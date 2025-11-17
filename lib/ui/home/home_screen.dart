import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../routing/routes.dart';
import '../../ui/core/colors.dart';
import 'home_view_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.viewModel});

  final HomeViewModel viewModel;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _selectedStatus;
  String? _selectedGenre;

  @override
  void initState() {
    super.initState();
    _setupListeners();
    _loadData();
  }

  @override
  void didUpdateWidget(HomeScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Se o viewModel mudou, atualiza listeners e recarrega dados
    if (oldWidget.viewModel != widget.viewModel) {
      _removeListeners(oldWidget);
      _setupListeners();
      _loadData();
    }
  }

  void _setupListeners() {
    // Listeners para commands
    widget.viewModel.loadBooksCommand.addListener(_onBooksLoaded);
    widget.viewModel.deleteBookCommand.addListener(_onBookDeleted);
    widget.viewModel.loadStatsCommand.addListener(_onStatsLoaded);
  }

  void _removeListeners(HomeScreen screen) {
    screen.viewModel.loadBooksCommand.removeListener(_onBooksLoaded);
    screen.viewModel.deleteBookCommand.removeListener(_onBookDeleted);
    screen.viewModel.loadStatsCommand.removeListener(_onStatsLoaded);
  }

  void _loadData() {
    // Carrega livros e estatísticas
    widget.viewModel.loadBooks();
    widget.viewModel.loadStats();
  }

  @override
  void dispose() {
    _removeListeners(widget);
    super.dispose();
  }

  void _onBooksLoaded() {
    final cmd = widget.viewModel.loadBooksCommand;
    if (cmd.error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text((cmd.result as dynamic).error?.toString() ?? 'Erro ao carregar livros'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  void _onStatsLoaded() {
    final cmd = widget.viewModel.loadStatsCommand;
    if (cmd.error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text((cmd.result as dynamic).error?.toString() ?? 'Erro ao carregar estatísticas'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  void _onBookDeleted() {
    final cmd = widget.viewModel.deleteBookCommand;
    if (cmd.error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text((cmd.result as dynamic).error?.toString() ?? 'Erro ao deletar livro'),
          backgroundColor: AppColors.error,
        ),
      );
    } else if (cmd.completed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Livro deletado com sucesso!'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  void _showDeleteConfirmation(int bookId, String bookTitle) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Deletar Livro'),
        content: Text('Tem certeza que deseja deletar "$bookTitle"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              widget.viewModel.deleteBook(bookId);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text('Deletar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Minha Biblioteca'),
            SizedBox(height: 8),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
            child: ListenableBuilder(
              listenable: widget.viewModel,
              builder: (context, _) {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildBadge('Total: ${widget.viewModel.totalBooks}'),
                      const SizedBox(width: 12),
                      _buildBadge('Lidos: ${widget.viewModel.readBooks}'),
                      const SizedBox(width: 12),
                      _buildBadge('Não lidos: ${widget.viewModel.unreadBooks}'),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
      body: ListenableBuilder(
        listenable: widget.viewModel,
        builder: (context, _) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Seção Filtros
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Filtro',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          // Status Filter
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.gray100,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: FutureBuilder<List<String>>(
                                future: widget.viewModel.getUniqueStatuses(),
                                builder: (context, snapshot) {
                                  final statuses = snapshot.data ?? [];
                                  return DropdownButton<String>(
                                    value: _selectedStatus ?? 'Todos os Status',
                                    isExpanded: true,
                                    underline: const SizedBox(),
                                    padding: const EdgeInsets.symmetric(horizontal: 12),
                                    items: [
                                      const DropdownMenuItem(
                                        value: 'Todos os Status',
                                        child: Text('Todos os Status'),
                                      ),
                                      ...statuses.map(
                                        (status) => DropdownMenuItem(
                                          value: status,
                                          child: Text(status),
                                        ),
                                      ),
                                    ],
                                    onChanged: (value) {
                                      setState(() => _selectedStatus = value);
                                      widget.viewModel.setStatusFilter(value);
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Genre Filter
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.gray100,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: FutureBuilder<List<String>>(
                                future: widget.viewModel.getUniqueGenres(),
                                builder: (context, snapshot) {
                                  final genres = snapshot.data ?? [];
                                  return DropdownButton<String>(
                                    value: _selectedGenre ?? 'Todos os Gêneros',
                                    isExpanded: true,
                                    underline: const SizedBox(),
                                    padding: const EdgeInsets.symmetric(horizontal: 12),
                                    items: [
                                      const DropdownMenuItem(
                                        value: 'Todos os Gêneros',
                                        child: Text('Todos os Gêneros'),
                                      ),
                                      ...genres.map(
                                        (genre) => DropdownMenuItem(
                                          value: genre,
                                          child: Text(genre),
                                        ),
                                      ),
                                    ],
                                    onChanged: (value) {
                                      setState(() => _selectedGenre = value);
                                      widget.viewModel.setGenreFilter(value);
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Lista de Livros
                if (widget.viewModel.filteredBooks.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 32),
                    child: Center(
                      child: Text(
                        'Nenhum livro encontrado',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppColors.gray700,
                        ),
                      ),
                    ),
                  )
                else
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: widget.viewModel.filteredBooks.length,
                      itemBuilder: (context, index) {
                        final book = widget.viewModel.filteredBooks[index];
                        return _buildBookCard(context, book);
                      },
                    ),
                  ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (mounted) {
            final result = await context.push(Routes.bookNew);
            if (mounted && result == true) {
              widget.viewModel.loadBooks();
              widget.viewModel.loadStats();
            }
          }
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.gray200,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildBookCard(BuildContext context, final book) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Capa do livro
            Container(
              width: 80,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.gray100,
                borderRadius: BorderRadius.circular(4),
              ),
              child: book.coverUrl != null && book.coverUrl!.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Image.network(
                        book.coverUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Center(
                            child: Icon(
                              Icons.book,
                              color: AppColors.gray500,
                              size: 40,
                            ),
                          );
                        },
                      ),
                    )
                  : Center(
                      child: Icon(
                        Icons.book,
                        color: AppColors.gray500,
                        size: 40,
                      ),
                    ),
            ),
            const SizedBox(width: 12),
            // Informações do livro
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              book.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'por ${book.author ?? 'Autor desconhecido'}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.gray700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Botões de ação
                      PopupMenuButton(
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            child: const Row(
                              children: [
                                Icon(Icons.edit, size: 18),
                                SizedBox(width: 8),
                                Text('Editar'),
                              ],
                            ),
                            onTap: () async {
                              // Aguarda um frame para evitar erro de contexto no PopupMenu
                              await Future.delayed(Duration.zero);
                              if (context.mounted) {
                                final result = await context.push(Routes.bookEdit, extra: book);
                                if (result == true) {
                                  widget.viewModel.loadBooks();
                                  widget.viewModel.loadStats();
                                }
                              }
                            },
                          ),
                          PopupMenuItem(
                            child: const Row(
                              children: [
                                Icon(Icons.delete, size: 18, color: AppColors.error),
                                SizedBox(width: 8),
                                Text('Deletar', style: TextStyle(color: AppColors.error)),
                              ],
                            ),
                            onTap: () {
                              _showDeleteConfirmation(book.id, book.title);
                            },
                          ),
                        ],
                        child: const Icon(Icons.more_vert),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Badges de gênero e status
                  Row(
                    children: [
                      if (book.genre != null && book.genre!.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.gray200,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            book.genre!,
                            style: const TextStyle(fontSize: 11),
                          ),
                        ),
                      const SizedBox(width: 8),
                      if (book.status != null && book.status!.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: book.status == 'lido'
                                ? AppColors.success
                                : AppColors.warning,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            book.status!,
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textOnPrimary,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
