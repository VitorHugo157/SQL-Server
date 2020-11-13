--Exercicios08.xlsx
CREATE DATABASE EXERCICIO08
GO
USE EXERCICIO08

CREATE TABLE [Cliente](
codigo_cliente		INT				NOT NULL	IDENTITY,
nome_cliente		VARCHAR(45)		NOT NULL,
endereco			VARCHAR(45)		NOT NULL,
telefone			CHAR(08)		NOT NULL,
telefone_comercial	CHAR(08)		NULL
PRIMARY KEY(codigo_cliente)
)

CREATE TABLE [Tipos_de_Mercadoria](
codigo_tipo_mercadoria	INT				NOT NULL	IDENTITY(10001, 1),
nome_tipo_mercadoria	VARCHAR(45)		NOT NULL
PRIMARY KEY(codigo_tipo_mercadoria)
)

CREATE TABLE [Corredor](
codigo_corredor		INT				NOT NULL	IDENTITY(101, 1),
tipo				INT				NULL,
nome_corredor		VARCHAR(45)		NULL
PRIMARY KEY(codigo_corredor)
FOREIGN KEY(tipo) REFERENCES [Tipos_de_Mercadoria](codigo_tipo_mercadoria)
)

CREATE TABLE [Mercadoria](
codigo_mercadoria		INT				NOT NULL	IDENTITY(1001, 1),
nome_mercadoria			VARCHAR(45)		NOT NULL,
corredor				INT				NOT NULL,
tipo					INT				NOT NULL,
valor_mercadoria		DECIMAL(7, 2)	NOT NULL	CHECK(valor_mercadoria > 0)
PRIMARY KEY(codigo_mercadoria)
FOREIGN KEY(corredor) REFERENCES [Corredor](codigo_corredor),
FOREIGN KEY(tipo) REFERENCES [Tipos_de_Mercadoria](codigo_tipo_mercadoria)
)

CREATE TABLE [Compra](
nota_fiscal		INT				NOT NULL	IDENTITY(1234, 1111),
cod_cliente		INT				NOT NULL,
valor_compra	DECIMAL(7, 2)	NOT NULL	CHECK(valor_compra > 0)
PRIMARY KEY(nota_fiscal)
FOREIGN KEY(cod_cliente) REFERENCES [Cliente](codigo_cliente)
)

--Inserindo dados nas tabelas
INSERT INTO [Cliente]
VALUES
('Luis Paulo', 'R. Xv de Novembro, 100', '45657878', NULL),
('Maria Fernanda', 'R. Anhaia, 1098', '27289098', '40040090'),
('Ana Claudia', 'Av. Voluntários da Pátria, 876', '21346548', NULL),
('Marcos Henrique', 'R. Pantojo, 76', '51425890', '30394540'),
('Emerson Souza', 'R. Pedro Álvares Cabral, 97', '44236545', '39389900'),
('Ricardo Santos', 'Trav. Hum, 10', '98789878', NULL)

SELECT * FROM [Cliente]

INSERT INTO [Tipos_de_Mercadoria]
VALUES
('Pães'),
('Frios'),
('Bolacha'),
('Clorados'),
('Frutas'),
('Esponjas'),
('Massas'),
('Molhos')

SELECT * FROM [Tipos_de_Mercadoria]

INSERT INTO [Corredor]
VALUES
(10001, 'Padaria'),
(10002, 'Calçados'),
(10003, 'Biscoitos'),
(10004, 'Limpeza'),
(NULL, NULL),
(NULL, NULL),
(10007, 'Congelados')

SELECT * FROM [Corredor]

INSERT INTO [Mercadoria]
VALUES
('Pão de Forma', 101, 10001, 3.50),
('Presunto', 101, 10002, 2.00),
('Cream Cracker', 103, 10003, 4.50),
('Água Sanitária', 104, 10004, 6.50),
('Maçã', 105, 10005, 0.90),
('Palha de Aço', 106, 10006, 1.30),
('Lasanha', 107, 10007, 9.70)

SELECT * FROM [Mercadoria]

INSERT INTO [Compra]
VALUES
(2, 200.00),
(4, 156.00),
(6, 354.00),
(3, 19.00)

SELECT * FROM [Compra]

--Valor da Compra de Luis Paulo
SELECT valor_compra
FROM [Compra]
WHERE cod_cliente IN
(
	SELECT codigo_cliente
	FROM [Cliente]
	WHERE nome_cliente = 'Luis Paulo'
)

--Valor da Compra de Marcos Henrique
SELECT valor_compra
FROM [Compra]
WHERE cod_cliente IN
(
	SELECT codigo_cliente
	FROM [Cliente]
	WHERE nome_cliente = 'Marcos Henrique'
)

--Endereço e telefone do comprador de Nota Fiscal = 4567
SELECT endereco, 
		SUBSTRING(telefone, 1, 4) + '-' + SUBSTRING(telefone, 5, 4) AS telefone
FROM [Cliente]
WHERE codigo_cliente IN
(
	SELECT cod_cliente
	FROM [Compra]
	WHERE nota_fiscal = 4567
)

--Valor da mercadoria cadastrada do tipo " Pães"
SELECT valor_mercadoria
FROM [Mercadoria]
WHERE tipo IN
(
	SELECT codigo_tipo_mercadoria
	FROM [Tipos_de_Mercadoria]
	WHERE nome_tipo_mercadoria = 'Pães'
)

--Nome do corredor onde está a Lasanha
SELECT nome_corredor
FROM [Corredor]
WHERE codigo_corredor IN
(
	SELECT corredor
	FROM [Mercadoria]
	WHERE nome_mercadoria = 'Lasanha'
)

--Nome do corredor onde estão os clorados
SELECT nome_corredor
FROM [Corredor]
WHERE tipo IN
(
	SELECT codigo_tipo_mercadoria
	FROM [Tipos_de_Mercadoria]
	WHERE nome_tipo_mercadoria = 'Clorados'
)
