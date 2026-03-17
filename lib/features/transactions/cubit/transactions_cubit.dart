import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/network/api_service.dart';
import '../model/transaction_model.dart';
import 'transactions_state.dart';

class TransactionsCubit extends Cubit<TransactionsState> {
  TransactionsCubit() : super(const TransactionsInitial());

  Future<void> fetchTransactions() async {
    emit(const TransactionsLoading());

    final result = await ApiService().getTransactions({});

    result.fold(
      (failure) => emit(TransactionsError(failure.message)),
      (response) {
        final list = (response.data['data'] as List<dynamic>)
            .map(
              (json) => TransactionModel.fromApiJson(
                json as Map<String, dynamic>,
              ),
            )
            .toList();
        emit(TransactionsLoaded(list));
      },
    );
  }
}

