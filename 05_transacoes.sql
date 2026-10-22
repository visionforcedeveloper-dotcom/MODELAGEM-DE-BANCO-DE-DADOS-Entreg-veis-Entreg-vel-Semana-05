-- ============================================================
-- 05_transacoes.sql — Transacoes com BEGIN / COMMIT / ROLLBACK
-- Sistema de E-commerce — Grupo 4
-- ============================================================

-- ============================================================
-- Transacao 1: Nova compra (pedido + itens + baixa de estoque + pagamento)
-- ============================================================
-- Cenario: o cliente 2 compra 1 notebook Acer Aspire 5 (produto 2)
--          pagando com cartao de credito em 3x, usando cupom BEMVINDO10.

BEGIN;

-- 1. Verifica estoque disponivel (lock pessimista com FOR UPDATE)
DO $$
DECLARE
    qtde_disponivel INTEGER;
BEGIN
    SELECT quantidade INTO qtde_disponivel FROM estoque WHERE id_produto = 2 FOR UPDATE;
    IF qtde_disponivel < 1 THEN
        RAISE EXCEPTION 'Estoque insuficiente para o produto 2';
    END IF;
END $$;

-- 2. Cria o pedido
INSERT INTO pedidos (id_cliente, id_endereco, id_cupon, status, valor_subtotal, valor_desconto, valor_total, data_pedido, data_entrega_estimada)
VALUES (2, 3, 1, 'PENDENTE', 3200.00, 320.00, 2880.00, CURRENT_TIMESTAMP, CURRENT_DATE + 7);

-- 3. Insere o item do pedido
INSERT INTO itens_pedido (id_pedido, id_produto, quantidade, preco_unitario, desconto)
VALUES (currval('pedidos_id_pedido_seq'), 2, 1, 3200.00, 320.00);

-- 4. Da baixa no estoque
UPDATE estoque SET quantidade = quantidade - 1, updated_at = CURRENT_TIMESTAMP WHERE id_produto = 2;

-- 5. Registra o pagamento
INSERT INTO pagamentos (id_pedido, metodo, status, valor, parcelas, codigo_transacao, data_pagamento)
VALUES (currval('pedidos_id_pedido_seq'), 'CARTAO_CREDITO', 'APROVADO', 2880.00, 3, 'TXN-NEW-001', CURRENT_TIMESTAMP);

-- 6. Atualiza o status do pedido para PAGO
UPDATE pedidos SET status = 'PAGO' WHERE id_pedido = currval('pedidos_id_pedido_seq');

-- 7. Incrementa o uso do cupom
UPDATE cupons SET vezes_usado = vezes_usado + 1 WHERE id_cupon = 1;

COMMIT;

-- ============================================================
-- Transacao 2: Cancelamento de pedido (devolucao de estoque + estorno de pagamento)
-- ============================================================
-- Cenario: o pedido 13 e cancelado. Devolve o produto ao estoque e estorna o pagamento.

BEGIN;

-- 1. Bloqueia o pedido para concorrencia
SELECT * FROM pedidos WHERE id_pedido = 13 FOR UPDATE;

-- 2. Verifica se o pedido pode ser cancelado
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pedidos WHERE id_pedido = 13 AND status NOT IN ('ENTREGUE', 'CANCELADO')) THEN
        RAISE EXCEPTION 'Pedido 13 nao pode ser cancelado (status atual: %)',
            (SELECT status FROM pedidos WHERE id_pedido = 13);
    END IF;
END $$;

-- 3. Devolve os itens ao estoque
UPDATE estoque e
SET quantidade = e.quantidade + ip.quantidade,
    updated_at = CURRENT_TIMESTAMP
FROM itens_pedido ip
WHERE ip.id_produto = e.id_produto AND ip.id_pedido = 13;

-- 4. Estorna o pagamento
UPDATE pagamentos SET status = 'ESTORNADO' WHERE id_pedido = 13;

-- 5. Cancela o pedido
UPDATE pedidos SET status = 'CANCELADO' WHERE id_pedido = 13;

-- 6. Se houver cupom, decrementa o uso
UPDATE cupons SET vezes_usado = GREATEST(vezes_usado - 1, 0)
WHERE id_cupon = (SELECT id_cupon FROM pedidos WHERE id_pedido = 13);

COMMIT;

-- ============================================================
-- Transacao 3 (demonstracao de ROLLBACK): compra com estoque insuficiente
-- ============================================================
-- Cenario: simulacao de tentativa de compra com estoque insuficiente.
-- Tudo deve ser desfeito se o estoque nao for suficiente.

BEGIN;

-- Tenta comprar 100 unidades do produto 1 (estoque atual: 50)
DO $$
DECLARE
    qtd_estoque INTEGER;
BEGIN
    SELECT quantidade INTO qtd_estoque FROM estoque WHERE id_produto = 1 FOR UPDATE;
    IF qtd_estoque < 100 THEN
        RAISE EXCEPTION 'Estoque insuficiente: tem %, tentou comprar 100', qtd_estoque;
    END IF;
END $$;

-- As instrucoes abaixo nao serao executadas porque o DO acima gera excecao
INSERT INTO pedidos (id_cliente, id_endereco, status, valor_subtotal, valor_total)
VALUES (3, 4, 'PENDENTE', 350000.00, 350000.00);

INSERT INTO itens_pedido (id_pedido, id_produto, quantidade, preco_unitario)
VALUES (currval('pedidos_id_pedido_seq'), 1, 100, 3500.00);

-- ROLLBACK explicito: nada foi persistido
ROLLBACK;
