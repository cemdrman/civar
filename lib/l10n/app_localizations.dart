import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
    Locale('fr'),
    Locale('pt'),
    Locale('tr'),
  ];

  /// Generic cancel button label used in bottom sheets.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Save button label on edit profile.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// Generic error toast when an action fails without a specific reason.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong, try again.'**
  String get genericErrorRetry;

  /// Shown when a live data stream (feed, DM list, DM thread) errors out.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong: {error}'**
  String streamError(Object error);

  /// Toast shown after successfully posting a comment/reply.
  ///
  /// In en, this message translates to:
  /// **'Your comment was posted to the venue.'**
  String get commentPosted;

  /// Label used instead of a numeric radius when the radius is unlimited.
  ///
  /// In en, this message translates to:
  /// **'Unlimited'**
  String get unlimitedRadius;

  /// Radius value followed by the word 'radius', e.g. '20 km radius'.
  ///
  /// In en, this message translates to:
  /// **'{radius} radius'**
  String radiusSuffix(String radius);

  /// Feed tab/section title, also used as the bottom nav label.
  ///
  /// In en, this message translates to:
  /// **'Explore'**
  String get exploreLabel;

  /// Map tab/section title, also used as the bottom nav label.
  ///
  /// In en, this message translates to:
  /// **'Map'**
  String get mapLabel;

  /// DM list tab/section title, also used as the bottom nav label.
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get messagesLabel;

  /// Bottom nav label for the profile tab.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileLabel;

  /// Settings row label and edit-profile screen title.
  ///
  /// In en, this message translates to:
  /// **'Edit profile'**
  String get editProfile;

  /// Subtitle on the onboarding welcome screen.
  ///
  /// In en, this message translates to:
  /// **'What\'s really happening around you? See and join comments, only where you are.'**
  String get onboardingTagline;

  /// Button on the onboarding welcome screen.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get onboardingStart;

  /// Title of the onboarding auth-choice step.
  ///
  /// In en, this message translates to:
  /// **'Access your account'**
  String get authAccessAccountTitle;

  /// Subtitle of the onboarding auth-choice step.
  ///
  /// In en, this message translates to:
  /// **'Choose a way to continue.'**
  String get authChooseMethodSubtitle;

  /// Button to continue onboarding with email instead of Google.
  ///
  /// In en, this message translates to:
  /// **'Continue with email'**
  String get continueWithEmail;

  /// Google sign-in button label.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get continueWithGoogle;

  /// Toast shown when Google sign-in fails.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t sign in with Google, try again.'**
  String get googleSignInFailed;

  /// Title shown when the email step offers registration.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get createAccountTitle;

  /// Subtitle shown when the email step offers registration.
  ///
  /// In en, this message translates to:
  /// **'If there\'s no account with this info, add your name and we\'ll create a new one.'**
  String get createAccountSubtitle;

  /// Subtitle shown on the initial email step before registration is offered.
  ///
  /// In en, this message translates to:
  /// **'Sign in if you already have an account, or create a new one below.'**
  String get signInSubtitle;

  /// Hint text for the full name field.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get fullNameHint;

  /// Hint text for the email field.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailHint;

  /// Hint text for the password field.
  ///
  /// In en, this message translates to:
  /// **'Password (at least 6 characters)'**
  String get passwordHint;

  /// Error shown when sign-in fails with invalid credentials.
  ///
  /// In en, this message translates to:
  /// **'Wrong email or password, or you don\'t have an account.'**
  String get invalidCredentialsError;

  /// Error shown when account registration fails.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t create account. The email might already be registered.'**
  String get accountCreationFailed;

  /// Button to submit registration.
  ///
  /// In en, this message translates to:
  /// **'Create account and enter'**
  String get createAccountAndEnter;

  /// Sign-in button label while the request is in flight.
  ///
  /// In en, this message translates to:
  /// **'Signing in...'**
  String get signingIn;

  /// Sign-in button label.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get signIn;

  /// Link to switch from sign-in to registration.
  ///
  /// In en, this message translates to:
  /// **'I don\'t have an account, I want to create one'**
  String get noAccountCreateOne;

  /// Placeholder label over the location-permission illustration.
  ///
  /// In en, this message translates to:
  /// **'LOCATION PERMISSION ILLUSTRATION'**
  String get locationPermissionIllustrationLabel;

  /// Title on the onboarding location-permission step.
  ///
  /// In en, this message translates to:
  /// **'We need your location'**
  String get locationNeededTitle;

  /// Body text on the onboarding location-permission step.
  ///
  /// In en, this message translates to:
  /// **'Civar only shows comments within a {radius} radius. You can only increase this radius with a monthly membership.'**
  String locationPermissionExplainer(String radius);

  /// Button to grant location permission.
  ///
  /// In en, this message translates to:
  /// **'Allow my location'**
  String get allowLocationAccess;

  /// Button to skip granting location permission for now.
  ///
  /// In en, this message translates to:
  /// **'Not now'**
  String get notNow;

  /// Empty state on the feed when there are no posts in range.
  ///
  /// In en, this message translates to:
  /// **'No comments in this radius yet.'**
  String get noCommentsInRadius;

  /// Subtitle under the Explore/feed header.
  ///
  /// In en, this message translates to:
  /// **'Recent comments around you'**
  String get feedSubtitle;

  /// Placeholder label over the map view.
  ///
  /// In en, this message translates to:
  /// **'MAP VIEW · density layer'**
  String get mapPlaceholderLabel;

  /// Teaser text on a map place preview with no posts yet.
  ///
  /// In en, this message translates to:
  /// **'No comments yet, be the first to write one.'**
  String get noCommentsYetWriteFirst;

  /// Button on the map place-preview sheet to open a place's comments.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{View {count} comment} other{View {count} comments}}'**
  String viewCommentsCount(num count);

  /// Title of the compose screen's header.
  ///
  /// In en, this message translates to:
  /// **'New comment'**
  String get newCommentTitle;

  /// Button to submit a new comment on the compose screen.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get shareAction;

  /// Shows the place the user is about to post to on the compose screen.
  ///
  /// In en, this message translates to:
  /// **'Now at: {place}'**
  String currentlyAt(String place);

  /// Hint text in the compose text field.
  ///
  /// In en, this message translates to:
  /// **'What\'s happening here? Pin your thought to this place...'**
  String get composeHint;

  /// Placeholder label on the empty media-attach slot in compose.
  ///
  /// In en, this message translates to:
  /// **'+ ADD PHOTO / VIDEO'**
  String get addPhotoVideo;

  /// Placeholder label over an attached photo/video on a comment card.
  ///
  /// In en, this message translates to:
  /// **'PHOTO / VIDEO'**
  String get photoVideoLabel;

  /// Title of the media-picker bottom sheet.
  ///
  /// In en, this message translates to:
  /// **'What do you want to add?'**
  String get whatToAddTitle;

  /// Option to attach a photo.
  ///
  /// In en, this message translates to:
  /// **'Choose photo'**
  String get choosePhoto;

  /// Supported photo formats/size sublabel.
  ///
  /// In en, this message translates to:
  /// **'jpg, png, webp, heic · max. 10MB'**
  String get choosePhotoHint;

  /// Option to attach a video.
  ///
  /// In en, this message translates to:
  /// **'Choose video'**
  String get chooseVideo;

  /// Supported video formats/size sublabel.
  ///
  /// In en, this message translates to:
  /// **'mp4, mov · max. 50MB'**
  String get chooseVideoHint;

  /// Placeholder label over the place-detail hero photo.
  ///
  /// In en, this message translates to:
  /// **'VENUE PHOTO'**
  String get placePhotoLabel;

  /// Meta line under a place's name on the place-detail screen.
  ///
  /// In en, this message translates to:
  /// **'{category} · {distance} km · {count} comments'**
  String placeDetailMeta(String category, String distance, int count);

  /// Hint text on the place-detail reply field.
  ///
  /// In en, this message translates to:
  /// **'Write a comment for this place...'**
  String get writeCommentHint;

  /// Shown instead of the reply field when the viewer is out of range.
  ///
  /// In en, this message translates to:
  /// **'You need to be close to this place to reply'**
  String get replyLockedMessage;

  /// Toast shown after submitting a report.
  ///
  /// In en, this message translates to:
  /// **'Thanks for reporting, our team will review it.'**
  String get reportThanks;

  /// Title of the report-reason bottom sheet.
  ///
  /// In en, this message translates to:
  /// **'Report this comment'**
  String get reportThisComment;

  /// Shows the viewer's current membership tier under their name on the profile screen.
  ///
  /// In en, this message translates to:
  /// **'{tier} plan'**
  String currentPlanLabel(String tier);

  /// Placeholder shown instead of a bio when the user hasn't written one.
  ///
  /// In en, this message translates to:
  /// **'Add a bio'**
  String get addBio;

  /// Profile stat cell label for comment count.
  ///
  /// In en, this message translates to:
  /// **'Comments'**
  String get statComments;

  /// Profile stat cell label for like count.
  ///
  /// In en, this message translates to:
  /// **'Likes'**
  String get statLikes;

  /// Profile stat cell label for place count.
  ///
  /// In en, this message translates to:
  /// **'Places'**
  String get statPlaces;

  /// Shown on the profile screen's plan banner.
  ///
  /// In en, this message translates to:
  /// **'{radius} radius active'**
  String activeRadiusLabel(String radius);

  /// Subtitle under the active-radius banner on the profile screen.
  ///
  /// In en, this message translates to:
  /// **'Manage or upgrade your plan'**
  String get managePlanSubtitle;

  /// Section title over the user's own posts grid on the profile screen.
  ///
  /// In en, this message translates to:
  /// **'Your comments'**
  String get yourCommentsTitle;

  /// Settings row label.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// Settings row label.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get privacy;

  /// Settings row label.
  ///
  /// In en, this message translates to:
  /// **'Blocked'**
  String get blockedUsers;

  /// Settings row label to sign out.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get signOut;

  /// Settings row label that opens the language picker.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageSettingsLabel;

  /// Title of the language-picker bottom sheet.
  ///
  /// In en, this message translates to:
  /// **'Choose language'**
  String get languagePickerTitle;

  /// Debug-only section title for the QA location presets, kDebugMode only.
  ///
  /// In en, this message translates to:
  /// **'Dev: Change location'**
  String get devChangeLocation;

  /// Toast shown when a profile photo upload fails.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t upload photo, try again.'**
  String get photoUploadFailed;

  /// Toast shown after successfully saving profile edits.
  ///
  /// In en, this message translates to:
  /// **'Your profile was updated.'**
  String get profileUpdated;

  /// Button under the avatar on the edit-profile screen.
  ///
  /// In en, this message translates to:
  /// **'Change profile photo'**
  String get changeProfilePhoto;

  /// Section title over the bio field on the edit-profile screen.
  ///
  /// In en, this message translates to:
  /// **'Bio'**
  String get bioLabel;

  /// Hint text for the bio field.
  ///
  /// In en, this message translates to:
  /// **'Tell us a bit about yourself...'**
  String get bioHint;

  /// Validation error shown under the bio field when it contains a link.
  ///
  /// In en, this message translates to:
  /// **'You can\'t share a link in your bio.'**
  String get bioLinkNotAllowed;

  /// Title of the new-message picker dialog.
  ///
  /// In en, this message translates to:
  /// **'Who do you want to talk to?'**
  String get whoToMessageTitle;

  /// Button to start a new DM thread.
  ///
  /// In en, this message translates to:
  /// **'New message'**
  String get newMessage;

  /// Banner shown on the DM list when the viewer can't start new chats.
  ///
  /// In en, this message translates to:
  /// **'Free members can\'t start new chats, but can reply to incoming messages.'**
  String get freeTierDmLockedMessage;

  /// Hint text on the DM chat input field.
  ///
  /// In en, this message translates to:
  /// **'Write a message...'**
  String get writeMessageHint;

  /// Paywall screen title.
  ///
  /// In en, this message translates to:
  /// **'Expand your radius'**
  String get expandYourRadius;

  /// Explainer paragraph at the top of the paywall screen.
  ///
  /// In en, this message translates to:
  /// **'Upgrade to see and reply to comments in a wider radius, and to message people.'**
  String get paywallExplainer;

  /// Discount banner on the paywall screen.
  ///
  /// In en, this message translates to:
  /// **'🎉 Special for your first membership: 50% off all plans for the first month!'**
  String get firstMonthDiscountBanner;

  /// Restore-purchases button label while the request is in flight.
  ///
  /// In en, this message translates to:
  /// **'Checking...'**
  String get checkingEllipsis;

  /// Button to restore previous purchases.
  ///
  /// In en, this message translates to:
  /// **'Restore purchases'**
  String get restorePurchases;

  /// Toast shown after switching to a lower/free tier.
  ///
  /// In en, this message translates to:
  /// **'Your plan was downgraded to {tier}.'**
  String planDowngraded(String tier);

  /// Toast shown after a successful upgrade purchase.
  ///
  /// In en, this message translates to:
  /// **'Your plan was upgraded to {tier}.'**
  String planUpgraded(String tier);

  /// Fallback error toast when a purchase fails without a specific reason.
  ///
  /// In en, this message translates to:
  /// **'Purchase couldn\'t be completed.'**
  String get purchaseNotCompleted;

  /// Toast shown when restoring purchases finds nothing.
  ///
  /// In en, this message translates to:
  /// **'No purchases found to restore.'**
  String get noPurchasesToRestore;

  /// Small discount tag on a tier card.
  ///
  /// In en, this message translates to:
  /// **'50% off your first month'**
  String get firstMonthDiscountTag;

  /// Badge shown on the tier card matching the viewer's current plan.
  ///
  /// In en, this message translates to:
  /// **'Your current plan'**
  String get currentPlanBadge;

  /// Tier card button label while a purchase is in flight.
  ///
  /// In en, this message translates to:
  /// **'Purchasing...'**
  String get purchasing;

  /// Tier card button label to select a plan.
  ///
  /// In en, this message translates to:
  /// **'Switch to this plan'**
  String get switchToThisPlan;

  /// Reply count + call-to-action shown under a comment card.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{{count} reply} other{{count} replies}} · Reply'**
  String replyCountLabel(num count);

  /// Shown instead of the reply link when the viewer left the post's range.
  ///
  /// In en, this message translates to:
  /// **'You\'ve moved away from this location'**
  String get movedAwayFromLocation;

  /// Tappable place-name pill on a comment card, with distance.
  ///
  /// In en, this message translates to:
  /// **'{place} · {distance} km'**
  String placeTagDistance(String place, String distance);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en', 'fr', 'pt', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
    case 'pt':
      return AppLocalizationsPt();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
