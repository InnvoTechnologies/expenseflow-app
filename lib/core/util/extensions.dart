import 'dart:math';

String generateRandomColorHex() {
  final random = Random();
  final colorValue = random.nextInt(0xFFFFFF + 1);
  return '#${colorValue.toRadixString(16).padLeft(6, '0').toUpperCase()}';
}

String getMonthName(int month) {
  const months = <String>[
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  if (month < 1 || month > 12) return '';
  return months[month - 1];
}

String formatAudAmount(double value) {
  final formatted = value.toStringAsFixed(2).replaceAllMapped(
        RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
        (match) => '${match[1]},',
      );
  return 'AUD $formatted';
}

String formatCurrency(double amount, String currency) {
  final symbol = currencySymbol(currency);
  final formatted = amount.toStringAsFixed(2).replaceAllMapped(
        RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
        (match) => '${match[1]},',
      );
  return '$symbol $formatted';
}

String currencySymbol(String currency) {
  switch (currency.toUpperCase()) {
    case 'USD':
      return '\$';
    case 'EUR':
      return '€';
    case 'GBP':
      return '£';
    case 'AUD':
      return 'AUD';
    case 'INR':
      return '₹';
    default:
      return currency;
  }
}

extension DateOnlyIsoExtension on DateTime {
  /// Formats as `yyyy-MM-dd` with zero-padded year/month/day.
  String toIsoDateOnly() {
    final y = year.toString().padLeft(4, '0');
    final m = month.toString().padLeft(2, '0');
    final d = day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }
}

String billingCycleLabel(String value) {
  switch (value) {
    case 'DAILY':
      return 'Daily';
    case 'WEEKLY':
      return 'Weekly';
    case 'MONTHLY':
      return 'Monthly';
    case 'QUARTERLY':
      return 'Quarterly';
    case 'YEARLY':
      return 'Yearly';
    default:
      return value;
  }
}

String formatShortDate(DateTime date) {
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  return '${months[date.month - 1]} ${date.day}, ${date.year}';
}

DateTime? calculateNextBillingDate(DateTime start, String cycle) {
  final now = DateTime.now();
  DateTime next = DateTime(start.year, start.month, start.day);

  if (next.isAfter(now)) return next;

  while (!next.isAfter(now)) {
    switch (cycle) {
      case 'DAILY':
        next = next.add(const Duration(days: 1));
        break;
      case 'WEEKLY':
        next = next.add(const Duration(days: 7));
        break;
      case 'MONTHLY':
        next = DateTime(next.year, next.month + 1, next.day);
        break;
      case 'QUARTERLY':
        next = DateTime(next.year, next.month + 3, next.day);
        break;
      case 'YEARLY':
        next = DateTime(next.year + 1, next.month, next.day);
        break;
      default:
        return null;
    }
  }
  return next;
}
