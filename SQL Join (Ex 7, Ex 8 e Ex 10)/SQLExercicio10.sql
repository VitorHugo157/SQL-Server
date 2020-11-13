--Exercicios10.xlsx
CREATE DATABASE EXERCICIO10
GO
USE EXERCICIO10

CREATE TABLE [Medicamento](
codigo				INT			 NOT NULL	IDENTITY,
nome_medicamento	VARCHAR(45)	 NOT NULL,
apresentacao		VARCHAR(45)	 NOT NULL,
unidade_de_cadastro	VARCHAR(45)	 NOT NULL	DEFAULT('Comprimido'),
preco_proposto		DECIMAL(7,3) NOT NULL	CHECK(preco_proposto > 0)
PRIMARY KEY(codigo)
)

CREATE TABLE [Cliente](
cpf				CHAR(12)		NOT NULL,
nome_cliente	VARCHAR(45)		NOT NULL,
logradouro		VARCHAR(45)		NOT NULL,
num_logradouro	INT				NOT NULL	CHECK(num_logradouro > 0),
bairro			VARCHAR(45)		NOT NULL,
telefone		CHAR(08)		NOT NULL
PRIMARY KEY(cpf)
)

CREATE TABLE [Venda](
nota_fiscal			INT			 NOT NULL,
cpf_cliente			CHAR(12)	 NOT NULL,
codigo_medicamento	INT			 NOT NULL,
quantidade			INT			 NOT NULL	CHECK(quantidade > 0),
valor_total			DECIMAL(7,2) NOT NULL	CHECK(valor_total > 0),
data_venda			DATE		 NOT NULL
PRIMARY KEY(nota_fiscal, cpf_cliente, codigo_medicamento)
FOREIGN KEY(cpf_cliente) REFERENCES [Cliente](cpf),
FOREIGN KEY(codigo_medicamento) REFERENCES [Medicamento](codigo)
)

--Inserindo dados nas tabelas
INSERT INTO [Medicamento]
VALUES
('Acetato de medroxiprogesterona', '150 mg/ml', 'Ampola', 6.700)
GO
INSERT INTO [Medicamento] (nome_medicamento, apresentacao, preco_proposto)
VALUES
('Aciclovir', '200mg/comp.', 0.280),
('Ácido Acetilsalicílico', '500mg/comp.', 0.035),
('Ácido Acetilsalicílico', '100mg/comp.', 0.030),
('Ácido Fólico', '5mg/comp.', 0.054),
('Albendazol', '400mg/comp. mastigável', 0.560),
('Alopurinol', '100mg/comp.', 0.080),
('Amiodarona', '200mg/comp.', 0.200),
('Amitriptilina(Cloridrato)', '25mg/comp.', 0.220)
GO
INSERT INTO [Medicamento]
VALUES
('Amoxicilina', '500mg/cáps.', 'Cápsula', 0.190)

SELECT * FROM [Medicamento]

INSERT INTO [Cliente]
VALUES
('343908987-00', 'Maria Zélia', 'Anhaia', 65, 'Barra Funda', '92103762'),
('213459862-90', 'Roseli Silva', 'Xv. De Novembro', 987, 'Centro', '82198763'),
('869279818-25', 'Carlos Campos', 'Voluntários da Pátria', 1276, 'Santana', '98172361'),
('310981209-00', 'João Perdizes', 'Carlos de Campos', 90, 'Pari', '61982371')

SELECT * FROM [Cliente]

INSERT INTO [Venda]
VALUES
(31501, '869279818-25', 10, 3, 0.57, '01/11/2010'),
(31501, '869279818-25', 2, 10, 2.80, '01/11/2010'),
(31501, '869279818-25', 5, 30, 1.05, '01/11/2010'),
(31501, '869279818-25', 8, 30, 6.60, '01/11/2010'),
(31502, '343908987-00', 8, 15, 3.00, '01/11/2010'),
(31502, '343908987-00', 2, 10, 2.80, '01/11/2010'),
(31502, '343908987-00', 9, 10, 2.20, '01/11/2010'),
(31503, '310981209-00', 1, 20, 134.00, '02/11/2010')

SELECT * FROM [Venda]

--Consultar:
--Nome, apresentação, unidade e valor unitário dos remédios que ainda não foram vendidos. Caso a unidade de cadastro seja comprimido, mostrar Comp.
SELECT nome_medicamento, apresentacao, 
		CASE WHEN (unidade_de_cadastro = 'Comprimido')
			THEN
				SUBSTRING(unidade_de_cadastro, 1, 4) + '.'
		END AS unidade_de_cadastro,
		preco_proposto
FROM [Medicamento] m LEFT OUTER JOIN [Venda] v
ON m.codigo = v.codigo_medicamento
WHERE v.codigo_medicamento IS NULL

--Nome dos clientes que compraram Amiodarona
SELECT nome_cliente
FROM [Cliente]
WHERE cpf IN
(
	SELECT cpf_cliente
	FROM [Venda]
	WHERE codigo_medicamento IN
	(
		SELECT codigo
		FROM [Medicamento]
		WHERE nome_medicamento = 'Amiodarona'
	)
)

/*CPF do cliente, endereço concatenado, nome do medicamento (como nome de remédio),  
apresentação do remédio, unidade, preço proposto, 
quantidade vendida e valor total dos remédios vendidos a Maria Zélia
*/
SELECT SUBSTRING(c.cpf, 1, 3) + '.' + SUBSTRING(c.cpf, 4, 3) + '.' + SUBSTRING(c.cpf, 7, 6) AS cpf_cliente,
	   c.logradouro + ', ' + CAST(c.num_logradouro AS VARCHAR(10)) + ' - ' + bairro AS endereco,
	   m.nome_medicamento AS nome_de_remédio, m.apresentacao, m.unidade_de_cadastro, preco_proposto,
	   v.quantidade, v.valor_total
FROM [Cliente] c, [Medicamento] m, [Venda] v
WHERE c.cpf = v.cpf_cliente
	AND	m.codigo = v.codigo_medicamento
	AND c.nome_cliente = 'Maria Zélia'

--Data de compra, convertida, de Carlos Campos
SELECT DISTINCT(CONVERT(CHAR(10), data_venda, 103)) AS data_venda,
		nota_fiscal
FROM [Venda]
WHERE cpf_cliente IN
(
	SELECT cpf
	FROM [Cliente]
	WHERE nome_cliente = 'Carlos Campos'
)

--Alterar o nome da  Amitriptilina(Cloridrato) para Cloridrato de Amitriptilina
UPDATE [Medicamento]
SET nome_medicamento = 'Cloridrato de Amitriptilina'
WHERE nome_medicamento = 'Amitriptilina(Cloridrato)'

SELECT codigo, nome_medicamento FROM [Medicamento] WHERE nome_medicamento = 'Cloridrato de Amitriptilina'
