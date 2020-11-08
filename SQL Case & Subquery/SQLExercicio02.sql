--Exercicios02.xls
CREATE DATABASE OFICINA
GO
USE OFICINA

CREATE TABLE [Carro](
placa	CHAR(7)			NOT NULL,
marca	VARCHAR(45)		NOT NULL,
modelo	VARCHAR(45)		NOT NULL,
cor		VARCHAR(45)		NOT NULL,
ano					INT				NOT NULL	CHECK(ano > 0)
PRIMARY KEY(placa)
)

CREATE TABLE [Peca](
codigo		INT			 NOT NULL	IDENTITY,
nome_peca	VARCHAR(45)	 NOT NULL,
valor		DECIMAL(7,2) NOT NULL	CHECK(valor > 0)
PRIMARY KEY(codigo)
)

CREATE TABLE [Cliente](
nome_cliente		VARCHAR(45)		NOT NULL,
logradouro			VARCHAR(45)		NOT NULL,
num_logradouro		INT				NOT NULL	CHECK(num_logradouro > 0),
bairro				VARCHAR(45)		NOT NULL,
telefone			CHAR(9)			NOT NULL,
carro				CHAR(7)			NOT NULL
PRIMARY KEY(carro)
FOREIGN KEY(carro) REFERENCES [Carro](placa)
)

CREATE TABLE [Servico](
carro			CHAR(7)			NOT NULL,
peca			INT				NOT NULL,
quantidade		INT				NOT NULL	CHECK(quantidade > 0),
valor			DECIMAL(7,2)	NOT NULL	CHECK(valor > 0),
data_servico	DATE			NOT NULL
PRIMARY KEY(carro, peca, data_servico)
FOREIGN KEY(carro) REFERENCES [Carro](placa),
FOREIGN KEY(peca) REFERENCES [Peca](codigo)
)

--Inserindo dados nas tabelas
INSERT INTO [Carro]
VALUES
('AFT9087', 'VW', 'Gol', 'Preto', 2007),
('DXO9876', 'Ford', 'Ka', 'Azul', 2000),
('EGT4631', 'Renault', 'Clio', 'Verde', 2004),
('LKM7380', 'Fiat', 'Palio', 'Prata', 1997),
('BCD7521', 'Ford', 'Fiesta', 'Preto', 1999)

SELECT * FROM [Carro]

INSERT INTO [Peca]
VALUES
('Vela', 70.00),
('Correia Dentada', 125.00),
('Trambulador', 90.00),
('Filtro de Ar', 30.00)

SELECT * FROM [Peca]

INSERT INTO [Cliente]
VALUES
('João Alves', 'R. Pereira Barreto', 1258, 'Jd. Oliveiras', '2154-9658', 'DXO9876'),
('Ana Maria', 'R. 7 de Setembro', 259, 'Centro', '9658-8541', 'LKM7380'),
('Clara Oliveira', 'Av. Nações Unidas', 10254, 'Pinheiros', '2458-9658', 'EGT4631'),
('José Simões', 'R. XV de Novembro', 36, 'Água Branca', '7895-2459', 'BCD7521'),
('Paula Rocha', 'R. Anhaia', 548, 'Barra Funda', '6958-2548', 'AFT9087')

SELECT * FROM [Cliente]

INSERT INTO [Servico]
VALUES
('DXO9876', 1, 4, 280.00, '01/08/2020'),
('DXO9876', 4, 1, 30.00, '01/08/2020'),
('EGT4631', 3, 1, 90.00, '02/08/2020'),
('DXO9876', 2, 1, 125.00, '07/08/2020')

SELECT * FROM [Servico]

--Consultar em subqueries:
--Telefone do dono do carro Ka, Azul
SELECT telefone
FROM [Cliente]
WHERE carro IN
(
	SELECT placa
	FROM [Carro]
	WHERE modelo = 'Ka' AND cor = 'Azul'
)

--Endereço concatenado do cliente que fez o serviço do dia 02/08/2020
SELECT logradouro + ', ' + CAST(num_logradouro AS VARCHAR(10)) + ' - ' + bairro AS endereco_cliente
FROM [Cliente]
WHERE carro IN
(
	SELECT carro
	FROM [Servico]
	WHERE data_servico = '02/08/2020'
)

--Consultar:
--Placas dos carros de anos anteriores a 2001
SELECT SUBSTRING(placa, 1, 3) + '-' + SUBSTRING(placa, 4, 7) AS placa_carro
FROM [Carro]
WHERE ano < 2001

--Marca, modelo e cor, concatenado dos carros posteriores a 2005
SELECT marca + ' ' + modelo + ' - ' + cor AS info_carro
FROM [Carro]
WHERE ano > 2005

--Código e nome das peças que custam menos de R$80,00
SELECT codigo, nome_peca
FROM [Peca]
WHERE valor < 80.00
