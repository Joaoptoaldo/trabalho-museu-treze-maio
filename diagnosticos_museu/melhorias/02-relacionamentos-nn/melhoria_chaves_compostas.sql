USE museutrezemaio2_teste;

-- Impedir relacionamentos duplicados entre itens e assuntos
ALTER TABLE item_acervo_assunto
ADD PRIMARY KEY (id_item_acervo, id_assunto);
