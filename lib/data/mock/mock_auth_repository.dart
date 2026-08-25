import 'dart:async';

import '../../core/utils/id_generator.dart';
import '../../domain/models/app_user.dart';
import '../../domain/repositories/auth_repository.dart';

class MockAuthRepository implements AuthRepository {
  AppUser? _user;

  /// Stand-in for a real backend's user table, keyed by lowercase email —
  /// lets a returning user (email or Google) sign back into their existing
  /// account (with their saved bio/photo) instead of getting a fresh one.
  final Map<String, AppUser> _registeredAccounts = {};

  final _controller = StreamController<AppUser?>.broadcast();

  void _signIn(AppUser user) {
    _user = user;
    _registeredAccounts[user.email.toLowerCase()] = user;
    _controller.add(user);
  }

  @override
  Stream<AppUser?> authStateChanges() => _controller.stream;

  @override
  Future<AppUser?> currentUser() async => _user;

  @override
  Future<AppUser> createAccount({required String fullName, required String email}) async {
    final user = AppUser.fromFullName(
      id: generateId('user'),
      fullName: fullName,
      email: email,
    );
    _signIn(user);
    return user;
  }

  @override
  Future<AppUser?> signInIfAccountExists({required String email}) async {
    final existing = _registeredAccounts[email.toLowerCase()];
    if (existing == null) return null;
    _signIn(existing);
    return existing;
  }

  @override
  Future<AppUser> signInWithGoogle({required String fullName, required String email}) async {
    final existing = _registeredAccounts[email.toLowerCase()];
    if (existing != null) {
      _signIn(existing);
      return existing;
    }
    final user = AppUser.fromFullName(
      id: generateId('user'),
      fullName: fullName,
      email: email,
    );
    _signIn(user);
    return user;
  }

  @override
  Future<AppUser> updateProfile({String? photoPath, String? bio}) async {
    final current = _user;
    if (current == null) {
      throw StateError('updateProfile called with no signed-in user.');
    }
    final updated = current.copyWith(photoPath: photoPath, bio: bio);
    _signIn(updated);
    return updated;
  }

  @override
  Future<void> signOut() async {
    _user = null;
    _controller.add(null);
  }
}
