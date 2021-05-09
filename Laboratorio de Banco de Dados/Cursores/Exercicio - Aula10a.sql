--Exercício tirado de situação real.
/* A empresa tinha duas tabelas: Envio e Endereço, como listada abaixo.
No atributo NR_LINHA_ARQUIV, há um número que referencia a 
linha de incidência do endereço na tabela endereço.
Por exemplo: 

ENVIO:
|CPF			|NR_LINHA_ARQUIV	|...
|11111111111	|1					|
|11111111111	|2					|

ENDEREÇO:
|CPF			|CEP		|PORTA	|ENDEREÇO	|COMPLEMENTO		|BAIRRO			|CIDADE			|UF	|
|11111111111	|11111111	|10		|Rua A		|					|Pq A			|São Paulo		|SP	|
|11111111111	|22222222	|125	|Rua B		|					|Pq B			|São Paulo		|SP	|

Portanto, o NR_LINHA_ARQUIV (1) referencia o registro do endereço da Rua A e o NR_LINHA_ARQUIV (2) 
referencia o endereço da Rua B.

Como se trata de uma estrutura completamente mal feita, o DBA solicitou
que se colcasse as colunas NM_ENDERECO, NR_ENDERECO, NM_COMPLEMENTO, NM_BAIRRO, NR_CEP,
NM_CIDADE, NM_UF varchar(2) e movesse os dados da tabela endereço para a tabela envio.

Fazer uma PROCEDURE, com cursor, que resolva esse problema
*/

CREATE DATABASE ex10a
GO
USE ex10a

create table envio (
CPF varchar(20),
NR_LINHA_ARQUIV	int,
CD_FILIAL int,
DT_ENVIO datetime,
NR_DDD int,
NR_TELEFONE	varchar(10),
NR_RAMAL varchar(10),
DT_PROCESSAMENT	datetime,
NM_ENDERECO varchar(200),
NR_ENDERECO int,
NM_COMPLEMENTO	varchar(50),
NM_BAIRRO varchar(100),
NR_CEP varchar(10),
NM_CIDADE varchar(100),
NM_UF varchar(2)
)

create table endereço(
CPF varchar(20),
CEP	varchar(10),
PORTA	int,
ENDEREÇO	varchar(200),
COMPLEMENTO	varchar(100),
BAIRRO	varchar(100),
CIDADE	varchar(100),
UF Varchar(2))

/*
Por se tratar de dados confidenciais, a procedure abaixo foi feita para se criar
dados fictícios nas tabelas
*/
-- Procedure que popula dados nas tabelas envio e endereço
create procedure sp_insereenvio
as
	declare @cpf as int
	declare @cont1 as int
	declare @cont2 as int
	declare @conttotal as int
	set @cpf = 11111
	set @cont1 = 1
	set @cont2 = 1
	set @conttotal = 1
	while @cont1 <= @cont2 and @cont2 < = 100
	begin
		insert into envio (CPF, NR_LINHA_ARQUIV, DT_ENVIO)
		values (cast(@cpf as varchar(20)), @cont1,GETDATE())
		insert into endereço (CPF,PORTA,ENDEREÇO)
		values (@cpf,@conttotal,CAST(@cont2 as varchar(3))+'Rua '+CAST(@conttotal as varchar(5)))
		set @cont1 = @cont1 + 1
		set @conttotal = @conttotal + 1
		if @cont1 > = @cont2
		begin
			set @cont1 = 1
			set @cont2 = @cont2 + 1
			set @cpf = @cpf + 1
		end
	end



-- Procedure que atualiza a tabela envio com as informações da tabela endereço utilizando cursores
CREATE PROCEDURE sp_envioEndereco
AS
	-- Variáveis para o cursor da tabela envio
	DECLARE @CPFEnvio varchar(20),
	@NR_LINHA_ARQUIV	int,
	@NM_ENDERECO varchar(200),
	@NR_ENDERECO int,
	@NM_COMPLEMENTO	varchar(50),
	@NM_BAIRRO varchar(100),
	@NR_CEP varchar(10),
	@NM_CIDADE varchar(100),
	@NM_UF varchar(2)

	-- Variáveis para o cursor da tabela endereço
	DECLARE @CPFEndereco varchar(20),
	@CEP	varchar(10),
	@PORTA	int,
	@ENDEREÇO	varchar(200),
	@COMPLEMENTO	varchar(100),
	@BAIRRO	varchar(100),
	@CIDADE	varchar(100),
	@UF Varchar(2)

	DECLARE c_envio CURSOR FOR SELECT CPF, NR_LINHA_ARQUIV, NM_ENDERECO, NR_ENDERECO,
		NM_COMPLEMENTO, NM_BAIRRO, NR_CEP, NM_CIDADE, NM_UF FROM envio ORDER BY CPF,NR_LINHA_ARQUIV ASC
	OPEN c_envio
	FETCH NEXT FROM c_envio INTO @CPFEnvio, @NR_LINHA_ARQUIV, @NM_ENDERECO, @NR_ENDERECO,
		@NM_COMPLEMENTO, @NM_BAIRRO, @NR_CEP, @NM_CIDADE, @NM_UF

	DECLARE c_endereco CURSOR FOR SELECT CPF, CEP, PORTA, ENDEREÇO, COMPLEMENTO, BAIRRO, CIDADE, UF 
		FROM endereço ORDER BY CPF ASC
	OPEN c_endereco
	FETCH NEXT FROM c_endereco INTO @CPFEndereco, @CEP, @PORTA, @ENDEREÇO, @COMPLEMENTO, @BAIRRO, @CIDADE, @UF

	WHILE(@@FETCH_STATUS = 0)
	BEGIN
		UPDATE envio
		SET NM_ENDERECO = @ENDEREÇO, NR_ENDERECO = @PORTA, NM_COMPLEMENTO = @COMPLEMENTO, 
			NM_BAIRRO = @BAIRRO, NR_CEP = @CEP, NM_CIDADE = @CIDADE, NM_UF = @UF
		WHERE CPF = @CPFEnvio AND NR_LINHA_ARQUIV = @NR_LINHA_ARQUIV
		
		FETCH NEXT FROM c_envio INTO @CPFEnvio, @NR_LINHA_ARQUIV, @NM_ENDERECO, @NR_ENDERECO,
			@NM_COMPLEMENTO, @NM_BAIRRO, @NR_CEP, @NM_CIDADE, @NM_UF
		FETCH NEXT FROM c_endereco INTO @CPFEndereco, @CEP, @PORTA, @ENDEREÇO, @COMPLEMENTO, @BAIRRO, @CIDADE, @UF
	END
	CLOSE c_envio
	DEALLOCATE c_envio
	CLOSE c_endereco
	DEALLOCATE c_endereco



-- Testes
DELETE envio
DELETE endereço
GO
EXEC sp_insereenvio

select * from envio order by CPF,NR_LINHA_ARQUIV asc
select * from endereço order by CPF asc

EXEC sp_envioEndereco
