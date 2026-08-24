import 'membership_tier.dart';

/// A purchasable subscription product, modeled after what a real store
/// (App Store/Play Store via `in_app_purchase`) would return: a stable
/// product id, a base price, and — while the first-purchase promo is
/// active — a discounted price alongside it.
class PurchaseProduct {
  final TierId tierId;
  final String storeProductId;
  final double priceTry;
  final double? discountedPriceTry;

  const PurchaseProduct({
    required this.tierId,
    required this.storeProductId,
    required this.priceTry,
    this.discountedPriceTry,
  });

  bool get hasDiscount => discountedPriceTry != null;

  String get priceLabel => _formatTry(priceTry);
  String? get discountedPriceLabel =>
      discountedPriceTry == null ? null : _formatTry(discountedPriceTry!);

  static String _formatTry(double amount) => '₺${amount.toStringAsFixed(0)}/ay';
}
