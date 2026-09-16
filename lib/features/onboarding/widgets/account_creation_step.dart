import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app_state/repository_providers.dart';
import '../../../core/routing/route_paths.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/pill_button.dart';
import '../../../l10n/app_localizations.dart';

/// Registration step of onboarding — a plain full name + email + password
/// form. Reached only via "I don't have an account" on [AuthChoiceStep];
/// sign-in itself lives entirely on that earlier step.
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
  String? _errorText;

  bool get _canRegister =>
      _nameController.text.trim().isNotEmpty &&
      _emailController.text.trim().isNotEmpty &&
      _passwordController.text.length >= 6;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
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
        _errorText = AppLocalizations.of(context)!.accountCreationFailed;
      });
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
          GestureDetector(
            onTap: widget.onBack,
            child: const Padding(
              padding: EdgeInsets.only(bottom: 8),
              child: Icon(Icons.arrow_back, size: 20),
            ),
          ),
          Text(
            l10n.createAccountTitle,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 22),
          ),
          const SizedBox(height: 6),
          Text(
            l10n.createAccountSubtitle,
            style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _nameController,
            autofocus: true,
            enabled: !_submitting,
            decoration: InputDecoration(hintText: l10n.fullNameHint),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            enabled: !_submitting,
            decoration: InputDecoration(hintText: l10n.emailHint),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _passwordController,
            obscureText: true,
            enabled: !_submitting,
            decoration: InputDecoration(hintText: l10n.passwordHint),
            onChanged: (_) => setState(() {}),
          ),
          if (_errorText != null) ...[
            const SizedBox(height: 10),
            Text(_errorText!, style: const TextStyle(fontSize: 12.5, color: AppColors.danger)),
          ],
          const SizedBox(height: 24),
          PillButton(
            label: l10n.createAccountAndEnter,
            onPressed: _canRegister && !_submitting ? _register : null,
          ),
        ],
      ),
    );
  }
}
