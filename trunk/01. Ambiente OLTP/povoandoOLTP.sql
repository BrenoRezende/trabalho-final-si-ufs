USE OLTP

CREATE PROCEDURE SP_INCLUI_CLIENTE (@NOME VARCHAR(60), @CPF VARCHAR(13), @RG VARCHAR(25),
@RUA VARCHAR(60), @NUMERO INT, @BAIRRO VARCHAR(30), @CIDADE VARCHAR(45), @ESTADO VARCHAR(25),
@TELEFONE VARCHAR(15), @MENSAGEM VARCHAR(40) OUTPUT)
AS
	BEGIN
		DECLARE @ROWCOUNT INT
		
		INSERT INTO TB_CLIENTE (nome,cpf,rg,rua,numero,bairro,cidade,estado,telefone)
		VALUES (@NOME,@CPF,@RG,@RUA,@NUMERO,@BAIRRO,@CIDADE,@ESTADO,@TELEFONE)
		
		SELECT @ROWCOUNT = @@ROWCOUNT
		IF @ROWCOUNT = 1
			SET @MENSAGEM = 'CLIENTE INCLUIDO COM SUCESSO.' 
		ELSE
			SET @MENSAGEM = 'FALHA NA INCLUSAO DO CLIENTE'
			
		PRINT @MENSAGEM
	END
	

CREATE PROCEDURE SP_INCLUI_CARRO(@MODELO VARCHAR(45), @MARCA VARCHAR(45),
@MENSAGEM VARCHAR(40) OUTPUT)
AS
	BEGIN
		DECLARE @ROWCOUNT INT
		
		INSERT INTO TB_CARRO (modelo, marca)
		VALUES (@MODELO,@MARCA)
		
		SELECT @ROWCOUNT = @@ROWCOUNT
		IF @ROWCOUNT = 1
			SET @MENSAGEM = 'CARRO INCLUSO COM SUCESSO.' 
		ELSE
			SET @MENSAGEM = 'FALHA NA INCLUSAO DO CARRO'
			
		PRINT @MENSAGEM
	END
	

CREATE PROCEDURE SP_INCLUI_FORNECEDOR(@NOME VARCHAR(45), @TELEFONE VARCHAR(15), 
@MENSAGEM VARCHAR(40) OUTPUT)
AS
	BEGIN
		DECLARE @ROWCOUNT INT
		
		INSERT INTO TB_FORNECEDOR (nome, telefone)
		VALUES (@NOME,@TELEFONE)
		
		SELECT @ROWCOUNT = @@ROWCOUNT
		IF @ROWCOUNT = 1
			SET @MENSAGEM = 'FORNECEDOR INCLUIDO COM SUCESSO.' 
		ELSE
			SET @MENSAGEM = 'FALHA NA INCLUSAO DO FORNECEDOR'
			
		PRINT @MENSAGEM
	END

CREATE PROCEDURE SP_INCLUI_FUNCIONARIO(@NOME VARCHAR(60), @CPF VARCHAR(13),@CARGO VARCHAR(50),
@FUNCAO VARCHAR(50), @SALARIO NUMERIC(15,2), @MENSAGEM VARCHAR(40) OUTPUT)
AS
	BEGIN
		DECLARE @ROWCOUNT INT
		
		INSERT INTO TB_FUNCIONARIO (nome, cpf, cargo, funcao, salario)
		VALUES (@NOME, @CPF, @CARGO, @FUNCAO, @SALARIO)
		
		SELECT @ROWCOUNT = @@ROWCOUNT
		IF @ROWCOUNT = 1
			SET @MENSAGEM = 'FUNCIONARIO INCLUIDO COM SUCESSO.' 
		ELSE
			SET @MENSAGEM = 'FALHA NA INCLUSAO DO FUNCIONARIO'
			
		PRINT @MENSAGEM
	END
	
CREATE PROCEDURE SP_INCLUI_PAGAMENTO(@VALOR NUMERIC(15,2), @TIPO VARCHAR(45),@ID_ORDEM_SERVICO INT,
@MENSAGEM VARCHAR(40) OUTPUT)
AS
	BEGIN
		DECLARE @ROWCOUNT INT
		
		INSERT INTO TB_PAGAMENTO (valor, tipo,idOrdemServico)
		VALUES (@VALOR, @TIPO, @ID_ORDEM_SERVICO)
		
		SELECT @ROWCOUNT = @@ROWCOUNT
		IF @ROWCOUNT = 1
			SET @MENSAGEM = 'PAGAMENTO REALIZADO COM SUCESSO.' 
		ELSE
			SET @MENSAGEM = 'FALHA NA REALIZACAO DO PAGAMENTO'
			
		PRINT @MENSAGEM
	END
	
CREATE PROCEDURE SP_INCLUI_SERVICO(@NOME VARCHAR(45), @TIPO VARCHAR(45), @VALOR NUMERIC(15,2),
@MENSAGEM VARCHAR(40) OUTPUT)
AS
	BEGIN
		DECLARE @ROWCOUNT INT
		
		INSERT INTO TB_SERVICO (nome, tipo, valor)
		VALUES (@NOME, @TIPO, @VALOR)
		
		SELECT @ROWCOUNT = @@ROWCOUNT
		IF @ROWCOUNT = 1
			SET @MENSAGEM = 'SERVICO CADASTRADO COM SUCESSO.' 
		ELSE
			SET @MENSAGEM = 'FALHA NO CADASTRO DO SERVICO.'
			
		PRINT @MENSAGEM
	END
	
CREATE PROCEDURE SP_INCLUI_PECA(@NOME VARCHAR(45), @VALOR NUMERIC(15,2), @ID_FORNECEDOR INT,
@MENSAGEM VARCHAR(40) OUTPUT)
AS
	BEGIN
		DECLARE @ROWCOUNT INT
		
		INSERT INTO TB_PECA (nome, valor, idFornecedor)
		VALUES (@NOME, @VALOR, @ID_FORNECEDOR)
		
		SELECT @ROWCOUNT = @@ROWCOUNT
		IF @ROWCOUNT = 1
			SET @MENSAGEM = 'PECA INCLUSA COM SUCESSO.' 
		ELSE
			SET @MENSAGEM = 'FALHA NA INCLUSAO DA PECA.'
			
		PRINT @MENSAGEM
	END
	
CREATE PROCEDURE SP_INCLUI_ORDEM_SERVICO(@VALOR_TOTAL NUMERIC(15,2),@ID_CARRO INT, 
@ID_CLIENTE INT, @ID_FUNCIONARIO INT, @ID_SERVICO INT, @ID_PECA INT,
@ID_FORNECEDOR INT, @MENSAGEM VARCHAR(40) OUTPUT)
AS
	BEGIN
		DECLARE @ROWCOUNT INT
		
		INSERT INTO TB_ORDEM_SERVICO (valorTotal, idCarro, idCliente,
		idFuncionario, idServico, idPeca, idFornecedor)
		VALUES (@VALOR_TOTAL, @ID_CARRO, @ID_CLIENTE,@ID_FUNCIONARIO,@ID_SERVICO,
		@ID_PECA,@ID_FORNECEDOR)
		
		SELECT @ROWCOUNT = @@ROWCOUNT
		IF @ROWCOUNT = 1
			SET @MENSAGEM = 'ORDEM DE SERVICO INCLUSA COM SUCESSO.' 
		ELSE
			SET @MENSAGEM = 'FALHA NA INCLUSAO DA ORDEM DE SERVICO.'
			
		PRINT @MENSAGEM
	END
	
CREATE PROCEDURE FINALIZAR_ORDEM_SERVICO(@ID INT, @MENSAGEM VARCHAR(40) OUTPUT)
AS
	BEGIN
		DECLARE @ROWCOUNT INT
		
		UPDATE TB_ORDEM_SERVICO
		SET dataFinalizacao = (SELECT CAST (getdate() as DATE))
		WHERE idOrdemServico = @ID
		
		SELECT @ROWCOUNT = @@ROWCOUNT
		IF @ROWCOUNT = 1
			SET @MENSAGEM = 'ORDEM DE SERVICO FINALIZADA COM SUCESSO.' 
		ELSE
			SET @MENSAGEM = 'FALHA NA FINALIZACAO DA ORDEM DE SERVICO.'
			
		PRINT @MENSAGEM
	END
------------------------------- EXECUTANDO PROCEDIMENTOS -------------------------------

DECLARE @MENSAGEM VARCHAR(40)
EXEC SP_INCLUI_CLIENTE 'JAIRO','1312331',NULL,NULL,NULL,NULL,NULL,NULL,'99221608',@MENSAGEM

DECLARE @MENSAGEM VARCHAR(40)
EXEC SP_INCLUI_CARRO 'UNO', 'FIAT', @MENSAGEM

DECLARE @MENSAGEM VARCHAR(40)
EXEC SP_INCLUI_FORNECEDOR 'JAIR', '231313132', @MENSAGEM

DECLARE @MENSAGEM VARCHAR(40)
EXEC SP_INCLUI_FUNCIONARIO 'MARIA', '123132', 'MECANICO', 'TROCA DE OLEO', 1850, @MENSAGEM

DECLARE @MENSAGEM VARCHAR(40)
EXEC SP_INCLUI_PECA 'REBINBOCA', 250, 1, @MENSAGEM

DECLARE @MENSAGEM VARCHAR(40)
EXEC SP_INCLUI_SERVICO 'TROCA DE OLEO', 'MECANICO', 100,@MENSAGEM

DECLARE @MENSAGEM VARCHAR(40)
EXEC SP_INCLUI_ORDEM_SERVICO 350,1,1,1,1,1,1,@MENSAGEM

DECLARE @MENSAGEM VARCHAR(40)
EXEC SP_INCLUI_PAGAMENTO 350, 'A PRAZO', 1, @MENSAGEM

SELECT * FROM TB_CARRO
SELECT * FROM TB_CLIENTE
SELECT * FROM TB_FORNECEDOR
SELECT * FROM TB_FUNCIONARIO
SELECT * FROM TB_PECA
SELECT * FROM TB_SERVICO
SELECT * FROM TB_ORDEM_SERVICO
SELECT * FROM TB_PAGAMENTO

DECLARE @MENSAGEM VARCHAR(40)
EXEC FINALIZAR_ORDEM_SERVICO 1, @MENSAGEM