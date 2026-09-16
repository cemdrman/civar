import '../models/app_user.dart';

enum SignInFailureReason { invalidCredentials, other }

class SignInResult {
  final AppUser? user;
  final SignInFailureReason? failureReason;

  const SignInResult.success(AppUser this.user) : failureReason = null;
  const SignInResult.failure(SignInFailureReason reason) : user = null, failureReason = reason;

  bool get isSuccess => user != null;
}

abstract class AuthRepository {
  Stream<AppUser?> authStateChanges();
  Future<AppUser?> currentUser();

  /// Registers a brand-new account. Throws if the email is already taken.
  Future<AppUser> createAccount({
    required String fullName,
    required String email,
    required String password,
  });

  /// Attempts to sign in with email/password. Firebase's modern security
  /// model (email-enumeration protection, on by default for new projects)
  /// means a failed attempt can't distinguish "no account" from "wrong
  /// password" — both come back as SignInFailureReason.invalidCredentials.
  /// The caller should offer "create an account instead" on failure rather
  /// than pre-checking whether the email is registered.
  Future<SignInResult> signInWithEmail({required String email, required String password});

  /// Triggers the native Google OAuth flow; the account picked (name,
  /// email, etc.) comes from Google itself. If that Google account already
  /// has a Civar account, signs into the existing one instead of creating a
  /// new one.
  Future<AppUser> signInWithGoogle();

  /// Updates the signed-in user's photo and/or bio. Pass null for a field to
  /// leave it unchanged.
  Future<AppUser> updateProfile({String? photoPath, String? bio});

  Future<void> signOut();

  /// Blocks [userId]: prevents them from starting a new DM thread or sending
  /// further messages to the signed-in user (see FirebaseMessagingRepository
  /// for the enforcement point). Does not affect posts/comments — only DMs.
  Future<void> blockUser(String userId);

  Future<void> unblockUser(String userId);

  /// The signed-in user's blocked list, resolved to full profiles.
  Stream<List<AppUser>> watchBlockedUsers();

  /// Soft-deletes the signed-in user's account: marks it inactive and signs
  /// out, without touching any of their existing data (posts, DM threads,
  /// etc. all remain untouched — this is a deactivation, not a real delete).
  Future<void> deactivateAccount();
}
