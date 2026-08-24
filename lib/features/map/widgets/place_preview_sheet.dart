import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/widgets/pill_button.dart';
import '../../../domain/models/place.dart';

/// Bottom preview card shown when a map pin is tapped.
class PlacePreviewSheet extends StatelessWidget {
  const PlacePreviewSheet({
    super.key,
    required this.place,
    required this.distanceKm,
    required this.commentCount,
    required this.teaser,
    required this.onClose,
    required this.onViewDetail,
  });

  final Place place;
  final double distanceKm;
  final int commentCount;
  final String teaser;
  final VoidCallback onClose;
  final VoidCallback onViewDetail;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadii.card),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 24, offset: Offset(0, -6)),
        ],
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
                      place.name,
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 17),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${place.category} · ${distanceKm.toStringAsFixed(1)} km',
                      style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: onClose,
                child: Container(
                  width: 26,
                  height: 26,
                  decoration: const BoxDecoration(color: AppColors.surface2, shape: BoxShape.circle),
                  child: const Icon(Icons.close, size: 14, color: AppColors.textSecondary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(teaser, style: const TextStyle(fontSize: 14, height: 1.4)),
          const SizedBox(height: 12),
          PillButton(label: '$commentCount yorumu gör', onPressed: onViewDetail),
        ],
      ),
    );
  }
}
