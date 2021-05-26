/*Um campeonato de basquete tem times que são cadastrados por um id único, 
que começa em 4001 e incrementa de 1 em 1, o nome do time que também deve ser 
único, a cidade e a Data de fundação que não é obrigatória. 
Um time tem muitos jogadores, porém 1 jogador só pode jogar 
em 1 time e os jogadores são cadastrados por um código único que inicia 
em 900101, incrementa de 1 em 1, o nome do jogador deve ser único também, 
sexo pode apenas ser M ou F, mas a maioria dos jogadores é Homem, 
altura com 2 casas decimais e a data de nascimento 
(apenas jogadores nascidos até 31/12/1999). 
Jogadores do sexo masculino devem ter, no mínimo 1.70 de altura e do sexo 
feminino, 1.60).
*/
CREATE DATABASE campeonatobasquete
GO
USE campeonatobasquete

CREATE TABLE times(
id			INT				NOT NULL	IDENTITY(4001,1),
nome		VARCHAR(50)		NOT NULL	UNIQUE,
cidade		VARCHAR(80)		NOT NULL,
dt_fundacao	DATE			NULL
PRIMARY KEY(id)
)

CREATE TABLE jogador(
codigo		INT				NOT NULL	IDENTITY(900101,1),
nome		VARCHAR(50)		NOT NULL	UNIQUE,
sexo		CHAR(1)			NULL		DEFAULT('M') CHECK(sexo='M' OR sexo='F'),
altura		DECIMAL(4,2)	NOT NULL,
dt_nasc		DATE			NOT NULL	CHECK(dt_nasc <= '1999-12-31'),
qtd_premios	INT				NOT NULL,
id_time		INT				NOT NULL
PRIMARY KEY (codigo)
FOREIGN KEY (id_time) REFERENCES times(id),
CONSTRAINT chk_sx_alt 
	CHECK((sexo='M' AND altura >= 1.70) OR (sexo='F' AND altura >= 1.60))
)

DROP TABLE jogador

EXEC sp_help times
EXEC sp_help jogador

--DML
--INSERT, SELECT, UPDATE, DELETE (CRUD)

--INSERT INTO tabela (col1, col2, col3)
--VALUES(d1, d2, d3)
/*Exemplo 1:
INSERT INTO times
VALUES(1, 'Bills', 'São Roque', '01/01/1995')
*/
INSERT INTO times (nome, cidade, dt_fundacao)
VALUES('Bills', 'São Roque', '01/01/1995')

INSERT INTO times (nome, cidade, dt_fundacao)
VALUES('Cows', 'São Roque', '1995-13-05')

INSERT INTO times (nome, cidade, dt_fundacao)
VALUES('Cows', 'São Roque', '1997-09-18')

INSERT INTO times(nome, cidade, dt_fundacao)
VALUES
('Axes', 'Pardinho', NULL),
('Rockets', 'Botucatu', '2001-05-18'),
('Rocks', 'Avaré', NULL)

INSERT INTO times(nome, cidade, dt_fundacao)
VALUES ('Axes', 'Pardinho', NULL)

INSERT INTO times(nome, cidade, dt_fundacao)
VALUES ('Axes', 'Pardinho', NULL)

INSERT INTO times(nome, cidade, dt_fundacao)
VALUES ('Eatrhquakes', 'SBC', NULL)

--SELECT
SELECT * FROM times

--DELETE
--DELETE tabela WHERE col = valor
DELETE times 
WHERE id = 4007

DELETE times 
WHERE id = 4002

DELETE times

--TRUNCATE TABLE (DROP TABLE + CREATE TABLE)
TRUNCATE TABLE times

--Restaura o passo do auto incremento
--DBCC Checkident(tabela, reseed, valor_de_reinicio)
DBCC Checkident(times, reseed, 4006)

--UPDATE
/*
UPDATE tabela
SET col = novo_valor
WHERE condicao
*/

INSERT INTO jogador(nome, altura, dt_nasc, qtd_premios, id_time)
VALUES ('Michael Jordan', 2.01, '1985-12-01', 0, 4001)

INSERT INTO jogador(nome, altura, dt_nasc, qtd_premios, id_time)
VALUES ('Magic Johnson', 1.99, '1982-04-11', 2, 4001)

SELECT * FROM jogador

TRUNCATE TABLE jogador

UPDATE jogador
SET nome = 'MJ'
WHERE codigo = 900102

--Solução 1
UPDATE jogador
SET qtd_premios = qtd_premios + 1
WHERE codigo = 900102

UPDATE jogador
SET qtd_premios = qtd_premios + 1
WHERE codigo = 900103

--Solução 2
UPDATE jogador
SET qtd_premios = qtd_premios + 1
WHERE codigo = 900102 OR codigo = 900103

--Solução 3
UPDATE jogador
SET qtd_premios = qtd_premios + 1
WHERE codigo >= 900102

UPDATE jogador 
SET altura = 2.03, dt_nasc = '1984-05-05'
WHERE codigo = 900102