CREATE DATABASE EXERCICIO13
GO
USE EXERCICIO13

create table empresa(
id int identity not null primary key,
nome varchar(50))

create table carro(
id int identity(1001,1) not null primary key,
marca varchar(50),
modelo varchar(50), 
idEmpresa int
foreign key (idEmpresa) references empresa(id))

create table viagem(
idCarro int not null,
distanciaPercorrida decimal(7,2),
dat char(10) not null
primary key (idCarro, dat)
foreign key (idCarro) references carro(id))

select * from carro
select * from empresa
select * from viagem


insert into empresa(nome) values
('Empresa 1'),
('Empresa 2'),
('Empresa 3'),
('Empresa 4'),
('Empresa 5'),
('Empresa 6')

insert into carro(idEmpresa, marca, modelo) values
(1,'Fiat', 'Uno'),
(1,'Renault', 'Sandero'),
(1,'Chevrolet','Celta'),
(1,'Fiat', 'Palio'),
(1,'Peugeot','307'),
(1,'Renault', 'Duster'),
(2,'Fiat', 'Bravo'),
(2,'Renault', 'Logan'),
(4,'Peugeot','207'),
(4,'Renault', 'Duster'),
(6,'Chevrolet','Celta'),
(6,'Fiat', 'Doblo'),
(6,'Volksvagen', 'Jetta')

insert into viagem values
(1006,97,'01/05/2016'),
(1005,2090,'02/05/2016'),
(1005,3387,'03/05/2016'),
(1005,487,'04/05/2016'),
(1004,3141,'05/05/2016'),
(1006,1895,'06/05/2016'),
(1005,3050,'07/05/2016'),
(1003,1974,'08/05/2016'),
(1005,1779,'09/05/2016'),
(1006,1727,'10/05/2016'),
(1002,641,'11/05/2016'),
(1004,1577,'12/05/2016'),
(1003,2697,'13/05/2016'),
(1005,832,'14/05/2016'),
(1002,2033,'15/05/2016'),
(1003,1930,'16/05/2016'),
(1005,2606,'17/05/2016'),
(1002,1424,'18/05/2016'),
(1005,2484,'19/05/2016'),
(1005,2711,'20/05/2016'),
(1003,3049,'21/05/2016'),
(1003,2446,'22/05/2016'),
(1003,1307,'23/05/2016'),
(1003,778,'24/05/2016'),
(1003,2202,'25/05/2016'),
(1004,2571,'26/05/2016'),
(1005,2736,'27/05/2016'),
(1003,3128,'28/05/2016'),
(1002,2513,'29/05/2016'),
(1006,1201,'30/05/2016'),
(1002,3319,'31/05/2016'),
(1006,2755,'01/06/2016'),
(1004,864,'02/06/2016'),
(1004,1833,'03/06/2016'),
(1004,1265,'04/06/2016'),
(1006,1670,'05/06/2016'),
(1006,3037,'06/06/2016'),
(1004,3134,'07/06/2016'),
(1002,358,'08/06/2016'),
(1003,2531,'09/06/2016'),
(1004,1515,'10/06/2016'),
(1005,3461,'11/06/2016'),
(1001,2963,'12/06/2016'),
(1003,2240,'13/06/2016'),
(1004,3403,'14/06/2016'),
(1001,621,'15/06/2016'),
(1005,1264,'16/06/2016'),
(1006,1121,'17/06/2016'),
(1005,88,'18/06/2016'),
(1006,2721,'19/06/2016'),
(1001,1146,'20/06/2016'),
(1005,515,'21/06/2016'),
(1005,3060,'22/06/2016'),
(1006,641,'23/06/2016'),
(1004,2037,'24/06/2016'),
(1006,2595,'25/06/2016'),
(1001,3064,'26/06/2016'),
(1002,2551,'27/06/2016'),
(1005,1380,'28/06/2016'),
(1001,611,'29/06/2016'),
(1002,2759,'30/06/2016'),
(1001,537,'01/07/2016'),
(1003,2581,'02/07/2016'),
(1004,3289,'03/07/2016'),
(1005,3335,'04/07/2016'),
(1004,3273,'05/07/2016'),
(1005,1736,'06/07/2016'),
(1006,2259,'07/07/2016'),
(1006,2269,'08/07/2016'),
(1002,2881,'09/07/2016'),
(1005,888,'10/07/2016'),
(1003,476,'11/07/2016'),
(1006,2944,'12/07/2016'),
(1002,373,'13/07/2016'),
(1005,1885,'14/07/2016'),
(1005,3416,'15/07/2016'),
(1004,1370,'16/07/2016'),
(1005,560,'17/07/2016'),
(1002,657,'18/07/2016'),
(1006,297,'19/07/2016'),
(1001,1661,'20/07/2016'),
(1005,2218,'21/07/2016'),
(1003,381,'22/07/2016'),
(1005,3284,'23/07/2016'),
(1004,771,'24/07/2016'),
(1002,1583,'25/07/2016'),
(1005,1841,'26/07/2016'),
(1005,2210,'27/07/2016'),
(1001,1512,'28/07/2016'),
(1004,1913,'29/07/2016'),
(1003,1065,'30/07/2016'),
(1006,3109,'31/07/2016'),
(1005,3393,'01/08/2016'),
(1003,1791,'02/08/2016'),
(1004,2652,'03/08/2016'),
(1002,1588,'04/08/2016'),
(1004,3154,'05/08/2016'),
(1005,2322,'06/08/2016'),
(1005,2750,'07/08/2016'),
(1006,460,'08/08/2016'),
(1004,465,'09/08/2016'),
(1006,2459,'10/08/2016'),
(1006,2354,'11/08/2016'),
(1006,1320,'12/08/2016'),
(1001,1478,'13/08/2016'),
(1003,2736,'14/08/2016'),
(1004,1908,'15/08/2016'),
(1005,1823,'16/08/2016'),
(1002,3202,'17/08/2016'),
(1001,2952,'18/08/2016'),
(1002,339,'19/08/2016'),
(1006,1092,'20/08/2016'),
(1003,1607,'21/08/2016'),
(1002,991,'22/08/2016'),
(1001,2123,'23/08/2016'),
(1001,1963,'24/08/2016'),
(1001,3359,'25/08/2016'),
(1006,119,'26/08/2016'),
(1003,1635,'27/08/2016'),
(1001,364,'28/08/2016'),
(1001,2672,'29/08/2016'),
(1005,324,'30/08/2016'),
(1002,1402,'31/08/2016'),
(1004,2902,'01/09/2016'),
(1004,1842,'02/09/2016'),
(1001,1113,'03/09/2016'),
(1005,373,'04/09/2016'),
(1002,157,'05/09/2016'),
(1002,1816,'06/09/2016'),
(1001,2413,'07/09/2016'),
(1003,1702,'08/09/2016'),
(1002,1871,'09/09/2016'),
(1006,3234,'10/09/2016'),
(1006,3165,'11/09/2016'),
(1004,360,'12/09/2016'),
(1004,1491,'13/09/2016'),
(1006,2653,'14/09/2016'),
(1002,886,'15/09/2016'),
(1001,1567,'16/09/2016'),
(1002,2642,'17/09/2016'),
(1006,1839,'18/09/2016'),
(1002,3418,'19/09/2016'),
(1004,1959,'20/09/2016'),
(1001,540,'21/09/2016'),
(1003,2510,'22/09/2016'),
(1002,2916,'23/09/2016'),
(1001,1519,'24/09/2016'),
(1006,241,'25/09/2016'),
(1003,728,'26/09/2016'),
(1003,1511,'27/09/2016'),
(1004,1738,'28/09/2016'),
(1002,646,'29/09/2016'),
(1003,253,'30/09/2016'),
(1006,2714,'01/10/2016'),
(1001,2114,'02/10/2016'),
(1004,725,'03/10/2016'),
(1010,348,'01/09/2016'),
(1008,194,'02/09/2016'),
(1012,1250,'03/09/2016'),
(1007,1291,'04/09/2016'),
(1009,1879,'05/09/2016'),
(1007,2466,'06/09/2016'),
(1010,900,'07/09/2016'),
(1011,2743,'08/09/2016'),
(1011,769,'09/09/2016'),
(1010,3284,'10/09/2016'),
(1009,811,'11/09/2016'),
(1010,434,'12/09/2016'),
(1007,1271,'13/09/2016'),
(1008,1492,'14/09/2016'),
(1008,3047,'15/09/2016'),
(1007,2305,'16/09/2016'),
(1007,2886,'17/09/2016'),
(1008,3226,'18/09/2016'),
(1011,1542,'19/09/2016'),
(1007,2150,'20/09/2016'),
(1011,1897,'21/09/2016'),
(1011,3022,'22/09/2016'),
(1007,3495,'23/09/2016'),
(1011,365,'24/09/2016'),
(1007,3265,'25/09/2016'),
(1011,2938,'26/09/2016'),
(1012,2136,'27/09/2016'),
(1008,891,'28/09/2016'),
(1011,833,'29/09/2016'),
(1009,1528,'30/09/2016'),
(1008,952,'01/10/2016'),
(1007,2310,'02/10/2016'),
(1008,1657,'03/10/2016'),
(1007,2007,'04/10/2016'),
(1007,2657,'05/10/2016'),
(1007,1509,'06/10/2016'),
(1010,737,'07/10/2016'),
(1008,2156,'08/10/2016'),
(1008,3263,'09/10/2016'),
(1007,1329,'10/10/2016'),
(1007,140,'11/10/2016'),
(1010,1701,'12/10/2016'),
(1009,3300,'13/10/2016'),
(1010,1324,'14/10/2016'),
(1011,1936,'15/10/2016'),
(1010,2961,'16/10/2016'),
(1007,781,'17/10/2016'),
(1012,3296,'18/10/2016'),
(1007,174,'19/10/2016'),
(1012,2894,'20/10/2016'),
(1009,2965,'21/10/2016'),
(1010,452,'22/10/2016'),
(1012,2077,'23/10/2016'),
(1009,2581,'24/10/2016'),
(1011,1503,'25/10/2016'),
(1008,1382,'26/10/2016'),
(1012,3379,'27/10/2016'),
(1010,351,'28/10/2016'),
(1007,553,'29/10/2016'),
(1011,1660,'30/10/2016'),
(1008,1045,'31/10/2016'),
(1008,1919,'01/11/2016'),
(1010,922,'02/11/2016'),
(1010,2983,'03/11/2016'),
(1012,1229,'04/11/2016'),
(1010,3083,'05/11/2016'),
(1010,1318,'06/11/2016'),
(1011,3018,'07/11/2016'),
(1011,2227,'08/11/2016'),
(1011,3304,'09/11/2016'),
(1011,2078,'10/11/2016'),
(1008,3388,'11/11/2016'),
(1007,1136,'12/11/2016'),
(1007,2043,'13/11/2016'),
(1009,2224,'14/11/2016'),
(1007,1413,'15/11/2016'),
(1008,496,'16/11/2016'),
(1008,3370,'17/11/2016'),
(1008,1524,'18/11/2016'),
(1008,2996,'19/11/2016'),
(1007,502,'20/11/2016'),
(1010,2314,'21/11/2016'),
(1007,1946,'22/11/2016'),
(1007,1042,'23/11/2016'),
(1007,141,'24/11/2016'),
(1011,1967,'25/11/2016'),
(1012,585,'26/11/2016'),
(1010,737,'27/11/2016'),
(1010,504,'28/11/2016'),
(1011,2351,'29/11/2016'),
(1008,1046,'30/11/2016'),
(1008,3117,'01/12/2016'),
(1008,229,'02/12/2016'),
(1008,3079,'03/12/2016'),
(1011,339,'04/12/2016'),
(1010,2335,'05/12/2016'),
(1007,3139,'06/12/2016'),
(1011,1632,'07/12/2016'),
(1010,3253,'08/12/2016'),
(1010,265,'09/12/2016')


--Exerc�cios
--Apresentar marca e modelo de carro e a soma total da dist�ncia percorrida pelos carros,
--em viagens, de uma dada empresa, ordenado pela dist�ncia percorrida
select c.marca, c.modelo, sum (v.distanciaPercorrida) as soma_distancia, e.nome as empresa
from carro c inner join viagem v
on c.id = v.idCarro inner join empresa e
on e.id = c.idEmpresa
group by c.marca, c.modelo, e.nome
order by sum (v.distanciaPercorrida)

--Consultar Nomes das empresas que n�o tem carros cadastrados
select distinct e.nome, c.id
from empresa e left outer join carro c
on e.id = c.idEmpresa
where c.id is null 

--Consultar quantas viagens foram feitas por cada carro (marca e modelo) de cada empresa
--em ordem ascendente de nome de empresa e descendente de quantidade
select count(c.id) as viagens, c.marca, c.modelo, e.nome as empresa
from viagem v inner join carro c
on c.id = v.idCarro inner join empresa e
on e.id = c.idEmpresa
group by c.marca, c.modelo, e.nome
having count(v.distanciaPercorrida) is not null 
order by empresa asc, viagens desc

--Consultar o nome da empresa, a marca e o modelo do carro, a dist�ncia percorrida
--e o valor total ganho por viagem, sabendo que para dist�ncias inferiores a 1000 km, o valor � R$10,00
--por km e para viagens superiores a 1000 km, o valor � R$15,00 por km.
select e.nome as empresa, c.marca, c.modelo, v.distanciaPercorrida, 
		case when (v.distanciaPercorrida < 1000.00)
		then (v.distanciaPercorrida * 10)
		when (v.distanciaPercorrida > 1000.00)
		then (v.distanciaPercorrida * 15)
		end as valor_total
from empresa e inner join carro c
on e.id = c.idEmpresa inner join viagem v
on v.idCarro = c.id

