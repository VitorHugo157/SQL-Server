CREATE DATABASE EXERCICIO09
GO 
USE EXERCICIO09

CREATE TABLE editora (
codigo INT NOT NULL IDENTITY,
nome VARCHAR(45) NOT NULL,
sites VARCHAR (45) NULL,
PRIMARY KEY (codigo)
)

CREATE TABLE autor (
codigo INT NOT NULL IDENTITY(101, 1),
nome VARCHAR(45) NOT NULL,
breve_biografia VARCHAR(100) NOT NULL
PRIMARY KEY (codigo)
)

CREATE TABLE estoque (
codigo INT NOT NULL IDENTITY(10001, 1),
nome VARCHAR(45) NOT NULL UNIQUE,
quantidade INT NOT NULL,
valor DECIMAL(7,2) NOT NULL CHECK(valor > 0),
cod_editora INT NOT NULL,
cod_autor INT NOT NULL,
PRIMARY KEY (codigo),
FOREIGN KEY (cod_editora) REFERENCES [editora] (codigo),
FOREIGN KEY (cod_autor) REFERENCES [autor] (codigo)
)

CREATE TABLE compras (
codigo INT NOT NULL,
cod_livro INT NOT NULL,
qtd_comprada INT NOT NULL CHECK (qtd_comprada > 0),
valor DECIMAL(7,2) NOT NULL, CHECK (valor > 0), 
data_compra DATE NOT NULL,
PRIMARY KEY (codigo, cod_livro),
FOREIGN KEY (cod_livro) REFERENCES estoque (codigo)
)

--Inserindo dados nas tabelas
INSERT INTO editora VALUES
('Pearson',	'www.pearson.com.br'),
('Civilização Brasileira', NULL),	
('Makron Books',	'www.mbooks.com.br'),
('LTC',	'www.ltceditora.com.br'),
('Atual',	'www.atualeditora.com.br'),
('Moderna',	'www.moderna.com.br')

SELECT * FROM [editora]

INSERT INTO autor VALUES 
('Andrew Tannenbaun',	'Desenvolvedor do Minix'),
('Fernando Henrique Cardoso',	'Ex-Presidente do Brasil'),
('Diva Marília Flemming',	'Professora adjunta da UFSC'),
('David Halliday',	'Ph.D. da University of Pittsburgh'),
('Alfredo Steinbruch',	'Professor de Matemática da UFRS e da PUCRS'),
('Willian Roberto Cereja',	'Doutorado em Lingüística Aplicada e Estudos da Linguagem'),
('William Stallings',	'Doutorado em Ciências da Computacão pelo MIT'),
('Carlos Morimoto',	'Criador do Kurumin Linux')

SELECT * FROM [autor]

INSERT INTO estoque VALUES 
('Sistemas Operacionais Modernos', 	4,	108.00,	1,	101),
('A Arte da Política',	2,	55.00,	2,	102),
('Calculo A',	12,	79.00,	3,	103),
('Fundamentos de Física I',	26,	68.00,	4,	104),
('Geometria Analítica',	1,	95.00,	3,	105),
('Gramática Reflexiva',	10,	49.00,	5,	106),
('Fundamentos de Física III',	1,	78.00,	4,	104),
('Calculo B',	3,	95.00,	3,	103)

SELECT * FROM [estoque]

INSERT INTO compras VALUES
(15051,	10003,	2,	158.00,	'04/07/2020'),
(15051,	10008,	1,	95.00,	'04/07/2020'),
(15051,	10004,	1,	68.00,	'04/07/2020'),
(15051,	10007,	1,	78.00,	'04/07/2020'),
(15052,	10006,	1,	49.00,	'05/07/2020'),
(15052,	10002,	3,	165.00,	'05/07/2020'),
(15053,	10001,	1,	108.00,	'05/07/2020'),
(15054,	10003,	1,	79.00,	'06/08/2020'),
(15054,	10008,	1,	95.00,	'06/08/2020')

SELECT * FROM [compras]

--Pede-se:												
--Consultar nome, valor unitário, nome da editora e nome do autor dos livros do estoque que foram vendidos. Não podem haver repetições.
SELECT DISTINCT e.nome AS LIVRO, e.valor AS VALOR_UNITARIO, ed.nome AS EDITORA, a.nome AS AUTOR 
FROM estoque e INNER JOIN autor a
ON e.cod_autor = a.codigo INNER JOIN editora ed 
ON e.cod_editora = ed.codigo INNER JOIN compras c
ON e.codigo = c.cod_livro
									
--Consultar nome do livro, quantidade comprada e valor de compra da compra 15051
SELECT e.nome AS LIVRO, c.qtd_comprada AS QUANTIDADE, c.valor AS VALOR 
FROM estoque e INNER JOIN compras c
ON e.codigo = c.cod_livro
WHERE c.codigo = 15051
											
--Consultar Nome do livro e site da editora dos livros da Makron books (Caso o site tenha mais de 10 dígitos, remover o www.).	
SELECT e.nome AS LIVRO, 
	CASE WHEN (LEN(ed.sites) > 10)
			THEN
			SUBSTRING(ed.sites,5 ,13)
			ELSE 
			ed.sites 
			END AS SITE_EDITORA
FROM estoque e INNER JOIN editora ed
ON e.cod_editora = ed.codigo
WHERE ed.nome = 'Makron books'
											
--Consultar nome do livro e Breve Biografia do David Halliday
SELECT e.nome AS LIVRO, a.breve_biografia AS BREVE_BIOGRAFIA
FROM estoque e INNER JOIN autor a
ON e.cod_autor = a.codigo
WHERE a.nome = 'David Halliday'	
											
--Consultar código de compra e quantidade comprada do livro Sistemas Operacionais Modernos
SELECT c.codigo AS CODIGO, c.qtd_comprada AS QUANTIDADE
FROM compras c INNER JOIN estoque e
ON	e.codigo = c.cod_livro
WHERE e.nome = 'Sistemas Operacionais Modernos'
											
--Consultar quais livros não foram vendidos	
SELECT e.nome AS Não_foi_vendido
FROM estoque e LEFT OUTER JOIN compras c
ON 	e.codigo = c.cod_livro
WHERE c.cod_livro IS NULL		
								
--Consultar quais livros foram vendidos e não estão cadastrados	
SELECT  e.nome AS LIVRO_VENDIDO_NÃO_CADASTRADO
FROM estoque e INNER JOIN compras c
ON e.codigo = c.cod_livro
WHERE e.quantidade - c.qtd_comprada < 0
											
--Consultar Nome e site da editora que não tem Livros no estoque (Caso o site tenha mais de 10 dígitos, remover o www.)
SELECT ed.nome AS EDITORA,
		CASE WHEN (LEN(ed.sites) > 10)
			THEN
			RTRIM(SUBSTRING(ed.sites,5 ,14))
			END AS SITE_EDITORA
FROM estoque e RIGHT OUTER JOIN editora ed
ON e.cod_editora = ed.codigo
WHERE e.cod_editora IS NULL		
										
--Consultar Nome e biografia do autor que não tem Livros no estoque (Caso a biografia inicie com Doutorado, substituir por Ph.D.)	
SELECT a.nome AS AUTOR, 
	CASE WHEN (a.breve_biografia LIKE 'doutorado%')
			THEN 'Ph.D.'+ SUBSTRING(a.breve_biografia, 10, 50)
			ELSE a.breve_biografia
			END AS BIOGRAFIA
FROM autor a LEFT OUTER JOIN estoque e
ON a.codigo = e.cod_autor	
WHERE e.cod_autor IS NULL	

--Consultar o nome do Autor, e o maior valor de Livro no estoque. Ordenar por valor descendente	
SELECT a.nome AS AUTOR, MAX(e.valor) AS VALOR_LIVROS  
FROM autor a INNER JOIN estoque e
ON e.cod_autor = a.codigo
GROUP BY a.nome, e.valor
ORDER BY e.valor DESC
 									
--Consultar o código da compra, o total de livros comprados e a soma dos valores gastos. Ordenar por Código da Compra ascendente.
SELECT codigo AS CODIGO, SUM (qtd_comprada) AS TOTAL_LIVROS, SUM (valor) AS SOMA_VALORES
FROM compras 		
GROUP BY codigo		
ORDER BY codigo ASC
					
--Consultar o nome da editora e a média de preços dos livros em estoque.Ordenar pela Média de Valores ascendente.
SELECT ed.nome AS EDITORA, CAST(AVG (e.valor) AS DECIMAL(7,2)) AS MEDIA
FROM editora ed INNER JOIN estoque e
ON e.cod_editora = ed.codigo
GROUP BY ed.nome
ORDER BY MEDIA ASC
												
--Consultar o nome do Livro, a quantidade em estoque o nome da editora, o site da editora (Caso o site tenha mais de 10 dígitos, remover o www.), criar uma coluna status onde:												
	--Caso tenha menos de 5 livros em estoque, escrever Produto em Ponto de Pedido											
	--Caso tenha entre 5 e 10 livros em estoque, escrever Produto Acabando											
	--Caso tenha mais de 10 livros em estoque, escrever Estoque Suficiente											
	--A Ordenação deve ser por Quantidade ascendente			
SELECT e.nome AS LIVRO, e.quantidade AS ESTOQUE, ed.nome AS EDITORA, 
		CASE WHEN (LEN(ed.sites) > 10)
			THEN
			SUBSTRING(ed.sites,5 ,50)
			ELSE 
			ed.sites 
			END AS SITES,

		CASE WHEN (e.quantidade < 5)
			THEN
			'Produto em Ponto de Pedido'
			WHEN (e.quantidade >= 5 AND e.quantidade <= 10 )
			THEN
			'Produto Acabando'
			WHEN (e.quantidade > 10)
			THEN
			'Estoque Suficiente'
			END AS SITUAÇÃO

FROM estoque e INNER JOIN editora ed
ON e.cod_editora = ed.codigo
ORDER BY e.quantidade ASC			
					
--Para montar um relatório, é necessário montar uma consulta com a seguinte saída: Código do Livro, Nome do Livro, Nome do Autor, Info Editora (Nome da Editora + Site) de todos os livros												
	--Só pode concatenar sites que não são nulos
SELECT e.codigo AS CODIGO, e.nome AS LIVRO, a.nome AS AUTOR, 
		CASE WHEN (ed.sites IS NOT NULL)
		THEN 
		(ed.nome + ' (' + ed.sites + ')') 
		ELSE
		(ed.nome + ' (**)')
		END AS INFO_EDITORA
FROM estoque e INNER JOIN autor a
ON e.cod_autor = a.codigo INNER JOIN editora ed
ON e.cod_editora = ed.codigo		
									
--Consultar Codigo da compra, quantos dias da compra até hoje e quantos meses da compra até hoje
SELECT codigo AS CODIGO, DATEDIFF (DAY, data_compra, GETDATE()) AS DIAS, DATEDIFF (MONTH, data_compra, GETDATE()) AS MESES
FROM compras

--Consultar o código da compra e a soma dos valores gastos das compras que somam mais de 200.00
SELECT codigo AS CODIGO, SUM (valor) AS SOMA
FROM compras
GROUP BY codigo
HAVING SUM (valor) > 200