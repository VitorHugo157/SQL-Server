/*
Programação estruturada em SQL (Com SQL SERVER)
Declaração de variáveis:
DECLARE @var TIPO

Atribuição de variáveis:
SET @var = valor
SET @var = (SELECT col FROM Tbl WHERE col = valor) -- Permitido se o select retorna 1 único valor
SELECT @var = col FROM Tbl WHERE col = valor -- Permitido se o select retorna 1 único valor

Condicional:
IF (condição lógica)
BEGIN
	.
	.
	.
END
ELSE
BEGIN
	.
	.
	.
END

Repetição (Não se usa FOR para essa finalidade)
WHILE (condição lógica)
BEGIN
	.
	.
	.
END

-- Exemplo com Tabelas

create table produto(
codigo int not null primary key,
nome varchar(100),
preco float)

declare @i as int
declare @preco as float
set @i = 1
while @i <= 10000
begin
	if (@i % 2 = 0)
	begin
		set @preco = @i * 1.5
	end
	else
	begin
		set @preco = @i * 2.5
	end
	insert into produto 
		values (@i,'Produto '+CONVERT(varchar(5),@i),@preco)
	set @i = @i + 1
end

select * from produto

-- Fazer um algoritmo que calcule a tabuada de um dado número
declare @a as int
declare @cont as int
set @a = 12
set @cont = 1
while @cont <= 10
	begin
		if @cont = 1
			begin
				print ((convert (char(2),@a)+' x 0 = '+convert (char(4),(@cont - 1))))
				print ((convert (char(2),@a)+' x 1 = '+convert (char(4),@a)))
				set @cont = @cont + 1
			end
		else
			begin
				print ((convert (char(2),@a)+' x '+(convert (varchar(2),@cont))+' = '+(convert (char(4),(@a*@cont)))))
				set @cont = @cont + 1
			end
	end
*/




/*Fazer um algoritmo que leia 3 valores e retorne se os valores formam um triângulo e se ele é
isóceles, escaleno ou equilátero.
Condições para formar um triângulo
	Nenhum valor pode ser = 0
	Um lado não pode ser maior que a soma dos outros 2.
*/
DECLARE @value1 INT,
		@value2 INT,
		@value3 INT

SET @value1 = 13
SET @value2 = 15
SET @value3 = 22

IF (@value1 > @value2 + @value3 
	OR @value2 > @value1 + @value3
	OR @value3 > @value1 + @value2 
	OR @value1 = 0 OR @value2 = 0 OR @value3 = 0)
BEGIN
	PRINT 'Não é um triângulo'
END
ELSE
BEGIN
	IF (@value1 = @value2 AND @value2 = @value3)
	BEGIN
		PRINT 'É um triângulo equilátero'
	END
	ELSE
	BEGIN
		IF (@value1 = @value2 AND @value1 != @value3
			OR @value1 = @value3 AND @value1 != @value2
			OR @value2 = @value3 AND @value2 != @value1)
		BEGIN
			PRINT 'É um triângulo isósceles' 
		END
		ELSE
		BEGIN
			PRINT 'É um triângulo escaleno'
		END
	END
END



--Fazer um algoritmo que leia 1 número e mostre se são múltiplos de 2,3,5 ou nenhum deles
DECLARE @num INT
SET @num = 7

IF (@num % 2 = 0 AND @num % 3 = 0)
BEGIN
	PRINT 'O número ' +CAST(@num AS VARCHAR(3)) + ' é múltiplo de 2 e 3'
END
ELSE
BEGIN
	IF (@num % 2 = 0 AND @num % 5 = 0)
	BEGIN
		PRINT 'O número ' +CAST(@num AS VARCHAR(3)) + ' é múltiplo de 2 e 5'
	END
	ELSE
	BEGIN
		IF (@num % 2 = 0)
		BEGIN
			PRINT 'O número ' +CAST(@num AS VARCHAR(3)) + ' é múltiplo de 2'
		END
		ELSE
		BEGIN
			IF (@num % 3 = 0 AND @num % 5 = 0)
			BEGIN
				PRINT 'O número ' +CAST(@num AS VARCHAR(3)) + ' é múltiplo de 3 e 5'
			END
			ELSE
			BEGIN
				IF (@num % 3 = 0)
				BEGIN
					PRINT 'O número ' +CAST(@num AS VARCHAR(3)) + ' é múltiplo de 3'
				END
				ELSE
				BEGIN
					IF (@num % 5 = 0)
					BEGIN
						PRINT 'O número ' +CAST(@num AS VARCHAR(3)) + ' é múltiplo de 5'
					END
					ELSE
					BEGIN
						PRINT 'O número ' +CAST(@num AS VARCHAR(3)) + ' NÃO é múltiplo de 2, 3, 5'
					END
				END
			END
		END
	END
END




--Fazer um algoritmo que leia 3 números e mostre o maior e o menor
DECLARE @num1 INT,
		@num2 INT,
		@num3 INT,
		@maior INT,
		@menor INT

SET @num1 = 2
SET @num2 = 3
SET @num3 = 1

IF (@num1 = @num2 AND @num1 = @num3)
BEGIN
	PRINT 'Os números são iguais'
END
ELSE
BEGIN
	IF (@num1 > @num2)
	BEGIN
		SET @maior = @num1
		SET @menor = @num2
	END
	ELSE
	BEGIN
		SET @maior = @num2
		SET @menor = @num1
	END
	IF (@num3 > @menor)
	BEGIN
		IF (@num3 > @maior)
		BEGIN
			SET @maior = @num3
		END
	END
	ELSE
	BEGIN
		SET @menor = @num3
	END
	PRINT 'MAIOR = ' + CAST(@maior AS VARCHAR(15))
	PRINT 'MENOR = ' + CAST(@menor AS VARCHAR(15))
END


/*
Fazer um algoritmo que calcule os 15 primeiros termos da série
1,1,2,3,5,8,13,21,...
E calcule a soma dos 15 termos
*/
DECLARE @soma INT,
		@cont INT,
		@fibo INT,
		@anterior INT,
		@atual INT

SET @soma = 0
SET @anterior = 0
SET @atual = 1
SET @cont = 0

WHILE (@cont < 15)
BEGIN
	SET @fibo = @atual + @anterior
	SET @atual = @anterior
	SET @anterior = @fibo
	SET @soma = @soma + @fibo
	SET @cont = @cont + 1
	PRINT @fibo
END
PRINT ''
PRINT 'SOMA = ' + CAST(@soma AS VARCHAR(5))



--Fazer um algoritmo que separa uma frase, colocando todas as letras em maiúsculo e em minúsculo
DECLARE @fraseOriginal VARCHAR(100),
		@fraseUpper VARCHAR(100),
		@fraseLower VARCHAR(100)

SET @fraseOriginal = 'A vOlTa DOs QuE nÃo FoRaM'
SET @fraseUpper = UPPER(@fraseOriginal)
SET @fraseLower = LOWER(@fraseOriginal)

PRINT @fraseOriginal
PRINT @fraseUpper
PRINT @fraseLower



--Fazer um algoritmo que inverta uma palavra
DECLARE @palavraOriginal VARCHAR(45),
		@palavraInvertida VARCHAR(45),
		@cont INT

SET @palavraOriginal = 'vitor'
SET @cont = LEN(@palavraOriginal)
SET @palavraInvertida = ''

WHILE (@cont >= 0)
BEGIN
	SET @palavraInvertida = @palavraInvertida + SUBSTRING(@palavraOriginal, @cont, 1)
	SET @cont = @cont - 1
END
PRINT 'Palavra original: ' + @palavraOriginal
PRINT 'Palavra invertida: ' + @palavraInvertida



--Verificar palíndromo
DECLARE @palavraOriginal VARCHAR(45),
		@palavraInvertida VARCHAR(45),
		@cont INT

SET @palavraOriginal = 'luzazul'
SET @cont = LEN(@palavraOriginal)
SET @palavraInvertida = ''

WHILE (@cont >= 0)
BEGIN
	SET @palavraInvertida = @palavraInvertida + SUBSTRING(@palavraOriginal, @cont, 1)
	SET @cont = @cont - 1
END
IF (@palavraInvertida = @palavraOriginal)
BEGIN
	PRINT 'A palavra "' + CAST(@palavraOriginal AS VARCHAR(45)) + '" é um palíndromo'
END
ELSE
BEGIN
	PRINT 'A palavra "' + CAST(@palavraOriginal AS VARCHAR(45)) + '" NÃO é um palíndromo'
END



--Algoritmo do CPF
DECLARE @cpf CHAR(11),
		@cpfVerificado CHAR(11),
		@CpfValido INT,
		@cont INT,
		@cont2 INT,
		@digitoVerificador VARCHAR(2),
		@calc INT,
		@soma INT,
		@aux INT,
		@aux2 INT

SET @cpf = '22233366638'
SET @cont = 2
SET @CpfValido = 1
SET @soma = 0

WHILE (@cont <= LEN(@cpf))
BEGIN
	IF (SUBSTRING(@cpf, @cont, 1) = SUBSTRING(@cpf, @cont - 1, 1))
	BEGIN
		SET @CpfValido = @CpfValido + 1
		SET @cont = @cont + 1
	END
	ELSE
	BEGIN
		SET @cont = @cont + 1
	END
END
IF (@CpfValido = LEN(@cpf))
BEGIN
	PRINT 'CPF com números iguais, é inválido'
END
ELSE
BEGIN
	SET @cont = 10
	SET @cont2 = 1
	WHILE (@cont >= 2)
	BEGIN
		SET @aux = CONVERT(INT, SUBSTRING(@cpf, @cont2, 1))
		SET @soma = @soma + (@aux * @cont)
		SET @cont = @cont - 1
		SET @cont2 = @cont2 + 1
	END
	SET @calc = @soma % 11
	IF (@calc < 2)
	BEGIN
		SET @digitoVerificador = @digitoVerificador + '0'
	END
	ELSE
	BEGIN
		SET @aux2 = 11 - @calc
		SET @digitoVerificador = CAST(@aux2 AS CHAR(1))
	END

	SET @cont = 11
	SET @cont2 = 1
	SET @soma = 0
	WHILE (@cont >= 2)
	BEGIN
		SET @aux = CONVERT(INT, SUBSTRING(@cpf, @cont2, 1))
		SET @soma = @soma + (@aux * @cont)
		SET @cont = @cont - 1
		SET @cont2 = @cont2 + 1
	END
	SET @calc = @soma % 11
	IF (@calc < 2)
	BEGIN
		SET @digitoVerificador = @digitoVerificador + '0'
	END
	ELSE
	BEGIN
		SET @aux2 = 11 - @calc
		SET @digitoVerificador = @digitoVerificador + CAST(@aux2 AS CHAR(1))
	END
	SET @cpfVerificado = SUBSTRING(@cpf, 1, 9) + @digitoVerificador
	IF (@cpfVerificado = @cpf)
	BEGIN
		PRINT 'CPF verificado, é válido'
	END
	ELSE
	BEGIN
		PRINT 'CPF verificado, é inválido'
	END
END
