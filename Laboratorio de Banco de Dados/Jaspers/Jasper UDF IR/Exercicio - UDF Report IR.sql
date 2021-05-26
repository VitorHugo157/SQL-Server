CREATE DATABASE udfReport
GO
USE udfReport

GO
CREATE TABLE Natureza_Rendimento(
id INT NOT NULL IDENTITY,
natureza VARCHAR(15) NOT NULL
PRIMARY KEY(id)
)

GO
CREATE TABLE Funcionario(
cpf CHAR(11) NOT NULL,
nome VARCHAR(100) NOT NULL,
idNaturezaRendimento INT NOT NULL
PRIMARY KEY(cpf)
FOREIGN KEY(idNaturezaRendimento) REFERENCES Natureza_Rendimento(id)
)

GO
CREATE TABLE Tipo_rendimento(
id INT NOT NULL IDENTITY,
tipo VARCHAR(30) NOT NULL
PRIMARY KEY(id)
)

GO
CREATE TABLE Rendimentos(
cpfFuncionario CHAR(11) NOT NULL,
dataRendimento DATE NOT NULL,
valor DECIMAL(7,2) NOT NULL,
idTipoRendimento INT NOT NULL
PRIMARY KEY(cpfFuncionario, dataRendimento, idTipoRendimento)
FOREIGN KEY(cpfFuncionario) REFERENCES Funcionario(cpf),
FOREIGN KEY(idTipoRendimento) REFERENCES Tipo_Rendimento(id)
)

GO
INSERT INTO Natureza_Rendimento VALUES
('Salário'),
('Pensão')

GO
INSERT INTO Tipo_rendimento VALUES
('Previdência (INSS)'),
('Imposto Retido na Fonte'),
('Salário Bruto'),
('Décimo Terceiro'),
('Imposto Retido sobre o 13º')

GO
INSERT INTO Funcionario VALUES
('11111111111', 'Maria', 1),
('22222222222', 'José', 1),
('33333333333', 'Tio Cláudio', 1),
('44444444444', 'Sr. Revoada', 1)

GO
INSERT INTO Rendimentos VALUES
('11111111111', '05/01/2020', 3000.00, 3),
('22222222222', '05/01/2020', 5100.00, 3),
('33333333333', '05/01/2020', 6500.00, 3),
('44444444444', '05/01/2020', 2500.00, 3)

GO
CREATE FUNCTION fn_informeRendimentos(@cpf CHAR(11))
RETURNS @table TABLE(
cpf CHAR(11),
nome VARCHAR(100),
naturezaRendimento VARCHAR(15),
salarioBruto DECIMAL(7,2),
contribuicaoPrevidencia DECIMAL(7,2),
irf DECIMAL(7,2),
decimoTerceiro DECIMAL(7,2),
irfDecimoTerceiro DECIMAL(7,2)
)
AS
BEGIN
	DECLARE @salarioBruto DECIMAL(7,2),
		@contribuicaoPrevidencia DECIMAL(7,2),
		@irf DECIMAL(7,2),
		@primeiraParcelaDecimoTerceiro DECIMAL(7,2),
		@segundaParcelaDecimoTerceiro DECIMAL(7,2),
		@decimoTerceiro DECIMAL(7,2),
		@irfDecimoTerceiro DECIMAL(7,2),
		@cont INT,
		@nome VARCHAR(100),
		@naturezaRendimento VARCHAR(15),
		@dataRendimento DATE,
		@contPrevidenciaTotal DECIMAL(7,2),
		@irfTotal DECIMAL(7,2),
		@baseIRRF DECIMAL(7,2)

	SET @salarioBruto = (SELECT valor FROM Rendimentos WHERE cpfFuncionario = @cpf AND idTipoRendimento = 3)
	SET @contribuicaoPrevidencia = 0
	SET @cont = 1
	SET @nome = (SELECT nome FROM Funcionario WHERE cpf = @cpf)
	SET @naturezaRendimento = (SELECT natureza FROM Natureza_Rendimento WHERE id IN (SELECT idNaturezaRendimento FROM Funcionario WHERE cpf = @cpf))

	-- Calculo da contribuição previdencia
	IF(@salarioBruto <= 1100.00)
	BEGIN
		-- Até 1100.00
		SET @contribuicaoPrevidencia = (@salarioBruto * 0.075)
	END
	ELSE
	BEGIN
		IF(@salarioBruto > 1100.00 AND @salarioBruto <= 2203.48)
		BEGIN
			-- De 1100.01 até 2203.48
			SET @contribuicaoPrevidencia = ((@salarioBruto * 0.09) - 16.50)
		END
		ELSE
		BEGIN
			IF(@salarioBruto > 2203.48 AND @salarioBruto <= 3305.22)
			BEGIN
				-- De 2203.49 até 3305.22
				SET @contribuicaoPrevidencia = ((@salarioBruto * 0.12) - 82.61)
			END
			ELSE
			BEGIN
				-- Acima de R$3305.23
				SET @contribuicaoPrevidencia = ((@salarioBruto * 0.14) - 148.72)
			END
		END
	END

	-- Cálculo IRRF
	SET @baseIRRF = (@salarioBruto - @contribuicaoPrevidencia)
	IF(@baseIRRF <= 1903.98)
	BEGIN
		SET @irf = 0
	END
	ELSE
	BEGIN
		IF(@baseIRRF > 1903.98 AND @baseIRRF <= 2826.65)
		BEGIN
			SET @irf = (((@baseIRRF) * 0.075) - 142.80)
		END
		ELSE
		BEGIN
			IF(@baseIRRF > 2826.65 AND @baseIRRF <= 3751.05)
			BEGIN
				SET @irf = (((@baseIRRF) * 0.15) - 354.80)
			END
			ELSE
			BEGIN
				IF(@baseIRRF > 3751.05 AND @baseIRRF <= 4664.68)
				BEGIN
					SET @irf = ((@baseIRRF * 0.225) - 636.13)
				END
				ELSE
				BEGIN
					SET @irf = ((@baseIRRF * 0.275) - 869.36)
				END
			END
		END
	END

	SET @contPrevidenciaTotal = (@contribuicaoPrevidencia * 12)
	SET @irfTotal = (@irf * 12)

	SET @primeiraParcelaDecimoTerceiro = ((@salarioBruto / 12) * 10) / 2
	SET @segundaParcelaDecimoTerceiro = (((((@salarioBruto / 12) * 12) - @primeiraParcelaDecimoTerceiro) - @contribuicaoPrevidencia) - @irf)
	SET @decimoTerceiro = (@primeiraParcelaDecimoTerceiro + @segundaParcelaDecimoTerceiro)
	SET @irfDecimoTerceiro = @segundaParcelaDecimoTerceiro * 0.075

	INSERT INTO @table VALUES
	(@cpf, @nome, @naturezaRendimento, @salarioBruto * 12, @contPrevidenciaTotal, @irfTotal, @decimoTerceiro, @irfDecimoTerceiro)

	RETURN
END




GO
-- Testes
SELECT * FROM fn_informeRendimentos('11111111111')
SELECT * FROM fn_informeRendimentos('22222222222')
SELECT * FROM fn_informeRendimentos('33333333333')
SELECT * FROM fn_informeRendimentos('44444444444')
