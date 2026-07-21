import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/utils/formatters.dart';
import '../../../shared/extensions/context_extensions.dart';
import '../models/property_model.dart';

/// Affordability tools for a listing. Adapts to the listing type:
/// a mortgage (EMI) estimator for sale/land, or a move-in cost + income
/// guideline for rentals. Fully client-side — no API calls.
class AffordabilitySheet extends StatefulWidget {
  const AffordabilitySheet({super.key, required this.property});

  final PropertyModel property;

  static Future<void> show(BuildContext context, PropertyModel property) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => AffordabilitySheet(property: property),
    );
  }

  @override
  State<AffordabilitySheet> createState() => _AffordabilitySheetState();
}

class _AffordabilitySheetState extends State<AffordabilitySheet> {
  late final bool _isSale = widget.property.type.pricePeriod.isEmpty;
  late final TextEditingController _amount = TextEditingController(
    text: (widget.property.price ?? 0).round().toString(),
  );

  // Sale inputs.
  double _downPct = 20;
  double _rate = 9;
  double _years = 20;

  // Rent inputs.
  late double _advanceMonths =
      (widget.property.advanceMonths ?? 2).toDouble().clamp(0, 12);

  @override
  void dispose() {
    _amount.dispose();
    super.dispose();
  }

  double get _base => double.tryParse(_amount.text.trim()) ?? 0;
  String? get _currency => widget.property.currency;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: DraggableScrollableSheet(
        initialChildSize: 0.72,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => Column(
          children: [
            const _Grabber(),
            Expanded(
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.fromLTRB(
                    AppSpacing.xl, 0, AppSpacing.xl, AppSpacing.xl),
                children: [
                  Text(
                    _isSale ? 'Mortgage calculator' : 'Rent calculator',
                    style: AppTextStyles.headingLg,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _isSale
                        ? 'Estimate your monthly repayment.'
                        : 'Estimate your move-in cost and income guideline.',
                    style: AppTextStyles.bodyMd
                        .copyWith(color: AppColors.textSecondary),
                  ),
                  AppSpacing.vGapXl,
                  _AmountField(
                    label: _isSale ? 'Property price' : 'Monthly rent',
                    controller: _amount,
                    currency: _currency,
                    onChanged: () => setState(() {}),
                  ),
                  AppSpacing.vGapLg,
                  if (_isSale) ..._saleInputs() else ..._rentInputs(),
                  AppSpacing.vGapXl,
                  _isSale ? _saleResult() : _rentResult(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --------------------------------------------------------------------------
  // Sale (mortgage / EMI)
  // --------------------------------------------------------------------------
  List<Widget> _saleInputs() => [
        _SliderRow(
          label: 'Down payment',
          valueLabel: '${_downPct.round()}%',
          value: _downPct,
          min: 0,
          max: 50,
          divisions: 50,
          onChanged: (v) => setState(() => _downPct = v),
        ),
        _SliderRow(
          label: 'Interest rate',
          valueLabel: '${_rate.toStringAsFixed(2)}%',
          value: _rate,
          min: 1,
          max: 18,
          divisions: 68,
          onChanged: (v) => setState(() => _rate = v),
        ),
        _SliderRow(
          label: 'Loan tenure',
          valueLabel: '${_years.round()} yr',
          value: _years,
          min: 1,
          max: 30,
          divisions: 29,
          onChanged: (v) => setState(() => _years = v),
        ),
      ];

  Widget _saleResult() {
    final downAmount = _base * _downPct / 100;
    final principal = _base - downAmount;
    final n = _years * 12;
    final r = _rate / 1200;
    final double emi;
    if (r == 0) {
      emi = n == 0 ? 0 : principal / n;
    } else {
      final pow = math.pow(1 + r, n);
      emi = principal * r * pow / (pow - 1);
    }
    final totalPayable = emi * n;
    final totalInterest = totalPayable - principal;

    return _ResultPanel(
      headline: 'Monthly payment',
      headlineValue: Formatters.money(emi.round(), currency: _currency),
      rows: [
        ('Down payment', Formatters.money(downAmount.round(), currency: _currency)),
        ('Loan amount', Formatters.money(principal.round(), currency: _currency)),
        ('Total interest',
            Formatters.money(totalInterest.round(), currency: _currency)),
        ('Total payable',
            Formatters.money(totalPayable.round(), currency: _currency)),
      ],
    );
  }

  // --------------------------------------------------------------------------
  // Rent (move-in cost + income guideline)
  // --------------------------------------------------------------------------
  List<Widget> _rentInputs() => [
        _SliderRow(
          label: 'Advance / deposit',
          valueLabel: _advanceMonths.round() == 1
              ? '1 month'
              : '${_advanceMonths.round()} months',
          value: _advanceMonths,
          min: 0,
          max: 12,
          divisions: 12,
          onChanged: (v) => setState(() => _advanceMonths = v),
        ),
      ];

  Widget _rentResult() {
    final rent = _base;
    final deposit = rent * _advanceMonths;
    final serviceCharge = (widget.property.serviceCharge ?? 0).toDouble();
    final moveIn = deposit + rent + serviceCharge;
    // 30%-of-income guideline.
    final recommendedIncome = rent / 0.30;

    return _ResultPanel(
      headline: 'Move-in cost',
      headlineValue: Formatters.money(moveIn.round(), currency: _currency),
      rows: [
        ('Deposit (${_advanceMonths.round()} mo)',
            Formatters.money(deposit.round(), currency: _currency)),
        ('First month rent',
            Formatters.money(rent.round(), currency: _currency)),
        if (serviceCharge > 0)
          ('Service charge',
              Formatters.money(serviceCharge.round(), currency: _currency)),
        ('Suggested income /mo',
            Formatters.money(recommendedIncome.round(), currency: _currency)),
      ],
    );
  }
}

class _Grabber extends StatelessWidget {
  const _Grabber();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      height: 4,
      width: 40,
      decoration: BoxDecoration(
        color: context.colors.outline,
        borderRadius: AppRadius.brPill,
      ),
    );
  }
}

class _AmountField extends StatelessWidget {
  const _AmountField({
    required this.label,
    required this.controller,
    required this.currency,
    required this.onChanged,
  });

  final String label;
  final TextEditingController controller;
  final String? currency;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.titleSm),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          onChanged: (_) => onChanged(),
          style: AppTextStyles.titleMd.copyWith(color: context.colors.onSurface),
          decoration: InputDecoration(
            prefixText: currency != null ? '$currency ' : null,
            prefixStyle: AppTextStyles.titleMd
                .copyWith(color: AppColors.textSecondary),
          ),
        ),
      ],
    );
  }
}

class _SliderRow extends StatelessWidget {
  const _SliderRow({
    required this.label,
    required this.valueLabel,
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.onChanged,
  });

  final String label;
  final String valueLabel;
  final double value;
  final double min;
  final double max;
  final int divisions;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(label, style: AppTextStyles.titleSm),
            const Spacer(),
            Text(valueLabel,
                style: AppTextStyles.titleSm
                    .copyWith(color: AppColors.primary)),
          ],
        ),
        Slider(
          value: value.clamp(min, max),
          min: min,
          max: max,
          divisions: divisions,
          onChanged: onChanged,
        ),
      ],
    );
  }
}

class _ResultPanel extends StatelessWidget {
  const _ResultPanel({
    required this.headline,
    required this.headlineValue,
    required this.rows,
  });

  final String headline;
  final String headlineValue;
  final List<(String, String)> rows;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: const BoxDecoration(
        gradient: AppColors.heroGradient,
        borderRadius: AppRadius.brXl,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(headline,
              style: AppTextStyles.bodySm
                  .copyWith(color: Colors.white.withValues(alpha: 0.7))),
          const SizedBox(height: 4),
          Text(headlineValue,
              style: AppTextStyles.displayLarge
                  .copyWith(color: Colors.white, fontSize: 30)),
          const SizedBox(height: AppSpacing.lg),
          Divider(color: Colors.white.withValues(alpha: 0.18), height: 1),
          const SizedBox(height: AppSpacing.md),
          for (final row in rows)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Row(
                children: [
                  Text(row.$1,
                      style: AppTextStyles.bodyMd.copyWith(
                          color: Colors.white.withValues(alpha: 0.8))),
                  const Spacer(),
                  Text(row.$2,
                      style: AppTextStyles.titleSm
                          .copyWith(color: Colors.white)),
                ],
              ),
            ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Estimates only. Actual figures may vary.',
            style: AppTextStyles.caption
                .copyWith(color: Colors.white.withValues(alpha: 0.6)),
          ),
        ],
      ),
    );
  }
}
