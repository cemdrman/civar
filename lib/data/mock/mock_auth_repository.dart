import 'dart:async';

import '../../core/utils/id_generator.dart';
import '../../domain/models/app_user.dart';
import '../../domain/repositories/auth_repository.dart';

class MockAuthRepository implements AuthRepository {
  AppUser? _user;
  final _controller = StreamController<AppUser?>.broadcast();

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
    _user = user;
    _controller.add(user);
    return user;
  }

  @override
  Future<AppUser> signInWithGoogle({required String fullName, required String email}) async {
    final user = AppUser.fromFullName(
      id: generateId('user'),
      fullName: fullName,
      email: email,
    );
    _user = user;
    _controller.add(user);
    return user;
  }

  @override
  Future<AppUser> updateProfile({String? photoPath, String? bio}) async {
    final current = _user;
    if (current == null) {
      throw StateError('updateProfile called with no signed-in user.');
    }
    final updated = current.copyWith(photoPath: photoPath, bio: bio);
    _user = updated;
    _controller.add(updated);
    return updated;
  }

  @override
  Future<void> signOut() async {
    _user = null;
    _controller.add(null);
  }
}
