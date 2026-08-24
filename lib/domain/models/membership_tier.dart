enum TierId { free, gezgin, maceraci, sinirsiz }

class MembershipTier {
  final TierId id;
  final String label;

  /// double.infinity for the unlimited tier.
  final double radiusKm;
  final String priceLabel;
  final bool canSendNewDm;
  final List<String> featureBullets;

  const MembershipTier({
    required this.id,
    required this.label,
    required this.radiusKm,
    required this.priceLabel,
    required this.canSendNewDm,
    required this.featureBullets,
  });

  String get radiusLabel => radiusKm.isInfinite ? 'Sınırsız' : '${radiusKm.toInt()} km';
}
