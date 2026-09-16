// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get cancel => 'Vazgeç';

  @override
  String get save => 'Kaydet';

  @override
  String get genericErrorRetry => 'Bir şeyler ters gitti, tekrar dene.';

  @override
  String streamError(Object error) {
    return 'Bir şeyler ters gitti: $error';
  }

  @override
  String get commentPosted => 'Yorumun mekana tutturuldu.';

  @override
  String get unlimitedRadius => 'Sınırsız';

  @override
  String radiusSuffix(String radius) {
    return '$radius çap';
  }

  @override
  String get exploreLabel => 'Keşfet';

  @override
  String get mapLabel => 'Harita';

  @override
  String get messagesLabel => 'Mesajlar';

  @override
  String get profileLabel => 'Profil';

  @override
  String get editProfile => 'Profili düzenle';

  @override
  String get onboardingTagline =>
      'Çevrende gerçekten neler oluyor? Sadece bulunduğun yerdeki yorumları gör, konuş.';

  @override
  String get onboardingStart => 'Başla';

  @override
  String get authAccessAccountTitle => 'Hesabına eriş';

  @override
  String get continueWithGoogle => 'Google ile devam et';

  @override
  String get googleSignInFailed => 'Google ile giriş yapılamadı, tekrar dene.';

  @override
  String get createAccountTitle => 'Hesap oluştur';

  @override
  String get createAccountSubtitle =>
      'Bilgilerini gir, hesabını saniyeler içinde oluşturalım.';

  @override
  String get signInSubtitle =>
      'Zaten hesabın varsa giriş yap, yoksa aşağıdan yeni hesap oluşturabilirsin.';

  @override
  String get fullNameHint => 'Ad Soyad';

  @override
  String get emailHint => 'E-posta';

  @override
  String get passwordHint => 'Şifre (en az 6 karakter)';

  @override
  String get invalidCredentialsError =>
      'E-posta veya şifre hatalı, ya da hesabın yok.';

  @override
  String get accountCreationFailed =>
      'Hesap oluşturulamadı. E-posta zaten kayıtlı olabilir.';

  @override
  String get createAccountAndEnter => 'Hesap oluştur ve gir';

  @override
  String get signingIn => 'Giriş yapılıyor...';

  @override
  String get signIn => 'Giriş yap';

  @override
  String get noAccountCreateOne => 'Hesabım yok, oluşturmak istiyorum';

  @override
  String get locationPermissionIllustrationLabel => 'KONUM İZNİ İLLÜSTRASYONU';

  @override
  String get locationNeededTitle => 'Konumuna ihtiyacımız var';

  @override
  String locationPermissionExplainer(String radius) {
    return 'Civar, yalnızca $radius çapındaki yorumları gösterir. Bu çapı yalnızca aylık üyelikle artırabilirsin.';
  }

  @override
  String get allowLocationAccess => 'Konumuma izin ver';

  @override
  String get notNow => 'Şimdi değil';

  @override
  String get noCommentsInRadius => 'Bu yarıçapta henüz yorum yok.';

  @override
  String get feedSubtitle => 'Çevrendeki son yorumlar';

  @override
  String get mapPlaceholderLabel => 'HARİTA GÖRÜNÜMÜ · yoğunluk katmanı';

  @override
  String get noCommentsYetWriteFirst => 'Henüz yorum yok, ilk sen yaz.';

  @override
  String viewCommentsCount(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    return '$countString yorumu gör';
  }

  @override
  String get newCommentTitle => 'Yeni yorum';

  @override
  String get shareAction => 'Paylaş';

  @override
  String currentlyAt(String place) {
    return 'Şu an: $place';
  }

  @override
  String get composeHint => 'Burada ne oluyor? Düşünceni bu mekana tuttur...';

  @override
  String get addPhotoVideo => '+ FOTOĞRAF / VİDEO EKLE';

  @override
  String get photoVideoLabel => 'FOTOĞRAF / VİDEO';

  @override
  String get whatToAddTitle => 'Ne eklemek istersin?';

  @override
  String get choosePhoto => 'Fotoğraf seç';

  @override
  String get choosePhotoHint => 'jpg, png, webp, heic · maks. 10MB';

  @override
  String get chooseVideo => 'Video seç';

  @override
  String get chooseVideoHint => 'mp4, mov · maks. 50MB';

  @override
  String get placePhotoLabel => 'MEKAN FOTOĞRAFI';

  @override
  String placeDetailMeta(String category, String distance, int count) {
    return '$category · $distance km · $count yorum';
  }

  @override
  String get writeCommentHint => 'Bu mekana yorum yaz...';

  @override
  String get replyLockedMessage =>
      'Cevap vermek için bu mekana yakın olmalısın';

  @override
  String get reportThanks =>
      'Bildirdiğin için teşekkürler, ekibimiz inceleyecek.';

  @override
  String get reportThisComment => 'Bu yorumu bildir';

  @override
  String currentPlanLabel(String tier) {
    return '$tier planı';
  }

  @override
  String get addBio => 'Biyografini ekle';

  @override
  String get statComments => 'Yorum';

  @override
  String get statLikes => 'Beğeni';

  @override
  String get statPlaces => 'Mekan';

  @override
  String activeRadiusLabel(String radius) {
    return '$radius çap aktif';
  }

  @override
  String get managePlanSubtitle => 'Planını yönet veya yükselt';

  @override
  String get yourCommentsTitle => 'Yorumların';

  @override
  String get notifications => 'Bildirimler';

  @override
  String get privacy => 'Gizlilik';

  @override
  String get blockedUsers => 'Engellenenler';

  @override
  String get signOut => 'Çıkış yap';

  @override
  String get languageSettingsLabel => 'Dil';

  @override
  String get languagePickerTitle => 'Dil seç';

  @override
  String get devChangeLocation => 'Dev: Konumu değiştir';

  @override
  String get photoUploadFailed => 'Fotoğraf yüklenemedi, tekrar dene.';

  @override
  String get profileUpdated => 'Profilin güncellendi.';

  @override
  String get changeProfilePhoto => 'Profil fotoğrafını değiştir';

  @override
  String get bioLabel => 'Biyografi';

  @override
  String get bioHint => 'Kendinden kısaca bahset...';

  @override
  String get bioLinkNotAllowed => 'Biyografide bağlantı paylaşamazsın.';

  @override
  String get whoToMessageTitle => 'Kiminle konuşmak istersin?';

  @override
  String get newMessage => 'Yeni mesaj';

  @override
  String get freeTierDmLockedMessage =>
      'Ücretsiz üyeler yeni sohbet başlatamaz, ama gelen mesajlara yanıt verebilir.';

  @override
  String get writeMessageHint => 'Mesaj yaz...';

  @override
  String get expandYourRadius => 'Çapını genişlet';

  @override
  String get paywallExplainer =>
      'Daha geniş bir çapta yorum görmek ve cevap vermek, ayrıca kişilere mesaj atabilmek için yükselt.';

  @override
  String get firstMonthDiscountBanner =>
      '🎉 İlk üyeliğine özel: ilk ay tüm planlarda %50 indirim!';

  @override
  String get checkingEllipsis => 'Kontrol ediliyor...';

  @override
  String get restorePurchases => 'Satın alımları geri yükle';

  @override
  String planDowngraded(String tier) {
    return 'Planın $tier\'a düşürüldü.';
  }

  @override
  String planUpgraded(String tier) {
    return 'Planın $tier\'a yükseltildi.';
  }

  @override
  String get purchaseNotCompleted => 'Satın alma tamamlanamadı.';

  @override
  String get noPurchasesToRestore =>
      'Geri yüklenecek bir satın alma bulunamadı.';

  @override
  String get firstMonthDiscountTag => 'İlk aya özel %50 indirim';

  @override
  String get currentPlanBadge => 'Mevcut planın';

  @override
  String get purchasing => 'Satın alınıyor...';

  @override
  String get switchToThisPlan => 'Bu plana geç';

  @override
  String replyCountLabel(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    return '$countString yanıt · Cevapla';
  }

  @override
  String get movedAwayFromLocation => 'Konumundan uzaklaştın';

  @override
  String placeTagDistance(String place, String distance) {
    return '$place · $distance km';
  }

  @override
  String get orDividerLabel => 'veya';

  @override
  String get noOwnPostsYet => 'Henüz yorum yapmadın.';

  @override
  String get blockedUsersScreenTitle => 'Engellenenler';

  @override
  String get noBlockedUsersMessage => 'Henüz kimseyi engellemedin.';

  @override
  String get blockUserAction => 'Engelle';

  @override
  String get unblockUserAction => 'Engeli kaldır';

  @override
  String get blockUserConfirmTitle =>
      'Bu kullanıcıyı engellemek istiyor musun?';

  @override
  String blockUserConfirmMessage(String name) {
    return '$name artık sana mesaj gönderemez. İstediğin zaman profilinden engeli kaldırabilirsin.';
  }

  @override
  String userBlockedToast(String name) {
    return '$name kullanıcısını engelledin.';
  }

  @override
  String get deleteAccountLabel => 'Hesabımı sil';

  @override
  String get deleteAccountConfirmTitle => 'Hesabını silmek istiyor musun?';

  @override
  String get deleteAccountConfirmMessage =>
      'Hesabın pasif hale getirilecek ve oturumun kapatılacak. Mevcut yorumların ve mesajların silinmeyecek.';

  @override
  String get deleteAccountConfirmButton => 'Hesabı sil';
}
