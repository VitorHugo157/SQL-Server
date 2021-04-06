CREATE DATABASE aula08
GO
USE aula08

CREATE TABLE Produto(
codigo INT NOT NULL,
nome VARCHAR(100) NOT NULL,
descricao VARCHAR(100),
valor_unitario DECIMAL(7,2) NOT NULL
PRIMARY KEY(codigo)
)

CREATE TABLE Estoque(
codigo_produto INT NOT NULL,
qtd_estoque INT NOT NULL,
estoque_minimo INT NOT NULL
PRIMARY KEY(codigo_produto)
FOREIGN KEY(codigo_produto) REFERENCES Produto(codigo)
)

CREATE TABLE Venda(
nota_fiscal INT NOT NULL,
codigo_produto INT NOT NULL,
quantidade INT NOT NULL
PRIMARY KEY(nota_fiscal)
FOREIGN KEY(codigo_produto) REFERENCES Produto(codigo)
)

CREATE TRIGGER t_venda ON venda
FOR INSERT
AS
BEGIN
	DECLARE @codigo INT,
			@qtd_estoque_final INT,
			@qtd_minima INT

	SET @codigo = (SELECT codigo_produto FROM inserted)
	SET @qtd_estoque_final = ((SELECT qtd_estoque FROM Estoque WHERE codigo_produto = @codigo) - (SELECT quantidade FROM inserted WHERE codigo_produto = @codigo))
	SET @qtd_minima = (SELECT estoque_minimo FROM Estoque WHERE codigo_produto = @codigo)

	IF(@qtd_estoque_final < 0)
	BEGIN
		ROLLBACK TRANSACTION
		RAISERROR('Quantidade do produto na venda indisponível no estoque.', 16, 1)
	END
	ELSE
	BEGIN
		IF((SELECT qtd_estoque FROM Estoque WHERE codigo_produto = @codigo) < @qtd_minima)
		BEGIN
			PRINT 'Quantidade do produto em estoque está abaixo do estoque mínimo!'
		END
		ELSE
		BEGIN
			IF(@qtd_estoque_final < @qtd_minima)
			BEGIN
				PRINT 'Quantidade do produto em estoque ficou abaixo do estoque mínimo!'
			END
		END
		UPDATE Estoque 
		SET qtd_estoque = qtd_estoque - (SELECT quantidade FROM inserted WHERE codigo_produto = @codigo) 
		WHERE codigo_produto = @codigo
	END
END

CREATE FUNCTION fn_nota_fiscal(@nota_fiscal INT)
RETURNS @table TABLE(
nota_fiscal INT,
codigo_produto INT,
nome_produto VARCHAR(100),
descricao_produto VARCHAR(100),
valor_unitario DECIMAL(7,2),
quantidade INT,
valor_total DECIMAL(7,2)
)
AS
BEGIN
	INSERT INTO @table
		SELECT v.nota_fiscal, p.codigo, p.nome, p.descricao, p.valor_unitario, v.quantidade, (p.valor_unitario * v.quantidade) AS valor_total
		FROM Produto p INNER JOIN Venda v
		ON p.codigo = v.codigo_produto
		WHERE v.nota_fiscal = @nota_fiscal

	RETURN
END



INSERT INTO Produto VALUES
(1, 'SSD', 'SSD 1TB M2 NVME', 1500.00),
(2, 'Placa de Vídeo', 'GeForce GTX 1660 Super', 2100.00)

INSERT INTO Estoque VALUES
(1, 10, 5),
(2, 20, 10)

-- Teste de venda com quantidade maior que a disponível no estoque
INSERT INTO Venda VALUES
(1, 1, 11)

-- Teste de venda pra deixar quantidade em estoque abaixo do estoque mínimo
INSERT INTO Venda VALUES
(2, 2, 12)

-- Teste de venda com quantidade em estoque no estoque mínimo
INSERT INTO Venda VALUES
(3, 2, 2)

SELECT * FROM fn_nota_fiscal(2)

SELECT * FROM Produto
SELECT * FROM Estoque
SELECT * FROM Venda
