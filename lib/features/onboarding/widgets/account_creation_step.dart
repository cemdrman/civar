import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app_state/repository_providers.dart';
import '../../../core/routing/route_paths.dart';
import '../../../core/widgets/pill_button.dart';

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

  bool get _canSubmit =>
      _nameController.text.trim().isNotEmpty && _emailController.text.trim().isNotEmpty;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_canSubmit || _submitting) return;
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
          Text('Hesap oluştur', style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 22)),
          const SizedBox(height: 6),
          const Text(
            'Gerçek adınla katıl, çevrendekilerle tanış.',
            style: TextStyle(fontSize: 14, color: Colors.black54),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(hintText: 'Ad Soyad'),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(hintText: 'E-posta'),
            onChanged: (_) => setState(() {}),
          ),
          const Spacer(),
          PillButton(
            label: 'Hesap oluştur ve gir',
            onPressed: _canSubmit && !_submitting ? _submit : null,
          ),
        ],
      ),
    );
  }
}
