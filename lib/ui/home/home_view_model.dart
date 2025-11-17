import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

import '../../utils/command.dart';
import '../../utils/result.dart';
import '../../data/repositories/book/book_repository.dart';
import '../../domain/models/book_model.dart';

class HomeViewModel extends ChangeNotifier {
  HomeViewModel({required BookRepository repository}) : _repository = repository {
    loadBooksCommand = Command0(_loadBooks);
    deleteBookCommand = Command0(_deleteBook);
    loadStatsCommand = Command0(_loadStats);
  }

  final BookRepository _repository;
  final _log = Logger('HomeViewModel');

  // State
  List<BookModel> _books = [];
  List<BookModel> _filteredBooks = [];
  String? _selectedStatus;
  String? _selectedGenre;
  int _totalBooks = 0;
  int _readBooks = 0;
  int _unreadBooks = 0;

  // Getters
  List<BookModel> get filteredBooks => _filteredBooks;
  String? get selectedStatus => _selectedStatus;
  String? get selectedGenre => _selectedGenre;
  int get totalBooks => _totalBooks;
  int get readBooks => _readBooks;
  int get unreadBooks => _unreadBooks;

  // Commands
  late Command0<void> loadBooksCommand;
  late Command0<void> deleteBookCommand;
  late Command0<void> loadStatsCommand;

  int? _bookToDelete;

  // Setters para filtros
  void setStatusFilter(String? status) {
    if (status == 'Todos os Status' || status?.isEmpty == true) {
      _selectedStatus = null;
    } else {
      _selectedStatus = status;
    }
    loadBooks();
  }

  void setGenreFilter(String? genre) {
    if (genre == 'Todos os Gêneros' || genre?.isEmpty == true) {
      _selectedGenre = null;
    } else {
      _selectedGenre = genre;
    }
    loadBooks();
  }

  // Private methods
  Future<Result<void>> _loadBooks() async {
    try {
      final result = await _repository.listBooks(
        status: _selectedStatus,
        genre: _selectedGenre,
      );

      if (result is Error<List<BookModel>>) {
        return result;
      }

      _books = (result as Ok<List<BookModel>>).value;
      _filteredBooks = _books;

      _log.info('Loaded ${_books.length} books with filters: status=$_selectedStatus, genre=$_selectedGenre');
      return const Result.ok(null);
    } catch (e, st) {
      _log.severe('Erro ao carregar livros', e, st);
      return Result.error(Exception(e.toString()));
    } finally {
      notifyListeners();
    }
  }

  Future<Result<void>> _loadStats() async {
    try {
      final result = await _repository.getBookStats();

      if (result is Error<({int total, int read, int unread})>) {
        return result;
      }

      final stats = (result as Ok<({int total, int read, int unread})>).value;
      _totalBooks = stats.total;
      _readBooks = stats.read;
      _unreadBooks = stats.unread;

      _log.info('Stats: Total=$_totalBooks, Read=$_readBooks, Unread=$_unreadBooks');
      return const Result.ok(null);
    } catch (e, st) {
      _log.severe('Erro ao carregar estatísticas', e, st);
      return Result.error(Exception(e.toString()));
    } finally {
      notifyListeners();
    }
  }

  Future<Result<void>> _deleteBook() async {
    if (_bookToDelete == null) {
      return Result.error(Exception('Nenhum livro selecionado para deletar'));
    }

    try {
      final result = await _repository.deleteBook(_bookToDelete!);

      if (result is Error<void>) {
        return result;
      }

      // Reload books and stats
      await _loadBooks();
      await _loadStats();

      _log.info('Book deleted: $_bookToDelete');
      return const Result.ok(null);
    } catch (e, st) {
      _log.severe('Erro ao deletar livro', e, st);
      return Result.error(Exception(e.toString()));
    } finally {
      _bookToDelete = null;
      notifyListeners();
    }
  }

  // Public methods para chamar os commands
  void loadBooks() {
    loadBooksCommand.execute();
  }

  void loadStats() {
    loadStatsCommand.execute();
  }

  void deleteBook(int bookId) {
    _bookToDelete = bookId;
    deleteBookCommand.execute();
  }

  // Get unique genres from ALL books (without filters)
  Future<List<String>> getUniqueGenres() async {
    try {
      final result = await _repository.listBooks();
      if (result is Ok<List<BookModel>>) {
        final allBooks = result.value;
        final genres = <String>{};
        for (final book in allBooks) {
          if (book.genre != null && book.genre!.isNotEmpty) {
            genres.add(book.genre!);
          }
        }
        return genres.toList()..sort();
      }
      return [];
    } catch (e) {
      _log.warning('Erro ao buscar gêneros únicos', e);
      return [];
    }
  }

  // Get unique statuses from ALL books (without filters)
  Future<List<String>> getUniqueStatuses() async {
    try {
      final result = await _repository.listBooks();
      if (result is Ok<List<BookModel>>) {
        final allBooks = result.value;
        final statuses = <String>{};
        for (final book in allBooks) {
          if (book.status != null && book.status!.isNotEmpty) {
            statuses.add(book.status!);
          }
        }
        return statuses.toList()..sort();
      }
      return [];
    } catch (e) {
      _log.warning('Erro ao buscar status únicos', e);
      return [];
    }
  }
}
