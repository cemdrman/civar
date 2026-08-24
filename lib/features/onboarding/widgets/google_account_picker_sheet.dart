import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/widgets/avatar_initials.dart';

/// Stand-in for the native Google account picker. Returns the chosen
/// (fullName, email) pair, or null if dismissed without a choice.
Future<({String fullName, String email})?> showGoogleAccountPickerSheet(BuildContext context) {
  const accounts = [
    (fullName: 'Kaan Yıldız', email: 'kaan.yildiz@gmail.com'),
    (fullName: 'Kaan Y. (İş)', email: 'kaanyildiz.work@gmail.com'),
  ];

  return showModalBottomSheet<({String fullName, String email})>(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (sheetContext) => Container(
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
            const Text('Hesap seç', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
            const SizedBox(height: 4),
            const Text(
              'Civar ile devam etmek için bir Google hesabı seç.',
              style: TextStyle(fontSize: 12.5, color: AppColors.textSecondary),
            ),
            const SizedBox(height: 8),
            for (final account in accounts)
              InkWell(
                onTap: () => Navigator.of(sheetContext).pop(account),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                  decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(color: AppColors.border)),
                  ),
                  child: Row(
                    children: [
                      AvatarInitials(initials: account.fullName.substring(0, 1), colorSeed: 1),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(account.fullName, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                            Text(
                              account.email,
                              style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            TextButton(
              onPressed: () => Navigator.of(sheetContext).pop(),
              child: const Text('Vazgeç', style: TextStyle(color: AppColors.textSecondary)),
            ),
          ],
        ),
      ),
    ),
  );
}
