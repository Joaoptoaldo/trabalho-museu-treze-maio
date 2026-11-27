-- ============================================================
-- Objetivo: provar que a PK composta bloqueia duplicatas e
--           que pares novos válidos continuam sendo aceitos.
-- ============================================================

USE museutrezemaio2_teste;

-- ------------------------------------------------------------
-- TESTE 1 — Sanidade: a PK composta existe?
-- Resultado esperado: 1
-- ------------------------------------------------------------
SELECT COUNT(*) AS pk_existe
FROM information_schema.TABLE_CONSTRAINTS
WHERE TABLE_SCHEMA    = 'museutrezemaio2_teste'
  AND TABLE_NAME      = 'item_acervo_colaborador'
  AND CONSTRAINT_TYPE = 'PRIMARY KEY';

-- ------------------------------------------------------------
-- TESTE 2 — Bloqueio de duplicata (manual).
-- Pegue um par existente...
-- ------------------------------------------------------------
SELECT id_item_acervo, id_colaborador
FROM item_acervo_colaborador
LIMIT 1;

-- ...e tente reinseri-lo. Deve falhar com:
--   ERROR 1062 (23000): Duplicate entry 'X-Y' for key 'PRIMARY'
-- Descomente as duas linhas abaixo e substitua os valores
-- pelos retornados pela consulta anterior.
-- ------------------------------------------------------------
-- INSERT INTO item_acervo_colaborador (id_item_acervo, id_colaborador)
-- VALUES (X, Y);

-- ------------------------------------------------------------
-- TESTE 3 — Versão automatizada do bloqueio, via procedure.
-- Retorna 'OK: duplicata bloqueada' se a PK funcionar.
-- ------------------------------------------------------------
DROP PROCEDURE IF EXISTS test_bloqueio_duplicidade_colaborador;

DELIMITER $$
CREATE PROCEDURE test_bloqueio_duplicidade_colaborador()
BEGIN
    DECLARE v_item   INT;
    DECLARE v_colab  INT;
    DECLARE v_ok     BOOL DEFAULT FALSE;

    SELECT id_item_acervo, id_colaborador
      INTO v_item, v_colab
      FROM item_acervo_colaborador
      LIMIT 1;

    IF v_item IS NULL THEN
        SELECT 'INCONCLUSIVO: tabela vazia' AS resultado;
    ELSE
        BEGIN
            DECLARE EXIT HANDLER FOR 1062
            BEGIN
                SET v_ok = TRUE;
            END;
            INSERT INTO item_acervo_colaborador (id_item_acervo, id_colaborador)
            VALUES (v_item, v_colab);
        END;

        IF v_ok THEN
            SELECT CONCAT('OK: duplicata bloqueada para (', v_item, ', ', v_colab, ')') AS resultado;
        ELSE
            SELECT CONCAT('FALHA: duplicata NÃO bloqueada para (', v_item, ', ', v_colab, ')') AS resultado;
        END IF;
    END IF;
END$$
DELIMITER ;

CALL test_bloqueio_duplicidade_colaborador();
DROP PROCEDURE test_bloqueio_duplicidade_colaborador;

-- ------------------------------------------------------------
-- TESTE 4 — Inserção de par novo válido deve funcionar.
-- Usa um par que ainda não exista; limpa em seguida.
-- ------------------------------------------------------------
SET @item_novo = (
    SELECT ia.id_item_acervo
    FROM item_acervo ia
    WHERE NOT EXISTS (
        SELECT 1 FROM item_acervo_colaborador iac
        WHERE iac.id_item_acervo = ia.id_item_acervo
    )
    LIMIT 1
);
SET @colab_novo = (SELECT id_colaborador FROM colaborador LIMIT 1);

-- Descomente para executar a inserção válida:
INSERT INTO item_acervo_colaborador (id_item_acervo, id_colaborador)
VALUES (@item_novo, @colab_novo);

-- Limpeza do par inserido no teste 4:
DELETE FROM item_acervo_colaborador
WHERE id_item_acervo = @item_novo AND id_colaborador = @colab_novo;