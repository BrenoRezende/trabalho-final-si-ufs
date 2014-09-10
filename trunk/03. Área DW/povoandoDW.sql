USE LOCAL_DW

-----------------------------------------------------------------------------------------------
---- CARGA DIM_TEMPO
----------------------------------------------------------------------------------------------- 
CREATE PROCEDURE SP_Dim_Tempo(@DATA_INICIAL DATE, @DATA_FINAL DATE)
AS
	BEGIN
		DECLARE @ANO_INICIAL INT, @ANO_FINAL INT
		SET @ANO_INICIAL = YEAR(@DATA_INICIAL)
		SET	@ANO_FINAL = YEAR(@DATA_FINAL)
		
		EXEC SP_GRANULARIDADE_ANO @ANO_INICIAL, @ANO_FINAL 
		
		EXEC SP_GRANULARIDADE_MES @DATA_INICIAL, @DATA_FINAL
		
		EXEC SP_GRANULARIDADE_DIA @DATA_INICIAL, @DATA_FINAL
	END
	
-- CRIANDO GRANULARIDADE ANO --
CREATE PROCEDURE SP_GRANULARIDADE_ANO(@ANO_INICIAL INT, @ANO_FINAL INT)
AS
	BEGIN
		DECLARE @AUX_ANO INT
		
		WHILE(@ANO_INICIAL <= @ANO_FINAL)	
		BEGIN
			SET @AUX_ANO = (SELECT COUNT(Ano) FROM DIM_Tempo WHERE Ano = @ANO_INICIAL AND Nivel = 'ANO')
			IF (@AUX_ANO = 0)
			BEGIN
				INSERT INTO DIM_Tempo(Nivel, Ano) VALUES ('ANO', @ANO_INICIAL)
				SET @ANO_INICIAL += 1
			END
			ELSE
				SET @ANO_INICIAL += 1
		END
	END

-- CRIANDO GRANULARIDADE MES --

CREATE PROCEDURE SP_GRANULARIDADE_MES(@DATA_INICIAL DATE, @DATA_FINAL DATE)
AS
	BEGIN
		DECLARE @DIA SMALLINT, @MES SMALLINT, @NOME_MES VARCHAR(20),
		@TRIMESTRE SMALLINT, @NOME_TRIMESTRE VARCHAR(20),
		@SEMESTRE SMALLINT, @NOME_SEMESTRE VARCHAR(20), @ANO SMALLINT, @NIVEL VARCHAR(8)
			
		WHILE (@DATA_INICIAL <= @DATA_FINAL)
		BEGIN	
		IF((SELECT COUNT(Mes) FROM DIM_Tempo WHERE Mes = MONTH(@DATA_INICIAL) AND Ano = YEAR(@DATA_INICIAL) AND Nivel = 'MES') = 0)
		BEGIN
				SET @MES = MONTH(@DATA_INICIAL)
				SET @ANO = YEAR(@DATA_INICIAL)
				SET @DIA = DAY(@DATA_INICIAL)
				SET @NOME_MES = DATENAME (MM,@DATA_INICIAL)
				SET @TRIMESTRE = DATEPART(QQ, @DATA_INICIAL)
				SET @NOME_TRIMESTRE = CAST(@TRIMESTRE AS VARCHAR) + 'º TRIMESTRE / ' + CAST(@ANO AS VARCHAR)
				IF (@MES < 7)
					SET @SEMESTRE = 1
				ELSE
					SET @SEMESTRE = 2
				SET @NOME_SEMESTRE = CAST(@SEMESTRE AS VARCHAR) + 'º SEMESTRE / ' + CAST(@ANO AS VARCHAR)
				SET @NIVEL = 'MES'
			
				INSERT INTO DIM_Tempo(Nivel, Mes, NomeMes,Trimestre, NomeTrimestre,
							Semestre, NomeSemestre, Ano) VALUES(@NIVEL, @MES, @NOME_MES,
							@TRIMESTRE, @NOME_TRIMESTRE, @SEMESTRE, @NOME_SEMESTRE, @ANO)
				
				IF (@DIA > 1)
					SET @DATA_INICIAL = DATEADD(DD,-(@DIA -1), @DATA_INICIAL) 
				SET @DATA_INICIAL = DATEADD(MM,1,@DATA_INICIAL)
			END
			ELSE
			BEGIN
				IF (@DIA > 1)
					SET @DATA_INICIAL = DATEADD(DD,-(@DIA -1), @DATA_INICIAL) 
				SET @DATA_INICIAL = DATEADD(MM,1,@DATA_INICIAL)
			END
		END
	END

-- CRIANDO GRANULARIDADE DIA --
CREATE PROCEDURE SP_GRANULARIDADE_DIA(@DATA_INICIAL DATE, @DATA_FINAL DATE)
AS
	BEGIN
		DECLARE @NIVEL VARCHAR(8),@DATA DATETIME, @DIA SMALLINT, @DIA_SEMANA VARCHAR(25), 
		@DIA_UTIL CHAR(3), @FIM_SEMANA CHAR(3),
		@QUINZENA SMALLINT, @MES SMALLINT, @NOME_MES VARCHAR(20), @FIM_MES CHAR(3),
		@TRIMESTRE SMALLINT, @NOME_TRIMESTRE VARCHAR(20),
		@SEMESTRE SMALLINT, @NOME_SEMESTRE VARCHAR(20), @ANO SMALLINT, @AUX_DATA INT
		
		WHILE(@DATA_INICIAL <= @DATA_FINAL)
		BEGIN
		
			SET @AUX_DATA = (SELECT COUNT(Data) FROM DIM_Tempo WHERE Data = CAST(@DATA_INICIAL AS DATETIME))
			
			IF(@AUX_DATA = 0)
			BEGIN
				SET @NIVEL = 'DIA'
				SET @DATA = CAST(@DATA_INICIAL AS DATETIME) 
				SET @DIA = DAY(@DATA_INICIAL)
				SET @DIA_SEMANA = DATENAME(DW,@DATA_INICIAL)
				IF (DATEPART(DW, @DATA_INICIAL)> 1 AND DATEPART(DW, @DATA_INICIAL) < 7)
				BEGIN
					SET @DIA_UTIL = 'SIM'
					SET @FIM_SEMANA = 'NÃO'
				END
				ELSE
				BEGIN
					SET @DIA_UTIL = 'NÃO'
					SET @FIM_SEMANA = 'SIM'
				END
				IF (@DIA > 15)
					SET @QUINZENA = 2
				ELSE
					SET @QUINZENA = 1	
				SET @MES = MONTH(@DATA_INICIAL)
				SET @ANO = YEAR(@DATA_INICIAL)
				SET @NOME_MES = DATENAME (MM,@DATA_INICIAL)
				IF(DAY(DATEADD(DD,1,@DATA_INICIAL)) = 1)
					SET @FIM_MES = 'SIM'
				ELSE
					SET @FIM_MES = 'NÃO'
				SET @TRIMESTRE = DATEPART(QQ, @DATA_INICIAL)
				SET @NOME_TRIMESTRE = CAST(@TRIMESTRE AS VARCHAR) + 'º TRIMESTRE / ' + CAST(@ANO AS VARCHAR)
				IF (@MES < 7)
					SET @SEMESTRE = 1
				ELSE
					SET @SEMESTRE = 2
				SET @NOME_SEMESTRE = CAST(@SEMESTRE AS VARCHAR) + 'º SEMESTRE / ' + CAST(@ANO AS VARCHAR)
		
				INSERT INTO DIM_Tempo(Nivel, Data, Dia, DiaSemana, DiaUtil, FimSemana,
				Quinzena, Mes, NomeMes, FimMes, Trimestre, NomeTrimestre, Semestre, 
				NomeSemestre,Ano) VALUES (@NIVEL, @DATA, @DIA, @DIA_SEMANA, @DIA_UTIL,
				@FIM_SEMANA, @QUINZENA, @MES, @NOME_MES, @FIM_MES, @TRIMESTRE,
				@NOME_TRIMESTRE, @SEMESTRE, @NOME_SEMESTRE, @ANO)
		
				SET @DATA_INICIAL = DATEADD(DD,1,@DATA_INICIAL)	
			END
			ELSE
				SET @DATA_INICIAL = DATEADD(DD,1,@DATA_INICIAL)	

		END	
	END

-----------------------------------------------------------------------------------------------
---- CARGA DIM_CARRO
-----------------------------------------------------------------------------------------------
CREATE PROCEDURE SP_CARGA_CARRO(@DATA_CARGA DATETIME)
AS
	BEGIN
		DECLARE @CODIGO INT, @MODELO VARCHAR(45), @MARCA VARCHAR(45)
		
		DECLARE C_CARRO CURSOR FOR
		SELECT idCarro, modelo, marca
		FROM LOCAL_AUXILIAR.DBO.TB_AUX_CARRO
		WHERE data_carga = @DATA_CARGA
		
		OPEN C_CARRO 
		FETCH C_CARRO INTO @CODIGO, @MODELO, @MARCA
		
		WHILE (@@FETCH_STATUS = 0)
		BEGIN
			DECLARE @AUX INT
			SET @AUX = (SELECT COUNT(modelo) FROM DIM_Carro WHERE cod_carro = @CODIGO)
			
			IF(@AUX = 0)
			BEGIN
				INSERT INTO DIM_Carro(cod_carro,modelo,marca)
				VALUES (@CODIGO,@MODELO,@MARCA)
			END
			ELSE
			BEGIN
				DECLARE @MODELO_DIM VARCHAR(45), @MARCA_DIM VARCHAR(45)
				
				SET @MODELO_DIM = (SELECT modelo FROM DIM_Carro WHERE cod_carro = @CODIGO)
				SET @MARCA_DIM = (SELECT marca FROM DIM_Carro WHERE cod_carro = @CODIGO)
				
				IF(@MODELO <> @MODELO_DIM OR @MARCA <> @MARCA_DIM)
				BEGIN
					UPDATE DIM_Carro
					SET modelo = @MODELO, marca = @MARCA
					WHERE cod_carro = @CODIGO
				END
			END
			FETCH C_CARRO INTO @CODIGO, @MODELO, @MARCA
		END
		CLOSE C_CARRO
		DEALLOCATE C_CARRO
	END

-----------------------------------------------------------------------------------------------
---- CARGA DIM_FORNECEDOR
-----------------------------------------------------------------------------------------------
CREATE PROCEDURE SP_CARGA_FORNECEDOR(@DATA_CARGA DATETIME)
AS
	BEGIN
		DECLARE @CODIGO INT, @NOME VARCHAR(45), @TELEFONE VARCHAR(15)
		
		DECLARE C_FORNECEDOR CURSOR FOR
		SELECT idFornecedor, nome, telefone
		FROM LOCAL_AUXILIAR.DBO.TB_AUX_FORNECEDOR
		WHERE data_carga = @DATA_CARGA
		
		OPEN C_FORNECEDOR
		FETCH C_FORNECEDOR INTO @CODIGO, @NOME, @TELEFONE
		
		WHILE(@@FETCH_STATUS = 0)
		BEGIN
			DECLARE @AUX INT
			SET @AUX = (SELECT COUNT(nome) FROM DIM_Fornecedor WHERE cod_fornecedor = @CODIGO)
			
			IF(@AUX = 0)
			BEGIN
				INSERT INTO DIM_Fornecedor (cod_fornecedor, nome, telefone)
				VALUES(@CODIGO,@NOME,@TELEFONE)
			END
			ELSE
			BEGIN
				DECLARE @NOME_DIM VARCHAR(45), @TELEFONE_DIM VARCHAR(45)
				
				SET @NOME_DIM = (SELECT nome FROM DIM_Fornecedor WHERE cod_fornecedor = @CODIGO)
				SET @TELEFONE_DIM = (SELECT nome FROM DIM_Fornecedor WHERE cod_fornecedor = @CODIGO)
				
				IF(@NOME <> @NOME_DIM OR @TELEFONE <> @TELEFONE_DIM)
				BEGIN
					UPDATE DIM_Fornecedor
					SET nome = @NOME, telefone = @TELEFONE
					WHERE cod_fornecedor = @CODIGO
				END
			END
			FETCH C_FORNECEDOR INTO @CODIGO, @NOME, @TELEFONE
		END
		CLOSE C_FORNECEDOR
		DEALLOCATE C_FORNECEDOR
	END

-----------------------------------------------------------------------------------------------
---- CARGA DIM_SERVICO
-----------------------------------------------------------------------------------------------
CREATE PROCEDURE SP_CARGA_SERVICO(@DATA_CARGA DATETIME)
AS
	BEGIN
		DECLARE @CODIGO INT, @NOME VARCHAR(45), @TIPO VARCHAR(15), @VALOR NUMERIC(15,2)
				
		
		DECLARE C_SERVICO CURSOR FOR
		SELECT idServico, nome, tipo, valor
		FROM LOCAL_AUXILIAR.DBO.TB_AUX_SERVICO
		WHERE data_carga = @DATA_CARGA
		
		OPEN C_SERVICO
		FETCH C_SERVICO INTO @CODIGO, @NOME, @TIPO, @VALOR
		
		WHILE(@@FETCH_STATUS = 0)
		BEGIN
			DECLARE @AUX INT
			SET @AUX = (SELECT COUNT(nome) FROM DIM_SERVICO WHERE cod_servico = @CODIGO)
			
			IF(@AUX = 0)
			BEGIN
				INSERT INTO DIM_SERVICO(cod_servico, nome, tipo, valor, data_inicial, data_final
				, fl_corrente )
				VALUES(@CODIGO, @NOME, @TIPO, @VALOR, @DATA_CARGA, NULL, 'SIM')
			END
			ELSE
			BEGIN
				DECLARE @NOME_DIM VARCHAR(45), @TIPO_DIM VARCHAR(15), @VALOR_DIM NUMERIC(15,2)
						
				
				SET @NOME_DIM = (SELECT nome FROM DIM_SERVICO WHERE cod_servico = @CODIGO)
				SET @TIPO_DIM = (SELECT tipo FROM DIM_SERVICO WHERE cod_servico = @CODIGO)
				SET @VALOR_DIM = (SELECT valor FROM DIM_SERVICO WHERE cod_servico = @CODIGO)
				
				IF(@NOME <> @NOME_DIM OR @TIPO <> @TIPO_DIM)
				BEGIN
					UPDATE DIM_SERVICO
					SET nome = @NOME,
						tipo = @TIPO
					WHERE cod_servico = @CODIGO
				END
				
				IF (@VALOR <> @VALOR_DIM)
				BEGIN
					UPDATE DIM_SERVICO
					SET data_final = @DATA_CARGA,
						fl_corrente = 'NAO'
					WHERE cod_servico = @CODIGO AND data_final IS NULL
					
					INSERT INTO DIM_SERVICO(cod_servico, nome, tipo, valor, data_inicial, data_final
					, fl_corrente )
					VALUES(@CODIGO, @NOME, @TIPO, @VALOR, @DATA_CARGA, NULL, 'SIM')
				END
			END
			FETCH C_SERVICO INTO @CODIGO, @NOME, @TIPO, @VALOR
		END
		CLOSE C_SERVICO
		DEALLOCATE C_SERVICO
	END


-----------------------------------------------------------------------------------------------
---- CARGA DIM_PECA
-----------------------------------------------------------------------------------------------
CREATE PROCEDURE SP_CARGA_PECA(@DATA_CARGA DATETIME)
AS
	BEGIN
		DECLARE @CODIGO INT, @NOME VARCHAR(45), @VALOR NUMERIC(15,2)
				
		
		DECLARE C_PECA CURSOR FOR
		SELECT idPeca, nome, valor
		FROM LOCAL_AUXILIAR.DBO.TB_AUX_PECA
		WHERE data_carga = @DATA_CARGA
		
		OPEN C_PECA
		FETCH C_PECA INTO @CODIGO, @NOME, @VALOR
		
		WHILE(@@FETCH_STATUS = 0)
		BEGIN
			DECLARE @AUX INT
			SET @AUX = (SELECT COUNT(nome) FROM DIM_Peca WHERE cod_peca = @CODIGO)
			
			IF(@AUX = 0)
			BEGIN
				INSERT INTO DIM_Peca(cod_peca, nome, valor, data_inicial, data_final
				, fl_corrente )
				VALUES(@CODIGO, @NOME, @VALOR, @DATA_CARGA, NULL, 'SIM')
			END
			ELSE
			BEGIN
				DECLARE @NOME_DIM VARCHAR(45), @VALOR_DIM NUMERIC(15,2)
						
				
				SET @NOME_DIM = (SELECT nome FROM DIM_Peca WHERE cod_peca = @CODIGO)
				SET @VALOR_DIM = (SELECT valor FROM DIM_Peca WHERE cod_peca = @CODIGO)
				
				IF(@NOME <> @NOME_DIM)
				BEGIN
					UPDATE DIM_Peca
					SET nome = @NOME
					WHERE cod_peca = @CODIGO
				END
				
				IF (@VALOR <> @VALOR_DIM)
				BEGIN
					UPDATE DIM_Peca
					SET data_final = @DATA_CARGA,
						fl_corrente = 'NAO'
					WHERE cod_peca = @CODIGO AND data_final IS NULL
					
					INSERT INTO DIM_Peca(cod_peca, nome, valor, data_inicial, data_final
					, fl_corrente )
					VALUES(@CODIGO, @NOME, @VALOR, @DATA_CARGA, NULL, 'SIM')
				END
			END
			FETCH C_PECA INTO @CODIGO, @NOME, @VALOR
		END
		CLOSE C_PECA
		DEALLOCATE C_PECA
	END


-----------------------------------------------------------------------------------------------
---- CARGA DIM_CLIENTE
-----------------------------------------------------------------------------------------------
CREATE PROCEDURE SP_CARGA_CLIENTE(@DATA_CARGA DATETIME)
AS
	BEGIN
		DECLARE @CODIGO INT, @NOME VARCHAR(60),@CPF VARCHAR(13), @RG VARCHAR(25),
				@RUA VARCHAR(60), @NUMERO INT, @BAIRRO VARCHAR(30), @CIDADE VARCHAR(45),
				@ESTADO VARCHAR(45), @TELEFONE VARCHAR(15) 
				
		
		DECLARE C_CLIENTE CURSOR FOR
		SELECT idCliente, nome, cpf, rg, rua, numero, bairro, cidade, estado, telefone
		FROM LOCAL_AUXILIAR.DBO.TB_AUX_CLIENTE
		WHERE data_carga = @DATA_CARGA
		
		OPEN C_CLIENTE
		FETCH C_CLIENTE INTO @CODIGO, @NOME, @CPF, @RG, @RUA, @NUMERO, @BAIRRO, @CIDADE, @ESTADO,
								@TELEFONE
		
		WHILE(@@FETCH_STATUS = 0)
		BEGIN
			DECLARE @AUX INT
			SET @AUX = (SELECT COUNT(nome) FROM DIM_Cliente WHERE cod_cliente = @CODIGO)
			
			IF(@AUX = 0)
			BEGIN
				INSERT INTO DIM_Cliente(cod_cliente, nome, cpf, rg, rua, numero, bairro,
							cidade, estado, telefone)
				VALUES(@CODIGO, @NOME, @CPF, @RG, @RUA, @NUMERO, @BAIRRO, @CIDADE, @ESTADO,
						@TELEFONE)
			END
			ELSE
			BEGIN 
				UPDATE DIM_Cliente
				SET nome = @NOME,
					cpf = @CPF,
					rg = @RG,
					rua = @RUA,
					numero = @NUMERO,
					bairro = @BAIRRO,
					cidade = @CIDADE,
					estado = @ESTADO,
					telefone = @TELEFONE
				WHERE cod_cliente = @CODIGO
			END
			FETCH C_CLIENTE INTO @CODIGO, @NOME, @CPF, @RG, @RUA, @NUMERO, @BAIRRO, @CIDADE, @ESTADO,
								@TELEFONE
		END
		CLOSE C_CLIENTE
		DEALLOCATE C_CLIENTE
	END

-----------------------------------------------------------------------------------------------
---- CARGA DIM_FUNCIONARIO
-----------------------------------------------------------------------------------------------
CREATE PROCEDURE SP_CARGA_FUNCIONARIO(@DATA_CARGA DATETIME)
AS
	BEGIN
		
		DECLARE @CODIGO INT, @NOME VARCHAR(60), @CPF VARCHAR(13), @CARGO VARCHAR(50), 
			@FUNCAO VARCHAR(50), @SALARIO NUMERIC(10,2)
	
		DECLARE C_FUNCIONARIO CURSOR FOR
		SELECT idFuncionario, nome, cpf, cargo, funcao, salario
		FROM LOCAL_AUXILIAR.DBO.TB_AUX_FUNCIONARIO
		WHERE data_carga = @DATA_CARGA
		
		OPEN C_FUNCIONARIO
		FETCH C_FUNCIONARIO INTO @CODIGO, @NOME, @CPF, @CARGO, @FUNCAO, @SALARIO
		
		WHILE(@@FETCH_STATUS = 0)
		BEGIN
			
			DECLARE @AUX INT
			SET @AUX = (SELECT COUNT(NOME) FROM DIM_Funcionario WHERE cod_funcionario = @CODIGO)
			
			IF(@AUX = 0)
			BEGIN
				INSERT INTO DIM_Funcionario (cod_funcionario, nome, cpf, cargo, funcao, salario,
							data_inicial, data_final, fl_corrente)
					VALUES (@CODIGO, @NOME, @CPF, @CARGO, @FUNCAO, @SALARIO, @DATA_CARGA, NULL, 'SIM')
			END
			ELSE
			BEGIN
				DECLARE @NOME_DIM VARCHAR(60), @CPF_DIM VARCHAR(13), @CARGO_DIM VARCHAR(50), 
					@FUNCAO_DIM VARCHAR(50), @SALARIO_DIM NUMERIC(10,2)
			
				SET @NOME_DIM = (SELECT nome FROM DIM_Funcionario WHERE cod_funcionario = @CODIGO)
				SET @CPF_DIM = (SELECT cpf FROM DIM_Funcionario WHERE cod_funcionario = @CODIGO)
				SET @CARGO_DIM = (SELECT cargo FROM DIM_Funcionario WHERE cod_funcionario = @CODIGO)
				SET @FUNCAO_DIM = (SELECT funcao FROM DIM_Funcionario WHERE cod_funcionario = @CODIGO)
				SET @SALARIO_DIM = (SELECT salario FROM DIM_Funcionario WHERE cod_funcionario = @CODIGO)	
				
				IF(@NOME_DIM <> @NOME)
				BEGIN
					UPDATE DIM_Funcionario
					SET nome = @NOME
					WHERE cod_funcionario = @CODIGO
				END
				
				IF(@CPF_DIM <> @CPF)
				BEGIN
					UPDATE DIM_Funcionario
					SET cpf = @CPF
					WHERE cod_funcionario = @CODIGO
				END
				
				IF(@CARGO_DIM <> @CARGO OR @FUNCAO_DIM <> @FUNCAO OR @SALARIO_DIM <> @SALARIO)
				BEGIN
					UPDATE DIM_Funcionario
					SET data_final = @DATA_CARGA,
						fl_corrente = 'NAO'
					WHERE cod_funcionario = @CODIGO AND data_final IS NULL
					
					INSERT INTO DIM_Funcionario (cod_funcionario, nome, cpf, cargo, funcao, salario,
							data_inicial, data_final, fl_corrente)
					VALUES (@CODIGO, @NOME, @CPF, @CARGO, @FUNCAO, @SALARIO, @DATA_CARGA, NULL, 'SIM')
				END
			END
			FETCH C_FUNCIONARIO INTO @CODIGO, @NOME, @CPF, @CARGO, @FUNCAO, @SALARIO
		END
		CLOSE C_FUNCIONARIO
		DEALLOCATE C_FUNCIONARIO
	END
	
	
-----------------------------------------------------------------------------------------------
---- CARGA FATO_ORDEM_SERVICO
-----------------------------------------------------------------------------------------------
CREATE PROCEDURE SP_CARGA_ORDEM_SERVICO(@DATA_CARGA DATETIME)
AS
	BEGIN
		DECLARE @CODIGO INT, @VALOR_TOTAL NUMERIC (15,2), @TIPO_PAGAMENTO VARCHAR(45),
				@ID_CARRO INT, @ID_FORNECEDOR INT, @ID_PECA INT, @ID_SERVICO INT, 
				@ID_CLIENTE INT, @ID_FUNCIONARIO INT, @DATA_CRIACAO DATETIME, 
				@DATA_FINALIZACAO DATETIME, @DATA_PAGAMENTO DATETIME
		
		DECLARE C_ORDEM_SERVICO CURSOR FOR
		SELECT idOrdemServico, valorTotal, dataCriacao, dataFinalizacao, idCarro, idCliente,
		idFuncionario, idServico, idPeca, idFornecedor
		FROM LOCAL_AUXILIAR.DBO.TB_AUX_ORDEM_SERVICO
		WHERE data_carga = @DATA_CARGA
			
		OPEN C_ORDEM_SERVICO
		FETCH C_ORDEM_SERVICO INTO @CODIGO, @VALOR_TOTAL, @DATA_CRIACAO, @DATA_FINALIZACAO,
		@ID_CARRO, @ID_CLIENTE ,@ID_FUNCIONARIO, @ID_SERVICO, @ID_PECA, @ID_FORNECEDOR
		
		WHILE(@@FETCH_STATUS = 0)
		BEGIN
			DECLARE @AUX INT, @ID_TEMPO_CRIACAO INT, @ID_TEMPO_FINALIZACAO INT, @ID_TEMPO_PAGAMENTO INT
			
			SET @ID_TEMPO_CRIACAO = (SELECT id_tempo FROM DIM_Tempo WHERE Data = @DATA_CRIACAO AND Nivel = 'Dia')
			SET @ID_TEMPO_FINALIZACAO = (SELECT id_tempo FROM DIM_Tempo WHERE Data = @DATA_FINALIZACAO AND Nivel = 'Dia')
			SET @TIPO_PAGAMENTO = (SELECT tipo FROM LOCAL_AUXILIAR.DBO.TB_AUX_PAGAMENTO WHERE idOrdemServico = @CODIGO)
			SET @DATA_PAGAMENTO = (SELECT data FROM LOCAL_AUXILIAR.DBO.TB_AUX_PAGAMENTO WHERE idOrdemServico = @CODIGO)
			SET @ID_TEMPO_PAGAMENTO = (SELECT id_tempo FROM DIM_Tempo WHERE Data = @DATA_PAGAMENTO AND Nivel = 'Dia')
			
			SET @AUX = (SELECT COUNT(valorTotal) FROM FATO_ORDEM_SERVICO WHERE cod_ordem_servico = @CODIGO)
			
			IF(@AUX = 0)
			BEGIN
				INSERT INTO FATO_ORDEM_SERVICO (cod_ordem_servico, quantidade, valorTotal, tipo_pagamento,
							id_carro, id_fornecedor, id_peca, id_servico, id_cliente, id_funcionario,
							id_tempo_criacao, id_tempo_finalizacao, id_tempo_pagamento)
				VALUES (@CODIGO, 1, @VALOR_TOTAL, @TIPO_PAGAMENTO, @ID_CARRO, @ID_FORNECEDOR, @ID_PECA,
							@ID_SERVICO, @ID_CLIENTE, @ID_FUNCIONARIO, @ID_TEMPO_CRIACAO, @ID_TEMPO_FINALIZACAO,
							@ID_TEMPO_PAGAMENTO)
			END
			ELSE
			BEGIN
				UPDATE FATO_ORDEM_SERVICO
				SET valorTotal = @VALOR_TOTAL,
					tipo_pagamento = @TIPO_PAGAMENTO,
					id_carro = @ID_CARRO,
					id_fornecedor = @ID_FORNECEDOR,
					id_peca = @ID_PECA,
					id_servico = @ID_SERVICO,
					id_cliente = @ID_CLIENTE,
					id_funcionario = @ID_FUNCIONARIO,
					id_tempo_criacao = @ID_TEMPO_CRIACAO,
					id_tempo_finalizacao = @ID_TEMPO_FINALIZACAO,
					id_tempo_pagamento = @ID_TEMPO_PAGAMENTO
				WHERE cod_ordem_servico = @CODIGO
			END
			DECLARE @GET_ID INT
			SET @GET_ID = (SELECT id_ordem_servico FROM FATO_ORDEM_SERVICO WHERE cod_ordem_servico = @CODIGO)
			EXEC SP_CARGA_AGREGADO_ORDENS_POR_DIA @GET_ID
			
			FETCH C_ORDEM_SERVICO INTO @CODIGO, @VALOR_TOTAL, @DATA_CRIACAO, @DATA_FINALIZACAO,
			@ID_CARRO, @ID_CLIENTE ,@ID_FUNCIONARIO, @ID_SERVICO, @ID_PECA, @ID_FORNECEDOR
		END
		CLOSE C_ORDEM_SERVICO
		DEALLOCATE C_ORDEM_SERVICO
	END

-----------------------------------------------------------------------------------------------
---- CARGA AGREGADO_ORDENS_SERVICO_CRIADA_POR_DIA
-----------------------------------------------------------------------------------------------
CREATE PROCEDURE SP_CARGA_AGREGADO_ORDENS_POR_DIA(@ID_ORDEM_SERVICO INT)
AS
	BEGIN
		DECLARE @QUANTIDADE INT, @ID_TEMPO INT, @AUX INT
		
		SET @ID_TEMPO = (SELECT id_tempo_criacao FROM FATO_ORDEM_SERVICO WHERE id_ordem_servico = @ID_ORDEM_SERVICO)
		SET @QUANTIDADE = (SELECT SUM(quantidade) FROM FATO_ORDEM_SERVICO WHERE id_tempo_criacao = @ID_TEMPO)
		
		SET @AUX = (SELECT COUNT(quantidade) FROM AGREGADO_ORDENS_SERVICO_CRIADA_POR_DIA WHERE id_ordem_servico = @ID_ORDEM_SERVICO)
		
		IF (@AUX = 0)
		BEGIN
			SET @ID_TEMPO = (SELECT id_tempo_criacao FROM FATO_ORDEM_SERVICO WHERE id_ordem_servico = @ID_ORDEM_SERVICO)
			SET @QUANTIDADE = (SELECT SUM(quantidade) FROM FATO_ORDEM_SERVICO WHERE id_tempo_criacao = @ID_TEMPO)
			
			INSERT INTO AGREGADO_ORDENS_SERVICO_CRIADA_POR_DIA(quantidade, id_ordem_servico, id_tempo)
			VALUES (@QUANTIDADE, @ID_ORDEM_SERVICO, @ID_TEMPO)
		END
		ELSE
		BEGIN
			UPDATE AGREGADO_ORDENS_SERVICO_CRIADA_POR_DIA
			SET quantidade = @QUANTIDADE
			WHERE id_ordem_servico = @ID_ORDEM_SERVICO
		END
		
	END

-----------------------------------------------------------------------------------------------
	
EXEC SP_Dim_Tempo '01/01/2014', '01/08/2015'
SELECT * FROM DIM_Tempo
	
EXEC SP_CARGA_CARRO '2014-09-09'
SELECT * FROM DIM_Carro

EXEC SP_CARGA_FORNECEDOR '2014-09-09'
SELECT * FROM DIM_Fornecedor

EXEC SP_CARGA_SERVICO '2014-09-09'
SELECT * FROM DIM_SERVICO

EXEC SP_CARGA_PECA '2014-09-09'
SELECT * FROM DIM_Peca

EXEC SP_CARGA_CLIENTE '2014-09-09'
SELECT * FROM DIM_Cliente

EXEC SP_CARGA_FUNCIONARIO '2014-09-09'
SELECT * FROM DIM_Funcionario

EXEC SP_CARGA_ORDEM_SERVICO '2014-09-09'
SELECT * FROM FATO_ORDEM_SERVICO

SELECT * FROM AGREGADO_ORDENS_SERVICO_CRIADA_POR_DIA

