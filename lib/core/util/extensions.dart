import 'dart:math';

String generateRandomColorHex() {
  final random = Random();
  final colorValue = random.nextInt(0xFFFFFF + 1);
  return '#${colorValue.toRadixString(16).padLeft(6, '0').toUpperCase()}';
}
