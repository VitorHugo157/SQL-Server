--Exercicios03.xls
CREATE DATABASE MEDICO
GO
USE MEDICO

CREATE TABLE [Paciente](
cpf				CHAR(11)		NOT NULL,
nome_paciente	VARCHAR(45)		NOT NULL,
logradouro		VARCHAR(45)		NOT NULL,
num_logradouro	INT				NOT NULL	CHECK(num_logradouro > 0),
bairro			VARCHAR(45)		NOT NULL	DEFAULT('Centro'),
telefone		VARCHAR(9)		NULL
PRIMARY KEY(cpf)
)

CREATE TABLE [Medico](
codigo			INT				NOT NULL	IDENTITY,
nome_medico		VARCHAR(45)		NOT NULL,
especialidade	VARCHAR(45)		NOT NULL
PRIMARY KEY(codigo)
)

CREATE TABLE [Prontuario](
data_consulta		DATE		NOT NULL,
cpf_paciente		CHAR(11)	NOT NULL,
codigo_medico		INT			NOT NULL,
diagnostico			VARCHAR(45)	NOT NULL,
medicamento			VARCHAR(45)	NOT NULL
PRIMARY KEY(data_consulta, cpf_paciente, codigo_medico)
FOREIGN KEY(cpf_paciente) REFERENCES [Paciente](cpf),
FOREIGN KEY(codigo_medico) REFERENCES [Medico](codigo)
)

--Inserindo dados nas tabelas
INSERT INTO [Paciente] (cpf, nome_paciente, logradouro, num_logradouro, telefone)
VALUES
('35454562890', 'Jos� Rubens', 'Campos Salles', 2750, '21450998'),
('29865439810', 'Ana Claudia', 'Sete de Setembro', 178, '97382764'),
('92173458910', 'Joana de Souza', 'XV de Novembro', 298, '21276578')

INSERT INTO [Paciente]
VALUES
('82176534800', 'Marcos Aur�lio', 'Tim�teo Penteado', 236, 'Vila Galv�o', '68172651'),
('12386758770', 'Maria Rita', 'Castello Branco', 7765, 'Vila Ros�lia', NULL)

SELECT * FROM [Paciente]

INSERT INTO [Medico]
VALUES
('Wilson Cesar', 'Pediatra'),
('Marcia Matos', 'Geriatria'),
('Carolina Oliveira', 'Ortopedista'),
('Vinicius Araujo', 'Cl�nico Geral')

SELECT * FROM [Medico]

INSERT INTO [Prontuario]
VALUES
('10/09/2020', '35454562890', 2, 'Reumatismo', 'Celebra'),
('10/09/2020', '92173458910', 2, 'Renite Al�rgica', 'Allegra'),
('12/09/2020', '29865439810', 1, 'Inflama��o de garganta', 'Nimesulida'),
('13/09/2020', '35454562890', 2, 'H1N1', 'Tamiflu'),
('15/09/2020', '82176534800', 4, 'Gripe', 'Resprin'),
('15/09/2020', '12386758770', 3, 'Bra�o Quebrado', 'Dorflex + Gesso')

SELECT * FROM [Prontuario]

--Consultar
--Nome e Endere�o (concatenado) dos pacientes com mais de 50 anos
SELECT nome_paciente, logradouro + ', ' + CAST(num_logradouro AS VARCHAR(10))
		+ ' - ' + bairro AS endereco 
FROM [Paciente]

--Qual a especialidade de Carolina Oliveira
SELECT especialidade
FROM [Medico]
WHERE nome_medico = 'Carolina Oliveira'

--Qual medicamento receitado para reumatismo
SELECT medicamento
FROM Prontuario
WHERE diagnostico = 'Reumatismo'

--Consultar em subqueries
--Diagn�stico e Medicamento do paciente Jos� Rubens em suas consultas
SELECT diagnostico, medicamento
FROM [Prontuario]
WHERE cpf_paciente IN
(
	SELECT cpf
	FROM [Paciente]
	WHERE nome_paciente = 'Jos� Rubens'
)

/*Nome e especialidade do(s) M�dico(s) que atenderam Jos� Rubens. 
Caso a especialidade tenha mais de 3 letras, mostrar apenas as 3 primeiras letras concatenada com um ponto final (.)
*/
SELECT nome_medico, 
	CASE WHEN LEN(especialidade) > 3
		THEN
			SUBSTRING(especialidade, 1, 3) + '.'
		ELSE
			especialidade
	END AS especialidade_medico
FROM [Medico]
WHERE codigo IN
(
	SELECT codigo_medico
	FROM [Prontuario]
	WHERE cpf_paciente IN
	(
		SELECT cpf
		FROM [Paciente]
		WHERE nome_paciente = 'Jos� Rubens'
	)
)

/*CPF (Com a m�scara XXX.XXX.XXX-XX), Nome, Endere�o completo (Rua, n� - Bairro), 
Telefone (Caso nulo, mostrar um tra�o (-)) dos pacientes do m�dico Vinicius
*/
SELECT SUBSTRING(cpf, 1, 3) + '.' + SUBSTRING(cpf, 4, 3) + '.' + SUBSTRING(cpf, 7, 3)  + '-' + SUBSTRING(cpf, 10, 2) AS cpf_paciente,
	nome_paciente, logradouro + ', ' + CAST(num_logradouro AS VARCHAR(10)) + ' - ' + bairro AS endereco,
	CASE WHEN (telefone IS NULL)
		THEN
			' - '
		ELSE
			SUBSTRING(telefone, 1, 4) + '-' + SUBSTRING(telefone, 5, 4)
	END AS telefone_paciente
FROM [Paciente]
WHERE cpf IN
(
	SELECT cpf_paciente
	FROM [Prontuario]
	WHERE codigo_medico IN
	(
		SELECT codigo
		FROM [Medico]
		WHERE nome_medico LIKE 'Vinicius%'
	)
)

--Quantos dias fazem da consulta de Maria Rita at� hoje
SELECT DATEDIFF(DAY, data_consulta, GETDATE()) AS dias_desde_a_consulta
FROM [Prontuario]
WHERE cpf_paciente IN
(
	SELECT cpf
	FROM [Paciente]
	WHERE nome_paciente = 'Maria Rita'
)

--Alterar o telefone da paciente Maria Rita, para 98345621
UPDATE [Paciente]
SET telefone = '98345621'
WHERE nome_paciente = 'Maria Rita'

SELECT SUBSTRING(telefone, 1, 4) + '-' + SUBSTRING(telefone, 5, 4) AS telefone
FROM [Paciente] 
WHERE nome_paciente = 'Maria Rita'

--Alterar o Endere�o de Joana de Souza para Volunt�rios da P�tria, 1980, Jd. Aeroporto
UPDATE [Paciente]
SET logradouro = 'Volunt�rios da P�tria',
	num_logradouro = 1980,
	bairro = 'Jd. Aeroporto'
WHERE nome_paciente = 'Joana de Souza'

SELECT logradouro + ', ' + CAST(num_logradouro AS VARCHAR(10)) + ' - ' + bairro AS endereco
FROM [Paciente]
WHERE nome_paciente = 'Joana de Souza'
