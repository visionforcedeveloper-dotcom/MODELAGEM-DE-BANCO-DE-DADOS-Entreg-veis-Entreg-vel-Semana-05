# Projeto de Banco de Dados — Sistema de E-commerce (Grupo 4)

## Descricao do dominio

O banco de dados simula uma plataforma de e-commerce multi-vendedor, onde vendedores cadastram produtos, clientes fazem pedidos, pagamentos sao processados e entregas sao rastreadas por transportadoras. O sistema cobre o fluxo completo: navegacao por categorias, checkout com cupons de desconto, baixa de estoque, pagamento, separacao, envio e entrega.

## Modelo logico

### Entidades e relacionamentos

```
categorias (1) ---< (N) categorias_filhas
categorias (1) ---< (N) produtos
vendedores (1) ---< (N) produtos
produtos (1) --- (1) estoque
clientes (1) ---< (N) enderecos
clientes (1) ---< (N) pedidos
enderecos (1) ---< (N) pedidos
cupons (1) ---< (N) pedidos
pedidos (1) ---< (N) itens_pedido
produtos (1) ---< (N) itens_pedido
pedidos (1) ---< (N) pagamentos
pedidos (1) --- (1) entregas
transportadoras (1) ---< (N) entregas
produtos (1) ---< (N) avaliacoes
clientes (1) ---< (N) avaliacoes
```

### Tabelas (14 no total)

| # | Tabela | PK | FKs | Outras constraints |
|---|--------|-----|-----|-------------------|
| 1 | categorias | id_categoria | id_categoria_pai (self) | ativo DEFAULT TRUE |
| 2 | transportadoras | id_transportadora | — | cnpj UNIQUE, ativo DEFAULT TRUE |
| 3 | vendedores | id_vendedor | — | email UNIQUE, cnpj UNIQUE, avaliacao_media CHECK 0-5 |
| 4 | produtos | id_produto | id_categoria, id_vendedor | sku UNIQUE, preco CHECK > 0, peso CHECK >= 0 |
| 5 | estoque | id_estoque | id_produto (UNIQUE) | quantidade CHECK >= 0, quantidade_minima CHECK >= 0 |
| 6 | clientes | id_cliente | — | email UNIQUE, cpf UNIQUE, data_nascimento < CURRENT_DATE |
| 7 | enderecos | id_endereco | id_cliente | estado CHECK (2 siglas UF), principal DEFAULT FALSE |
| 8 | cupons | id_cupon | — | codigo UNIQUE, tipo_desconto CHECK, data_fim >= data_inicio |
| 9 | pedidos | id_pedido | id_cliente, id_endereco, id_cupon | status CHECK (6 valores) |
| 10 | itens_pedido | id_item | id_pedido (CASCADE), id_produto | quantidade CHECK > 0, desconto <= subtotal |
| 11 | pagamentos | id_pagamento | id_pedido | metodo CHECK (5 valores), parcelas CHECK 1-12, codigo_transacao UNIQUE |
| 12 | avaliacoes | id_avaliacao | id_produto, id_cliente | nota CHECK 1-5, UNIQUE(id_produto, id_cliente) |
| 13 | entregas | id_entrega | id_pedido, id_transportadora | codigo_rastreio UNIQUE, status CHECK (5 valores) |

## Normalizacao

O modelo esta na 3FN:

- **1FN**: todos os atributos sao atomicos. CPF e CEP sao CHAR(11) e CHAR(8) sem pontuacao. Endereco e separado em logradouro, numero, complemento, bairro, cidade, estado e cep.
- **2FN**: todas as colunas nao-chave dependem integralmente da PK. Nao ha dependencias parciais. Itens_pedido tem propria PK (id_item) e nao apenas (id_pedido, id_produto) composta.
- **3FN**: nao ha dependencias transitivas. Por exemplo, a avaliacao_media do vendedor esta na tabela vendedores (nao em produtos ou pedidos). O endereco do cliente fica em tabela separada (enderecos) e nao duplicado no pedido.

## Justificativa das escolhas

- **categorias com auto-referencia**: permite arvore de categorias sem tabela extra (categoria pai e categoria filha na mesma tabela).
- **estoque 1:1 com produtos**: mantem o estoque em tabela separada para nao afetar consultas de listagem de produtos que nao precisam de quantidade.
- **ON DELETE CASCADE em itens_pedido**: se um pedido e removido, seus itens sao removidos automaticamente. O pedido e a entidade pai.
- **CHECK constraints em pedidos.status e pagamentos.status**: garantem que so sejam inseridos valores validos do fluxo de negocio.
- **UNIQUE(id_produto, id_cliente) em avaliacoes**: um cliente so pode avaliar um produto uma unica vez.
- **cupons com limite_uso e vezes_usado**: controla o numero maximo de utilizacoes de cada cupom.
- **estado CHAR(2) com CHECK de siglas UF**: impede estados invalidos.
- **cpf CHAR(11) sem pontuacao**: padroniza o armazenamento e facilita buscas exatas.

## Indices criados

| Indice | Coluna | Justificativa |
|--------|--------|---------------|
| idx_produtos_categoria | id_categoria | Navegacao por categoria (filtro lateral do site) |
| idx_produtos_vendedor | id_vendedor | Dashboard do vendedor |
| idx_produtos_nome_trgm | nome (GIN trgm) | Busca textual parcial (ILIKE '%termo%') |
| idx_pedidos_cliente | id_cliente | Area "meus pedidos" do cliente |
| idx_pedidos_status | status | Painel administrativo filtra por status |
| idx_enderecos_cliente | id_cliente | Selecao de endereco no checkout |
| idx_itens_pedido_pedido | id_pedido | Juncao itens-pedido em relatorios |
| idx_itens_pedido_produto | id_produto | Relatorio de produtos vendidos |
| idx_pagamentos_status | status | Conciliacao financeira |
| idx_cupons_data | data_inicio, data_fim | Validacao de cupom ativo no checkout |
| idx_avaliacoes_produto | id_produto | Aba de avaliacoes na pagina do produto |
| idx_entregas_rastreio | codigo_rastreio | Rastreamento publico de pedidos |
| idx_estoque_quantidade | quantidade | Alerta de reposicao (quantidade < minimo) |
| idx_pedidos_data_pedido | data_pedido | Relatorios por periodo |

## Lista de consultas (04_consultas.sql)

1. Produtos mais vendidos por quantidade (JOIN + GROUP BY)
2. Faturamento por status de pedido (GROUP BY + SUM)
3. Clientes que mais gastaram (JOIN + HAVING)
4. Produtos com estoque abaixo do minimo (JOIN + WHERE)
5. Ticket medio por cliente com comparacao geral (subconsulta escalar)
6. Vendedores com maior receita (JOIN + GROUP BY + HAVING)
7. Avaliacao media por produto (LEFT JOIN + GROUP BY)
8. Pedidos com detalhes completos (JOIN de 5 tabelas)
9. Clientes que nunca compraram (subconsulta NOT IN)
10. Categoria com maior volume de vendas (subconsulta + JOIN)
11. Produtos com preco acima da media da categoria (subconsulta correlacionada)
12. Ranking de cupons mais utilizados (LEFT JOIN + GROUP BY)

## Transacoes (05_transacoes.sql)

1. **Nova compra**: cria pedido, insere item, da baixa no estoque, registra pagamento, atualiza status do pedido e incrementa uso do cupom. Tudo em uma transacao BEGIN/COMMIT. Usa SELECT FOR UPDATE para lock pessimista no estoque.
2. **Cancelamento de pedido**: seleciona o pedido com FOR UPDATE, verifica se pode ser cancelado, devolve os itens ao estoque, estorna o pagamento, cancela o pedido e decrementa o uso do cupom.
3. **ROLLBACK de demonstracao**: tenta comprar 100 unidades de um produto com apenas 50 em estoque. O bloco DO gera excecao e o ROLLBACK desfaz tudo, garantindo que nenhum dado inconsistente seja persistido.

## Controle de acesso (06_permissoes.sql)

| Usuario | Permissoes | Restricoes |
|---------|------------|------------|
| atendente_sac | SELECT em pedidos, clientes, pagamentos, entregas, produtos. UPDATE status de pedidos e entregas. | Nao ve cupons nem dados de estoque |
| gerente_estoque | CRUD em estoque. INSERT/UPDATE em produtos. | Nao pode DELETE produtos. BYPASSRLS |
| vendedor_loja | SELECT em produtos e pedidos. UPDATE em preco/descricao/ativo de produtos. | Nao ve pagamentos. RLS filtra produtos do seu vendedor |

Revogacoes aplicadas:
- REVOKE DELETE ON produtos FROM gerente_estoque
- REVOKE SELECT ON pagamentos FROM vendedor_loja
- REVOKE SELECT ON cupons FROM atendente_sac

Row Level Security (RLS) ativa em produtos com politica que filtra pelo id_vendedor da sessao.

## Analise EXPLAIN (07_explain.sql)

Foram analisadas 6 consultas:

1. **Busca textual por nome** — o indice GIN trgm converte Seq Scan em Bitmap Index Scan, reduzindo drasticamente o custo em tabelas grandes.
2. **Faturamento por status** — o indice em pedidos.status permite Bitmap Index Scan em vez de Seq Scan.
3. **Produtos por categoria com join** — o indice em id_categoria e a PK de vendedores geram um Nested Loop com Index Scan em ambos os lados.
4. **Pedidos de um cliente** — o indice em id_cliente elimina o full scan; o LEFT JOIN com pagamentos usa a PK de pagamentos.
5. **Estoque abaixo do minimo** — em volumes pequenos o otimizador prefere Seq Scan (mais barato). Com 10k+ registros, o indice passa a ser usado. Esse comportamento e esperado do otimizador do PostgreSQL.
6. **Subconsulta correlacionada** — o otimizador pode reescrever como Hash Semi-Join dependendo do volume de dados.

### Consideracoes do EXPLAIN

O otimizador do PostgreSQL decide entre Seq Scan e Index Scan com base na seletividade e na estimativa de custo. Em tabelas pequenas, o Seq Scan pode ser mais rapido que ler o indice e depois a tabela. Por isso, alguns indices nao aparecem no plano de execucao com poucos dados de teste. Em producao, com dezenas de milhares de registros, os indices passam a ser usados consistentemente.

## Arquivos do projeto

| Arquivo | Conteudo |
|--------|----------|
| 01_ddl.sql | Definicao das 14 tabelas com todas as constraints |
| 02_inserts.sql | Insercao de dados (15+ registros por tabela) |
| 03_indices.sql | 14 indices com justificativa |
| 04_consultas.sql | 12 consultas SQL |
| 05_transacoes.sql | 3 transacoes (2 COMMIT + 1 ROLLBACK) |
| 06_permissoes.sql | 3 usuarios, GRANT/REVOKE e RLS |
| 07_explain.sql | 6 analises com EXPLAIN ANALYZE |
