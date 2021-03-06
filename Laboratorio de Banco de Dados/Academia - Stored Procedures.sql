/*Exercício
Criar uma database chamada academia, com 3 tabelas como seguem:

Aluno
|Codigo_aluno|Nome|

Atividade
|Codigo|Descrição|IMC|

Atividade
codigo      descricao                           imc
----------- ----------------------------------- --------
1           Corrida + Step                       18.5
2           Biceps + Costas + Pernas             24.9
3           Esteira + Biceps + Costas + Pernas   29.9
4           Bicicleta + Biceps + Costas + Pernas 34.9
5           Esteira + Bicicleta                  39.9                                                                                                                                                                    

Atividadesaluno
|Codigo_aluno|Altura|Peso|IMC|Atividade|

IMC = Peso (Kg) / Altura² (M)

Atividade: Buscar a PRIMEIRA atividade referente ao IMC imediatamente acima do calculado.
* Caso o IMC seja maior que 40, utilizar o código 5.

Criar uma Stored Procedure (sp_alunoatividades), com as seguintes regras:
 - Se, dos dados inseridos, o código for nulo, mas, existirem nome, altura, peso, deve-se inserir um 
 novo registro nas tabelas aluno e aluno atividade com o imc calculado e as atividades pelas 
 regras estabelecidas acima.
 - Se, dos dados inseridos, o nome for (ou não nulo), mas, existirem código, altura, peso, deve-se 
 verificar se aquele código existe na base de dados e atualizar a altura, o peso, o imc calculado e 
 as atividades pelas regras estabelecidas acima.
*/

CREATE DATABASE academia
GO
USE academia

CREATE TABLE Aluno(
codigo_aluno INT,
nome VARCHAR(100)
PRIMARY KEY(codigo_aluno)
)

CREATE TABLE Atividade(
codigo INT,
descricao VARCHAR(100),
imc DECIMAL(7,2)
PRIMARY KEY(codigo)
)

CREATE TABLE Atividades_Aluno(
codigo_aluno INT,
altura DECIMAL(7,2) NOT NULL,
peso DECIMAL(7,2) NOT NULL,
imc DECIMAL(7,2),
atividade INT
PRIMARY KEY(codigo_aluno, atividade)
FOREIGN KEY(codigo_aluno) REFERENCES Aluno(codigo_aluno),
FOREIGN KEY(atividade) REFERENCES Atividade(codigo)
)

INSERT INTO Atividade VALUES
(1, 'Corrida + Step', 18.5),
(2, 'Biceps + Costas + Pernas', 24.9),
(3, 'Esteira + Biceps + Costas + Pernas', 29.9),
(4, 'Bicicleta + Biceps + Costas + Pernas', 34.9),
(5, 'Esteira + Bicicleta', 39.9)



CREATE PROCEDURE sp_calcula_imc(@peso DECIMAL(7,2), @altura DECIMAL(7,2), @imc DECIMAL(7,2) OUTPUT)
AS
	SET @imc = @peso / (@altura * @altura)


CREATE PROCEDURE sp_prox_cod_aluno(@codigo INT OUTPUT)
AS
	DECLARE @count INT
	SET @count = (SELECT COUNT(*) FROM Aluno)
	IF (@count = 0)
	BEGIN
		SET @codigo = 1
	END
	ELSE
	BEGIN
		SET @codigo = (SELECT MAX(codigo_aluno) FROM Aluno) + 1
	END




CREATE PROCEDURE sp_verifica_aluno(@codigo_aluno INT, @return INT OUTPUT)
AS
	IF((SELECT a.codigo_aluno FROM Aluno a WHERE a.codigo_aluno = @codigo_aluno) IS NULL)
	BEGIN
		SET @return = 0		--Quer dizer que o aluno não existe no banco
	END
	ELSE
	BEGIN
		SET @return = 1		--Quer dizer que o aluno existe no banco
	END



CREATE PROCEDURE sp_calcula_atividade(@imc DECIMAL(7,2), @atividade INT OUTPUT)
AS
	IF(@imc >= 18.5 AND @imc < 24.9)
	BEGIN
		SET @atividade = 1
	END
	ELSE
	BEGIN
		IF(@imc >= 24.9 AND @imc < 29.9)
		BEGIN
			SET @atividade = 2
		END
		ELSE
		BEGIN
			IF(@imc >= 29.9 AND @imc < 34.9)
			BEGIN
				SET @atividade = 3
			END
			ELSE
			BEGIN
				IF(@imc >= 34.9 AND @imc < 39.9)
				BEGIN
					SET @atividade = 4
				END
				ELSE
				BEGIN
					SET @atividade = 5
				END
			END
		END
	END



CREATE PROCEDURE sp_alunoatividades(@nome VARCHAR(100), @codigo INT, @altura DECIMAL(7,2), @peso DECIMAL(7,2), @return VARCHAR(100) OUTPUT)
AS
	DECLARE @imc DECIMAL(7,2)
	DECLARE @atividade INT
	DECLARE @alunoExists INT
	DECLARE @codGenericoAluno INT

	IF( (@altura IS NOT NULL AND @altura > 0) AND (@peso IS NOT NULL AND @peso > 0) )
	BEGIN
		EXEC sp_calcula_imc @peso, @altura, @imc OUTPUT
		EXEC sp_calcula_atividade @imc, @atividade OUTPUT
		EXEC sp_verifica_aluno @codigo, @alunoExists OUTPUT

		IF(@codigo IS NULL AND @nome IS NOT NULL AND (@altura IS NOT NULL OR @altura > 0) AND (@peso IS NOT NULL OR @peso > 0))
		BEGIN
			EXEC sp_prox_cod_aluno @codGenericoAluno OUTPUT

			INSERT INTO Aluno VALUES(@codGenericoAluno, @nome)
			INSERT INTO Atividades_Aluno VALUES(@codGenericoAluno, @altura, @peso, @imc, @atividade)
			SET @return = 'Dados inseridos com sucesso'	
		END
		IF( (@nome IS NULL OR @nome IS NOT NULL) AND @codigo IS NOT NULL AND @altura IS NOT NULL AND @peso IS NOT NULL )
		BEGIN
			IF(@alunoExists = 0)
			BEGIN
				INSERT INTO Aluno VALUES(@codigo, @nome)
				INSERT INTO Atividades_Aluno VALUES(@codigo, @altura, @peso, @imc, @atividade)
				SET @return = 'Dados inseridos com sucesso'
			END
			ELSE
			BEGIN
				UPDATE Atividades_Aluno SET altura = @altura, peso = @peso, imc = @imc, atividade = @atividade WHERE codigo_aluno = @codigo
				SET @return = 'Dados atualizados com sucesso'
			END
		END
	END
	ELSE
	BEGIN
		IF((@altura IS NULL OR @altura <= 0) AND (@peso IS NULL OR @peso <= 0) )
		BEGIN
			RAISERROR('Valores da Altura e Peso inválidos', 16, 1)
		END
		ELSE
		BEGIN
			IF(@altura IS NULL OR @altura <= 0)
			BEGIN
				RAISERROR('Valor da Altura inválido', 16, 1)
			END
			ELSE
			BEGIN
				RAISERROR('Valor do peso inválido', 16, 1)
			END
		END
	END
	
	





DECLARE @out VARCHAR(100)
EXEC sp_alunoatividades 'Vitor Hugo', NULL, 1.70, 65, @out OUTPUT
PRINT @out

SELECT * FROM Aluno
SELECT * FROM Atividades_Aluno


DELETE Atividades_Aluno
DELETE Aluno

