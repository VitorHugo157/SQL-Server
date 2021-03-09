/*
Considere a tabela Produto com os seguintes atributos:
Produto (Codigo | Nome | Valor)
Considere a tabela ENTRADA e a tabela SAÍDA com os seguintes atributos:
(Codigo_Transacao | Codigo_Produto | Quantidade | Valor_Total)
Cada produto que a empresa compra, entra na tabela ENTRADA. Cada produto que a 
empresa vende, entra na tabela SAIDA.
Criar uma procedure que receba um código ('e' para ENTRADA e 's' para SAIDA), 
criar uma exceção de erro para código inválido, receba o codigo_transacao, codigo_produto e 
a quantidade e preencha a tabela correta, 
com o valor_total de cada transação de cada produto.
*/

CREATE DATABASE empresa
GO
USE empresa

CREATE TABLE Produto(
codigo INT NOT NULL,
nome VARCHAR(100),
valor DECIMAL(7,2)
PRIMARY KEY(codigo)
)

CREATE TABLE Entrada(
codigo_transacao INT NOT NULL,
codigo_produto INT NOT NULL,
quantidade INT,
valor_total DECIMAL(7,2)
PRIMARY KEY(codigo_transacao, codigo_produto)
FOREIGN KEY(codigo_produto) REFERENCES Produto(codigo)
)

CREATE TABLE Saida(
codigo_transacao INT NOT NULL,
codigo_produto INT NOT NULL,
quantidade INT,
valor_total DECIMAL(7,2)
PRIMARY KEY(codigo_transacao, codigo_produto)
FOREIGN KEY(codigo_produto) REFERENCES Produto(codigo)
)



CREATE PROCEDURE sp_valorTotalProduto(@codigo_produto INT, @quantidade INT, @return DECIMAL(7,2) OUTPUT)
AS
	DECLARE @valorUnitario DECIMAL(7,2)

	SET @valorUnitario = (SELECT p.valor FROM Produto p WHERE p.codigo = @codigo_produto)
	SET @return = @quantidade * @valorUnitario


CREATE PROCEDURE sp_insereProduto(@codigo CHAR(1), @codigo_transacao INT, @codigo_produto INT, @quantidade INT)
AS
	DECLARE @erro VARCHAR(200),
			@table VARCHAR(20),
			@query VARCHAR(MAX),
			@valorTotal DECIMAL(7,2)

	IF(LOWER(@codigo) = 'e' OR LOWER(@codigo) = 's')
	BEGIN
		IF(LOWER(@codigo) = 'e')
		BEGIN
			SET @table = 'Entrada'
		END
		ELSE
		BEGIN
			SET @table = 'Saida'
		END

		EXEC sp_valorTotalProduto @codigo_produto, @quantidade, @valorTotal OUTPUT
		
		SET @query = 'INSERT INTO ' + @table + ' VALUES (' 
			+ CAST(@codigo_transacao AS VARCHAR(10)) + ', ' 
			+ CAST(@codigo_produto AS VARCHAR(10)) + ', ' 
			+ CAST(@quantidade AS VARCHAR(10)) + ', ' 
			+ CAST(@valorTotal AS VARCHAR(10)) + ')'

		BEGIN TRY
			EXEC (@query)
		END TRY
		BEGIN CATCH
			SET @erro = ERROR_MESSAGE()
			IF(@erro LIKE '%primary%')
			BEGIN
				RAISERROR('ID produto duplicado', 16, 1)
			END
			ELSE
			BEGIN
				RAISERROR('Erro de processamento', 16, 1)
			END
		END CATCH

	END
	ELSE
	BEGIN
		RAISERROR('Codigo da tabela inválido', 16, 1)
	END




INSERT INTO Produto VALUES
(1001, 'Teclado Mecânico', 100.00),
(1002, 'Mouse Gamer 7200 DPI', 95.00),
(1003, 'SSD 256GB SATA III', 430.00),
(1004, 'SSD 2TB M.2 NVME', 2500.00),
(1005, 'Memoria RAM 16GB DDR4 3000MHZ', 830.00)

EXEC sp_insereProduto 'e', 1001, 1003, 50
EXEC sp_insereProduto 's', 1001, 1003, 10

SELECT * FROM Produto
SELECT * FROM Entrada
SELECT * FROM Saida
