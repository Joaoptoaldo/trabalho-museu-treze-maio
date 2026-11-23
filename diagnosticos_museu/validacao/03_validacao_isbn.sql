-- =============================================================
-- 03 - Validação de formato e dígito verificador dos ISBNs
-- Banco de teste: museutrezemaio2_teste
-- Somente leitura.
-- ISBN-10: aceita X como último caractere.
-- ISBN-13: aceita somente dígitos.
-- Os hífens são removidos antes da validação do conteúdo numérico.
-- =============================================================

USE museutrezemaio2_teste;

-- 3.1 - Registros com formato incompatível.
-- Resultado observado: nenhuma linha.
SELECT
    id_item_acervo,
    codigo_livro,
    isbn,
    UPPER(REPLACE(isbn, '-', '')) AS isbn_normalizado,
    CHAR_LENGTH(UPPER(REPLACE(isbn, '-', ''))) AS quantidade_caracteres
FROM livro
WHERE isbn IS NOT NULL
  AND NOT REGEXP_LIKE(
      UPPER(REPLACE(isbn, '-', '')),
      '^([0-9]{9}[0-9X]|[0-9]{13})$',
      'c'
  )
ORDER BY id_item_acervo;

-- 3.2 - Registros com dígito verificador inválido.
-- Executa o cálculo somente sobre ISBNs que passaram pela validação
-- estrutural acima. Resultado observado: nenhuma linha.
WITH normalizados AS (
    SELECT
        id_item_acervo,
        codigo_livro,
        isbn,
        UPPER(REPLACE(isbn, '-', '')) AS numero
    FROM livro
    WHERE isbn IS NOT NULL
      AND REGEXP_LIKE(
          UPPER(REPLACE(isbn, '-', '')),
          '^([0-9]{9}[0-9X]|[0-9]{13})$',
          'c'
      )
),
somas AS (
    SELECT *,
        CASE
            WHEN CHAR_LENGTH(numero) = 10 THEN
                CAST(SUBSTRING(numero, 1, 1) AS UNSIGNED) * 10 +
                CAST(SUBSTRING(numero, 2, 1) AS UNSIGNED) * 9 +
                CAST(SUBSTRING(numero, 3, 1) AS UNSIGNED) * 8 +
                CAST(SUBSTRING(numero, 4, 1) AS UNSIGNED) * 7 +
                CAST(SUBSTRING(numero, 5, 1) AS UNSIGNED) * 6 +
                CAST(SUBSTRING(numero, 6, 1) AS UNSIGNED) * 5 +
                CAST(SUBSTRING(numero, 7, 1) AS UNSIGNED) * 4 +
                CAST(SUBSTRING(numero, 8, 1) AS UNSIGNED) * 3 +
                CAST(SUBSTRING(numero, 9, 1) AS UNSIGNED) * 2
            WHEN CHAR_LENGTH(numero) = 13 THEN
                CAST(SUBSTRING(numero, 1, 1) AS UNSIGNED) * 1 +
                CAST(SUBSTRING(numero, 2, 1) AS UNSIGNED) * 3 +
                CAST(SUBSTRING(numero, 3, 1) AS UNSIGNED) * 1 +
                CAST(SUBSTRING(numero, 4, 1) AS UNSIGNED) * 3 +
                CAST(SUBSTRING(numero, 5, 1) AS UNSIGNED) * 1 +
                CAST(SUBSTRING(numero, 6, 1) AS UNSIGNED) * 3 +
                CAST(SUBSTRING(numero, 7, 1) AS UNSIGNED) * 1 +
                CAST(SUBSTRING(numero, 8, 1) AS UNSIGNED) * 3 +
                CAST(SUBSTRING(numero, 9, 1) AS UNSIGNED) * 1 +
                CAST(SUBSTRING(numero, 10, 1) AS UNSIGNED) * 3 +
                CAST(SUBSTRING(numero, 11, 1) AS UNSIGNED) * 1 +
                CAST(SUBSTRING(numero, 12, 1) AS UNSIGNED) * 3
        END AS soma
    FROM normalizados
),
verificacao AS (
    SELECT *,
        SUBSTRING(numero, CHAR_LENGTH(numero), 1) AS digito_cadastrado,
        CASE
            WHEN CHAR_LENGTH(numero) = 10 THEN
                CASE
                    WHEN MOD(11 - MOD(soma, 11), 11) = 10 THEN 'X'
                    ELSE CAST(MOD(11 - MOD(soma, 11), 11) AS CHAR)
                END
            WHEN CHAR_LENGTH(numero) = 13 THEN
                CAST(MOD(10 - MOD(soma, 10), 10) AS CHAR)
        END AS digito_calculado
    FROM somas
)
SELECT
    id_item_acervo,
    codigo_livro,
    isbn,
    digito_cadastrado,
    digito_calculado
FROM verificacao
WHERE BINARY digito_cadastrado <> BINARY digito_calculado
ORDER BY id_item_acervo;
