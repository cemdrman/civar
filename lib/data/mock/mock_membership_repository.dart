import 'dart:async';

import '../../domain/models/membership_tier.dart';
import '../../domain/repositories/membership_repository.dart';
import 'seed/seed_tiers.dart';

class MockMembershipRepository implements MembershipRepository {
  MembershipTier _current = seedTiers.first;
  final _controller = StreamController<MembershipTier>.broadcast();

  @override
  List<MembershipTier> getTiers() => List.unmodifiable(seedTiers);

  @override
  Stream<MembershipTier> watchCurrentTier() async* {
    yield _current;
    yield* _controller.stream;
  }

  @override
  Future<void> switchTier(TierId id) async {
    _current = seedTiers.firstWhere((t) => t.id == id);
    _controller.add(_current);
  }
}
