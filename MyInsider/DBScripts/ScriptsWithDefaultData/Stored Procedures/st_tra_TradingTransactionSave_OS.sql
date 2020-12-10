IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_tra_TradingTransactionSave_OS')
DROP PROCEDURE [dbo].[st_tra_TradingTransactionSave_OS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_tra_TradingTransactionSave_OS] 
	@inp_iTransactionDetailsId BIGINT,
	@inp_iTransactionMasterId BIGINT,
	@inp_iSecurityTypeCodeId INT,
	@inp_iForUserInfoId INT,
	@inp_iDMATDetailsID INT,
	@inp_iCompanyId INT,
	@inp_dtDateOfAcquisition DATETIME,
	@inp_dtDateOfInitimationToCompany DATETIME,
	@inp_iModeOfAcquisitionCodeId INT ,
	@inp_iExchangeCodeId INT,
	@inp_iTransactionTypeCodeId INT,
	@inp_dQuantity decimal(10, 0),
	@inp_dValue decimal(10, 0),	
	@inp_iLotSize INT,	
	@inp_sContractSpecification VARCHAR(50),
	@inp_sCompanyName			VARCHAR(300),	
	@inp_iLoggedInUserId	INT,
	@inp_dOtherExcerciseOptionQty decimal(10, 0),
	@out_nReturnValue		INT = 0 OUTPUT,
	@out_nSQLErrCode		INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage		NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
AS
BEGIN
	DECLARE @ERR_TRADINGTRANSACTIONDETAILS_SAVE INT = 17328
	DECLARE @out_nSavedTransactionDetailsId INT
	BEGIN TRY
			
			EXEC st_tra_TradingTransactionSave_Override_OS @inp_iTransactionDetailsId ,@inp_iTransactionMasterId ,@inp_iSecurityTypeCodeId ,
							@inp_iForUserInfoId ,@inp_iDMATDetailsID ,@inp_iCompanyId ,					
							@inp_dtDateOfAcquisition ,@inp_dtDateOfInitimationToCompany ,@inp_iModeOfAcquisitionCodeId  ,				
							@inp_iExchangeCodeId ,
							@inp_iTransactionTypeCodeId ,
							@inp_dQuantity ,@inp_dValue ,				
							@inp_iLotSize, @inp_sContractSpecification, @inp_sCompanyName,
							@inp_iLoggedInUserId,'',
							@inp_dOtherExcerciseOptionQty,					
							@out_nSavedTransactionDetailsId OUTPUT, @out_nReturnValue OUTPUT,@out_nSQLErrCode  OUTPUT,@out_sSQLErrMessage  OUTPUT
	
			RETURN @out_nReturnValue

	END TRY	
	BEGIN CATCH	

			SET @out_nSQLErrCode    =  ERROR_NUMBER()
			SET @out_sSQLErrMessage =   ERROR_MESSAGE()	
		
			-- Return common error if required, otherwise specific error.		
			SET @out_nReturnValue =  dbo.uf_com_GetErrorCode(@ERR_TRADINGTRANSACTIONDETAILS_SAVE, ERROR_NUMBER())
			RETURN @out_nReturnValue

	END CATCH
END