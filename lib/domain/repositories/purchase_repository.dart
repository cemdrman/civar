import '../models/membership_tier.dart';
import '../models/purchase_product.dart';

enum PurchaseStatus { success, cancelled, failed }

class PurchaseResult {
  final PurchaseStatus status;
  final String? errorMessage;

  const PurchaseResult(this.status, {this.errorMessage});
}

/// Modeled after Flutter's `in_app_purchase` package so a real StoreKit/Play
/// Billing implementation is a drop-in swap later (see repository_providers.dart).
/// The mock simulates the native purchase sheet's latency and the
/// first-purchase 50% discount, without contacting any real store.
abstract class PurchaseRepository {
  Stream<List<PurchaseProduct>> watchProducts();

  Future<PurchaseResult> purchase(TierId tierId);

  /// Apple/Google require every IAP-enabled app to offer this.
  Future<void> restorePurchases();
}
