--Exercicios07.xlsx
CREATE DATABASE LOJA
GO
USE LOJA

CREATE TABLE [Cliente](
rg					VARCHAR(12)		NOT NULL,
cpf					CHAR(14)		NOT NULL,
nome				VARCHAR(45)		NOT NULL,
endereco_cliente	VARCHAR(45)		NOT NULL
PRIMARY KEY(rg)
)

CREATE TABLE [Pedido](
nota_fiscal		INT				NOT NULL	IDENTITY(1001, 1),
valor			DECIMAL(7, 2)	NOT NULL	CHECK(valor > 0),
data_pedido		DATE			NOT NULL,
rg_cliente		VARCHAR(12)		NOT NULL
PRIMARY KEY(nota_fiscal)
FOREIGN KEY(rg_cliente) REFERENCES [Cliente](rg)
)

CREATE TABLE [Fornecedor](
codigo_fornecedor		INT			NOT NULL	IDENTITY,
nome_fornecedor			VARCHAR(45)	NOT NULL,
endereco_fornecedor		VARCHAR(45)	NOT NULL,
telefone				VARCHAR(14)	NULL,
cgc						VARCHAR(14)	NULL,
cidade					VARCHAR(45)	NULL,
transporte				VARCHAR(45)	NULL,
pais					VARCHAR(03)	NULL,
moeda					VARCHAR(04)	NULL	DEFAULT('US$')
PRIMARY KEY(codigo_fornecedor)
)

CREATE TABLE [Mercadoria](
codigo_mercadoria		INT				NOT NULL	IDENTITY(10, 1),
descricao				VARCHAR(45)		NOT NULL,
preco					DECIMAL(7, 2)	NOT NULL	CHECK(preco > 0),
qtd						INT				NOT NULL	CHECK(qtd >= 0),
cod_fornecedor			INT				NOT NULL
PRIMARY KEY(codigo_mercadoria)
FOREIGN KEY(cod_fornecedor) REFERENCES [Fornecedor](codigo_fornecedor)
)

--Inserindo dados nas tabelas
INSERT INTO [Cliente]
VALUES
('2.953.184-4', '345.198.780-40', 'Luiz André', 'R. Astorga, 500'),
('13.514.996-x', '849.842.856-30', 'Maria Luiza', 'R. Piauí, 174'),
('12.198.554-1', '233.549.973-10', 'Ana Barbara', 'Av. Jaceguai, 1141'),
('23.987.746-x', '435.876.699-20', 'Marcos Alberto', 'R. Quinze, 22')

SELECT * FROM [Cliente]

INSERT INTO [Pedido]
VALUES
(754.00, '01/04/2018', '12.198.554-1'),
(350.00, '02/04/2018', '12.198.554-1'),
(30.00, '02/04/2018', '2.953.184-4'),
(1500.00, '03/04/2018', '13.514.996-X')

SELECT * FROM [Pedido]

INSERT INTO [Fornecedor]
VALUES
('Clone', 'Av. Nações Unidas, 12000', '(11)4178-7000', NULL, 'São Paulo', NULL, NULL, NULL),
('Logitech', '28th Street, 100', '1-800-145990', NULL, NULL, 'Avião', 'EUA', 'US$'),
('LG', 'Rod. Castello Branco', '0800-664400', '415997810/0001', 'Sorocaba', NULL, NULL, NULL),
('PcChips', 'Ponte da Amizade', NULL, NULL, NULL, 'Navio', 'Py', 'US$')

SELECT * FROM [Fornecedor]

INSERT INTO [Mercadoria]
VALUES
('Mouse', 24.00, 30, 1),
('Teclado', 50.00, 20, 1),
('Cx. De Som', 30.00, 8, 2),
('Monitor 17', 350.00, 4, 3),
('Notebook', 1500.00, 7, 4)

SELECT * FROM [Mercadoria]

--Consultar 10% de desconto no pedido 1003
SELECT valor, CAST(valor * 0.9 AS DECIMAL(7, 2)) AS 'valor_10%_desconto'
FROM [Pedido]
WHERE nota_fiscal = 1003

--Consultar 5% de desconto em pedidos com valor maior de R$700,00
SELECT nota_fiscal, valor, CAST(valor * 0.95 AS DECIMAL(7, 2)) AS 'valor_05%_desconto'
FROM [Pedido]
WHERE valor > 700.00

--Consultar e atualizar aumento de 20% no valor de marcadorias com estoque menor de 10					
SELECT codigo_mercadoria, preco, CAST(preco * 1.20 AS DECIMAL(7, 2)) AS 'preço_com_20%_de_aumento'
FROM [Mercadoria]
WHERE qtd < 10

UPDATE [Mercadoria]
SET preco = preco * 1.20
WHERE qtd < 10

SELECT codigo_mercadoria, preco
FROM [Mercadoria]
WHERE qtd < 10

--Data e valor dos pedidos do Luiz
SELECT CONVERT(CHAR(10), data_pedido, 103) AS data_pedido, valor
FROM [Pedido]
WHERE rg_cliente IN
(
	SELECT rg
	FROM [Cliente]
	WHERE nome LIKE 'Luiz%'
)

--CPF, Nome e endereço do cliente de nota 1004
SELECT cpf, nome, endereco_cliente
FROM [Cliente]
WHERE rg IN
(
	SELECT rg_cliente
	FROM [Pedido]
	WHERE nota_fiscal = 1004
)

--País e meio de transporte da Cx. De som
SELECT pais, transporte
FROM [Fornecedor]
WHERE codigo_fornecedor IN
(
	SELECT cod_fornecedor
	FROM [Mercadoria]
	WHERE descricao = 'Cx. De Som'
)

--Nome e Quantidade em estoque dos produtos fornecidos pela Clone
SELECT descricao, qtd
FROM [Mercadoria]
WHERE cod_fornecedor IN
(
	SELECT codigo_fornecedor
	FROM [Fornecedor]
	WHERE nome_fornecedor = 'Clone'
)

--Endereço e telefone dos fornecedores do monitor
SELECT endereco_fornecedor, telefone
FROM [Fornecedor]
WHERE codigo_fornecedor IN
(
	SELECT cod_fornecedor
	FROM [Mercadoria]
	WHERE descricao LIKE 'Monitor%'
)

--Tipo de moeda que se compra o notebook
SELECT moeda
FROM [Fornecedor]
WHERE codigo_fornecedor IN
(
	SELECT cod_fornecedor
	FROM [Mercadoria]
	WHERE descricao = 'Notebook'
)

--Há quantos dias foram feitos os pedidos e, criar uma coluna que escreva Pedido antigo para pedidos feitos há mais de 6 meses
SELECT nota_fiscal, CONVERT(CHAR(10), data_pedido, 103) AS data_pedido,
		DATEDIFF(DAY, data_pedido, GETDATE()) AS dias_passados_desde_a_compra
FROM [Pedido]

ALTER TABLE [Pedido]
ADD definicao_data_pedido	CHAR(13)	NULL

UPDATE [Pedido]
SET definicao_data_pedido = 'Pedido antigo'
WHERE DATEDIFF(MONTH, data_pedido, GETDATE()) > 6

SELECT * FROM [Pedido]

--Nome e Quantos pedidos foram feitos por cada cliente
SELECT c.nome, p.nota_fiscal, p.valor, CONVERT(CHAR(10), p.data_pedido, 103) AS data_pedido, p.rg_cliente
FROM [Cliente] c, [Pedido] p
WHERE p.rg_cliente = c.rg

--RG,CPF,Nome e Endereço dos cliente cadastrados que Não Fizeram pedidos
SELECT rg, cpf, nome, endereco_cliente
FROM [Cliente] c LEFT OUTER JOIN [Pedido] p
ON c.rg = p.rg_cliente
WHERE p.rg_cliente IS NULL

