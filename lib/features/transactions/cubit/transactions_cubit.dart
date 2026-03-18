import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/network/api_service.dart';
import '../model/transaction_model.dart';
import 'transactions_state.dart';

class TransactionsCubit extends Cubit<TransactionsState> {
  TransactionsCubit() : super(const TransactionsInitial());

  static const int _defaultLimit = 20;

  Future<void> fetchTransactions({int page = 1, int limit = _defaultLimit}) async {
    emit(const TransactionsLoading());

    final result = await ApiService().getTransactions({
      'page': page,
      'limit': limit,
    });

    result.fold(
      (failure) => emit(TransactionsError(failure.message)),
      (response) {
        final meta = TransactionPaginationMetadata.fromJson(
          (response.data['metadata'] as Map?)?.cast<String, dynamic>(),
          fallbackPage: page,
          fallbackLimit: limit,
        );

        final list = (response.data['data'] as List<dynamic>)
            .map(
              (json) => TransactionModel.fromApiJson(
                json as Map<String, dynamic>,
              ),
            )
            .toList();
        emit(
          TransactionsLoaded(
            transactions: list,
            page: meta.page,
            totalPages: meta.totalPages,
            limit: meta.limit,
            total: meta.total,
          ),
        );
      },
    );
  }

  Future<void> refresh() async {
    await fetchTransactions(page: 1, limit: _defaultLimit);
  }

  Future<void> loadMore() async {
    final currentState = state;
    if (currentState is! TransactionsLoaded) return;
    if (!currentState.hasMore) return;
    if (currentState.isLoadingMore) return;

    emit(currentState.copyWith(isLoadingMore: true));

    final nextPage = currentState.page + 1;
    final result = await ApiService().getTransactions({
      'page': nextPage,
      'limit': currentState.limit,
    });

    result.fold(
      (failure) => emit(
        currentState.copyWith(isLoadingMore: false),
      ),
      (response) {
        final meta = TransactionPaginationMetadata.fromJson(
          (response.data['metadata'] as Map?)?.cast<String, dynamic>(),
          fallbackPage: nextPage,
          fallbackLimit: currentState.limit,
        );

        final list = (response.data['data'] as List<dynamic>)
            .map(
              (json) => TransactionModel.fromApiJson(
                json as Map<String, dynamic>,
              ),
            )
            .toList();

        emit(
          currentState.copyWith(
            transactions: [...currentState.transactions, ...list],
            page: meta.page,
            totalPages: meta.totalPages,
            limit: meta.limit,
            total: meta.total,
            isLoadingMore: false,
          ),
        );
      },
    );
  }
}

