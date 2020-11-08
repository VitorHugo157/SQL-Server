--Funções com caracteres
--SUBSTRING(CHAR, Pos Inicial, Deslocamento)
--RTRIM(CHAR) || LTRIM(CHAR)
SELECT SUBSTRING('Banco de Dados', 1, 5) AS separado
SELECT SUBSTRING('Banco de Dados', 7, 2) AS separado
SELECT SUBSTRING('Banco de Dados', 10, 5) AS separado

SELECT SUBSTRING('Banco de Dados', 1, 5) AS separado1, 
		SUBSTRING('Banco de Dados', 7, 2) AS separado2, 
		SUBSTRING('Banco de Dados', 10, 5) AS separado3

SELECT SUBSTRING(SUBSTRING('Banco de Dados', 1, 5), 4, 2) AS sub_do_sub

SELECT SUBSTRING('Banco de Dados', 1, 5) AS separado
SELECT SUBSTRING('Banco de Dados', 1, 6) AS separado
SELECT RTRIM(SUBSTRING('Banco de Dados', 1, 6)) AS separado_com_rtrim

SELECT SUBSTRING('Banco de Dados', 9, 6) AS separado
SELECT LTRIM(SUBSTRING('Banco de Dados', 9, 6)) AS separado_com_ltrim

SELECT RTRIM(LTRIM(SUBSTRING('Banco de Dados', 6, 4))) AS separado

--Funções com datas
--DATEPART(Intervalo, DATETIME)
--DATEADD(Intervalo, INT, DATETIME) RET DATETIME
--DATEDIFF(Intervalo, DATETIME, DATETIME) RET INT

--Não façam isso em casa, crianças !
SELECT CAST(SUBSTRING(CONVERT(CHAR(10),GETDATE(),103), 1, 2) AS INT) AS dia_hoje

SELECT DAY(GETDATE()) AS dia_hoje
SELECT MONTH(GETDATE()) AS mes_hoje
SELECT YEAR(GETDATE()) AS ano_hoje

SELECT DAY(GETDATE()) AS dia_hoje, MONTH(GETDATE()) AS mes_hoje, 
		YEAR(GETDATE()) AS ano_hoje

SELECT DATEPART(DD, GETDATE()) AS dia_hoje
SELECT DATEPART(MM, GETDATE()) AS mes_hoje
SELECT DATEPART(YY, GETDATE()) AS ano_hoje
SELECT DATEPART(WEEKDAY, GETDATE()) AS dia_semana_hoje
SELECT DATEPART(DAYOFYEAR, GETDATE()) AS dia_ano_hoje
SELECT DATEPART(WEEK, GETDATE()) AS semana_ano_hoje

SELECT DATEPART(DD, GETDATE()) AS dia_hoje ,DATEPART(MM, GETDATE()) AS mes_hoje, 
	DATEPART(YY, GETDATE()) AS ano_hoje ,
	DATEPART(WEEKDAY, GETDATE()) AS dia_semana_hoje, 
	DATEPART(DAYOFYEAR, GETDATE()) AS dia_ano_hoje, 
	DATEPART(WEEK, GETDATE()) AS semana_ano_hoje

SELECT DATEPART(WEEKDAY, '1979-10-03') AS dia_semana

SELECT DATEDIFF(YEAR, '1979-12-03', GETDATE()) AS dif_anos
SELECT DATEDIFF(MONTH, '1979-12-03', GETDATE()) AS dif_meses
SELECT DATEDIFF(DAY, '1979-12-03', GETDATE()) AS dif_dias

SELECT DATEADD(DAY, 3, GETDATE()) AS daqui_3_dias
SELECT CONVERT(CHAR(10), DATEADD(DAY, 3, GETDATE()), 103) AS daqui_3_dias

SELECT DATEDIFF(YEAR, '1979-12-03', GETDATE()) - 1 AS dif_anos
--Novos dados
INSERT INTO funcionario
VALUES 
('Fulano','da Silva Jr.','R. Voluntários da Patria',8150,NULL,'05423110','11','32549874','1990-09-09',1235.00),
('João','dos Santos','R. Anhaia',150,NULL,'03425000','11','45879852','1973-08-19',2352.00),
('Maria','dos Santos','R. Pedro de Toledo',18,NULL,'04426000','11','32568974','1982-03-05',4550.00)

SELECT * FROM funcionario
SELECT * FROM projeto
SELECT * FROM funcproj


--Consultar nome completo e CEP mascarado(XXXXX-XXX)
SELECT id, nome + ' ' + sobrenome AS nome_completo, 
	SUBSTRING(cep, 1, 5) + '-' + SUBSTRING(cep, 6 , 3) AS cep
FROM funcionario

--Consultar nome completo e telefone mascarado, com ddd (XX)XXXX-XXXX
SELECT id, nome + ' ' + sobrenome AS nome_completo, 
	'('+ddd+')' + SUBSTRING(telefone, 1, 4) + '-' + SUBSTRING(telefone, 5, 4) AS tel
FROM funcionario

--Condicional em SQL 
--CASE semelhante ao SWITCH CASE
/*SINTAXE:
	CASE(coluna)
		WHEN condição1 THEN
			Programação
		WHEN condição2 THEN
			Outra programação
		...
		ELSE
			Otra Programação
	END
*/
/*SINTAXE 2:
	CASE WHEN (Teste lógico)
		THEN
			Programação
		ELSE
			Outra Programação
	END
*/
--Caso seja celular ?
SELECT id, nome + ' ' + sobrenome AS nome_completo,
	tel = CASE(CAST(SUBSTRING(telefone, 1, 1) AS INT))
		WHEN 6 THEN
			'('+ddd+')9' + SUBSTRING(telefone, 1, 4) + '-' + SUBSTRING(telefone, 5, 4)
		WHEN 7 THEN
			'('+ddd+')9' + SUBSTRING(telefone, 1, 4) + '-' + SUBSTRING(telefone, 5, 4)
		WHEN 8 THEN
			'('+ddd+')9' + SUBSTRING(telefone, 1, 4) + '-' + SUBSTRING(telefone, 5, 4)
		WHEN 9 THEN
			'('+ddd+')9' + SUBSTRING(telefone, 1, 4) + '-' + SUBSTRING(telefone, 5, 4)
		ELSE
			'('+ddd+')' + SUBSTRING(telefone, 1, 4) + '-' + SUBSTRING(telefone, 5, 4)
	END
FROM funcionario

--De outro jeito
SELECT id, nome + ' ' + sobrenome AS nome_completo,
	CASE WHEN (CAST(SUBSTRING(telefone, 1, 1) AS INT) >= 6) 
		THEN
			'('+ddd+')9' + SUBSTRING(telefone, 1, 4) + '-' + SUBSTRING(telefone, 5, 4)
		ELSE
			'('+ddd+')' + SUBSTRING(telefone, 1, 4) + '-' + SUBSTRING(telefone, 5, 4)
	END AS tel
FROM funcionario

--Consultar nome completo, com endereço completo (possível NULL)
SELECT * FROM funcionario

SELECT id, nome + ' ' + sobrenome AS nome_completo,
	logradouro + ',' + CAST(numero AS VARCHAR(5)) + ' - ' + bairro AS endereco_completo
FROM funcionario

--Corrigir com CASE
SELECT id, nome + ' ' + sobrenome AS nome_completo,
	CASE WHEN (bairro IS NOT NULL)
		THEN
			logradouro + ',' + CAST(numero AS VARCHAR(5)) + ' - ' + bairro 
		ELSE
			logradouro + ',' + CAST(numero AS VARCHAR(5))
	END AS endereco_completo
FROM funcionario


--Consultar nome completo, endereço completo, cep mascarado, 
--telefone com ddd mascarado e validação de celular
SELECT TOP(4) id, 
	nome + ' ' + sobrenome AS nome_completo,
	CASE WHEN (bairro IS NOT NULL)
		THEN
			logradouro + ',' + CAST(numero AS VARCHAR(5)) + ' - ' + bairro 
		ELSE
			logradouro + ',' + CAST(numero AS VARCHAR(5))
	END AS endereco_completo,
	SUBSTRING(cep, 1, 5) + '-' + SUBSTRING(cep, 6 , 3) AS cep,
	CASE WHEN (CAST(SUBSTRING(telefone, 1, 1) AS INT) >= 6) 
		THEN
			'('+ddd+')9' + SUBSTRING(telefone, 1, 4) + '-' + SUBSTRING(telefone, 5, 4)
		ELSE
			CASE WHEN (telefone IS NULL) 
				THEN 
					'(**)****-****'
				ELSE
					'('+ddd+')' + SUBSTRING(telefone, 1, 4) + '-' + SUBSTRING(telefone, 5, 4)
			END
	END AS tel
FROM funcionario
ORDER BY nome_completo

--Quantos dias trabalhados, por funcionário em cada projeto
SELECT id_funcionario, codigo_projeto, 
	DATEDIFF(DAY, data_inicio, data_fim) AS dias_trabalhados
FROM funcproj

SELECT id_funcionario, codigo_projeto, 
	DATEDIFF(DAY, data_inicio, data_fim) AS dias_trabalhados
FROM funcproj
WHERE id_funcionario = 1 AND codigo_projeto = 1002

--Funcionario 3 do projeto 1003 pediu mais 3 dias para finalizar o projeto, 
--qual será sua nova data final, convertida (BR - DD/MM/YYYY) ?
SELECT CONVERT(CHAR(10), DATEADD(DD, 3, data_fim), 103) AS nova_data_fim
FROM funcproj
WHERE id_funcionario = 3 AND codigo_projeto = 1003

--Quais codigos de projetos distintos tem menos de 10 dias trabalhados
SELECT DISTINCT codigo_projeto
FROM funcproj
WHERE DATEDIFF(DD, data_inicio, data_fim) < 10

--SUBCONSULTA - SUBQUERY - SUBSELECT
--IN ou NOT IN

--Nomes e descrições de projetos distintos tem menos de 10 dias trabalhados
SELECT codigo, nome, descricao
FROM projeto
WHERE codigo IN
(
	SELECT DISTINCT codigo_projeto
	FROM funcproj
	WHERE DATEDIFF(DD, data_inicio, data_fim) < 10
)

--Nomes completos dos Funcionários que estão no
--projeto Modificação do Módulo de Cadastro

SELECT nome + ' '+ sobrenome AS nome_completo
FROM funcionario
WHERE id IN
(
	SELECT id_funcionario
	FROM funcproj
	WHERE codigo_projeto IN
	(
		SELECT codigo
		FROM projeto
		WHERE nome = 'Modificação do Módulo de Cadastro'
	)
)

--Nomes completos e Idade, em anos (considere se fez ou ainda fará
--aniversário esse ano), dos funcionários
SELECT id, nome + ' ' + sobrenome AS nome_completo,
	CASE WHEN (MONTH(GETDATE()) > MONTH(data_nasc))
		THEN 
			DATEDIFF(YY, data_nasc, GETDATE()) 
		ELSE
			CASE WHEN (MONTH(GETDATE()) = MONTH(data_nasc) AND
						DAY(GETDATE()) >= DAY(data_nasc))
				THEN
					DATEDIFF(YY, data_nasc, GETDATE())
				ELSE
					DATEDIFF(YY, data_nasc, GETDATE()) - 1
			END
	END AS idade
FROM funcionario

SELECT id, nome + ' ' + sobrenome AS nome_completo,
	DATEDIFF(DD, data_nasc, GETDATE()) / 365 AS idade
FROM funcionario

SELECT id, nome + ' ' + sobrenome AS nome_completo,
	CASE WHEN (MONTH(GETDATE()) > MONTH(data_nasc))
		THEN 
			DATEDIFF(YY, data_nasc, GETDATE()) 
		ELSE
			CASE WHEN (MONTH(GETDATE()) = MONTH(data_nasc) AND
						DAY(GETDATE()) >= DAY(data_nasc))
				THEN
					DATEDIFF(YY, data_nasc, GETDATE())
				ELSE
					DATEDIFF(YY, data_nasc, GETDATE()) - 1
			END
	END AS idade,
	DATEDIFF(DD, data_nasc, GETDATE()) / 365 AS idade
FROM funcionario
