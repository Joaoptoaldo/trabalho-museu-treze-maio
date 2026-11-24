USE museutrezemaio2_teste;

-- 1. Consultar as chaves primárias existentes
SELECT
    tc.TABLE_NAME,
    tc.CONSTRAINT_NAME,
    GROUP_CONCAT(
        kcu.COLUMN_NAME
        ORDER BY kcu.ORDINAL_POSITION
    ) AS colunas
FROM information_schema.TABLE_CONSTRAINTS tc
JOIN information_schema.KEY_COLUMN_USAGE kcu
    ON tc.CONSTRAINT_SCHEMA = kcu.CONSTRAINT_SCHEMA
    AND tc.TABLE_NAME = kcu.TABLE_NAME
    AND tc.CONSTRAINT_NAME = kcu.CONSTRAINT_NAME
WHERE tc.CONSTRAINT_SCHEMA = DATABASE()
  AND tc.CONSTRAINT_TYPE = 'PRIMARY KEY'
  AND tc.TABLE_NAME IN (
      'item_acervo_assunto',
      'item_acervo_colaborador'
  )
GROUP BY tc.TABLE_NAME, tc.CONSTRAINT_NAME;

-- 2. Procurar duplicidades em item_acervo_assunto
SELECT
    id_item_acervo,
    id_assunto,
    COUNT(*) AS ocorrencias
FROM item_acervo_assunto
GROUP BY id_item_acervo, id_assunto
HAVING COUNT(*) > 1;

-- 3. Procurar duplicidades em item_acervo_colaborador
SELECT
    id_item_acervo,
    id_colaborador,
    COUNT(*) AS ocorrencias
FROM item_acervo_colaborador
GROUP BY id_item_acervo, id_colaborador
HAVING COUNT(*) > 1;