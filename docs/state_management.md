# Convenção de Gerenciamento de Estado

Este documento descreve a convenção de gerenciamento de estado utilizada no aplicativo [Nome do Aplicativo], baseada no padrão **Command Pattern** combinado com **ChangeNotifier** e **Listeners** do Flutter.

## Índice

1. [Visão Geral](#visão-geral)
2. [Arquitetura](#arquitetura)
3. [Componentes Principais](#componentes-principais)
4. [Padrões e Convenções](#padrões-e-convenções)
5. [Fluxo de Dados](#fluxo-de-dados)
6. [Exemplos Práticos](#exemplos-práticos)
7. [Boas Práticas](#boas-práticas)
8. [Guia para Desenvolvimento Assistido por IA](#guia-para-desenvolvimento-assistido-por-ia)

---

## Visão Geral

O aplicativo utiliza uma arquitetura de gerenciamento de estado que combina:

- **Command Pattern**: Para encapsular ações assíncronas
- **ChangeNotifier**: Para notificar mudanças de estado
- **Listeners**: Para reagir a eventos e estados dos Commands
- **Result Pattern**: Para tratamento de erros tipado

### Benefícios desta Abordagem

- ✅ **Separação clara** entre lógica de negócio e UI
- ✅ **Rastreamento de estados** de execução (running, completed, error)
- ✅ **Testabilidade** melhorada
- ✅ **Reutilização** de comandos em diferentes contextos
- ✅ **Tratamento robusto** de erros
- ✅ **Feedback visual** automático para o usuário

---

## Arquitetura

```
┌─────────────────┐
│   UI (Screen)   │
│  StatefulWidget │
└────────┬────────┘
         │ 1. Injeta via construtor
         │ 2. Adiciona listeners
         │ 3. Executa comandos
         │ 4. Reage a mudanças
         ▼
┌─────────────────┐
│    ViewModel    │
│ ChangeNotifier  │
├─────────────────┤
│ • Properties    │
│ • Commands      │
│ • Logic         │
└────────┬────────┘
         │ Executa
         ▼
┌─────────────────┐
│    Command      │
│ ChangeNotifier  │
├─────────────────┤
│ • running       │
│ • completed     │
│ • error         │
│ • result        │
└────────┬────────┘
         │ Usa
         ▼
┌─────────────────┐
│   Repository    │
│  Data Layer     │
└─────────────────┘
```

---

## Componentes Principais

### 1. Command (`utils/command.dart`)

Base para executar ações assíncronas com rastreamento de estado.

#### Tipos de Command

##### Command0 - Sem argumentos
```dart
late Command0<void> loadDataCommand;

// Inicialização
loadDataCommand = Command0(_loadData);

// Execução
await loadDataCommand.execute();
```

##### Command1 - Com um argumento
```dart
late Command1<void, int> deleteItemCommand;

// Inicialização
deleteItemCommand = Command1(_deleteItem);

// Execução
await deleteItemCommand.execute(itemId);
```

#### Propriedades do Command

```dart
command.running    // bool - true durante execução
command.completed  // bool - true se completou com sucesso
command.error      // bool - true se completou com erro
command.result     // Result<T> - resultado da execução
```

#### Métodos do Command

```dart
command.execute()           // Executa a ação
command.clearResult()       // Limpa o resultado anterior
command.addListener(fn)     // Adiciona listener para mudanças
command.removeListener(fn)  // Remove listener
```

### 2. ViewModel (extends ChangeNotifier)

Contém a lógica de negócio e estado da tela.

#### Estrutura Básica

```dart
class ExampleViewModel extends ChangeNotifier {
  ExampleViewModel({
    required ExampleRepository repository,
  }) : _repository = repository {
    // Inicializar comandos no construtor
    loadDataCommand = Command0(_loadData);
    saveDataCommand = Command1(_saveData);
  }

  final ExampleRepository _repository;
  
  // Estado
  List<Item> _items = [];
  List<Item> get items => _items;
  
  // Commands
  late Command0<void> loadDataCommand;
  late Command1<void, Item> saveDataCommand;
  
  // Ações privadas
  Future<Result<void>> _loadData() async {
    try {
      final result = await _repository.getItems();
      switch (result) {
        case Ok<List<Item>>():
          _items = result.value;
          return Result.ok(null);
        case Error<List<Item>>():
          return Result.error(result.error);
      }
    } catch (e) {
      return Result.error(Exception(e.toString()));
    } finally {
      notifyListeners();
    }
  }
  
  Future<Result<void>> _saveData(Item item) async {
    try {
      final result = await _repository.saveItem(item);
      if (result is Ok) {
        await _loadData(); // Recarregar após salvar
        return Result.ok(null);
      }
      return Result.error(result.error);
    } catch (e) {
      return Result.error(Exception(e.toString()));
    }
  }
}
```

### 3. Screen (StatefulWidget)

Interface do usuário que reage às mudanças do ViewModel.

#### Estrutura Básica

```dart
class ExampleScreen extends StatefulWidget {
  const ExampleScreen({super.key, required this.viewModel});

  final ExampleViewModel viewModel;

  @override
  State<ExampleScreen> createState() => _ExampleScreenState();
}

class _ExampleScreenState extends State<ExampleScreen> {
  @override
  void initState() {
    super.initState();
    
    // 1. Adicionar listeners aos comandos
    widget.viewModel.loadDataCommand.addListener(_onLoadData);
    widget.viewModel.saveDataCommand.addListener(_onSaveData);
    
    // 2. Executar comandos iniciais (se necessário)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.viewModel.loadDataCommand.execute();
    });
  }

  @override
  void dispose() {
    // 3. SEMPRE remover listeners
    widget.viewModel.loadDataCommand.removeListener(_onLoadData);
    widget.viewModel.saveDataCommand.removeListener(_onSaveData);
    super.dispose();
  }

  // 4. Callbacks dos listeners
  void _onLoadData() {
    final command = widget.viewModel.loadDataCommand;
    
    if (command.error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao carregar dados'),
          backgroundColor: Colors.red,
        ),
      );
    } else if (command.completed) {
      // Dados carregados com sucesso
    }
  }

  void _onSaveData() {
    final command = widget.viewModel.saveDataCommand;
    
    if (command.error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao salvar'),
          backgroundColor: Colors.red,
        ),
      );
    } else if (command.completed) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Salvo com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Example')),
      body: ListenableBuilder(
        listenable: widget.viewModel,
        builder: (context, _) {
          // UI reage às mudanças do ViewModel
          if (widget.viewModel.loadDataCommand.running) {
            return Center(child: CircularProgressIndicator());
          }
          
          return ListView.builder(
            itemCount: widget.viewModel.items.length,
            itemBuilder: (context, index) {
              final item = widget.viewModel.items[index];
              return ListTile(title: Text(item.name));
            },
          );
        },
      ),
      floatingActionButton: ListenableBuilder(
        listenable: widget.viewModel.saveDataCommand,
        builder: (context, _) {
          return FloatingActionButton(
            onPressed: widget.viewModel.saveDataCommand.running
                ? null
                : () => widget.viewModel.saveDataCommand.execute(newItem),
            child: widget.viewModel.saveDataCommand.running
                ? CircularProgressIndicator(color: Colors.white)
                : Icon(Icons.save),
          );
        },
      ),
    );
  }
}
```

---

## Padrões e Convenções

### Nomenclatura

#### ViewModels
- **Sufixo**: `ViewModel`
- **Exemplo**: `FormViewModel`, `LoginViewModel`, `HomeViewmodel`

#### Commands
- **Sufixo**: `Command`
- **Padrão**: `<ação><contexto>Command`
- **Exemplos**:
  - `loadDataCommand`
  - `saveItemCommand`
  - `deleteUserCommand`
  - `searchProductCommand`

#### Métodos Privados (ações dos Commands)
- **Prefixo**: `_` (underscore)
- **Padrão**: `_<ação><contexto>`
- **Exemplos**:
  - `_loadData()`
  - `_saveItem(item)`
  - `_deleteUser(userId)`

#### Listeners
- **Prefixo**: `_on`
- **Padrão**: `_on<NomeDoCommand>`
- **Exemplos**:
  - `_onLoadData()`
  - `_onSaveItem()`
  - `_onDeleteUser()`

### Estrutura do ViewModel

```dart
class ExampleViewModel extends ChangeNotifier {
  // 1. Construtor
  ExampleViewModel({
    required Repository repository,
    Type? param,
  }) : _repository = repository {
    // Inicializar commands
    command1 = Command0(_action1);
    command2 = Command1(_action2);
  }

  // 2. Dependencies (private, final)
  final Repository _repository;
  final _log = Logger('ExampleViewModel');

  // 3. State Properties (private com getter público)
  List<Item> _items = [];
  List<Item> get items => _items;
  
  bool _loading = false;
  bool get loading => _loading;

  // 4. Commands (late, public)
  late Command0<void> command1;
  late Command1<void, int> command2;

  // 5. Public Methods (se necessário)
  void updateFilter(String filter) {
    _filter = filter;
    notifyListeners();
  }

  // 6. Private Actions (para Commands)
  Future<Result<void>> _action1() async {
    try {
      // Lógica assíncrona
      final result = await _repository.doSomething();
      
      switch (result) {
        case Ok<Data>():
          _items = result.value;
          return Result.ok(null);
        case Error<Data>():
          return Result.error(result.error);
      }
    } catch (e, stack) {
      _log.severe('Error in action1', e, stack);
      return Result.error(Exception(e.toString()));
    } finally {
      notifyListeners();
    }
  }
}
```

### Estrutura do Screen

```dart
class ExampleScreen extends StatefulWidget {
  const ExampleScreen({super.key, required this.viewModel});

  final ExampleViewModel viewModel;

  @override
  State<ExampleScreen> createState() => _ExampleScreenState();
}

class _ExampleScreenState extends State<ExampleScreen> {
  // 1. Controllers (se necessário)
  final TextEditingController _controller = TextEditingController();

  // 2. initState - Configurar listeners e executar comandos iniciais
  @override
  void initState() {
    super.initState();
    
    // Adicionar listeners
    widget.viewModel.command1.addListener(_onCommand1);
    widget.viewModel.command2.addListener(_onCommand2);
    
    // Executar comandos iniciais
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.viewModel.command1.execute();
    });
  }

  // 3. dispose - Limpar recursos
  @override
  void dispose() {
    _controller.dispose();
    widget.viewModel.command1.removeListener(_onCommand1);
    widget.viewModel.command2.removeListener(_onCommand2);
    super.dispose();
  }

  // 4. Listener Callbacks
  void _onCommand1() {
    final cmd = widget.viewModel.command1;
    
    if (cmd.error) {
      _showError('Erro na operação');
    } else if (cmd.completed) {
      _showSuccess('Operação concluída');
    }
  }

  void _onCommand2() {
    // Implementação
  }

  // 5. Helper Methods
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  // 6. build - UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Title')),
      body: ListenableBuilder(
        listenable: widget.viewModel,
        builder: (context, _) {
          // UI baseada no estado
          return Container();
        },
      ),
    );
  }
}
```

---

## Fluxo de Dados

### 1. Inicialização

```
Screen.initState()
    ↓
Adicionar listeners aos Commands
    ↓
Executar comandos iniciais (opcional)
    ↓
Command.execute() → ViewModel action
```

### 2. Execução de Ação

```
User Action (ex: botão pressionado)
    ↓
Command.execute()
    ↓
Command muda estado (running = true)
    ↓
Command notifica listeners
    ↓
Listener callback executa
    ↓
ViewModel executa ação privada
    ↓
Repository busca/salva dados
    ↓
ViewModel atualiza estado
    ↓
ViewModel chama notifyListeners()
    ↓
Command muda estado (completed ou error)
    ↓
Command notifica listeners
    ↓
Listener callback processa resultado
    ↓
UI atualiza via ListenableBuilder
```

### 3. Limpeza

```
Screen.dispose()
    ↓
Remover listeners dos Commands
    ↓
Liberar outros recursos (controllers, etc)
```

---

## Exemplos Práticos

### Exemplo 1: Carregar e Exibir Lista

#### ViewModel
```dart
class ProductsViewModel extends ChangeNotifier {
  ProductsViewModel({
    required ProductRepository repository,
  }) : _repository = repository {
    loadProductsCommand = Command0(_loadProducts);
  }

  final ProductRepository _repository;
  
  List<Product> _products = [];
  List<Product> get products => _products;
  
  late Command0<void> loadProductsCommand;
  
  Future<Result<void>> _loadProducts() async {
    try {
      final result = await _repository.getAllProducts();
      
      if (result is Ok<List<Product>>) {
        _products = result.value;
        return Result.ok(null);
      }
      
      return Result.error(result.error);
    } finally {
      notifyListeners();
    }
  }
}
```

#### Screen
```dart
class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key, required this.viewModel});
  final ProductsViewModel viewModel;

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.loadProductsCommand.addListener(_onLoadProducts);
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.viewModel.loadProductsCommand.execute();
    });
  }

  @override
  void dispose() {
    widget.viewModel.loadProductsCommand.removeListener(_onLoadProducts);
    super.dispose();
  }

  void _onLoadProducts() {
    if (widget.viewModel.loadProductsCommand.error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao carregar produtos'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Produtos')),
      body: ListenableBuilder(
        listenable: widget.viewModel,
        builder: (context, _) {
          if (widget.viewModel.loadProductsCommand.running) {
            return Center(child: CircularProgressIndicator());
          }
          
          return ListView.builder(
            itemCount: widget.viewModel.products.length,
            itemBuilder: (context, index) {
              final product = widget.viewModel.products[index];
              return ListTile(
                title: Text(product.name),
                subtitle: Text('\$${product.price}'),
              );
            },
          );
        },
      ),
    );
  }
}
```

### Exemplo 2: Formulário com Salvamento

#### ViewModel
```dart
class FormViewModel extends ChangeNotifier {
  FormViewModel({
    required ItemRepository repository,
    Item? itemToEdit,
  }) : _repository = repository {
    if (itemToEdit != null) {
      _isEditing = true;
      _item = itemToEdit;
      name = itemToEdit.name;
      description = itemToEdit.description;
    }
    
    saveCommand = Command0(_save);
  }

  final ItemRepository _repository;
  
  bool _isEditing = false;
  bool get isEditing => _isEditing;
  
  Item? _item;
  
  String? name;
  String? description;
  
  late Command0<void> saveCommand;
  
  Future<Result<void>> _save() async {
    if (name == null || name!.isEmpty) {
      return Result.error(Exception('Nome é obrigatório'));
    }
    
    try {
      final item = Item(
        id: _item?.id,
        name: name!,
        description: description,
      );
      
      final result = _isEditing
          ? await _repository.update(item)
          : await _repository.create(item);
      
      if (result is Ok) {
        return Result.ok(null);
      }
      
      return Result.error(result.error);
    } catch (e) {
      return Result.error(Exception(e.toString()));
    } finally {
      notifyListeners();
    }
  }
}
```

#### Screen
```dart
class FormScreen extends StatefulWidget {
  const FormScreen({super.key, required this.viewModel});
  final FormViewModel viewModel;

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    widget.viewModel.saveCommand.addListener(_onSave);
    
    // Preencher campos se estiver editando
    if (widget.viewModel.isEditing) {
      _nameController.text = widget.viewModel.name ?? '';
      _descriptionController.text = widget.viewModel.description ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    widget.viewModel.saveCommand.removeListener(_onSave);
    super.dispose();
  }

  void _onSave() {
    final command = widget.viewModel.saveCommand;
    
    if (command.error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao salvar'),
          backgroundColor: Colors.red,
        ),
      );
    } else if (command.completed) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Salvo com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.of(context).pop();
    }
  }

  void _handleSave() {
    if (_formKey.currentState?.validate() ?? false) {
      widget.viewModel.name = _nameController.text;
      widget.viewModel.description = _descriptionController.text;
      widget.viewModel.saveCommand.execute();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.viewModel.isEditing ? 'Editar Item' : 'Novo Item',
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Nome'),
              validator: (value) =>
                  value?.isEmpty ?? true ? 'Campo obrigatório' : null,
            ),
            SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Descrição'),
              maxLines: 3,
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(16),
        child: ListenableBuilder(
          listenable: widget.viewModel.saveCommand,
          builder: (context, _) {
            return ElevatedButton(
              onPressed: widget.viewModel.saveCommand.running
                  ? null
                  : _handleSave,
              child: widget.viewModel.saveCommand.running
                  ? CircularProgressIndicator()
                  : Text('SALVAR'),
            );
          },
        ),
      ),
    );
  }
}
```

### Exemplo 3: Deletar Item com Confirmação

#### ViewModel
```dart
class ItemsViewModel extends ChangeNotifier {
  ItemsViewModel({
    required ItemRepository repository,
  }) : _repository = repository {
    loadItemsCommand = Command0(_loadItems);
    deleteItemCommand = Command1(_deleteItem);
  }

  final ItemRepository _repository;
  
  List<Item> _items = [];
  List<Item> get items => _items;
  
  late Command0<void> loadItemsCommand;
  late Command1<void, int> deleteItemCommand;
  
  Future<Result<void>> _loadItems() async {
    try {
      final result = await _repository.getAll();
      
      if (result is Ok<List<Item>>) {
        _items = result.value;
        return Result.ok(null);
      }
      
      return Result.error(result.error);
    } finally {
      notifyListeners();
    }
  }
  
  Future<Result<void>> _deleteItem(int itemId) async {
    try {
      final result = await _repository.delete(itemId);
      
      if (result is Ok) {
        // Recarrega a lista após deletar
        await _loadItems();
        return Result.ok(null);
      }
      
      return Result.error(result.error);
    } catch (e) {
      return Result.error(Exception(e.toString()));
    }
  }
}
```

#### Screen
```dart
class ItemsScreen extends StatefulWidget {
  const ItemsScreen({super.key, required this.viewModel});
  final ItemsViewModel viewModel;

  @override
  State<ItemsScreen> createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.loadItemsCommand.addListener(_onLoadItems);
    widget.viewModel.deleteItemCommand.addListener(_onDeleteItem);
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.viewModel.loadItemsCommand.execute();
    });
  }

  @override
  void dispose() {
    widget.viewModel.loadItemsCommand.removeListener(_onLoadItems);
    widget.viewModel.deleteItemCommand.removeListener(_onDeleteItem);
    super.dispose();
  }

  void _onLoadItems() {
    if (widget.viewModel.loadItemsCommand.error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao carregar itens'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _onDeleteItem() {
    final command = widget.viewModel.deleteItemCommand;
    
    if (command.completed) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Item deletado com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );
    } else if (command.error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao deletar item'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _showDeleteDialog(int itemId) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirmar exclusão'),
        content: Text('Deseja realmente deletar este item?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text('Deletar'),
          ),
        ],
      ),
    );

    if (shouldDelete == true) {
      widget.viewModel.deleteItemCommand.execute(itemId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Itens')),
      body: ListenableBuilder(
        listenable: widget.viewModel,
        builder: (context, _) {
          if (widget.viewModel.loadItemsCommand.running) {
            return Center(child: CircularProgressIndicator());
          }
          
          if (widget.viewModel.items.isEmpty) {
            return Center(child: Text('Nenhum item encontrado'));
          }
          
          return ListView.builder(
            itemCount: widget.viewModel.items.length,
            itemBuilder: (context, index) {
              final item = widget.viewModel.items[index];
              return ListTile(
                title: Text(item.name),
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _showDeleteDialog(item.id),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
```

---

## Boas Práticas

### ✅ DO (Faça)

1. **Sempre remova listeners no dispose**
   ```dart
   @override
   void dispose() {
     widget.viewModel.command.removeListener(_onCommand);
     super.dispose();
   }
   ```

2. **Use `WidgetsBinding.instance.addPostFrameCallback` para comandos iniciais**
   ```dart
   @override
   void initState() {
     super.initState();
     WidgetsBinding.instance.addPostFrameCallback((_) {
       widget.viewModel.loadCommand.execute();
     });
   }
   ```

3. **Verifique o estado do comando no listener**
   ```dart
   void _onCommand() {
     final cmd = widget.viewModel.command;
     
     if (cmd.error) {
       // Tratar erro
     } else if (cmd.completed) {
       // Tratar sucesso
     }
   }
   ```

4. **Use `ListenableBuilder` para reagir a mudanças do ViewModel**
   ```dart
   ListenableBuilder(
     listenable: widget.viewModel,
     builder: (context, _) {
       // UI reage às mudanças
       return Widget();
     },
   )
   ```

5. **Retorne sempre `Result<T>` das ações privadas**
   ```dart
   Future<Result<void>> _action() async {
     try {
       // operação
       return Result.ok(null);
     } catch (e) {
       return Result.error(Exception(e.toString()));
     }
   }
   ```

6. **Chame `notifyListeners()` no `finally` do try-catch**
   ```dart
   Future<Result<void>> _action() async {
     try {
       // operação
     } finally {
       notifyListeners();
     }
   }
   ```

7. **Use logger para debug**
   ```dart
   final _log = Logger('ViewModelName');
   
   Future<Result<void>> _action() async {
     _log.info('Starting action');
     try {
       // operação
     } catch (e, stack) {
       _log.severe('Error in action', e, stack);
     }
   }
   ```

8. **Desabilite botões durante execução de comando**
   ```dart
   ElevatedButton(
     onPressed: command.running ? null : () => command.execute(),
     child: command.running
         ? CircularProgressIndicator()
         : Text('Salvar'),
   )
   ```

### ❌ DON'T (Não Faça)

1. **Não esqueça de remover listeners**
   ```dart
   // ❌ Evite memory leaks
   @override
   void dispose() {
     super.dispose(); // Sem remover listeners
   }
   ```

2. **Não execute comandos assíncronos no initState diretamente**
   ```dart
   // ❌ Errado
   @override
   void initState() {
     super.initState();
     widget.viewModel.loadCommand.execute(); // Pode causar problemas
   }
   
   // ✅ Correto
   @override
   void initState() {
     super.initState();
     WidgetsBinding.instance.addPostFrameCallback((_) {
       widget.viewModel.loadCommand.execute();
     });
   }
   ```

3. **Não use setState dentro do ViewModel**
   ```dart
   // ❌ ViewModel não deve ter setState
   class MyViewModel extends ChangeNotifier {
     void update() {
       setState(() {}); // ERRADO
     }
   }
   
   // ✅ Use notifyListeners()
   class MyViewModel extends ChangeNotifier {
     void update() {
       notifyListeners(); // CORRETO
     }
   }
   ```

4. **Não acesse BuildContext em métodos assíncronos sem verificar mounted**
   ```dart
   // ❌ Pode causar erro se o widget for desmontado
   void _onCommand() async {
     await someAsyncOperation();
     ScaffoldMessenger.of(context).showSnackBar(...);
   }
   
   // ✅ Verifique mounted
   void _onCommand() async {
     await someAsyncOperation();
     if (!mounted) return;
     ScaffoldMessenger.of(context).showSnackBar(...);
   }
   ```

5. **Não manipule estado diretamente na UI**
   ```dart
   // ❌ Lógica de negócio na UI
   void _handleSave() {
     final data = await repository.save();
     setState(() => items = data);
   }
   
   // ✅ Delegue ao ViewModel
   void _handleSave() {
     widget.viewModel.saveCommand.execute();
   }
   ```

6. **Não crie múltiplos listeners para o mesmo propósito**
   ```dart
   // ❌ Listeners duplicados
   @override
   void initState() {
     super.initState();
     widget.viewModel.addListener(_rebuild);
     widget.viewModel.addListener(_rebuild); // Duplicado
   }
   ```

7. **Não exponha métodos internos do ViewModel**
   ```dart
   // ❌ Expor método privado
   class MyViewModel extends ChangeNotifier {
     Future<void> loadData() async { } // Público
   }
   
   // ✅ Use Command
   class MyViewModel extends ChangeNotifier {
     late Command0<void> loadDataCommand;
     Future<Result<void>> _loadData() async { } // Privado
   }
   ```

---

## Guia para Desenvolvimento Assistido por IA

### Prompts Efetivos

#### Para criar um novo ViewModel:

```
Crie um ViewModel seguindo a convenção do projeto:
- Nome: <Nome>ViewModel
- Deve estender ChangeNotifier
- Repository: <NomeRepository>
- Comandos necessários: 
  - loadDataCommand: carrega lista de <Entidade>
  - saveItemCommand: salva um <Entidade>
- Estado: lista de <Entidade>
- Usar Result pattern para retorno
- Adicionar logger
```

#### Para criar um Screen:

```
Crie um Screen seguindo a convenção do projeto:
- Nome: <Nome>Screen
- ViewModel: <Nome>ViewModel
- Deve ser StatefulWidget
- Adicionar listeners para todos os comandos do ViewModel
- Exibir SnackBar para erros e sucessos
- Usar ListenableBuilder para reagir a mudanças
- Lembrar de remover listeners no dispose
```

#### Para adicionar um novo Command:

```
Adicione um novo Command ao <Nome>ViewModel:
- Nome: <ação>Command
- Tipo: Command0 (sem argumentos) ou Command1<void, TipoDoArgumento>
- Ação privada: _<ação>
- A ação deve chamar o repository e retornar Result<void>
- Usar try-catch-finally com notifyListeners no finally
```

### Checklist para Revisão de Código

#### ViewModel
- [ ] Estende `ChangeNotifier`
- [ ] Todos os Commands são inicializados no construtor
- [ ] Ações privadas retornam `Result<T>`
- [ ] `notifyListeners()` é chamado no `finally`
- [ ] Logger está configurado
- [ ] Propriedades de estado são privadas com getters públicos
- [ ] Tratamento de erros adequado

#### Screen
- [ ] É um `StatefulWidget`
- [ ] Listeners são adicionados em `initState`
- [ ] Listeners são removidos em `dispose`
- [ ] Comandos iniciais usam `addPostFrameCallback`
- [ ] Callbacks de listeners verificam `error` e `completed`
- [ ] Usa `ListenableBuilder` para reagir a mudanças
- [ ] Mostra feedback visual (SnackBar, Dialog, etc)
- [ ] Desabilita ações durante execução de Commands

#### Command
- [ ] Tipo correto (`Command0` ou `Command1`)
- [ ] Nome segue convenção (`<ação>Command`)
- [ ] Action privada segue convenção (`_<ação>`)
- [ ] Retorna `Result<T>`
- [ ] Tratamento de erros apropriado

### Templates Rápidos

#### Template ViewModel Básico
```dart
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:nivel_diario_acude/utils/command.dart';
import 'package:nivel_diario_acude/utils/result.dart';

class ${1:Name}ViewModel extends ChangeNotifier {
  ${1:Name}ViewModel({
    required ${2:Repository} repository,
  }) : _repository = repository {
    ${3:load}Command = Command0(_${3:load});
  }

  final ${2:Repository} _repository;
  final _log = Logger('${1:Name}ViewModel');

  List<${4:Entity}> _items = [];
  List<${4:Entity}> get items => _items;

  late Command0<void> ${3:load}Command;

  Future<Result<void>> _${3:load}() async {
    try {
      final result = await _repository.getAll();
      
      if (result is Ok<List<${4:Entity}>>) {
        _items = result.value;
        return Result.ok(null);
      }
      
      return Result.error(result.error);
    } catch (e, stack) {
      _log.severe('Error loading data', e, stack);
      return Result.error(Exception(e.toString()));
    } finally {
      notifyListeners();
    }
  }
}
```

#### Template Screen Básico
```dart
import 'package:flutter/material.dart';

class ${1:Name}Screen extends StatefulWidget {
  const ${1:Name}Screen({super.key, required this.viewModel});

  final ${2:Name}ViewModel viewModel;

  @override
  State<${1:Name}Screen> createState() => _${1:Name}ScreenState();
}

class _${1:Name}ScreenState extends State<${1:Name}Screen> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.${3:command}.addListener(_on${4:Command});
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.viewModel.${3:command}.execute();
    });
  }

  @override
  void dispose() {
    widget.viewModel.${3:command}.removeListener(_on${4:Command});
    super.dispose();
  }

  void _on${4:Command}() {
    final cmd = widget.viewModel.${3:command};
    
    if (cmd.error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro na operação'),
          backgroundColor: Colors.red,
        ),
      );
    } else if (cmd.completed) {
      // Sucesso
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${5:Title}')),
      body: ListenableBuilder(
        listenable: widget.viewModel,
        builder: (context, _) {
          if (widget.viewModel.${3:command}.running) {
            return Center(child: CircularProgressIndicator());
          }
          
          return Container(); // Sua UI aqui
        },
      ),
    );
  }
}
```

---

## Conclusão

Esta convenção de gerenciamento de estado proporciona:

- **Separação clara de responsabilidades**: UI e lógica de negócio bem separadas
- **Testabilidade**: ViewModels podem ser testados independentemente
- **Rastreabilidade**: Estados de execução são facilmente rastreáveis
- **Manutenibilidade**: Código organizado e previsível
- **Experiência do usuário**: Feedback visual automático e consistente

Ao seguir estas convenções, o código se torna mais legível, manutenível e adequado para desenvolvimento assistido por IA, pois os padrões são claros e consistentes em todo o projeto.

---

**Documentação criada em:** Outubro de 2025
**Versão:** 1.0
**Projeto:** [Nome do Projeto] - [Descrição curta do projeto]