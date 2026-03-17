import 'package:freezed_annotation/freezed_annotation.dart';

part 'organization_model.freezed.dart';
part 'organization_model.g.dart';

@freezed
abstract class OrganizationModel with _$OrganizationModel {
  const factory OrganizationModel({
    required String id,
    required String name,
    required String slug,
    String? logo,
    Map<String, dynamic>? metadata,
    required DateTime createdAt,
    required String role,
  }) = _OrganizationModel;

  factory OrganizationModel.fromJson(Map<String, dynamic> json) =>
      _$OrganizationModelFromJson(json);
}

