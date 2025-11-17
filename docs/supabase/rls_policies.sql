-- Row Level Security (RLS) Policies para a tabela books
-- Execute este script no SQL Editor do Supabase

-- 1. Habilitar RLS na tabela books (se ainda não estiver habilitado)
ALTER TABLE public.books ENABLE ROW LEVEL SECURITY;

-- 2. Política para SELECT: Usuários só podem ver seus próprios livros
CREATE POLICY "Users can view their own books"
ON public.books
FOR SELECT
USING (auth.uid() = user_id);

-- 3. Política para INSERT: Usuários só podem inserir livros para si mesmos
CREATE POLICY "Users can insert their own books"
ON public.books
FOR INSERT
WITH CHECK (auth.uid() = user_id);

-- 4. Política para UPDATE: Usuários só podem atualizar seus próprios livros
CREATE POLICY "Users can update their own books"
ON public.books
FOR UPDATE
USING (auth.uid() = user_id)
WITH CHECK (auth.uid() = user_id);

-- 5. Política para DELETE: Usuários só podem deletar seus próprios livros
CREATE POLICY "Users can delete their own books"
ON public.books
FOR DELETE
USING (auth.uid() = user_id);
