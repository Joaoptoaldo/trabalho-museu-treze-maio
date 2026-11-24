USE museutrezemaio2_teste;

-- Executar somente antes da criação da chave primária.
-- O relacionamento (1, 4) deve existir uma única vez.

START TRANSACTION;

-- Tentar inserir novamente um relacionamento existente
INSERT INTO item_acervo_assunto (
    id_item_acervo,
    id_assunto
)
VALUES (1, 4);

-- Conferir se o banco aceitou a duplicação
SELECT
    id_item_acervo,
    id_assunto,
    COUNT(*) AS ocorrencias
FROM item_acervo_assunto
WHERE id_item_acervo = 1
  AND id_assunto = 4
GROUP BY id_item_acervo, id_assunto;

ROLLBACK;