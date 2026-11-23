-- =============================================================
-- 06 - Levantamento dos valores textuais existentes
-- Banco de teste: museutrezemaio2_teste
-- Somente leitura.
-- =============================================================

USE museutrezemaio2_teste;

-- Lista os valores distintos de tipo, status e idioma, distinguindo
-- também representações binárias diferentes (por exemplo, espaços
-- ou caracteres com codificação diferente).
-- Este levantamento NÃO determina sozinho quais valores são válidos
-- segundo a aplicação; apenas mostra o conteúdo atualmente cadastrado.
SELECT
    'tipo' AS campo,
    tipo AS valor,
    HEX(tipo) AS representacao_hex,
    COUNT(*) AS quantidade
FROM item_acervo
GROUP BY tipo, HEX(tipo)

UNION ALL

SELECT
    'status',
    status,
    HEX(status),
    COUNT(*)
FROM item_acervo
GROUP BY status, HEX(status)

UNION ALL

SELECT
    'idioma',
    idioma,
    HEX(idioma),
    COUNT(*)
FROM item_acervo
GROUP BY idioma, HEX(idioma)

ORDER BY campo, representacao_hex;
