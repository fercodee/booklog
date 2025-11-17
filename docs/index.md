# 📚 Documentação - Book Log

Bem-vindo à documentação do projeto Book Log! Use este índice para navegar pelos documentos.

## 🎯 Comece Aqui

- **[README.md](../README.md)** - Guia principal do projeto (setup, features, troubleshooting)
- **[architecture.md](architecture.md)** - Entenda a arquitetura e padrões de design
- **[development_guide.md](development_guide.md)** - Como começar a programar features

## 📖 Documentação Disponível

### 🏗️ Arquitetura e Design
- **[architecture.md](architecture.md)** - Clean Architecture, padrões de design, fluxos de dados
- **[state_management.md](state_management.md)** - Como o estado é gerenciado no projeto
- **[GIT_DECISION.md](GIT_DECISION.md)** - Decisão sobre versionamento de documentação

### 🛠️ Desenvolvimento
- **[development_guide.md](development_guide.md)** - Tarefas comuns, padrões de código, troubleshooting
- **[others/book-log.md](others/book-log.md)** - Regras de negócio e MVP

### 🗄️ Supabase
- **[supabase/database.md](supabase/database.md)** - Schema das tabelas, Row Level Security (RLS)
- **[supabase/auth.md](supabase/auth.md)** - Autenticação com Supabase
- **[supabase/rls_policies.sql](supabase/rls_policies.sql)** - Script SQL para configurar RLS

## 🚀 Roadmap Rápido

### Seu Primeiro Dia
1. Leia [../README.md](../README.md) - 15 min
2. Faça o Getting Started - 30 min
3. Leia [development_guide.md](development_guide.md) primeiro acesso - 30 min

### Entender Arquitetura
1. Leia [architecture.md](architecture.md) - 40 min
2. Consulte código (HomeViewModel, BookFormViewModel)
3. Consulte quando tiver dúvidas

### Implementar Feature
1. Consulte [development_guide.md](development_guide.md) "Tarefas Comuns"
2. Use exemplos similares no código
3. Siga os padrões documentados

## 📊 Estrutura do Projeto

```
book_log/
├── README.md ........................ Guia principal (raiz)
├── docs/ ........................... Documentação
│   ├── index.md (este arquivo)
│   ├── architecture.md ............. Arquitetura
│   ├── development_guide.md ........ Como desenvolver
│   ├── state_management.md ......... Gerenciamento de estado
│   ├── GIT_DECISION.md ............ Decisão de versionamento
│   ├── supabase/ ................... Documentação Supabase
│   │   ├── database.md ............ Schema do banco
│   │   ├── auth.md ................ Autenticação
│   │   └── rls_policies.sql ....... Script de RLS
│   └── others/ .................... Documentos adicionais
│       └── book-log.md ............ Regras de negócio
└── lib/ ........................... Código principal
```

## 🔗 Links Rápidos

| Tópico | Link |
|--------|------|
| Setup inicial | [../README.md#-getting-started](../README.md#-getting-started) |
| Troubleshooting | [../README.md#-troubleshooting](../README.md#-troubleshooting) |
| Padrões de código | [development_guide.md#padrões-de-código](development_guide.md#padrões-de-código) |
| Boas práticas | [development_guide.md#boas-práticas](development_guide.md#boas-práticas) |
| Configurar Supabase | [supabase/database.md](supabase/database.md) |

## ❓ Não Encontrou O Que Procura?

- **Problema durante setup?** → [../README.md#-troubleshooting](../README.md#-troubleshooting)
- **Como adicionar feature?** → [development_guide.md](development_guide.md)
- **Qual padrão usar?** → [development_guide.md#padrões-de-código](development_guide.md#padrões-de-código)
- **Entender fluxo de dados?** → [architecture.md](architecture.md)
- **Configurar banco de dados?** → [supabase/database.md](supabase/database.md)

---

**Última atualização**: Novembro 2025  
**Status**: ✅ Documentação Completa
