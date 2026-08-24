import 'dart:async';

import '../../domain/models/membership_tier.dart';
import '../../domain/models/purchase_product.dart';
import '../../domain/repositories/purchase_repository.dart';
import 'seed/seed_purchase_products.dart';

class MockPurchaseRepository implements PurchaseRepository {
  bool _hasEverPurchased = false;
  final _controller = StreamController<List<PurchaseProduct>>.broadcast();

  List<PurchaseProduct> _buildProducts() => basePricesTry.entries
      .map((entry) => PurchaseProduct(
            tierId: entry.key,
            storeProductId: storeProductIds[entry.key]!,
            priceTry: entry.value,
            discountedPriceTry: _hasEverPurchased ? null : (entry.value * 0.5).round().toDouble(),
          ))
      .toList();

  @override
  Stream<List<PurchaseProduct>> watchProducts() async* {
    yield _buildProducts();
    yield* _controller.stream;
  }

  @override
  Future<PurchaseResult> purchase(TierId tierId) async {
    if (!basePricesTry.containsKey(tierId)) {
      return const PurchaseResult(PurchaseStatus.failed, errorMessage: 'Bu plan satın alınamaz.');
    }
    // Simulates the native purchase-sheet round trip (StoreKit/Play Billing).
    await Future.delayed(const Duration(milliseconds: 1200));
    _hasEverPurchased = true;
    _controller.add(_buildProducts());
    return const PurchaseResult(PurchaseStatus.success);
  }

  @override
  Future<void> restorePurchases() async {
    await Future.delayed(const Duration(milliseconds: 600));
    // Nothing to restore in the mock — a real store lookup happens here.
  }
}
