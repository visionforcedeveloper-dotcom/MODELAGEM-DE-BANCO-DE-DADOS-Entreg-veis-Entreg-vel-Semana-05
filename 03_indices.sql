-- ============================================================
-- 03_indices.sql — Criação de índices com justificativa
-- Sistema de E-commerce — Grupo 4
-- ============================================================

-- Extensao necessaria para o indice de busca textual trigram
CREATE EXTENSION IF NOT EXISTS pg_trgm;

-- ------------------------------------------------------------
-- Índices em colunas de busca frequente (WHERE, JOIN, ORDER BY)
-- ------------------------------------------------------------

-- 1. Busca de produtos por categoria (filtro lateral do e-commerce)
CREATE INDEX idx_produtos_categoria ON produtos(id_categoria);

-- 2. Busca de produtos por vendedor (dashboard do vendedor)
CREATE INDEX idx_produtos_vendedor ON produtos(id_vendedor);

-- 3. Busca de produtos por nome com ILIKE (barra de pesquisa do site)
--    Requer a extensao pg_trgm (criada acima)
CREATE INDEX idx_produtos_nome_trgm ON produtos USING gin (nome gin_trgm_ops);

-- 4. Listagem de pedidos por cliente (area "meus pedidos")
CREATE INDEX idx_pedidos_cliente ON pedidos(id_cliente);

-- 5. Filtro de pedidos por status (painel administrativo)
CREATE INDEX idx_pedidos_status ON pedidos(status);

-- 6. Busca de enderecos por cliente (selecao no checkout)
CREATE INDEX idx_enderecos_cliente ON enderecos(id_cliente);

-- 7. Juncao itens_pedido <-> pedidos (relatorio de vendas)
CREATE INDEX idx_itens_pedido_pedido ON itens_pedido(id_pedido);

-- 8. Juncao itens_pedido <-> produtos (relatorio de produtos vendidos)
CREATE INDEX idx_itens_pedido_produto ON itens_pedido(id_produto);

-- 9. Busca de pagamentos por status (conciliacao financeira)
CREATE INDEX idx_pagamentos_status ON pagamentos(status);

-- 10. Filtro de cupons ativos por data (validacao no checkout)
CREATE INDEX idx_cupons_data ON cupons(data_inicio, data_fim);

-- 11. Busca de avaliacoes por produto (aba de avaliaces na pagina do produto)
CREATE INDEX idx_avaliacoes_produto ON avaliacoes(id_produto);

-- 12. Rastreamento por codigo (pagina "rastrear pedido")
CREATE INDEX idx_entregas_rastreio ON entregas(codigo_rastreio);

-- 13. Filtro de estoque com quantidade abaixo do minimo (alerta de reposicao)
CREATE INDEX idx_estoque_quantidade ON estoque(quantidade);

-- 14. Filtro de pedidos por data (relatorios por periodo)
CREATE INDEX idx_pedidos_data_pedido ON pedidos(data_pedido);

-- ------------------------------------------------------------
-- Justificativas resumidas
-- ------------------------------------------------------------
-- idx_produtos_categoria:   A maioria das navegacoes do usuario comeca por categoria.
--                           Sem indice, cada acesso faz um full scan em "produtos".
-- idx_produtos_nome_trgm:   A busca textual (ILIKE '%termo%') e muito custosa sem
--                           indice trigram. O GIN trgm acelera buscas parciais.
-- idx_pedidos_cliente:      O cliente acessa "meus pedidos" frequentemente. Sem
--                           indice, e um full scan em uma tabela que so cresce.
-- idx_pedidos_status:       O painel administrativo filtra por status a cada minuto.
--                           Reduz o custo de ORDER BY + WHERE em relatorios.
-- idx_itens_pedido_*:       As juncoes entre itens_pedido e pedidos/produtos sao
--                           usadas em praticamente todos os relatorios de vendas.
-- idx_estoque_quantidade:   O sistema de reposicao roda periodicamente verificando
--                           quantidade < quantidade_minima. O indice acelera esse filtro.
-- idx_entregas_rastreio:    O rastreamento publico consulta por codigo_rastreio.
--                           Sem indice, cada consulta varre toda a tabela de entregas.
-- Os demais seguem a mesma logica: colunas usadas em WHERE e JOIN de alta frequencia.
