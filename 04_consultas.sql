-- ============================================================
-- 04_consultas.sql — Consultas SQL (JOIN, GROUP BY, subconsultas)
-- Sistema de E-commerce — Grupo 4
-- 12 consultas
-- ============================================================

-- ============================================================
-- Consulta 1: Produtos mais vendidos por quantidade (JOIN + GROUP BY + ORDER BY)
-- ============================================================
SELECT
    p.nome,
    p.sku,
    SUM(ip.quantidade) AS total_vendido
FROM produtos p
JOIN itens_pedido ip ON ip.id_produto = p.id_produto
GROUP BY p.id_produto, p.nome, p.sku
ORDER BY total_vendido DESC;

-- ============================================================
-- Consulta 2: Faturamento por status de pedido (GROUP BY + SUM)
-- ============================================================
SELECT
    status,
    COUNT(*) AS qtd_pedidos,
    SUM(valor_total) AS faturamento
FROM pedidos
GROUP BY status
ORDER BY faturamento DESC;

-- ============================================================
-- Consulta 3: Clientes que mais gastaram (JOIN 3 tabelas + subconsulta)
-- ============================================================
SELECT
    c.nome,
    c.email,
    SUM(p.valor_total) AS total_gasto
FROM clientes c
JOIN pedidos p ON p.id_cliente = c.id_cliente
WHERE p.status NOT IN ('CANCELADO')
GROUP BY c.id_cliente, c.nome, c.email
HAVING SUM(p.valor_total) > 1000
ORDER BY total_gasto DESC;

-- ============================================================
-- Consulta 4: Produtos com estoque abaixo do minimo (JOIN + WHERE)
-- ============================================================
SELECT
    p.nome,
    p.sku,
    e.quantidade,
    e.quantidade_minima,
    v.nome AS vendedor
FROM produtos p
JOIN estoque e ON e.id_produto = p.id_produto
JOIN vendedores v ON v.id_vendedor = p.id_vendedor
WHERE e.quantidade < e.quantidade_minima
ORDER BY e.quantidade ASC;

-- ============================================================
-- Consulta 5: Ticket medio por cliente (subconsulta escalar)
-- ============================================================
SELECT
    c.nome,
    COUNT(p.id_pedido) AS pedidos,
    ROUND(AVG(p.valor_total), 2) AS ticket_medio,
    (SELECT ROUND(AVG(p2.valor_total), 2)
     FROM pedidos p2
     WHERE p2.status NOT IN ('CANCELADO')) AS ticket_geral
FROM clientes c
JOIN pedidos p ON p.id_cliente = c.id_cliente
WHERE p.status NOT IN ('CANCELADO')
GROUP BY c.id_cliente, c.nome
ORDER BY ticket_medio DESC;

-- ============================================================
-- Consulta 6: Vendedores com suas vendas totais (JOIN + GROUP BY + HAVING)
-- ============================================================
SELECT
    v.nome AS vendedor,
    COUNT(ip.id_item) AS itens_vendidos,
    SUM(ip.quantidade * ip.preco_unitario) AS receita
FROM vendedores v
JOIN produtos p ON p.id_vendedor = v.id_vendedor
JOIN itens_pedido ip ON ip.id_produto = p.id_produto
GROUP BY v.id_vendedor, v.nome
HAVING SUM(ip.quantidade * ip.preco_unitario) > 5000
ORDER BY receita DESC;

-- ============================================================
-- Consulta 7: Avaliacao media por produto (LEFT JOIN + GROUP BY)
-- ============================================================
SELECT
    p.nome,
    p.sku,
    ROUND(AVG(a.nota), 2) AS media_avaliacao,
    COUNT(a.id_avaliacao) AS qtd_avaliacoes
FROM produtos p
LEFT JOIN avaliacoes a ON a.id_produto = p.id_produto
GROUP BY p.id_produto, p.nome, p.sku
ORDER BY media_avaliacao DESC NULLS LAST;

-- ============================================================
-- Consulta 8: Pedidos com detalhes completos (JOIN de 5 tabelas)
-- ============================================================
SELECT
    p.id_pedido,
    c.nome AS cliente,
    p.status,
    p.valor_total,
    pg.metodo AS forma_pagamento,
    t.nome AS transportadora,
    e.codigo_rastreio
FROM pedidos p
JOIN clientes c ON c.id_cliente = p.id_cliente
LEFT JOIN pagamentos pg ON pg.id_pedido = p.id_pedido
LEFT JOIN entregas e ON e.id_pedido = p.id_pedido
LEFT JOIN transportadoras t ON t.id_transportadora = e.id_transportadora
ORDER BY p.data_pedido DESC;

-- ============================================================
-- Consulta 9: Clientes que nunca compraram (subconsulta NOT IN)
-- ============================================================
SELECT
    c.nome,
    c.email
FROM clientes c
WHERE c.id_cliente NOT IN (
    SELECT DISTINCT p.id_cliente FROM pedidos p WHERE p.status NOT IN ('CANCELADO')
)
ORDER BY c.nome;

-- ============================================================
-- Consulta 10: Categoria com maior volume de vendas (subconsulta + JOIN)
-- ============================================================
SELECT
    cat.nome AS categoria,
    SUM(ip.quantidade) AS total_itens,
    SUM(ip.quantidade * ip.preco_unitario) AS receita_total
FROM itens_pedido ip
JOIN produtos p ON p.id_produto = ip.id_produto
JOIN categorias cat ON cat.id_categoria = p.id_categoria
GROUP BY cat.id_categoria, cat.nome
ORDER BY receita_total DESC;

-- ============================================================
-- Consulta 11: Produtos com preco acima da media da categoria (subconsulta correlacionada)
-- ============================================================
SELECT
    p.nome,
    p.preco,
    c.nome AS categoria,
    (SELECT ROUND(AVG(p2.preco), 2)
     FROM produtos p2 WHERE p2.id_categoria = c.id_categoria) AS media_categoria
FROM produtos p
JOIN categorias c ON c.id_categoria = p.id_categoria
WHERE p.preco > (
    SELECT AVG(p3.preco)
    FROM produtos p3
    WHERE p3.id_categoria = p.id_categoria
)
ORDER BY p.preco DESC;

-- ============================================================
-- Consulta 12: Ranking de cupons mais utilizados e desconto concedido (JOIN + GROUP BY)
-- ============================================================
SELECT
    cp.codigo,
    cp.descricao,
    cp.tipo_desconto,
    cp.valor,
    COUNT(p.id_pedido) AS vezes_utilizado,
    SUM(p.valor_desconto) AS desconto_total_concedido
FROM cupons cp
LEFT JOIN pedidos p ON p.id_cupon = cp.id_cupon
GROUP BY cp.id_cupon, cp.codigo, cp.descricao, cp.tipo_desconto, cp.valor
ORDER BY vezes_utilizado DESC;
