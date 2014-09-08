CREATE DATABASE LOCAL_AUXILIAR
USE LOCAL_AUXILIAR

CREATE TABLE TB_AUX_CLIENTE(
	data_carga datetime not null,
	idCliente int not null,
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

CREATE TABLE TB_AUX_FUNCIONARIO(
	data_carga datetime not null,
	idFuncionario int not null,
	nome varchar(60) not null,
	cpf varchar(13) not null,
	cargo varchar(50) not null,
	funcao varchar(50) not null,
	salario numeric(15,2) not null		
)

CREATE TABLE TB_AUX_PAGAMENTO(
	data_carga datetime not null,
	idPagamento int not null,
	valor numeric(15,2) not null,
	tipo varchar(45) not null ,	
	data date,
	idOrdemServico int 		
)

CREATE TABLE TB_AUX_CARRO(
	data_carga datetime not null,
	idCarro int not null,
	modelo varchar(45) not null,
	marca varchar(45) not null		
)

CREATE TABLE TB_AUX_SERVICO(
	data_carga datetime not null,
	idServico int not null,
	nome varchar(45) not null,
	tipo varchar(45) not null,
	valor numeric(15,2) not null	
)

CREATE TABLE TB_AUX_FORNECEDOR(
	data_carga datetime not null,
	idFornecedor int not null,
	nome varchar(45) not null,
	telefone varchar(15)not null	
)

CREATE TABLE TB_AUX_PECA(
	data_carga datetime not null,	
	idPeca int not null,	
	nome varchar(45) not null,
	valor numeric(15,2) not null,
	idFornecedor int not null	
)


CREATE TABLE TB_AUX_ORDEM_SERVICO(
	data_carga datetime not null,	
	idOrdemServico int not null,
	valorTotal numeric not null,
	dataCriacao datetime,
	dataFinalizacao datetime null,
	idCarro int not null,
	idCliente int not null,
	idFuncionario int not null,
	idServico int not null,
	idPeca int not null,
	idFornecedor int not null	
)