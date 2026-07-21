import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/constants/countries.dart';
import '../../core/theme/app_radius.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_text_styles.dart';

/// Phone-number field with a country dial-code + flag picker.
///
/// Mirrors the web `PhoneInput` component: the user picks a country (flag +
/// `+dial`) and types the local number; the widget keeps a single combined
/// value like `+8801711223344` in [controller], so callers read
/// `controller.text` exactly as before — no API changes needed.
class PhoneField extends StatefulWidget {
  const PhoneField({
    super.key,
    required this.controller,
    this.label,
    this.hint,
    this.enabled = true,
    this.textInputAction,
    this.validator,
    this.initialIso = Countries.defaultIso,
  });

  /// Holds the combined `+<dial><local>` value (empty when no number entered).
  final TextEditingController controller;
  final String? label;
  final String? hint;
  final bool enabled;
  final TextInputAction? textInputAction;

  /// Receives the combined value, so existing [Validators.phone] works.
  final String? Function(String?)? validator;

  /// ISO alpha-2 code selected initially when [controller] starts empty.
  final String initialIso;

  @override
  State<PhoneField> createState() => _PhoneFieldState();
}

class _PhoneFieldState extends State<PhoneField> {
  final _local = TextEditingController();
  late Country _country;

  @override
  void initState() {
    super.initState();
    final existing = widget.controller.text.trim();
    if (existing.isEmpty) {
      _country = Countries.byIso(widget.initialIso);
    } else {
      final parts = Countries.split(existing);
      _country = parts.country;
      _local.text = parts.local;
    }
  }

  @override
  void dispose() {
    _local.dispose();
    super.dispose();
  }

  void _syncCombined() {
    final digits = _local.text.replaceAll(RegExp(r'\D'), '');
    widget.controller.text =
        digits.isEmpty ? '' : '+${_country.dialCode}$digits';
  }

  Future<void> _pickCountry() async {
    FocusScope.of(context).unfocus();
    final selected = await showModalBottomSheet<Country>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => _CountryPickerSheet(selectedIso: _country.iso),
    );
    if (selected != null && selected.iso != _country.iso) {
      setState(() => _country = selected);
      _syncCombined();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(widget.label!, style: AppTextStyles.label),
          AppSpacing.vGapSm,
        ],
        TextFormField(
          controller: _local,
          enabled: widget.enabled,
          keyboardType: TextInputType.phone,
          textInputAction: widget.textInputAction,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          onChanged: (_) => _syncCombined(),
          validator: (_) => widget.validator?.call(widget.controller.text),
          style: AppTextStyles.bodyMd
              .copyWith(color: Theme.of(context).colorScheme.onSurface),
          decoration: InputDecoration(
            hintText: widget.hint,
            prefixIcon: _CountrySelector(
              country: _country,
              onTap: widget.enabled ? _pickCountry : null,
            ),
            prefixIconConstraints: const BoxConstraints(),
          ),
        ),
      ],
    );
  }
}

/// The tappable flag + dial-code button shown inside the field.
class _CountrySelector extends StatelessWidget {
  const _CountrySelector({required this.country, this.onTap});

  final Country country;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    return InkWell(
      onTap: onTap,
      borderRadius: AppRadius.brSm,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.md,
          AppSpacing.sm,
          AppSpacing.md,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(country.flag, style: const TextStyle(fontSize: 20)),
            AppSpacing.hGapSm,
            Text(
              '+${country.dialCode}',
              style: AppTextStyles.bodyMd.copyWith(
                color: onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
            Icon(Icons.arrow_drop_down_rounded,
                color: onSurface.withValues(alpha: 0.6)),
            Container(
              width: 1,
              height: 22,
              margin: const EdgeInsets.only(left: AppSpacing.xs),
              color: Theme.of(context).dividerColor,
            ),
          ],
        ),
      ),
    );
  }
}

/// Searchable country list shown in a bottom sheet.
class _CountryPickerSheet extends StatefulWidget {
  const _CountryPickerSheet({required this.selectedIso});

  final String selectedIso;

  @override
  State<_CountryPickerSheet> createState() => _CountryPickerSheetState();
}

class _CountryPickerSheetState extends State<_CountryPickerSheet> {
  final _search = TextEditingController();
  List<Country> _results = Countries.all;

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  void _onQuery(String q) => setState(() => _results = Countries.search(q));

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.72,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                0,
                AppSpacing.lg,
                AppSpacing.md,
              ),
              child: TextField(
                controller: _search,
                autofocus: true,
                onChanged: _onQuery,
                textInputAction: TextInputAction.search,
                decoration: const InputDecoration(
                  hintText: 'Search country or code',
                  prefixIcon: Icon(Icons.search_rounded),
                ),
              ),
            ),
            Expanded(
              child: _results.isEmpty
                  ? Center(
                      child: Text('No countries found',
                          style: AppTextStyles.bodyMd.copyWith(
                              color: onSurface.withValues(alpha: 0.5))),
                    )
                  : ListView.builder(
                      itemCount: _results.length,
                      itemBuilder: (context, i) {
                        final c = _results[i];
                        final selected = c.iso == widget.selectedIso;
                        return ListTile(
                          leading: Text(c.flag,
                              style: const TextStyle(fontSize: 24)),
                          title: Text(c.name, style: AppTextStyles.bodyMd),
                          trailing: Text(
                            '+${c.dialCode}',
                            style: AppTextStyles.bodyMd.copyWith(
                              color: onSurface.withValues(alpha: 0.7),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          selected: selected,
                          onTap: () => Navigator.of(context).pop(c),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
