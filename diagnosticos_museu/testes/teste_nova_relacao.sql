USE museutrezemaio2_teste;

-- Encontrar um par válido que ainda não exista
SET @novo_item = NULL;
SET @novo_assunto = NULL;

SELECT
    ia.id_item_acervo,
    a.id_assunto
INTO
    @novo_item,
    @novo_assunto
FROM item_acervo ia
CROSS JOIN assunto a
WHERE NOT EXISTS (
    SELECT 1
    FROM item_acervo_assunto rel
    WHERE rel.id_item_acervo = ia.id_item_acervo
      AND rel.id_assunto = a.id_assunto
)
LIMIT 1;

-- Conferir o par selecionado
SELECT
    @novo_item AS id_item_acervo,
    @novo_assunto AS id_assunto;

START TRANSACTION;

-- Inserir o novo relacionamento
INSERT INTO item_acervo_assunto (
    id_item_acervo,
    id_assunto
)
VALUES (
    @novo_item,
    @novo_assunto
);

-- Confirmar que foi inserido exatamente uma vez
SELECT COUNT(*) AS ocorrencias
FROM item_acervo_assunto
WHERE id_item_acervo = @novo_item
  AND id_assunto = @novo_assunto;

ROLLBACK;