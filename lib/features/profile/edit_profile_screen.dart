import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../app_state/auth_providers.dart';
import '../../app_state/repository_providers.dart';
import '../../core/constants/profile_limits.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/link_validation.dart';
import '../../core/widgets/app_toast.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  late final TextEditingController _bioController;
  String? _photoUrl;
  bool _uploadingPhoto = false;
  bool _saving = false;
  bool _initialized = false;

  @override
  void dispose() {
    if (_initialized) _bioController.dispose();
    super.dispose();
  }

  bool get _bioHasLink => containsLink(_bioController.text);
  bool get _canSave => !_bioHasLink && !_saving && !_uploadingPhoto;

  Future<void> _pickPhoto(String uid) async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 85);
    if (picked == null) return;

    setState(() => _uploadingPhoto = true);
    try {
      final storageRef =
          FirebaseStorage.instance.ref('profile_photos/$uid/${DateTime.now().millisecondsSinceEpoch}.jpg');
      await storageRef.putFile(File(picked.path));
      final url = await storageRef.getDownloadURL();
      if (!mounted) return;
      setState(() {
        _photoUrl = url;
        _uploadingPhoto = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _uploadingPhoto = false);
      showAppToast(context, 'Fotoğraf yüklenemedi, tekrar dene.');
    }
  }

  Future<void> _save() async {
    if (!_canSave) return;
    setState(() => _saving = true);
    await ref.read(authRepositoryProvider).updateProfile(
          photoPath: _photoUrl,
          bio: _bioController.text.trim(),
        );
    if (!mounted) return;
    Navigator.of(context).pop();
    showAppToast(context, 'Profilin güncellendi.');
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider).value;

    if (!_initialized && user != null) {
      _bioController = TextEditingController(text: user.bio);
      _photoUrl = user.photoPath;
      _initialized = true;
    }
    if (!_initialized) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profili düzenle'),
        actions: [
          TextButton(
            onPressed: _canSave ? _save : null,
            child: Text(
              _saving ? '...' : 'Kaydet',
              style: TextStyle(
                color: _canSave ? AppColors.accent : AppColors.textFaint,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          Center(
            child: GestureDetector(
              onTap: _uploadingPhoto ? null : () => _pickPhoto(user!.id),
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 44,
                    backgroundColor: AppColors.accent,
                    backgroundImage: _photoUrl != null ? NetworkImage(_photoUrl!) : null,
                    child: _photoUrl == null
                        ? Text(
                            user!.initials,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 28,
                            ),
                          )
                        : null,
                  ),
                  if (_uploadingPhoto)
                    const Positioned.fill(
                      child: CircleAvatar(
                        radius: 44,
                        backgroundColor: Colors.black45,
                        child: SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        ),
                      ),
                    ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: AppColors.text,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.surface, width: 2),
                      ),
                      child: const Icon(Icons.camera_alt_outlined, size: 14, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: TextButton(
              onPressed: _uploadingPhoto ? null : () => _pickPhoto(user!.id),
              child: const Text('Profil fotoğrafını değiştir'),
            ),
          ),
          const SizedBox(height: 18),
          const Text('Biyografi', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
          const SizedBox(height: 8),
          TextField(
            controller: _bioController,
            maxLength: bioMaxLength,
            maxLines: 3,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              hintText: 'Kendinden kısaca bahset...',
              errorText: _bioHasLink ? 'Biyografide bağlantı paylaşamazsın.' : null,
            ),
          ),
        ],
      ),
    );
  }
}
