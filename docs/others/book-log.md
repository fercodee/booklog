# BookLog — Documentação do Projeto

## 1. Identificação da Equipe

- **Nome do Grupo:** BookLog  
- **Integrantes:** Fernando Cordeiro (nome completo)

## 2. Visão Geral e Contexto do Aplicativo

**Nome Provisório do Aplicativo:** BookLog

**O Problema ou a Oportunidade:**  
Muitas pessoas têm dificuldade em acompanhar suas leituras, lembrar quais livros já leram, quais pretendem ler e organizar suas avaliações e anotações sobre cada obra. O aplicativo **BookLog** facilita o registro e o acompanhamento das leituras, permitindo ao usuário organizar sua biblioteca pessoal, registrar informações relevantes sobre cada livro e acompanhar seu progresso de leitura. O contexto de uso é para leitores que desejam ter controle e organização sobre suas leituras, avaliações e anotações.

**Público-Alvo:**  
Leitores em geral que desejam organizar e acompanhar suas leituras — estudantes, amantes de livros ou qualquer pessoa interessada em leitura.

**Proposta de Valor:**  
A maneira mais prática de registrar, organizar e acompanhar suas leituras de livros.

## 3. Funcionalidades Essenciais (MVP - Mínimo Produto Viável)

### a) Autenticação de Usuários

- Cadastro de novos usuários (e-mail/senha).  
- Tela de Login.  
- (Opcional) Recuperação de senha.

### b) Uso do Banco de Dados (CRUD - Criar, Ler, Atualizar, Deletar)  

**Principal dado gerenciado:** Livros do usuário.

- **Criar:** Usuário poderá registrar novos livros informando:
  - Título
  - Autor
  - Gênero
  - Status (`lido` / `não lido`)
  - Avaliação (até 5 estrelas)
  - URL da capa
  - Notas
- **Ler:** Usuário poderá visualizar sua lista de livros e filtrar por gênero e status de leitura.
- **Atualizar:** Usuário poderá editar informações dos livros, atualizar status de leitura, avaliação e notas.
- **Deletar:** Usuário poderá excluir livros da sua lista.

### c) Integração com Outro Serviço Cloud

- Usaremos o **Supabase Storage** para permitir que os usuários façam upload da imagem da capa do livro.

## 4. Arquitetura e Tecnologias

### a) Tecnologia para Desenvolvimento do App (Frontend)

- **Escolha:** Flutter  
- **Justificativa:** Experiência prévia com a tecnologia e facilidade de desenvolvimento multiplataforma.

### b) Tecnologia para o Servidor (Backend)

- **Escolha:** Supabase  
- **Serviços a serem utilizados:** Supabase Authentication, Supabase Database (PostgreSQL), Supabase Storage.

## 5. Divisão de Tarefas

Equipe formada por apenas uma pessoa; todas as etapas do projeto (frontend, backend e integração) serão de responsabilidade de Fernando Cordeiro.
