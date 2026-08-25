import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app_state/repository_providers.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radii.dart';
import '../../core/widgets/app_toast.dart';
import '../../domain/models/report_reason.dart';
import '../../l10n/app_localizations.dart';

/// Bottom sheet with the 5 report reasons; submitting reports the post and
/// shows a confirmation toast.
Future<void> showReportSheet(BuildContext context, WidgetRef ref, String postId) {
  return showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) => _ReportSheetContent(
      onSelect: (reason) async {
        Navigator.of(sheetContext).pop();
        await ref.read(feedRepositoryProvider).reportPost(postId: postId, reason: reason);
        if (context.mounted) {
          showAppToast(context, AppLocalizations.of(context)!.reportThanks);
        }
      },
    ),
  );
}

class _ReportSheetContent extends StatelessWidget {
  const _ReportSheetContent({required this.onSelect});

  final ValueChanged<ReportReason> onSelect;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 28),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadii.sheet)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 36,
                height: 4,
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Text(
              l10n.reportThisComment,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
            ),
            const SizedBox(height: 8),
            for (final reason in ReportReason.values)
              InkWell(
                onTap: () => onSelect(reason),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
                  decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(color: AppColors.border)),
                  ),
                  child: Text(reason.label, style: const TextStyle(fontSize: 14.5)),
                ),
              ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.cancel, style: const TextStyle(color: AppColors.textSecondary)),
            ),
          ],
        ),
      ),
    );
  }
}
