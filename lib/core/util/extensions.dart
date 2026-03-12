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
