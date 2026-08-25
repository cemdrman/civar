class AppUser {
  final String id;
  final String fullName;
  final String email;
  final String initials;

  /// Local file path in this mock phase — becomes a Storage download URL
  /// once a real backend is wired up.
  final String? photoPath;
  final String bio;

  const AppUser({
    required this.id,
    required this.fullName,
    required this.email,
    required this.initials,
    this.photoPath,
    this.bio = '',
  });

  factory AppUser.fromFullName({
    required String id,
    required String fullName,
    required String email,
  }) {
    final parts = fullName.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    final initials = parts.isEmpty
        ? '?'
        : parts.length == 1
            ? parts[0].substring(0, 1).toUpperCase()
            : (parts.first.substring(0, 1) + parts.last.substring(0, 1)).toUpperCase();
    return AppUser(id: id, fullName: fullName, email: email, initials: initials);
  }

  AppUser copyWith({String? photoPath, String? bio}) => AppUser(
        id: id,
        fullName: fullName,
        email: email,
        initials: initials,
        photoPath: photoPath ?? this.photoPath,
        bio: bio ?? this.bio,
      );
}
