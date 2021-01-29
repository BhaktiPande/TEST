/*
	Created By  :	
	Created On  :  
	Description :	
*/

IF EXISTS (SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_tra_GetQuantity_OS')
	DROP PROCEDURE st_tra_GetQuantity_OS
GO

CREATE PROCEDURE [dbo].[st_tra_GetQuantity_OS] --251
	--@inp_iTransactionType 	INT	,
	@inp_iDisclosuerType INT,
	@inp_iUserInfoId		INT,		
	@out_nReturnValue			INT = 0 OUTPUT
	,@out_nSQLErrCode			INT = 0 OUTPUT				-- Output SQL Error Number, if error occurred.
	,@out_sSQLErrMessage		NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
	
AS
BEGIN
	DECLARE @ERR_GETDETAILS INT = 50440 -- Error occurred while fetching code details.	
	DECLARE @nDisclosureType_Initial INT = 147001
	DECLARE @nDisclosureTypeCodeId INT
	DECLARE @nDisclosureType_Continuous INT = 147002
	DECLARE @nTransactionType_Buy INT = 143001
	DECLARE @nTransactionType_Sell INT = 143002
	

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
	
		IF(@inp_iDisclosuerType=@nDisclosureType_Initial)	
			BEGIN			
				SELECT *from tra_QuantityValueDetails_OS  where DisclouserType=@inp_iDisclosuerType
			END
		ELSE
		IF(@inp_iDisclosuerType=@nDisclosureType_Continuous)
			BEGIN			
				select * from tra_QuantityValueDetails_OS where DisclouserType=@inp_iDisclosuerType and TransactionType=143001
			END
		--ELSE
		--IF(@inp_iDisclosuerType=@nDisclosureType_Continuous and @inp_iTransactionType=@nTransactionType_Sell)
		--	BEGIN
		--	print'Cnt Sell'
		--		select * from tra_QuantityValueDetails_OS where @inp_iDisclosuerType=@nDisclosureType_Continuous and @inp_iTransactionType=@nTransactionType_Sell
		--	END	
				
		
		SET @out_nReturnValue = 0
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



