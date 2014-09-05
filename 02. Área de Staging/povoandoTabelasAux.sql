USE LOCAL_AUXILIAR

CREATE PROCEDURE SP_CARGA_OLTP_CARRO(@DATA_CARGA DATETIME)
AS
BEGIN
	DECLARE @VERIFICAR_DATA DATETIME	
	SET @VERIFICAR_DATA =( 
		SELECT TOP(1) DATA_CARGA FROM TB_AUX_CARRO 
		WHERE DATA_CARGA  =  @DATA_CARGA)
		IF(@VERIFICAR_DATA IS NULL )
			BEGIN
				INSERT INTO TB_AUX_CARRO 
				SELECT @DATA_CARGA, * FROM OLTP.DBO.TB_CARRO
			END
		ELSE
			BEGIN
				DELETE FROM TB_AUX_CARRO WHERE DATA_CARGA = @DATA_CARGA
				INSERT INTO TB_AUX_CARRO 
				SELECT @DATA_CARGA, * FROM OLTP.DBO.TB_CARRO 
			END
		END

EXEC SP_CARGA_OLTP_CARRO '2014-07-03'


CREATE PROCEDURE SP_CARGA_OLTP_CLIENTE(@DATA_CARGA DATETIME)
AS
BEGIN
	DECLARE @VERIFICAR_DATA DATETIME	
	SET @VERIFICAR_DATA =( 
		SELECT TOP(1) DATA_CARGA FROM TB_AUX_CLIENTE 
		WHERE DATA_CARGA  =  @DATA_CARGA)
		IF(@VERIFICAR_DATA IS NULL )
			BEGIN
				INSERT INTO TB_AUX_CLIENTE 
				SELECT @DATA_CARGA, * FROM OLTP.DBO.TB_CLIENTE
			END
		ELSE
			BEGIN
				DELETE FROM TB_AUX_CLIENTE WHERE DATA_CARGA = @DATA_CARGA
				INSERT INTO TB_AUX_CLIENTE 
				SELECT @DATA_CARGA, * FROM OLTP.DBO.TB_CLIENTE 
			END
		END

EXEC SP_CARGA_OLTP_CLIENTE '2014-07-03'


CREATE PROCEDURE SP_CARGA_OLTP_FORNECEDOR(@DATA_CARGA DATETIME)
AS
BEGIN
	DECLARE @VERIFICAR_DATA DATETIME	
	SET @VERIFICAR_DATA =( 
		SELECT TOP(1) DATA_CARGA FROM TB_AUX_FORNECEDOR 
		WHERE DATA_CARGA  =  @DATA_CARGA)
		IF(@VERIFICAR_DATA IS NULL )
			BEGIN
				INSERT INTO TB_AUX_FORNECEDOR 
				SELECT @DATA_CARGA, * FROM OLTP.DBO.TB_FORNECEDOR
			END
		ELSE
			BEGIN
				DELETE FROM TB_AUX_FORNECEDOR WHERE DATA_CARGA = @DATA_CARGA
				INSERT INTO TB_AUX_FORNECEDOR 
				SELECT @DATA_CARGA, * FROM OLTP.DBO.TB_FORNECEDOR
			END
		END

EXEC SP_CARGA_OLTP_FORNECEDOR '2014-07-03'



CREATE PROCEDURE SP_CARGA_OLTP_FUNCIONARIO(@DATA_CARGA DATETIME)
AS
BEGIN
	DECLARE @VERIFICAR_DATA DATETIME	
	SET @VERIFICAR_DATA =( 
		SELECT TOP(1) DATA_CARGA FROM TB_AUX_FUNCIONARIO 
		WHERE DATA_CARGA  =  @DATA_CARGA)
		IF(@VERIFICAR_DATA IS NULL )
			BEGIN
				INSERT INTO TB_AUX_FUNCIONARIO 
				SELECT @DATA_CARGA, * FROM OLTP.DBO.TB_FUNCIONARIO
			END
		ELSE
			BEGIN
				DELETE FROM TB_AUX_FUNCIONARIO WHERE DATA_CARGA = @DATA_CARGA
				INSERT INTO TB_AUX_FUNCIONARIO 
				SELECT @DATA_CARGA, * FROM OLTP.DBO.TB_FUNCIONARIO 
			END
		END


EXEC SP_CARGA_OLTP_FUNCIONARIO '2014-07-03'


CREATE PROCEDURE SP_CARGA_OLTP_PECA(@DATA_CARGA DATETIME)
AS
BEGIN
	DECLARE @VERIFICAR_DATA DATETIME	
	SET @VERIFICAR_DATA =( 
		SELECT TOP(1) DATA_CARGA FROM TB_AUX_PECA 
		WHERE DATA_CARGA  =  @DATA_CARGA)
		IF(@VERIFICAR_DATA IS NULL )
			BEGIN
				INSERT INTO TB_AUX_PECA 
				SELECT @DATA_CARGA, * FROM OLTP.DBO.TB_PECA
			END
		ELSE
			BEGIN
				DELETE FROM TB_AUX_PECA WHERE DATA_CARGA = @DATA_CARGA
				INSERT INTO TB_AUX_PECA
				SELECT @DATA_CARGA, * FROM OLTP.DBO.TB_PECA 
			END
		END


EXEC SP_CARGA_OLTP_PECA '2014-07-03'


CREATE PROCEDURE SP_CARGA_OLTP_SERVICO(@DATA_CARGA DATETIME)
AS
BEGIN
	DECLARE @VERIFICAR_DATA DATETIME	
	SET @VERIFICAR_DATA =( 
		SELECT TOP(1) DATA_CARGA FROM TB_AUX_SERVICO 
		WHERE DATA_CARGA  =  @DATA_CARGA)
		IF(@VERIFICAR_DATA IS NULL )
			BEGIN
				INSERT INTO TB_AUX_SERVICO 
				SELECT @DATA_CARGA, * FROM OLTP.DBO.TB_SERVICO
			END
		ELSE
			BEGIN
				DELETE FROM TB_AUX_SERVICO WHERE DATA_CARGA = @DATA_CARGA
				INSERT INTO TB_AUX_SERVICO
				SELECT @DATA_CARGA, * FROM OLTP.DBO.TB_SERVICO
			END
		END


EXEC SP_CARGA_OLTP_SERVICO '2014-07-03'


CREATE PROCEDURE SP_CARGA_OLTP_ORDEM_SERVICO(@DATA_CARGA DATETIME)
AS
BEGIN
	DECLARE @VERIFICAR_DATA DATETIME	
	SET @VERIFICAR_DATA =( 
		SELECT TOP(1) DATA_CARGA FROM TB_AUX_ORDEM_SERVICO 
		WHERE DATA_CARGA  =  @DATA_CARGA)
		IF(@VERIFICAR_DATA IS NULL )
			BEGIN
				INSERT INTO TB_AUX_ORDEM_SERVICO 
				SELECT @DATA_CARGA, * FROM OLTP.DBO.TB_ORDEM_SERVICO
			END
		ELSE
			BEGIN
				DELETE FROM TB_AUX_ORDEM_SERVICO WHERE DATA_CARGA = @DATA_CARGA
				INSERT INTO TB_AUX_ORDEM_SERVICO 
				SELECT @DATA_CARGA, * FROM OLTP.DBO.TB_ORDEM_SERVICO 
			END
		END


EXEC SP_CARGA_OLTP_ORDEM_SERVICO '2014-07-03'


CREATE PROCEDURE SP_CARGA_OLTP_PAGAMENTO(@DATA_CARGA DATETIME)
AS
BEGIN
	DECLARE @VERIFICAR_DATA DATETIME	
	SET @VERIFICAR_DATA =( 
		SELECT TOP(1) DATA_CARGA FROM TB_AUX_PAGAMENTO
		WHERE DATA_CARGA  =  @DATA_CARGA)
		IF(@VERIFICAR_DATA IS NULL )
			BEGIN
				INSERT INTO TB_AUX_PAGAMENTO 
				SELECT @DATA_CARGA, * FROM OLTP.DBO.TB_PAGAMENTO
			END
		ELSE
			BEGIN
				DELETE FROM TB_AUX_PAGAMENTO WHERE DATA_CARGA = @DATA_CARGA
				INSERT INTO TB_AUX_PAGAMENTO
				SELECT @DATA_CARGA, * FROM OLTP.DBO.TB_PAGAMENTO
			END
		END


EXEC SP_CARGA_OLTP_PAGAMENTO '2014-07-03'

------------------------------- EXECUTANDO PROCEDIMENTOS -------------------------------

SELECT * FROM TB_AUX_CARRO
SELECT * FROM TB_AUX_CLIENTE
SELECT * FROM TB_AUX_FORNECEDOR
SELECT * FROM TB_AUX_FUNCIONARIO
SELECT * FROM TB_AUX_PECA
SELECT * FROM TB_AUX_SERVICO
SELECT * FROM TB_AUX_ORDEM_SERVICO
SELECT * FROM TB_AUX_PAGAMENTO