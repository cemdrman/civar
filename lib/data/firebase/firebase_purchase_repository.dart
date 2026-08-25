import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:flutter/foundation.dart';

import '../../core/utils/id_generator.dart';
import '../../domain/models/membership_tier.dart';
import '../../domain/models/purchase_product.dart';
import '../../domain/repositories/purchase_repository.dart';
import '../catalog/purchase_catalog.dart';

/// Stores purchase *receipts* (who bought what, when, for how much) — never
/// raw card/payment credentials, which stay with Apple/Google and are never
/// our database's concern. See firestore.rules for the immutable-once-
/// written access rule.
class FirebasePurchaseRepository implements PurchaseRepository {
  FirebasePurchaseRepository({FirebaseFirestore? firestore, fb_auth.FirebaseAuth? auth})
      : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? fb_auth.FirebaseAuth.instance;

  final FirebaseFirestore _firestore;
  final fb_auth.FirebaseAuth _auth;

  CollectionReference<Map<String, dynamic>> get _purchasesRef => _firestore.collection('purchases');

  List<PurchaseProduct> _buildProducts({required bool hasEverPurchased}) => basePricesTry.entries
      .map((entry) => PurchaseProduct(
            tierId: entry.key,
            storeProductId: storeProductIds[entry.key]!,
            priceTry: entry.value,
            discountedPriceTry: hasEverPurchased ? null : (entry.value * 0.5).round().toDouble(),
          ))
      .toList();

  Future<bool> _hasEverPurchased(String uid) async {
    final snap = await _purchasesRef.where('userId', isEqualTo: uid).limit(1).get();
    return snap.docs.isNotEmpty;
  }

  @override
  Stream<List<PurchaseProduct>> watchProducts() {
    return _auth.authStateChanges().asyncExpand((fbUser) {
      if (fbUser == null) return Stream.value(_buildProducts(hasEverPurchased: false));
      return _purchasesRef
          .where('userId', isEqualTo: fbUser.uid)
          .limit(1)
          .snapshots()
          .map((snap) => _buildProducts(hasEverPurchased: snap.docs.isNotEmpty));
    });
  }

  String _currentPlatformName() {
    if (kIsWeb) return 'web';
    return defaultTargetPlatform.name;
  }

  @override
  Future<PurchaseResult> purchase(TierId tierId) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) {
      return const PurchaseResult(PurchaseStatus.failed, errorMessage: 'Önce giriş yapmalısın.');
    }
    if (!basePricesTry.containsKey(tierId)) {
      return const PurchaseResult(PurchaseStatus.failed, errorMessage: 'Bu plan satın alınamaz.');
    }

    // Simulates the native purchase-sheet round trip (StoreKit/Play Billing) —
    // payment itself is still client-simulated (see class doc comment).
    await Future.delayed(const Duration(milliseconds: 1200));

    final discountApplied = !(await _hasEverPurchased(uid));
    final basePrice = basePricesTry[tierId]!;
    final pricePaid = discountApplied ? (basePrice * 0.5).round().toDouble() : basePrice;

    await _purchasesRef.doc(generateId('purchase')).set({
      'userId': uid,
      'tierId': tierId.name,
      'storeProductId': storeProductIds[tierId],
      'basePriceTry': basePrice,
      'priceTry': pricePaid,
      'discountApplied': discountApplied,
      'currency': 'TRY',
      'platform': _currentPlatformName(),
      'purchasedAt': FieldValue.serverTimestamp(),
    });

    return const PurchaseResult(PurchaseStatus.success);
  }

  @override
  Future<void> restorePurchases() async {
    // Purchase records in Firestore are already the source of truth for
    // entitlement in this client-simulated-payment phase — there's no
    // separate store ledger to reconcile against yet. Kept as a real async
    // step (not a bare no-op) so the UX timing matches a real store restore.
    await Future.delayed(const Duration(milliseconds: 600));
  }
}
