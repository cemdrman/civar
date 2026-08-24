import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/avatar_initials.dart';
import '../../../domain/models/dm_thread.dart';

class ThreadTile extends StatelessWidget {
  const ThreadTile({super.key, required this.thread, required this.onTap});

  final DmThread thread;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        child: Row(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                AvatarInitials(
                  initials: thread.participantInitials,
                  colorSeed: thread.avatarColorSeed,
                  size: 46,
                ),
                if (thread.unread)
                  Positioned(
                    top: -1,
                    right: -1,
                    child: Container(
                      width: 11,
                      height: 11,
                      decoration: BoxDecoration(
                        color: AppColors.accent,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.surface, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        thread.participantName,
                        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14.5),
                      ),
                      Text(
                        thread.lastMessageTimeLabel,
                        style: const TextStyle(fontSize: 11.5, color: AppColors.textFaint),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    thread.lastMessagePreview,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
