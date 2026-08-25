import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app_state/repository_providers.dart';
import '../../../core/routing/route_paths.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/pill_button.dart';

/// Email step of onboarding — doubles as sign-in and sign-up. First checks
/// whether an account already exists for the entered email and signs into
/// it if so; only when no account is found does it reveal the name field to
/// complete registration.
class AccountCreationStep extends ConsumerStatefulWidget {
  const AccountCreationStep({super.key, required this.onBack});

  final VoidCallback onBack;

  @override
  ConsumerState<AccountCreationStep> createState() => _AccountCreationStepState();
}

class _AccountCreationStepState extends ConsumerState<AccountCreationStep> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  bool _submitting = false;
  bool _accountNotFound = false;

  bool get _canContinueWithEmail => _emailController.text.trim().isNotEmpty;
  bool get _canCreateAccount =>
      _nameController.text.trim().isNotEmpty && _emailController.text.trim().isNotEmpty;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _continueWithEmail() async {
    if (!_canContinueWithEmail || _submitting) return;
    setState(() => _submitting = true);

    final email = _emailController.text.trim();
    final existing = await ref.read(authRepositoryProvider).signInIfAccountExists(email: email);
    if (!mounted) return;

    if (existing != null) {
      context.go(RoutePaths.map);
      return;
    }
    setState(() {
      _submitting = false;
      _accountNotFound = true;
    });
  }

  Future<void> _createAccount() async {
    if (!_canCreateAccount || _submitting) return;
    setState(() => _submitting = true);
    await ref.read(authRepositoryProvider).createAccount(
          fullName: _nameController.text.trim(),
          email: _emailController.text.trim(),
        );
    if (mounted) context.go(RoutePaths.map);
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
            _accountNotFound ? 'Hesap oluştur' : 'E-posta ile devam et',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 22),
          ),
          const SizedBox(height: 6),
          Text(
            _accountNotFound
                ? 'Bu e-posta için hesap bulunamadı. Yeni hesap oluşturalım.'
                : 'Zaten hesabın varsa e-postanla giriş yap, yoksa yeni hesap oluşturalım.',
            style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 20),
          if (_accountNotFound) ...[
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
            enabled: !_accountNotFound,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(hintText: 'E-posta'),
            onChanged: (_) => setState(() {}),
          ),
          const Spacer(),
          PillButton(
            label: _accountNotFound
                ? 'Hesap oluştur ve gir'
                : (_submitting ? 'Kontrol ediliyor...' : 'Devam et'),
            onPressed: _accountNotFound
                ? (_canCreateAccount && !_submitting ? _createAccount : null)
                : (_canContinueWithEmail && !_submitting ? _continueWithEmail : null),
          ),
        ],
      ),
    );
  }
}
