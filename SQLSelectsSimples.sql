CREATE DATABASE selects
GO
USE selects

CREATE TABLE funcionario(
id          INT             NOT NULL	IDENTITY,
nome        VARCHAR(100)    NOT NULL,
sobrenome   VARCHAR(200)    NOT NULL,
logradouro  VARCHAR(200)    NOT NULL,
numero      INT             NOT NULL	CHECK(numero > 0),
bairro      VARCHAR(100)    NULL,
cep         CHAR(8)         NULL		CHECK(LEN(cep) = 8),
ddd         CHAR(2)         NULL		DEFAULT('11'),
telefone    CHAR(8)         NULL		CHECK(LEN(telefone) = 8),
data_nasc   DATETIME        NOT NULL	CHECK(data_nasc < GETDATE()),
salario     DECIMAL(7,2)    NOT NULL	CHECK(salario > 0)
PRIMARY KEY(id)
)
GO
CREATE TABLE projeto(
codigo      INT             NOT NULL	IDENTITY(1001,1),
nome        VARCHAR(200)    NOT NULL	UNIQUE,
descricao   VARCHAR(300)    NULL
PRIMARY KEY(codigo)
)
GO
CREATE TABLE funcproj(
id_funcionario  INT         NOT NULL,
codigo_projeto  INT         NOT NULL,
data_inicio     DATETIME    NOT NULL,
data_fim        DATETIME    NOT NULL
PRIMARY KEY (id_funcionario, codigo_projeto)
FOREIGN KEY (id_funcionario) REFERENCES funcionario (id),
FOREIGN KEY (codigo_projeto) REFERENCES projeto (codigo),
CONSTRAINT chk_dt CHECK(data_fim > data_inicio))

/*
A tabela funcionário tem as seguintes restrições:
- PK - id
- id - auto incremento de 1 em 1
- número - deve ser positivo
- cep - deve ter 8 caracteres
- ddd - padrão 11
- telefone - deve ter 8 caracteres
- data_nasc - deve ser anterior a hoje
- salario - deve ser positivo

A tabela projeto tem as seguintes restrições:
- PK - codigo
- codigo - auto incremento partindo de 1001, de 1 em 1
- nome - não pode repetir

A tabela funcproj tem as seguintes restrições:
- PK - id_funcionario, codigo_projeto
- FK - id_funcionario ref. funcionario, PK id
- FK - codigo_projeto ref. projeto, PK codigo
- data_inicio & data_fim - data_fim não pode ser maior que data_inicio

ALIAS - Apelido
AS

SQL Funcões:
LEN(char)
GETDATE()
CAST()[Todos SGBD] - CONVERT()[SQL SERVER]
*/
--Exemplos Funções
SELECT LEN('Banco de Dados')
SELECT GETDATE()
SELECT CAST('12' AS INT)
SELECT CAST(12 AS VARCHAR(2))
SELECT CAST(5.1 AS VARCHAR(3))
SELECT CAST('5.1' AS DECIMAL(4,2))
SELECT CAST(5.1 AS INT)
SELECT CAST('12A' AS INT)
SELECT CONVERT(VARCHAR(2), 12)
SELECT CONVERT(INT, '12')
--DATETIME de YYYY-MM-DD HH:MM:ss para DD/MM/YYYY
SELECT CONVERT(CHAR(10), GETDATE(), 103) AS dia_hoje --103 código data BR DD/MM/YYYY
SELECT CONVERT(CHAR(10), GETDATE(), 101) AS dia_hoje --101 código data BR MM/DD/YYYY
SELECT CONVERT(CHAR(11), GETDATE(), 100) AS dia_hoje --100 código data USA

SELECT CONVERT(CHAR(5), GETDATE(), 108) AS dia_hoje --108 código hora HH:MM
SELECT CONVERT(CHAR(8), GETDATE(), 108) AS dia_hoje --108 código hora HH:MM:ss

INSERT INTO funcionario (nome, sobrenome, logradouro, numero, bairro, cep, telefone, data_nasc, salario) VALUES
('Fulano',	'da Silva',	'R. Voluntários da Patria',	8150,	'Santana',	'05423110',	'76895248',	'1974-05-15',	4350.00),
('Cicrano',	'De Souza',	'R. Anhaia', 353,	'Barra Funda',	'03598770',	'99568741',	'1984-08-25',	1552.00),
('Beltrano',	'Dos Santos',	'R. ABC', 1100,	'Artur Alvim',	'05448000',	'25639854',	'1963-06-02',	2250.00)

INSERT INTO funcionario (nome, sobrenome, logradouro, numero, bairro, cep, ddd, telefone, data_nasc, salario) VALUES
('Tirano',	'De Souza',	'Avenida Águia de Haia', 4430,	'Artur Alvim',	'05448000',	NULL,	NULL,	'1975-10-15',	2804.00)

INSERT INTO projeto VALUES
('Implantação de Sistemas','Colocar o sistema no ar'),
('Modificação do módulo de cadastro','Modificar CRUD'),
('Teste de Sistema de Cadastro',NULL)

INSERT INTO funcproj VALUES
(1, 1001, '2015-04-18', '2015-04-30'),
(3, 1001, '2015-04-18', '2015-04-30'),
(1, 1002, '2015-05-06', '2015-05-10'),
(2, 1002, '2015-05-06', '2015-05-10'),
(3, 1003, '2015-05-11', '2015-05-13')

INSERT INTO funcproj VALUES
(3, 1002, '2015-05-13', '2015-05-11')

SELECT * FROM funcionario
SELECT * FROM projeto 
SELECT * FROM funcproj


--Select Simples funcionario
SELECT id, nome, sobrenome, salario
FROM funcionario

--Select Simples funcionario(s) Fulano
SELECT id, nome, sobrenome, salario
FROM funcionario
WHERE nome = 'Fulano'

--Select Simples funcionario(s) Fulano Silva
SELECT id, nome, sobrenome, salario
FROM funcionario
WHERE nome = 'Fulano' AND sobrenome LIKE '%Silva%'

--LIKE (Faz análise parcial da coluna)

--Select Simples funcionario(s) Souza
SELECT id, nome, sobrenome, salario
FROM funcionario
WHERE sobrenome LIKE '%Souza%'

--Id e Nome Concatenado de quem não tem telefone
SELECT id, nome + ' ' + sobrenome AS nome_completo
FROM funcionario
WHERE telefone IS NULL

--NULL não aceita = nem != (<>)
--IS NULL || IS NOT NULL

--Nome Concatenado e telefone (sem ddd) de quem tem telefone
SELECT id, nome + ' ' + sobrenome AS nome_completo, telefone
FROM funcionario
WHERE telefone IS NOT NULL

--Nome Concatenado e telefone (sem ddd) de quem tem telefone em ordem alfabética
SELECT id, nome + ' ' + sobrenome AS nome_completo, telefone
FROM funcionario
WHERE telefone IS NOT NULL
ORDER BY nome ASC

--Nome completo, Endereco completo (Rua, nº e CEP), ddd e telefone, ordem alfabética crescente
SELECT id, nome + ' ' + sobrenome AS nome_completo, 
	logradouro+','+CAST(numero AS VARCHAR(5))+' - '+cep AS endereco_completo, 
	ddd, telefone
FROM funcionario
ORDER BY nome

--Nome completo, Endereco completo (Rua, nº e CEP), data_nasc (BR - DD/MM/AAAA), ordem alfabética decrescente
SELECT id, nome + ' ' + sobrenome AS nome_completo, 
	logradouro+','+CAST(numero AS VARCHAR(5))+' - '+cep AS endereco_completo, 
	CONVERT(CHAR(10), data_nasc, 103) AS dt_nasc
FROM funcionario
ORDER BY nome DESC
--ASC crescente | DESC decrescente

--Datas distintas (BR) de inicio de trabalhos
SELECT DISTINCT CONVERT(CHAR(10), data_inicio, 103) AS dt_inicio
FROM funcproj

--DISTINCT Remove linhas inteiras de um select quando estas estão duplicadas

--nome_completo e 15% de aumento para Cicrano
SELECT id, nome + ' ' + sobrenome AS nome_completo, salario,
		CAST(salario * 1.15 AS DECIMAL(7,2)) AS novo_salario
FROM funcionario
WHERE nome = 'Cicrano'

--Nome completo e salario de quem ganha mais que 3000
SELECT id, nome + ' ' + sobrenome AS nome_completo, salario
FROM funcionario
WHERE salario >= 3000

-- = , != OU <>, >, >=, <, <=

--Nome completo e salario de quem ganha menos que 2000
SELECT id, nome + ' ' + sobrenome AS nome_completo, salario
FROM funcionario
WHERE salario <= 2000

--Nome completo e salario de quem ganha entre 2000 e 3000
SELECT id, nome + ' ' + sobrenome AS nome_completo, salario
FROM funcionario
WHERE salario > 2000 AND salario < 3000

SELECT id, nome + ' ' + sobrenome AS nome_completo, salario
FROM funcionario
WHERE salario BETWEEN 2000 AND 3000

--Nome completo e salario de quem ganha menos que 2000 e mais que 3000
SELECT id, nome + ' ' + sobrenome AS nome_completo, salario
FROM funcionario
WHERE salario <= 2000 OR salario >= 3000

SELECT id, nome + ' ' + sobrenome AS nome_completo, salario
FROM funcionario
WHERE salario NOT BETWEEN 2000 AND 3000

SELECT id, nome + ' ' + sobrenome AS nome_completo, salario
FROM funcionario
WHERE nome != 'Fulano'

SELECT id, nome + ' ' + sobrenome AS nome_completo, salario
FROM funcionario
WHERE sobrenome <> 'De Souza'