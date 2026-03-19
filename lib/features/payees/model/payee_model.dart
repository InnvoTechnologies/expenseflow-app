import 'package:freezed_annotation/freezed_annotation.dart';

part 'payee_model.freezed.dart';
part 'payee_model.g.dart';

@freezed
abstract class Payee with _$Payee {
  const factory Payee({
    required String id,
    required String name,
    String? email,
    String? phone,
    String? address,
    String? description,
    String? userId,
    String? organizationId,
  }) = _Payee;

  factory Payee.fromJson(Map<String, dynamic> json) => _$PayeeFromJson(json);
}
