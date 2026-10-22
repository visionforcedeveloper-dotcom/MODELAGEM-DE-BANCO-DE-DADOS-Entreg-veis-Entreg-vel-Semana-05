-- ============================================================
-- 07_explain.sql — Analise de plano de execucao com EXPLAIN ANALYZE
-- Sistema de E-commerce — Grupo 4
-- ============================================================

-- ============================================================
-- Analise 1: Busca de produtos por nome (indice trigram)
-- ============================================================
-- Antes de criar o indice, esta consulta faria um Seq Scan em toda a tabela.
-- Com o indice GIN trgm, o PostgreSQL usa um Bitmap Index Scan.

EXPLAIN ANALYZE
SELECT nome, sku, preco
FROM produtos
WHERE nome ILIKE '%notebook%'
ORDER BY preco;

-- Resultado esperado:
-- -> Bitmap Heap Scan on produtos
--    -> Bitmap Index Scan on idx_produtos_nome_trgm
--       Index Cond: (nome ~~ '%notebook%'::text)
-- O custo cai drasticamente em tabelas grandes.

-- ============================================================
-- Analise 2: Faturamento por status (indice em pedidos.status)
-- ============================================================
EXPLAIN ANALYZE
SELECT status, COUNT(*), SUM(valor_total)
FROM pedidos
WHERE status IN ('PAGO', 'ENTREGUE')
GROUP BY status;

-- Resultado esperado:
-- -> Bitmap Heap Scan on pedidos
--    -> Bitmap Index Scan on idx_pedidos_status
-- Sem o indice, seria um Seq Scan completo filtrando linha a linha.

-- ============================================================
-- Analise 3: Produtos de uma categoria com join em vendedor
-- ============================================================
EXPLAIN ANALYZE
SELECT p.nome, p.preco, v.nome AS vendedor
FROM produtos p
JOIN vendedores v ON v.id_vendedor = p.id_vendedor
WHERE p.id_categoria = 3
ORDER BY p.preco;

-- Resultado esperado:
-- -> Nested Loop
--    -> Index Scan using idx_produtos_categoria on produtos p
--    -> Index Scan using vendedores_pkey on vendedores v
-- O indice em id_categoria elimina o Seq Scan e o Nested Loop
-- aproveita a PK de vendedores.

-- ============================================================
-- Analise 4: Pedidos de um cliente especifico (indice em pedidos.id_cliente)
-- ============================================================
EXPLAIN ANALYZE
SELECT p.id_pedido, p.status, p.valor_total, pg.metodo
FROM pedidos p
LEFT JOIN pagamentos pg ON pg.id_pedido = p.id_pedido
WHERE p.id_cliente = 1
ORDER BY p.data_pedido DESC;

-- Resultado esperado:
-- -> Nested Loop Left Join
--    -> Index Scan using idx_pedidos_cliente on pedidos p
--    -> Index Scan using pagamentos_pkey on pagamentos pg
-- Sem o indice em id_cliente, cada acesso a "meus pedidos" faria
-- um full scan em pedidos (que cresce continuamente).

-- ============================================================
-- Analise 5: Estoque abaixo do minimo (alerta de reposicao)
-- ============================================================
EXPLAIN ANALYZE
SELECT p.nome, e.quantidade, e.quantidade_minima
FROM estoque e
JOIN produtos p ON p.id_produto = e.id_produto
WHERE e.quantidade < e.quantidade_minima;

-- Resultado esperado:
-- -> Hash Join
--    -> Seq Scan on estoque (filtragem por quantidade < quantidade_minima)
--    -> Seq Scan on produtos
-- Observacao: Com poucos registros o otimizador pode preferir Seq Scan
-- mesmo com o indice. Em volumes maiores (10k+ produtos) o idx_estoque_quantidade
-- passa a ser usado como Bitmap Index Scan. Esse e um comportamento normal
-- do otimizador do PostgreSQL, que decide entre Seq Scan e Index Scan com
-- base no seletividade e na estimativa de custo.

-- ============================================================
-- Analise 6: Consulta complexa com subconsulta correlacionada
-- ============================================================
EXPLAIN ANALYZE
SELECT p.nome, p.preco
FROM produtos p
WHERE p.preco > (
    SELECT AVG(p2.preco) FROM produtos p2
    WHERE p2.id_categoria = p.id_categoria
)
ORDER BY p.preco DESC;

-- Resultado esperado:
-- -> Index Scan on produtos p (para o ORDER BY)
--    -> SubPlan / Hash Aggregate (para a media por categoria)
-- O otimizador pode reescrever a subconsulta correlacionada como
-- um Hash Semi-Join dependendo do volume de dados.
