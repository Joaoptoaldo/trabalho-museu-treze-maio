USE museutrezemaio2_teste;

-- Limite de páginas do item do acervo
ALTER TABLE item_acervo
ADD CONSTRAINT chk_item_acervo_numero_paginas
CHECK (numero_paginas BETWEEN 0 AND 99999);

-- Ano de publicação do livro
ALTER TABLE livro
ADD CONSTRAINT chk_livro_ano_publicacao
CHECK (ano_publicacao BETWEEN 1 AND 9999);

-- Ano de publicação da revista
ALTER TABLE revista
ADD CONSTRAINT chk_revista_ano
CHECK (ano BETWEEN 1 AND 9999);

-- Mês de publicação da revista
ALTER TABLE revista
ADD CONSTRAINT chk_revista_mes
CHECK (mes BETWEEN 1 AND 12);


-- Cnfirmação da implementação
-- quatro linhas, todas com ENFORCED = YES
SELECT
    tc.TABLE_NAME,
    tc.CONSTRAINT_NAME,
    cc.CHECK_CLAUSE,
    tc.ENFORCED
FROM information_schema.TABLE_CONSTRAINTS tc
JOIN information_schema.CHECK_CONSTRAINTS cc
    ON cc.CONSTRAINT_SCHEMA = tc.CONSTRAINT_SCHEMA
   AND cc.CONSTRAINT_NAME = tc.CONSTRAINT_NAME
WHERE tc.CONSTRAINT_SCHEMA = 'museutrezemaio2_teste'
  AND tc.CONSTRAINT_TYPE = 'CHECK'
  AND tc.CONSTRAINT_NAME IN (
      'chk_item_acervo_numero_paginas',
      'chk_livro_ano_publicacao',
      'chk_revista_ano',
      'chk_revista_mes'
  )
ORDER BY tc.TABLE_NAME, tc.CONSTRAINT_NAME;