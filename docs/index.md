# Documentação do Projeto BookLog

## Visão Geral

BookLog é um aplicativo Flutter para registro, organização e acompanhamento de leituras de livros. O backend utiliza Supabase para autenticação, banco de dados e armazenamento de imagens.

As regras de negócio detalhadas estão em [docs/others/book-log.md](others/book-log.md).

---

## Estrutura das Telas e Funcionalidades

### 1. Tela de Login

- **Campos:** E-mail, senha.
- **Autenticação:** Supabase Auth.
- **Cadastro de Usuário:**  
  - Campos: E-mail, nome do usuário, senha (duas vezes para confirmação).
- **Recuperação de Senha:** Opcional.

### 2. Tela Home

- **Visualização:** Lista dos livros cadastrados pelo usuário.
- **Filtros:**  
  - Status do livro (lido/não lido).
  - Gênero do livro.
- **Ações:**  
  - Editar livro.
  - Deletar livro.
- **Float Button:**  
  - Acesso ao formulário de cadastro de novo livro.

### 3. Tela de Cadastro/Edição de Livro

- **Campos do Formulário:**  
  - Título  
  - Autor  
  - Gênero  
  - Status (lido/não lido)  
  - Avaliação (até 5 estrelas)  
  - URL da capa (upload via Supabase Storage)  
  - Notas

---

## Tecnologias Utilizadas

- **Frontend:** Flutter
- **Backend:** Supabase (Auth, Database, Storage)

---

## Referências

- [Regras de Negócio e MVP](others/book-log.md)

---

## Observações

- O projeto é desenvolvido por uma pessoa, responsável por todas as etapas.
- A documentação está estruturada para facilitar integração com assistentes de IA e colaboração futura.