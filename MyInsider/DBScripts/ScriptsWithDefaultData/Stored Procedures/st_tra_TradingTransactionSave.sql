IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_tra_TradingTransactionSave')
DROP PROCEDURE [dbo].[st_tra_TradingTransactionSave]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
Description:	Saves the TradingTransaction details

Returns:		0, if Success.
				
Created by:		Gaurishankar
Created on:		14-Apr-2015
Modification History:
Modified By		Modified On	Description
Amar			22-May-2015  Changes done to add newly added fields.
Amar			26-May-2015  Added default value to @inp_dtDateOfAcquisition to current date.
Arundhati		28-May-2015	Added call to st_tra_TransactionDetailsValidation procedure
Arundhati		26-Jun-2015	SecurityType is updated in Transaction Master for continuous disclosure
Amar            04-Jul-2015 Changed decimal(4,2) to decimal(5,2) for percentage of shares pre and post transaction
Arundahti		08-Jul-2015	Added parameter in validation procedure. Corresponding changes done.
Arundhati		17-Jul-2015	Query to update security type in transaction master is corrected.
							TransactionMasterId was not in the where clause. So it was updating all records.
Amar			21-Jul-2015 Changed decimal(5,0) to (10,0) for @inp_dSecuritiesPriorToAcquisition, @inp_dQuantity, @inp_dQuantity2 and local variable @dQuantity
Gaurishankar	25-Nov-2015	Added new parameter for New disclosure and contra trade change
Tushar			08-Dec-2015	Datatype change for INT to decimal for @inp_dESOPExcerciseOptionQty & @inp_dOtherExcerciseOptionQty
Raghvendra		07-Sep-2016	Changed the GETDATE() call with function dbo.uf_com_GetServerDate(). This function will return the date to be used as server date.

Usage:
DECLARE @RC int
EXEC st_tra_TradingTransactionSave ,1
-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_tra_TradingTransactionSave] 
	@inp_iTransactionDetailsId BIGINT,
	@inp_iTransactionMasterId BIGINT,
	@inp_iSecurityTypeCodeId INT,
	@inp_iForUserInfoId INT,
	@inp_iDMATDetailsID INT,
	@inp_iCompanyId INT,
	@inp_dSecuritiesPriorToAcquisition decimal(10, 0),
	@inp_dPerOfSharesPreTransaction decimal(5, 2),
	@inp_dtDateOfAcquisition DATETIME,
	@inp_dtDateOfInitimationToCompany DATETIME,
	@inp_iModeOfAcquisitionCodeId INT ,
	@inp_dPerOfSharesPostTransaction decimal(5, 2),
	@inp_iExchangeCodeId INT,
	@inp_iTransactionTypeCodeId INT,
	@inp_dQuantity decimal(10, 0),
	@inp_dValue decimal(10, 0),
	@inp_dQuantity2 decimal(10, 0),
	@inp_dValue2 decimal(10, 0),	
	@inp_iTransactionLetterId BIGINT,	
	@inp_iLotSize INT,	
	@inp_dDateOfBecomingInsider datetime,	
	@inp_bSegregateESOPAndOtherExcerciseOptionQtyFalg BIT,	
	@inp_dESOPExcerciseOptionQty decimal(10, 0),
	@inp_dOtherExcerciseOptionQty decimal(10, 0),	
	@inp_bESOPExcerseOptionQtyFlag BIT,	
	@inp_bOtherESOPExcerseOptionFlag BIT,	
	@inp_sContractSpecification VARCHAR(50),	
	@inp_iLoggedInUserId	INT,
	@inp_CurrencyId int=0,
	@out_nReturnValue		INT = 0 OUTPUT,
	@out_nSQLErrCode		INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage		NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
	
AS
BEGIN

	DECLARE @ERR_TRADINGTRANSACTIONDETAILS_SAVE INT = 17328
	DECLARE @out_nSavedTransactionDetailsId INT
	
	
	--DECLARE @ERR_TRADINGTRANSACTIONDETAILS_NOTFOUND INT
	--DECLARE @nTmpRet INT = 0
	--DECLARE @dQuantity decimal(10, 0)
	--DECLARE @dValue decimal(10, 0)
	--DECLARE @nWarningMsg INT
	
	BEGIN TRY
	
	
	EXEC st_tra_TradingTransactionSave_Override @inp_iTransactionDetailsId ,@inp_iTransactionMasterId ,@inp_iSecurityTypeCodeId ,
					@inp_iForUserInfoId ,@inp_iDMATDetailsID ,@inp_iCompanyId ,@inp_dSecuritiesPriorToAcquisition ,@inp_dPerOfSharesPreTransaction ,
					@inp_dtDateOfAcquisition ,@inp_dtDateOfInitimationToCompany ,@inp_iModeOfAcquisitionCodeId  ,@inp_dPerOfSharesPostTransaction ,
					@inp_iExchangeCodeId ,@inp_iTransactionTypeCodeId ,@inp_dQuantity ,@inp_dValue ,@inp_dQuantity2 ,@inp_dValue2 ,
					@inp_iTransactionLetterId ,@inp_iLotSize ,@inp_dDateOfBecomingInsider ,@inp_iLoggedInUserId,'',
					@inp_bSegregateESOPAndOtherExcerciseOptionQtyFalg,@inp_dESOPExcerciseOptionQty,	@inp_dOtherExcerciseOptionQty ,
					@inp_bESOPExcerseOptionQtyFlag ,@inp_bOtherESOPExcerseOptionFlag ,	@inp_sContractSpecification,
					@out_nSavedTransactionDetailsId OUTPUT, @out_nReturnValue OUTPUT,@out_nSQLErrCode  OUTPUT,@out_sSQLErrMessage  OUTPUT,@inp_CurrencyId
	
	--	-- SET NOCOUNT ON added to prevent extra result sets from
	--	-- interfering with SELECT statements.
	--	SET NOCOUNT ON;
		
	--	if(@inp_dtDateOfAcquisition IS NULL)
	--	BEGIN
	--		SELECT @inp_dtDateOfAcquisition = dbo.uf_com_GetServerDate();
	--	END
		
	--	--Initialize variables
	--	SELECT	@ERR_TRADINGTRANSACTIONDETAILS_SAVE = 17328,  -- Not defined
	--			@ERR_TRADINGTRANSACTIONDETAILS_NOTFOUND = 17329 -- Not defined

	--	SELECT @dQuantity = @inp_dQuantity, -- + @inp_dQuantity2,
	--			@dValue = @inp_dValue --+ @inp_dValue2
	--	EXEC @nTmpRet = st_tra_TransactionDetailsValidation @inp_iTransactionDetailsId, @inp_iTransactionMasterId, @inp_iSecurityTypeCodeId, 
	--														@inp_iForUserInfoId, @inp_iDMATDetailsID, @inp_iCompanyId, 
	--														--@inp_dNoOfSharesVotingRightsAcquired, @inp_dPercentageOfSharesVotingRightsAcquired, 
	--														@inp_dtDateOfAcquisition, @inp_dtDateOfInitimationToCompany, @inp_iModeOfAcquisitionCodeId, 
	--														--@inp_dShareHoldingSubsequentToAcquisition, 
	--														@inp_iExchangeCodeId, 
	--														@inp_iTransactionTypeCodeId, @dQuantity, @dValue, @inp_iLoggedInUserId, 
	--														@nWarningMsg OUTPUT, @out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT, @out_sSQLErrMessage OUTPUT
	--	IF @out_nReturnValue <> 0
	--	BEGIN
	--		--SET @out_nReturnValue = @ERR_TRADINGTRANSACTIONDETAILS_SAVE
	--		RETURN @out_nReturnValue
	--	END

	--	UPDATE u 
	--	SET DateOfBecomingInsider = @inp_dDateOfBecomingInsider,
	--		ModifiedBy = @inp_iLoggedInUserId,
	--		ModifiedOn = dbo.uf_com_GetServerDate()
	--	FROM usr_UserInfo u JOIN tra_TransactionMaster t ON u.UserInfoId = t.UserInfoId
	--	WHERE t.TransactionMasterId = @inp_iTransactionMasterId

	--	-- Update Security type in TransactionMaster, if the disclosure type is continuous and this is the first transaction detail entry
	--	IF EXISTS (SELECT TransactionMasterId FROM tra_TransactionMaster WHERE TransactionMasterId = @inp_iTransactionMasterId AND DisclosureTypeCodeId = 147002)
	--	BEGIN
	--		-- Update transaction master, if it is first transaction
	--		IF NOT EXISTS(SELECT * FROM tra_TransactionDetails WHERE TransactionMasterId = @inp_iTransactionMasterId)
	--		BEGIN
	--			UPDATE tra_TransactionMaster
	--			SET SecurityTypeCodeId = @inp_iSecurityTypeCodeId
	--			WHERE TransactionMasterId = @inp_iTransactionMasterId
	--		END
	--	END
		
	--	--Save the Trading transaction details 
	--	IF @inp_iTransactionDetailsId = 0
	--	BEGIN
	--		--IF NOT EXISTS(SELECT TransactionDetailsId FROM tra_TransactionDetails WHERE TransactionDetailsId = @inp_iTransactionDetailsId )
	--		--BEGIN
	--		--	SET @inp_iIsDefault = 1
	--		--END
		
	--		Insert into tra_TransactionDetails(
	--					TransactionMasterId
	--				  ,SecurityTypeCodeId
	--				  ,ForUserInfoId
	--				  ,DMATDetailsID
	--				  ,CompanyId
	--				  ,SecuritiesPriorToAcquisition
	--				  ,PerOfSharesPreTransaction
	--				  ,DateOfAcquisition
	--				  ,DateOfInitimationToCompany
	--				  ,ModeOfAcquisitionCodeId
	--				  ,PerOfSharesPostTransaction
	--				  ,ExchangeCodeId
	--				  ,TransactionTypeCodeId
	--				  ,Quantity
	--				  ,Value
	--				  ,Quantity2
	--				  ,Value2
	--				  ,TransactionLetterId
	--				  ,LotSize
	--				  ,CreatedBy, CreatedOn, ModifiedBy, ModifiedOn )
	--		Values (
	--				@inp_iTransactionMasterId ,
	--				@inp_iSecurityTypeCodeId ,
	--				@inp_iForUserInfoId ,
	--				@inp_iDMATDetailsID ,
	--				@inp_iCompanyId ,
	--				@inp_dSecuritiesPriorToAcquisition,
	--				@inp_dPerOfSharesPreTransaction ,
	--				@inp_dtDateOfAcquisition ,
	--				@inp_dtDateOfInitimationToCompany ,
	--				@inp_iModeOfAcquisitionCodeId  ,
	--				@inp_dPerOfSharesPostTransaction ,
	--				@inp_iExchangeCodeId ,
	--				@inp_iTransactionTypeCodeId ,
	--				@inp_dQuantity ,
	--				@inp_dValue,
	--				@inp_dQuantity2 ,
	--				@inp_dValue2,
	--				@inp_iTransactionLetterId,
	--				@inp_iLotSize,
	--				@inp_iLoggedInUserId, dbo.uf_com_GetServerDate(), @inp_iLoggedInUserId, dbo.uf_com_GetServerDate() )
	--				SELECT @inp_iTransactionDetailsId = SCOPE_IDENTITY()
	--	END
	--	ELSE
	--	BEGIN
	--		--Check if the RoleMaster whose details are being updated exists
	--		IF (NOT EXISTS(SELECT TransactionDetailsId FROM tra_TransactionDetails WHERE TransactionDetailsId = @inp_iTransactionDetailsId))		
	--		BEGIN
	--			SET @out_nReturnValue = @ERR_TRADINGTRANSACTIONDETAILS_NOTFOUND
	--			RETURN (@out_nReturnValue)
	--		END
	
			
	--		Update tra_TransactionDetails
	--		Set 	TransactionMasterId = @inp_iTransactionMasterId
	--				,SecurityTypeCodeId = @inp_iSecurityTypeCodeId
	--				,ForUserInfoId = @inp_iForUserInfoId
	--				,DMATDetailsID = @inp_iDMATDetailsID
	--				,CompanyId = @inp_iCompanyId
	--				,SecuritiesPriorToAcquisition = @inp_dSecuritiesPriorToAcquisition
	--				,PerOfSharesPreTransaction = @inp_dPerOfSharesPreTransaction
	--				,DateOfAcquisition = @inp_dtDateOfAcquisition
	--				,DateOfInitimationToCompany = @inp_dtDateOfInitimationToCompany
	--				,ModeOfAcquisitionCodeId = @inp_iModeOfAcquisitionCodeId
	--				,PerOfSharesPostTransaction = @inp_dPerOfSharesPostTransaction
	--				,ExchangeCodeId = @inp_iExchangeCodeId
	--				,TransactionTypeCodeId = @inp_iTransactionTypeCodeId
	--				,Quantity = @inp_dQuantity
	--				,Value = @inp_dValue
	--				,Quantity2 = @inp_dQuantity2
	--				,Value2 = @inp_dValue2
	--				,TransactionLetterId = @inp_iTransactionLetterId
	--				,LotSize = @inp_iLotSize
	--				,ModifiedBy	= @inp_iLoggedInUserId
	--				,ModifiedOn = dbo.uf_com_GetServerDate()
	--		Where TransactionDetailsId = @inp_iTransactionDetailsId	
			
	--	END
		
		
	--	-- in case required to return for partial save case.
	--	Select TransactionDetailsId,
	--		TransactionMasterId
	--		,SecurityTypeCodeId
	--		,ForUserInfoId
	--		,DMATDetailsID
	--		,CompanyId
	--		,SecuritiesPriorToAcquisition
	--		,PerOfSharesPreTransaction
	--		,DateOfAcquisition
	--		,DateOfInitimationToCompany
	--		,ModeOfAcquisitionCodeId
	--		,PerOfSharesPostTransaction
	--		,ExchangeCodeId
	--		,TransactionTypeCodeId
	--		,Quantity
	--		,Value
	--		,Quantity2
	--		,Value2
	--		,TransactionLetterId
	--		,LotSize
	--		From tra_TransactionDetails
	--		Where TransactionDetailsId = @inp_iTransactionDetailsId	
		

	--	SET @out_nReturnValue = 0
		RETURN @out_nReturnValue
	END	 TRY
	
	BEGIN CATCH	
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()	
		
		-- Return common error if required, otherwise specific error.		
		SET @out_nReturnValue =  dbo.uf_com_GetErrorCode(@ERR_TRADINGTRANSACTIONDETAILS_SAVE, ERROR_NUMBER())
		RETURN @out_nReturnValue
	END CATCH

END