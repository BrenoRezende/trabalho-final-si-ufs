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

CREATE TABLE TB_CARRO(
	idCarro int primary key identity(1,1) not null,
	modelo varchar(45) not null,
	marca varchar(45) not null,
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
	idPeca int identity(1,1) not null,
	nome varchar(45) not null,
	valor numeric(15,2) not null,
	idFornecedor int not null,
	primary key(idPeca, idFornecedor),
	CONSTRAINT fk_TB_PECA_TB_FORNECEDOR
    FOREIGN KEY (idFornecedor)
    REFERENCES TB_FORNECEDOR (idFornecedor)
)

CREATE TABLE TB_ORDEM_SERVICO(
	idOrdemServico int identity(1,1) not null,
	valorTotal numeric(15,2) not null,
	dataCriacao datetime default(getdate()),
	dataFinalizacao datetime null,
	idCarro int not null,
	idCliente int not null,
	idFuncionario int not null,
	idServico int not null,
	idPeca int not null,
	idFornecedor int not null,
	primary key (idOrdemServico),
	CONSTRAINT fk_ORDEM_SERVICO_TB_CARRO
    FOREIGN KEY (idCarro)
    REFERENCES TB_CARRO (idCarro),
    CONSTRAINT fk_ORDEM_SERVICO_TB_CLIENTE
    FOREIGN KEY (idCliente)
    REFERENCES TB_CLIENTE (idCliente),
    CONSTRAINT fk_ORDEM_SERVICO_TB_FUNCIONARIO
    FOREIGN KEY (idFuncionario)
    REFERENCES TB_FUNCIONARIO (idFuncionario),
    CONSTRAINT fk_ORDEM_SERVICO_TB_SERVICO
    FOREIGN KEY (idServico)
    REFERENCES TB_SERVICO (idServico),
    CONSTRAINT fk_ORDEM_SERVICO_TB_PECA
    FOREIGN KEY(idPeca, idFornecedor )
    REFERENCES TB_PECA(idPeca, idFornecedor)
)

CREATE TABLE TB_PAGAMENTO(
	idPagamento int primary key identity(1,1) not null,
	valor numeric(15,2) not null,
	tipo VARCHAR(45) NOT NULL CHECK(tipo IN ('A VISTA','A PRAZO')),
	data date default (cast(getdate() as date)),
	idOrdemServico int foreign key references TB_ORDEM_SERVICO
)