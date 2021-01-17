/*
	Created By  :	
	Created On  :  
	Description :	
*/

IF EXISTS (SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_tra_GetSellAllDetails_OS')	
	DROP PROCEDURE st_tra_GetSellAllDetails_OS
GO

CREATE PROCEDURE [dbo].[st_tra_GetSellAllDetails_OS] 
	@inp_iTransactionMasterId BIGINT,
	--@inp_iForUserInfoId BIGINT,
	--@inp_iTransactionDetalisId BIGINT,	
	--@inp_bSellAllFlag BIT,									--1=SellAll,0=Not SellAll
	--@inp_iForUserInfoId		INT,
	--@inp_iCompanyId INT,
	--@inp_iDMATDetailsId INT,	
	--@out_nSellAllID BIGINT = 0 OUTPUT,									
	@out_nReturnValue			INT = 0 OUTPUT
	,@out_nSQLErrCode			INT = 0 OUTPUT				-- Output SQL Error Number, if error occurred.
	,@out_sSQLErrMessage		NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
	

AS
BEGIN
	DECLARE @ERR_GETDETAILS INT = 50440 -- Error occurred while fetching code details.	
	
	DECLARE @nTransactionType_Sell INT = 143002
	DECLARE @nEnableDisableQuantityValueShow INT = 400002
	DECLARE @nEnableDisableQuantityValueHide INT = 400003
	DECLARE @nEnableDisableQuantityValue INT
	DECLARE @nSellAll bit
	DECLARE @ERR_TRADINGTRANSACTIONDETAILS_NOTFOUND INT
	DECLARE @nSellAllDetailsId INT

	 SELECT @ERR_TRADINGTRANSACTIONDETAILS_NOTFOUND = 17329

	BEGIN TRY
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;		
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''

					
		SELECT 
		SellAllDetailsId,
		TransactionMasterId,
		ForUserInfoId,
		SellAllFlag,
		CompanyId,
		DMATDetailsId
		
		FROM tra_SellAllValues_OS 
		
		WHERE TransactionMasterId=@inp_iTransactionMasterId --and ForUserInfoId=@inp_iForUserInfoId 
		--and CompanyId= and DMATDetailsId=
	
		--select *    from tra_SellAllValues_OS	where SellAllDetailsId=12	
		--SET @out_nReturnValue = 0
		RETURN @out_nReturnValue
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()
		
		-- Return common error if required, otherwise specific error.		
		SET @out_nReturnValue  = dbo.uf_com_GetErrorCode(@ERR_GETDETAILS, ERROR_NUMBER())
		RETURN @out_nReturnValue		
	END CATCH
END




