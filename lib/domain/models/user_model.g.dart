// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserModel _$UserModelFromJson(Map<String, dynamic> json) => _UserModel(
  id: json['id'] as String,
  aud: json['aud'] as String?,
  role: json['role'] as String?,
  email: json['email'] as String?,
  emailConfirmedAt: json['emailConfirmedAt'] as String?,
  phone: json['phone'] as String?,
  lastSignInAt: json['lastSignInAt'] as String?,
  appMetadata: json['appMetadata'] as Map<String, dynamic>?,
  userMetadata: json['userMetadata'] as Map<String, dynamic>?,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$UserModelToJson(_UserModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'aud': instance.aud,
      'role': instance.role,
      'email': instance.email,
      'emailConfirmedAt': instance.emailConfirmedAt,
      'phone': instance.phone,
      'lastSignInAt': instance.lastSignInAt,
      'appMetadata': instance.appMetadata,
      'userMetadata': instance.userMetadata,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
