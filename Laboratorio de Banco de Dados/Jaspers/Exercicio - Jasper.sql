CREATE DATABASE jasper
GO
USE jasper

CREATE TABLE Cliente(
cpf CHAR(11) NOT NULL,
nome VARCHAR(100) NOT NULL,
ddd CHAR(2) NOT NULL,
telefone CHAR(9) NOT NULL,
email VARCHAR(50) NOT NULL,
senha CHAR(8) NOT NULL
PRIMARY KEY(cpf)
)

GO
CREATE TABLE Produto(
id INT NOT NULL IDENTITY,
nome VARCHAR(40) NOT NULL,
descricao VARCHAR(200) NOT NULL,
valor_un DECIMAL(7,2) NOT NULL
PRIMARY KEY(id)
)

GO
CREATE TABLE Compra(
cpf_cliente CHAR(11) NOT NULL,
id_produto INT NOT NULL,
dt_compra DATETIME NOT NULL,
qtd INT NOT NULL
PRIMARY KEY(cpf_cliente, id_produto, dt_compra)
FOREIGN KEY(cpf_cliente) REFERENCES Cliente(cpf),
FOREIGN KEY(id_produto) REFERENCES Produto(id)
)

GO
INSERT INTO Cliente VALUES
('11111111111', 'Cliente 1', '11', '911111111', 'cliente1@email.com', 'cli1@123'),
('22222222222', 'Cliente 2', '22', '922222222', 'cliente2@email.com', 'cli2@123'),
('33333333333', 'Cliente 3', '33', '933333333', 'cliente3@email.com', 'cli3@123'),
('44444444444', 'Cliente 4', '44', '944444444', 'cliente4@email.com', 'cli4@123'),
('55555555555', 'Cliente 5', '55', '955555555', 'cliente5@email.com', 'cli5@123')

GO
INSERT INTO Produto VALUES
('Placa Mãe Asus Z490-F', '', 2300.00),
('Mousepad Hyrax', '', 150.00),
('Headset Razer', '', 570.00),
('Mouse RGB', '', 200.00),
('Gabinete White', '', 284.90)

GO
INSERT INTO Compra VALUES
('11111111111', 2, '17/05/2021', 3),
('11111111111', 5, '17/05/2021', 1),
('11111111111', 1, '16/05/2021', 1),
('11111111111', 3, '16/05/2021', 1),
('22222222222', 1, '17/05/2021', 2),
('33333333333', 2, '17/05/2021', 5),
('44444444444', 3, '17/05/2021', 4),
('55555555555', 5, '17/05/2021', 1),
('55555555555', 1, '17/05/2021', 2)

SELECT * FROM Cliente
SELECT * FROM Produto
SELECT * FROM Compra

SELECT cli.cpf, cli.nome, 
	'(' + cli.ddd + ')' + SUBSTRING(cli.telefone, 1, 5) + '-' + SUBSTRING(cli.telefone, 6, 4) AS telefone, 
	cli.email, com.dt_compra, p.id, p.nome AS nome_produto, com.qtd, p.valor_un * com.qtd AS valor_total
FROM Cliente cli INNER JOIN Compra com
ON cli.cpf = com.cpf_cliente
INNER JOIN Produto p
ON p.id = com.id_produto
WHERE com.dt_compra = '17/05/2021' -- $P{dataCompra}
	AND com.cpf_cliente = '11111111111' -- $P{cpfCliente}

