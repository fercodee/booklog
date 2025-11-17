import 'package:freezed_annotation/freezed_annotation.dart';

part 'book_model.freezed.dart';
part 'book_model.g.dart';

@freezed
abstract class BookModel with _$BookModel {
  const factory BookModel({
    required int id,
    String? userId,
    required String title,
    String? author,
    String? genre,
    String? status, // 'lido' ou 'não lido'
    int? rating, // 0-5
    String? coverUrl,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _BookModel;

  factory BookModel.fromJson(Map<String, dynamic> json) => _$BookModelFromJson(json);
}
