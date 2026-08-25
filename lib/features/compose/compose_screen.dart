import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../app_state/location_providers.dart';
import '../../app_state/repository_providers.dart';
import '../../core/constants/post_limits.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radii.dart';
import '../../core/utils/media_validation.dart';
import '../../core/widgets/app_toast.dart';
import '../../l10n/app_localizations.dart';
import 'widgets/media_picker_sheet.dart';

class ComposeScreen extends ConsumerStatefulWidget {
  const ComposeScreen({super.key});

  @override
  ConsumerState<ComposeScreen> createState() => _ComposeScreenState();
}

class _ComposeScreenState extends ConsumerState<ComposeScreen> {
  final _textController = TextEditingController();
  XFile? _attachedMedia;
  MediaKind? _attachedKind;
  bool _submitting = false;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _pickMedia() async {
    final kind = await showMediaPickerSheet(context);
    if (kind == null || !mounted) return;

    final picker = ImagePicker();
    final picked = kind == MediaKind.image
        ? await picker.pickImage(source: ImageSource.gallery)
        : await picker.pickVideo(source: ImageSource.gallery);
    if (picked == null || !mounted) return;

    final sizeBytes = await File(picked.path).length();
    final result = validateMediaFile(path: picked.path, sizeBytes: sizeBytes, kind: kind);
    if (!result.isValid) {
      if (mounted) showAppToast(context, result.errorMessage!);
      return;
    }

    setState(() {
      _attachedMedia = picked;
      _attachedKind = kind;
    });
  }

  void _clearMedia() {
    setState(() {
      _attachedMedia = null;
      _attachedKind = null;
    });
  }

  Future<void> _submit() async {
    final text = _textController.text.trim();
    if (text.isEmpty || text.length > postTextMaxLength || _submitting) return;
    setState(() => _submitting = true);

    final viewer = ref.read(simulatedLocationProvider);
    final place = ref.read(feedRepositoryProvider).nearestPlaceTo(viewer);
    await ref.read(feedRepositoryProvider).createPost(
          placeId: place.id,
          text: text,
          hasMedia: _attachedMedia != null,
        );

    if (mounted) {
      Navigator.of(context).pop();
      showAppToast(context, AppLocalizations.of(context)!.commentPosted);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final viewer = ref.watch(simulatedLocationProvider);
    final nearestPlace = ref.watch(feedRepositoryProvider).nearestPlaceTo(viewer);

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: AppColors.border)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(l10n.cancel, style: const TextStyle(color: AppColors.textSecondary)),
                  ),
                  Text(l10n.newCommentTitle, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
                  TextButton(
                    onPressed: _submitting ? null : _submit,
                    child: Text(
                      l10n.shareAction,
                      style: const TextStyle(color: AppColors.accent, fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.accent2Soft,
                        borderRadius: BorderRadius.circular(AppRadii.pill),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration:
                                const BoxDecoration(color: AppColors.accent2, shape: BoxShape.circle),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            l10n.currentlyAt(nearestPlace.name),
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppColors.accent2,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    Expanded(
                      child: TextField(
                        controller: _textController,
                        maxLines: null,
                        expands: true,
                        maxLength: postTextMaxLength,
                        textAlignVertical: TextAlignVertical.top,
                        style: const TextStyle(fontSize: 16, height: 1.5),
                        decoration: InputDecoration(
                          hintText: l10n.composeHint,
                          border: InputBorder.none,
                          filled: false,
                          contentPadding: EdgeInsets.zero,
                        ),
                        buildCounter: (context, {required currentLength, required isFocused, maxLength}) => Text(
                          '$currentLength/$maxLength',
                          style: TextStyle(
                            fontSize: 11.5,
                            color: currentLength >= (maxLength ?? postTextMaxLength)
                                ? AppColors.accentDark
                                : AppColors.textFaint,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    GestureDetector(
                      onTap: _attachedMedia == null ? _pickMedia : null,
                      child: Container(
                        height: 110,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppColors.border, width: 1.5),
                        ),
                        child: _attachedMedia == null
                            ? Center(
                                child: Text(
                                  l10n.addPhotoVideo,
                                  style: const TextStyle(
                                    fontFamily: 'monospace',
                                    fontSize: 13,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              )
                            : Stack(
                                fit: StackFit.expand,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12.5),
                                    child: _attachedKind == MediaKind.image
                                        ? Image.file(File(_attachedMedia!.path), fit: BoxFit.cover)
                                        : Container(
                                            color: AppColors.surface2,
                                            alignment: Alignment.center,
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const Icon(Icons.play_circle_outline,
                                                    size: 28, color: AppColors.textSecondary),
                                                const SizedBox(height: 4),
                                                Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                                  child: Text(
                                                    _attachedMedia!.name,
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: const TextStyle(
                                                      fontSize: 11.5,
                                                      color: AppColors.textSecondary,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                  ),
                                  Positioned(
                                    top: 6,
                                    right: 6,
                                    child: GestureDetector(
                                      onTap: _clearMedia,
                                      child: Container(
                                        width: 24,
                                        height: 24,
                                        decoration: BoxDecoration(
                                          color: Colors.black.withValues(alpha: 0.55),
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(Icons.close, size: 14, color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
