import '../models/app_user.dart';

abstract class AuthRepository {
  Stream<AppUser?> authStateChanges();
  Future<AppUser?> currentUser();
  Future<AppUser> createAccount({required String fullName, required String email});

  /// Real implementation triggers the native Google OAuth flow and resolves
  /// with the account the user picked; the mock simulates the picker instead
  /// (see GoogleAccountPickerSheet) and passes its choice straight through.
  Future<AppUser> signInWithGoogle({required String fullName, required String email});

  /// Updates the signed-in user's photo and/or bio. Pass null for a field to
  /// leave it unchanged.
  Future<AppUser> updateProfile({String? photoPath, String? bio});

  Future<void> signOut();
}
