CREATE DATABASE LOCAL_DW
USE LOCAL_DW

-- -----------------------------------------------------
-- DIM_Tempo
-- -----------------------------------------------------

CREATE TABLE DIM_Tempo(
	id_tempo INT IDENTITY(1,1) NOT NULL,
	Nivel VARCHAR(8) NOT NULL,
	
	Data DATETIME NULL,
	Dia SMALLINT NULL,
	DiaSemana VARCHAR(25) NULL,
	DiaUtil CHAR(3) NULL,
	FimSemana CHAR(3) NULL,
	Quinzena SMALLINT NULL,
	
	Mes SMALLINT NULL,
	NomeMes VARCHAR(20) NULL,
	FimMes CHAR(3) NULL,
	Trimestre SMALLINT NULL,
	NomeTrimestre VARCHAR(20) NULL,
	Semestre SMALLINT NULL,
	NomeSemestre VARCHAR(20) NULL,
	
	Ano SMALLINT NOT NULL,
	PRIMARY KEY (id_tempo)
)

-- -----------------------------------------------------
-- DIM_Carro
--------------------------------------------------------

CREATE TABLE DIM_Carro(
	id_carro INT IDENTITY(1,1) NOT NULL,
	cod_carro INT NOT NULL,
	modelo VARCHAR(45) NOT NULL,
	marca VARCHAR(45) NOT NULL,
	PRIMARY KEY (id_carro)
)

-- -----------------------------------------------------
-- DIM_Fornecedor
--------------------------------------------------------

CREATE TABLE DIM_Fornecedor(
	id_fornecedor INT IDENTITY(1,1) NOT NULL,
	cod_fornecedor INT NOT NULL,
	nome VARCHAR(45) NOT NULL,
	telefone VARCHAR(15) NOT NULL,
	PRIMARY KEY (id_fornecedor)	
)

-- -----------------------------------------------------
-- DIM_Peca
--------------------------------------------------------

CREATE TABLE DIM_Peca(
	id_peca INT IDENTITY(1,1) NOT NULL,
	cod_peca INT NOT NULL,
	nome VARCHAR(45) NOT NULL,
	valor NUMERIC(15,2) NOT NULL,
	data_inicial DATETIME NOT NULL,
	data_final DATETIME NULL,
	fl_corrente VARCHAR(3) NOT NULL CHECK (fl_corrente IN ('SIM','NAO')),
	PRIMARY KEY(id_peca)
)

-- -----------------------------------------------------
-- DIM_Servico
--------------------------------------------------------

CREATE TABLE DIM_SERVICO(
	id_servico INT IDENTITY(1,1) NOT NULL,
	cod_servico INT NOT NULL,
	nome VARCHAR(45) NOT NULL,
	tipo VARCHAR(15) NOT NULL,
	valor NUMERIC(15,2) NOT NULL,
	data_inicial DATETIME NOT NULL,
	data_final DATETIME NULL,
	fl_corrente VARCHAR(3) NOT NULL CHECK (fl_corrente IN ('SIM','NAO')),
	PRIMARY KEY(id_servico)
)

-- -----------------------------------------------------
-- DIM_Cliente
--------------------------------------------------------

CREATE TABLE DIM_Cliente(
	id_cliente INT IDENTITY(1,1) NOT NULL,
	cod_cliente INT NOT NULL,
	nome VARCHAR(60) NOT NULL,
	cpf VARCHAR(13) NOT NULL,
	rg VARCHAR(25) NULL,
	rua VARCHAR(60) NULL,
	numero INT NULL,
	bairro VARCHAR(30) NULL,
	cidade VARCHAR(45) NULL,
	estado VARCHAR(25) NULL,
	telefone VARCHAR(15) NOT NULL,
	PRIMARY KEY(id_cliente)
)

-- -----------------------------------------------------
-- DIM_Funcionario
--------------------------------------------------------

CREATE TABLE DIM_Funcionario(
	id_funcionario INT IDENTITY(1,1) NOT NULL,
	cod_funcionario INT NOT NULL,
	nome VARCHAR(60) NOT NULL,
	cpf VARCHAR(13) NOT NULL,
	cargo VARCHAR(50) NOT NULL,
	funcao VARCHAR(50) NOT NULL,
	salario NUMERIC(15,2) NOT NULL,
	data_inicial DATETIME NOT NULL,
	data_final DATETIME NULL,
	fl_corrente VARCHAR(3) NOT NULL CHECK (fl_corrente IN ('SIM','NAO')),
	PRIMARY KEY(id_funcionario)
)

-- -----------------------------------------------------
-- FATO_ORDEM_SERVICO
--------------------------------------------------------

CREATE TABLE FATO_ORDEM_SERVICO(
	id_ordem_servico INT IDENTITY(1,1) NOT NULL,
	cod_ordem_servico INT NOT NULL,
	quantidade INT NOT NULL DEFAULT(1),
	valorTotal NUMERIC(15,2) NOT NULL,
	tipo_pagamento VARCHAR(45) NOT NULL CHECK(tipo_pagamento IN ('A VISTA','A PRAZO')),
	id_carro INT NOT NULL,
	id_fornecedor INT NOT NULL,
	id_peca INT NOT NULL,
	id_servico INT NOT NULL,
	id_cliente INT NOT NULL,
	id_funcionario INT NOT NULL,
	id_tempo_criacao INT NOT NULL,
	id_tempo_finalizacao INT NOT NULL,
	id_tempo_pagamento INT NOT NULL,
	
	PRIMARY KEY (id_ordem_servico),
	CONSTRAINT fk_ORDEM_SERVICO_DIM_CARRO
    FOREIGN KEY (id_carro)
    REFERENCES DIM_Carro (id_carro),
    CONSTRAINT fk_ORDEM_SERVICO_DIM_FORNECEDOR
    FOREIGN KEY (id_fornecedor)
    REFERENCES DIM_Fornecedor (id_fornecedor),
    CONSTRAINT fk_ORDEM_SERVICO_DIM_PECA
    FOREIGN KEY (id_peca)
    REFERENCES DIM_Peca (id_peca),
    CONSTRAINT fk_ORDEM_SERVICO_DIM_SERVICO
    FOREIGN KEY (id_servico)
    REFERENCES DIM_Servico (id_servico),
    CONSTRAINT fk_ORDEM_SERVICO_DIM_CLIENTE
    FOREIGN KEY (id_cliente)
    REFERENCES DIM_Cliente (id_cliente),
    CONSTRAINT fk_ORDEM_SERVICO_DIM_FUNCIONARIO
    FOREIGN KEY (id_funcionario)
    REFERENCES DIM_Funcionario (id_funcionario),
    CONSTRAINT fk_ORDEM_SERVICO_DIM_TEMPO1
    FOREIGN KEY (id_tempo_criacao)
    REFERENCES DIM_Tempo (id_tempo),
    CONSTRAINT fk_ORDEM_SERVICO_DIM_TEMPO2
    FOREIGN KEY (id_tempo_finalizacao)
    REFERENCES DIM_Tempo (id_tempo),
    CONSTRAINT fk_ORDEM_SERVICO_DIM_TEMPO3
    FOREIGN KEY (id_tempo_pagamento)
    REFERENCES DIM_Tempo (id_tempo)
)

