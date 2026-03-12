import 'package:freezed_annotation/freezed_annotation.dart';

part 'dashboard_model.freezed.dart';

@freezed
abstract class DashboardAccount with _$DashboardAccount {
  const factory DashboardAccount({
    required String id,
    required String name,
    required double currentBalance,
    required String type,
  }) = _DashboardAccount;

  factory DashboardAccount.fromJson(Map<String, dynamic> json) =>
      DashboardAccount.fromApiJson(json);

  factory DashboardAccount.fromApiJson(Map<String, dynamic> json) {
    final balanceRaw = json['currentBalance'];
    final balance = balanceRaw is num
        ? balanceRaw.toDouble()
        : double.tryParse(balanceRaw?.toString() ?? '') ?? 0.0;

    return DashboardAccount(
      id: json['id'] as String,
      name: json['name'] as String,
      currentBalance: balance,
      type: json['type'] as String,
    );
  }
}

@freezed
abstract class DashboardTransaction with _$DashboardTransaction {
  const factory DashboardTransaction({
    required String id,
    required String description,
    required double amount,
    required String type,
    DateTime? date,
  }) = _DashboardTransaction;

  factory DashboardTransaction.fromJson(Map<String, dynamic> json) =>
      DashboardTransaction.fromApiJson(json);

  factory DashboardTransaction.fromApiJson(Map<String, dynamic> json) {
    final amountRaw = json['amount'] ?? json['value'] ?? 0;
    final amount = amountRaw is num
        ? amountRaw.toDouble()
        : double.tryParse(amountRaw.toString()) ?? 0.0;

    final dateStr = (json['date'] ?? json['createdAt'])?.toString();
    DateTime? parsedDate;
    if (dateStr != null) {
      parsedDate = DateTime.tryParse(dateStr);
    }

    return DashboardTransaction(
      id: (json['id'] ?? '') as String,
      description:
          (json['description'] ?? json['name'] ?? '').toString(),
      amount: amount,
      type: (json['type'] ?? json['transactionType'] ?? '')
          .toString(),
      date: parsedDate,
    );
  }
}

@freezed
abstract class DashboardNamedAmount with _$DashboardNamedAmount {
  const factory DashboardNamedAmount({
    required String name,
    required double amount,
    String? color,
  }) = _DashboardNamedAmount;

  factory DashboardNamedAmount.fromJson(Map<String, dynamic> json) =>
      DashboardNamedAmount.fromApiJson(json);

  factory DashboardNamedAmount.fromApiJson(Map<String, dynamic> json) {
    final amountRaw =
        json['amount'] ?? json['totalAmount'] ?? json['total'] ?? 0;
    final amount = amountRaw is num
        ? amountRaw.toDouble()
        : double.tryParse(amountRaw.toString()) ?? 0.0;

    final name =
        (json['name'] ?? json['title'] ?? json['label'] ?? 'Unknown')
            .toString();

    final color = json['color'] as String?;

    return DashboardNamedAmount(
      name: name,
      amount: amount,
      color: color,
    );
  }
}

@freezed
abstract class DashboardData with _$DashboardData {
  const factory DashboardData({
    required double totalBalance,
    required double monthlyIncome,
    required double monthlyExpense,
    required List<DashboardAccount> accounts,
    required List<DashboardTransaction> recentTransactions,
    required List<DashboardNamedAmount> topPayees,
    required List<DashboardNamedAmount> topSubscriptions,
    required List<DashboardNamedAmount> topTags,
    required List<DashboardNamedAmount> expensesByCategory,
    required List<DashboardNamedAmount> incomeByCategory,
  }) = _DashboardData;

  factory DashboardData.fromJson(Map<String, dynamic> json) =>
      DashboardData.fromApiJson(json);

  factory DashboardData.fromApiJson(Map<String, dynamic> json) {
    final totalBalance = (json['totalBalance'] as num?)?.toDouble() ?? 0.0;
    final monthlyIncome = (json['monthlyIncome'] as num?)?.toDouble() ?? 0.0;
    final monthlyExpense =
        (json['monthlyExpense'] as num?)?.toDouble() ?? 0.0;

    final accountsJson = json['accounts'] as List<dynamic>? ?? [];
    final accounts = accountsJson
        .map((a) => DashboardAccount.fromJson(
              a as Map<String, dynamic>,
            ))
        .toList();

    final recentTxJson =
        json['recentTransactions'] as List<dynamic>? ?? [];
    final recentTransactions = recentTxJson
        .map((t) => DashboardTransaction.fromJson(
              t as Map<String, dynamic>,
            ))
        .toList();

    List<DashboardNamedAmount> parseNamedList(String key) {
      final raw = json[key] as List<dynamic>? ?? [];
      return raw
          .map(
            (e) => DashboardNamedAmount.fromJson(
              e as Map<String, dynamic>,
            ),
          )
          .toList();
    }

    final topPayees = parseNamedList('topPayees');
    final topSubscriptions = parseNamedList('topSubscriptions');
    final topTags = parseNamedList('topTags');
    final expensesByCategory = parseNamedList('expensesByCategory');
    final incomeByCategory = parseNamedList('incomeByCategory');

    return DashboardData(
      totalBalance: totalBalance,
      monthlyIncome: monthlyIncome,
      monthlyExpense: monthlyExpense,
      accounts: accounts,
      recentTransactions: recentTransactions,
      topPayees: topPayees,
      topSubscriptions: topSubscriptions,
      topTags: topTags,
      expensesByCategory: expensesByCategory,
      incomeByCategory: incomeByCategory,
    );
  }
}

