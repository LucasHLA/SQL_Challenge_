--Nomes: Alessandra Nakamoto
--		 João Serrano
--		 Lucas Henrique
create database desafio;
use desafio;

-- Tabelas 
create table Funcionarios (
 id_func		int not null primary key,
 nome_func		varchar(40) not null
);
create table Servicos (
 id_servico		int identity primary key,
 nome_servico   varchar(40) not null		
);

create table Lugar(
id_local		int identity primary key,
nome_local		varchar(40) not null
);

create table Requisitos_serv (
 id_requisito		int identity primary key,
 nome_req			varchar(40) not null,
 id_func			int not null,
 id_servico			int not null,
 id_local			int not null
);

create table Auditoria_insert(
 id_requisito		int identity primary key,
 nome_req			varchar(40) not null,
 id_func			int not null,
 nome_func			varchar(40) not null,
 id_servico			int not null,
 nome_servico		varchar(40) not null,
 id_local			int not null,
 nome_local			varchar(40) not null
);

-- insert Funcionario
insert into Funcionarios values (001,'Antônio Mello');
insert into Funcionarios values (002,'Lucas Araujo');
insert into Funcionarios values (003,'Mariana Santos');

-- insert Serviços
insert into Servicos values ('Manutenção');
insert into Servicos values ('Troca de Peça');
insert into Servicos values ('Cabeamento');
insert into Servicos values ('Explosão');

-- insert local
insert into Lugar values ('Administração');
insert into Lugar values ('Recepção');
insert into Lugar values ('RH');

-- Procedure
go
create procedure insert_requisito
	@nome_req		varchar(40),
	@id_func		int,
	@id_servico		int,
	@id_local		int
as
	declare
	@id_conf_func	int,
	@id_conf_serv	int,
	@id_conf_local	int 
	set @id_conf_func = (select id_func from Funcionarios where id_func = @id_func); 
	set @id_conf_serv = (select id_servico from Servicos where id_servico = @id_servico); 
	set @id_conf_local = (select id_local from Lugar where id_local = @id_local); 
	if @id_func = @id_conf_func and @id_servico = @id_conf_serv and @id_local = @id_conf_local
	begin
		insert into Requisitos_serv values (@nome_req,@id_func,@id_servico,@id_local);
		print 'Requisição Registrado';
	end
	else
		print('Digite informações validas!');


-- Exec correto 
exec insert_requisito 'Sophia', 002, 4, 2;
exec insert_requisito 'Camila', 001, 2, 3;
exec insert_requisito 'Zé', 003, 3, 1;

-- Exec incorreto
exec insert_requisito 'Zé', 007, 3, 1;
exec insert_requisito 'James', 003, 5, 1;
exec insert_requisito 'Lucas', 003, 3, 7448;

select * from mostre_requisitos;
select * from Auditoria_insert;
-- Trigger 

go
create trigger trigger_insert
on Requisitos_serv
for insert
as 
begin
	declare @id_func		int,
			@nome_req		varchar(40),
			@id_servico		int,
			@id_local		int,
			@nome_func		varchar(40),
			@nome_servico	varchar(40),
			@nome_local		varchar(40)
	select @id_func = id_func, @nome_req = nome_req, @id_servico = id_servico ,@id_local = id_local from inserted;
	set @nome_func = (select nome_func from Funcionarios where id_func = @id_func);
	set @nome_servico = (select nome_servico from Servicos where id_servico = @id_servico);
	set @nome_local = (select nome_local from Lugar where id_local = @id_local);
	insert into Auditoria_insert values (@nome_req, @id_func, @nome_func, @id_servico, @nome_servico, @id_local, @nome_local);
	select * from mostre_requisitos;
	select * from Auditoria_insert;
end


-- View

go
create view mostre_requisitos
as
	select id_requisito 'Protocolo', nome_req 'Requisitante', f.nome_func 'Funcionário', s.nome_servico 'Serviço', l.nome_local 'Local'
	from Requisitos_serv r inner join Funcionarios f on r.id_func = f.id_func
						   inner join Servicos s on r.id_servico = s.id_servico
						   inner join Lugar l on r.id_local = l.id_local;

