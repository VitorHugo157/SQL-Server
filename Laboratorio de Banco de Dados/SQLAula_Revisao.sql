CREATE DATABASE Aula_Revisao
GO
USE Aula_Revisao

CREATE TABLE Aluno(
RA INT NOT NULL,
nome VARCHAR(100) NOT NULL,
idade INT NOT NULL CHECK(idade > 0)
PRIMARY KEY (RA)
)

CREATE TABLE Disciplina(
codigo INT NOT NULL,
nome VARCHAR(100) NOT NULL,
carga_horaria INT NOT NULL CHECK(carga_horaria >= 32)
PRIMARY KEY (codigo)
)

CREATE TABLE Titulacao(
codigo INT NOT NULL,
titulo VARCHAR(20) NOT NULL
PRIMARY KEY (codigo)
)

CREATE TABLE Professor(
registro INT NOT NULL,
nome VARCHAR(100) NOT NULL,
titulacao INT NOT NULL
PRIMARY KEY (registro)
FOREIGN KEY (titulacao) REFERENCES Titulacao(codigo)
)

CREATE TABLE Curso(
codigo INT NOT NULL,
nome VARCHAR(45) NOT NULL,
area VARCHAR(45) NOT NULL
PRIMARY KEY (codigo)
)

CREATE TABLE Aluno_Disciplina(
codigo_disciplina INT,
RA_aluno INT
PRIMARY KEY (codigo_disciplina, RA_aluno)
FOREIGN KEY (codigo_disciplina) REFERENCES Disciplina(codigo),
FOREIGN KEY (RA_aluno) REFERENCES Aluno(RA)
)

CREATE TABLE Professor_Disciplina(
codigo_disciplina INT,
registro_professor INT
PRIMARY KEY (codigo_disciplina, registro_professor)
FOREIGN KEY (codigo_disciplina) REFERENCES Disciplina(codigo),
FOREIGN KEY (registro_professor) REFERENCES Professor(registro)
)

CREATE TABLE Disciplina_Curso(
codigo_disciplina INT,
codigo_curso INT
PRIMARY KEY (codigo_disciplina, codigo_curso)
FOREIGN KEY (codigo_disciplina) REFERENCES Disciplina(codigo),
FOREIGN KEY (codigo_curso) REFERENCES Curso(codigo)
)

--A coluna idade na tabela aluno não é apropriada. Alterar a tabela criando uma coluna Ano_Nascimento INT.													
ALTER TABLE Aluno
ADD ano_nascimento INT

--Atualizar a coluna Ano_Nascimento usando uma única expressão, com DATEADD e GETDATE, inserindo apenas o ano.													
SELECT DATEADD(YEAR, 3, GETDATE()) AS daqui_3_dias
SELECT * FROM Aluno

--Excluir a coluna idade
ALTER TABLE Aluno
DROP CONSTRAINT CK__Aluno__idade__30F848ED

ALTER TABLE Aluno
DROP COLUMN idade

--Como fazer as listas de chamadas, com RA e nome por disciplina ?													

--Fazer uma pesquisa que liste o nome das disciplinas e o nome dos professores que as ministram													
SELECT d.nome, p.nome
FROM Professor p INNER JOIN Professor_Disciplina pd
ON p.registro = pd.registro_professor
INNER JOIN Disciplina d
ON d.codigo = pd.codigo_disciplina
WHERE d.codigo = pd.codigo_disciplina
	AND p.registro = pd.registro_professor

--Fazer uma pesquisa que , dado o nome de uma disciplina, retorne o nome do curso
SELECT nome
FROM Curso
WHERE codigo IN
(
	SELECT codigo_curso
	FROM Disciplina_Curso
	WHERE codigo_disciplina IN
	(
		SELECT codigo
		FROM Disciplina
		WHERE nome LIKE 'Laboratório de Banco de Dados'
	)
)

--Fazer uma pesquisa que , dado o nome de uma disciplina, retorne sua área													
SELECT area
FROM Curso
WHERE codigo IN
(
	SELECT codigo_curso
	FROM Disciplina_Curso
	WHERE codigo_disciplina IN
	(
		SELECT codigo
		FROM Disciplina
		WHERE nome LIKE 'Gestão de Estoques'
	)
)

--Fazer uma pesquisa que , dado o nome de uma disciplina, retorne o título do professor que a ministra													
SELECT titulo
FROM Titulacao
WHERE codigo IN
	(
		SELECT titulacao
		FROM Professor
		WHERE registro IN
		(
			SELECT registro_professor
			FROM Professor_Disciplina
			WHERE codigo_disciplina IN
			(
				SELECT codigo
				FROM Disciplina
				WHERE nome LIKE 'Laboratório de Banco de Dados'
			)
		)
	)

--Fazer uma pesquisa que retorne o nome da disciplina e quantos alunos estão matriculados em cada uma delas													
SELECT d.nome AS disciplina, COUNT(a.RA) as qtd_alunos
FROM Aluno_Disciplina al INNER JOIN Aluno a
ON al.RA_aluno = a.RA
INNER JOIN Disciplina d
ON d.codigo = al.codigo_disciplina
GROUP BY d.nome

/*Fazer uma pesquisa que, dado o nome de uma disciplina, retorne o nome do professor. 
Só deve retornar de disciplinas que tenham, no mínimo, 5 alunos matriculados*/													
SELECT p.nome AS nome_professor
FROM Professor_Disciplina pd INNER JOIN Professor p
ON pd.registro_professor = p.registro
INNER JOIN Disciplina d
ON pd.codigo_disciplina = d.codigo
INNER JOIN Aluno_Disciplina ad
ON ad.codigo_disciplina = d.codigo
INNER JOIN Aluno a
ON ad.RA_aluno = a.RA
WHERE d.nome LIKE 'Segurança%'
GROUP BY d.nome, p.nome
HAVING COUNT(a.RA) >= 5

/*Fazer uma pesquisa que retorne o nome do curso e a quantidade de professores cadastrados que ministram aula nele. 
A coluna deve se chamar quantidade*/													
SELECT c.nome, COUNT(DISTINCT pd.registro_professor) AS quantidade
FROM Professor_Disciplina pd INNER JOIN Professor p
ON pd.registro_professor = p.registro
INNER JOIN Disciplina d
ON pd.codigo_disciplina = d.codigo
INNER JOIN Disciplina_Curso dc
ON dc.codigo_disciplina = d.codigo
INNER JOIN Curso c
ON dc.codigo_curso = c.codigo
GROUP BY c.nome

