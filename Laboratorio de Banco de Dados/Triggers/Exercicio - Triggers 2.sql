/*
- Uma empresa vende produtos alimentícios
- A empresa dá pontos, para seus clientes, que podem ser revertidos em prêmios
- Para não prejudicar a tabela venda, nenhum produto pode ser deletado, mesmo 
que não venha mais a ser vendido
- Para não prejudicar os relatórios e a contabilidade, a tabela venda não pode ser alterada. 
- Ao invés de alterar a tabela venda deve-se exibir uma tabela com o nome do 
último cliente que comprou e o valor da última compra
- Após a inserção de cada linha na tabela venda, 10% do total deverá ser transformado em pontos.
- Se o cliente ainda não estiver na tabela de pontos, deve ser inserido automaticamente após 
sua primeira compra
- Se o cliente atingir 1 ponto, deve receber uma mensagem dizendo que ganhou.

Tabela Cliente (Codigo | Nome)

Tabela Venda (Codigo_Venda | Codigo_Cliente | Valor_Total)

Tabela Pontos (Codigo_Cliente | Total_Pontos)
*/

CREATE DATABASE exTriggers
GO
USE exTriggers

-- Criando as tabelas
CREATE TABLE Cliente(
codigo INT NOT NULL IDENTITY,
nome VARCHAR(100) NOT NULL,
PRIMARY KEY (codigo)
)

GO

CREATE TABLE Venda(
codigo_venda INT IDENTITY,
codigo_cliente INT NOT NULL,
valor_total DECIMAL(7,2) NOT NULL,
PRIMARY KEY (codigo_venda),
FOREIGN KEY (codigo_cliente) REFERENCES Cliente(codigo))

GO

CREATE TABLE Pontos(
codigo_cliente INT NOT NULL,
total_pontos DECIMAL(7,2),
PRIMARY KEY (codigo_cliente),
FOREIGN KEY (codigo_cliente) REFERENCES Cliente(codigo)
)

INSERT INTO Cliente VALUES 
('Cliente 1'),
('Cliente 2'),
('Cliente 3'),
('Cliente 4'),
('Cliente 5')

SELECT * FROM Cliente
SELECT * FROM Venda
SELECT * FROM Pontos

-- Testando os triggers
INSERT INTO Venda VALUES
(2, 5.00)

INSERT INTO Venda VALUES
(5, 10.00)

INSERT INTO Venda VALUES
(2, 5.00)

UPDATE Venda SET valor_total = 9.00 WHERE codigo_cliente = 5

DELETE Venda WHERE codigo_cliente = 2



-- Criando os triggers
CREATE TRIGGER t_vendaInsert ON Venda
AFTER INSERT
AS
BEGIN
	DECLARE @codigo_cliente INT, @pontos DECIMAL(7,2), @clienteExiste INT
	SET @codigo_cliente = (SELECT codigo_cliente FROM inserted)
	SET @pontos = (SELECT valor_total FROM inserted) * 0.1;
	SET @clienteExiste = (SELECT COUNT(codigo_cliente) FROM Pontos WHERE codigo_cliente = @codigo_cliente)

	IF(@clienteExiste = 0)
	BEGIN
		INSERT INTO Pontos VALUES (@codigo_cliente, @pontos)
	END
	ELSE
	BEGIN
		UPDATE Pontos
	    SET total_pontos = total_pontos + @pontos 
	    WHERE codigo_cliente = @codigo_cliente
	END

	IF ((SELECT total_pontos FROM Pontos WHERE codigo_cliente = @codigo_cliente) >= 1)
	BEGIN
		PRINT 'Ganhou!'
	END
END

GO

CREATE TRIGGER t_vendaUpdate ON Venda
INSTEAD OF UPDATE
AS
BEGIN
	SELECT c.nome, v.valor_total
	FROM Cliente c INNER JOIN Venda v 
	ON c.codigo = v.codigo_cliente
	WHERE v.codigo_venda = (SELECT MAX(codigo_venda) FROM Venda)
END

GO

CREATE TRIGGER t_vendaDelete ON Venda
AFTER DELETE
AS
BEGIN
	ROLLBACK TRANSACTION
	RAISERROR('Registros da tabela Venda não podem ser deletados!', 16, 1)
END

