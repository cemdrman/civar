// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get cancel => 'إلغاء';

  @override
  String get save => 'حفظ';

  @override
  String get genericErrorRetry => 'حدث خطأ ما، حاول مرة أخرى.';

  @override
  String streamError(Object error) {
    return 'حدث خطأ ما: $error';
  }

  @override
  String get commentPosted => 'تم نشر تعليقك في المكان.';

  @override
  String get unlimitedRadius => 'غير محدود';

  @override
  String radiusSuffix(String radius) {
    return 'نطاق $radius';
  }

  @override
  String get exploreLabel => 'استكشف';

  @override
  String get mapLabel => 'الخريطة';

  @override
  String get messagesLabel => 'الرسائل';

  @override
  String get profileLabel => 'الملف الشخصي';

  @override
  String get editProfile => 'تعديل الملف الشخصي';

  @override
  String get onboardingTagline =>
      'ماذا يحدث فعلاً من حولك؟ اطّلع على التعليقات وشارك فيها في مكانك فقط.';

  @override
  String get onboardingStart => 'ابدأ';

  @override
  String get authAccessAccountTitle => 'الدخول إلى حسابك';

  @override
  String get continueWithGoogle => 'المتابعة باستخدام Google';

  @override
  String get googleSignInFailed =>
      'تعذّر تسجيل الدخول عبر Google، حاول مرة أخرى.';

  @override
  String get createAccountTitle => 'إنشاء حساب';

  @override
  String get createAccountSubtitle =>
      'أدخل بياناتك أدناه وسننشئ حسابك خلال ثوانٍ.';

  @override
  String get signInSubtitle =>
      'سجّل الدخول إذا كان لديك حساب بالفعل، أو أنشئ حسابًا جديدًا أدناه.';

  @override
  String get fullNameHint => 'الاسم الكامل';

  @override
  String get emailHint => 'البريد الإلكتروني';

  @override
  String get passwordHint => 'كلمة المرور (6 أحرف على الأقل)';

  @override
  String get invalidCredentialsError =>
      'البريد الإلكتروني أو كلمة المرور غير صحيحة، أو ليس لديك حساب.';

  @override
  String get accountCreationFailed =>
      'تعذّر إنشاء الحساب. قد يكون البريد الإلكتروني مسجّلاً بالفعل.';

  @override
  String get createAccountAndEnter => 'إنشاء حساب والدخول';

  @override
  String get signingIn => 'جارٍ تسجيل الدخول...';

  @override
  String get signIn => 'تسجيل الدخول';

  @override
  String get noAccountCreateOne => 'ليس لدي حساب، أريد إنشاء واحد';

  @override
  String get locationPermissionIllustrationLabel => 'رسم توضيحي لإذن الموقع';

  @override
  String get locationNeededTitle => 'نحتاج إلى موقعك';

  @override
  String locationPermissionExplainer(String radius) {
    return 'يعرض Civar التعليقات ضمن نطاق $radius فقط. يمكنك توسيع هذا النطاق فقط من خلال عضوية شهرية.';
  }

  @override
  String get allowLocationAccess => 'السماح بالوصول إلى موقعي';

  @override
  String get notNow => 'ليس الآن';

  @override
  String get noCommentsInRadius => 'لا توجد تعليقات في هذا النطاق بعد.';

  @override
  String get feedSubtitle => 'أحدث التعليقات من حولك';

  @override
  String get mapPlaceholderLabel => 'عرض الخريطة · طبقة الكثافة';

  @override
  String get noCommentsYetWriteFirst => 'لا توجد تعليقات بعد، كن أول من يكتب.';

  @override
  String viewCommentsCount(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'عرض $countString تعليق',
      many: 'عرض $countString تعليقًا',
      few: 'عرض $countString تعليقات',
      two: 'عرض تعليقين',
      one: 'عرض تعليق واحد',
      zero: 'لا توجد تعليقات لعرضها',
    );
    return '$_temp0';
  }

  @override
  String get newCommentTitle => 'تعليق جديد';

  @override
  String get shareAction => 'نشر';

  @override
  String currentlyAt(String place) {
    return 'الآن في: $place';
  }

  @override
  String get composeHint => 'ما الذي يحدث هنا؟ ثبّت فكرتك في هذا المكان...';

  @override
  String get addPhotoVideo => '+ إضافة صورة / فيديو';

  @override
  String get photoVideoLabel => 'صورة / فيديو';

  @override
  String get whatToAddTitle => 'ماذا تريد أن تضيف؟';

  @override
  String get choosePhoto => 'اختيار صورة';

  @override
  String get choosePhotoHint => 'jpg، png، webp، heic · بحد أقصى 10 ميغابايت';

  @override
  String get chooseVideo => 'اختيار فيديو';

  @override
  String get chooseVideoHint => 'mp4، mov · بحد أقصى 50 ميغابايت';

  @override
  String get placePhotoLabel => 'صورة المكان';

  @override
  String placeDetailMeta(String category, String distance, int count) {
    return '$category · $distance كم · $count تعليق';
  }

  @override
  String get writeCommentHint => 'اكتب تعليقًا لهذا المكان...';

  @override
  String get replyLockedMessage => 'يجب أن تكون قريبًا من هذا المكان للرد';

  @override
  String get reportThanks => 'شكرًا لإبلاغك، سيراجعه فريقنا.';

  @override
  String get reportThisComment => 'الإبلاغ عن هذا التعليق';

  @override
  String currentPlanLabel(String tier) {
    return 'خطة $tier';
  }

  @override
  String get addBio => 'أضف نبذة تعريفية';

  @override
  String get statComments => 'تعليقات';

  @override
  String get statLikes => 'إعجابات';

  @override
  String get statPlaces => 'أماكن';

  @override
  String activeRadiusLabel(String radius) {
    return 'نطاق $radius نشط';
  }

  @override
  String get managePlanSubtitle => 'إدارة خطتك أو الترقية';

  @override
  String get yourCommentsTitle => 'تعليقاتك';

  @override
  String get notifications => 'الإشعارات';

  @override
  String get privacy => 'الخصوصية';

  @override
  String get blockedUsers => 'المحظورون';

  @override
  String get signOut => 'تسجيل الخروج';

  @override
  String get languageSettingsLabel => 'اللغة';

  @override
  String get languagePickerTitle => 'اختر اللغة';

  @override
  String get devChangeLocation => 'للمطورين: تغيير الموقع';

  @override
  String get photoUploadFailed => 'تعذّر رفع الصورة، حاول مرة أخرى.';

  @override
  String get profileUpdated => 'تم تحديث ملفك الشخصي.';

  @override
  String get changeProfilePhoto => 'تغيير صورة الملف الشخصي';

  @override
  String get bioLabel => 'النبذة التعريفية';

  @override
  String get bioHint => 'اكتب نبذة قصيرة عن نفسك...';

  @override
  String get bioLinkNotAllowed => 'لا يمكنك مشاركة رابط في نبذتك التعريفية.';

  @override
  String get whoToMessageTitle => 'مع من تريد التحدث؟';

  @override
  String get newMessage => 'رسالة جديدة';

  @override
  String get freeTierDmLockedMessage =>
      'لا يمكن للأعضاء المجانيين بدء محادثات جديدة، لكن يمكنهم الرد على الرسائل الواردة.';

  @override
  String get writeMessageHint => 'اكتب رسالة...';

  @override
  String get expandYourRadius => 'وسّع نطاقك';

  @override
  String get paywallExplainer =>
      'قم بالترقية لرؤية التعليقات والرد عليها ضمن نطاق أوسع، وإرسال رسائل إلى الأشخاص.';

  @override
  String get firstMonthDiscountBanner =>
      '🎉 عرض خاص لعضويتك الأولى: خصم 50٪ على جميع الخطط للشهر الأول!';

  @override
  String get checkingEllipsis => 'جارٍ التحقق...';

  @override
  String get restorePurchases => 'استعادة المشتريات';

  @override
  String planDowngraded(String tier) {
    return 'تم تخفيض خطتك إلى $tier.';
  }

  @override
  String planUpgraded(String tier) {
    return 'تمت ترقية خطتك إلى $tier.';
  }

  @override
  String get purchaseNotCompleted => 'تعذّر إتمام عملية الشراء.';

  @override
  String get noPurchasesToRestore => 'لم يتم العثور على مشتريات لاستعادتها.';

  @override
  String get firstMonthDiscountTag => 'خصم 50٪ على شهرك الأول';

  @override
  String get currentPlanBadge => 'خطتك الحالية';

  @override
  String get purchasing => 'جارٍ الشراء...';

  @override
  String get switchToThisPlan => 'التبديل إلى هذه الخطة';

  @override
  String replyCountLabel(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString رد',
      many: '$countString ردًا',
      few: '$countString ردود',
      two: 'ردّان',
      one: 'رد واحد',
      zero: 'لا ردود',
    );
    return '$_temp0 · الرد';
  }

  @override
  String get movedAwayFromLocation => 'لقد ابتعدت عن هذا الموقع';

  @override
  String placeTagDistance(String place, String distance) {
    return '$place · $distance كم';
  }

  @override
  String get orDividerLabel => 'أو';

  @override
  String get noOwnPostsYet => 'لم تكتب أي تعليقات بعد.';

  @override
  String get blockedUsersScreenTitle => 'المحظورون';

  @override
  String get noBlockedUsersMessage => 'لم تحظر أحدًا بعد.';

  @override
  String get blockUserAction => 'حظر';

  @override
  String get unblockUserAction => 'إلغاء الحظر';

  @override
  String get blockUserConfirmTitle => 'هل تريد حظر هذا المستخدم؟';

  @override
  String blockUserConfirmMessage(String name) {
    return 'لن يتمكن $name من مراسلتك بعد الآن. يمكنك إلغاء الحظر في أي وقت من ملفك الشخصي.';
  }

  @override
  String userBlockedToast(String name) {
    return 'تم حظر $name.';
  }

  @override
  String get deleteAccountLabel => 'حذف حسابي';

  @override
  String get deleteAccountConfirmTitle => 'هل تريد حذف حسابك؟';

  @override
  String get deleteAccountConfirmMessage =>
      'سيتم إلغاء تفعيل حسابك وتسجيل خروجك. لن يتم حذف تعليقاتك ورسائلك الحالية.';

  @override
  String get deleteAccountConfirmButton => 'حذف الحساب';
}
