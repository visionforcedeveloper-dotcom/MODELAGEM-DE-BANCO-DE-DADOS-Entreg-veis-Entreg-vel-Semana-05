-- ============================================================
-- 06_permissoes.sql — Controle de acesso com GRANT / REVOKE
-- Sistema de E-commerce — Grupo 4
-- ============================================================

-- ------------------------------------------------------------
-- Criacao de roles (usuarios)
-- ------------------------------------------------------------

-- Usuario 1: atendente_sac — pode consultar pedidos, clientes e pagamentos
CREATE ROLE atendente_sac LOGIN PASSWORD 'Sac@2026';

-- Usuario 2: gerente_estoque — pode consultar e atualizar estoque e produtos
CREATE ROLE gerente_estoque LOGIN PASSWORD 'Estoque@2026';

-- Usuario 3: vendedor_loja — pode consultar produtos, pedidos e suas proprias vendas
CREATE ROLE vendedor_loja LOGIN PASSWORD 'Vend@2026';

-- ------------------------------------------------------------
-- Concessao de permissoes (GRANT)
-- ------------------------------------------------------------

-- Permissoes para atendente_sac
GRANT CONNECT ON DATABASE ecommerce TO atendente_sac;
GRANT USAGE ON SCHEMA public TO atendente_sac;
GRANT SELECT ON pedidos, clientes, enderecos, pagamentos, entregas TO atendente_sac;
GRANT SELECT ON itens_pedido TO atendente_sac;
-- Permite atualizar status de pedidos e entregas
GRANT UPDATE (status) ON pedidos TO atendente_sac;
GRANT UPDATE (status) ON entregas TO atendente_sac;
-- Permite consultar produtos (para atendimento de duvidas)
GRANT SELECT ON produtos, categorias TO atendente_sac;

-- Permissoes para gerente_estoque
GRANT CONNECT ON DATABASE ecommerce TO gerente_estoque;
GRANT USAGE ON SCHEMA public TO gerente_estoque;
GRANT SELECT, INSERT, UPDATE, DELETE ON estoque TO gerente_estoque;
GRANT SELECT, INSERT, UPDATE ON produtos TO gerente_estoque;
GRANT SELECT ON categorias, vendedores TO gerente_estoque;
-- Permite usar a sequence de produtos e estoque
GRANT USAGE, SELECT ON SEQUENCE produtos_id_produto_seq TO gerente_estoque;
GRANT USAGE, SELECT ON SEQUENCE estoque_id_estoque_seq TO gerente_estoque;

-- Permissoes para vendedor_loja
GRANT CONNECT ON DATABASE ecommerce TO vendedor_loja;
GRANT USAGE ON SCHEMA public TO vendedor_loja;
GRANT SELECT ON produtos TO vendedor_loja;
GRANT SELECT ON pedidos, itens_pedido TO vendedor_loja;
GRANT SELECT ON vendedores TO vendedor_loja;
-- Permite atualizar preco e descricao dos seus produtos
GRANT UPDATE (preco, descricao, ativo) ON produtos TO vendedor_loja;

-- ------------------------------------------------------------
-- Revogacao de permissoes (REVOKE) — demonstracao
-- ------------------------------------------------------------

-- Revoga DELETE de gerente_estoque na tabela produtos (nao deve remover produtos)
REVOKE DELETE ON produtos FROM gerente_estoque;

-- Revoga SELECT de vendedor_loja na tabela pagamentos (nao deve ver dados financeiros)
REVOKE SELECT ON pagamentos FROM vendedor_loja;

-- Revoga SELECT de atendente_sac na tabela cupons (cupons sao gerenciados apenas por admin)
REVOKE SELECT ON cupons FROM atendente_sac;

-- ------------------------------------------------------------
-- Row Level Security (RLS) — vendedor so ve seus proprios produtos
-- ------------------------------------------------------------

ALTER TABLE produtos ENABLE ROW LEVEL SECURITY;

-- Politica: vendedor_loja so pode ver produtos do seu proprio vendedor
-- (Assumindo que o vendedor conhece seu id_vendedor ou usamos uma sessao var)
CREATE POLICY politica_produtos_vendedor
ON produtos
FOR SELECT
TO vendedor_loja
USING (id_vendedor = current_setting('app.id_vendedor')::INTEGER);

-- Permitir que o gerente de estoque veja todos os produtos (bypass RLS)
ALTER TABLE produtos FORCE ROW LEVEL SECURITY;
-- gerente_estoque tem direitos de superuser neste contexto ou pode ser adicionado bypass:
ALTER ROLE gerente_estoque BYPASSRLS;

-- ------------------------------------------------------------
-- Resumo
-- ------------------------------------------------------------
-- atendente_sac:  SELECT em pedidos, clientes, pagamentos, entregas;
--                  UPDATE do status de pedidos e entregas.
--                  Nao ve cupons nem dados de estoque.
-- gerente_estoque: CRUD em estoque, INSERT/UPDATE em produtos.
--                  Nao pode DELETE produtos. Veja todos (BYPASSRLS).
-- vendedor_loja:   SELECT em produtos e pedidos. UPDATE em preco/descricao/ativo.
--                  Nao ve pagamentos. RLS filtra produtos do seu vendedor.
