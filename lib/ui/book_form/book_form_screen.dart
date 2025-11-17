import 'package:flutter/material.dart';

import '../../ui/core/colors.dart';
import 'book_form_view_model.dart';

class BookFormScreen extends StatefulWidget {
  const BookFormScreen({super.key, required this.viewModel});

  final BookFormViewModel viewModel;

  @override
  State<BookFormScreen> createState() => _BookFormScreenState();
}

class _BookFormScreenState extends State<BookFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _genreController = TextEditingController();
  final _coverUrlController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Preenche os campos se estiver em modo de edição
    _titleController.text = widget.viewModel.title;
    _authorController.text = widget.viewModel.author ?? '';
    _genreController.text = widget.viewModel.genre ?? '';
    _coverUrlController.text = widget.viewModel.coverUrl ?? '';
    _notesController.text = widget.viewModel.notes ?? '';

    // Add listener to save command
    widget.viewModel.saveBookCommand.addListener(_onSaveBook);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _genreController.dispose();
    _coverUrlController.dispose();
    _notesController.dispose();
    widget.viewModel.saveBookCommand.removeListener(_onSaveBook);
    super.dispose();
  }

  void _onSaveBook() {
    final cmd = widget.viewModel.saveBookCommand;
    if (cmd.error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text((cmd.result as dynamic).error?.toString() ?? 'Erro ao salvar livro'),
          backgroundColor: AppColors.error,
        ),
      );
    } else if (cmd.completed) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.viewModel.isEditMode
              ? 'Livro atualizado com sucesso!'
              : 'Livro cadastrado com sucesso!'),
          backgroundColor: AppColors.success,
        ),
      );
      // Retorna true para indicar que precisa recarregar a lista
      Navigator.pop(context, true);
    }
  }

  void _handleSave() {
    if (_formKey.currentState?.validate() ?? false) {
      widget.viewModel.setTitle(_titleController.text);
      widget.viewModel.setAuthor(_authorController.text.isEmpty ? null : _authorController.text);
      widget.viewModel.setGenre(_genreController.text.isEmpty ? null : _genreController.text);
      widget.viewModel.setCoverUrl(
          _coverUrlController.text.isEmpty ? null : _coverUrlController.text);
      widget.viewModel.setNotes(_notesController.text.isEmpty ? null : _notesController.text);

      widget.viewModel.saveBook();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.viewModel.isEditMode ? 'Editar Livro' : 'Novo Livro'),
      ),
      body: ListenableBuilder(
        listenable: widget.viewModel,
        builder: (context, _) {
          final isLoading = widget.viewModel.saveBookCommand.running;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Título
                  TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Título *',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.book),
                    ),
                    enabled: !isLoading,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Título é obrigatório';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Autor
                  TextFormField(
                    controller: _authorController,
                    decoration: const InputDecoration(
                      labelText: 'Autor',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                    ),
                    enabled: !isLoading,
                  ),
                  const SizedBox(height: 16),

                  // Gênero
                  TextFormField(
                    controller: _genreController,
                    decoration: const InputDecoration(
                      labelText: 'Gênero',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.category),
                    ),
                    enabled: !isLoading,
                  ),
                  const SizedBox(height: 16),

                  // Status
                  DropdownButtonFormField<String>(
                    value: widget.viewModel.status,
                    decoration: const InputDecoration(
                      labelText: 'Status',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.library_books),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'lido', child: Text('Lido')),
                      DropdownMenuItem(value: 'não lido', child: Text('Não lido')),
                    ],
                    onChanged: isLoading
                        ? null
                        : (value) {
                            if (value != null) {
                              widget.viewModel.setStatus(value);
                            }
                          },
                  ),
                  const SizedBox(height: 16),

                  // Avaliação (Estrelas)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Avaliação',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: List.generate(5, (index) {
                          return IconButton(
                            icon: Icon(
                              index < widget.viewModel.rating
                                  ? Icons.star
                                  : Icons.star_border,
                              color: AppColors.warning,
                              size: 32,
                            ),
                            onPressed: isLoading
                                ? null
                                : () {
                                    widget.viewModel.setRating(index + 1);
                                  },
                          );
                        }),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // URL da Capa
                  TextFormField(
                    controller: _coverUrlController,
                    decoration: const InputDecoration(
                      labelText: 'URL da Capa',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.image),
                    ),
                    enabled: !isLoading,
                  ),
                  const SizedBox(height: 16),

                  // Notas
                  TextFormField(
                    controller: _notesController,
                    decoration: const InputDecoration(
                      labelText: 'Notas',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.notes),
                      alignLabelWithHint: true,
                    ),
                    maxLines: 4,
                    enabled: !isLoading,
                  ),
                  const SizedBox(height: 24),

                  // Botão Salvar
                  ElevatedButton(
                    onPressed: isLoading ? null : _handleSave,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.textOnPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(AppColors.textOnPrimary),
                            ),
                          )
                        : Text(widget.viewModel.isEditMode ? 'Atualizar' : 'Cadastrar'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
