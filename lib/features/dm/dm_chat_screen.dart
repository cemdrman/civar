import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app_state/messaging_providers.dart';
import '../../app_state/repository_providers.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_radii.dart';
import '../../core/widgets/app_toast.dart';
import '../../core/widgets/avatar_initials.dart';
import '../../domain/models/dm_thread.dart';
import '../../l10n/app_localizations.dart';
import 'widgets/message_bubble.dart';

class DmChatScreen extends ConsumerStatefulWidget {
  const DmChatScreen({super.key, required this.threadId});

  final String threadId;

  @override
  ConsumerState<DmChatScreen> createState() => _DmChatScreenState();
}

class _DmChatScreenState extends ConsumerState<DmChatScreen> {
  final _inputController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(messagingRepositoryProvider).markThreadRead(widget.threadId));
  }

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final text = _inputController.text.trim();
    if (text.isEmpty) return;
    _inputController.clear();
    await ref
        .read(messagingRepositoryProvider)
        .sendMessage(threadId: widget.threadId, text: text);
  }

  Future<void> _confirmBlock(DmThread thread) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.blockUserConfirmTitle),
        content: Text(l10n.blockUserConfirmMessage(thread.participantName)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.blockUserAction, style: const TextStyle(color: AppColors.danger)),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    await ref.read(authRepositoryProvider).blockUser(thread.participantId);
    if (!mounted) return;
    Navigator.of(context).maybePop();
    showAppToast(context, l10n.userBlockedToast(thread.participantName));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final threads = ref.watch(dmThreadsStreamProvider).value ?? const [];
    final thread = threads.where((t) => t.id == widget.threadId).firstOrNull;
    final messagesAsync = ref.watch(dmMessagesProvider(widget.threadId));

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: AppColors.border)),
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).maybePop(),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                      child: Icon(Icons.arrow_back, size: 20),
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (thread != null) ...[
                    AvatarInitials(
                      initials: thread.participantInitials,
                      colorSeed: thread.avatarColorSeed,
                      size: 34,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        thread.participantName,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                      ),
                    ),
                    IconButton(
                      onPressed: () => _confirmBlock(thread),
                      tooltip: l10n.blockUserAction,
                      icon: const Icon(Icons.block, size: 20, color: AppColors.textSecondary),
                    ),
                  ],
                ],
              ),
            ),
            Expanded(
              child: messagesAsync.when(
                data: (messages) => ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: messages.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 10),
                  itemBuilder: (context, index) => MessageBubble(message: messages[index]),
                ),
                error: (err, st) => Center(child: Text(l10n.streamError(err))),
                loading: () => const Center(child: CircularProgressIndicator()),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: const BoxDecoration(
                color: AppColors.surface,
                border: Border(top: BorderSide(color: AppColors.border)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _inputController,
                      decoration: InputDecoration(
                        hintText: l10n.writeMessageHint,
                        filled: true,
                        fillColor: AppColors.surface2,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppRadii.pill),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onSubmitted: (_) => _send(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: _send,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(color: AppColors.accent, shape: BoxShape.circle),
                      child: const Icon(Icons.arrow_upward, color: Colors.white, size: 16),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
