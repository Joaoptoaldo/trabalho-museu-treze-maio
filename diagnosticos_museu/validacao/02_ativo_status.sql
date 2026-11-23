-- =============================================================
-- 02 - Diagnóstico dos campos ativo e status
-- Banco de teste: museutrezemaio2_teste
-- Somente leitura.
-- Observação: ativo (exclusão lógica) e status (situação do acervo)
-- têm significados diferentes segundo o dicionário de dados.
-- =============================================================

USE museutrezemaio2_teste;

-- 2.1 - Distribuição de status e ativo por tipo de acervo.
SELECT
    'Livro' AS tipo,
    ia.status,
    CAST(l.ativo AS UNSIGNED) AS registro_ativo,
    COUNT(*) AS quantidade
FROM item_acervo AS ia
JOIN livro AS l
    ON l.id_item_acervo = ia.id_item_acervo
GROUP BY ia.status, l.ativo

UNION ALL

SELECT
    'Revista',
    ia.status,
    CAST(r.ativo AS UNSIGNED),
    COUNT(*)
FROM item_acervo AS ia
JOIN revista AS r
    ON r.id_item_acervo = ia.id_item_acervo
GROUP BY ia.status, r.ativo

UNION ALL

SELECT
    'Jornal',
    ia.status,
    CAST(j.ativo AS UNSIGNED),
    COUNT(*)
FROM item_acervo AS ia
JOIN jornal AS j
    ON j.id_item_acervo = ia.id_item_acervo
GROUP BY ia.status, j.ativo
ORDER BY tipo, status, registro_ativo;

-- 2.2 - Lista de registros com ativo = 0 e status = 'Ativo'.
-- Esta combinação não é automaticamente uma inconsistência:
-- ativo representa exclusão lógica, enquanto status descreve
-- a situação do item no acervo.
SELECT
    ia.id_item_acervo,
    ia.titulo,
    ia.tipo,
    ia.status,
    CAST(l.ativo AS UNSIGNED) AS registro_ativo
FROM item_acervo AS ia
JOIN livro AS l
    ON l.id_item_acervo = ia.id_item_acervo
WHERE l.ativo = b'0'
  AND ia.status = 'Ativo'

UNION ALL

SELECT
    ia.id_item_acervo,
    ia.titulo,
    ia.tipo,
    ia.status,
    CAST(r.ativo AS UNSIGNED)
FROM item_acervo AS ia
JOIN revista AS r
    ON r.id_item_acervo = ia.id_item_acervo
WHERE r.ativo = b'0'
  AND ia.status = 'Ativo'

UNION ALL

SELECT
    ia.id_item_acervo,
    ia.titulo,
    ia.tipo,
    ia.status,
    CAST(j.ativo AS UNSIGNED)
FROM item_acervo AS ia
JOIN jornal AS j
    ON j.id_item_acervo = ia.id_item_acervo
WHERE j.ativo = b'0'
  AND ia.status = 'Ativo'
ORDER BY id_item_acervo;
