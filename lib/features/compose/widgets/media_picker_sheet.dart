import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/utils/media_validation.dart';

/// Lets the user choose photo vs video before opening the OS picker, since
/// image_picker exposes them as two separate calls (pickImage/pickVideo).
Future<MediaKind?> showMediaPickerSheet(BuildContext context) {
  return showModalBottomSheet<MediaKind>(
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
            const Text('Ne eklemek istersin?', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
            const SizedBox(height: 8),
            _OptionRow(
              icon: Icons.image_outlined,
              label: 'Fotoğraf seç',
              sublabel: 'jpg, png, webp, heic · maks. 10MB',
              onTap: () => Navigator.of(sheetContext).pop(MediaKind.image),
            ),
            _OptionRow(
              icon: Icons.videocam_outlined,
              label: 'Video seç',
              sublabel: 'mp4, mov · maks. 50MB',
              onTap: () => Navigator.of(sheetContext).pop(MediaKind.video),
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

class _OptionRow extends StatelessWidget {
  const _OptionRow({
    required this.icon,
    required this.label,
    required this.sublabel,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String sublabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.border)),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: AppColors.textSecondary),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                Text(sublabel, style: const TextStyle(fontSize: 11.5, color: AppColors.textFaint)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
