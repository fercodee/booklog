// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserModel {

 String get id; String? get aud; String? get role; String? get email; String? get emailConfirmedAt; String? get phone; String? get lastSignInAt; Map<String, dynamic>? get appMetadata; Map<String, dynamic>? get userMetadata; DateTime? get createdAt; DateTime? get updatedAt;
/// Create a copy of UserModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserModelCopyWith<UserModel> get copyWith => _$UserModelCopyWithImpl<UserModel>(this as UserModel, _$identity);

  /// Serializes this UserModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserModel&&(identical(other.id, id) || other.id == id)&&(identical(other.aud, aud) || other.aud == aud)&&(identical(other.role, role) || other.role == role)&&(identical(other.email, email) || other.email == email)&&(identical(other.emailConfirmedAt, emailConfirmedAt) || other.emailConfirmedAt == emailConfirmedAt)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.lastSignInAt, lastSignInAt) || other.lastSignInAt == lastSignInAt)&&const DeepCollectionEquality().equals(other.appMetadata, appMetadata)&&const DeepCollectionEquality().equals(other.userMetadata, userMetadata)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,aud,role,email,emailConfirmedAt,phone,lastSignInAt,const DeepCollectionEquality().hash(appMetadata),const DeepCollectionEquality().hash(userMetadata),createdAt,updatedAt);

@override
String toString() {
  return 'UserModel(id: $id, aud: $aud, role: $role, email: $email, emailConfirmedAt: $emailConfirmedAt, phone: $phone, lastSignInAt: $lastSignInAt, appMetadata: $appMetadata, userMetadata: $userMetadata, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $UserModelCopyWith<$Res>  {
  factory $UserModelCopyWith(UserModel value, $Res Function(UserModel) _then) = _$UserModelCopyWithImpl;
@useResult
$Res call({
 String id, String? aud, String? role, String? email, String? emailConfirmedAt, String? phone, String? lastSignInAt, Map<String, dynamic>? appMetadata, Map<String, dynamic>? userMetadata, DateTime? createdAt, DateTime? updatedAt
});




}
/// @nodoc
class _$UserModelCopyWithImpl<$Res>
    implements $UserModelCopyWith<$Res> {
  _$UserModelCopyWithImpl(this._self, this._then);

  final UserModel _self;
  final $Res Function(UserModel) _then;

/// Create a copy of UserModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? aud = freezed,Object? role = freezed,Object? email = freezed,Object? emailConfirmedAt = freezed,Object? phone = freezed,Object? lastSignInAt = freezed,Object? appMetadata = freezed,Object? userMetadata = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,aud: freezed == aud ? _self.aud : aud // ignore: cast_nullable_to_non_nullable
as String?,role: freezed == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,emailConfirmedAt: freezed == emailConfirmedAt ? _self.emailConfirmedAt : emailConfirmedAt // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,lastSignInAt: freezed == lastSignInAt ? _self.lastSignInAt : lastSignInAt // ignore: cast_nullable_to_non_nullable
as String?,appMetadata: freezed == appMetadata ? _self.appMetadata : appMetadata // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,userMetadata: freezed == userMetadata ? _self.userMetadata : userMetadata // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [UserModel].
extension UserModelPatterns on UserModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserModel value)  $default,){
final _that = this;
switch (_that) {
case _UserModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserModel value)?  $default,){
final _that = this;
switch (_that) {
case _UserModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String? aud,  String? role,  String? email,  String? emailConfirmedAt,  String? phone,  String? lastSignInAt,  Map<String, dynamic>? appMetadata,  Map<String, dynamic>? userMetadata,  DateTime? createdAt,  DateTime? updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserModel() when $default != null:
return $default(_that.id,_that.aud,_that.role,_that.email,_that.emailConfirmedAt,_that.phone,_that.lastSignInAt,_that.appMetadata,_that.userMetadata,_that.createdAt,_that.updatedAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String? aud,  String? role,  String? email,  String? emailConfirmedAt,  String? phone,  String? lastSignInAt,  Map<String, dynamic>? appMetadata,  Map<String, dynamic>? userMetadata,  DateTime? createdAt,  DateTime? updatedAt)  $default,) {final _that = this;
switch (_that) {
case _UserModel():
return $default(_that.id,_that.aud,_that.role,_that.email,_that.emailConfirmedAt,_that.phone,_that.lastSignInAt,_that.appMetadata,_that.userMetadata,_that.createdAt,_that.updatedAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String? aud,  String? role,  String? email,  String? emailConfirmedAt,  String? phone,  String? lastSignInAt,  Map<String, dynamic>? appMetadata,  Map<String, dynamic>? userMetadata,  DateTime? createdAt,  DateTime? updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _UserModel() when $default != null:
return $default(_that.id,_that.aud,_that.role,_that.email,_that.emailConfirmedAt,_that.phone,_that.lastSignInAt,_that.appMetadata,_that.userMetadata,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserModel implements UserModel {
  const _UserModel({required this.id, this.aud, this.role, this.email, this.emailConfirmedAt, this.phone, this.lastSignInAt, final  Map<String, dynamic>? appMetadata, final  Map<String, dynamic>? userMetadata, this.createdAt, this.updatedAt}): _appMetadata = appMetadata,_userMetadata = userMetadata;
  factory _UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);

@override final  String id;
@override final  String? aud;
@override final  String? role;
@override final  String? email;
@override final  String? emailConfirmedAt;
@override final  String? phone;
@override final  String? lastSignInAt;
 final  Map<String, dynamic>? _appMetadata;
@override Map<String, dynamic>? get appMetadata {
  final value = _appMetadata;
  if (value == null) return null;
  if (_appMetadata is EqualUnmodifiableMapView) return _appMetadata;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

 final  Map<String, dynamic>? _userMetadata;
@override Map<String, dynamic>? get userMetadata {
  final value = _userMetadata;
  if (value == null) return null;
  if (_userMetadata is EqualUnmodifiableMapView) return _userMetadata;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

@override final  DateTime? createdAt;
@override final  DateTime? updatedAt;

/// Create a copy of UserModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserModelCopyWith<_UserModel> get copyWith => __$UserModelCopyWithImpl<_UserModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserModel&&(identical(other.id, id) || other.id == id)&&(identical(other.aud, aud) || other.aud == aud)&&(identical(other.role, role) || other.role == role)&&(identical(other.email, email) || other.email == email)&&(identical(other.emailConfirmedAt, emailConfirmedAt) || other.emailConfirmedAt == emailConfirmedAt)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.lastSignInAt, lastSignInAt) || other.lastSignInAt == lastSignInAt)&&const DeepCollectionEquality().equals(other._appMetadata, _appMetadata)&&const DeepCollectionEquality().equals(other._userMetadata, _userMetadata)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,aud,role,email,emailConfirmedAt,phone,lastSignInAt,const DeepCollectionEquality().hash(_appMetadata),const DeepCollectionEquality().hash(_userMetadata),createdAt,updatedAt);

@override
String toString() {
  return 'UserModel(id: $id, aud: $aud, role: $role, email: $email, emailConfirmedAt: $emailConfirmedAt, phone: $phone, lastSignInAt: $lastSignInAt, appMetadata: $appMetadata, userMetadata: $userMetadata, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$UserModelCopyWith<$Res> implements $UserModelCopyWith<$Res> {
  factory _$UserModelCopyWith(_UserModel value, $Res Function(_UserModel) _then) = __$UserModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String? aud, String? role, String? email, String? emailConfirmedAt, String? phone, String? lastSignInAt, Map<String, dynamic>? appMetadata, Map<String, dynamic>? userMetadata, DateTime? createdAt, DateTime? updatedAt
});




}
/// @nodoc
class __$UserModelCopyWithImpl<$Res>
    implements _$UserModelCopyWith<$Res> {
  __$UserModelCopyWithImpl(this._self, this._then);

  final _UserModel _self;
  final $Res Function(_UserModel) _then;

/// Create a copy of UserModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? aud = freezed,Object? role = freezed,Object? email = freezed,Object? emailConfirmedAt = freezed,Object? phone = freezed,Object? lastSignInAt = freezed,Object? appMetadata = freezed,Object? userMetadata = freezed,Object? createdAt = freezed,Object? updatedAt = freezed,}) {
  return _then(_UserModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,aud: freezed == aud ? _self.aud : aud // ignore: cast_nullable_to_non_nullable
as String?,role: freezed == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String?,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,emailConfirmedAt: freezed == emailConfirmedAt ? _self.emailConfirmedAt : emailConfirmedAt // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,lastSignInAt: freezed == lastSignInAt ? _self.lastSignInAt : lastSignInAt // ignore: cast_nullable_to_non_nullable
as String?,appMetadata: freezed == appMetadata ? _self._appMetadata : appMetadata // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,userMetadata: freezed == userMetadata ? _self._userMetadata : userMetadata // ignore: cast_nullable_to_non_nullable
as Map<String, dynamic>?,createdAt: freezed == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime?,updatedAt: freezed == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
