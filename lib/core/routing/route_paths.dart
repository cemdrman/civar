class RoutePaths {
  RoutePaths._();

  static const onboarding = '/onboarding';
  static const map = '/map';
  static const feed = '/feed';
  static const dm = '/dm';
  static const profile = '/profile';
  static const compose = '/compose';
  static const paywall = '/paywall';
  static const editProfile = '/profile/edit';

  static String placeDetail(String placeId) => '/place/$placeId';
  static String dmThread(String threadId) => '/dm-thread/$threadId';
}
