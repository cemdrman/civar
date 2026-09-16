// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get cancel => 'Cancelar';

  @override
  String get save => 'Salvar';

  @override
  String get genericErrorRetry => 'Algo deu errado, tente novamente.';

  @override
  String streamError(Object error) {
    return 'Algo deu errado: $error';
  }

  @override
  String get commentPosted => 'Seu comentário foi fixado no local.';

  @override
  String get unlimitedRadius => 'Ilimitado';

  @override
  String radiusSuffix(String radius) {
    return 'Raio de $radius';
  }

  @override
  String get exploreLabel => 'Explorar';

  @override
  String get mapLabel => 'Mapa';

  @override
  String get messagesLabel => 'Mensagens';

  @override
  String get profileLabel => 'Perfil';

  @override
  String get editProfile => 'Editar perfil';

  @override
  String get onboardingTagline =>
      'O que está realmente acontecendo ao seu redor? Veja e participe dos comentários, só onde você está.';

  @override
  String get onboardingStart => 'Começar';

  @override
  String get authAccessAccountTitle => 'Acesse sua conta';

  @override
  String get continueWithGoogle => 'Continuar com o Google';

  @override
  String get googleSignInFailed =>
      'Não foi possível entrar com o Google, tente novamente.';

  @override
  String get createAccountTitle => 'Criar conta';

  @override
  String get createAccountSubtitle =>
      'Adicione suas informações abaixo e criamos sua conta em segundos.';

  @override
  String get signInSubtitle =>
      'Entre se você já tem uma conta, ou crie uma nova abaixo.';

  @override
  String get fullNameHint => 'Nome completo';

  @override
  String get emailHint => 'E-mail';

  @override
  String get passwordHint => 'Senha (mínimo de 6 caracteres)';

  @override
  String get invalidCredentialsError =>
      'E-mail ou senha incorretos, ou você não tem uma conta.';

  @override
  String get accountCreationFailed =>
      'Não foi possível criar a conta. O e-mail já pode estar cadastrado.';

  @override
  String get createAccountAndEnter => 'Criar conta e entrar';

  @override
  String get signingIn => 'Entrando...';

  @override
  String get signIn => 'Entrar';

  @override
  String get noAccountCreateOne => 'Não tenho conta, quero criar uma';

  @override
  String get locationPermissionIllustrationLabel =>
      'ILUSTRAÇÃO DE PERMISSÃO DE LOCALIZAÇÃO';

  @override
  String get locationNeededTitle => 'Precisamos da sua localização';

  @override
  String locationPermissionExplainer(String radius) {
    return 'O Civar mostra apenas comentários dentro de um raio de $radius. Você só pode aumentar esse raio com uma assinatura mensal.';
  }

  @override
  String get allowLocationAccess => 'Permitir minha localização';

  @override
  String get notNow => 'Agora não';

  @override
  String get noCommentsInRadius => 'Ainda não há comentários nesse raio.';

  @override
  String get feedSubtitle => 'Comentários recentes ao seu redor';

  @override
  String get mapPlaceholderLabel =>
      'VISUALIZAÇÃO DO MAPA · camada de densidade';

  @override
  String get noCommentsYetWriteFirst =>
      'Ainda não há comentários, seja o primeiro a escrever.';

  @override
  String viewCommentsCount(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ver $countString comentários',
      one: 'Ver $countString comentário',
    );
    return '$_temp0';
  }

  @override
  String get newCommentTitle => 'Novo comentário';

  @override
  String get shareAction => 'Publicar';

  @override
  String currentlyAt(String place) {
    return 'Agora em: $place';
  }

  @override
  String get composeHint =>
      'O que está acontecendo aqui? Fixe seu pensamento neste local...';

  @override
  String get addPhotoVideo => '+ ADICIONAR FOTO / VÍDEO';

  @override
  String get photoVideoLabel => 'FOTO / VÍDEO';

  @override
  String get whatToAddTitle => 'O que você quer adicionar?';

  @override
  String get choosePhoto => 'Escolher foto';

  @override
  String get choosePhotoHint => 'jpg, png, webp, heic · máx. 10 MB';

  @override
  String get chooseVideo => 'Escolher vídeo';

  @override
  String get chooseVideoHint => 'mp4, mov · máx. 50 MB';

  @override
  String get placePhotoLabel => 'FOTO DO LOCAL';

  @override
  String placeDetailMeta(String category, String distance, int count) {
    return '$category · $distance km · $count comentários';
  }

  @override
  String get writeCommentHint => 'Escreva um comentário para este local...';

  @override
  String get replyLockedMessage =>
      'Você precisa estar perto deste local para responder';

  @override
  String get reportThanks =>
      'Obrigado por denunciar, nossa equipe vai analisar.';

  @override
  String get reportThisComment => 'Denunciar este comentário';

  @override
  String currentPlanLabel(String tier) {
    return 'Plano $tier';
  }

  @override
  String get addBio => 'Adicione uma bio';

  @override
  String get statComments => 'Comentários';

  @override
  String get statLikes => 'Curtidas';

  @override
  String get statPlaces => 'Locais';

  @override
  String activeRadiusLabel(String radius) {
    return 'Raio de $radius ativo';
  }

  @override
  String get managePlanSubtitle => 'Gerencie ou faça upgrade do seu plano';

  @override
  String get yourCommentsTitle => 'Seus comentários';

  @override
  String get notifications => 'Notificações';

  @override
  String get privacy => 'Privacidade';

  @override
  String get blockedUsers => 'Bloqueados';

  @override
  String get signOut => 'Sair';

  @override
  String get languageSettingsLabel => 'Idioma';

  @override
  String get languagePickerTitle => 'Escolher idioma';

  @override
  String get devChangeLocation => 'Dev: alterar localização';

  @override
  String get photoUploadFailed =>
      'Não foi possível enviar a foto, tente novamente.';

  @override
  String get profileUpdated => 'Seu perfil foi atualizado.';

  @override
  String get changeProfilePhoto => 'Alterar foto de perfil';

  @override
  String get bioLabel => 'Bio';

  @override
  String get bioHint => 'Conte um pouco sobre você...';

  @override
  String get bioLinkNotAllowed =>
      'Você não pode compartilhar um link na sua bio.';

  @override
  String get whoToMessageTitle => 'Com quem você quer falar?';

  @override
  String get newMessage => 'Nova mensagem';

  @override
  String get freeTierDmLockedMessage =>
      'Membros gratuitos não podem iniciar novas conversas, mas podem responder a mensagens recebidas.';

  @override
  String get writeMessageHint => 'Escreva uma mensagem...';

  @override
  String get expandYourRadius => 'Amplie seu raio';

  @override
  String get paywallExplainer =>
      'Faça upgrade para ver e responder comentários em um raio maior, além de enviar mensagens para outras pessoas.';

  @override
  String get firstMonthDiscountBanner =>
      '🎉 Especial para sua primeira assinatura: 50% de desconto em todos os planos no primeiro mês!';

  @override
  String get checkingEllipsis => 'Verificando...';

  @override
  String get restorePurchases => 'Restaurar compras';

  @override
  String planDowngraded(String tier) {
    return 'Seu plano foi rebaixado para $tier.';
  }

  @override
  String planUpgraded(String tier) {
    return 'Seu plano foi atualizado para $tier.';
  }

  @override
  String get purchaseNotCompleted => 'Não foi possível concluir a compra.';

  @override
  String get noPurchasesToRestore =>
      'Nenhuma compra encontrada para restaurar.';

  @override
  String get firstMonthDiscountTag => '50% de desconto no primeiro mês';

  @override
  String get currentPlanBadge => 'Seu plano atual';

  @override
  String get purchasing => 'Comprando...';

  @override
  String get switchToThisPlan => 'Mudar para este plano';

  @override
  String replyCountLabel(num count) {
    final intl.NumberFormat countNumberFormat = intl.NumberFormat.compact(
      locale: localeName,
    );
    final String countString = countNumberFormat.format(count);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countString respostas',
      one: '$countString resposta',
    );
    return '$_temp0 · Responder';
  }

  @override
  String get movedAwayFromLocation => 'Você se afastou deste local';

  @override
  String placeTagDistance(String place, String distance) {
    return '$place · $distance km';
  }

  @override
  String get orDividerLabel => 'ou';

  @override
  String get noOwnPostsYet => 'Você ainda não fez nenhum comentário.';

  @override
  String get blockedUsersScreenTitle => 'Usuários bloqueados';

  @override
  String get noBlockedUsersMessage => 'Você ainda não bloqueou ninguém.';

  @override
  String get blockUserAction => 'Bloquear';

  @override
  String get unblockUserAction => 'Desbloquear';

  @override
  String get blockUserConfirmTitle => 'Bloquear este usuário?';

  @override
  String blockUserConfirmMessage(String name) {
    return '$name não poderá mais te enviar mensagens. Você pode desbloquear a qualquer momento pelo seu perfil.';
  }

  @override
  String userBlockedToast(String name) {
    return 'Você bloqueou $name.';
  }

  @override
  String get deleteAccountLabel => 'Excluir minha conta';

  @override
  String get deleteAccountConfirmTitle => 'Excluir sua conta?';

  @override
  String get deleteAccountConfirmMessage =>
      'Sua conta será desativada e você será desconectado. Seus comentários e mensagens existentes não serão excluídos.';

  @override
  String get deleteAccountConfirmButton => 'Excluir conta';
}
