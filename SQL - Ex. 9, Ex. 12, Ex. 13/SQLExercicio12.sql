CREATE DATABASE EXERCICIO12
GO
USE EXERCICIO12

CREATE TABLE planos (
cod_plano INT NOT NULL IDENTITY,
nome_plano VARCHAR(45) NOT NULL,
valor_plano INT NOT NULL,
PRIMARY KEY (cod_plano)
)

CREATE TABLE servicos (
cod_servico INT NOT NULL IDENTITY,
nome_servico VARCHAR(45) NOT NULL,
valor_servico INT NOT NULL,
PRIMARY KEY (cod_servico)
)

CREATE TABLE cliente (
cod_cliente INT NOT NULL IDENTITY(1234, 1234),
nome_cliente VARCHAR(45) NOT NULL,
data_inicio CHAR(10) NOT NULL,
PRIMARY KEY (cod_cliente)
)

CREATE TABLE contratos (
cod_cliente INT NOT NULL,
cod_plano INT NOT NULL,
cod_servico INT NOT NULL,
status_contrato CHAR(1) NOT NULL,
dat CHAR(10) NOT NULL,
PRIMARY KEY (cod_cliente, cod_plano, cod_servico, status_contrato),
FOREIGN KEY (cod_cliente) REFERENCES cliente (cod_cliente),
FOREIGN KEY (cod_plano) REFERENCES planos (cod_plano),
FOREIGN KEY (cod_servico) REFERENCES servicos (cod_servico)
)

--Inserindo dados nas tabelas
INSERT INTO planos VALUES
('100 Minutos',	80),
('150 Minutos',	130),
('200 Minutos',	160),
('250 Minutos',	220),
('300 Minutos',	260),
('600 Minutos',	350)

SELECT * FROM [planos]

INSERT INTO servicos VALUES
('100 SMS',	10),
('SMS Ilimitado',	30),
('Internet 500 MB',	40),
('Internet 1 GB',	60),
('Internet 2 GB',	70)

SELECT * FROM [servicos]

INSERT INTO cliente VALUES
('Cliente A',	'15/10/2012'),
('Cliente B',	'20/11/2012'),
('Cliente C',	'25/11/2012'),
('Cliente D',	'01/12/2012'),
('Cliente E',	'18/12/2012'),
('Cliente F',	'20/01/2013'),
('Cliente G',	'25/01/2013')

SELECT * FROM [cliente]

INSERT INTO contratos VALUES 
(1234,	3,	1,	'E',	'15/10/2012'),
(1234,	3,	3,	'E',	'15/10/2012'),
(1234,	3,	3,	'A',	'16/10/2012'),
(1234,	3,	1,	'A',	'16/10/2012'),
(2468,	4,	4,	'E',	'20/11/2012'),
(2468,	4,	4,	'A',	'21/11/2012'),
(6170,	6,	2,	'E',	'18/12/2012'),
(6170,	6,	5,	'E',	'19/12/2012'),
(6170,	6,	2,	'A',	'20/12/2012'),
(6170,	6,	5,	'A',	'21/12/2012'),
(1234,	3,	1,	'D',	'10/01/2013'),
(1234,	3,	3,	'D',	'10/01/2013'),
(1234,	2,	1,	'E',	'10/01/2013'),
(1234,	2,	1,	'A',	'11/01/2013'),
(2468,	4,	4,	'D',	'25/01/2013'),
(7404,	2,	1,	'E',	'20/01/2013'),
(7404,	2,	5,	'E',	'20/01/2013'),
(7404,	2,	5,	'A',	'21/01/2013'),
(7404,	2,	1,	'A',	'22/01/2013'),
(8638,	6,	5,	'E',	'25/01/2013'),
(8638,	6,	5,	'A',	'26/01/2013'),
(7404,	2,	5,	'D',	'03/02/2013')

SELECT * FROM [contratos]

--Status de contrato A(Ativo), D(Desativado), E(Espera)										
--Um plano só é válido se existe pelo menos um serviço associado a ele										
								
-- Consultar o nome do cliente, o nome do plano, a quantidade de estados de contrato (sem repetições) por contrato, dos planos cancelados, ordenados pelo nome do cliente
SELECT c.nome_cliente AS CLIENTE, p.nome_plano AS PLANO, COUNT (co.status_contrato) AS PLANOS_CANCELADOS
FROM cliente c 	INNER JOIN contratos co
ON c.cod_cliente = co.cod_cliente INNER JOIN planos p
ON p.cod_plano = co.cod_plano
GROUP BY c.nome_cliente, p.nome_plano, co.status_contrato
HAVING (co.status_contrato = 'D')
ORDER BY c.nome_cliente

-- Consultar o nome do cliente, o nome do plano, a quantidade de estados de contrato (sem repetições) por contrato, dos planos não cancelados, ordenados pelo nome do cliente										
SELECT DISTINCT c.nome_cliente AS CLIENTE, p.nome_plano AS PLANO, COUNT (co.status_contrato) AS PLANOS_NÃO_CANCELADOS
FROM cliente c 	INNER JOIN contratos co
ON c.cod_cliente = co.cod_cliente INNER JOIN planos p
ON p.cod_plano = co.cod_plano
GROUP BY c.nome_cliente, p.nome_plano, co.status_contrato
HAVING (co.status_contrato != 'D')
ORDER BY c.nome_cliente

-- Consultar o nome do cliente, o nome do plano, e o valor da conta de cada contrato que está ou esteve ativo, sob as seguintes condições:										
	-- A conta é o valor do plano, somado à soma dos valores de todos os serviços									
	-- Caso a conta tenha valor superior a R$400.00, deverá ser incluído um desconto de 8%									
	-- Caso a conta tenha valor entre R$300,00 a R$400.00, deverá ser incluído um desconto de 5%									
	-- Caso a conta tenha valor entre R$200,00 a R$300.00, deverá ser incluído um desconto de 3%									
	-- Contas com valor inferiores a R$200,00 não tem desconto			
SELECT DISTINCT c.nome_cliente AS CLIENTE, p.nome_plano AS PLANO, s.valor_servico AS VALOR,  
		CASE WHEN (s.valor_servico > 40.00)
		THEN 
		(s.valor_servico * 0.92)
		WHEN (s.valor_servico >= 30.00 AND s.valor_servico <= 40.00)
		THEN
		(s.valor_servico * 0.95)
		WHEN (s.valor_servico >= 20.00 AND s.valor_servico <= 30.00)
		THEN 
		(s.valor_servico * 0.97)
		ELSE 
		NULL 
		END AS DESCONTO 
FROM cliente c INNER JOIN contratos co
ON c.cod_cliente = co.cod_cliente INNER JOIN planos p
ON p.cod_plano = co.cod_plano INNER JOIN servicos s
ON s.cod_servico = co.cod_servico
WHERE co.status_contrato = 'A' OR co.status_contrato = 'E'
						
-- Consultar o nome do cliente, o nome do serviço, e a duração, em meses (até a data de hoje) do serviço, dos cliente que nunca cancelaram nenhum plano										
SELECT DISTINCT c.nome_cliente AS CLIENTE, s.nome_servico AS SERVIÇO, DATEDIFF(MONTH, CONVERT(DATE, co.dat, 103), GETDATE()) AS DURAÇÃO_MESES
FROM cliente c INNER JOIN contratos co
ON c.cod_cliente = co.cod_cliente INNER JOIN servicos s
ON s.cod_servico = co.cod_servico
WHERE co.status_contrato != 'D'

