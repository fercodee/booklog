import 'package:logging/logging.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../domain/models/book_model.dart';
import '../../../utils/result.dart';
import '../../services/api/supabase_client.dart';
import 'book_repository.dart';

class SupabaseBookRepository extends BookRepository {
  SupabaseBookRepository({SupabaseClientService? clientService})
      : _service = clientService ?? SupabaseClientService();

  final SupabaseClientService _service;
  final _log = Logger('SupabaseBookRepository');

  // Helper para obter userId ou retornar erro
  String? _currentUserId() {
    final user = _service.client.auth.currentUser;
    return user?.id;
  }

  @override
  Future<Result<List<BookModel>>> listBooks({
    String? status,
    String? genre,
  }) async {
    try {
      final userId = _currentUserId();
      if (userId == null) {
        return Result.error(Exception('Usuário não autenticado'));
      }

      var query = _service.client.from('books').select().eq('user_id', userId);

      if (status != null && status.isNotEmpty) {
        query = query.eq('status', status);
      }

      if (genre != null && genre.isNotEmpty) {
        query = query.eq('genre', genre);
      }

      final data = await query;
      final books = (data as List)
          .map((e) => BookModel.fromJson(e as Map<String, dynamic>))
          .toList();

      return Result.ok(books);
    } on PostgrestException catch (e, st) {
      _log.warning('listBooks failed', e, st);
      return Result.error(Exception(e.message));
    } catch (e, st) {
      _log.severe('listBooks unexpected error', e, st);
      return Result.error(Exception(e.toString()));
    }
  }

  @override
  Future<Result<BookModel>> getBook(int bookId) async {
    try {
      final userId = _currentUserId();
      if (userId == null) {
        return Result.error(Exception('Usuário não autenticado'));
      }

      final data = await _service.client
          .from('books')
          .select()
          .eq('id', bookId)
          .eq('user_id', userId)
          .single();

      final book = BookModel.fromJson(data);
      return Result.ok(book);
    } on PostgrestException catch (e, st) {
      _log.warning('getBook failed', e, st);
      return Result.error(Exception(e.message));
    } catch (e, st) {
      _log.severe('getBook unexpected error', e, st);
      return Result.error(Exception(e.toString()));
    }
  }

  @override
  Future<Result<BookModel>> createBook({
    required String title,
    String? author,
    String? genre,
    String? status,
    int? rating,
    String? coverUrl,
    String? notes,
  }) async {
    try {
      final userId = _currentUserId();
      if (userId == null) {
        return Result.error(Exception('Usuário não autenticado'));
      }

      final data = await _service.client.from('books').insert({
        'title': title,
        'author': author,
        'genre': genre,
        'status': status ?? 'não lido',
        'rating': rating ?? 0,
        'coverUrl': coverUrl,
        'notes': notes,
        'user_id': userId, // <- importante para passar RLS
      }).select().single();

      final book = BookModel.fromJson(data);
      _log.info('Book created: ${book.title}');
      return Result.ok(book);
    } on PostgrestException catch (e, st) {
      _log.warning('createBook failed', e, st);
      return Result.error(Exception(e.message));
    } catch (e, st) {
      _log.severe('createBook unexpected error', e, st);
      return Result.error(Exception(e.toString()));
    }
  }

  @override
  Future<Result<BookModel>> updateBook({
    required int bookId,
    String? title,
    String? author,
    String? genre,
    String? status,
    int? rating,
    String? coverUrl,
    String? notes,
  }) async {
    try {
      final userId = _currentUserId();
      if (userId == null) {
        return Result.error(Exception('Usuário não autenticado'));
      }

      final updateData = <String, dynamic>{};
      if (title != null) updateData['title'] = title;
      if (author != null) updateData['author'] = author;
      if (genre != null) updateData['genre'] = genre;
      if (status != null) updateData['status'] = status;
      if (rating != null) updateData['rating'] = rating;
      if (coverUrl != null) updateData['coverUrl'] = coverUrl;
      if (notes != null) updateData['notes'] = notes;

      final data = await _service.client
          .from('books')
          .update(updateData)
          .eq('id', bookId)
          .eq('user_id', userId) // garante que só atualiza livro do usuário
          .select()
          .single();

      final book = BookModel.fromJson(data);
      _log.info('Book updated: ${book.title}');
      return Result.ok(book);
    } on PostgrestException catch (e, st) {
      _log.warning('updateBook failed', e, st);
      return Result.error(Exception(e.message));
    } catch (e, st) {
      _log.severe('updateBook unexpected error', e, st);
      return Result.error(Exception(e.toString()));
    }
  }

  @override
  Future<Result<void>> deleteBook(int bookId) async {
    try {
      final userId = _currentUserId();
      if (userId == null) {
        return Result.error(Exception('Usuário não autenticado'));
      }

      await _service.client
          .from('books')
          .delete()
          .eq('id', bookId)
          .eq('user_id', userId); // garante que só deleta livro do usuário
      _log.info('Book deleted: $bookId');
      return const Result.ok(null);
    } on PostgrestException catch (e, st) {
      _log.warning('deleteBook failed', e, st);
      return Result.error(Exception(e.message));
    } catch (e, st) {
      _log.severe('deleteBook unexpected error', e, st);
      return Result.error(Exception(e.toString()));
    }
  }

  @override
  Future<Result<({int total, int read, int unread})>> getBookStats() async {
    try {
      final userId = _currentUserId();
      if (userId == null) {
        return Result.error(Exception('Usuário não autenticado'));
      }

      final books = await _service.client
          .from('books')
          .select('status')
          .eq('user_id', userId);

      int total = books.length;
      int read = 0;
      int unread = 0;

      for (final book in books) {
        final status = book['status'] as String?;
        if (status == 'lido') {
          read++;
        } else if (status == 'não lido') {
          unread++;
        }
      }

      return Result.ok((total: total, read: read, unread: unread));
    } on PostgrestException catch (e, st) {
      _log.warning('getBookStats failed', e, st);
      return Result.error(Exception(e.message));
    } catch (e, st) {
      _log.severe('getBookStats unexpected error', e, st);
      return Result.error(Exception(e.toString()));
    }
  }
}
