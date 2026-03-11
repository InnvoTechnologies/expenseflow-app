import 'package:expenseflow/features/categories/model/category_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/util/extensions.dart';
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
          emit(CategoryError('Data parsing error: $e'));
        }
      },
    );
  }

  Future<bool> createCategory({
    required String name,
    required CategoryType type,
  }) async {
    final params = <String, Object>{
      'name': name,
      'type': type == CategoryType.income ? 'INCOME' : 'EXPENSE',
      'color': generateRandomColorHex(),
    };

    final result = await ApiService().createCategory(params);

    return result.fold(
      (l) {
        emit(CategoryError(l.toString()));
        return false;
      },
      (r) {
        try {
          final Category newCategory = Category.fromJson(r.data);
          final List<Category> updatedCategories = [
            newCategory,
            ...state.categories,
          ];
          emit(CategoryLoaded(updatedCategories));
        } catch (_) {
          getCategories();
        }
        return true;
      },
    );
  }

  Future<bool> updateCategory({
    required Category category,
    required String name,
  }) async {
    final params = <String, Object>{
      'name': name,
      'type': category.type == CategoryType.income ? 'INCOME' : 'EXPENSE',
      'color': category.color,
    };

    final result = await ApiService().updateCategory(category.id, params);

    return result.fold(
      (l) {
        emit(CategoryError(l.toString()));
        return false;
      },
      (r) {
        try {
          final Category updatedCategory = Category.fromJson(r.data);
          final List<Category> updatedCategories = state.categories
              .map((c) => c.id == updatedCategory.id ? updatedCategory : c)
              .toList();
          emit(CategoryLoaded(updatedCategories));
        } catch (_) {
          getCategories();
        }
        return true;
      },
    );
  }

  Future<bool> deleteCategory(String id) async {
    final result = await ApiService().deleteCategory(id);

    return result.fold(
      (l) {
        emit(CategoryError(l.toString()));
        return false;
      },
      (r) {
        final List<Category> updatedCategories = state.categories
            .where((c) => c.id != id)
            .toList();
        emit(CategoryLoaded(updatedCategories));
        return true;
      },
    );
  }
}
