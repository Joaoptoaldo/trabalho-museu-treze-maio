-- =============================================================
-- 04 - Validação de formato e dígito verificador dos ISSNs
-- Banco de teste: museutrezemaio2_teste
-- Somente leitura.
-- Formato aceito: NNNNNNNN ou NNNN-NNNN.
-- O último caractere pode ser X (representa o valor 10).
-- =============================================================

USE museutrezemaio2_teste;

-- 4.1 - Registros com formato incompatível.
-- Resultado observado após considerar X final: nenhuma linha.
SELECT
    id_item_acervo,
    codigo_revista,
    issn
FROM revista
WHERE issn IS NOT NULL
  AND NOT (
      REGEXP_LIKE(UPPER(issn), '^[0-9]{7}[0-9X]$', 'c')
      OR REGEXP_LIKE(UPPER(issn), '^[0-9]{4}-[0-9]{3}[0-9X]$', 'c')
  )
ORDER BY id_item_acervo;

-- 4.2 - Registros com dígito verificador inválido.
-- Executa o cálculo apenas sobre ISSNs com formato reconhecido.
-- Resultado observado: nenhuma linha.
WITH normalizados AS (
    SELECT
        id_item_acervo,
        codigo_revista,
        issn,
        UPPER(REPLACE(issn, '-', '')) AS numero
    FROM revista
    WHERE issn IS NOT NULL
      AND (
          REGEXP_LIKE(UPPER(issn), '^[0-9]{7}[0-9X]$', 'c')
          OR REGEXP_LIKE(UPPER(issn), '^[0-9]{4}-[0-9]{3}[0-9X]$', 'c')
      )
),
somas AS (
    SELECT *,
        CAST(SUBSTRING(numero, 1, 1) AS UNSIGNED) * 8 +
        CAST(SUBSTRING(numero, 2, 1) AS UNSIGNED) * 7 +
        CAST(SUBSTRING(numero, 3, 1) AS UNSIGNED) * 6 +
        CAST(SUBSTRING(numero, 4, 1) AS UNSIGNED) * 5 +
        CAST(SUBSTRING(numero, 5, 1) AS UNSIGNED) * 4 +
        CAST(SUBSTRING(numero, 6, 1) AS UNSIGNED) * 3 +
        CAST(SUBSTRING(numero, 7, 1) AS UNSIGNED) * 2 AS soma
    FROM normalizados
),
resultado AS (
    SELECT *,
        SUBSTRING(numero, 8, 1) AS digito_cadastrado,
        CASE
            WHEN MOD(11 - MOD(soma, 11), 11) = 10 THEN 'X'
            ELSE CAST(MOD(11 - MOD(soma, 11), 11) AS CHAR)
        END AS digito_calculado
    FROM somas
)
SELECT
    id_item_acervo,
    codigo_revista,
    issn,
    soma,
    digito_cadastrado,
    digito_calculado
FROM resultado
WHERE BINARY digito_cadastrado <> BINARY digito_calculado
ORDER BY id_item_acervo;
