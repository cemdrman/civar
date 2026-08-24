import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/models/app_user.dart';
import 'repository_providers.dart';

/// Drives the router's redirect (onboarding vs main shell).
final currentUserProvider = StreamProvider<AppUser?>((ref) async* {
  final repo = ref.watch(authRepositoryProvider);
  yield await repo.currentUser();
  yield* repo.authStateChanges();
});
