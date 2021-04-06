CREATE DATABASE functions2
GO
USE functions2

CREATE TABLE aluno (
cod		INT NOT NULL,
nome	VARCHAR(100),
altura	DECIMAL(7,2),
peso	DECIMAL(7,2)
PRIMARY KEY(cod))

INSERT INTO aluno VALUES 
(1, 'Fulano', 1.7, 100.2),
(2, 'Cicrano', 1.92, 107.1),
(3, 'Beltrano', 1.83, 76.0)

SELECT * FROM aluno

/*User Defined Functions (UDF)
-Tipos:
	- Scalar Function (Ret. Var. Escalar)
	- Inline Table (Assemelha a Views, pouco utilizadas)(Ret. Table)
	- Multi Statement Tables* (Ret. Table)

Em SGBDs como o Oracle, só existe o retorno escalar,
nesse caso, deve-se criar um objeto tipo tabela, fazer um pipe do 
retorno para o objeto e a UDF retorna o objeto

- Não permite DDL
- Não permite Raise Error
- Retorna ResultSet (Acessado por selects)
- Pode fazer joins com selects de tabelas comuns ou views
*/

/*SINTAXE:
CREATE FUNCTION fn_nome(param)
RETURNS tipo
AS
BEGIN
	programação
	RETURN 
END

Scalar:
SELECT dbo.fn_nome(param)
SELECT dbo.fn_nome()

Multi Statement Table:
SELECT * FROM fn_nome(param)
SELECT * FROM fn_nome()

*/

--Ex.1: Fazer uma função escalar da Database acima que, dado o 
--código de um aluno, retornar seu imc (peso/alt²)
CREATE FUNCTION fn_calcimc(@cod INT)
RETURNS DECIMAL(7,2)
AS
BEGIN
	DECLARE @alt	DECIMAL(7,2),
			@peso	DECIMAL(7,2),
			@imc	DECIMAL(7,2)
	IF (@cod > 0)
	BEGIN
--		SET @alt = (SELECT altura FROM aluno WHERE cod = @cod)
--		SET @peso = (SELECT peso FROM aluno WHERE cod = @cod)
		SELECT @alt = altura, @peso = peso FROM aluno
			WHERE cod = @cod
		SET @imc = @peso / POWER(@alt, 2)
--		SELECT @imc = @peso / POWER(@alt, 2) FROM aluno WHERE cod = @cod
	END
	RETURN (@imc)
END

SELECT dbo.fn_calcimc(1) AS imc

/*Ex.2: Fazer uma função Multi Statement Table que retorne:
cod			int
nome		varchar
altura		decimal
peso		decimal
imc			decimal
condicao	varchar

Condição:
Classificação			IMC
Muito abaixo do peso	abaixo de 16,9 kg/m2	
Abaixo do peso			17 a 18,4 kg/m2	
Peso normal				18,5 a 24,9 kg/m2
Acima do peso			25 a 29,9 kg/m2	
Obesidade Grau I		30 a 34,9 kg/m2	
Obesidade Grau II		35 a 40 kg/m2		
Obesidade Grau III		acima de 40 kg/m2
*/

CREATE FUNCTION fn_alunoimc()
RETURNS @table TABLE (
cod			INT,
nome		VARCHAR(100),
altura		DECIMAL(7,2),
peso		DECIMAL(7,2),
imc			DECIMAL(7,2),
situacao	VARCHAR(100)
)
AS
BEGIN
	INSERT INTO @table (cod, nome, altura, peso)
		SELECT cod, nome, altura, peso FROM aluno

	UPDATE @table
		SET imc = (SELECT dbo.fn_calcimc(cod))

	UPDATE @table
		SET situacao = 'Muito Abaixo do Peso'
		WHERE imc < 17
	UPDATE @table
		SET situacao = 'Abaixo do Peso'
		WHERE imc >= 17 AND imc < 18.5
	UPDATE @table
		SET situacao = 'Peso Normal'
		WHERE imc >= 18.5 AND imc < 25
	UPDATE @table
		SET situacao = 'Acima do Peso'
		WHERE imc >= 25 AND imc < 30	
	UPDATE @table
		SET situacao = 'Obesidade Grau I'
		WHERE imc >= 30 AND imc < 35	
	UPDATE @table
		SET situacao = 'Obesidade Grau II'
		WHERE imc >= 35 AND imc < 40
	UPDATE @table
		SET situacao = 'Obesidade Grau III'
		WHERE imc >= 40

	RETURN
END

SELECT * FROM fn_alunoimc()

SELECT nome, CAST(imc AS INT) AS imc, situacao FROM fn_alunoimc()

SELECT nome, imc, situacao FROM fn_tabelaimc()
WHERE cod > 2


CREATE TABLE exercicios (
imc			INT				NOT NULL,
exercicio	VARCHAR(100)
PRIMARY KEY (imc))

INSERT INTO exercicios VALUES 
(22, 'Supino'),
(34, 'Bicicleta Ergométrica')

SELECT al.nome, CAST(al.imc AS INT) AS imc, al.situacao, ex.exercicio
FROM fn_alunoimc() al, exercicios ex
WHERE CAST(al.imc AS INT) = ex.imc

SELECT al.nome, CAST(al.imc AS INT) AS imc, al.situacao, ex.exercicio
FROM fn_alunoimc() al INNER JOIN exercicios ex
ON CAST(al.imc AS INT) = ex.imc

--Exemplo cópia de dados de uma tabela para outra
CREATE TABLE #temp_aluno (
cod		INT NOT NULL,
nome	VARCHAR(100),
altura	DECIMAL(7,2),
peso	DECIMAL(7,2)
PRIMARY KEY(cod))

INSERT INTO #temp_aluno
	SELECT cod, nome, altura, peso FROM aluno

SELECT * FROM #temp_aluno
SELECT * FROM fn_tabelaimc()

