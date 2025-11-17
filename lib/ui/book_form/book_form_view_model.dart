import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

import '../../utils/command.dart';
import '../../utils/result.dart';
import '../../data/repositories/book/book_repository.dart';
import '../../domain/models/book_model.dart';

class BookFormViewModel extends ChangeNotifier {
  BookFormViewModel({
    required BookRepository repository,
    BookModel? book,
  })  : _repository = repository,
        _book = book,
        _isEditMode = book != null {
    saveBookCommand = Command0(_saveBook);

    // Se está em modo de edição, preenche os campos
    if (_isEditMode && book != null) {
      _title = book.title;
      _author = book.author;
      _genre = book.genre;
      _status = book.status ?? 'não lido';
      _rating = book.rating ?? 0;
      _coverUrl = book.coverUrl;
      _notes = book.notes;
    }
  }

  final BookRepository _repository;
  final BookModel? _book;
  final bool _isEditMode;
  final _log = Logger('BookFormViewModel');

  // State
  String _title = '';
  String? _author;
  String? _genre;
  String _status = 'não lido';
  int _rating = 0;
  String? _coverUrl;
  String? _notes;

  // Getters
  bool get isEditMode => _isEditMode;
  String get title => _title;
  String? get author => _author;
  String? get genre => _genre;
  String get status => _status;
  int get rating => _rating;
  String? get coverUrl => _coverUrl;
  String? get notes => _notes;

  // Commands
  late Command0<void> saveBookCommand;

  // Setters
  void setTitle(String value) {
    _title = value;
    notifyListeners();
  }

  void setAuthor(String? value) {
    _author = value;
    notifyListeners();
  }

  void setGenre(String? value) {
    _genre = value;
    notifyListeners();
  }

  void setStatus(String value) {
    _status = value;
    notifyListeners();
  }

  void setRating(int value) {
    _rating = value;
    notifyListeners();
  }

  void setCoverUrl(String? value) {
    _coverUrl = value;
    notifyListeners();
  }

  void setNotes(String? value) {
    _notes = value;
    notifyListeners();
  }

  // Private Actions
  Future<Result<void>> _saveBook() async {
    try {
      if (_title.isEmpty) {
        return Result.error(Exception('Título é obrigatório'));
      }

      Result result;

      if (_isEditMode && _book != null) {
        // Update existing book
        result = await _repository.updateBook(
          bookId: _book.id,
          title: _title,
          author: _author,
          genre: _genre,
          status: _status,
          rating: _rating,
          coverUrl: _coverUrl,
          notes: _notes,
        );
        _log.info('Book updated: $_title');
      } else {
        // Create new book
        result = await _repository.createBook(
          title: _title,
          author: _author,
          genre: _genre,
          status: _status,
          rating: _rating,
          coverUrl: _coverUrl,
          notes: _notes,
        );
        _log.info('Book created: $_title');
      }

      if (result is Error) {
        return result as Error<void>;
      }

      return const Result.ok(null);
    } catch (e, st) {
      _log.severe('Erro ao salvar livro', e, st);
      return Result.error(Exception(e.toString()));
    } finally {
      notifyListeners();
    }
  }

  // Public Methods
  void saveBook() {
    saveBookCommand.execute();
  }
}
