import 'package:expenseflow/features/categories/model/category_model.dart';

abstract class CategoryState {
  final List<Category> categories;
  CategoryState({this.categories = const []});
}

class CategoryInitial extends CategoryState {}

class CategoryLoading extends CategoryState {}

class CategoryLoaded extends CategoryState {
  CategoryLoaded(List<Category> categories) : super(categories: categories);
}

class CategoryError extends CategoryState {
  final String message;
  CategoryError(this.message);
}