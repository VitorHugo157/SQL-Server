CREATE DATABASE udf
GO
USE udf

CREATE TABLE Funcionario(
codigo INT NOT NULL,
nome VARCHAR(100),
salario DECIMAL(7,2)
PRIMARY KEY(codigo)
)

INSERT INTO Funcionario VALUES
(001, 'José da Silva', 1600.00),
(002, 'Felipe Souza', 1950.00),
(003, 'Rafaela Rosa', 1800.00)

CREATE TABLE Dependente(
codigo_dependente INT NOT NULL IDENTITY,
codigo_funcionario INT NOT NULL,
nome_dependente VARCHAR(100),
salario_dependente DECIMAL(7,2)
PRIMARY KEY(codigo_dependente, codigo_funcionario)
FOREIGN KEY(codigo_funcionario) REFERENCES Funcionario(codigo)
)

INSERT INTO Dependente VALUES
(001, 'Beatris do Santos', 1400.00),
(002, 'Kaellen Vieira', 1350.00),
(003, 'Agata Santos', 1500.00),
(003, 'Sheila da Silva', 1450.00)

CREATE FUNCTION fn_funcDependente()
RETURNS @table TABLE(
nome_funcionario VARCHAR(100),
nome_dependente VARCHAR(100),
salario_funcionario DECIMAL(7,2),
salario_dependente DECIMAL(7,2)
)
AS
BEGIN
	INSERT INTO @table
		SELECT f.nome AS nome_funcionario, d.nome_dependente AS nome_dependente, 
			f.salario AS salario_funcionario, d.salario_dependente AS salario_dependente
		FROM Funcionario f INNER JOIN Dependente d
		ON f.codigo = d.codigo_funcionario

	RETURN
END

CREATE FUNCTION fn_calcSalario(@cod_funcionario INT)
RETURNS DECIMAL(7,2)
AS
BEGIN
	DECLARE @salarioTotal DECIMAL(7,2)
	
	SELECT @salarioTotal = salario FROM Funcionario WHERE codigo = @cod_funcionario

	SELECT @salarioTotal = @salarioTotal + SUM(salario_dependente) FROM Dependente WHERE codigo_funcionario = @cod_funcionario

	RETURN (@salarioTotal)
END

SELECT * FROM fn_funcDependente()
SELECT dbo.fn_calcSalario(3) AS SALARIO_TOTAL
