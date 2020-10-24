CREATE DATABASE LIVRARIA
GO
USE LIVRARIA

CREATE TABLE [LIVRO](
Codigo_Livro		INT				NOT NULL,
Nome				VARCHAR(100)	NOT NULL,
Lingua				VARCHAR(50)		NOT NULL	DEFAULT('PT-BR'),
Ano					INT				NOT NULL	CHECK(Ano >= 1990),
PRIMARY KEY(Codigo_livro)
)

CREATE TABLE [AUTOR](
Codigo_autor		INT				NOT NULL,
Nome				VARCHAR(100)	NOT NULL	UNIQUE,
Nascimento			DATE			NOT NULL,
Pais				VARCHAR(50)		NOT NULL,
Biografia			VARCHAR(MAX)	NOT NULL
PRIMARY KEY(Codigo_autor)
)

CREATE TABLE [LIVRO_AUTOR](
LIVROCodigo_livro	INT				NOT NULL,
AUTORCodigo_autor	INT				NOT NULL
PRIMARY KEY(LIVROCodigo_livro, AUTORCodigo_autor)
FOREIGN KEY(LIVROCodigo_livro) REFERENCES LIVRO(Codigo_livro),
FOREIGN KEY(AUTORCodigo_autor) REFERENCES AUTOR(Codigo_autor)
)

CREATE TABLE [EDICOES](
ISBN				INT				NOT NULL,
Preco				DECIMAL(7,2)	NOT NULL	CHECK(Preco >= 0),
Ano					INT				NOT NULL	CHECK(Ano >= 1993),
Num_paginas			INT				NOT NULL	CHECK(Num_paginas > 0),
Qtd_estoque			INT				NOT NULL
PRIMARY KEY(ISBN)
)

CREATE TABLE [EDITORA](
Codigo_editora		INT				NOT NULL,
Nome				VARCHAR(50)		NOT NULL	UNIQUE,
Logradouro			VARCHAR(255)	NOT NULL,
Numero				INT				NOT NULL	CHECK(numero >= 0),
CEP					CHAR(8)			NOT NULL,
Telefone			CHAR(11)		NOT NULL
PRIMARY KEY(Codigo_editora)
)

CREATE TABLE [LIVRO_EDICOES_EDITORA](
EDICOESISBN			   INT			NOT NULL,
EDITORACodigo_editora  INT			NOT NULL,
LIVROCodigo_livro	   INT			NOT NULL
PRIMARY KEY(EDICOESISBN, EDITORACodigo_editora, LIVROCodigo_livro)
FOREIGN KEY(EDICOESISBN) REFERENCES EDICOES(ISBN),
FOREIGN KEY(EDITORACodigo_editora) REFERENCES EDITORA(Codigo_editora),
FOREIGN KEY(LIVROCodigo_livro) REFERENCES LIVRO(Codigo_livro)
)

--Modificar o nome da coluna ano da tabela edicoes, para AnoEdicao
USE LIVRARIA
GO
EXEC sp_rename 'dbo.EDICOES.Ano', 'AnoEdicao', 'COLUMN';
GO

--Modificar o tamanho do varchar do Nome da editora de 50 para 30
ALTER TABLE [EDITORA]
ALTER COLUMN Nome		VARCHAR(30)		NOT NULL

--Modificar o tipo da coluna ano da tabela autor para int
ALTER TABLE [AUTOR]
DROP COLUMN Nascimento

ALTER TABLE [AUTOR]
ADD Ano		INT		NOT NULL


---------Inserindo dados na tabela [LIVRO]---------------------
INSERT INTO [LIVRO] (Codigo_Livro, Nome, Lingua, Ano)
VALUES (1001, 'CCNA 4.1', 'PT-BR', 2015)

--Testando o DEFAULT('PT-BR')
INSERT INTO [LIVRO] (Codigo_Livro, Nome, Ano)
VALUES (1002, 'HTML 5', 2017)

INSERT INTO [LIVRO] (Codigo_Livro, Nome, Lingua, Ano)
VALUES
(1003, 'Redes de Computadores', 'EN', 2010),
(1004, 'Android em Ação', 'PT-BR', 2018)

--Mostrando os dados da tebela [LIVRO]
SELECT * FROM [LIVRO]

---------Inserindo dados na tabela [AUTOR]---------------------
INSERT INTO [AUTOR] (Codigo_autor, Nome, Ano, Pais, Biografia)
VALUES
(10001, 'Inácio da Silva', 1975, 'Brasil', 'Programador WEB desde 1995'),
(10002, 'Andrew Tannenbaum', 1944, 'EUA', 'Chefe do Departamento de Sistemas de Computação da Universidade de Vrij'),
(10003, 'Luis Rocha', 1967, 'Brasil', 'Programador Mobile desde 2000'),
(10004, 'David Halliday', 1916, 'EUA', 'Físico PH.D desde 1941')

/*
OBS: Alterar a ordem da coluna Ano: clickar com botão direiro do mouse em cima da tabela [AUTOR],
clique em 'Design', agora só colocar na ordem que quiser e salvar.
*/

SELECT * FROM [AUTOR]

---------Inserindo dados na tabela [LIVRO_AUTOR]---------------------
INSERT INTO [LIVRO_AUTOR]
VALUES 
(1001, 10001),
(1002, 10003),
(1003, 10002),
(1004, 10003)

SELECT * FROM [LIVRO_AUTOR]

---------Inserindo dados na tabela [EDICOES]---------------------
INSERT INTO [EDICOES] (ISBN, Preco, Ano, Num_paginas, Qtd_estoque)
VALUES (0130661023, 189.99, 2018, 653, 10)

SELECT * FROM [EDICOES]

--A universidade do Prof. Tannenbaum chama-se Vrije e não Vrij, modificar
UPDATE [AUTOR]
SET Biografia = 'Chefe do Departamento de Sistemas de Computação da Universidade de Vrije'
WHERE Codigo_autor = 10002

SELECT * FROM [AUTOR]

--A livraria vendeu 2 unidades do livro 0130661023, atualizar
UPDATE [EDICOES]
SET Qtd_estoque = Qtd_estoque - 2
WHERE ISBN = 0130661023

SELECT * FROM [EDICOES]

--Por não ter mais livros do David Halliday, apagar o autor.
DELETE [AUTOR]
WHERE Codigo_autor = 10004

SELECT * FROM [AUTOR]

