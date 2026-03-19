import 'package:freezed_annotation/freezed_annotation.dart';

part 'subscription_model.freezed.dart';
part 'subscription_model.g.dart';

@freezed
abstract class Subscription with _$Subscription {
  const factory Subscription({
    required String id,
    required String title,
    String? description,
    required double amount,
    required String currency,
    required String billingCycle,
    required DateTime startDate,
    DateTime? endDate,
    String? accountId,
    String? categoryId,
    required bool reminderEnabled,
    required int notifyDaysBefore,
    required String status,
    String? userId,
    String? organizationId,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Subscription;

  static const List<Map<String, String>> billingCycles = <Map<String, String>>[
    {'value': 'DAILY', 'label': 'Daily'},
    {'value': 'WEEKLY', 'label': 'Weekly'},
    {'value': 'MONTHLY', 'label': 'Monthly'},
    {'value': 'QUARTERLY', 'label': 'Quarterly'},
    {'value': 'YEARLY', 'label': 'Yearly'},
  ];

  factory Subscription.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionFromJson(json);

  factory Subscription.fromApiJson(Map<String, dynamic> json) {
    final amountRaw = json['amount'];
    final amount = amountRaw is num
        ? amountRaw.toDouble()
        : double.tryParse(amountRaw?.toString() ?? '') ?? 0.0;

    return Subscription(
      id: json['id'] as String,
      title: (json['title'] ?? '').toString(),
      description: json['description'] as String?,
      amount: amount,
      currency: (json['currency'] ?? 'USD').toString(),
      billingCycle: (json['billingCycle'] ?? 'MONTHLY').toString(),
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] != null
          ? DateTime.tryParse(json['endDate'] as String)
          : null,
      accountId: json['accountId'] as String?,
      categoryId: json['categoryId'] as String?,
      reminderEnabled: (json['reminderEnabled'] as bool?) ?? false,
      notifyDaysBefore: (json['notifyDaysBefore'] as num?)?.toInt() ?? 0,
      status: (json['status'] ?? '').toString(),
      userId: (json['userId'] ?? '').toString(),
      organizationId: json['organizationId'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }
}

