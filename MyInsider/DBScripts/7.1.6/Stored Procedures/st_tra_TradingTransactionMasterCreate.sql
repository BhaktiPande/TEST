IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_tra_TradingTransactionMasterCreate')
DROP PROCEDURE [dbo].[st_tra_TradingTransactionMasterCreate]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Create and fetch TradingTransaction Master details

Returns:		0, if Success.
				
Created by:		Amar
Created on:		07-May-2015

Modification History:
Modified By		Modified On		Description
Arundhati		14-May-2015		Procedure to update status to Confirm is called.
Amar			16-May-2015		Call to view to fetch trading policy 
Ashish			19-May-2015		Change the type of @inp_sPreclearanceRequestId from INT to BIGINT
Amar			29-May-2015		Added update for no holding flag
Arundhati		30-May-2015		Condition for checking Trading policy defined for user is corrected
Arundhati		11-Jun-2015		Parameter @inp_dtHCpByCOSubmission is added
Amar            17-Jun-2015		Fix for initial disclosure to not check trading policy id. 
								Also added code to delete the Transaction details in case no holding flag is set
Amar            25-Jun-2015		Fix to not check for trading policy for period-end disclosure.
Amar			03-Jun-2015		Added check before updating transaction master status, if transaction details are not available returns error code.
Tushar			20-Jul-2015		Add @out_nDisclosureCompletedFlag Input Param for After completing the entire procedure of Initial 
								Disclosure, system should give a success message saying "Initial Disclosure process completed successfully".
Amar			21-Jul-2015		Added transaction details document upload check to verify whether the document is been uploaded before updating the status to document upload.
Amar			29-Jul-2015     Shifting the vw_ApplicableTradingPolicyForUser call inside if as previously it was required outside for one of the condition in if. As the condition for policy id is
                                removed so this call is shifted inside where the insert script needs the policy id.
Arundahti		05-Aug-2015		Changes related to Partial Trading
Raghvendra		12-Oct-2015		Added change to call the overriden  st_tra_TradingTransactionMasterCreateOverride procedure with parameters for executing the last select
								and for the TransactionMasterid to be set to outparameter.
Parag 			04-May-2016		Made change to auto submit transcation - call auto submit stored procedure
								NOTE - Remove commented code because this code is move to another stored procedure
AniketS			2-Jun-2016		Added new parameter for UPSI declaration on Continuous Disclosures page(YES BANK customization)

Usage:
EXEC [st_tra_TradingTransactionMasterCreate] 1
-------------------------------------------------------------------------------------------------*/


CREATE PROCEDURE [dbo].[st_tra_TradingTransactionMasterCreate]
	@inp_sTransactionMasterId		BIGINT,
	@inp_sPreclearanceRequestId		BIGINT = null,
	@inp_iUserInfoId				INT = null,
	@inp_iDisclosureTypeCodeId		INT = null,
	@inp_iTransactionStatusCodeId	INT = null,
	@inp_sNoHoldingFlag				bit = null,
	@inp_iTradingPolicyId			INT = null,
	@inp_dtPeriodEndDate			DATETIME = null,
	@inp_bPartiallyTradedFlag		bit = null,
	@inp_bSoftCopyReq				bit = null,
	@inp_bHardCopyReq				bit = null,
	@inp_dtHCpByCOSubmission		DATETIME = null,
	@inp_nUserId					INT,
	
	--New parameter added on 2-Jun-2016(YES BANK customization)
	@inp_SeekDeclarationFromEmpRegPossessionOfUPSIFlag					BIT = NULL,
	@inp_CDDuringPE														BIT=NULL,
	
	@out_nDisclosureCompletedFlag	INT = 0 OUTPUT,
	@out_nReturnValue				INT = 0 OUTPUT,
	@out_nSQLErrCode				INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage				NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
AS
BEGIN

	DECLARE @ERR_TRANSACTIONMASTER_SAVE INT = 16092
	
	DECLARE @bIsMassUpload BIT = 0 -- set flag for mass upload
	
	BEGIN TRY
	
		EXEC st_tra_TradingTransactionMasterCreate_Override 
				@inp_sTransactionMasterId, 
				@inp_sPreclearanceRequestId, 
				@inp_iUserInfoId, 
				@inp_iDisclosureTypeCodeId, 
				@inp_iTransactionStatusCodeId, 
				@inp_sNoHoldingFlag, 
				@inp_iTradingPolicyId, 
				@inp_dtPeriodEndDate, 
				@inp_bPartiallyTradedFlag, 
				@inp_bSoftCopyReq, 
				@inp_bHardCopyReq, 
				@inp_dtHCpByCOSubmission, 
				@inp_nUserId,
				'',
				@inp_SeekDeclarationFromEmpRegPossessionOfUPSIFlag,
				@inp_CDDuringPE,
				@inp_sTransactionMasterId out, 
				@out_nDisclosureCompletedFlag OUTPUT, 
				@out_nReturnValue OUTPUT, 
				@out_nSQLErrCode OUTPUT, 
				@out_sSQLErrMessage OUTPUT	
		
		
		IF(@out_nReturnValue = 0)
		BEGIN
			-- auto submit transcation 
			EXEC st_tra_TradingTransaction_Auto_Submit
					@inp_sTransactionMasterId, 
					@bIsMassUpload,
					@out_nReturnValue OUTPUT, 
					@out_nSQLErrCode OUTPUT, 
					@out_sSQLErrMessage OUTPUT	
		END
		
		
		RETURN @out_nReturnValue
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()
		
		-- Return common error if required, otherwise specific error.		
		SET @out_nReturnValue  = dbo.uf_com_GetErrorCode(@ERR_TRANSACTIONMASTER_SAVE, ERROR_NUMBER())
		RETURN @out_nReturnValue		
	END CATCH
END