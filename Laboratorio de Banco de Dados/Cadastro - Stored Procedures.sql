CREATE DATABASE Cadastro
GO
USE Cadastro

CREATE TABLE Pessoa(
cpf CHAR(11) NOT NULL,
nome VARCHAR(80) NOT NULL
PRIMARY KEY(cpf)
)


--Procedure que verifica se o CPF está com números iguais
CREATE PROCEDURE sp_isCpfComNumerosIguais(@cpf CHAR(11), @result INT OUTPUT)
AS
	DECLARE @CpfValido INT, @cont INT
	SET @CpfValido = 1
	SET @cont = 2

	WHILE (@cont <= LEN(@cpf))
	BEGIN
		IF (SUBSTRING(@cpf, @cont, 1) = SUBSTRING(@cpf, @cont - 1, 1))
		BEGIN
			SET @CpfValido = @CpfValido + 1
			SET @cont = @cont + 1
		END
		ELSE
		BEGIN
			SET @cont = @cont + 1
		END
	END

	IF (@CpfValido = LEN(@cpf))
	BEGIN
		SET @result = 1
	END
	ELSE
	BEGIN
		SET @result = 0
	END


--Procedure que verifica se o CPF é válido, de acordo com os dígitos verificadores
CREATE PROCEDURE sp_isCpfValido(@cpf CHAR(11), @result INT OUTPUT)
AS
	DECLARE
			@cpfVerificado CHAR(11),
			@cont2 INT,
			@digitoVerificador VARCHAR(2),
			@calc INT,
			@soma INT,
			@aux INT,
			@aux2 INT,
			@cont INT

	SET @soma = 0
	SET @cont = 10
	SET @cont2 = 1
	WHILE (@cont >= 2)
	BEGIN
		SET @aux = CONVERT(INT, SUBSTRING(@cpf, @cont2, 1))
		SET @soma = @soma + (@aux * @cont)
		SET @cont = @cont - 1
		SET @cont2 = @cont2 + 1
	END
	SET @calc = @soma % 11
	IF (@calc < 2)
	BEGIN
		SET @digitoVerificador = @digitoVerificador + '0'
	END
	ELSE
	BEGIN
		SET @aux2 = 11 - @calc
		SET @digitoVerificador = CAST(@aux2 AS CHAR(1))
	END

	SET @cont = 11
	SET @cont2 = 1
	SET @soma = 0
	WHILE (@cont >= 2)
	BEGIN
		SET @aux = CONVERT(INT, SUBSTRING(@cpf, @cont2, 1))
		SET @soma = @soma + (@aux * @cont)
		SET @cont = @cont - 1
		SET @cont2 = @cont2 + 1
	END
	SET @calc = @soma % 11
	IF (@calc < 2)
	BEGIN
		SET @digitoVerificador = @digitoVerificador + '0'
	END
	ELSE
	BEGIN
		SET @aux2 = 11 - @calc
		SET @digitoVerificador = @digitoVerificador + CAST(@aux2 AS CHAR(1))
	END
	SET @cpfVerificado = SUBSTRING(@cpf, 1, 9) + @digitoVerificador
	IF (@cpfVerificado = @cpf)
	BEGIN
		SET @result = 1
	END
	ELSE
	BEGIN
		SET @result = 0
	END


--Procedure que insere dados na tabela Pessoa
CREATE PROCEDURE sp_insere_pessoa (@cpf CHAR(11), @nome VARCHAR(80), @saida VARCHAR(100) OUTPUT)
AS
	IF (LEN(@cpf) = 11 AND LEN(@nome) > 0)
	BEGIN
		--Verificar se o cpf contém números iguais
		DECLARE @isCpfComNumIguais INT
		EXEC sp_isCpfComNumerosIguais @cpf, @isCpfComNumIguais OUTPUT
		
		IF (@isCpfComNumIguais = 1)
		BEGIN
			RAISERROR('CPF com números iguais, é inválido', 16, 1)
		END
		ELSE
		BEGIN
			--Se o cpf não conter números iguais
			--Verificar se o cpf é válido
			DECLARE @isCpfValido INT
			EXEC sp_isCpfValido @cpf, @isCpfValido OUTPUT

			IF (@isCpfValido = 1)
			BEGIN
				--Se o cpf verificado for válido
				INSERT INTO Pessoa
				VALUES (@cpf, @nome)
				
				SET @saida = 'Pessoa inserida com sucesso'
			END
			ELSE
			BEGIN
				--Caso o cpf verificado for inválido
				RAISERROR('CPF verificado da pessoa é inválido', 16, 1)
			END
		END
	END
	ELSE
	BEGIN
		--Tratamento de erro caso cpf ou nome estiver com qtd invalida de digitos
		IF (LEN(@cpf) < 11)
		BEGIN
			RAISERROR('CPF da pessoa inválido', 16, 1)
		END
		ELSE
		BEGIN
			RAISERROR('Nome da pessoa inválido', 16, 1)
		END
	END

--Insere pessoa com CPF em branco
DECLARE @out VARCHAR(100)
EXEC sp_insere_pessoa '', 'Vitor Hugo', @out OUTPUT
PRINT @out

--Insere pessoa com CPF com números iguais
DECLARE @out VARCHAR(100)
EXEC sp_insere_pessoa '11111111111', 'Vitor Hugo', @out OUTPUT
PRINT @out

--Insere pessoa com qtd de digitos do CPF inválida
DECLARE @out VARCHAR(100)
EXEC sp_insere_pessoa '123456', 'Vitor Hugo', @out OUTPUT
PRINT @out

--Insere pessoa com Nome em branco
DECLARE @out VARCHAR(100)
EXEC sp_insere_pessoa '12345678910', '', @out OUTPUT
PRINT @out

--Insere pessoa com CPF e nome válidos
DECLARE @out VARCHAR(100)
EXEC sp_insere_pessoa '22233366638', 'Vitor Hugo', @out OUTPUT
PRINT @out

SELECT * FROM Pessoa
