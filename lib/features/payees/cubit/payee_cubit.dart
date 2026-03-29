import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/network/api_service.dart';
import '../model/payee_model.dart';
import 'payee_state.dart';

class PayeeCubit extends Cubit<PayeeState> {
  PayeeCubit() : super(PayeeInitial());

  Future<void> getPayees() async {
    emit(PayeeLoading());

    final result = await ApiService().getPayees({});

    result.fold(
      (l) {
        emit(PayeeError(l.toString()));
      },
      (r) {
        try {
          final List<dynamic> rawData = r.data;

          final List<Payee> payees =
              rawData.map((json) => Payee.fromJson(json)).toList();

          emit(PayeeLoaded(payees));
        } catch (e) {
          emit(PayeeError('Data parsing error: $e'));
        }
      },
    );
  }

  Future<bool> createPayee({
    required String name,
    String? email,
    String? phone,
    String? address,
    String? description,
  }) async {
    final params = <String, Object>{
      'name': name,
      'email': email ?? '',
      'phone': phone ?? '',
      'address': address ?? '',
      'description': description ?? '',
    };

    final result = await ApiService().createPayee(params);

    return result.fold(
      (l) {
        emit(PayeeError(l.toString()));
        return false;
      },
      (r) {
        try {
          final Payee newPayee = Payee.fromJson(r.data);
          final List<Payee> updatedPayees = [
            newPayee,
            ...state.payees,
          ];
          emit(PayeeLoaded(updatedPayees));
        } catch (_) {
          getPayees();
        }
        return true;
      },
    );
  }

  Future<bool> updatePayee({
    required Payee payee,
    required String name,
    String? email,
    String? phone,
    String? address,
    String? description,
  }) async {
    final params = <String, Object>{
      'name': name,
      'email': email ?? '',
      'phone': phone ?? '',
      'address': address ?? '',
      'description': description ?? '',
    };

    final result = await ApiService().updatePayee(payee.id, params);

    return result.fold(
      (l) {
        emit(PayeeError(l.toString()));
        return false;
      },
      (r) {
        try {
          final Payee updatedPayee = Payee.fromJson(r.data);
          final List<Payee> updatedPayees = state.payees
              .map(
                (p) => p.id == updatedPayee.id ? updatedPayee : p,
              )
              .toList();
          emit(PayeeLoaded(updatedPayees));
        } catch (_) {
          getPayees();
        }
        return true;
      },
    );
  }

  Future<bool> deletePayee(String id) async {
    final result = await ApiService().deletePayee(id);

    return result.fold(
      (l) {
        emit(PayeeError(l.toString()));
        return false;
      },
      (r) {
        final List<Payee> updatedPayees =
            state.payees.where((p) => p.id != id).toList();
        emit(PayeeLoaded(updatedPayees));
        return true;
      },
    );
  }
}

