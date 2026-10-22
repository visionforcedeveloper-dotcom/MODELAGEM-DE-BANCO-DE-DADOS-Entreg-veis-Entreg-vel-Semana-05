-- ============================================================
-- 02_inserts.sql — Inserção de dados (mínimo 15 registros por tabela)
-- Sistema de E-commerce — Grupo 4
-- ============================================================

-- ------------------------------------------------------------
-- CATEGORIAS (18 registros)
-- ------------------------------------------------------------
INSERT INTO categorias (nome, descricao, id_categoria_pai) VALUES
('Eletronicos', 'Produtos eletronicos em geral', NULL),
('Computadores', 'Desktops, notebooks e acessorios', 1),
('Notebooks', 'Laptops de todas as marcas', 2),
('Acessorios', 'Perifericos e acessorios para PC', 2),
('Monitores', 'Telas e monitores', 2),
('Smartphones', 'Telefones celulares', 1),
('Tablets', 'Tablets e leitores', 1),
('Eletrodomesticos', 'Produtos para casa', NULL),
('Geladeiras', 'Refrigeradores', 8),
('Lavadoras', 'Maquinas de lavar', 8),
('Moveis', 'Moveis para casa e escritorio', NULL),
('Sala', 'Moveis de sala', 11),
('Quarto', 'Moveis de quarto', 11),
('Escritorio', 'Moveis de escritorio', 11),
('Games', 'Consoles e jogos', NULL),
('Consoles', 'Videogames', 15),
('Jogos', 'Jogos digitais e fisicos', 15),
('Acessorios Gamer', 'Perifericos para jogos', 15);

-- ------------------------------------------------------------
-- TRANSPORTADORAS (15 registros)
-- ------------------------------------------------------------
INSERT INTO transportadoras (nome, cnpj, telefone, email) VALUES
('Correios', '34028316000103', '08007257257', 'sac@correios.com.br'),
('Transportadora Nacional', '12345678000101', '1133334444', 'contato@transnacional.com.br'),
('LogExpress', '98765432000122', '1144445555', 'sac@logexpress.com.br'),
('Rapidao Cargas', '55555555000166', '1155556666', 'operacao@rapidaocargas.com.br'),
('SuperFrete', '11122233000144', '1166667777', 'suporte@superfrete.com.br'),
('Expresso Brasil', '22233344000155', '1177778888', 'logistica@expressobrasil.com.br'),
('Cargo Log', '33344455000177', '1188889999', 'contato@cargolog.com.br'),
('TransLogistica', '44455566000188', '1199900000', 'sac@translogistica.com.br'),
('Frete Facil', '55566677000199', '1122112233', 'ajuda@fretfacil.com.br'),
('FastCargo', '66677788000110', '1133224455', 'operacao@fastcargo.com.br'),
('BrasilEntrega', '77788899000121', '1144335566', 'contato@brasilentrega.com.br'),
('NorteLog', '88899900001132', '1155446677', 'logistica@nortelog.com.br'),
('SulExpress', '99900011001243', '1166557788', 'sac@sulexpress.com.br'),
('Leste Cargo', '00011122001254', '1177668899', 'suporte@lestecargo.com.br'),
('Oeste Log', '11122233001365', '1188779900', 'operacao@oestelog.com.br');

-- ------------------------------------------------------------
-- VENDEDORES (15 registros)
-- ------------------------------------------------------------
INSERT INTO vendedores (nome, email, cnpj, telefone, avaliacao_media) VALUES
('TechStore LTDA', 'contato@techstore.com.br', '11222333000101', '1133334444', 4.50),
('MegaEletronics', 'vendas@megaeletronics.com.br', '22333444000102', '1144445555', 4.20),
('CasaMoveis', 'sac@casamoveis.com.br', '33444555000103', '1155556666', 3.80),
('GameWorld', 'loja@gameworld.com.br', '44555666000104', '1166667777', 4.70),
('SuperEletro', 'contato@supereletro.com.br', '55666777000105', '1177778888', 4.10),
('NotebookCenter', 'vendas@notebookcenter.com.br', '66777888000106', '1188889999', 4.60),
('PhoneShop', 'sac@phoneshop.com.br', '77888999000107', '1199900000', 4.30),
('TabletsBR', 'contato@tabletsbr.com.br', '88990011000108', '1122112233', 4.00),
('EletroCasa', 'sac@eletrocasa.com.br', '99001122000109', '1133224455', 3.90),
('MoveisPrime', 'vendas@moveisprime.com.br', '00112233000110', '1144335566', 4.40),
('AcessoriosNet', 'loja@acessoriosnet.com.br', '11223344000111', '1155446677', 4.15),
('ConsoleKing', 'sac@consoleking.com.br', '22334455000112', '1166557788', 4.80),
('GamerPro', 'vendas@gamerpro.com.br', '33445566000113', '1177668899', 4.55),
('TudoCasa', 'contato@tudocasa.com.br', '44556677000114', '1188779900', 3.75),
('DigitalStore', 'sac@digitalstore.com.br', '55667788000115', '1199880011', 4.35);

-- ------------------------------------------------------------
-- PRODUTOS (18 registros)
-- ------------------------------------------------------------
INSERT INTO produtos (nome, descricao, preco, custo, sku, id_categoria, id_vendedor, peso) VALUES
('Notebook Dell Inspiron 15', 'Notebook 15.6 Intel Core i5 8GB 256GB SSD', 3500.00, 2800.00, 'NB-DELL-INS-15', 3, 6, 2.100),
('Notebook Acer Aspire 5', 'Notebook 15.6 AMD Ryzen 5 8GB 512GB SSD', 3200.00, 2500.00, 'NB-ACER-ASP-5', 3, 1, 1.900),
('Monitor LG 24 Full HD', 'Monitor 24 polegadas 1920x1080 75Hz', 890.00, 650.00, 'MN-LG-24-FHD', 4, 1, 4.200),
('Monitor Samsung 27 QHD', 'Monitor 27 polegadas 2560x1440 144Hz', 1450.00, 1100.00, 'MN-SAM-27-QHD', 4, 2, 5.500),
('Mouse Logitech G502', 'Mouse gamer 12000 DPI 11 botoes', 299.00, 180.00, 'MS-LOG-G502', 4, 11, 0.150),
('Teclado Mecanico Redragon', 'Teclado mecanico RGB Switch Blue', 220.00, 130.00, 'KB-RED-MEC', 4, 11, 0.800),
('iPhone 14 128GB', 'Apple iPhone 14 128GB 6.1 polegadas', 5200.00, 4400.00, 'PH-APPLE-14-128', 6, 7, 0.172),
('Samsung Galaxy S23', 'Samsung Galaxy S23 5G 128GB', 4200.00, 3500.00, 'PH-SAM-S23-128', 6, 7, 0.168),
('iPad 10 Geracao', 'Apple iPad 10 64GB Wi-Fi', 2800.00, 2300.00, 'TB-APPLE-10-64', 7, 8, 0.460),
('Galaxy Tab S9', 'Samsung Galaxy Tab S9 128GB', 3800.00, 3100.00, 'TB-SAM-S9-128', 7, 8, 0.498),
('PlayStation 5', 'Console Sony PlayStation 5 825GB', 3800.00, 3000.00, 'CN-SONY-PS5', 16, 12, 4.500),
('Xbox Series X', 'Console Microsoft Xbox Series X 1TB', 4200.00, 3300.00, 'CN-MS-XBOX-X', 16, 13, 4.450),
('God of War Ragnarok PS5', 'Jogo God of War Ragnarok PS5', 250.00, 150.00, 'JG-GOW-RAG-PS5', 17, 12, 0.100),
('Forza Horizon 5 Xbox', 'Jogo Forza Horizon 5 Xbox Series', 250.00, 140.00, 'JG-FORZA-H5-XB', 17, 13, 0.100),
('Geladeira Brastemp Frost Free', 'Geladeira 375L Inverter Frost Free', 2400.00, 1900.00, 'GE-BRA-FF-375', 9, 9, 55.000),
('Lavadora Electrolux 12kg', 'Maquina de lavar 12kg automatica', 1800.00, 1400.00, 'LV-ELECT-12', 10, 9, 45.000),
('Sofa 3 Lugares Retratil', 'Sofa retratil 3 lugares tecido', 1500.00, 1000.00, 'MV-SOF-3-RT', 12, 10, 38.000),
('Mesa de Escritorio Madeira', 'Mesa de escritorio em madeira 1.20m', 450.00, 300.00, 'MV-MES-ESC-120', 14, 10, 15.000);

-- ------------------------------------------------------------
-- ESTOQUE (18 registros — 1:1 com produtos)
-- ------------------------------------------------------------
INSERT INTO estoque (id_produto, quantidade, quantidade_minima, localizacao) VALUES
(1, 50, 10, 'A-01-01'),
(2, 35, 10, 'A-01-02'),
(3, 80, 15, 'A-02-01'),
(4, 25, 10, 'A-02-02'),
(5, 200, 30, 'B-01-01'),
(6, 150, 25, 'B-01-02'),
(7, 40, 15, 'C-01-01'),
(8, 30, 15, 'C-01-02'),
(9, 20, 10, 'C-02-01'),
(10, 15, 8, 'C-02-02'),
(11, 18, 5, 'D-01-01'),
(12, 12, 5, 'D-01-02'),
(13, 100, 20, 'D-02-01'),
(14, 90, 20, 'D-02-02'),
(15, 10, 3, 'E-01-01'),
(16, 8, 3, 'E-01-02'),
(17, 22, 5, 'F-01-01'),
(18, 40, 10, 'F-01-02');

-- ------------------------------------------------------------
-- CLIENTES (15 registros)
-- ------------------------------------------------------------
INSERT INTO clientes (nome, email, cpf, telefone, data_nascimento) VALUES
('Joao Silva', 'joao.silva@email.com', '12345678901', '11987654321', '1990-05-15'),
('Maria Santos', 'maria.santos@email.com', '23456789012', '11987654322', '1985-08-22'),
('Pedro Oliveira', 'pedro.oliveira@email.com', '34567890123', '11987654323', '1992-03-10'),
('Ana Costa', 'ana.costa@email.com', '45678901234', '11987654324', '1988-12-05'),
('Carlos Souza', 'carlos.souza@email.com', '56789012345', '11987654325', '1995-07-18'),
('Fernanda Lima', 'fernanda.lima@email.com', '67890123456', '11987654326', '1993-01-30'),
('Roberto Alves', 'roberto.alves@email.com', '78901234567', '11987654327', '1980-09-12'),
('Juliana Ferreira', 'juliana.ferreira@email.com', '89012345678', '11987654328', '1998-04-25'),
('Marcos Pereira', 'marcos.pereira@email.com', '90123456789', '11987654329', '1987-11-03'),
('Patricia Gomes', 'patricia.gomes@email.com', '01234567890', '11987654330', '1991-06-14'),
('Rafael Martins', 'rafael.martins@email.com', '11122233344', '11987654331', '1994-02-20'),
('Camila Rocha', 'camila.rocha@email.com', '22233344455', '11987654332', '1996-10-08'),
('Bruno Carvalho', 'bruno.carvalho@email.com', '33344455566', '11987654333', '1982-05-01'),
('Daniela Ribeiro', 'daniela.ribeiro@email.com', '44455566677', '11987654334', '1999-08-16'),
('Eduardo Fernandes', 'eduardo.fernandes@email.com', '55566677788', '11987654335', '1989-03-27');

-- ------------------------------------------------------------
-- ENDERECOS (15 registros)
-- ------------------------------------------------------------
INSERT INTO enderecos (id_cliente, logradouro, numero, complemento, bairro, cidade, estado, cep, principal) VALUES
(1, 'Rua das Flores', '123', 'Apto 101', 'Centro', 'Sao Paulo', 'SP', '01000000', TRUE),
(1, 'Av. Paulista', '1500', 'Casa', 'Bela Vista', 'Sao Paulo', 'SP', '01310000', FALSE),
(2, 'Rua dos Pinheiros', '456', 'Apto 302', 'Pinheiros', 'Sao Paulo', 'SP', '05422000', TRUE),
(3, 'Rua Augusta', '789', 'Bloco B', 'Consolacao', 'Sao Paulo', 'SP', '01305000', TRUE),
(4, 'Av. Brigadeiro', '222', 'Apto 505', 'Itaim Bibi', 'Sao Paulo', 'SP', '04544050', TRUE),
(5, 'Rua Oscar Freire', '333', 'Casa 2', 'Jardins', 'Sao Paulo', 'SP', '01426000', TRUE),
(6, 'Av. Reboucas', '444', 'Apto 1201', 'Pinheiros', 'Sao Paulo', 'SP', '05402000', TRUE),
(7, 'Rua Teodoro Sampaio', '555', 'Sala 3', 'Pinheiros', 'Sao Paulo', 'SP', '05406000', TRUE),
(8, 'Rua Haddock Lobo', '666', 'Apto 808', 'Cerqueira Cesar', 'Sao Paulo', 'SP', '01414000', TRUE),
(9, 'Av. Faria Lima', '777', 'Torre 2 Apto 1501', 'Itaim Bibi', 'Sao Paulo', 'SP', '01451000', TRUE),
(10, 'Rua da Consolacao', '888', 'Casa', 'Consolacao', 'Sao Paulo', 'SP', '01301000', TRUE),
(11, 'Rua Estados Unidos', '999', 'Apto 201', 'Jardim America', 'Sao Paulo', 'SP', '01427001', TRUE),
(12, 'Av. Pedroso de Morais', '111', 'Casa 5', 'Pinheiros', 'Sao Paulo', 'SP', '05419000', TRUE),
(13, 'Rua Cardeal Arcoverde', '222', 'Bloco A Apto 401', 'Pinheiros', 'Sao Paulo', 'SP', '05407000', TRUE),
(14, 'Rua dos Incas', '333', 'Apto 909', 'Perdizes', 'Sao Paulo', 'SP', '05026000', TRUE),
(15, 'Rua Caiubi', '444', 'Casa', 'Perdizes', 'Sao Paulo', 'SP', '05024000', TRUE);

-- ------------------------------------------------------------
-- CUPONS (15 registros)
-- ------------------------------------------------------------
INSERT INTO cupons (codigo, descricao, tipo_desconto, valor, valor_minimo, data_inicio, data_fim, limite_uso, vezes_usado) VALUES
('BEMVINDO10', '10% de desconto para novos clientes', 'PERCENTUAL', 10.00, 100.00, '2025-01-01', '2026-12-31', 1000, 150),
('FRETEGRATIS', 'Frete gratis em compras acima de 200', 'FIXO', 30.00, 200.00, '2025-01-01', '2026-12-31', 5000, 320),
('BLACKFRIDAY20', '20% Black Friday', 'PERCENTUAL', 20.00, 500.00, '2025-11-24', '2025-11-30', 2000, 850),
('NATAL15', '15% Natal', 'PERCENTUAL', 15.00, 300.00, '2025-12-01', '2025-12-31', 1500, 400),
('PRIMEIRACOMPRA', '25% primeira compra', 'PERCENTUAL', 25.00, 200.00, '2025-01-01', '2026-12-31', 500, 120),
('PROMO50', '50 reais de desconto fixo', 'FIXO', 50.00, 500.00, '2025-06-01', '2026-06-30', 800, 90),
('CUPOM5', '5% desconto sem minimo', 'PERCENTUAL', 5.00, 0.00, '2025-01-01', '2026-12-31', 10000, 1100),
('ANIVERSARIO', '20% aniversario do cliente', 'PERCENTUAL', 20.00, 100.00, '2025-01-01', '2026-12-31', 2000, 280),
('MIDWEEK10', '10% desconto no meio da semana', 'PERCENTUAL', 10.00, 150.00, '2025-03-01', '2026-03-31', 3000, 450),
('FLASH25', '25% oferta relampago', 'PERCENTUAL', 25.00, 400.00, '2025-07-01', '2025-07-15', 500, 410),
('DESCONTO100', '100 reais off em compras acima de 1000', 'FIXO', 100.00, 1000.00, '2025-04-01', '2026-04-30', 300, 55),
('VIP30', '30% cliente VIP', 'PERCENTUAL', 30.00, 800.00, '2025-01-01', '2026-12-31', 200, 60),
('VOLTAULA10', '10% volta as aulas', 'PERCENTUAL', 10.00, 200.00, '2025-01-15', '2026-02-28', 1000, 340),
('DIA6', '6% desconto dia 6', 'PERCENTUAL', 6.00, 50.00, '2025-01-01', '2026-12-31', 5000, 700),
('SUPER12', '12% super promo', 'PERCENTUAL', 12.00, 250.00, '2025-05-01', '2026-05-31', 2000, 380);

-- ------------------------------------------------------------
-- PEDIDOS (15 registros)
-- ------------------------------------------------------------
INSERT INTO pedidos (id_cliente, id_endereco, id_cupon, status, valor_subtotal, valor_desconto, valor_total, data_pedido, data_entrega_estimada) VALUES
(1, 1, 1, 'ENTREGUE', 3500.00, 350.00, 3150.00, '2025-09-01 10:30:00', '2025-09-08'),
(2, 3, 2, 'ENTREGUE', 890.00, 30.00, 860.00, '2025-09-03 14:20:00', '2025-09-10'),
(3, 4, 3, 'ENTREGUE', 7400.00, 1480.00, 5920.00, '2025-09-05 09:15:00', '2025-09-12'),
(4, 5, 4, 'ENTREGUE', 5200.00, 1300.00, 3900.00, '2025-09-07 16:45:00', '2025-09-14'),
(5, 6, NULL, 'ENTREGUE', 299.00, 0.00, 299.00, '2025-09-10 11:00:00', '2025-09-17'),
(6, 7, 5, 'PAGO', 4200.00, 1050.00, 3150.00, '2025-09-12 13:30:00', '2025-09-19'),
(7, 8, NULL, 'PAGO', 1450.00, 0.00, 1450.00, '2025-09-15 08:00:00', '2025-09-22'),
(8, 9, 6, 'SEPARADO', 2800.00, 50.00, 2750.00, '2025-09-18 15:20:00', '2025-09-25'),
(9, 10, 7, 'SEPARADO', 3800.00, 190.00, 3610.00, '2025-09-20 10:10:00', '2025-09-27'),
(10, 11, 8, 'ENVIADO', 1500.00, 300.00, 1200.00, '2025-09-22 14:00:00', '2025-09-29'),
(11, 12, NULL, 'ENVIADO', 500.00, 0.00, 500.00, '2025-09-25 09:45:00', '2025-10-02'),
(12, 13, 9, 'PENDENTE', 4200.00, 420.00, 3780.00, '2025-09-28 17:30:00', '2025-10-05'),
(13, 14, NULL, 'PENDENTE', 250.00, 0.00, 250.00, '2025-09-30 11:15:00', '2025-10-07'),
(14, 15, 10, 'PENDENTE', 1800.00, 450.00, 1350.00, '2025-10-02 08:50:00', '2025-10-09'),
(15, 16, NULL, 'CANCELADO', 2400.00, 0.00, 2400.00, '2025-10-05 16:00:00', '2025-10-12');

-- ------------------------------------------------------------
-- ITENS_PEDIDO (30 registros)
-- ------------------------------------------------------------
INSERT INTO itens_pedido (id_pedido, id_produto, quantidade, preco_unitario, desconto) VALUES
(1, 1, 1, 3500.00, 350.00),
(2, 3, 1, 890.00, 30.00),
(3, 11, 1, 3800.00, 760.00),
(3, 13, 1, 250.00, 50.00),
(3, 17, 1, 1500.00, 300.00),
(3, 14, 1, 250.00, 50.00),
(4, 7, 1, 5200.00, 1300.00),
(5, 5, 1, 299.00, 0.00),
(6, 8, 1, 4200.00, 1050.00),
(7, 4, 1, 1450.00, 0.00),
(8, 9, 1, 2800.00, 50.00),
(9, 12, 1, 4200.00, 190.00),
(10, 17, 1, 1500.00, 300.00),
(11, 18, 1, 450.00, 0.00),
(11, 6, 1, 220.00, 0.00),
(12, 12, 1, 4200.00, 420.00),
(13, 13, 1, 250.00, 0.00),
(14, 16, 1, 1800.00, 450.00),
(15, 15, 1, 2400.00, 0.00),
(1, 5, 1, 299.00, 0.00),
(2, 6, 1, 220.00, 0.00),
(4, 14, 1, 250.00, 0.00),
(6, 5, 1, 299.00, 0.00),
(8, 5, 1, 299.00, 0.00),
(9, 14, 1, 250.00, 0.00),
(10, 6, 1, 220.00, 0.00),
(12, 6, 1, 220.00, 0.00),
(13, 5, 1, 299.00, 0.00),
(14, 5, 1, 299.00, 0.00),
(15, 6, 1, 220.00, 0.00);

-- ------------------------------------------------------------
-- PAGAMENTOS (15 registros)
-- ------------------------------------------------------------
INSERT INTO pagamentos (id_pedido, metodo, status, valor, parcelas, codigo_transacao, data_pagamento) VALUES
(1, 'CARTAO_CREDITO', 'APROVADO', 3150.00, 6, 'TXN-00001', '2025-09-01 10:31:00'),
(2, 'PIX', 'APROVADO', 860.00, 1, 'TXN-00002', '2025-09-03 14:21:00'),
(3, 'CARTAO_CREDITO', 'APROVADO', 5920.00, 10, 'TXN-00003', '2025-09-05 09:16:00'),
(4, 'CARTAO_CREDITO', 'APROVADO', 3900.00, 6, 'TXN-00004', '2025-09-07 16:46:00'),
(5, 'BOLETO', 'APROVADO', 299.00, 1, 'TXN-00005', '2025-09-10 11:01:00'),
(6, 'CARTAO_CREDITO', 'APROVADO', 3150.00, 6, 'TXN-00006', '2025-09-12 13:31:00'),
(7, 'CARTAO_DEBITO', 'APROVADO', 1450.00, 1, 'TXN-00007', '2025-09-15 08:01:00'),
(8, 'PIX', 'APROVADO', 2750.00, 1, 'TXN-00008', '2025-09-18 15:21:00'),
(9, 'CARTAO_CREDITO', 'APROVADO', 3610.00, 6, 'TXN-00009', '2025-09-20 10:11:00'),
(10, 'CARTAO_CREDITO', 'APROVADO', 1200.00, 3, 'TXN-00010', '2025-09-22 14:01:00'),
(11, 'PIX', 'APROVADO', 500.00, 1, 'TXN-00011', '2025-09-25 09:46:00'),
(12, 'CARTAO_CREDITO', 'PENDENTE', 3780.00, 6, 'TXN-00012', '2025-09-28 17:31:00'),
(13, 'BOLETO', 'PENDENTE', 250.00, 1, 'TXN-00013', '2025-09-30 11:16:00'),
(14, 'CARTAO_CREDITO', 'PENDENTE', 1350.00, 3, 'TXN-00014', '2025-10-02 08:51:00'),
(15, 'CARTAO_CREDITO', 'CANCELADO', 2400.00, 1, 'TXN-00015', '2025-10-05 16:01:00');

-- ------------------------------------------------------------
-- AVALIACOES (15 registros)
-- ------------------------------------------------------------
INSERT INTO avaliacoes (id_produto, id_cliente, nota, comentario, data_avaliacao) VALUES
(1, 1, 5, 'Excelente notebook, superou expectativas', '2025-09-10 14:00:00'),
(1, 3, 4, 'Bom custo beneficio', '2025-09-12 10:30:00'),
(3, 2, 5, 'Monitor com otima qualidade de imagem', '2025-09-15 16:00:00'),
(4, 7, 4, 'Otimo monitor, mas chegou com atraso', '2025-09-18 09:00:00'),
(5, 5, 5, 'Melhor mouse que ja tive', '2025-09-20 11:00:00'),
(7, 4, 5, 'iPhone perfeito, chegou rapido', '2025-09-22 13:00:00'),
(11, 3, 5, 'PS5 incrivel, sem problemas', '2025-09-25 15:00:00'),
(11, 6, 4, 'Console otimo, mas o jogo veio em ingles', '2025-09-28 10:00:00'),
(12, 9, 5, 'Xbox Series X fantastico', '2025-09-30 14:00:00'),
(2, 1, 4, 'Notebook bom porem bateria podia ser melhor', '2025-10-02 08:00:00'),
(6, 8, 5, 'Teclado mecanico perfeito para programar', '2025-10-04 12:00:00'),
(13, 3, 5, 'God of War espetacular', '2025-10-06 17:00:00'),
(17, 10, 4, 'Sofa confortavel, cor ligeiramente diferente do anuncio', '2025-10-08 09:30:00'),
(15, 13, 5, 'Geladeira excelente e silenciosa', '2025-10-10 14:00:00'),
(9, 14, 4, 'iPad muito bom, ideal para estudos', '2025-10-12 11:00:00');

-- ------------------------------------------------------------
-- ENTREGAS (15 registros)
-- ------------------------------------------------------------
INSERT INTO entregas (id_pedido, id_transportadora, codigo_rastreio, status, data_envio, data_entrega) VALUES
(1, 1, 'BR0012345678', 'ENTREGUE', '2025-09-02 08:00:00', '2025-09-07 15:00:00'),
(2, 2, 'BR0012345679', 'ENTREGUE', '2025-09-04 08:00:00', '2025-09-09 16:00:00'),
(3, 3, 'BR0012345680', 'ENTREGUE', '2025-09-06 08:00:00', '2025-09-11 17:00:00'),
(4, 4, 'BR0012345681', 'ENTREGUE', '2025-09-08 08:00:00', '2025-09-13 18:00:00'),
(5, 5, 'BR0012345682', 'ENTREGUE', '2025-09-11 08:00:00', '2025-09-16 15:00:00'),
(6, 1, 'BR0012345683', 'ENVIADO', '2025-09-13 08:00:00', NULL),
(7, 2, 'BR0012345684', 'ENVIADO', '2025-09-16 08:00:00', NULL),
(8, 3, 'BR0012345685', 'EM_TRANSITO', '2025-09-19 08:00:00', NULL),
(9, 4, 'BR0012345686', 'EM_TRANSITO', '2025-09-21 08:00:00', NULL),
(10, 5, 'BR0012345687', 'EM_TRANSITO', '2025-09-23 08:00:00', NULL),
(11, 6, 'BR0012345688', 'EM_SEPARACAO', NULL, NULL),
(12, 7, 'BR0012345689', 'EM_SEPARACAO', NULL, NULL),
(13, 8, 'BR0012345690', 'EM_SEPARACAO', NULL, NULL),
(14, 9, 'BR0012345691', 'EM_SEPARACAO', NULL, NULL),
(15, 10, 'BR0012345692', 'DEVOLVIDO', '2025-10-06 08:00:00', NULL);
