import 'package:freezed_annotation/freezed_annotation.dart';

part 'account_model.freezed.dart';
part 'account_model.g.dart';

enum ApiAccountType { bank, cash, creditCard, mobileWallet, unknown }

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

  static List<Map<String, String>> get accountTypes =>
      [
            ApiAccountType.bank,
            ApiAccountType.cash,
            ApiAccountType.creditCard,
            ApiAccountType.mobileWallet,
          ]
          .map((t) => {'value': t.apiValue, 'label': t.dropdownLabel})
          .toList(growable: false);
}

extension ApiAccountTypeX on ApiAccountType {
  String get label => switch (this) {
    ApiAccountType.bank => 'Bank',
    ApiAccountType.cash => 'Cash',
    ApiAccountType.creditCard => 'Card',
    ApiAccountType.mobileWallet => 'Wallet',
    ApiAccountType.unknown => 'Unknown',
  };

  String get apiValue => switch (this) {
    ApiAccountType.bank => 'BANK',
    ApiAccountType.cash => 'CASH',
    ApiAccountType.creditCard => 'CREDIT_CARD',
    ApiAccountType.mobileWallet => 'MOBILE_WALLET',
    ApiAccountType.unknown => 'UNKNOWN',
  };

  String get dropdownLabel => switch (this) {
    ApiAccountType.bank => 'Bank Account',
    ApiAccountType.cash => 'Cash',
    ApiAccountType.creditCard => 'Credit Card',
    ApiAccountType.mobileWallet => 'Mobile Wallet',
    ApiAccountType.unknown => 'Unknown',
  };

  static ApiAccountType fromApi(String? value) {
    switch ((value ?? '').toUpperCase()) {
      case 'BANK':
        return ApiAccountType.bank;
      case 'CASH':
        return ApiAccountType.cash;
      case 'CREDIT_CARD':
        return ApiAccountType.creditCard;
      case 'MOBILE_WALLET':
        return ApiAccountType.mobileWallet;
      default:
        return ApiAccountType.unknown;
    }
  }
}

extension ApiAccountTypeParsing on String {
  ApiAccountType toApiAccountType() => ApiAccountTypeX.fromApi(this);
}
