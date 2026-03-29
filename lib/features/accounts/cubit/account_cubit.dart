import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/network/api_service.dart';
import '../model/account_model.dart';
import 'account_state.dart';

class AccountCubit extends Cubit<AccountState> {
  AccountCubit() : super(const AccountInitial());

  Future<void> getAccounts() async {
    emit(const AccountLoading());

    final result = await ApiService().getAccounts({});

    result.fold(
      (l) => emit(AccountError(l.toString())),
      (r) {
        try {
          final List<dynamic> raw = r.data as List<dynamic>;
          final accounts = raw
              .map((json) => Account.fromApiJson(json as Map<String, dynamic>))
              .toList();
          emit(AccountLoaded(accounts));
        } catch (e) {
          emit(AccountError('Data parsing error: $e'));
        }
      },
    );
  }

  Future<bool> createAccount({
    required String name,
    required String type,
    required String currency,
    required double currentBalance,
    required bool isDefault,
  }) async {
    final params = <String, Object>{
      'name': name,
      'type': type,
      'currency': currency,
      'currentBalance': currentBalance,
      'isDefault': isDefault,
    };

    final result = await ApiService().createAccount(params);

    return result.fold(
      (l) {
        emit(AccountError(l.toString()));
        return false;
      },
      (r) {
        try {
          final account =
              Account.fromApiJson(r.data as Map<String, dynamic>);
          final updated = [account, ...state.accounts];
          emit(AccountLoaded(updated));
        } catch (_) {
          getAccounts();
        }
        return true;
      },
    );
  }

  Future<bool> updateAccount({
    required Account account,
    required String name,
    required String type,
    required String currency,
    required double currentBalance,
    required bool isDefault,
  }) async {
    final params = <String, Object>{
      'name': name,
      'type': type,
      'currency': currency,
      'currentBalance': currentBalance,
      'isDefault': isDefault,
    };

    final result = await ApiService().updateAccount(account.id, params);

    return result.fold(
      (l) {
        emit(AccountError(l.toString()));
        return false;
      },
      (r) {
        try {
          final updatedAccount =
              Account.fromApiJson(r.data as Map<String, dynamic>);
          final updated = state.accounts
              .map((a) => a.id == updatedAccount.id ? updatedAccount : a)
              .toList();
          emit(AccountLoaded(updated));
        } catch (_) {
          getAccounts();
        }
        return true;
      },
    );
  }

  Future<bool> deleteAccount(String id) async {
    final result = await ApiService().deleteAccount(id);

    return result.fold(
      (l) {
        emit(AccountError(l.toString()));
        return false;
      },
      (r) {
        final updated =
            state.accounts.where((a) => a.id != id).toList();
        emit(AccountLoaded(updated));
        return true;
      },
    );
  }
}

