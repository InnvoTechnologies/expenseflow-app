import 'package:freezed_annotation/freezed_annotation.dart';

part 'category_model.freezed.dart';
part 'category_model.g.dart';

enum CategoryType {
  @JsonValue('INCOME')
  income,
  @JsonValue('EXPENSE')
  expense,
}

@freezed
abstract class Category with _$Category {
  const factory Category({
    required String id,
    required String name,
    required CategoryType type,
    required String color,
    String? parentId,
    required String userId,
    String? organizationId,
  }) = _Category;

  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);

  static const List<String> availableColors = [
    '#EF4444',
    '#F97316',
    '#F59E0B',
    '#84CC16',
    '#10B981',
    '#06B6D4',
    '#3B82F6',
    '#6366F1',
    '#8B5CF6',
    '#D946EF',
    '#EC4899',
    '#64748B',
    '#71717A',
    '#737373',
    '#78716C',
  ];
}
