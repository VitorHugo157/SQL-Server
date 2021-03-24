USE udf

CREATE TABLE Cliente(
cpf CHAR(11) NOT NULL,
nome VARCHAR(100),
telefone VARCHAR(11),
email VARCHAR(100)
PRIMARY KEY(cpf)
)

CREATE TABLE Produto(
codigo INT NOT NULL,
nome VARCHAR(100),
descricao VARCHAR(100),
valor_unitario DECIMAL(7,2)
PRIMARY KEY(codigo)
)

CREATE TABLE Venda(
cpf_cliente CHAR(11) NOT NULL,
codigo_produto INT NOT NULL,
quantidade INT NOT NULL CHECK(quantidade > 0),
data_venda DATE NOT NULL
PRIMARY KEY(cpf_cliente, codigo_produto)
FOREIGN KEY(cpf_cliente) REFERENCES Cliente(cpf),
FOREIGN KEY(codigo_produto) REFERENCES Produto(codigo)
)

INSERT INTO Cliente VALUES
('11111111111', 'Amarelão', '11912345678', 'yellow@email.com'),
('22222222222', 'Azulão', '1343218765', 'blue@email.com'),
('33333333333', 'Vermelhão', '11987654321', 'red@email.com')

INSERT INTO Produto VALUES
(001, 'Memória RAM', 'Memoria RAM 8GB DDR4 2133MHZ', 386.30),
(002, 'SSD', 'SSD 480GB M2 NVME', 1021.60),
(003, 'Placa de Vídeo', 'Geforce GTX 1660 Super', 3337.50)

INSERT INTO Venda VALUES
('11111111111', 001, 2, '19/02/2021'),
('22222222222', 002, 1, '25/02/2021'),
('33333333333', 003, 1, '02/03/2021'),
('33333333333', 002, 1, '02/03/2021')


CREATE FUNCTION fn_notaFiscal()
RETURNS @table TABLE(
nome_cliente VARCHAR(100),
nome_produto VARCHAR(100),
quantidade INT,
valor_total DECIMAL(7,2)
)
AS
BEGIN
	INSERT INTO @table
		SELECT c.nome AS nome_cliente, p.nome AS nome_produto, 
			v.quantidade AS quantidade, (v.quantidade * p.valor_unitario) AS valor_total
		FROM Cliente c INNER JOIN Venda v
		ON c.cpf = v.cpf_cliente
		INNER JOIN Produto p
		ON p.codigo = v.codigo_produto

	RETURN
END

CREATE FUNCTION fn_valorTotalUltimaCompra(@cpf CHAR(11))
RETURNS DECIMAL(7,2)
AS
BEGIN
	DECLARE @dataUltimaCompra DATE,
			@valorTotal DECIMAL(7,2)

	SELECT @dataUltimaCompra = (MAX(v.data_venda))
	FROM Cliente c INNER JOIN Venda v
	ON c.cpf = v.cpf_cliente
	WHERE c.cpf = @cpf

	SELECT @valorTotal = (SUM(v.quantidade * p.valor_unitario))
	FROM Cliente c INNER JOIN Venda v
	ON c.cpf = v.cpf_cliente
	INNER JOIN Produto p
	ON p.codigo = v.codigo_produto 
	WHERE c.cpf = @cpf AND v.data_venda = @dataUltimaCompra
	
	RETURN (@valorTotal)
END

SELECT * FROM fn_notaFiscal()
SELECT dbo.fn_valorTotalUltimaCompra('33333333333') AS VALOR_TOTAL
