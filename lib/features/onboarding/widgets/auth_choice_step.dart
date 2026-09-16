import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../app_state/repository_providers.dart';
import '../../../core/routing/route_paths.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radii.dart';
import '../../../core/widgets/app_toast.dart';
import '../../../core/widgets/pill_button.dart';
import '../../../domain/repositories/auth_repository.dart';
import '../../../l10n/app_localizations.dart';

/// "Access your account" step of onboarding: email + password sign-in
/// fields are visible immediately, with Google offered as an alternative
/// below a divider. "I don't have an account" hands off to the separate
/// [AccountCreationStep] rather than morphing this widget in place.
class AuthChoiceStep extends ConsumerStatefulWidget {
  const AuthChoiceStep({super.key, required this.onCreateAccount});

  final VoidCallback onCreateAccount;

  @override
  ConsumerState<AuthChoiceStep> createState() => _AuthChoiceStepState();
}

class _AuthChoiceStepState extends ConsumerState<AuthChoiceStep> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _signingIn = false;
  bool _googleSigningIn = false;
  String? _errorText;

  bool get _busy => _signingIn || _googleSigningIn;
  bool get _canSignIn =>
      _emailController.text.trim().isNotEmpty && _passwordController.text.length >= 6;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    if (!_canSignIn || _busy) return;
    setState(() {
      _signingIn = true;
      _errorText = null;
    });

    final result = await ref.read(authRepositoryProvider).signInWithEmail(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
    if (!mounted) return;

    if (result.isSuccess) {
      context.go(RoutePaths.map);
      return;
    }
    final l10n = AppLocalizations.of(context)!;
    setState(() {
      _signingIn = false;
      _errorText = result.failureReason == SignInFailureReason.invalidCredentials
          ? l10n.invalidCredentialsError
          : l10n.genericErrorRetry;
    });
  }

  Future<void> _continueWithGoogle() async {
    if (_busy) return;
    setState(() => _googleSigningIn = true);
    try {
      await ref.read(authRepositoryProvider).signInWithGoogle();
      if (mounted) context.go(RoutePaths.map);
    } on GoogleSignInException catch (e) {
      if (!mounted) return;
      setState(() => _googleSigningIn = false);
      // User closing the picker is normal, not an error worth surfacing.
      if (e.code != GoogleSignInExceptionCode.canceled) {
        showAppToast(context, AppLocalizations.of(context)!.googleSignInFailed);
      }
    } catch (_) {
      if (!mounted) return;
      setState(() => _googleSigningIn = false);
      showAppToast(context, AppLocalizations.of(context)!.googleSignInFailed);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.authAccessAccountTitle,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 22),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.signInSubtitle,
            style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            enabled: !_busy,
            decoration: InputDecoration(hintText: l10n.emailHint),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _passwordController,
            obscureText: true,
            enabled: !_busy,
            decoration: InputDecoration(hintText: l10n.passwordHint),
            onChanged: (_) => setState(() {}),
          ),
          if (_errorText != null) ...[
            const SizedBox(height: 10),
            Text(_errorText!, style: const TextStyle(fontSize: 12.5, color: AppColors.danger)),
          ],
          const SizedBox(height: 20),
          PillButton(
            label: _signingIn ? l10n.signingIn : l10n.signIn,
            onPressed: _canSignIn && !_busy ? _signIn : null,
          ),
          const SizedBox(height: 24),
          _OrDivider(label: l10n.orDividerLabel),
          const SizedBox(height: 20),
          _GoogleButton(
            loading: _googleSigningIn,
            onPressed: _busy ? null : _continueWithGoogle,
          ),
          const SizedBox(height: 20),
          Center(
            child: TextButton(
              onPressed: _busy ? null : widget.onCreateAccount,
              style: TextButton.styleFrom(foregroundColor: AppColors.accent),
              child: Text(
                l10n.noAccountCreateOne,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Thin "or" separator between the email form and the Google alternative.
class _OrDivider extends StatelessWidget {
  const _OrDivider({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: AppColors.border, thickness: 1)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textFaint,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const Expanded(child: Divider(color: AppColors.border, thickness: 1)),
      ],
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
