CREATE DATABASE EMPRESA
GO
USE EMPRESA

/*
A coluna users_id da tabela associativa é FK da coluna id, tabela users
A coluna projects_id da tabela associativa é FK da coluna id, tabela projects
A coluna date da tabela projects deve verificar se a data é posterior que 01/09/2014.
Caso contrário, o registro não deve ser inserido
A PK de projects deve ser de auto incremento, iniciando em 10001, com incremento de
1
A PK de users deve ser de auto incremento, iniciando em 1, com incremento de 1
O valor padrão da coluna password da tabela users, deverá ser 123mudar
A coluna username da tabela users deve ter restrição de unicidade.
*/

CREATE TABLE [users](
id			INT			NOT NULL		IDENTITY,
name		VARCHAR(45) NOT NULL,
username	VARCHAR(45)	NOT NULL	UNIQUE,
password	VARCHAR(45) NOT NULL	DEFAULT('123mudar'),
email		VARCHAR(45) NOT NULL
PRIMARY KEY(id)
)

CREATE TABLE [projects](
id			INT			NOT NULL		IDENTITY(10001,1),
name		VARCHAR(45)	NOT NULL,
description	VARCHAR(45) NULL,
date		VARCHAR(45) NOT NULL		CHECK(date > '01/09/2014')
PRIMARY KEY(id)
)

CREATE TABLE [users_has_projects](
users_id		INT		NOT NULL,
projects_id		INT		NOT NULL
PRIMARY KEY(users_id, projects_id)
FOREIGN KEY(users_id) REFERENCES [users](id),
FOREIGN KEY(projects_id) REFERENCES [projects](id)
)

--Modificar a coluna username da tabela Users para varchar(10)
--Como queremos modificar a coluna para um tamanho menor:
--1º como username é UNIQUE, precisamos dropar essa CONSTRAINT
ALTER TABLE [users]
DROP CONSTRAINT UQ__users__F3DBC5724C2FAD66
--2º agora podemos alterar o tamanho da coluna
ALTER TABLE [users]
ALTER COLUMN username	VARCHAR(10)		NOT NULL
--3º agora adicionamos a CONSTRAINT UNIQUE para a coluna username
ALTER TABLE [users]
ADD CONSTRAINT AK_username UNIQUE (username)


--Modificar a coluna password da tabela Users para varchar(8)
ALTER TABLE [users]
ALTER COLUMN password	VARCHAR(8)		NOT NULL

--Inserindo dados na tabela users
INSERT INTO [users] (name, username, email)
VALUES('Maria', 'Rh_maria', 'maria@empresa.com')

INSERT INTO [users] (name, username, password, email)
VALUES ('Paulo', 'Ti_paulo', '123@456', 'paulo@empresa.com')

INSERT INTO [users] (name, username, email) VALUES
('Ana', 'Rh_ana', 'ana@empresa.com'),
('Clara', 'Ti_clara', 'clara@empresa.com')

INSERT INTO [users] (name, username, password, email)
VALUES ('Aparecido', 'Rh_apareci', '55@!cido', 'aparecido@empresa.com')

SELECT * FROM [users]

--Inserindo dados na tabela [projects]
INSERT INTO [projects] (name, description, date) VALUES
('Re-folha', 'Refatoração das Folhas', '05/09/2014'),
('Manutenção PC´s', 'Manutenção PC´s', '06/09/2014'),
('Auditoria', NULL, '07/09/2014')

SELECT * FROM [projects]

--Inserindo dados na tabela [users_has_projects]
INSERT INTO [users_has_projects] (users_id, projects_id) VALUES
(1, 10001),
(5, 10001),
(3, 10003),
(4, 10002),
(2, 10002)

SELECT * FROM [users_has_projects]

--O projeto de Manutenção atrasou, mudar a data para 12/09/2014
UPDATE [projects]
SET date = '12/09/2014'
WHERE id = 10002

SELECT * FROM [projects]

--O username de aparecido (usar o nome como condição de mudança) está feio, mudar para Rh_cido
UPDATE [users]
SET username = 'Rh_cido'
WHERE name = 'Aparecido'

SELECT * FROM [users]

/* Mudar o password do username Rh_maria (usar o username como condição de mudança) 
para 888@*, mas a condição deve verificar se o password dela ainda é 123mudar */

--Testando primeiro com um password que não existe
UPDATE [users]
SET password = '888@*'
WHERE username = 'Rh_maria' AND password = '1234'

UPDATE [users]
SET password = '888@*'
WHERE username = 'Rh_maria' AND password = '123mudar'

SELECT * FROM [users]

--O user de id 2 não participa mais do projeto 10002, removê‐lo da associativa
DELETE [users_has_projects]
WHERE users_id = 2

SELECT * FROM [users_has_projects]

--Adicionar uma coluna budget DECIMAL(7,2) NULL na tabela Project
ALTER TABLE [projects]
ADD budget	DECIMAL(7,2)	NULL

SELECT * FROM [projects]

/* Atualizar a coluna budget com:
5750.00 para id 10001
7850.00 para id 10002
9530.00 para id 10003
*/
UPDATE [projects]
SET budget = 5750.00
WHERE id = 10001

UPDATE [projects]
SET budget = 7850.00
WHERE id = 10002

UPDATE [projects]
SET budget = 9530.00
WHERE id = 10003

SELECT * FROM [projects]

--Consultar:
--1) username e password da Ana
SELECT username, password
FROM [users]
WHERE name = 'Ana'

--2) nome, budget e valor hipotético de um budget 25% maior
SELECT name, budget, CAST(budget * 1.25 AS DECIMAL(7,2)) AS budget_25
FROM [projects]

--3) id, nome e e-mail do usuário que ainda mantém o password padrão (123mudar)
SELECT id, name, email
FROM [users]
WHERE password = '123mudar'

--4) id, nome dos budgets cujo valor está entre 2000.00 e 8000.00
SELECT id, name, budget
FROM [projects]
WHERE budget BETWEEN 2000 AND 8000
