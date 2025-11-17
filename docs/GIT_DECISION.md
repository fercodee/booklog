# 📚 Decisão: Incluir `/docs/` no Repositório Git

## 🎯 Decisão Tomada

**REMOVER `/docs/` do `.gitignore` para que a documentação seja versionada junto com o código.**

## ✅ Justificativas

### 1. **Documentação é Parte do Projeto**

```
Projeto = Código + Documentação
```

A documentação não é um artefato secundário, é essencial para:
- Entender a arquitetura
- Onboarding de novos devs
- Manutenção do código
- Histórico de decisões

### 2. **Benefícios de Versionar Documentação**

| Benefício | Exemplo |
|-----------|---------|
| **Histórico** | Ver como a arquitetura evoluiu |
| **Rastreabilidade** | `git log docs/` mostra mudanças |
| **Sincronização** | Docs e código evoluem juntos |
| **Branches** | Feature branch com docs atualizados |
| **Code Review** | Revisar docs junto com código |
| **Backup** | Proteção contra perda |
| **Colaboração** | Múltiplos autores no Git |

### 3. **Sem Versionar = Problemas**

❌ Documentação desatualizada  
❌ Sem como recuperar versão anterior  
❌ Histórico perdido  
❌ Novo dev não tem referência  
❌ Sem rastreabilidade  
❌ Sem backup central  

## 📋 O que Mudou

### Antes
```
.gitignore
──────────
/docs/          ← Documentação IGNORADA
.env            ← Credenciais ignoradas (correto)
```

### Depois
```
.gitignore
──────────
.env            ← Apenas credenciais ignoradas
```

### Resultado
```
Git Repository
──────────────
📁 docs/
  ├── README.md
  ├── architecture.md
  ├── development_guide.md
  └── supabase/
      ├── database.md
      ├── auth.md
      └── rls_policies.sql
```

## 🔐 O que Continua Ignorado (Correto)

```
.gitignore continua com:
──────────────────────
.env                # ✅ Credenciais
/build/             # ✅ Build artifacts
.dart_tool/         # ✅ Cache
.pub-cache/         # ✅ Cache
/coverage/          # ✅ Relatórios de teste
.idea/              # ✅ IDE config local
.vscode/            # ✅ IDE config local
.DS_Store           # ✅ Sistema operacional
*.log               # ✅ Logs
```

## 📊 Estrutura Recomendada do Git

```
book_log/
├── .gitignore
├── .env.example          ← NOVO: Template de .env
├── README.md
├── pubspec.yaml
├── lib/                  # ✅ Versionado
├── docs/                 # ✅ Agora versionado
│   ├── README.md
│   ├── architecture.md
│   ├── development_guide.md
│   └── supabase/
├── android/
├── ios/
└── test/
```

## 💡 Boas Práticas

### ✅ DO's (Fazer)
- Versionar documentação
- Atualizar docs com cada feature
- Revisar docs no code review
- Manter docs sincronizados

### ❌ DON'Ts (Evitar)
- Não deixar docs fora do Git
- Não deixar docs desatualizadas
- Não ignorar documentação
- Não perder histórico

## 🔄 Fluxo de Trabalho Recomendado

### Ao Adicionar Feature:

1. **Criar branch feature**
   ```bash
   git checkout -b feature/nova-feature
   ```

2. **Implementar código**
   ```bash
   # código em lib/
   ```

3. **Atualizar documentação**
   ```bash
   # atualizar docs/development_guide.md
   # ou docs/architecture.md
   ```

4. **Commit único ou organizado**
   ```bash
   git add lib/ docs/
   git commit -m "feat: nova feature com documentação"
   ```

5. **Push e Pull Request**
   ```bash
   git push origin feature/nova-feature
   # Review de código + documentação
   ```

## 📝 Exemplo: Histórico de Documentação

```bash
$ git log --oneline docs/

a1b2c3d Atualizar development_guide com nova feature
2x3y4z5 Adicionar exemplos de testes em architecture.md
5m6n7o8 Expandir troubleshooting no README
...
```

**Benefício**: Você pode rastrear quando mudou a documentação e por quê.

## 🎓 Para Novos Desenvolvedores

Agora o novo dev pode:

✅ Clonar repositório
```bash
git clone <repo>
```

✅ Ter acesso a TODA documentação
```bash
cat docs/README.md
```

✅ Ver histórico de decisões
```bash
git log -- docs/
```

✅ Entender evolução
```bash
git show <commit>:docs/architecture.md
```

## 📌 Próximos Passos

### 1. Criar `.env.example`

```bash
# .env.example (fazer commit)
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your-anon-key
```

**Instruções no README:**
```
1. Copiar .env.example para .env
2. Preencer com suas credenciais
3. .env está em .gitignore (protegido)
```

### 2. First Commit com Docs

```bash
git add docs/
git commit -m "docs: documentação inicial do projeto

- README.md: guia principal
- docs/architecture.md: padrões de design
- docs/development_guide.md: como desenvolver
- docs/supabase/: configuração do banco"
```

### 3. Manter Sincronizado

Toda feature deve ter docs atualizadas:
```bash
git add lib/ docs/
git commit -m "feat: adicionar feature X

- Implementação em lib/
- Documentação em docs/development_guide.md"
```

## 🔗 Referências

- [Git Documentation Best Practices](https://git-scm.com/book/en/v2)
- [Version Control for Documentation](https://www.atlassian.com/blog/bitbucket/how-to-version-control-your-api-documentation)

## ✨ Conclusão

Agora o projeto **Book Log** tem:

✅ Código versionado  
✅ Documentação versionada  
✅ Histórico completo  
✅ Backup centralizado  
✅ Fácil colaboração  

**A documentação é PARTE do repositório, não um artefato separado!**

---

**Data da Decisão**: Novembro 2025  
**Status**: ✅ Implementado
