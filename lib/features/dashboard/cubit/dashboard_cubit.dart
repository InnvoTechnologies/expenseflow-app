import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/network/api_service.dart';
import '../model/dashboard_model.dart';
import 'dashboard_state.dart';

class DashboardCubit extends Cubit<DashboardState> {
  DashboardCubit() : super(const DashboardInitial());

  Future<void> loadForMonth(DateTime month) async {
    emit(const DashboardLoading());

    final monthParam =
        '${month.year.toString().padLeft(4, '0')}-${month.month.toString().padLeft(2, '0')}';

    final result = await ApiService().getDashboard({
      'month': monthParam,
    });

    result.fold(
      (l) => emit(DashboardError(l.toString())),
      (r) {
        try {
          final data = DashboardData.fromJson(r.data as Map<String, dynamic>);
          emit(DashboardLoaded(data));
        } catch (e) {
          emit(DashboardError('Data parsing error: $e'));
        }
      },
    );
  }
}

