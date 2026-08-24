import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/models/membership_tier.dart';
import 'repository_providers.dart';

final tiersProvider = Provider<List<MembershipTier>>(
  (ref) => ref.watch(membershipRepositoryProvider).getTiers(),
);

/// Current membership tier — determines active radius + DM permissions.
final currentTierProvider = StreamProvider<MembershipTier>(
  (ref) => ref.watch(membershipRepositoryProvider).watchCurrentTier(),
);
