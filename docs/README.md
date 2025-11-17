# 📖 Documentação do Projeto Book Log

## Visão Geral da Documentação

Este projeto possui documentação completa para ajudar desenvolvedores a entender, usar e contribuir ao projeto.

## 📚 Arquivos de Documentação

### 1. **README.md** (Arquivo Principal)
- 📋 Descrição geral do projeto
- 🎯 Funcionalidades principais
- 🏗️ Arquitetura em alto nível
- 🚀 Getting Started (setup completo)
- 📱 Navegação e rotas
- 📊 Modelos de dados
- 🔐 Autenticação e segurança
- 📦 Dependências principais
- 🛠️ Desenvolvimento (Build Runner)
- 🐛 Troubleshooting
- 📝 Guia de contribuição

**Use este arquivo para**: Entender o projeto de forma geral, setup inicial, referência rápida.

### 2. **docs/architecture.md** (Arquitetura Detalhada)
- 📊 Camadas arquiteturais (Data, Domain, UI)
- 🔄 Padrões de design utilizados
  - Repository Pattern
  - Command Pattern
  - Result Type
  - MVVM Pattern
- 🔐 Fluxo de autenticação
- 📡 Fluxo de dados (Livros)
- 🧩 Injeção de dependências
- 🛡️ Segurança (variáveis de env, RLS, JWT)
- 📱 Navegação (GoRouter)
- 🔄 Estado global
- 📊 Modelos de dados (Freezed)
- 🧪 Testeabilidade
- 🚀 Performance
- 📚 Referências bibliográficas

**Use este arquivo para**: Entender decisões arquiteturais, aprender padrões de design, estudar como o projeto está estruturado.

### 3. **docs/development_guide.md** (Guia de Desenvolvimento)
- 🚀 Primeiro acesso ao projeto
- 📁 Estrutura de pastas
- 🛠️ Tarefas comuns
  - Adicionar novo campo ao livro
  - Adicionar nova tela
  - Adicionar novo repositório
- 📝 Padrões de código (ViewModel, Screen)
- 🐛 Debugging (Logs, DevTools, Supabase Logs)
- 📈 Performance (Avoid/Do)
- ✅ Boas práticas (Naming, Imports, Error Handling)
- 🔧 Troubleshooting
- 🔗 Links úteis
- 💻 Comandos úteis

**Use este arquivo para**: Começar a desenvolver, aprender padrões de código, resolver problemas comuns.

### 4. **docs/supabase/database.md** (Estrutura do Banco)
- 📋 Tabela de usuários (gerenciada por Auth)
- 📚 Tabela de livros (schema SQL)
- 🔐 Row Level Security (RLS)
  - Políticas de SELECT, INSERT, UPDATE, DELETE
- 📦 Supabase Flutter API
  - Selecionar e inserir dados
  - Atualização em realtime
  - Postgres Changes

**Use este arquivo para**: Entender schema do banco, configurar RLS, exemplo de uso da API do Supabase.

### 5. **docs/supabase/auth.md** (Autenticação)
- 🔓 Fluxo de autenticação
- 📝 Como configurar Auth no Supabase
- 🎯 Implementação no app

**Use este arquivo para**: Entender fluxo de login/signup, integração com Supabase Auth.

### 6. **docs/supabase/rls_policies.sql** (Script SQL de RLS)
- SQL pronto para executar no Supabase
- Habilita RLS na tabela books
- Cria 4 políticas (SELECT, INSERT, UPDATE, DELETE)

**Use este arquivo para**: Copiar e executar no SQL Editor do Supabase durante setup.

## 🎯 Por Onde Começar

### Se você é novo no projeto:

1. **Comece pelo README.md**
   - Leia a visão geral
   - Faça o setup (Getting Started)

2. **Leia docs/development_guide.md**
   - "Primeiro Acesso ao Projeto"
   - Entenda a estrutura

3. **Consulte docs/architecture.md**
   - Quando tiver dúvidas sobre padrões
   - Para entender decisões de design

### Se você vai desenvolver uma feature:

1. **Leia docs/development_guide.md**
   - Tarefas comuns relevantes
   - Padrões de código

2. **Veja exemplos no código**
   - HomeViewModel como referência
   - BookFormScreen como template

3. **Consulte README.md**
   - Troubleshooting se encontrar erros

### Se você vai trabalhar com dados:

1. **Leia docs/supabase/database.md**
   - Schema das tabelas
   - Exemplos de consultas

2. **Veja RLS em docs/supabase/database.md**
   - Entenda as políticas
   - Execute o script SQL

## 📈 Estrutura do Projeto

```
book_log/
├── README.md                          ← COMECE AQUI
├── lib/
│   ├── main.dart
│   ├── configs/
│   ├── data/
│   ├── domain/
│   ├── routing/
│   ├── ui/
│   └── utils/
├── docs/
│   ├── architecture.md                ← PADRÕES E DESIGN
│   ├── development_guide.md           ← COMO DESENVOLVER
│   └── supabase/
│       ├── database.md                ← BANCO DE DADOS
│       ├── auth.md                    ← AUTENTICAÇÃO
│       └── rls_policies.sql           ← SCRIPT SQL
├── pubspec.yaml
└── .env                               ← VARIÁVEIS DE AMBIENTE
```

## 🔄 Fluxos Principais

### Fluxo de Login

```
LoginScreen → LoginViewModel.login()
          → AuthRepository.login()
          → Supabase.auth.signInWithPassword()
          → JWT Token gerado
          → AuthRepository notifica listeners
          → Router redireciona para /home
```

### Fluxo de Carregar Livros

```
HomeScreen → HomeViewModel.loadBooks()
         → BookRepository.listBooks()
         → Supabase (com RLS)
         → BookModel list retornado
         → HomeViewModel notifica listeners
         → HomeScreen recarrega via ListenableBuilder
```

### Fluxo de Editar Livro

```
HomeScreen (clique no card)
      → Context.push(Routes.bookEdit, extra: book)
      → BookFormScreen com livro pré-preenchido
      → User modifica dados
      → BookFormViewModel.saveBook()
      → BookRepository.updateBook()
      → Supabase atualiza
      → Pop com result = true
      → HomeScreen recarrega livros
```

## 🔐 Segurança

### Em Desenvolvimento

- Use `.env` com credenciais
- Nunca commite `.env` (já está em `.gitignore`)
- Use variáveis de ambiente para dados sensíveis

### Em Produção

- Row Level Security (RLS) protege dados no servidor
- JWT tokens validam cada requisição
- Usuários só acessam seus próprios dados

## 📦 Stack Tecnológico

- **Frontend**: Flutter 3.9.2+
- **Linguagem**: Dart
- **State Management**: Provider
- **Navegação**: GoRouter
- **Backend**: Supabase
- **Autenticação**: Supabase Auth
- **Banco de Dados**: PostgreSQL (Supabase)
- **Codegen**: Freezed, JSON Serializable
- **Logging**: Logging package

## 🧪 Testes

O projeto é testável devido à arquitetura:

- ViewModels podem ser testados isoladamente
- Repositórios podem ser mockados
- Result types facilitam assertions

Exemplo:
```dart
test('loadBooks carrega lista', () async {
  final mockRepo = MockBookRepository();
  when(mockRepo.listBooks()).thenAnswer(
    (_) async => Result.ok([...]),
  );
  
  final viewModel = HomeViewModel(repository: mockRepo);
  viewModel.loadBooks();
  
  expect(viewModel.filteredBooks.length, 2);
});
```

## 🚀 Próximos Passos

### Melhorias Futuras

- [ ] Testes unitários e de widget
- [ ] Modo offline com sincronização
- [ ] Integração com APIs de livros (Google Books, etc)
- [ ] Recomendações baseadas em leitura
- [ ] Compartilhamento de listas de livros
- [ ] Dark mode
- [ ] Internacionalização (i18n)
- [ ] Backup e restore de dados

### Performance

- [ ] Lazy loading de imagens
- [ ] Caching inteligente
- [ ] Pagination na lista de livros

### UX

- [ ] Animações de transição
- [ ] Pull-to-refresh
- [ ] Search global
- [ ] Filtros avançados

## 📞 Suporte

### Problemas Comuns

**Ver seção "Troubleshooting" em:**
- README.md (problemas de setup/runtime)
- docs/development_guide.md (problemas de desenvolvimento)

### Logs

Ative logs para debugar:

```dart
import 'package:logging/logging.dart';

void main() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    print('${record.level.name}: ${record.message}');
  });
  
  runApp(const MyApp());
}
```

### Recurso: Supabase Dashboard

- Logs de API: dashboard → Logs → API
- SQL Editor para queries
- Browser de dados: Tables
- Monitoramento em tempo real

## 👥 Contribuindo

1. Leia este documento
2. Leia README.md (seção Contribuindo)
3. Consulte docs/development_guide.md
4. Siga os padrões de código
5. Abra um PR

## 📝 Changelog

### v1.0.0 (Novembro 2025)

- ✅ Autenticação completa (login/signup)
- ✅ CRUD de livros (create, read, update, delete)
- ✅ Filtros (status, gênero)
- ✅ Estatísticas
- ✅ Avaliações
- ✅ Notas pessoais
- ✅ Row Level Security
- ✅ Documentação completa

## 🔗 Links Importantes

- [Flutter Documentation](https://flutter.dev/docs)
- [Supabase Documentation](https://supabase.com/docs)
- [Provider Package](https://pub.dev/packages/provider)
- [GoRouter Documentation](https://pub.dev/packages/go_router)
- [Freezed Package](https://pub.dev/packages/freezed)
- [Clean Architecture (Robert C. Martin)](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)

---

**Versão**: 1.0.0  
**Última atualização**: Novembro 2025  
**Status**: Produção
