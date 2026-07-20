import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/extensions/context_extensions.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../../shared/widgets/primary_button.dart';
import '../controllers/reviews_controller.dart';

/// Bottom sheet to submit a rating + review for a listing. Pops `true` on success.
class WriteReviewSheet extends ConsumerStatefulWidget {
  const WriteReviewSheet({super.key, required this.listingId});

  final int listingId;

  static Future<bool?> show(BuildContext context, int listingId) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (_) => WriteReviewSheet(listingId: listingId),
    );
  }

  @override
  ConsumerState<WriteReviewSheet> createState() => _WriteReviewSheetState();
}

class _WriteReviewSheetState extends ConsumerState<WriteReviewSheet> {
  final _body = TextEditingController();
  int _rating = 0;
  bool _submitting = false;

  @override
  void dispose() {
    _body.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_rating == 0) {
      context.showSnack('Tap a star to rate', error: true);
      return;
    }
    setState(() => _submitting = true);
    try {
      await ref
          .read(reviewServiceProvider)
          .submit(widget.listingId, _rating, _body.text.trim());
      if (!mounted) return;
      ref.invalidate(listingReviewsProvider(widget.listingId));
      Navigator.pop(context, true);
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
          const Text('Write a review', style: AppTextStyles.headingMd),
          AppSpacing.vGapLg,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var i = 1; i <= 5; i++)
                IconButton(
                  onPressed: () => setState(() => _rating = i),
                  icon: Icon(
                    i <= _rating
                        ? Icons.star_rounded
                        : Icons.star_border_rounded,
                    size: 36,
                    color: AppColors.rating,
                  ),
                ),
            ],
          ),
          AppSpacing.vGapLg,
          AppTextField(
            label: 'Your review (optional)',
            hint: 'Share details of your experience',
            controller: _body,
            maxLines: 4,
          ),
          AppSpacing.vGapXl,
          PrimaryButton(
            label: 'Submit review',
            isLoading: _submitting,
            onPressed: _submit,
          ),
        ],
      ),
    );
  }
}
