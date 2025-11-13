import 'package:freezed_annotation/freezed_annotation.dart';

import 'user_model.dart';

part 'session_model.freezed.dart';
part 'session_model.g.dart';

@freezed
abstract class SessionModel with _$SessionModel {
  const factory SessionModel({
    String? accessToken,
    String? tokenType,
    int? expiresIn,
    String? refreshToken,
    UserModel? user,
  }) = _SessionModel;

  factory SessionModel.fromJson(Map<String, dynamic> json) => _$SessionModelFromJson(json);
}
