# Diagnósticos do banco - Museu Treze de Maio

Conjunto de consultas SQL utilizadas na investigação do banco `museutrezemaio2_teste`, compatíveis com MySQL 8. Os arquivos documentam verificações realizadas durante o diagnóstico; não substituem os scripts originais de criação e carga do banco.

## Organização

| Arquivo | Finalidade | Tipo de operação |
|---|---|---|
| `validacao/01_integridade_subtipos.sql` | Confere a correspondência entre `item_acervo.tipo` e as tabelas `livro`, `revista` e `jornal` | Somente leitura |
| `validacao/02_ativo_status.sql` | Analisa a combinação entre exclusão lógica (`ativo`) e situação do acervo (`status`) | Somente leitura |
| `validacao/03_validacao_isbn.sql` | Verifica formato e dígito verificador dos ISBNs, incluindo ISBN-10 com `X` final | Somente leitura |
| `validacao/04_validacao_issn.sql` | Verifica formato e dígito verificador dos ISSNs, inclusive `X` final | Somente leitura |
| `validacao/05_limites_numericos.sql` | Verifica os intervalos numéricos documentados nos dados existentes | Somente leitura |
| `validacao/06_dominios_textuais.sql` | Lista os valores existentes em `tipo`, `status` e `idioma` | Somente leitura |
| `validacao/07_teste_dominios_textuais.sql` | Testa a inserção de valores textuais fora dos valores observados | Cria e remove uma tabela temporária |
| `melhorias/01-restricoes/melhoria_restricoes.sql` | Aplica restrições CHECK ao schema de teste | Cria/Altera (DDL) |
| `testes/teste_fragilidade.sql` | Avalia a fragilidade de regras ao inserir valores fora do padrão | Cria e remove tabelas temporárias (teste) |

## Resultados

- **Integridade entre item e subtipo:** foram analisados 1.000 itens: 500 livros, 300 revistas e 200 jornais. Não foram encontradas divergências entre `item_acervo.tipo` e a tabela especializada correspondente.
- **`ativo` e `status`:** representam conceitos distintos. `ativo` indica exclusão lógica; `status` descreve a situação do item no acervo. A combinação `ativo = 0` e `status = 'Ativo'` não foi classificada automaticamente como erro.
- **ISBN:** não foram encontradas inconsistências de formato ou de dígito verificador nos ISBNs preenchidos analisados.
- **ISSN:** não foram encontradas inconsistências de formato ou de dígito verificador nos ISSNs preenchidos analisados. O registro `7937-395X` foi conferido e passou no cálculo do dígito verificador.
- **Limites numéricos — dados existentes:** não foram encontrados valores fora dos intervalos documentados para `numero_paginas`, `ano_publicacao`, `revista.ano` e `revista.mes`.
- **Domínios textuais:** foram identificados os valores atualmente cadastrados em `tipo`, `status` e `idioma`. O experimento de inserção de valores textuais arbitrários ainda não foi concluído com resultado verificável; portanto, não se afirma que esses domínios estejam ou não protegidos pelo banco.

## Melhoria aplicada no banco de teste: restrições CHECK

A investigação do DDL e do banco de teste confirmou que não havia restrições `CHECK` para os quatro limites numéricos documentados. Antes da melhoria, testes controlados em tabelas temporárias demonstraram que os valores inválidos abaixo eram aceitos.

Foram então adicionadas ao schema `museutrezemaio2_teste` as quatro restrições seguintes:

| Tabela | Restrição | Regra aplicada |
|---|---|---|
| `item_acervo` | `chk_item_acervo_numero_paginas` | `numero_paginas BETWEEN 0 AND 99999` |
| `livro` | `chk_livro_ano_publicacao` | `ano_publicacao BETWEEN 1 AND 9999` |
| `revista` | `chk_revista_ano` | `ano BETWEEN 1 AND 9999` |
| `revista` | `chk_revista_mes` | `mes BETWEEN 1 AND 12` |

A consulta ao `information_schema` confirmou as quatro restrições com `ENFORCED = YES`. Após a implementação, os testes apresentaram os seguintes resultados:

| Cenário testado | Resultado antes | Resultado depois |
|---|---|---|
| `numero_paginas = -1` | Inserção aceita | Inserção rejeitada |
| `ano_publicacao = 0` | Inserção aceita | Inserção rejeitada |
| `revista.ano = 10000` | Inserção aceita | Inserção rejeitada |
| `revista.mes = 13` | Inserção aceita | Inserção rejeitada |
| Limites válidos: páginas `0` e `99999`; ano `1` e `9999`; mês `1` e `12` | — | Inserções aceitas |

**Conclusão:** a melhoria foi implementada e validada na cópia de teste. Ela faz o próprio SGBD rejeitar valores fora dos intervalos documentados, sem bloquear os valores-limite permitidos. Essa alteração foi executada separadamente dos arquivos de diagnóstico desta pasta; o script permanente de melhoria deve ser mantido na área de implementações do projeto, não misturado às consultas de `validation/`.

## Cuidados de interpretação

- Uma consulta sem linhas significa que ela não encontrou ocorrências segundo os critérios implementados; não prova, por si só, que o banco impeça novas ocorrências.
- Os levantamentos de valores existentes não substituem a análise das validações da aplicação.
- O experimento com `CREATE TEMPORARY TABLE ... LIKE` não copia triggers. Portanto, ele não permite concluir nada sobre eventuais regras implementadas por triggers na tabela original.
- Os arquivos desta pasta são consultas de diagnóstico e um experimento temporário. O arquivo `07` cria e remove uma tabela temporária; nenhum deles aplica alterações permanentes ao schema.
- A melhoria `CHECK` descrita acima é uma alteração permanente já aplicada somente em `museutrezemaio2_teste`; ela não deve ser confundida com as consultas desta pasta.
