// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get genericErrorRetry => 'Something went wrong, try again.';

  @override
  String streamError(Object error) {
    return 'Something went wrong: $error';
  }

  @override
  String get commentPosted => 'Your comment was posted to the venue.';

  @override
  String get unlimitedRadius => 'Unlimited';

  @override
  String radiusSuffix(String radius) {
    return '$radius radius';
  }

  @override
  String get exploreLabel => 'Explore';

  @override
  String get mapLabel => 'Map';

  @override
  String get messagesLabel => 'Messages';

  @override
  String get profileLabel => 'Profile';

  @override
  String get editProfile => 'Edit profile';

  @override
  String get onboardingTagline =>
      'What\'s really happening around you? See and join comments, only where you are.';

  @override
  String get onboardingStart => 'Start';

  @override
  String get authAccessAccountTitle => 'Access your account';

  @override
  String get continueWithGoogle => 'Continue with Google';

  @override
  String get googleSignInFailed => 'Couldn\'t sign in with Google, try again.';

  @override
  String get createAccountTitle => 'Create account';

  @override
  String get createAccountSubtitle =>
      'Add your info below and we\'ll get your account set up in seconds.';

  @override
  String get signInSubtitle =>
      'Sign in if you already have an account, or create a new one below.';

  @override
  String get fullNameHint => 'Full name';

  @override
  String get emailHint => 'Email';

  @override
  String get passwordHint => 'Password (at least 6 characters)';

  @override
  String get invalidCredentialsError =>
      'Wrong email or password, or you don\'t have an account.';

  @override
  String get accountCreationFailed =>
      'Couldn\'t create account. The email might already be registered.';

  @override
  String get createAccountAndEnter => 'Create account and enter';

  @override
  String get signingIn => 'Signing in...';

  @override
  String get signIn => 'Sign in';

  @override
  String get noAccountCreateOne =>
      'I don\'t have an account, I want to create one';

  @override
  String get locationPermissionIllustrationLabel =>
      'LOCATION PERMISSION ILLUSTRATION';

  @override
  String get locationNeededTitle => 'We need your location';

  @override
  String locationPermissionExplainer(String radius) {
    return 'Civar only shows comments within a $radius radius. You can only increase this radius with a monthly membership.';
  }

  @override
  String get allowLocationAccess => 'Allow my location';

  @override
  String get notNow => 'Not now';

  @override
  String get noCommentsInRadius => 'No comments in this radius yet.';

  @override
  String get feedSubtitle => 'Recent comments around you';

  @override
  String get mapPlaceholderLabel => 'MAP VIEW · density layer';

  @override
  String get noCommentsYetWriteFirst =>
      'No comments yet, be the first to write one.';

  @override
  String viewCommentsCount(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'View $countString comments',
      one: 'View $countString comment',
    );
    return '$_temp0';
  }

  @override
  String get newCommentTitle => 'New comment';

  @override
  String get shareAction => 'Share';

  @override
  String currentlyAt(String place) {
    return 'Now at: $place';
  }

  @override
  String get composeHint =>
      'What\'s happening here? Pin your thought to this place...';

  @override
  String get addPhotoVideo => '+ ADD PHOTO / VIDEO';

  @override
  String get photoVideoLabel => 'PHOTO / VIDEO';

  @override
  String get whatToAddTitle => 'What do you want to add?';

  @override
  String get choosePhoto => 'Choose photo';

  @override
  String get choosePhotoHint => 'jpg, png, webp, heic · max. 10MB';

  @override
  String get chooseVideo => 'Choose video';

  @override
  String get chooseVideoHint => 'mp4, mov · max. 50MB';

  @override
  String get placePhotoLabel => 'VENUE PHOTO';

  @override
  String placeDetailMeta(String category, String distance, int count) {
    return '$category · $distance km · $count comments';
  }

  @override
  String get writeCommentHint => 'Write a comment for this place...';

  @override
  String get replyLockedMessage =>
      'You need to be close to this place to reply';

  @override
  String get reportThanks => 'Thanks for reporting, our team will review it.';

  @override
  String get reportThisComment => 'Report this comment';

  @override
  String currentPlanLabel(String tier) {
    return '$tier plan';
  }

  @override
  String get addBio => 'Add a bio';

  @override
  String get statComments => 'Comments';

  @override
  String get statLikes => 'Likes';

  @override
  String get statPlaces => 'Places';

  @override
  String activeRadiusLabel(String radius) {
    return '$radius radius active';
  }

  @override
  String get managePlanSubtitle => 'Manage or upgrade your plan';

  @override
  String get yourCommentsTitle => 'Your comments';

  @override
  String get notifications => 'Notifications';

  @override
  String get privacy => 'Privacy';

  @override
  String get blockedUsers => 'Blocked';

  @override
  String get signOut => 'Sign out';

  @override
  String get languageSettingsLabel => 'Language';

  @override
  String get languagePickerTitle => 'Choose language';

  @override
  String get devChangeLocation => 'Dev: Change location';

  @override
  String get photoUploadFailed => 'Couldn\'t upload photo, try again.';

  @override
  String get profileUpdated => 'Your profile was updated.';

  @override
  String get changeProfilePhoto => 'Change profile photo';

  @override
  String get bioLabel => 'Bio';

  @override
  String get bioHint => 'Tell us a bit about yourself...';

  @override
  String get bioLinkNotAllowed => 'You can\'t share a link in your bio.';

  @override
  String get whoToMessageTitle => 'Who do you want to talk to?';

  @override
  String get newMessage => 'New message';

  @override
  String get freeTierDmLockedMessage =>
      'Free members can\'t start new chats, but can reply to incoming messages.';

  @override
  String get writeMessageHint => 'Write a message...';

  @override
  String get expandYourRadius => 'Expand your radius';

  @override
  String get paywallExplainer =>
      'Upgrade to see and reply to comments in a wider radius, and to message people.';

  @override
  String get firstMonthDiscountBanner =>
      '🎉 Special for your first membership: 50% off all plans for the first month!';

  @override
  String get checkingEllipsis => 'Checking...';

  @override
  String get restorePurchases => 'Restore purchases';

  @override
  String planDowngraded(String tier) {
    return 'Your plan was downgraded to $tier.';
  }

  @override
  String planUpgraded(String tier) {
    return 'Your plan was upgraded to $tier.';
  }

  @override
  String get purchaseNotCompleted => 'Purchase couldn\'t be completed.';

  @override
  String get noPurchasesToRestore => 'No purchases found to restore.';

  @override
  String get firstMonthDiscountTag => '50% off your first month';

  @override
  String get currentPlanBadge => 'Your current plan';

  @override
  String get purchasing => 'Purchasing...';

  @override
  String get switchToThisPlan => 'Switch to this plan';

  @override
  String replyCountLabel(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString replies',
      one: '$countString reply',
    );
    return '$_temp0 · Reply';
  }

  @override
  String get movedAwayFromLocation => 'You\'ve moved away from this location';

  @override
  String placeTagDistance(String place, String distance) {
    return '$place · $distance km';
  }

  @override
  String get orDividerLabel => 'or';

  @override
  String get noOwnPostsYet => 'You haven\'t posted any comments yet.';

  @override
  String get blockedUsersScreenTitle => 'Blocked users';

  @override
  String get noBlockedUsersMessage => 'You haven\'t blocked anyone.';

  @override
  String get blockUserAction => 'Block';

  @override
  String get unblockUserAction => 'Unblock';

  @override
  String get blockUserConfirmTitle => 'Block this user?';

  @override
  String blockUserConfirmMessage(String name) {
    return '$name won\'t be able to message you anymore. You can unblock them anytime from your profile.';
  }

  @override
  String userBlockedToast(String name) {
    return 'You blocked $name.';
  }

  @override
  String get deleteAccountLabel => 'Delete my account';

  @override
  String get deleteAccountConfirmTitle => 'Delete your account?';

  @override
  String get deleteAccountConfirmMessage =>
      'Your account will be deactivated and you\'ll be signed out. Your existing comments and messages won\'t be deleted.';

  @override
  String get deleteAccountConfirmButton => 'Delete account';
}
