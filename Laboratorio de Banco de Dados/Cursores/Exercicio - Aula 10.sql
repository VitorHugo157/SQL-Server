CREATE DATABASE ex_cursor
GO
USE ex_cursor

CREATE TABLE Filiais (
idFilial INT NOT NULL,
logradouro VARCHAR(5) NOT NULL,
numero INT NOT NULL
PRIMARY KEY (idFilial)
)

INSERT INTO Filiais VALUES
(1, 'R. A', 250),
(2, 'R. B', 500),
(3, 'R. C', 125)

CREATE TABLE Cliente (
idCliente INT NOT NULL,
nome VARCHAR(50) NOT NULL,
filial INT NOT NULL,
gasto_filial DECIMAL(7,2)
PRIMARY KEY (idCliente)
FOREIGN KEY (filial) REFERENCES Filiais (idFilial)
)

INSERT INTO Cliente VALUES
(1001, 'Cliente1', 1, 6404.00),
(1002, 'Cliente2', 1, 5652.00),
(1003, 'Cliente3', 3, 1800.00),
(1004, 'Cliente4', 2, 3536.00),
(1005, 'Cliente5', 2, 8110.00),
(1006, 'Cliente6', 2, 5256.00),
(1007, 'Cliente7', 2, 6879.00),
(1008, 'Cliente8', 2, 7092.00),
(1009, 'Cliente9', 3, 7976.00),
(1010, 'Cliente10', 3, 4192.00),
(1011, 'Cliente11', 3, 8278.00),
(1012, 'Cliente12', 1, 8913.00)

CREATE FUNCTION fn_cli_fil_3()
RETURNS @tabela TABLE (
idCliente INT, 
nomeCliente VARCHAR(50), 
gasto_filial_3 DECIMAL(7,2), 
multa_filiais DECIMAL(7,2)
)
AS
BEGIN
	DECLARE @idCliente		INT,
			@nome			VARCHAR(50),
			@filial			INT,
			@gastoFilial	DECIMAL(7,2)
	DECLARE c CURSOR FOR SELECT idCliente, nome, filial, gasto_filial FROM Cliente WHERE filial = 3
	
	OPEN c

	FETCH NEXT FROM c INTO @idCliente, @nome, @filial, @gastoFilial

	WHILE @@FETCH_STATUS = 0
	BEGIN
		
		IF (@gastoFilial <= 3000)
		BEGIN
			INSERT INTO @tabela VALUES (@idCliente, @nome, @gastoFilial * 0.85, @gastoFilial * 0.15)
		END
		IF (@gastoFilial > 3000 AND @gastoFilial <= 6000)
		BEGIN
			INSERT INTO @tabela VALUES (@idCliente, @nome, (@gastoFilial * 0.75) - 100, (@gastoFilial * 0.25) + 100)
		END
		IF (@gastoFilial > 6000)
		BEGIN
			INSERT INTO @tabela VALUES (@idCliente, @nome, @gastoFilial * 0.65, @gastoFilial * 0.35)
		END

		FETCH NEXT FROM c INTO @idCliente, @nome, @filial, @gastoFilial
	END

	CLOSE c
	DEALLOCATE c

	RETURN
END

SELECT * FROM fn_cli_fil_3()
