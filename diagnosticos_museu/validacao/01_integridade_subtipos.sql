-- =============================================================
-- 01 - Integridade entre item_acervo e suas tabelas especializadas
-- Banco de teste: museutrezemaio2_teste
-- Somente leitura.
-- =============================================================

USE museutrezemaio2_teste;

-- 1.1 - Lista os itens cuja tabela especializada não corresponde
--      ao valor de item_acervo.tipo, ou que possuem mais de uma
--      especialização.
-- Resultado esperado nos dados analisados: nenhuma linha.
SELECT
    ia.id_item_acervo,
    ia.titulo,
    ia.tipo,
    CASE WHEN l.id_item_acervo IS NOT NULL THEN 'Sim' ELSE 'Não' END AS possui_livro,
    CASE WHEN r.id_item_acervo IS NOT NULL THEN 'Sim' ELSE 'Não' END AS possui_revista,
    CASE WHEN j.id_item_acervo IS NOT NULL THEN 'Sim' ELSE 'Não' END AS possui_jornal
FROM item_acervo AS ia
LEFT JOIN livro AS l
    ON l.id_item_acervo = ia.id_item_acervo
LEFT JOIN revista AS r
    ON r.id_item_acervo = ia.id_item_acervo
LEFT JOIN jornal AS j
    ON j.id_item_acervo = ia.id_item_acervo
WHERE
       (ia.tipo = 'Livro'
        AND (l.id_item_acervo IS NULL
             OR r.id_item_acervo IS NOT NULL
             OR j.id_item_acervo IS NOT NULL))
    OR (ia.tipo = 'Revista'
        AND (r.id_item_acervo IS NULL
             OR l.id_item_acervo IS NOT NULL
             OR j.id_item_acervo IS NOT NULL))
    OR (ia.tipo = 'Jornal'
        AND (j.id_item_acervo IS NULL
             OR l.id_item_acervo IS NOT NULL
             OR r.id_item_acervo IS NOT NULL))
    OR ia.tipo NOT IN ('Livro', 'Revista', 'Jornal')
ORDER BY ia.id_item_acervo;

-- 1.2 - Resumo quantitativo das inconsistências por tipo.
-- total_itens deve corresponder à quantidade total de item_acervo.
-- Resultado observado: 1.000 itens e zero inconsistências.
SELECT
    COUNT(*) AS total_itens,
    SUM(CASE
        WHEN ia.tipo = 'Livro'
         AND (l.id_item_acervo IS NULL
              OR r.id_item_acervo IS NOT NULL
              OR j.id_item_acervo IS NOT NULL)
        THEN 1 ELSE 0
    END) AS livros_inconsistentes,
    SUM(CASE
        WHEN ia.tipo = 'Revista'
         AND (r.id_item_acervo IS NULL
              OR l.id_item_acervo IS NOT NULL
              OR j.id_item_acervo IS NOT NULL)
        THEN 1 ELSE 0
    END) AS revistas_inconsistentes,
    SUM(CASE
        WHEN ia.tipo = 'Jornal'
         AND (j.id_item_acervo IS NULL
              OR l.id_item_acervo IS NOT NULL
              OR r.id_item_acervo IS NOT NULL)
        THEN 1 ELSE 0
    END) AS jornais_inconsistentes,
    SUM(CASE
        WHEN ia.tipo NOT IN ('Livro', 'Revista', 'Jornal')
        THEN 1 ELSE 0
    END) AS tipos_desconhecidos
FROM item_acervo AS ia
LEFT JOIN livro AS l
    ON l.id_item_acervo = ia.id_item_acervo
LEFT JOIN revista AS r
    ON r.id_item_acervo = ia.id_item_acervo
LEFT JOIN jornal AS j
    ON j.id_item_acervo = ia.id_item_acervo;
