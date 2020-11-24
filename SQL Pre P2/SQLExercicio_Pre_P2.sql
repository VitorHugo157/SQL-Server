CREATE DATABASE exercicioPreP2
GO
USE exercicioPreP2

CREATE TABLE [Cliente](
cod INT NOT NULL,
nome VARCHAR(45) NULL,
logradouro VARCHAR(45) NULL,
numero INT NULL CHECK(numero > 0),
telefone CHAR(9) NULL
PRIMARY KEY(cod)
)

CREATE TABLE [Autor](
cod INT NOT NULL,
nome VARCHAR(45) NULL,
pais VARCHAR(45) NULL DEFAULT('Brasil'),
biografia VARCHAR(45) NULL
PRIMARY KEY(cod)
)

CREATE TABLE [Corredor](
cod INT NOT NULL,
tipo VARCHAR(45) NULL
PRIMARY KEY(cod)
)

CREATE TABLE [Livro](
cod INT NOT NULL,
cod_autor INT NOT NULL,
cod_corredor INT NOT NULL,
nome VARCHAR(45) NULL,
pag INT NULL CHECK(pag > 0),
idioma VARCHAR(45) NULL DEFAULT('Português')
PRIMARY KEY(cod)
FOREIGN KEY(cod_autor) REFERENCES [Autor](cod),
FOREIGN KEY(cod_corredor) REFERENCES [Corredor](cod)
)

CREATE TABLE [Emprestimo](
cod_cli INT NOT NULL,
data_emprestimo DATE NOT NULL,
cod_livro INT NOT NULL
PRIMARY KEY(cod_cli, cod_livro)
FOREIGN KEY(cod_cli) REFERENCES [Cliente](cod),
FOREIGN KEY(cod_livro) REFERENCES [Livro](cod)
)

SELECT * FROM [Autor]
SELECT * FROM [Cliente]
SELECT * FROM [Corredor]
SELECT * FROM [Livro]
SELECT * FROM [Emprestimo]

--Fazer os seguintes exercícios:
--Fazer uma consulta que retorne o nome do cliente e a data do empréstimo formatada padrão BR (dd/mm/yyyy)
SELECT c.nome, CONVERT(CHAR(10), e.data_emprestimo, 103) AS data_emprestimo
FROM [Emprestimo] e, [Cliente] c
WHERE e.cod_cli = c.cod

/*Fazer uma consulta que retorne Nome do autor e Quantos livros foram escritos 
por Cada autor, ordenado pelo número de livros. Se o nome do autor 
tiver mais de 25 caracteres, mostrar só os 13 primeiros.
*/
SELECT CASE WHEN (LEN(a.nome) > 25)
			THEN
				SUBSTRING(a.nome, 1, 13)
			ELSE
				a.nome
		END AS nome_autor,
		COUNT(a.cod) AS qtd_livros
FROM [Autor] a, [Livro] l
WHERE a.cod = l.cod_autor
GROUP BY a.cod, a.nome
ORDER BY a.cod, a.nome

--Fazer uma consulta que retorne o nome do autor e o país de origem do livro com maior número de páginas cadastrados no sistema
SELECT a.nome, l.idioma
FROM [Autor] a, [Livro] l
WHERE a.cod = l.cod_autor
	AND (l.pag IN
	(
		SELECT MAX(l.pag)
		FROM [Livro] l
	))

--Fazer uma consulta que retorne nome e endereço concatenado dos clientes que tem livros emprestados
SELECT DISTINCT c.nome, c.logradouro + ', ' + CAST(c.numero AS VARCHAR(10)) AS endereco
FROM [Cliente] c, [Emprestimo] e
WHERE c.cod = e.cod_cli

/*
Nome dos Clientes, sem repetir e, concatenados como
enderço_telefone, o logradouro, o numero e o telefone) dos
clientes que Não pegaram livros. Se o logradouro e o 
número forem nulos e o telefone não for nulo, mostrar só o telefone. Se o telefone for nulo e o logradouro e o número não forem nulos, mostrar só logradouro e número. Se os três existirem, mostrar os três.
O telefone deve estar mascarado XXXXX-XXXX
*/
SELECT DISTINCT c.nome, 
	CASE WHEN (c.logradouro IS NULL AND c.numero IS NULL AND c.telefone IS NOT NULL)
		THEN
			SUBSTRING(c.telefone, 1, 5) + '-' + SUBSTRING(c.telefone, 6, 4)
		ELSE
			CASE WHEN (c.telefone IS NULL AND c.logradouro IS NOT NULL AND c.numero IS NOT NULL)
				THEN
					c.logradouro + ', ' + CAST(c.numero AS VARCHAR(10))
				ELSE
					CASE WHEN (c.logradouro IS NOT NULL AND c.numero IS NOT NULL AND c.telefone IS NOT NULL)
						THEN
							c.logradouro + ', ' + CAST(c.numero AS VARCHAR(10)) + ' - ' + 
							SUBSTRING(c.telefone, 1, 5) + '-' + SUBSTRING(c.telefone, 6, 4)
					END
			END
	END AS endereco_telefone
FROM [Cliente] c LEFT OUTER JOIN [Emprestimo] e
ON c.cod = e.cod_cli
WHERE e.cod_cli IS NULL

--Fazer uma consulta que retorne Quantos livros não foram emprestados
SELECT COUNT(l.cod) AS qtd_livros_não_emprestados
FROM [Livro] l LEFT OUTER JOIN [Emprestimo] e
ON l.cod = e.cod_livro
WHERE e.cod_livro IS NULL

--Fazer uma consulta que retorne Nome do Autor, Tipo do corredor e quantos livros, ordenados por quantidade de livro
SELECT a.nome, c.tipo, COUNT(l.cod) AS qtd_livros
FROM [Autor] a, [Corredor] c, [Livro] l
WHERE l.cod_corredor = c.cod
	AND a.cod = l.cod_autor
GROUP BY a.nome, c.tipo
ORDER BY qtd_livros

/*Considere que hoje é dia 18/05/2012, faça uma consulta que apresente o nome do cliente, o nome do livro, 
o total de dias que cada um está com o livro e, uma coluna que apresente, caso o número de dias seja 
superior a 4, apresente 'Atrasado', caso contrário, apresente 'No Prazo'
*/
SELECT c.nome, l.nome, DATEDIFF(DAY, e.data_emprestimo, '18/05/2012') AS qtd_dias_com_livro,
	CASE WHEN (DATEDIFF(DAY, e.data_emprestimo, '18/05/2012') > 4)
		THEN
			'Atrasado'
		ELSE
			'No Prazo'
	END AS status_emprestimo
FROM [Cliente] c, [Livro] l, [Emprestimo] e
WHERE c.cod = e.cod_cli
	AND l.cod = e.cod_livro

--Fazer uma consulta que retorne cod de corredores, tipo de corredores e quantos livros tem em cada corredor
SELECT c.cod, c.tipo, COUNT(l.cod_corredor) AS qtd_livros
FROM [Corredor] c, [Livro] l
WHERE c.cod = l.cod_corredor
GROUP BY c.cod, l.cod_corredor, c.tipo

--Fazer uma consulta que retorne o Nome dos autores cuja quantidade de livros cadastrado é maior ou igual a 2.
SELECT CASE WHEN ((COUNT(l.cod)) >= 2)
			THEN
				a.nome
		END AS nome_autor
FROM [Autor] a, [Livro] l
WHERE a.cod = l.cod_autor
GROUP BY a.nome
ORDER BY a.nome

/*Considere que hoje é dia 18/05/2012, faça uma consulta que apresente o nome do cliente, 
o nome do livro dos empréstimos que tem 7 dias ou mais
*/
SELECT c.nome, l.nome
FROM [Cliente] c, [Livro] l, [Emprestimo] e
WHERE c.cod = e.cod_cli
	AND l.cod = e.cod_livro
	AND (DATEDIFF(DAY, e.data_emprestimo, '18/05/2012')) >= 7
