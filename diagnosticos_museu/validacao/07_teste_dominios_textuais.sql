-- =============================================================
-- 07 - Experimento controlado: domínios textuais
-- Banco de teste: museutrezemaio2_teste
-- NÃO altera registros permanentes de item_acervo.
-- =============================================================

USE museutrezemaio2_teste;

-- IMPORTANTE:
-- Execute este arquivo inteiro na mesma conexão/aba do Workbench.
-- Tabelas TEMPORARY existem somente na conexão que as criou.
-- Se a execução for interrompida antes do DROP, execute novamente
-- o DROP abaixo na mesma conexão antes de recriar a tabela.

DROP TEMPORARY TABLE IF EXISTS item_acervo_teste;

-- Cria uma cópia vazia da estrutura de colunas e índices da tabela.
-- CREATE TABLE ... LIKE não copia triggers; portanto, este experimento
-- verifica as restrições estruturais copiadas, não o comportamento
-- de eventuais triggers associados à tabela original.
CREATE TEMPORARY TABLE item_acervo_teste LIKE item_acervo;

-- Teste 1: idioma fora dos valores encontrados atualmente.
INSERT INTO item_acervo_teste (
    idioma, localizacao_acervo, numero_paginas,
    status, tipo, titulo, visibilidade_notas
)
VALUES (
    'IdiomaInventado', 'Teste', 0,
    'Ativo', 'Livro', 'Teste idioma', b'0'
);

-- Teste 2: status fora dos valores encontrados atualmente.
INSERT INTO item_acervo_teste (
    idioma, localizacao_acervo, numero_paginas,
    status, tipo, titulo, visibilidade_notas
)
VALUES (
    'Português', 'Teste', 0,
    'StatusInventado', 'Livro', 'Teste status', b'0'
);

-- Teste 3: tipo fora dos valores encontrados atualmente.
INSERT INTO item_acervo_teste (
    idioma, localizacao_acervo, numero_paginas,
    status, tipo, titulo, visibilidade_notas
)
VALUES (
    'Português', 'Teste', 0,
    'Ativo', 'TipoInventado', 'Teste tipo', b'0'
);

-- Se os três INSERTs forem aceitos, a consulta exibirá três linhas.
SELECT
    idioma,
    status,
    tipo,
    titulo
FROM item_acervo_teste;

-- Limpeza: remove a tabela temporária ao final do experimento.
DROP TEMPORARY TABLE item_acervo_teste;
