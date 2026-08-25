import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/widgets/pill_button.dart';
import '../../../domain/models/membership_tier.dart';
import '../../../domain/models/purchase_product.dart';
import '../../../l10n/app_localizations.dart';

class TierCard extends StatelessWidget {
  const TierCard({
    super.key,
    required this.tier,
    required this.isCurrent,
    required this.onSelect,
    this.product,
    this.isPurchasing = false,
  });

  final MembershipTier tier;
  final bool isCurrent;
  final VoidCallback onSelect;

  /// Live pricing/discount info for this tier, when it's a purchasable
  /// (non-free) product. Null for the free tier.
  final PurchaseProduct? product;
  final bool isPurchasing;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final dark = isCurrent;
    final fg = dark ? Colors.white : AppColors.text;
    final fgMuted = dark ? Colors.white70 : AppColors.textSecondary;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: dark ? AppColors.text : AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadii.card),
        border: Border.all(color: dark ? Colors.transparent : AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tier.label,
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 17, color: fg),
                    ),
                    const SizedBox(height: 2),
                    Text(l10n.radiusSuffix(tier.radiusLabel), style: TextStyle(fontSize: 13, color: fgMuted)),
                  ],
                ),
              ),
              _PriceLabel(tier: tier, product: product, fg: fg, fgMuted: fgMuted),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            tier.featureBullets.join(' · '),
            style: TextStyle(fontSize: 12.5, color: fgMuted, height: 1.5),
          ),
          if (product?.hasDiscount ?? false) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
              decoration: BoxDecoration(
                color: dark ? Colors.white.withValues(alpha: 0.15) : AppColors.accentSoft,
                borderRadius: BorderRadius.circular(AppRadii.pill),
              ),
              child: Text(
                l10n.firstMonthDiscountTag,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: dark ? Colors.white : AppColors.accentDark,
                ),
              ),
            ),
          ],
          const SizedBox(height: 12),
          if (isCurrent)
            Container(
              width: double.infinity,
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(AppRadii.pill),
              ),
              child: Text(
                l10n.currentPlanBadge,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13),
              ),
            )
          else
            PillButton(
              label: isPurchasing ? l10n.purchasing : l10n.switchToThisPlan,
              onPressed: isPurchasing ? null : onSelect,
            ),
        ],
      ),
    );
  }
}

class _PriceLabel extends StatelessWidget {
  const _PriceLabel({required this.tier, required this.product, required this.fg, required this.fgMuted});

  final MembershipTier tier;
  final PurchaseProduct? product;
  final Color fg;
  final Color fgMuted;

  @override
  Widget build(BuildContext context) {
    if (product == null || !product!.hasDiscount) {
      return Text(
        product?.priceLabel ?? tier.priceLabel,
        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: fg),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          product!.priceLabel,
          style: TextStyle(
            fontSize: 12,
            color: fgMuted,
            decoration: TextDecoration.lineThrough,
          ),
        ),
        Text(
          product!.discountedPriceLabel!,
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15, color: fg),
        ),
      ],
    );
  }
}
