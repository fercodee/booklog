import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
abstract class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    String? aud,
    String? role,
    String? email,
    String? emailConfirmedAt,
    String? phone,
    String? lastSignInAt,
    Map<String, dynamic>? appMetadata,
    Map<String, dynamic>? userMetadata,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
}
