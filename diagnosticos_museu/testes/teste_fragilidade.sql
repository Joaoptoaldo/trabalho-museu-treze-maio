USE museutrezemaio2_teste;

-- Limpar temporárias de uma execução anterior
DROP TEMPORARY TABLE IF EXISTS tmp_check_item_acervo;
DROP TEMPORARY TABLE IF EXISTS tmp_check_livro;
DROP TEMPORARY TABLE IF EXISTS tmp_check_revista;

-- Criar cópias vazias das estruturas originais
CREATE TEMPORARY TABLE tmp_check_item_acervo
LIKE item_acervo;

CREATE TEMPORARY TABLE tmp_check_livro
LIKE livro;

CREATE TEMPORARY TABLE tmp_check_revista
LIKE revista;


-- TESTE 1: número de páginas negativo
INSERT INTO tmp_check_item_acervo (
    idioma,
    localizacao_acervo,
    numero_paginas,
    status,
    tipo,
    titulo,
    visibilidade_notas
)
VALUES (
    'Português',
    'Teste',
    -1,
    'Ativo',
    'Livro',
    'Teste de páginas',
    b'0'
);


-- TESTE 2: ano de publicação igual a zero
INSERT INTO tmp_check_livro (
    ano_publicacao,
    ativo,
    codigo_livro,
    edicao,
    ilustrado,
    id_item_acervo
)
VALUES (
    0,
    b'1',
    'TESTE-CHECK-LIVRO',
    'Teste',
    b'0',
    1
);


-- TESTE 3: ano de revista superior ao limite
INSERT INTO tmp_check_revista (
    issn,
    ano,
    ativo,
    codigo_revista,
    edicao,
    mes,
    id_item_acervo
)
VALUES (
    NULL,
    10000,
    b'1',
    'TESTE-CHECK-REVISTA-ANO',
    'Teste',
    1,
    1
);


-- TESTE 4: mês de revista superior a 12
INSERT INTO tmp_check_revista (
    issn,
    ano,
    ativo,
    codigo_revista,
    edicao,
    mes,
    id_item_acervo
)
VALUES (
    NULL,
    2026,
    b'1',
    'TESTE-CHECK-REVISTA-MES',
    'Teste',
    13,
    2
);


-- Consultar resultados
SELECT
    'numero_paginas' AS campo,
    numero_paginas AS valor
FROM tmp_check_item_acervo;

SELECT
    'ano_publicacao' AS campo,
    ano_publicacao AS valor
FROM tmp_check_livro;

SELECT
    'ano_revista' AS campo,
    ano AS valor,
    mes
FROM tmp_check_revista
WHERE codigo_revista = 'TESTE-CHECK-REVISTA-ANO';

SELECT
    'mes_revista' AS campo,
    ano,
    mes AS valor
FROM tmp_check_revista
WHERE codigo_revista = 'TESTE-CHECK-REVISTA-MES';


-- Remover tabelas temporárias
DROP TEMPORARY TABLE tmp_check_item_acervo;
DROP TEMPORARY TABLE tmp_check_livro;
DROP TEMPORARY TABLE tmp_check_revista;