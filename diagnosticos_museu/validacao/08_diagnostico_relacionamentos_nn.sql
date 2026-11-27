-- ============================================================
-- Objetivo: verificar se há duplicatas em item_acervo_colaborador
--           antes de aplicar a chave primária composta.
-- ============================================================

USE museutrezemaio2_teste;

-- 1. Duplicatas exatas (pares repetidos)
SELECT
    id_item_acervo,
    id_colaborador,
    COUNT(*) AS ocorrencias
FROM item_acervo_colaborador
GROUP BY id_item_acervo, id_colaborador
HAVING COUNT(*) > 1;

-- 2. Total de linhas vs. pares distintos
--    (se forem iguais, não há duplicatas)
SELECT
    COUNT(*)                                        AS total_linhas,
    COUNT(DISTINCT id_item_acervo, id_colaborador)  AS pares_distintos
FROM item_acervo_colaborador;

-- 3. Estado atual de índices/constraints na tabela
SELECT
    INDEX_NAME,
    COLUMN_NAME,
    NON_UNIQUE,
    SEQ_IN_INDEX
FROM information_schema.STATISTICS
WHERE TABLE_SCHEMA = 'museutrezemaio2_teste'
  AND TABLE_NAME   = 'item_acervo_colaborador'
ORDER BY INDEX_NAME, SEQ_IN_INDEX;

-- 4. Verificar se a PK já existe (idempotência da melhoria)
SELECT COUNT(*) AS pk_ja_existe
FROM information_schema.TABLE_CONSTRAINTS
WHERE TABLE_SCHEMA    = 'museutrezemaio2_teste'
  AND TABLE_NAME      = 'item_acervo_colaborador'
  AND CONSTRAINT_TYPE = 'PRIMARY KEY';