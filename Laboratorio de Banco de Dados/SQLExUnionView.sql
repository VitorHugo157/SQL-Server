/*
	Considere o MER abaixo do domínio de palestras em uma Faculdade. Palestrantes apresentarão 
palestras para alunos e não alunos. Para o caso de alunos, seus dados já são referenciáveis 
em outro sistema, portanto, basta saber seu RA, no entanto, para não alunos, para prover certificados, 
é importante saber seu RG e Órgão Expedidor. 

	O problema está no momento de gerar a lista de presença. 
A lista de presença deverá vir de uma consulta que retorna 
(Num_Documento, Nome_Pessoa, Titulo_Palestra, Nome_Palestrante, Carga_Horária e Data). 
A lista deverá ser uma só, por palestra (A condição da consulta é o código da palestra) 
e contemplar alunos e não alunos (O Num_Documento se referencia ao RA para alunos e RG + Orgao_Exp para não alunos) 
e estar ordenada pelo Nome_Pessoa. Fazer uma view de select que forneça a saída conforme se pede.
*/

CREATE DATABASE ExUnionView
GO
USE ExUnionView

CREATE TABLE Curso (
codigo_curso INT NOT NULL,
nome VARCHAR(70) NOT NULL,
sigla VARCHAR(10) NOT NULL
PRIMARY KEY (codigo_curso)
)

CREATE TABLE Palestrante (
codigo_palestrante INT IDENTITY,
nome VARCHAR(250) NOT NULL,
empresa VARCHAR(100) NOT NULL
PRIMARY KEY (codigo_palestrante)
)

CREATE TABLE Aluno (
RA CHAR(7) NOT NULL,
nome VARCHAR(250) NOT NULL,
codigo_curso INT NOT NULL
PRIMARY KEY (RA)
FOREIGN KEY (codigo_curso) REFERENCES Curso(codigo_curso)
)

CREATE TABLE Palestra (
codigo_palestra INT IDENTITY,
titulo VARCHAR(MAX) NOT NULL,
carga_horaria INT NULL,
data_palestra DATETIME NOT NULL,
codigo_palestrante INT NOT NULL
PRIMARY KEY (codigo_palestra)
FOREIGN KEY (codigo_palestrante) REFERENCES Palestrante(codigo_palestrante)
)

CREATE TABLE Alunos_Inscritos (
RA CHAR(7) NOT NULL,
codigo_palestra INT NOT NULL
PRIMARY KEY (RA, codigo_palestra)
FOREIGN KEY (RA) REFERENCES Aluno(RA),
FOREIGN KEY (codigo_palestra) REFERENCES Palestra(codigo_palestra)
)

CREATE TABLE Nao_Alunos (
RG VARCHAR(9) NOT NULL,
orgao_exp CHAR(5) NOT NULL,
nome VARCHAR(250) NOT NULL
PRIMARY KEY (RG, orgao_exp)
)

CREATE TABLE Nao_Alunos_Inscritos (
codigo_palestra INT NOT NULL,
RG VARCHAR(9) NOT NULL,
orgao_exp CHAR(5) NOT NULL
PRIMARY KEY (codigo_palestra, RG, orgao_exp)
FOREIGN KEY (codigo_palestra) REFERENCES Palestra(codigo_palestra),
FOREIGN KEY (RG, orgao_exp) REFERENCES Nao_Alunos(RG, orgao_exp)
)

INSERT INTO Curso VALUES
(1, 'Análise e Desenvolvimento de Sistemas', 'ADS'),
(2, 'Desenvolvimento de Software Multiplataforma', 'DSM'),
(3, 'Comércio Exterior', 'Comex'),
(4, 'Gestão de Recursos Humanos', 'RH')

INSERT INTO Palestrante VALUES
('Rafael Ireno', 'IBM'),
('Aline Divino', 'EISA')

INSERT INTO Aluno VALUES
('1110481', 'Vitor Hugo', 1),
('1110482', 'Ricardo Ferreira', 1),
('1110483', 'Gustavo Araújo', 1),
('1110484', 'Agata da Silva', 3),
('1110485', 'Rafaela Rosa', 3),
('1110486', 'Giovana dos Santos', 4),
('1110487', 'Carlos Guilherme', 2)

INSERT INTO Palestra VALUES
('Tudo sobre o Mainframe', 2, '06/02/2021', 1),
('Os desafios da programação na EISA', 1, '13/02/2021', 2)

INSERT INTO Nao_Alunos VALUES
('468735214', 'SSPSP', 'Pamela Palacio'),
('245917388', 'SSPRJ', 'Caique de Souza'),
('157166472', 'SSPRS', 'Karen Luisa'),
('511647384', 'SSPMG', 'Kaellen Macedo'),
('346589147', 'SSPSP', 'Mateus da Silva')

INSERT INTO Alunos_Inscritos VALUES
('1110486', 1),
('1110484', 1),
('1110481', 2),
('1110487', 1),
('1110485', 2),
('1110482', 2)

INSERT INTO Nao_Alunos_Inscritos VALUES
(1, '468735214', 'SSPSP'),
(2, '511647384', 'SSPMG'),
(2, '157166472', 'SSPRS'),
(1, '346589147', 'SSPSP'),
(1, '245917388', 'SSPRJ')


CREATE VIEW v_palestra
AS
SELECT a.RA AS Num_Documento, a.nome AS Nome_Pessoa, 
	pa.titulo AS Titulo_Palestra, pe.nome AS Nome_Palestrante, 
	pa.carga_horaria AS Carga_Horaria, CONVERT(CHAR(10), pa.data_palestra, 103) AS 'Data'
FROM Aluno a INNER JOIN Alunos_Inscritos ai
ON a.RA = ai.RA
INNER JOIN Palestra pa
ON pa.codigo_palestra = ai.codigo_palestra
INNER JOIN Palestrante pe
ON pe.codigo_palestrante = pa.codigo_palestrante
UNION
SELECT SUBSTRING(na.RG, 1, 2) + '.' + SUBSTRING(na.RG, 3, 3) + '.' + SUBSTRING(na.RG, 6, 3) + '-' + SUBSTRING(na.RG, 9, 1) 
	+ '/' + na.orgao_exp AS Num_Documento, na.nome AS Nome_Pessoa, 
	pa.titulo AS Titulo_Palestra, pe.nome AS Nome_Palestrante, 
	pa.carga_horaria AS Carga_Horaria, CONVERT(CHAR(10), pa.data_palestra, 103) AS 'Data'
FROM Nao_Alunos na INNER JOIN Nao_Alunos_Inscritos nai
ON na.RG = nai.RG AND na.orgao_exp = nai.orgao_exp
INNER JOIN Palestra pa
ON pa.codigo_palestra = nai.codigo_palestra
INNER JOIN Palestrante pe
ON pe.codigo_palestrante = pa.codigo_palestrante


--Código da palestra = 1
SELECT * 
FROM v_palestra 
WHERE Titulo_Palestra IN
(
	SELECT titulo
	FROM Palestra
	WHERE codigo_palestra = 1
)
ORDER BY Nome_Pessoa

--Código da palestra = 2
SELECT * 
FROM v_palestra 
WHERE Titulo_Palestra IN
(
	SELECT titulo
	FROM Palestra
	WHERE codigo_palestra = 2
)
ORDER BY Nome_Pessoa

