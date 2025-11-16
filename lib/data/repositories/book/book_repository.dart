import '../../../domain/models/book_model.dart';
import '../../../utils/result.dart';

/// Abstração para operações CRUD com livros.
/// Implementações podem usar Supabase, mocks, etc.
abstract class BookRepository {
  /// Lista todos os livros do usuário autenticado.
  /// Se [status] ou [genre] são fornecidos, filtra por esses campos.
  Future<Result<List<BookModel>>> listBooks({
    String? status,
    String? genre,
  });

  /// Obtém um livro pelo ID.
  Future<Result<BookModel>> getBook(int bookId);

  /// Cria um novo livro.
  Future<Result<BookModel>> createBook({
    required String title,
    String? author,
    String? genre,
    String? status,
    int? rating,
    String? coverUrl,
    String? notes,
  });

  /// Atualiza um livro existente.
  Future<Result<BookModel>> updateBook({
    required int bookId,
    String? title,
    String? author,
    String? genre,
    String? status,
    int? rating,
    String? coverUrl,
    String? notes,
  });

  /// Deleta um livro.
  Future<Result<void>> deleteBook(int bookId);

  /// Retorna estatísticas dos livros do usuário (total, lidos, não lidos).
  Future<Result<({int total, int read, int unread})>> getBookStats();
}
