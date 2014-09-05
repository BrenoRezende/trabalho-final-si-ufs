CREATE DATABASE LOCAL_AUXILIAR
USE LOCAL_AUXILIAR

CREATE TABLE TB_AUX_CLIENTE(
	idCliente int primary key identity(1,1) not null,
	nome varchar(60) not null,
	cpf varchar(13) not null,
	rg varchar(25) null,
	rua varchar(60) null,
	numero int null,
	bairro varchar(30) null,
	cidade varchar(45) null,
	estado varchar(25) null,
	telefone varchar(15) not null,
	tada_carga datetime not null	
)

CREATE TABLE TB_AUX_FUNCIONARIO(
	idFuncionario int primary key identity(1,1) not null,
	nome varchar(60) not null,
	cpf varchar(13) not null,
	cargo varchar(50) not null,
	funcao varchar(50) not null,
	salario numeric(15,2) not null,
	tada_carga datetime not null	
)

CREATE TABLE TB_AUX_PAGAMENTO(
	idPagamento int primary key identity(1,1) not null,
	valor numeric(15,2) not null,
	tipo char not null check(tipo in ('D', 'C')),
	tada_carga datetime not null,
	data date default (cast(getdate() as date)),
	idOrdemServico int foreign key references TB_AUX_ORDEM_SERVICO
		
)

CREATE TABLE TB_AUX_CARRO(
	idCarro int primary key identity(1,1) not null,
	modelo varchar(45) not null,
	marca varchar(45) not null,
	tada_carga datetime not null	
)

CREATE TABLE TB_AUX_SERVICO(
	idServico int primary key identity(1,1) not null,
	nome varchar(45) not null,
	tipo varchar(45) not null,
	valor numeric(15,2) not null,
	tada_carga datetime not null	
)

CREATE TABLE TB_AUX_FORNECEDOR(
	idFornecedor int primary key identity(1,1) not null,
	nome varchar(45) not null,
	telefone varchar(15)not null,
	tada_carga datetime not null	
)

CREATE TABLE TB_AUX_PECA(
	idPeca int identity(1,1) not null,	
	nome varchar(45) not null,
	valor numeric(15,2) not null,
	idFornecedor int not null,
	tada_carga datetime not null,	
	primary key(idPeca, idFornecedor),
	CONSTRAINT fk_TB_AUX_PECA_TB_AUX_FORNECEDOR
    FOREIGN KEY (idFornecedor)
    REFERENCES TB_AUX_FORNECEDOR (idFornecedor)
    
)

CREATE TABLE TB_AUX_ORDEM_SERVICO(
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
	tada_carga datetime not null,	
	primary key (idOrdemServico),
	
	CONSTRAINT fk_AUX_ORDEM_SERVICO_TB_AUX_CARRO
    FOREIGN KEY (idCarro)
    REFERENCES TB_AUX_CARRO (idCarro),
    
    CONSTRAINT fk_AUX_ORDEM_SERVICO_TB_AUX_CLIENTE
    FOREIGN KEY (idCliente)
    REFERENCES TB_AUX_CLIENTE (idCliente),
    
    CONSTRAINT fk_AUX_ORDEM_SERVICO_TB_AUX_FUNCIONARIO
    FOREIGN KEY (idFuncionario)
    REFERENCES TB_AUX_FUNCIONARIO (idFuncionario),
    
    CONSTRAINT fk_AUX_ORDEM_SERVICO_TB_AUX_SERVICO
    FOREIGN KEY (idServico)
    REFERENCES TB_AUX_SERVICO (idServico),
    
    CONSTRAINT fk_AUX_ORDEM_SERVICO_TB_AUX_PECA
    FOREIGN KEY(idPeca, idFornecedor )
    REFERENCES TB_AUX_PECA(idPeca, idFornecedor)
)