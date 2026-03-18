import 'dart:math';

import 'package:intl/intl.dart';

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
  final formatted = value
      .toStringAsFixed(2)
      .replaceAllMapped(
        RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
        (match) => '${match[1]},',
      );
  return 'AUD $formatted';
}

String formatCurrency(double amount, String currency) {
  final symbol = currencySymbol(currency);
  final formatted = amount
      .toStringAsFixed(2)
      .replaceAllMapped(
        RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
        (match) => '${match[1]},',
      );
  return '$symbol $formatted';
}

String formatSignedCurrency(
  double amount, {
  required bool isNegative,
  String currency = 'USD',
}) {
  final symbol = currencySymbol(currency);
  final formatted = amount
      .abs()
      .toStringAsFixed(2)
      .replaceAllMapped(
        RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
        (match) => '${match[1]},',
      );
  final prefix = isNegative ? '-' : '';
  return '$prefix$symbol$formatted';
}

String currencySymbol(String currency) {
  try {
    return NumberFormat.simpleCurrency(
      name: currency.toUpperCase(),
    ).currencySymbol;
  } catch (_) {
    return currency.toUpperCase();
  }
}

extension DateOnlyIsoExtension on DateTime {
  /// Formats as `yyyy-MM-dd` using intl.
  String toIsoDateOnly() => DateFormat('yyyy-MM-dd').format(this);
}

extension UiDateFormatExtension on DateTime {
  String toUiDate() => DateFormat('dd/MM/yyyy').format(this);
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
  return DateFormat('MMM d, yyyy').format(date);
}

String formatMonthDay(DateTime date) {
  return DateFormat('MMM d').format(date);
}

String formatDateTime(DateTime date) {
  return DateFormat('MMM d, yyyy, h:mm a').format(date);
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
