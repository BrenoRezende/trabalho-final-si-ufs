CREATE DATABASE OLTP
USE OLTP

CREATE TABLE TB_CLIENTE(
	idCliente int primary key identity(1,1) not null,
	nome varchar(60),
	cpf varchar(13),
	rg varchar(25),
	rua varchar(60),
	numero int,
	bairro varchar(30),
	cidade varchar(45),
	estado varchar(25),
	telefone varchar(15)
)

CREATE TABLE TB_FUNCIONARIO(
	idFuncionario int primary key identity(1,1) not null,
	nome varchar(60),
	cpf varchar(13),
	cargo varchar(50),
	funcao varchar(50),
	salario numeric(15,2)
)

CREATE TABLE TB_PAGAMENTO(
	idPagamento int primary key identity(1,1) not null,
	valor numeric(15,2) not null,
	tipo char not null check(tipo in ('D', 'C')),
	data date default (cast(getdate() as date))
)

CREATE TABLE TB_CARRO(
	idCarro int primary key identity(1,1) not null,
	nome varchar(45) not null,
	marca varchar(45) not null,
	placa varchar(45) not null,
	documento varchar(45) not null
)

CREATE TABLE TB_SERVICO(
	idServico int primary key identity(1,1) not null,
	nome varchar(45) not null,
	tipo varchar(45) not null,
	valor numeric(15,2)
)

CREATE TABLE TB_FORNECEDOR(
	idFornecedor int primary key identity(1,1) not null,
	nome varchar(45) not null,
	telefone varchar(15)
)

CREATE TABLE TB_PECA(
	idPeca int primary key identity(1,1) not null,
	nome varchar(45) not null,
	valor numeric(15,2),
	idFornecedor int foreign key references TB_FORNECEDOR
)