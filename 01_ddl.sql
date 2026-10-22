-- ============================================================
-- 01_ddl.sql — Definição da Estrutura (Data Definition Language)
-- Sistema de E-commerce — Grupo 4
-- PostgreSQL 14+
-- ============================================================

-- DROP em ordem reversa para reexecução segura
DROP TABLE IF EXISTS entregas CASCADE;
DROP TABLE IF EXISTS avaliacoes CASCADE;
DROP TABLE IF EXISTS pagamentos CASCADE;
DROP TABLE IF EXISTS itens_pedido CASCADE;
DROP TABLE IF EXISTS pedidos CASCADE;
DROP TABLE IF EXISTS enderecos CASCADE;
DROP TABLE IF EXISTS estoque CASCADE;
DROP TABLE IF EXISTS produtos CASCADE;
DROP TABLE IF EXISTS cupons CASCADE;
DROP TABLE IF EXISTS clientes CASCADE;
DROP TABLE IF EXISTS vendedores CASCADE;
DROP TABLE IF EXISTS transportadoras CASCADE;
DROP TABLE IF EXISTS categorias CASCADE;

-- ============================================================
-- 1. CATEGORIAS — Categorias de produtos (auto-referência p/ subcategorias)
-- ============================================================
CREATE TABLE categorias (
    id_categoria      SERIAL PRIMARY KEY,
    nome              VARCHAR(100) NOT NULL,
    descricao         TEXT,
    id_categoria_pai  INTEGER REFERENCES categorias(id_categoria),
    ativo             BOOLEAN NOT NULL DEFAULT TRUE,
    created_at        TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================
-- 2. TRANSPORTADORAS — Empresas de entrega
-- ============================================================
CREATE TABLE transportadoras (
    id_transportadora SERIAL PRIMARY KEY,
    nome              VARCHAR(100) NOT NULL,
    cnpj              CHAR(14) NOT NULL UNIQUE,
    telefone          VARCHAR(20),
    email             VARCHAR(150),
    ativo             BOOLEAN NOT NULL DEFAULT TRUE,
    created_at        TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================
-- 3. VENDEDORES — Lojas/parceiros que vendem na plataforma
-- ============================================================
CREATE TABLE vendedores (
    id_vendedor       SERIAL PRIMARY KEY,
    nome              VARCHAR(150) NOT NULL,
    email             VARCHAR(150) NOT NULL UNIQUE,
    cnpj              CHAR(14) NOT NULL UNIQUE,
    telefone          VARCHAR(20),
    avaliacao_media   NUMERIC(3,2) DEFAULT 0 CHECK (avaliacao_media >= 0 AND avaliacao_media <= 5),
    ativo             BOOLEAN NOT NULL DEFAULT TRUE,
    created_at        TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================
-- 4. PRODUTOS — Catálogo de produtos
-- ============================================================
CREATE TABLE produtos (
    id_produto        SERIAL PRIMARY KEY,
    nome              VARCHAR(200) NOT NULL,
    descricao         TEXT,
    preco             NUMERIC(10,2) NOT NULL CHECK (preco > 0),
    custo             NUMERIC(10,2) CHECK (custo >= 0),
    sku               VARCHAR(50) NOT NULL UNIQUE,
    id_categoria      INTEGER NOT NULL REFERENCES categorias(id_categoria),
    id_vendedor       INTEGER NOT NULL REFERENCES vendedores(id_vendedor),
    peso              NUMERIC(6,3) CHECK (peso >= 0),
    ativo             BOOLEAN NOT NULL DEFAULT TRUE,
    created_at        TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================
-- 5. ESTOQUE — Controle de inventário por produto (1:1)
-- ============================================================
CREATE TABLE estoque (
    id_estoque        SERIAL PRIMARY KEY,
    id_produto        INTEGER NOT NULL UNIQUE REFERENCES produtos(id_produto),
    quantidade        INTEGER NOT NULL DEFAULT 0 CHECK (quantidade >= 0),
    quantidade_minima INTEGER NOT NULL DEFAULT 5 CHECK (quantidade_minima >= 0),
    localizacao       VARCHAR(50),
    updated_at        TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================
-- 6. CLIENTES — Usuários compradores
-- ============================================================
CREATE TABLE clientes (
    id_cliente        SERIAL PRIMARY KEY,
    nome              VARCHAR(150) NOT NULL,
    email             VARCHAR(150) NOT NULL UNIQUE,
    cpf               CHAR(11) NOT NULL UNIQUE,
    telefone          VARCHAR(20),
    data_nascimento    DATE CHECK (data_nascimento < CURRENT_DATE),
    ativo             BOOLEAN NOT NULL DEFAULT TRUE,
    created_at        TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================
-- 7. ENDEREÇOS — Endereços de entrega dos clientes (1:N)
-- ============================================================
CREATE TABLE enderecos (
    id_endereco       SERIAL PRIMARY KEY,
    id_cliente        INTEGER NOT NULL REFERENCES clientes(id_cliente),
    logradouro        VARCHAR(200) NOT NULL,
    numero            VARCHAR(20) NOT NULL,
    complemento       VARCHAR(100),
    bairro            VARCHAR(100) NOT NULL,
    cidade            VARCHAR(100) NOT NULL,
    estado            CHAR(2) NOT NULL CHECK (estado IN (
        'AC','AL','AP','AM','BA','CE','DF','ES','GO','MA','MT','MS','MG',
        'PA','PB','PR','PE','PI','RJ','RN','RS','RO','RR','SC','SP','SE','TO'
    )),
    cep               CHAR(8) NOT NULL,
    principal         BOOLEAN NOT NULL DEFAULT FALSE,
    created_at        TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================
-- 8. CUPONS — Cupons de desconto
-- ============================================================
CREATE TABLE cupons (
    id_cupon          SERIAL PRIMARY KEY,
    codigo            VARCHAR(30) NOT NULL UNIQUE,
    descricao         TEXT,
    tipo_desconto     VARCHAR(15) NOT NULL DEFAULT 'PERCENTUAL' CHECK (
        tipo_desconto IN ('PERCENTUAL', 'FIXO')
    ),
    valor             NUMERIC(10,2) NOT NULL CHECK (valor > 0),
    valor_minimo      NUMERIC(10,2) DEFAULT 0 CHECK (valor_minimo >= 0),
    data_inicio       DATE NOT NULL,
    data_fim          DATE NOT NULL,
    limite_uso        INTEGER DEFAULT 100 CHECK (limite_uso > 0),
    vezes_usado       INTEGER NOT NULL DEFAULT 0,
    ativo             BOOLEAN NOT NULL DEFAULT TRUE,
    CHECK (data_fim >= data_inicio)
);

-- ============================================================
-- 9. PEDIDOS — Cabeçalho de pedidos
-- ============================================================
CREATE TABLE pedidos (
    id_pedido               SERIAL PRIMARY KEY,
    id_cliente              INTEGER NOT NULL REFERENCES clientes(id_cliente),
    id_endereco             INTEGER NOT NULL REFERENCES enderecos(id_endereco),
    id_cupon                INTEGER REFERENCES cupons(id_cupon),
    status                  VARCHAR(20) NOT NULL DEFAULT 'PENDENTE' CHECK (
        status IN ('PENDENTE', 'PAGO', 'SEPARADO', 'ENVIADO', 'ENTREGUE', 'CANCELADO')
    ),
    valor_subtotal          NUMERIC(12,2) NOT NULL DEFAULT 0 CHECK (valor_subtotal >= 0),
    valor_desconto          NUMERIC(12,2) NOT NULL DEFAULT 0 CHECK (valor_desconto >= 0),
    valor_total             NUMERIC(12,2) NOT NULL DEFAULT 0 CHECK (valor_total >= 0),
    data_pedido             TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    data_entrega_estimada   DATE
);

-- ============================================================
-- 10. ITENS_PEDIDO — Produtos dentro de cada pedido (N:M)
-- ============================================================
CREATE TABLE itens_pedido (
    id_item           SERIAL PRIMARY KEY,
    id_pedido         INTEGER NOT NULL REFERENCES pedidos(id_pedido) ON DELETE CASCADE,
    id_produto        INTEGER NOT NULL REFERENCES produtos(id_produto),
    quantidade        INTEGER NOT NULL CHECK (quantidade > 0),
    preco_unitario    NUMERIC(10,2) NOT NULL CHECK (preco_unitario > 0),
    desconto          NUMERIC(10,2) DEFAULT 0 CHECK (desconto >= 0),
    CHECK (desconto <= preco_unitario * quantidade)
);

-- ============================================================
-- 11. PAGAMENTOS — Pagamentos dos pedidos
-- ============================================================
CREATE TABLE pagamentos (
    id_pagamento      SERIAL PRIMARY KEY,
    id_pedido         INTEGER NOT NULL REFERENCES pedidos(id_pedido),
    metodo            VARCHAR(20) NOT NULL CHECK (
        metodo IN ('CARTAO_CREDITO', 'CARTAO_DEBITO', 'PIX', 'BOLETO', 'PAYPAL')
    ),
    status            VARCHAR(20) NOT NULL DEFAULT 'PENDENTE' CHECK (
        status IN ('PENDENTE', 'APROVADO', 'RECUSADO', 'ESTORNADO', 'CANCELADO')
    ),
    valor             NUMERIC(12,2) NOT NULL CHECK (valor > 0),
    parcelas          INTEGER DEFAULT 1 CHECK (parcelas >= 1 AND parcelas <= 12),
    codigo_transacao  VARCHAR(100) UNIQUE,
    data_pagamento    TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================
-- 12. AVALIAÇÕES — Avaliações de produtos pelos clientes
-- ============================================================
CREATE TABLE avaliacoes (
    id_avaliacao      SERIAL PRIMARY KEY,
    id_produto        INTEGER NOT NULL REFERENCES produtos(id_produto),
    id_cliente        INTEGER NOT NULL REFERENCES clientes(id_cliente),
    nota              INTEGER NOT NULL CHECK (nota >= 1 AND nota <= 5),
    comentario        TEXT,
    data_avaliacao    TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (id_produto, id_cliente)
);

-- ============================================================
-- 13. ENTREGAS — Rastreamento de pedidos
-- ============================================================
CREATE TABLE entregas (
    id_entrega        SERIAL PRIMARY KEY,
    id_pedido         INTEGER NOT NULL REFERENCES pedidos(id_pedido),
    id_transportadora INTEGER NOT NULL REFERENCES transportadoras(id_transportadora),
    codigo_rastreio   VARCHAR(50) NOT NULL UNIQUE,
    status            VARCHAR(20) NOT NULL DEFAULT 'EM_SEPARACAO' CHECK (
        status IN ('EM_SEPARACAO', 'ENVIADO', 'EM_TRANSITO', 'ENTREGUE', 'DEVOLVIDO')
    ),
    data_envio        TIMESTAMP,
    data_entrega      TIMESTAMP,
    created_at        TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);
