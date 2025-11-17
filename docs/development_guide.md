# 🚀 Guia Rápido de Desenvolvimento

Guia rápido para desenvolvedores trabalharem no projeto Book Log.

## Primeiro Acesso ao Projeto

### 1. Clonar e Preparar

```bash
# Clonar repositório
git clone <repo-url>
cd book_log

# Instalar dependências
flutter pub get

# Gerar código
dart run build_runner build
```

### 2. Configurar Supabase

- Copiar credenciais do projeto Supabase
- Criar arquivo `.env`:

```
SUPABASE_URL=https://seu-projeto.supabase.co
SUPABASE_ANON_KEY=sua-chave-anonima
```

### 3. Executar

```bash
flutter run
```

## Estrutura de Pastas

```
lib/
├── main.dart                     # Entrada
├── configs/dependencies.dart     # DI (Provider)
├── data/                         # Acesso a dados
├── domain/models/                # Modelos
├── routing/                      # Navegação (GoRouter)
├── ui/                           # Telas (MVVM)
└── utils/                        # Utilitários (Command, Result)
```

## Tarefas Comuns

### Adicionar Novo Campo ao Livro

1. **Atualizar `book_model.dart`:**

```dart
@freezed
abstract class BookModel with _$BookModel {
  const factory BookModel({
    // ... campos existentes
    String? newField,  // ← Novo campo
  }) = _BookModel;
}
```

2. **Regenerar código:**

```bash
dart run build_runner build
```

3. **Atualizar banco de dados (Supabase):**

```sql
ALTER TABLE public.books ADD COLUMN new_field TEXT;
```

### Adicionar Nova Tela

1. **Criar pasta:**

```bash
mkdir lib/ui/nova_tela
```

2. **Criar tela:**

```dart
// lib/ui/nova_tela/nova_tela_screen.dart
class NovaTela extends StatefulWidget {
  const NovaTela({required this.viewModel});
  final NovaTelAViewModel viewModel;
  
  @override
  State<NovaTela> createState() => _NovaTelAState();
}

class _NovaTelAState extends State<NovaTela> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nova Tela')),
    );
  }
}
```

3. **Criar ViewModel:**

```dart
// lib/ui/nova_tela/nova_tela_view_model.dart
class NovaTelAViewModel extends ChangeNotifier {
  NovaTelAViewModel({required BookRepository repository})
    : _repository = repository;
    
  final BookRepository _repository;
}
```

4. **Registrar rota:**

```dart
// routing/routes.dart
abstract final class Routes {
  static const novaTela = '/nova-tela';
}

// routing/router.dart
GoRoute(
  path: Routes.novaTela,
  builder: (context, state) => NovaTela(
    viewModel: context.read<NovaTelAViewModel>(),
  ),
),
```

5. **Registrar Provider:**

```dart
// configs/dependencies.dart
ChangeNotifierProvider<NovaTelAViewModel>(
  create: (context) => NovaTelAViewModel(
    repository: context.read(),
  ),
),
```

### Adicionar Novo Repositório

1. **Criar interface:**

```dart
// data/repositories/novo/novo_repository.dart
abstract class NovoRepository {
  Future<Result<List<Algo>>> listarTudo();
}
```

2. **Implementar:**

```dart
// data/repositories/novo/novo_repository_impl.dart
class SupabaseNovoRepository extends NovoRepository {
  SupabaseNovoRepository({SupabaseClientService? clientService})
    : _service = clientService ?? SupabaseClientService();
  
  final SupabaseClientService _service;
  final _log = Logger('SupabaseNovoRepository');
  
  @override
  Future<Result<List<Algo>>> listarTudo() async {
    try {
      final data = await _service.client.from('tabela').select();
      final items = (data as List)
        .map((e) => Algo.fromJson(e))
        .toList();
      return Result.ok(items);
    } catch (e, st) {
      _log.severe('Erro', e, st);
      return Result.error(Exception(e.toString()));
    }
  }
}
```

3. **Registrar Provider:**

```dart
// configs/dependencies.dart
Provider<NovoRepository>(
  create: (context) => SupabaseNovoRepository(
    clientService: context.read(),
  ),
),
```

## Padrões de Código

### ViewModel

```dart
class MinhaViewModel extends ChangeNotifier {
  MinhaViewModel({required SomeRepository repository})
    : _repository = repository {
    carregarCommand = Command0(_carregar);
  }

  final SomeRepository _repository;
  final _log = Logger('MinhaViewModel');

  // State
  List<Item> _items = [];
  
  // Commands
  late Command0<void> carregarCommand;

  // Getters
  List<Item> get items => _items;

  // Private methods
  Future<Result<void>> _carregar() async {
    try {
      final result = await _repository.listar();
      if (result is Error<List<Item>>) return result;
      
      _items = (result as Ok<List<Item>>).value;
      return const Result.ok(null);
    } catch (e, st) {
      _log.severe('Erro ao carregar', e, st);
      return Result.error(Exception(e.toString()));
    } finally {
      notifyListeners();
    }
  }

  // Public methods
  void carregar() => carregarCommand.execute();
}
```

### Screen com ViewModel

```dart
class MinhaScreen extends StatefulWidget {
  const MinhaScreen({required this.viewModel});
  final MinhaViewModel viewModel;

  @override
  State<MinhaScreen> createState() => _MinhaScreenState();
}

class _MinhaScreenState extends State<MinhaScreen> {
  @override
  void initState() {
    super.initState();
    _setupListeners();
    _loadData();
  }

  @override
  void didUpdateWidget(MinhaScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.viewModel != widget.viewModel) {
      _removeListeners(oldWidget);
      _setupListeners();
      _loadData();
    }
  }

  void _setupListeners() {
    widget.viewModel.carregarCommand.addListener(_onLoaded);
  }

  void _removeListeners(MinhaScreen screen) {
    screen.viewModel.carregarCommand.removeListener(_onLoaded);
  }

  void _loadData() {
    widget.viewModel.carregar();
  }

  void _onLoaded() {
    final cmd = widget.viewModel.carregarCommand;
    if (cmd.error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text((cmd.result as dynamic).error?.toString() ?? 'Erro'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  void dispose() {
    _removeListeners(widget);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Minha Tela')),
      body: ListenableBuilder(
        listenable: widget.viewModel,
        builder: (context, _) {
          return ListView(
            children: widget.viewModel.items.map((item) {
              return ListTile(title: Text(item.nome));
            }).toList(),
          );
        },
      ),
    );
  }
}
```

## Debugging

### Logs

O projeto usa o pacote `logging`:

```dart
import 'package:logging/logging.dart';

final _log = Logger('MinhaClasse');

_log.info('Informação');
_log.warning('Aviso');
_log.severe('Erro', exception, stackTrace);
```

### Supabase Logs

Ver logs no Supabase:

1. Ir para dashboard do projeto
2. "Logs" → "API"
3. Filtrar por timestamp

### DevTools

```bash
flutter pub global activate devtools
devtools

# No navegador vai abrir DevTools
# Connect seu app (mostra URL no console)
```

## Performance

### Avoid

- Rebuild desnecessários (use `const`)
- Multiple async calls simultâneos (use `Future.wait`)
- Rebuild de ListView grande (use `shrinkWrap` com cuidado)

### Do

- Use `ListenableBuilder` apenas no necessário
- Mantenha estado em ViewModel, não em State
- Lazy-load dados quando possível
- Use `const` construtores

## Boas Práticas

### Naming

- Classes: `PascalCase` (ViewModel, Repository)
- Methods: `camelCase` (loadBooks, setTitle)
- Private: prefixo `_` (_loadBooks, _repository)
- Constants: `UPPER_SNAKE_CASE` (API_KEY)

### Imports

- Imports de `dart:` primeiro
- Depois `package:`
- Depois relativos `../`

```dart
import 'dart:async';

import 'package:flutter/material.dart';

import '../models/book_model.dart';
```

### Error Handling

Sempre use `Result` type:

```dart
// ❌ Evitar
Future<List<BookModel>> getBooks() async {
  return await repo.getBooks();
}

// ✅ Fazer
Future<Result<List<BookModel>>> getBooks() async {
  try {
    return Result.ok(await repo.getBooks());
  } catch (e) {
    return Result.error(Exception(e.toString()));
  }
}
```

## Troubleshooting

### Build Runner não regenera código

```bash
dart run build_runner clean
dart run build_runner build
```

### Erro de imports circulares

- Imports circulares causam problemas
- Use abstrações (interfaces) para quebrar ciclos
- Sempre `pub get` após mudanças de import

### Tela em branco ao navegar

- Verifique se ViewModel está registrado em Provider
- Verifique se rota está em `Routes`
- Verifique `didUpdateWidget` se viewModel muda

## Links Úteis

- [Flutter Docs](https://flutter.dev/docs)
- [Supabase Docs](https://supabase.com/docs)
- [Provider Package](https://pub.dev/packages/provider)
- [GoRouter Docs](https://pub.dev/packages/go_router)

## Comandos Úteis

```bash
# Limpar build
flutter clean

# Atualizar dependências
flutter pub upgrade

# Checar problemas
flutter analyze

# Formatar código
dart format lib/

# Rodar testes
flutter test

# Build APK
flutter build apk

# Build Web
flutter build web
```

---

**Última atualização**: Novembro 2025
