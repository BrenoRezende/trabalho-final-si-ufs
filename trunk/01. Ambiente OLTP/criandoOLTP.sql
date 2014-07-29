CREATE DATABASE OLTP
USE OLTP

CREATE TABLE TB_CLIENTE(
	idCliente int primary key identity(1,1) not null,
	nome varchar(60) not null,
	cpf varchar(13) not null,
	rg varchar(25) null,
	rua varchar(60) null,
	numero int null,
	bairro varchar(30) null,
	cidade varchar(45) null,
	estado varchar(25) null,
	telefone varchar(15) not null
)

CREATE TABLE TB_FUNCIONARIO(
	idFuncionario int primary key identity(1,1) not null,
	nome varchar(60) not null,
	cpf varchar(13) not null,
	cargo varchar(50) not null,
	funcao varchar(50) not null,
	salario numeric(15,2) not null
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
	valor numeric(15,2) not null
)

CREATE TABLE TB_FORNECEDOR(
	idFornecedor int primary key identity(1,1) not null,
	nome varchar(45) not null,
	telefone varchar(15)not null
)

CREATE TABLE TB_PECA(
	idPeca int primary key identity(1,1) not null,
	nome varchar(45) not null,
	valor numeric(15,2) not null,
	idFornecedor int foreign key references TB_FORNECEDOR
)

CREATE TABLE TB_ORDEM_SERVICO(
	idOrdemServico int primary key identity(1,1) not null,
	valorTotal numeric(15,2) not null,
	dataCriacao datetime default(getdate()),
	dataFinalizacao datetime null,
	idCarro int foreign key references TB_CARRO,
	idPagamento int foreign key references TB_PAGAMENTO,
	idCliente int foreign key references TB_CLIENTE,
	idFuncionario int foreign key references TB_FUNCIONARIO,
	idServico int foreign key references TB_SERVICO,
	idPeca int foreign key references TB_PECA,
	idFornecedor int foreign key references TB_FORNECEDOR
)
