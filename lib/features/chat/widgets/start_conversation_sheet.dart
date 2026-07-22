import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/extensions/context_extensions.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../../shared/widgets/primary_button.dart';
import '../viewmodels/chat_viewmodel.dart';

/// Bottom sheet to message a listing owner. Pops the new conversation id
/// (`int`) on success.
class StartConversationSheet extends ConsumerStatefulWidget {
  const StartConversationSheet({super.key, required this.listingId});

  final int listingId;

  static Future<int?> show(BuildContext context, int listingId) {
    return showModalBottomSheet<int>(
      context: context,
      isScrollControlled: true,
      builder: (_) => StartConversationSheet(listingId: listingId),
    );
  }

  @override
  ConsumerState<StartConversationSheet> createState() =>
      _StartConversationSheetState();
}

class _StartConversationSheetState
    extends ConsumerState<StartConversationSheet> {
  late final _message =
      TextEditingController(text: context.l10n.chatDefaultMessage);
  bool _submitting = false;

  @override
  void dispose() {
    _message.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final text = _message.text.trim();
    if (text.isEmpty) {
      context.showSnack(context.l10n.chatWriteMessageFirst, error: true);
      return;
    }
    setState(() => _submitting = true);
    try {
      final id = await ref.read(chatServiceProvider).start(widget.listingId, text);
      if (!mounted) return;
      ref.invalidate(conversationsViewModelProvider);
      Navigator.pop(context, id);
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _submitting = false);
      context.showSnack(e.message, error: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(context.l10n.chatMessageOwnerTitle, style: AppTextStyles.headingMd),
          AppSpacing.vGapLg,
          AppTextField(
            controller: _message,
            maxLines: 4,
            hint: context.l10n.chatYourMessageHint,
          ),
          AppSpacing.vGapXl,
          PrimaryButton(
            label: context.l10n.supportSendMessageBtn,
            isLoading: _submitting,
            onPressed: _send,
          ),
        ],
      ),
    );
  }
}
