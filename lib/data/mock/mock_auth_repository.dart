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
  Future<void> signOut() async {
    _user = null;
    _controller.add(null);
  }
}
