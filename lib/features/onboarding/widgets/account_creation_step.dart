import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app_state/repository_providers.dart';
import '../../../core/routing/route_paths.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/pill_button.dart';
import '../../../domain/repositories/auth_repository.dart';

/// Email step of onboarding — doubles as sign-in and sign-up. Firebase's
/// email-enumeration protection means we can't check in advance whether an
/// email is registered, so this always tries a sign-in first; only on
/// failure does it reveal the name field to register instead.
class AccountCreationStep extends ConsumerStatefulWidget {
  const AccountCreationStep({super.key, required this.onBack});

  final VoidCallback onBack;

  @override
  ConsumerState<AccountCreationStep> createState() => _AccountCreationStepState();
}

class _AccountCreationStepState extends ConsumerState<AccountCreationStep> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _submitting = false;
  bool _offerRegistration = false;
  String? _errorText;

  bool get _canSignIn =>
      _emailController.text.trim().isNotEmpty && _passwordController.text.length >= 6;
  bool get _canRegister => _canSignIn && _nameController.text.trim().isNotEmpty;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    if (!_canSignIn || _submitting) return;
    setState(() {
      _submitting = true;
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
    setState(() {
      _submitting = false;
      _offerRegistration = result.failureReason == SignInFailureReason.invalidCredentials;
      _errorText = result.failureReason == SignInFailureReason.invalidCredentials
          ? 'E-posta veya şifre hatalı, ya da hesabın yok.'
          : 'Bir şeyler ters gitti, tekrar dene.';
    });
  }

  Future<void> _register() async {
    if (!_canRegister || _submitting) return;
    setState(() {
      _submitting = true;
      _errorText = null;
    });
    try {
      await ref.read(authRepositoryProvider).createAccount(
            fullName: _nameController.text.trim(),
            email: _emailController.text.trim(),
            password: _passwordController.text,
          );
      if (mounted) context.go(RoutePaths.map);
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _submitting = false;
        _errorText = 'Hesap oluşturulamadı. E-posta zaten kayıtlı olabilir.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: widget.onBack,
            child: const Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Icon(Icons.arrow_back, size: 20),
            ),
          ),
          Text(
            _offerRegistration ? 'Hesap oluştur' : 'E-posta ile devam et',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 22),
          ),
          const SizedBox(height: 6),
          Text(
            _offerRegistration
                ? 'Bu bilgilerle bir hesap yoksa, adını da yazıp yeni hesap oluşturalım.'
                : 'Zaten hesabın varsa giriş yap, yoksa aşağıdan yeni hesap oluşturabilirsin.',
            style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 20),
          if (_offerRegistration) ...[
            TextField(
              controller: _nameController,
              autofocus: true,
              decoration: const InputDecoration(hintText: 'Ad Soyad'),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 12),
          ],
          TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(hintText: 'E-posta'),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: const InputDecoration(hintText: 'Şifre (en az 6 karakter)'),
            onChanged: (_) => setState(() {}),
          ),
          if (_errorText != null) ...[
            const SizedBox(height: 10),
            Text(_errorText!, style: const TextStyle(fontSize: 12.5, color: AppColors.danger)),
          ],
          const Spacer(),
          if (_offerRegistration)
            PillButton(
              label: 'Hesap oluştur ve gir',
              onPressed: _canRegister && !_submitting ? _register : null,
            )
          else ...[
            PillButton(
              label: _submitting ? 'Giriş yapılıyor...' : 'Giriş yap',
              onPressed: _canSignIn && !_submitting ? _signIn : null,
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: _submitting ? null : () => setState(() => _offerRegistration = true),
              child: const Text('Hesabım yok, oluşturmak istiyorum'),
            ),
          ],
        ],
      ),
    );
  }
}
