import 'package:expenseflow/features/categories/model/category_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/network/api_service.dart';
import 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  CategoryCubit() : super(CategoryInitial());

  Future<void> getCategories() async {
    emit(CategoryLoading());

    final result = await ApiService().getCategories({});

    result.fold(
      (l) {
        emit(CategoryError(l.toString()));
      },
      (r) {
        try {
          final List<dynamic> rawData = r.data;

          final List<Category> categories = rawData
              .map((json) => Category.fromJson(json))
              .toList();

          emit(CategoryLoaded(categories));
        } catch (e) {
          emit(CategoryError("Data parsing error: $e"));
        }
      },
    );
  }
}
