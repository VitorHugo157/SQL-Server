/*TRIGGERS - GATILHOS*/

--AFTER(FOR) | INSTEAD OF* | BEFORE**

/*
TRIGGER AFTER
CREATE TRIGGER t_nome ON tabela
FOR INSERT, UPDATE, DELETE
AS
	programação
	
TRIGGER INSTEAD OF
CREATE TRIGGER t_nome ON tabela
INSTEAD OF INSERT, UPDATE, DELETE
AS
	programação
*/

/*
As TRIGGER geram tabelas temporárias chamadas
INSERTED e DELETED
*/

/*
DISABLE TRIGGER t_nome ON tabela
ENABLE TRIGGER t_nome ON tabela
*/

CREATE DATABASE aulatriggers01
GO
USE aulatriggers01

CREATE TABLE servico(
id		INT NOT NULL,
nome	VARCHAR(100),
preco	DECIMAL(7,2)
PRIMARY KEY(id))

CREATE TABLE depto(
codigo			INT not null,
nome			VARCHAR(100),
total_salarios	DECIMAL(7,2)
PRIMARY KEY(codigo))

CREATE TABLE funcionario(
id		INT NOT NULL,
nome	VARCHAR(100),
salario DECIMAL(7,2),
depto	INT NOT NULL
PRIMARY KEY(id)
FOREIGN KEY (depto) REFERENCES depto(codigo))

INSERT INTO servico VALUES
(1, 'Orçamento', 20.00),
(2, 'Manutenção preventiva', 85.00)

INSERT INTO depto (codigo, nome) VALUES
(1,'RH'),
(2,'DTI')

SELECT * FROM servico
SELECT * FROM depto
SELECT * FROM funcionario

--Exemplos:
--1) Como ficam as tabelas INSERTED e DELETED a cada operação em servico ?
CREATE TRIGGER t_serv ON servico
FOR INSERT, UPDATE, DELETE
AS
BEGIN
	SELECT * FROM INSERTED
	SELECT * FROM DELETED
END

INSERT INTO servico VALUES
(3, 'Limpeza', 50.00)

UPDATE servico
SET preco = 50.00
WHERE id = 3

DELETE servico 
WHERE id = 3

DROP TRIGGER t_serv

--2) Em serviço, não pode deletar registros
CREATE TRIGGER t_blockdelserv ON servico
FOR DELETE
AS
BEGIN
	ROLLBACK TRANSACTION
	RAISERROR('Não é permitido excluir registros de serviços', 16, 1)
END

DISABLE TRIGGER t_blockdelserv ON servico
ENABLE TRIGGER t_blockdelserv ON servico

--3) Em serviço, ao atualizar os valores, não pode atualizar para valores menores
CREATE TRIGGER t_updtrule ON servico
AFTER UPDATE
AS
BEGIN
	DECLARE @preco_velho	DECIMAL(7,2),
			@preco_novo		DECIMAL(7,2)

	SET @preco_velho = (SELECT preco FROM DELETED)
	SET @preco_novo = (SELECT preco FROM INSERTED)

	IF (@preco_novo < @preco_velho)
	BEGIN
		ROLLBACK TRANSACTION
		RAISERROR('Preço atual deve ser maior que o preço antigo', 16, 1)
	END
END

--4) A cada inserção, atualização ou exclusão de funcionário, o total_salarios do
--   depto deve ser atualizado (aumentado ou diminuído). Cuidado com o início da 
--   database que iniciam os total_salario com NULL
CREATE TRIGGER t_sal_func_depto ON funcionario
FOR INSERT, UPDATE, DELETE
AS
BEGIN
	DECLARE @salario	DECIMAL(7,2),
			@cont_ins	INT,
			@cont_del	INT,
			@depto		INT

	SET @salario = 0.00
	SET @cont_ins = (SELECT COUNT(*) FROM INSERTED)
	SET @cont_del = (SELECT COUNT(*) FROM DELETED)

	IF (@cont_ins > 0)
	BEGIN
		SET @salario = @salario + (SELECT salario FROM INSERTED)
		SET @depto = (SELECT depto FROM INSERTED)
	END
	IF (@cont_del > 0)
	BEGIN
		SET @salario = @salario - (SELECT salario FROM DELETED)
		IF (@depto IS NULL)
		BEGIN
			SET @depto = (SELECT depto FROM DELETED)
		END
	END

	IF ((SELECT total_salarios FROM depto WHERE codigo = @depto) IS NULL)
	BEGIN
		UPDATE depto
		SET total_salarios = @salario
		WHERE codigo = @depto
	END
	ELSE
	BEGIN
		UPDATE depto
		SET total_salarios = total_salarios + @salario
		WHERE codigo = @depto
	END
END

CREATE TRIGGER t_sal_func_depto ON funcionario
FOR INSERT, UPDATE, DELETE
AS
BEGIN
	DECLARE @salario	DECIMAL(7,2),
			@cont_ins	INT,
			@cont_del	INT,
			@depto		INT

	SET @salario = 0.00
	SET @cont_ins = (SELECT COUNT(*) FROM INSERTED)
	SET @cont_del = (SELECT COUNT(*) FROM DELETED)

	IF (@cont_ins > 0)
	BEGIN
		SET @salario = @salario + (SELECT salario FROM INSERTED)
		SET @depto = (SELECT depto FROM INSERTED)
	END
	IF (@cont_del > 0)
	BEGIN
		SET @salario = @salario - (SELECT salario FROM DELETED)
		IF (@depto IS NULL)
		BEGIN
			SET @depto = (SELECT depto FROM DELETED)
		END
	END

	IF ((SELECT total_salarios FROM depto WHERE codigo = @depto) IS NULL)
	BEGIN
		UPDATE depto
		SET total_salarios = 0.00
		WHERE codigo = @depto AND total_salarios IS NULL
	END

	UPDATE depto
	SET total_salarios = total_salarios + @salario
	WHERE codigo = @depto

END

INSERT INTO funcionario VALUES
(1001, 'Fulano de Tal', 3579.99, 1)

UPDATE funcionario
SET salario = 4579.99
WHERE id = 1001

INSERT INTO funcionario VALUES
(1002, 'Beltrano de Tal', 2000.00, 1)

INSERT INTO funcionario VALUES
(1003, 'Cicrano de Tal', 1000.00, 1)

SELECT * FROM funcionario
SELECT * FROM depto
DELETE funcionario

--5) Não se pode fazer atualizações ou exclusões na tabela depto.
--   Ao invés de fazer atualizações ou exclusões, mostrar o select da tabela
CREATE TRIGGER t_instof_updt_del_depto ON depto
INSTEAD OF UPDATE, DELETE
AS
BEGIN
	SELECT * FROM depto
END

DELETE depto
WHERE codigo = 1

UPDATE depto
SET nome = 'Baita RH'
WHERE codigo = 1