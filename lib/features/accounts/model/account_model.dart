import 'package:freezed_annotation/freezed_annotation.dart';

part 'account_model.freezed.dart';
part 'account_model.g.dart';

@freezed
abstract class Account with _$Account {
  const factory Account({
    required String id,
    required String name,
    required String type,
    required String currency,
    required double currentBalance,
    required String userId,
    String? organizationId,
    required bool isDefault,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Account;

  factory Account.fromJson(Map<String, dynamic> json) =>
      Account.fromApiJson(json);

  factory Account.fromApiJson(Map<String, dynamic> json) {
    final balanceRaw = json['currentBalance'];
    final balance = balanceRaw is num
        ? balanceRaw.toDouble()
        : double.tryParse(balanceRaw?.toString() ?? '') ?? 0.0;

    return Account(
      id: json['id'] as String,
      name: json['name'] as String,
      type: (json['type'] ?? 'BANK').toString(),
      currency: (json['currency'] ?? 'USD').toString(),
      currentBalance: balance,
      userId: (json['userId'] ?? '').toString(),
      organizationId: json['organizationId'] as String?,
      isDefault: (json['isDefault'] as bool?) ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  static const List<Map<String, String>> accountTypes = [
    {'value': 'BANK', 'label': 'Bank Account'},
    {'value': 'CASH', 'label': 'Cash'},
    {'value': 'CREDIT_CARD', 'label': 'Credit Card'},
    {'value': 'MOBILE_WALLET', 'label': 'Mobile Wallet'},
  ];
}

