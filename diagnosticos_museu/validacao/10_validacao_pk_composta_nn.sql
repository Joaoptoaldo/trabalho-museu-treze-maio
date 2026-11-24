USE museutrezemaio2_teste;

-- Conferir a estrutura da tabela modificada
SHOW CREATE TABLE item_acervo_assunto;

-- Conferir a estrutura da outra tabela associativa
SHOW CREATE TABLE item_acervo_colaborador;

-- Verificar novamente duplicidades em item_acervo_assunto
SELECT
    id_item_acervo,
    id_assunto,
    COUNT(*) AS ocorrencias
FROM item_acervo_assunto
GROUP BY id_item_acervo, id_assunto
HAVING COUNT(*) > 1;

-- Verificar novamente duplicidades em item_acervo_colaborador
SELECT
    id_item_acervo,
    id_colaborador,
    COUNT(*) AS ocorrencias
FROM item_acervo_colaborador
GROUP BY id_item_acervo, id_colaborador
HAVING COUNT(*) > 1;