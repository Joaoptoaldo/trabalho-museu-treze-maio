USE museutrezemaio2_teste;

-- adiciona PRIMARY KEY composta em item_acervo_colaborador,
-- espelhando a melhoria já aplicada em item_acervo_assunto.
ALTER TABLE item_acervo_colaborador
ADD PRIMARY KEY (id_item_acervo, id_colaborador);