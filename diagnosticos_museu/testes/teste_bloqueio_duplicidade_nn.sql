USE museutrezemaio2_teste;

START TRANSACTION;

-- Testar a duplicação de um relacionamento item/assunto existente
INSERT IGNORE INTO item_acervo_assunto (
    id_item_acervo,
    id_assunto
)
VALUES (1, 4);

SELECT COUNT(*) AS ocorrencias_assunto
FROM item_acervo_assunto
WHERE id_item_acervo = 1
  AND id_assunto = 4;

-- Selecionar um relacionamento item/colaborador existente
SELECT
    id_item_acervo,
    id_colaborador
INTO
    @id_item_teste,
    @id_colaborador_teste
FROM item_acervo_colaborador
LIMIT 1;

-- Tentar inserir novamente o mesmo relacionamento
INSERT IGNORE INTO item_acervo_colaborador (
    id_item_acervo,
    id_colaborador
)
VALUES (
    @id_item_teste,
    @id_colaborador_teste
);

SELECT COUNT(*) AS ocorrencias_colaborador
FROM item_acervo_colaborador
WHERE id_item_acervo = @id_item_teste
  AND id_colaborador = @id_colaborador_teste;

ROLLBACK;