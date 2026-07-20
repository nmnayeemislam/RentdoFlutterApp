import 'package:intl/intl.dart';

/// Reusable formatting helpers for prices, dates and relative time.
abstract final class Formatters {
  Formatters._();

  static final NumberFormat _currency =
      NumberFormat.currency(symbol: r'$', decimalDigits: 0);
  static final NumberFormat _compact = NumberFormat.compact();

  /// `$355` or `$1,250,000`. Appends [period] such as `/night` when provided.
  static String price(num? value, {String? period}) {
    if (value == null) return 'Price on request';
    final formatted = _currency.format(value);
    return period == null ? formatted : '$formatted /$period';
  }

  static final NumberFormat _decimal = NumberFormat('#,##0');

  /// `USD 50,000` — an amount with an explicit currency code (used by wallet,
  /// plans and packages, which return a raw amount + currency).
  static String money(num? amount, {String? currency}) {
    if (amount == null) return '—';
    final formatted = _decimal.format(amount);
    return currency == null ? formatted : '$currency $formatted';
  }

  static String compact(num? value) =>
      value == null ? '0' : _compact.format(value);

  static String date(DateTime? date) =>
      date == null ? '' : DateFormat('MMM d, yyyy').format(date);

  /// "16 hours ago", "1 week ago".
  static String relative(DateTime? date) {
    if (date == null) return '';
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 1) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours} hours ago';
    if (diff.inDays < 7) return '${diff.inDays} days ago';
    if (diff.inDays < 30) return '${(diff.inDays / 7).floor()} week(s) ago';
    if (diff.inDays < 365) return '${(diff.inDays / 30).floor()} month(s) ago';
    return '${(diff.inDays / 365).floor()} year(s) ago';
  }
}
