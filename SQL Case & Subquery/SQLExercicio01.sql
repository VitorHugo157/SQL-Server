--Exercicios01.xls
CREATE DATABASE FACULDADE
GO
USE FACULDADE

CREATE TABLE [Aluno](
ra				INT				NOT NULL	IDENTITY(12345, 1),
nome_aluno		VARCHAR(45)		NOT NULL,
sobrenome		VARCHAR(45)		NOT NULL,
logradouro		VARCHAR(45)		NOT NULL,
num_logradouro	INT				NOT NULL	CHECK(num_logradouro > 0),
bairro			VARCHAR(45)		NOT NULL,
cep				CHAR(8)			NOT NULL,
telefone		CHAR(8)			NULL
PRIMARY KEY(ra)
)

CREATE TABLE [Curso](
codigo_curso		INT				NOT NULL	IDENTITY,
nome_curso			VARCHAR(45)		NOT NULL,
carga_horaria_curso	INT				NOT NULL	CHECK(carga_horaria_curso > 0),
turno_curso			CHAR(5)			NOT NULL	CHECK(turno_curso='Tarde' OR turno_curso='Noite'),
PRIMARY KEY(codigo_curso)
)

CREATE TABLE [Disciplina](
codigo_disciplina		 INT			NOT NULL	IDENTITY,
nome_disciplina			 VARCHAR(45)	NOT NULL,
carga_horaria_disciplina INT			NOT NULL	CHECK(carga_horaria_disciplina > 0),
turno_disciplina		 CHAR(5)		NOT NULL	CHECK(turno_disciplina='Tarde' OR turno_disciplina='Noite'),
semestre				 INT			NOT NULL	CHECK(semestre > 0),
PRIMARY KEY(codigo_disciplina)
)

--Inserindo dados nas tabelas
INSERT INTO [Aluno] 
VALUES
('Jos�', 'Silva', 'Almirante Noronha', 236, 'Jardim S�o Paulo', '01589000', '69875287'),
('Ana', 'Maria Bastos', 'Anhaia', 1568, 'Barra Funda', '03569000', '25698526'),
('Mario', 'Santos', 'XV de Novembro', 1841, 'Centro', '01020030', NULL),
('Marcia', 'Neves', 'Volut�nrios da Patria', 225, 'Santana', '02785090', '78964152')

SELECT * FROM [Aluno]

INSERT INTO [Curso]
VALUES
('Inform�tica', 2800, 'Tarde'),
('Inform�tica', 2800, 'Noite'),
('Log�stica', 2650, 'Tarde'),
('Log�stica', 2650, 'Noite'),
('Pl�sticos', 2500, 'Tarde'),
('Pl�sticos', 2500, 'Noite')

SELECT * FROM [Curso]

INSERT INTO [Disciplina]
VALUES
('Inform�tica', 4, 'Tarde', 1),
('Inform�tica', 4, 'Noite', 1),
('Quimica', 4, 'Tarde', 1),
('Quimica', 4, 'Noite', 1),
('Banco de Dados I', 2, 'Tarde', 3),
('Banco de Dados I', 2, 'Noite', 3),
('Estrutura de Dados', 4, 'Tarde', 4),
('Estrutura de Dados', 4, 'Noite', 4)

SELECT * FROM [Disciplina]

--Consultar:
--Nome e sobrenome, como nome completo dos Alunos Matriculados					
SELECT nome_aluno + ' ' + sobrenome AS nome_completo
FROM [Aluno]

--Rua, n�, Bairro e CEP como Endere�o do aluno que n�o tem telefone					
SELECT logradouro + ', ' + CAST(num_logradouro AS VARCHAR(10)) + ' - ' + 
	bairro + ' ' + SUBSTRING(cep, 1, 5) + '-' + SUBSTRING(cep, 6, 8) AS endereco
FROM [Aluno]
WHERE telefone IS NULL

--Telefone do aluno com RA 12348		
SELECT SUBSTRING(telefone, 1, 4) + '-' + SUBSTRING(telefone, 5, 4) AS telefone_aluno
FROM [Aluno]
WHERE ra = 12348

--Nome e Turno dos cursos com 2800 horas			
SELECT nome_curso, turno_curso
FROM [Curso]
WHERE carga_horaria_curso = 2800

--O semestre da disciplina de Banco de Dados I noite			
SELECT semestre
FROM [Disciplina]
WHERE nome_disciplina = 'Banco de Dados I' AND turno_disciplina = 'Noite'
