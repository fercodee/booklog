// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BookModel _$BookModelFromJson(Map<String, dynamic> json) => _BookModel(
  id: (json['id'] as num).toInt(),
  userId: json['userId'] as String?,
  title: json['title'] as String,
  author: json['author'] as String?,
  genre: json['genre'] as String?,
  status: json['status'] as String?,
  rating: (json['rating'] as num?)?.toInt(),
  coverUrl: json['coverUrl'] as String?,
  notes: json['notes'] as String?,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$BookModelToJson(_BookModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'title': instance.title,
      'author': instance.author,
      'genre': instance.genre,
      'status': instance.status,
      'rating': instance.rating,
      'coverUrl': instance.coverUrl,
      'notes': instance.notes,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
