-- =============================================================
-- 05 - Validação dos limites numéricos documentados
-- Banco de teste: museutrezemaio2_teste
-- Somente leitura.
-- =============================================================

USE museutrezemaio2_teste;

-- Procura valores fora dos intervalos descritos no dicionário:
-- numero_paginas: 0 a 99.999
-- ano_publicacao / ano: 1 a 9.999
-- mes: 1 a 12
-- Resultado observado: nenhuma linha.
SELECT
    'item_acervo.numero_paginas' AS campo,
    id_item_acervo AS registro,
    CAST(numero_paginas AS CHAR) AS valor
FROM item_acervo
WHERE numero_paginas < 0 OR numero_paginas > 99999

UNION ALL

SELECT
    'livro.ano_publicacao',
    id_item_acervo,
    CAST(ano_publicacao AS CHAR)
FROM livro
WHERE ano_publicacao < 1 OR ano_publicacao > 9999

UNION ALL

SELECT
    'revista.ano',
    id_item_acervo,
    CAST(ano AS CHAR)
FROM revista
WHERE ano IS NOT NULL
  AND (ano < 1 OR ano > 9999)

UNION ALL

SELECT
    'revista.mes',
    id_item_acervo,
    CAST(mes AS CHAR)
FROM revista
WHERE mes IS NOT NULL
  AND (mes < 1 OR mes > 12)
ORDER BY campo, registro;
