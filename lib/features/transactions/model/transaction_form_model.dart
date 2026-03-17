import 'package:flutter/foundation.dart';

import 'transaction_model.dart';

class TransactionFormModel extends ChangeNotifier {
  TransactionFormModel({
    String amount = '',
    String feeAmount = '',
    String description = '',
    DateTime? date,
    String? categoryId,
    String? accountId,
    String? toAccountId,
    String? payeeId,
    String? subscriptionId,
    String? tagId,
  })  : _amount = amount,
        _feeAmount = feeAmount,
        _description = description,
        _date = date ?? DateTime.now(),
        _categoryId = categoryId,
        _accountId = accountId,
        _toAccountId = toAccountId,
        _payeeId = payeeId,
        _subscriptionId = subscriptionId,
        _tagId = tagId;

  factory TransactionFormModel.fromTransaction(TransactionModel? tx) {
    if (tx == null) return TransactionFormModel();
    return TransactionFormModel(
      amount: tx.amount.toStringAsFixed(2),
      feeAmount: tx.feeAmount.toStringAsFixed(2),
      description: tx.description,
      date: tx.date,
      categoryId: tx.categoryId,
      accountId: tx.accountId,
      toAccountId: tx.toAccountId,
      payeeId: tx.payeeId,
      subscriptionId: tx.subscriptionId,
      tagId: tx.tagIds.isNotEmpty ? tx.tagIds.first : null,
    );
  }

  String _amount;
  String _feeAmount;
  String _description;
  DateTime _date;
  String? _categoryId;
  String? _accountId;
  String? _toAccountId;
  String? _payeeId;
  String? _subscriptionId;
  String? _tagId;

  String get amount => _amount;
  String get feeAmount => _feeAmount;
  String get description => _description;
  DateTime get date => _date;
  String? get categoryId => _categoryId;
  String? get accountId => _accountId;
  String? get toAccountId => _toAccountId;
  String? get payeeId => _payeeId;
  String? get subscriptionId => _subscriptionId;
  String? get tagId => _tagId;

  void setAmount(String value) {
    _amount = value;
    notifyListeners();
  }

  void setFeeAmount(String value) {
    _feeAmount = value;
    notifyListeners();
  }

  void setDescription(String value) {
    _description = value;
    notifyListeners();
  }

  void setDate(DateTime value) {
    _date = value;
    notifyListeners();
  }

  void setCategoryId(String? value) {
    _categoryId = value;
    notifyListeners();
  }

  void setAccountId(String? value) {
    _accountId = value;
    notifyListeners();
  }

  void setToAccountId(String? value) {
    _toAccountId = value;
    notifyListeners();
  }

  void setPayeeId(String? value) {
    _payeeId = value;
    notifyListeners();
  }

  void setSubscriptionId(String? value) {
    _subscriptionId = value;
    notifyListeners();
  }

  void setTagId(String? value) {
    _tagId = value;
    notifyListeners();
  }
}

