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
}
