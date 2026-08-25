import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app_state/membership_providers.dart';
import '../../app_state/purchase_providers.dart';
import '../../app_state/repository_providers.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radii.dart';
import '../../core/widgets/app_toast.dart';
import '../../domain/models/membership_tier.dart';
import '../../domain/repositories/purchase_repository.dart';
import '../../l10n/app_localizations.dart';
import 'widgets/tier_card.dart';

class PaywallScreen extends ConsumerStatefulWidget {
  const PaywallScreen({super.key});

  @override
  ConsumerState<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends ConsumerState<PaywallScreen> {
  TierId? _purchasingTierId;
  bool _restoring = false;

  Future<void> _selectTier(MembershipTier tier) async {
    final l10n = AppLocalizations.of(context)!;
    if (tier.id == TierId.free) {
      await ref.read(membershipRepositoryProvider).switchTier(tier.id);
      if (mounted) showAppToast(context, l10n.planDowngraded(tier.label));
      return;
    }

    setState(() => _purchasingTierId = tier.id);
    final result = await ref.read(purchaseRepositoryProvider).purchase(tier.id);
    if (result.status == PurchaseStatus.success) {
      await ref.read(membershipRepositoryProvider).switchTier(tier.id);
    }
    if (!mounted) return;
    setState(() => _purchasingTierId = null);
    showAppToast(
      context,
      result.status == PurchaseStatus.success
          ? l10n.planUpgraded(tier.label)
          : result.errorMessage ?? l10n.purchaseNotCompleted,
    );
  }

  Future<void> _restorePurchases() async {
    setState(() => _restoring = true);
    await ref.read(purchaseRepositoryProvider).restorePurchases();
    if (!mounted) return;
    setState(() => _restoring = false);
    showAppToast(context, AppLocalizations.of(context)!.noPurchasesToRestore);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final tiers = ref.watch(tiersProvider);
    final currentTier = ref.watch(currentTierProvider).value;
    final products = ref.watch(purchaseProductsStreamProvider).value ?? const [];
    final discountActive = products.any((p) => p.hasDiscount);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.expandYourRadius)),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          Text(
            l10n.paywallExplainer,
            style: const TextStyle(fontSize: 13.5, color: Colors.black54, height: 1.5),
          ),
          if (discountActive) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.accentSoft,
                borderRadius: BorderRadius.circular(AppRadii.card - 4),
              ),
              child: Text(
                l10n.firstMonthDiscountBanner,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.accentDark,
                ),
              ),
            ),
          ],
          const SizedBox(height: 12),
          for (final tier in tiers)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: TierCard(
                tier: tier,
                isCurrent: tier.id == currentTier?.id,
                product: products.where((p) => p.tierId == tier.id).firstOrNull,
                isPurchasing: _purchasingTierId == tier.id,
                onSelect: () => _selectTier(tier),
              ),
            ),
          Center(
            child: TextButton(
              onPressed: _restoring ? null : _restorePurchases,
              child: Text(
                _restoring ? l10n.checkingEllipsis : l10n.restorePurchases,
                style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
