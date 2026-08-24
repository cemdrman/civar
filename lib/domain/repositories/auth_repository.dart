import '../models/app_user.dart';

abstract class AuthRepository {
  Stream<AppUser?> authStateChanges();
  Future<AppUser?> currentUser();
  Future<AppUser> createAccount({required String fullName, required String email});

  /// Real implementation triggers the native Google OAuth flow and resolves
  /// with the account the user picked; the mock simulates the picker instead
  /// (see GoogleAccountPickerSheet) and passes its choice straight through.
  Future<AppUser> signInWithGoogle({required String fullName, required String email});

  Future<void> signOut();
}
