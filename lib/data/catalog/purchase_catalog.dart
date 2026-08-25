import '../../domain/models/membership_tier.dart';

/// Base (non-discounted) monthly prices, matching membership_tiers.dart's
/// priceLabel values. TierId.free is intentionally absent — it isn't a
/// purchasable product.
const basePricesTry = <TierId, double>{
  TierId.gezgin: 49,
  TierId.maceraci: 99,
  TierId.sinirsiz: 179,
};

const storeProductIds = <TierId, String>{
  TierId.gezgin: 'civar.tier.gezgin.monthly',
  TierId.maceraci: 'civar.tier.maceraci.monthly',
  TierId.sinirsiz: 'civar.tier.sinirsiz.monthly',
};
