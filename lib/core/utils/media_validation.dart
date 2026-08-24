enum MediaKind { image, video }

class MediaLimits {
  MediaLimits._();

  static const maxImageBytes = 10 * 1024 * 1024; // 10 MB
  static const maxVideoBytes = 50 * 1024 * 1024; // 50 MB
  static const allowedImageExtensions = {'jpg', 'jpeg', 'png', 'webp', 'heic'};
  static const allowedVideoExtensions = {'mp4', 'mov'};
}

class MediaValidationResult {
  final bool isValid;
  final String? errorMessage;

  const MediaValidationResult.valid()
      : isValid = true,
        errorMessage = null;

  const MediaValidationResult.invalid(String message)
      : isValid = false,
        errorMessage = message;
}

/// Checks a picked file's extension and size against [MediaLimits] before
/// it's attached to a post. Takes plain path/size rather than an XFile so
/// this stays independent of the image_picker plugin.
MediaValidationResult validateMediaFile({
  required String path,
  required int sizeBytes,
  required MediaKind kind,
}) {
  final ext = path.contains('.') ? path.split('.').last.toLowerCase() : '';
  final allowedExtensions =
      kind == MediaKind.image ? MediaLimits.allowedImageExtensions : MediaLimits.allowedVideoExtensions;

  if (!allowedExtensions.contains(ext)) {
    final formats = allowedExtensions.join(', ');
    return MediaValidationResult.invalid('Desteklenmeyen dosya formatı. Kullanabileceğin formatlar: $formats.');
  }

  final maxBytes = kind == MediaKind.image ? MediaLimits.maxImageBytes : MediaLimits.maxVideoBytes;
  if (sizeBytes > maxBytes) {
    final maxMb = (maxBytes / (1024 * 1024)).round();
    return MediaValidationResult.invalid('Dosya çok büyük. En fazla ${maxMb}MB olabilir.');
  }

  return const MediaValidationResult.valid();
}
