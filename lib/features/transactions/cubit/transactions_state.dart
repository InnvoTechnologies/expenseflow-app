import '../model/transaction_model.dart';

abstract class TransactionsState {
  const TransactionsState();
}

class TransactionsInitial extends TransactionsState {
  const TransactionsInitial();
}

class TransactionsLoading extends TransactionsState {
  const TransactionsLoading();
}

class TransactionsLoaded extends TransactionsState {
  final List<TransactionModel> transactions;

  const TransactionsLoaded(this.transactions);
}

class TransactionsError extends TransactionsState {
  final String message;

  const TransactionsError(this.message);
}

