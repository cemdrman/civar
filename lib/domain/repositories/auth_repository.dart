import '../models/app_user.dart';

abstract class AuthRepository {
  Stream<AppUser?> authStateChanges();
  Future<AppUser?> currentUser();
  Future<AppUser> createAccount({required String fullName, required String email});

  /// Looks up an existing account by email and signs into it if one is
  /// registered — returns null (no side effect) when there isn't, so the
  /// caller can fall back to account creation instead.
  Future<AppUser?> signInIfAccountExists({required String email});

  /// Real implementation triggers the native Google OAuth flow and resolves
  /// with the account the user picked; the mock simulates the picker instead
  /// (see GoogleAccountPickerSheet) and passes its choice straight through.
  /// If that Google account already has a Civar account, signs into the
  /// existing one instead of creating a new one.
  Future<AppUser> signInWithGoogle({required String fullName, required String email});

  /// Updates the signed-in user's photo and/or bio. Pass null for a field to
  /// leave it unchanged.
  Future<AppUser> updateProfile({String? photoPath, String? bio});

  Future<void> signOut();
}
