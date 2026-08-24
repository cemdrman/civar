import '../models/membership_tier.dart';

abstract class MembershipRepository {
  List<MembershipTier> getTiers();
  Stream<MembershipTier> watchCurrentTier();

  /// Mock: instant flip, no real IAP call — payment is out of scope for this pass.
  Future<void> switchTier(TierId id);
}
