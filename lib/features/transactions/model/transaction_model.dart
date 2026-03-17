import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction_model.freezed.dart';
part 'transaction_model.g.dart';

@freezed
abstract class TransactionTagModel with _$TransactionTagModel {
  const factory TransactionTagModel({
    required String id,
    required String name,
    String? color,
  }) = _TransactionTagModel;

  factory TransactionTagModel.fromJson(Map<String, dynamic> json) =>
      _$TransactionTagModelFromJson(json);
}

@freezed
abstract class TransactionRelatedModel with _$TransactionRelatedModel {
  const factory TransactionRelatedModel({
    required String id,
    required String name,
  }) = _TransactionRelatedModel;

  factory TransactionRelatedModel.fromJson(Map<String, dynamic> json) =>
      _$TransactionRelatedModelFromJson(json);

  factory TransactionRelatedModel.fromApiJson(Map<String, dynamic> json) {
    return TransactionRelatedModel(
      id: (json['id'] ?? '').toString(),
      name: (json['name'] ?? json['title'] ?? '').toString(),
    );
  }
}

@freezed
abstract class TransactionModel with _$TransactionModel {
  const factory TransactionModel({
    required String id,
    required double amount,
    required double feeAmount,
    required String type,
    required String status,
    required DateTime date,
    required String description,
    required String accountId,
    String? toAccountId,
    required String categoryId,
    String? payeeId,
    String? subscriptionId,
    @Default(<String>[]) List<String> tagIds,
    @Default(<TransactionTagModel>[]) List<TransactionTagModel> tags,
    TransactionRelatedModel? category,
    TransactionRelatedModel? account,
    TransactionRelatedModel? toAccount,
    TransactionRelatedModel? payee,
    TransactionRelatedModel? subscription,
  }) = _TransactionModel;

  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      _$TransactionModelFromJson(json);

  factory TransactionModel.fromApiJson(Map<String, dynamic> json) {
    final amountRaw = json['amount'] ?? 0;
    final feeRaw = json['feeAmount'] ?? 0;

    final amount = amountRaw is num
        ? amountRaw.toDouble()
        : double.tryParse(amountRaw.toString()) ?? 0.0;
    final feeAmount = feeRaw is num
        ? feeRaw.toDouble()
        : double.tryParse(feeRaw.toString()) ?? 0.0;

    final payeeId = json['payeeId']?.toString() ??
        (json['payee'] as Map<String, dynamic>?)?['id']?.toString();

    final subscriptionId = json['subscriptionId']?.toString() ??
        (json['subscription'] as Map<String, dynamic>?)?['id']?.toString();

    final tagIds = (json['tagIds'] as List<dynamic>? ?? [])
        .map((e) => e.toString())
        .toList();

    final tags = (json['tags'] as List<dynamic>? ?? [])
        .map(
          (t) => TransactionTagModel.fromJson(t as Map<String, dynamic>),
        )
        .toList();

    TransactionRelatedModel? parseRelated(dynamic value) {
      if (value is Map<String, dynamic>) {
        return TransactionRelatedModel.fromApiJson(value);
      }
      return null;
    }

    return TransactionModel(
      id: (json['id'] ?? '').toString(),
      amount: amount,
      feeAmount: feeAmount,
      type: (json['type'] ?? '').toString(),
      status: (json['status'] ?? '').toString(),
      date: DateTime.parse((json['date'] ?? '').toString()),
      description: (json['description'] as String?)?.trim() ?? '',
      accountId: (json['accountId'] ?? '').toString(),
      toAccountId: json['toAccountId']?.toString(),
      categoryId: (json['categoryId'] ?? '').toString(),
      payeeId: payeeId,
      subscriptionId: subscriptionId,
      tagIds: tagIds,
      tags: tags,
      category: parseRelated(json['category']),
      account: parseRelated(json['account']),
      toAccount: parseRelated(json['toAccount']),
      payee: parseRelated(json['payee']),
      subscription: parseRelated(json['subscription']),
    );
  }
}

