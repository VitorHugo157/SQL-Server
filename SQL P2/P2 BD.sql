--1) idDepto e depto do Depto que n�o tem usu�rios alocados
SELECT d.idDepto, d.depto
FROM [depto] d LEFT OUTER JOIN [usuario] u
ON d.idDepto = u.depto 
WHERE u.depto IS NULL

--2) Nomes distintos dos softwares usados pelos desenvolvedores 
--(Usar o termo desenvolvimento para a filtragemm da busca)
SELECT DISTINCT s.nome
FROM [software] s, [usuario] u, [depto] d, [maquina] m, [usuarioMaquina] um, [softwareMaquina] sm
WHERE d.depto = 'Desenvolvimento'
	AND u.depto = d.idDepto
	AND sm.idSoftware = s.idSoftware
	AND m.idMaquina = sm.idMaquina

--3) A quatidade de usuarios em cada departamento, em uma sa�da
--(depto | qtdUsuarios). A sa�da deve ser ordenada, de maneira crescente, por qtdUsuarios
SELECT d.idDepto, d.depto, COUNT(u.idUsuario) as qtdUsuarios
FROM [usuario] u, [depto] d
WHERE d.idDepto = u.depto
GROUP BY d.idDepto, u.depto, d.depto
ORDER BY qtdUsuarios ASC


--4) Nome do usuario, ramal dos usu�rios que ficam no per�odo da manh�
--(Usar o termo manh� para filtrar a busca). Se o nome do usu�rio tiver mais de 10 caracteres,
--limitar a exibi��o a 10 e colocar um ponto no final.
SELECT CASE WHEN(LEN(u.nome) > 10)
				THEN
					SUBSTRING(u.nome, 1, 10) + '.'
            END AS nome
, u.ramal, h.horario
FROM [usuario] u, [usuarioMaquina] um, [horario] h
WHERE u.idUsuario = um.idUsuario
	AND h.idHorario = um.horario
	AND um.horario = 1
