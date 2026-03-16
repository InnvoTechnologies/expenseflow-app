import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/network/api_service.dart';
import '../../../core/util/extensions.dart';
import '../model/subscription_model.dart';
import 'subscription_state.dart';

class SubscriptionCubit extends Cubit<SubscriptionState> {
  SubscriptionCubit() : super(const SubscriptionInitial());

  Future<void> getSubscriptions() async {
    emit(const SubscriptionLoading());

    final result = await ApiService().getSubscriptions({});

    result.fold(
      (l) => emit(SubscriptionError(l.toString())),
      (r) {
        try {
          final raw = r.data as List<dynamic>;
          final subscriptions = raw
              .map(
                (json) => Subscription.fromApiJson(
                  json as Map<String, dynamic>,
                ),
              )
              .toList();
          emit(SubscriptionLoaded(subscriptions));
        } catch (e) {
          emit(SubscriptionError('Data parsing error: $e'));
        }
      },
    );
  }

  Future<bool> createSubscription({
    required String title,
    String? description,
    required DateTime startDate,
    required String billingCycle,
    required String amount,
    required String currency,
    String? categoryId,
    String? accountId,
    required int notifyDaysBefore,
    required bool reminderEnabled,
    required String status,
  }) async {
    final params = <String, Object?>{
      'title': title,
      'description': description ?? '',
      'startDate': startDate.toIsoDateOnly(),
      'billingCycle': billingCycle,
      'amount': amount,
      'currency': currency,
      'categoryId': categoryId,
      'accountId': accountId,
      'notifyDaysBefore': notifyDaysBefore,
      'reminderEnabled': reminderEnabled,
      'status': status,
    }..removeWhere((_, value) => value == null);

    final result = await ApiService().createSubscription(
      params.cast<String, Object>(),
    );

    return result.fold(
      (l) {
        emit(SubscriptionError(l.toString()));
        return false;
      },
      (r) {
        try {
          final sub = Subscription.fromApiJson(
            r.data as Map<String, dynamic>,
          );
          final updated = [sub, ...state.subscriptions];
          emit(SubscriptionLoaded(updated));
        } catch (_) {
          getSubscriptions();
        }
        return true;
      },
    );
  }

  Future<bool> updateSubscription({
    required Subscription subscription,
    required String title,
    String? description,
    required DateTime startDate,
    required String billingCycle,
    required String amount,
    required String currency,
    String? categoryId,
    String? accountId,
    required int notifyDaysBefore,
    required bool reminderEnabled,
    required String status,
  }) async {
    final params = <String, Object?>{
      'title': title,
      'description': description ?? '',
      'startDate': startDate.toIsoDateOnly(),
      'billingCycle': billingCycle,
      'amount': amount,
      'currency': currency,
      'categoryId': categoryId,
      'accountId': accountId,
      'notifyDaysBefore': notifyDaysBefore,
      'reminderEnabled': reminderEnabled,
      'status': status,
    }..removeWhere((_, value) => value == null);

    final result = await ApiService().updateSubscription(
      subscription.id,
      params.cast<String, Object>(),
    );

    return result.fold(
      (l) {
        emit(SubscriptionError(l.toString()));
        return false;
      },
      (r) {
        try {
          final updatedSub = Subscription.fromApiJson(
            r.data as Map<String, dynamic>,
          );
          final updated = state.subscriptions
              .map((s) => s.id == updatedSub.id ? updatedSub : s)
              .toList();
          emit(SubscriptionLoaded(updated));
        } catch (_) {
          getSubscriptions();
        }
        return true;
      },
    );
  }

  Future<bool> deleteSubscription(String id) async {
    final result = await ApiService().deleteSubscription(id);

    return result.fold(
      (l) {
        emit(SubscriptionError(l.toString()));
        return false;
      },
      (r) {
        final updated =
            state.subscriptions.where((s) => s.id != id).toList();
        emit(SubscriptionLoaded(updated));
        return true;
      },
    );
  }
}

