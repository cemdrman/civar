import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../app_state/repository_providers.dart';
import '../../../core/routing/route_paths.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/widgets/app_toast.dart';
import '../../../l10n/app_localizations.dart';

class AuthChoiceStep extends ConsumerStatefulWidget {
  const AuthChoiceStep({super.key, required this.onChooseEmail});

  final VoidCallback onChooseEmail;

  @override
  ConsumerState<AuthChoiceStep> createState() => _AuthChoiceStepState();
}

class _AuthChoiceStepState extends ConsumerState<AuthChoiceStep> {
  bool _signingIn = false;

  Future<void> _continueWithGoogle() async {
    setState(() => _signingIn = true);
    try {
      await ref.read(authRepositoryProvider).signInWithGoogle();
      if (mounted) context.go(RoutePaths.map);
    } on GoogleSignInException catch (e) {
      if (!mounted) return;
      setState(() => _signingIn = false);
      // User closing the picker is normal, not an error worth surfacing.
      if (e.code != GoogleSignInExceptionCode.canceled) {
        showAppToast(context, AppLocalizations.of(context)!.googleSignInFailed);
      }
    } catch (_) {
      if (!mounted) return;
      setState(() => _signingIn = false);
      showAppToast(context, AppLocalizations.of(context)!.googleSignInFailed);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.authAccessAccountTitle,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 22),
          ),
          const SizedBox(height: 6),
          Text(
            AppLocalizations.of(context)!.authChooseMethodSubtitle,
            style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
          ),
          const Spacer(),
          _GoogleButton(loading: _signingIn, onPressed: _signingIn ? null : _continueWithGoogle),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: _signingIn ? null : widget.onChooseEmail,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.text,
                side: const BorderSide(color: AppColors.border),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadii.pill)),
              ),
              child: Text(
                AppLocalizations.of(context)!.continueWithEmail,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GoogleButton extends StatelessWidget {
  const _GoogleButton({required this.loading, required this.onPressed});

  final bool loading;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: AppColors.text,
          side: const BorderSide(color: AppColors.border),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadii.pill)),
        ),
        child: loading
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(color: AppColors.surface2, shape: BoxShape.circle),
                    child: const Text(
                      'G',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textSecondary),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    AppLocalizations.of(context)!.continueWithGoogle,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
      ),
    );
  }
}
