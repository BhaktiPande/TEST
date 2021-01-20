/*
	Created By  :	
	Created On  :  
	Description :	
*/

IF EXISTS (SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_tra_SaveSellAllDetails_OS')	
	DROP PROCEDURE st_tra_SaveSellAllDetails_OS
GO

CREATE PROCEDURE [dbo].[st_tra_SaveSellAllDetails_OS] 
	@inp_iTransactionMasterId BIGINT,	
	@inp_bSellAllFlag BIT,									--1=SellAll,0=Not SellAll
	@inp_iForUserInfoId		INT,
	@inp_iCompanyId INT,
	@inp_iDMATDetailsId INT,	
	@inp_iSecurityTypecodeId INT,
	@inp_Quanity DECIMAL(10,2),									
	@inp_Value DECIMAL(10,2),
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

			
			IF NOT EXISTS(SELECT 1 FROM tra_SellAllValues_OS WHERE TransactionMasterId = @inp_iTransactionMasterId and 
					  CompanyId=@inp_iCompanyId and DMATDetailsId= @inp_iDMATDetailsId and SecurityTypeCodeId=@inp_iSecurityTypecodeId)
				BEGIN
				
					INSERT INTO tra_SellAllValues_OS(TransactionMasterId,SellAllFlag,ForUserInfoId,CompanyId,DMATDetailsId,CreatedOn,ModifiedOn,SecurityTypeCodeId)
							VALUES(@inp_iTransactionMasterId , @inp_bSellAllFlag , @inp_iForUserInfoId,@inp_iCompanyId,@inp_iDMATDetailsId,dbo.uf_com_GetServerDate(),dbo.uf_com_GetServerDate(),@inp_iSecurityTypecodeId)
							
				END
			ELSE
			BEGIN
				UPDATE tra_SellAllValues_OS SET SellAllFlag= @inp_bSellAllFlag WHERE TransactionMasterId = @inp_iTransactionMasterId and 
					 ForUserInfoId=@inp_iForUserInfoId and CompanyId=@inp_iCompanyId and DMATDetailsId= @inp_iDMATDetailsId and SecurityTypeCodeId=@inp_iSecurityTypecodeId
			END
			
			DECLARE @nSellAllFlag INT=0
			DECLARE @nClosingBalance INT=0			
			DECLARE @nYearcodeID INT=0
		
		SELECT 		
		@nSellAllFlag=SellAllFlag		
		FROM tra_SellAllValues_OS SA	
		join usr_UserInfo UI on UI.UserInfoId = SA.ForUserInfoId
		WHERE TransactionMasterId = @inp_iTransactionMasterId and ForUserInfoId=@inp_iForUserInfoId and SA.CompanyId=@inp_iCompanyId and DMATDetailsId= @inp_iDMATDetailsId and SecurityTypeCodeId=@inp_iSecurityTypecodeId

		IF(@nSellAllFlag=1)
		BEGIN
			SELECT @nYearcodeID=MAX(YearCodeId) FROM tra_TransactionSummaryDMATWise_OS WHERE UserInfoIdRelative=@inp_iForUserInfoId and CompanyId=@inp_iCompanyId and DMATDetailsId= @inp_iDMATDetailsId and SecurityTypeCodeId=@inp_iSecurityTypecodeId
			SELECT @nClosingBalance=ClosingBalance FROM tra_TransactionSummaryDMATWise_OS WHERE YearCodeId=@nYearcodeID AND PeriodCodeId=124001 AND UserInfoIdRelative=@inp_iForUserInfoId and CompanyId=@inp_iCompanyId and DMATDetailsId= @inp_iDMATDetailsId and SecurityTypeCodeId=@inp_iSecurityTypecodeId
			UPDATE tra_TransactionDetails_OS SET Quantity=@nClosingBalance,Value=@inp_Quanity where TransactionMasterId=@inp_iTransactionMasterId
		END
		ELSE
		BEGIN
			UPDATE tra_TransactionDetails_OS SET Quantity=@inp_Quanity,Value=@inp_Value where TransactionMasterId=@inp_iTransactionMasterId
		END
		
		SELECT 
		SellAllDetailsId,
		TransactionMasterId,
		ForUserInfoId,
		SellAllFlag,
		SA.CompanyId,
		DMATDetailsId,
		UI.UserTypeCodeId
		FROM tra_SellAllValues_OS SA	
		join usr_UserInfo UI on UI.UserInfoId = SA.ForUserInfoId
		WHERE TransactionMasterId = @inp_iTransactionMasterId and ForUserInfoId=@inp_iForUserInfoId and SA.CompanyId=@inp_iCompanyId and DMATDetailsId= @inp_iDMATDetailsId and SecurityTypeCodeId=@inp_iSecurityTypecodeId
	
	
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




