// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get cancel => 'Annuler';

  @override
  String get save => 'Enregistrer';

  @override
  String get genericErrorRetry => 'Une erreur s\'est produite, réessaie.';

  @override
  String streamError(Object error) {
    return 'Une erreur s\'est produite : $error';
  }

  @override
  String get commentPosted => 'Ton commentaire a été épinglé au lieu.';

  @override
  String get unlimitedRadius => 'Illimité';

  @override
  String radiusSuffix(String radius) {
    return 'Rayon de $radius';
  }

  @override
  String get exploreLabel => 'Explorer';

  @override
  String get mapLabel => 'Carte';

  @override
  String get messagesLabel => 'Messages';

  @override
  String get profileLabel => 'Profil';

  @override
  String get editProfile => 'Modifier le profil';

  @override
  String get onboardingTagline =>
      'Que se passe-t-il vraiment autour de toi ? Découvre et rejoins les commentaires, uniquement là où tu te trouves.';

  @override
  String get onboardingStart => 'Commencer';

  @override
  String get authAccessAccountTitle => 'Accède à ton compte';

  @override
  String get continueWithGoogle => 'Continuer avec Google';

  @override
  String get googleSignInFailed =>
      'Connexion avec Google impossible, réessaie.';

  @override
  String get createAccountTitle => 'Créer un compte';

  @override
  String get createAccountSubtitle =>
      'Ajoute tes informations ci-dessous, ton compte sera prêt en quelques secondes.';

  @override
  String get signInSubtitle =>
      'Connecte-toi si tu as déjà un compte, ou crées-en un nouveau ci-dessous.';

  @override
  String get fullNameHint => 'Nom complet';

  @override
  String get emailHint => 'E-mail';

  @override
  String get passwordHint => 'Mot de passe (6 caractères minimum)';

  @override
  String get invalidCredentialsError =>
      'E-mail ou mot de passe incorrect, ou tu n\'as pas de compte.';

  @override
  String get accountCreationFailed =>
      'Impossible de créer le compte. Cet e-mail est peut-être déjà utilisé.';

  @override
  String get createAccountAndEnter => 'Créer un compte et entrer';

  @override
  String get signingIn => 'Connexion...';

  @override
  String get signIn => 'Se connecter';

  @override
  String get noAccountCreateOne =>
      'Je n\'ai pas de compte, je veux en créer un';

  @override
  String get locationPermissionIllustrationLabel =>
      'ILLUSTRATION AUTORISATION DE LOCALISATION';

  @override
  String get locationNeededTitle => 'Nous avons besoin de ta localisation';

  @override
  String locationPermissionExplainer(String radius) {
    return 'Civar n\'affiche que les commentaires dans un rayon de $radius. Tu ne peux augmenter ce rayon qu\'avec un abonnement mensuel.';
  }

  @override
  String get allowLocationAccess => 'Autoriser ma position';

  @override
  String get notNow => 'Pas maintenant';

  @override
  String get noCommentsInRadius =>
      'Aucun commentaire dans ce rayon pour l\'instant.';

  @override
  String get feedSubtitle => 'Derniers commentaires autour de toi';

  @override
  String get mapPlaceholderLabel => 'VUE CARTE · couche de densité';

  @override
  String get noCommentsYetWriteFirst =>
      'Aucun commentaire pour l\'instant, sois le premier à écrire.';

  @override
  String viewCommentsCount(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Voir $countString commentaires',
      one: 'Voir $countString commentaire',
    );
    return '$_temp0';
  }

  @override
  String get newCommentTitle => 'Nouveau commentaire';

  @override
  String get shareAction => 'Publier';

  @override
  String currentlyAt(String place) {
    return 'Actuellement à : $place';
  }

  @override
  String get composeHint =>
      'Que se passe-t-il ici ? Épingle ta pensée à ce lieu...';

  @override
  String get addPhotoVideo => '+ AJOUTER PHOTO / VIDÉO';

  @override
  String get photoVideoLabel => 'PHOTO / VIDÉO';

  @override
  String get whatToAddTitle => 'Que veux-tu ajouter ?';

  @override
  String get choosePhoto => 'Choisir une photo';

  @override
  String get choosePhotoHint => 'jpg, png, webp, heic · max. 10 Mo';

  @override
  String get chooseVideo => 'Choisir une vidéo';

  @override
  String get chooseVideoHint => 'mp4, mov · max. 50 Mo';

  @override
  String get placePhotoLabel => 'PHOTO DU LIEU';

  @override
  String placeDetailMeta(String category, String distance, int count) {
    return '$category · $distance km · $count commentaires';
  }

  @override
  String get writeCommentHint => 'Écris un commentaire pour ce lieu...';

  @override
  String get replyLockedMessage =>
      'Tu dois être proche de ce lieu pour répondre';

  @override
  String get reportThanks =>
      'Merci pour ton signalement, notre équipe va l\'examiner.';

  @override
  String get reportThisComment => 'Signaler ce commentaire';

  @override
  String currentPlanLabel(String tier) {
    return 'Forfait $tier';
  }

  @override
  String get addBio => 'Ajouter une bio';

  @override
  String get statComments => 'Commentaires';

  @override
  String get statLikes => 'J\'aime';

  @override
  String get statPlaces => 'Lieux';

  @override
  String activeRadiusLabel(String radius) {
    return 'Rayon de $radius actif';
  }

  @override
  String get managePlanSubtitle => 'Gérer ou améliorer ton forfait';

  @override
  String get yourCommentsTitle => 'Tes commentaires';

  @override
  String get notifications => 'Notifications';

  @override
  String get privacy => 'Confidentialité';

  @override
  String get blockedUsers => 'Bloqués';

  @override
  String get signOut => 'Se déconnecter';

  @override
  String get languageSettingsLabel => 'Langue';

  @override
  String get languagePickerTitle => 'Choisir la langue';

  @override
  String get devChangeLocation => 'Dev : changer de position';

  @override
  String get photoUploadFailed => 'Échec de l\'envoi de la photo, réessaie.';

  @override
  String get profileUpdated => 'Ton profil a été mis à jour.';

  @override
  String get changeProfilePhoto => 'Changer la photo de profil';

  @override
  String get bioLabel => 'Bio';

  @override
  String get bioHint => 'Parle-nous un peu de toi...';

  @override
  String get bioLinkNotAllowed =>
      'Tu ne peux pas partager de lien dans ta bio.';

  @override
  String get whoToMessageTitle => 'À qui veux-tu parler ?';

  @override
  String get newMessage => 'Nouveau message';

  @override
  String get freeTierDmLockedMessage =>
      'Les membres gratuits ne peuvent pas démarrer de nouvelles conversations, mais peuvent répondre aux messages reçus.';

  @override
  String get writeMessageHint => 'Écris un message...';

  @override
  String get expandYourRadius => 'Élargis ton rayon';

  @override
  String get paywallExplainer =>
      'Passe à un forfait supérieur pour voir et répondre aux commentaires dans un rayon plus large, et envoyer des messages.';

  @override
  String get firstMonthDiscountBanner =>
      '🎉 Offre spéciale pour ton premier abonnement : 50 % de réduction sur tous les forfaits le premier mois !';

  @override
  String get checkingEllipsis => 'Vérification...';

  @override
  String get restorePurchases => 'Restaurer les achats';

  @override
  String planDowngraded(String tier) {
    return 'Ton forfait a été rétrogradé à $tier.';
  }

  @override
  String planUpgraded(String tier) {
    return 'Ton forfait a été mis à niveau vers $tier.';
  }

  @override
  String get purchaseNotCompleted => 'L\'achat n\'a pas pu être finalisé.';

  @override
  String get noPurchasesToRestore => 'Aucun achat à restaurer n\'a été trouvé.';

  @override
  String get firstMonthDiscountTag => '50 % de réduction le premier mois';

  @override
  String get currentPlanBadge => 'Ton forfait actuel';

  @override
  String get purchasing => 'Achat en cours...';

  @override
  String get switchToThisPlan => 'Passer à ce forfait';

  @override
  String replyCountLabel(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString réponses',
      one: '$countString réponse',
    );
    return '$_temp0 · Répondre';
  }

  @override
  String get movedAwayFromLocation => 'Tu t\'es éloigné de ce lieu';

  @override
  String placeTagDistance(String place, String distance) {
    return '$place · $distance km';
  }

  @override
  String get orDividerLabel => 'ou';

  @override
  String get noOwnPostsYet => 'Tu n\'as encore posté aucun commentaire.';

  @override
  String get blockedUsersScreenTitle => 'Utilisateurs bloqués';

  @override
  String get noBlockedUsersMessage => 'Tu n\'as encore bloqué personne.';

  @override
  String get blockUserAction => 'Bloquer';

  @override
  String get unblockUserAction => 'Débloquer';

  @override
  String get blockUserConfirmTitle => 'Bloquer cet utilisateur ?';

  @override
  String blockUserConfirmMessage(String name) {
    return '$name ne pourra plus t\'envoyer de messages. Tu peux le débloquer à tout moment depuis ton profil.';
  }

  @override
  String userBlockedToast(String name) {
    return 'Tu as bloqué $name.';
  }

  @override
  String get deleteAccountLabel => 'Supprimer mon compte';

  @override
  String get deleteAccountConfirmTitle => 'Supprimer ton compte ?';

  @override
  String get deleteAccountConfirmMessage =>
      'Ton compte sera désactivé et tu seras déconnecté. Tes commentaires et messages existants ne seront pas supprimés.';

  @override
  String get deleteAccountConfirmButton => 'Supprimer le compte';
}
