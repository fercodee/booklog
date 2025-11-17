# 🏛️ Arquitetura do Projeto Book Log

Este documento detalha a arquitetura e os padrões de design utilizados no projeto Book Log.

## 📊 Camadas Arquiteturais

O projeto segue **Clean Architecture** com três camadas principais:

### 1. **Data Layer** (`lib/data/`)

Responsável por:
- Acesso a dados externos (Supabase)
- Implementação dos repositórios
- Serviços de API

**Estrutura:**
```
data/
├── repositories/
│   ├── auth/
│   │   ├── auth_repository.dart          # Interface
│   │   └── auth_repository_impl.dart     # Implementação
│   └── book/
│       ├── book_repository.dart          # Interface
│       └── book_repository_impl.dart     # Implementação
└── services/
    └── api/
        └── supabase_client.dart          # Cliente centralizado
```

**Responsabilidades:**
- `AuthRepository`: Gerencia login, signup, logout
- `BookRepository`: CRUD de livros, estatísticas
- `SupabaseClientService`: Configuração centralizada do Supabase

### 2. **Domain Layer** (`lib/domain/`)

Responsável por:
- Modelos de dados
- Lógica de negócio independente de UI

**Estrutura:**
```
domain/
└── models/
    └── book_model.dart                  # Modelo imutável com Freezed
```

**Características:**
- Usa `@freezed` para imutabilidade
- Inclui serialização JSON automática
- Independente de frameworks de UI

### 3. **UI Layer** (`lib/ui/`)

Responsável por:
- Interfaces de usuário
- ViewModels para gerenciar estado
- Navegação entre telas

**Estrutura:**
```
ui/
├── core/
│   ├── colors.dart                      # Paleta de cores centralizada
│   └── theme.dart                       # Tema Material
├── login/
│   ├── login_screen.dart
│   └── login_view_model.dart
├── signup/
│   ├── signup_screen.dart
│   └── signup_view_model.dart
├── home/
│   ├── home_screen.dart
│   └── home_view_model.dart
└── book_form/
    ├── book_form_screen.dart
    └── book_form_view_model.dart
```

## 🔄 Padrões de Design

### Repository Pattern

Os repositórios abstraem o acesso a dados:

```dart
// Interface
abstract class BookRepository {
  Future<Result<List<BookModel>>> listBooks({
    String? status,
    String? genre,
  });
}

// Implementação
class SupabaseBookRepository extends BookRepository {
  @override
  Future<Result<List<BookModel>>> listBooks({...}) async {
    // Lógica de acesso a dados
  }
}
```

**Benefícios:**
- Facilita testes (pode criar mocks)
- Desacoplamento de implementação
- Fácil trocar de banco de dados

### Command Pattern

Encapsula ações assíncronas:

```dart
// Uso
loadBooksCommand = Command0(_loadBooks);

// Execução
loadBooksCommand.execute();

// Listening
loadBooksCommand.addListener(_onBooksLoaded);
```

**Benefícios:**
- Evita múltiplas execuções
- Estados: `running`, `completed`, `error`
- Integração natural com `ChangeNotifier`

### Result Type

Tratamento robusto de erros:

```dart
// Ao invés de try/catch ou null
Future<Result<List<BookModel>>> listBooks() async {
  try {
    final data = await supabase.from('books').select();
    final books = data.map((e) => BookModel.fromJson(e)).toList();
    return Result.ok(books);
  } catch (e) {
    return Result.error(Exception(e.toString()));
  }
}

// Uso
final result = await repository.listBooks();
if (result is Ok<List<BookModel>>) {
  final books = result.value;
}
```

### MVVM (Model-View-ViewModel)

Cada tela tem um ViewModel:

```dart
class HomeViewModel extends ChangeNotifier {
  // State
  List<BookModel> _books = [];
  
  // Commands
  late Command0<void> loadBooksCommand;
  
  // Getters
  List<BookModel> get filteredBooks => _filteredBooks;
  
  // Public methods
  void loadBooks() => loadBooksCommand.execute();
  
  // Private business logic
  Future<Result<void>> _loadBooks() async { ... }
}
```

**Benefícios:**
- Lógica separada da UI
- Fácil testar
- Estado centralizado

## 🔐 Fluxo de Autenticação

```
User → Login → Supabase Auth → JWT Token → App State → Redirect
                                     ↓
                            Update AuthRepository
                                     ↓
                            Trigger redirect no router
```

### Implementação:

1. **LoginViewModel** executa `repository.login(email, password)`
2. **SupabaseAuthRepository** chama `supabase.auth.signInWithPassword()`
3. **AuthRepository** notifica listeners (é um `ChangeNotifier`)
4. **Router** detecta mudança e redireciona para `/home`

## 📡 Fluxo de Dados (Livros)

```
UI (HomeScreen)
    ↓
HomeViewModel.loadBooks()
    ↓
BookRepository.listBooks()
    ↓
Supabase (com RLS)
    ↓
Result<List<BookModel>>
    ↓
HomeViewModel notifica listeners
    ↓
UI recarrega com novos dados
```

## 🧩 Injeção de Dependências

Utiliza **Provider** com padrão de `MultiProvider`:

```dart
// dependencies.dart
List<SingleChildWidget> get providersRemote {
  return [
    // Serviços
    Provider(create: (context) => SupabaseClientService()),
    
    // Repositórios
    ChangeNotifierProvider<AuthRepository>(
      create: (context) => SupabaseAuthRepository(
        clientService: context.read(),
      ),
    ),
    
    // ViewModels (Singletons)
    ChangeNotifierProvider<HomeViewModel>(
      create: (context) => HomeViewModel(
        repository: context.read(),
      ),
    ),
  ];
}
```

**Vantagens:**
- Injeção automática
- Facilita testes
- Reutilização de instâncias

## 🛡️ Segurança

### 1. Variáveis de Ambiente

Credenciais armazenadas em `.env`:
```bash
SUPABASE_URL=https://...supabase.co
SUPABASE_ANON_KEY=eyJh...
```

Carregadas via `flutter_dotenv`:
```dart
await dotenv.load(fileName: '.env');
final url = dotenv.env['SUPABASE_URL']!;
```

### 2. Row Level Security (RLS)

Políticas no banco de dados garantem:
- Usuários só veem seus próprios livros
- Usuários só editam seus próprios livros
- Aplicado no nível do banco, não da aplicação

```sql
CREATE POLICY "Users can view their own books"
ON public.books FOR SELECT
USING (auth.uid() = user_id);
```

### 3. JWT Tokens

Supabase gera tokens JWT automáticos:
- Enviados em cada requisição
- Incluem `sub` (user ID) no payload
- Usados para validar RLS no servidor

## 📱 Navegação

Usa **GoRouter** para navegação declarativa:

```dart
GoRouter(
  initialLocation: Routes.home,
  redirect: _redirect,  // Redireciona se não autenticado
  routes: [
    GoRoute(
      path: Routes.home,
      builder: (context, state) => HomeScreen(...),
    ),
  ],
);
```

**Vantagens:**
- Deep linking automático
- Redireccionamento condicional
- Histórico de navegação
- Tipo-seguro

## 🔄 Estado Global

### AuthRepository

Singleton que monitora autenticação:

```dart
class SupabaseAuthRepository extends AuthRepository {
  // Listener que o router escuta
  @override
  void notifyListeners() {
    // Notifica quando login/logout ocorre
  }
}
```

### HomeViewModel

Singleton que mantém estado da home:

```dart
ChangeNotifierProvider<HomeViewModel>(
  create: (context) => HomeViewModel(...),
)
// Mesma instância em toda navegação
```

## 📊 Modelos de Dados

### BookModel (Domain)

```dart
@freezed
abstract class BookModel with _$BookModel {
  const factory BookModel({
    required int id,
    String? userId,
    required String title,
    String? author,
    String? genre,
    String? status,
    int? rating,
    String? coverUrl,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _BookModel;

  factory BookModel.fromJson(Map<String, dynamic> json) =>
    _$BookModelFromJson(json);
}
```

**Benefícios de Freezed:**
- Imutabilidade
- `copyWith()` automático
- Igualdade por valor
- `toString()` útil
- Serialização JSON

## 🧪 Testeabilidade

A arquitetura permite testes fáceis:

```dart
// Mock do repositório
class MockBookRepository extends Mock implements BookRepository {}

// Teste do ViewModel
test('loadBooks deve carregar lista', () async {
  final mockRepo = MockBookRepository();
  when(mockRepo.listBooks()).thenAnswer(
    (_) async => Result.ok([...]),
  );
  
  final viewModel = HomeViewModel(repository: mockRepo);
  viewModel.loadBooks();
  
  expect(viewModel.filteredBooks.length, 2);
});
```

## 🚀 Performance

### Lazy Loading

- ViewModels carregados sob demanda
- Livros carregados quando necessário

### Caching

- HomeViewModel mantém livros em memória
- Filtros aplicados localmente
- Recarregamento após edit/delete

### Build Optimization

- `ListenableBuilder` apenas no necessário
- `const` constructores onde possível

## 📚 Referências Bibliográficas

Este projeto implementa conceitos de:
- Clean Architecture (Robert C. Martin)
- MVVM Pattern
- Repository Pattern
- Command Pattern
- Result Type (estilo Rust/Kotlin)

## 🔗 Veja Também

- [README.md](../README.md) - Guia principal do projeto
- [database.md](./supabase/database.md) - Estrutura do banco
- [auth.md](./supabase/auth.md) - Fluxo de autenticação
