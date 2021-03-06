--Modularização
--Procedimentos (Stored Procedures) - Retornos escalares em tipo definido
--Funções (UDF - User Defined Functions) - Retorna ResultSet

--Stored Procedures
--Sintaxes DML e DDL
--Call de outra procedure
--Select de query, view, UDF

/*
CREATE(ALTER | DROP) PROCEDURE sp_nome (parâmetros de ent. e sai.)
AS
	programação
*/
/* CALL PROCEDURE
	Padrão SQL	- CALL sp_nome(param.)
	SQL SERVER	- EXEC sp_nome param.
	Oracle		- EXECUTE sp_nome param.
*/
/*RAISE APPLICATION ERROR
	SQL SERVER	- RAISERROR('Msg Exception', 16, 1)
	Oracle		- RAISE_APPLICATION_ERROR
*/

CREATE DATABASE procedimento
GO
USE procedimento

CREATE TABLE pessoa(
codigo INT NOT NULL,
nome VARCHAR(100),
telefone VARCHAR(15),
PRIMARY KEY(codigo))

CREATE PROCEDURE sp_prox_cod_pessoa(@cod INT OUTPUT)
AS
	DECLARE @count INT
	SET @count = (SELECT COUNT(*) FROM pessoa)
	IF (@count = 0)
	BEGIN
		SET @cod = 1
	END
	ELSE
	BEGIN
		SET @cod = (SELECT MAX(codigo) FROM pessoa) + 1
	END

CREATE PROCEDURE sp_iud_pessoa(@acao CHAR(1), @codigo INT, @nome VARCHAR(100),
	@telefone VARCHAR(100), @saida VARCHAR(MAX) OUTPUT)
AS
	--DECLARE variaveis locais
	DECLARE @prox_cod INT
	IF (UPPER(@acao) = 'I' OR UPPER(@acao) = 'U' OR UPPER(@acao) = 'D')
	BEGIN
		IF (LEN(@telefone) = 9 AND @codigo > 0)
		BEGIN
			IF (UPPER(@acao) = 'I')
			BEGIN
				EXEC sp_prox_cod_pessoa @prox_cod OUTPUT

				INSERT INTO pessoa 
				VALUES (@prox_cod, @nome, @telefone)

				SET @saida = 'Pessoa inserida com sucesso'
			END
			ELSE
			BEGIN
				IF (UPPER(@acao) = 'U')
				BEGIN
					UPDATE pessoa
					SET nome = @nome, @telefone = telefone
					WHERE codigo = @codigo

					SET @saida = 'Pessoa atualizada com sucesso'
				END
				ELSE
				BEGIN
					DELETE pessoa 
					WHERE codigo = @codigo

					SET @saida = 'Pessoa excluida com sucesso'
				END
			END
		END
		ELSE
		BEGIN
			--Tratamento de erro telefone com quantidade inválida de dígitos
			--Tratamento de erro de código negativo
			IF (@codigo <= 0)
			BEGIN
				RAISERROR('Codigo de pessoa invalido', 16, 1)
			END
			ELSE
			BEGIN
				RAISERROR('Telefone invalido', 16, 1)
			END
		END
	END
	ELSE
	BEGIN
		--Tratamento de erro de ação inválida
		RAISERROR('Operacao invalida', 16, 1)
	END

--Telefone inválido
DECLARE @out VARCHAR(MAX)
EXEC sp_iud_pessoa 'I', 1, 'Fulano', '132', @out OUTPUT
PRINT @out

--Ação inválida
DECLARE @out VARCHAR(MAX)
EXEC sp_iud_pessoa 'K', 1, 'Fulano', '132', @out OUTPUT
PRINT @out

--Código inválido
DECLARE @out VARCHAR(MAX)
EXEC sp_iud_pessoa 'I', -1, 'Fulano', '132', @out OUTPUT
PRINT @out

--Insert de pessoa válida
DECLARE @out VARCHAR(MAX)
EXEC sp_iud_pessoa 'I', 100000, 'Fulano', '923454567', @out OUTPUT
PRINT @out

--Insert de outra pessoa válida
DECLARE @out VARCHAR(MAX)
EXEC sp_iud_pessoa 'I', 100000, 'Cicrano', '956787894', @out OUTPUT
PRINT @out

--Update de pessoa válida
DECLARE @out VARCHAR(MAX)
EXEC sp_iud_pessoa 'U', 1, 'Fulano dos Santos', '923454567', @out OUTPUT
PRINT @out

--Delete de pessoa válida
DECLARE @out VARCHAR(MAX)
EXEC sp_iud_pessoa 'D', 1, 'Fulano dos Santos', '923454567', @out OUTPUT
PRINT @out

SELECT * FROM pessoa



--Tabela temporária (# local, só o usuário vê - ## global, todos os usuários tem acesso)
CREATE TABLE #tabela (
col1	tipo,
col2	tipo
)