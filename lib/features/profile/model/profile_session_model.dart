import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile_session_model.freezed.dart';
part 'profile_session_model.g.dart';

@freezed
abstract class ProfileSessionModel with _$ProfileSessionModel {
  const factory ProfileSessionModel({
    required String id,
    required String ipAddress,
    required String userAgent,
    required DateTime expiresAt,
    required String deviceType,
    required String browser,
    required String os,
    required bool isCurrent,
    required DateTime lastActive,
  }) = _ProfileSessionModel;

  factory ProfileSessionModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileSessionModelFromJson(json);
}

