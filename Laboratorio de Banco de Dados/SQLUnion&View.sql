CREATE DATABASE unionview
GO
USE unionview

CREATE TABLE cliente (
id_cliente			INT				NOT NULL,
nome_cliente		VARCHAR(40)		NOT NULL,
email_cliente		VARCHAR(50)		NOT NULL,
telefone_cliente	CHAR(11)		NOT NULL,
cod_cliente			INT				NOT NULL
PRIMARY KEY (id_cliente))

CREATE TABLE fornecedor (
id_fornecedor		INT				NOT NULL,
nome_fornecedor		VARCHAR(40)		NOT NULL,
email_fornecedor	VARCHAR(50)		NOT NULL,
telefone_fornecedor	CHAR(11)		NOT NULL,
cod_fornecedor		VARCHAR(3)		NOT NULL
PRIMARY KEY (id_fornecedor))

CREATE TABLE funcionario (
id_func			INT				NOT NULL,
nome_func		VARCHAR(100)	NOT NULL,
salario_func	DECIMAL(7,2)	NULL,
login_func		CHAR(8)			NULL	CHECK(LEN(login_func) = 8),
senha_func		CHAR(8)			NULL	CHECK(LEN(senha_func) = 8)
PRIMARY KEY (id_func))


INSERT INTO cliente VALUES 
(1001, 'Cliente 1', 'cli1@email.com', '11987654321', 123),
(1002, 'Cliente 2', 'cli2@email.com', '11912837465', 124),
(1003, 'Cliente 3', 'cli3@email.com', '11932569874', 125),
(1004, 'Cliente 4', 'cli4@email.com', '11912458632', 126),
(1005, 'Cliente 5', 'cli5@email.com', '11902365400', 127)

INSERT INTO fornecedor VALUES 
(1001, 'Fornecedor 1', 'forn1@email.com', '11977889966', '12A'),
(1002, 'Fornecedor 2', 'forn2@email.com', '11933669988', '12B'),
(1003, 'Fornecedor 3', 'forn3@email.com', '11911220044', '12C'),
(1004, 'Fornecedor 4', 'forn4@email.com', '11933654477', '12D'),
(1005, 'Fornecedor 5', 'forn5@email.com', '11933001177', '12E')

INSERT INTO funcionario VALUES
(101, 'Fulano de Tal', 7580.00, 'fula1234', 'mudar123')

SELECT * FROM cliente
SELECT * FROM fornecedor
SELECT * FROM funcionario

--UNION
/*
SELECTS com o mesmo número de colunas, 
colunas do mesmo TIPO e 
colunas com o mesmo nome

Não ordena os selects parciais

UNION - Descarta linhas iguais nos 2 selects
UNION ALL - Mostra todas as linhas, mesmo as repetidas
*/
SELECT id_cliente AS id, nome_cliente AS nome, 
		email_cliente AS email, telefone_cliente AS telefone,
		CAST(cod_cliente AS VARCHAR(3)) AS cod, 'CLIENTE' AS tipo
FROM cliente
UNION
SELECT id_fornecedor, nome_fornecedor, 
		email_fornecedor, telefone_fornecedor,
		cod_fornecedor, 'FORNECEDOR'
FROM fornecedor
ORDER BY id

ALTER TABLE cliente
ALTER COLUMN telefone_cliente BIGINT

--VIEW
/*
Abstração de uma consulta, dando a impressão que
se trata de uma consulta em uma tabela

DDL
CREATE VIEW - Cria view
ALTER VIEW - Modifica view
DROP VIEW - Exclui view

Não coloco order na view
*/
CREATE VIEW v_agenda
AS
SELECT id_cliente AS id, nome_cliente AS nome, 
		email_cliente AS email, telefone_cliente AS telefone,
		CAST(cod_cliente AS VARCHAR(3)) AS cod, 'CLIENTE' AS tipo
FROM cliente
UNION
SELECT id_fornecedor, nome_fornecedor, 
		email_fornecedor, telefone_fornecedor,
		cod_fornecedor, 'FORNECEDOR'
FROM fornecedor


SELECT id, nome, email, telefone, tipo 
	FROM v_agenda
	ORDER BY id

CREATE VIEW v_ti
AS
SELECT id_func, nome_func, login_func, senha_func
	FROM funcionario

CREATE VIEW v_rh
AS
SELECT id_func, nome_func, salario_func
	FROM funcionario

SELECT * FROM v_ti
SELECT * FROM v_rh

INSERT INTO v_rh VALUES
(102, 'Beltrano de Tal', 8500.00)

--Dá erro
INSERT INTO v_ti VALUES
(102, 'Beltrano de Tal', 'belt1234', 'mudar123')

--Funciona
UPDATE v_ti
SET login_func = 'belt1234', senha_func = 'mudar123'
WHERE id_func = 102

BACKUP DATABASE unionview
TO DISK = '/var/opt/mssql/data/uv.bak' 