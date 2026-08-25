import '../../domain/models/membership_tier.dart';

/// Static tier catalog (radius/price/features) — app config, not user data,
/// so it isn't stored in Firestore. Used by both the mock and Firebase
/// membership repositories.
final membershipTierCatalog = <MembershipTier>[
  const MembershipTier(
    id: TierId.free,
    label: 'Keşifçi',
    radiusKm: 5,
    priceLabel: 'Ücretsiz',
    canSendNewDm: false,
    featureBullets: ['5 km çap', 'Gelen mesajlara yanıt'],
  ),
  const MembershipTier(
    id: TierId.gezgin,
    label: 'Gezgin',
    radiusKm: 20,
    priceLabel: '₺49/ay',
    canSendNewDm: true,
    featureBullets: ['20 km çap', 'Mesaj gönderme', 'Öncelikli destek'],
  ),
  const MembershipTier(
    id: TierId.maceraci,
    label: 'Maceracı',
    radiusKm: 50,
    priceLabel: '₺99/ay',
    canSendNewDm: true,
    featureBullets: ['50 km çap', 'Mesaj gönderme', 'Rozet'],
  ),
  MembershipTier(
    id: TierId.sinirsiz,
    label: 'Sınırsız',
    radiusKm: double.infinity,
    priceLabel: '₺179/ay',
    canSendNewDm: true,
    featureBullets: const ['Sınırsız çap', 'Mesaj gönderme', 'Rozet'],
  ),
];
