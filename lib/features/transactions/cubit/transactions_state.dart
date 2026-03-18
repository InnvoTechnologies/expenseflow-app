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
  final int page;
  final int totalPages;
  final int limit;
  final int total;
  final bool isLoadingMore;

  const TransactionsLoaded({
    required this.transactions,
    required this.page,
    required this.totalPages,
    required this.limit,
    required this.total,
    this.isLoadingMore = false,
  });

  bool get hasMore => page < totalPages;

  TransactionsLoaded copyWith({
    List<TransactionModel>? transactions,
    int? page,
    int? totalPages,
    int? limit,
    int? total,
    bool? isLoadingMore,
  }) {
    return TransactionsLoaded(
      transactions: transactions ?? this.transactions,
      page: page ?? this.page,
      totalPages: totalPages ?? this.totalPages,
      limit: limit ?? this.limit,
      total: total ?? this.total,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    );
  }
}

class TransactionsError extends TransactionsState {
  final String message;

  const TransactionsError(this.message);
}

