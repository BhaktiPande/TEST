IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_rul_ApplicableTradingPolicyDetails')
DROP PROCEDURE [dbo].[st_rul_ApplicableTradingPolicyDetails]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
Description:	Get the Applicable Policy Details Insider/Employee

Returns:		0, if Success.
				
Created by:		Tushar Tekawade
Created on:		13-May-2015

Modification History:
Modified By		Modified On		Description
Tushar			01-Jun-2015     Change logic for getting applicable trading policy. 
Tushar			02-Jul-2015		Return Column PreClrSeekDeclarationForUPSIFlag,PreClrUPSIDeclaration
Tushar			03-Jul-2015		Return Column NonTradingPeriodFlag 
Tushar			08-Jul-2015		Retuen WindowCloseDate and WindowOpenDate
Tushar			17-Jul-2015		Return GenContraTradeNotAllowedLimit
Tushar			31-Oct-2015		Financial Year block out period remove event active status condition.
Tushar			03-Nov-2015		Trading Window Other event only activated event listed out.
Parag			24-Nov-2015		Made change to fetch option for contra trade 
								Also made change to fetch details for TP attached to transaction master 
									if transcation master id is set else fetch current TP applicable
Parag			24-Dec-2015		for input transaction master id change data type to BIGINT
Tushar			28-Jun-2016		Windows Open Date minus 1 days for only considering to window closing period.
Raghvendra		07-Sep-2016		Changed the GETDATE() call with function dbo.uf_com_GetServerDate(). This function will return the date to be used as server date.

Usage:
EXEC st_tra_PreclearanceRequestDetails 1
-------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[st_rul_ApplicableTradingPolicyDetails]
	@inp_iUserInfoID									INT,						-- Id of the PreclearanceRequest whose details are to be fetched.
	@inp_iTransacationMasterId							BIGINT = 0,					-- transanction master id .
	@out_nReturnValue									INT = 0 OUTPUT,
	@out_nSQLErrCode									INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage									NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
	
AS
BEGIN
	DECLARE @ERR_APPLICABLETRADINGPOLICY_DETAILS			INT
	DECLARE @ERR_APPLICABLETRADINGPOLICY_NOTFOUND			INT
	DECLARE @nTradingPolicyID								INT
	DECLARE @nPreClrTradeDiscloLimit						INT
	DECLARE @nTradingWindowEventTypeFinancialResult			INT
	DECLARE @dtWindowCloseFrom								DATETIME
	DECLARE @dtWindowOpen									DATETIME
	
	DECLARE @bUseExerciseSecurityPool						BIT = 0
	DECLARE @nTransactionMode_MapToTypeCode_Preclearnace	INT = 132004
	
	DECLARE @nTransactionMode_Buy							INT = 143001
	DECLARE @nTransactionMode_Sell							INT = 143002
	DECLARE @nTransactionMode_Cash_Exercise					INT = 143003
	DECLARE @nTranscationMode_Cashless_Partial				INT = 143005

	BEGIN TRY
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;

		DECLARE @nTradingWindowStatusActive					INT
		DECLARE @nNonTradingPeriodFlag						BIT = 0 -- default value set
		
		--Initialize variables
		SELECT	@ERR_APPLICABLETRADINGPOLICY_NOTFOUND		= 16093,
				@ERR_APPLICABLETRADINGPOLICY_DETAILS		= 15377
				
		SET @nTradingWindowStatusActive = 131002
		SET @nTradingWindowEventTypeFinancialResult  = 126001

		--SELECT TOP 1 TP.TradingPolicyId,TP.PreClrTradeDiscloLimit 
		--FROM rul_TradingPolicy TP
		--JOIN vw_ApplicableTradingPolicyForUser ATPFU ON TP.TradingPolicyId = ATPFU.MapToId 
		--WHERE ATPFU.UserInfoId = @inp_iUserInfoID
		--ORDER BY MapToId DESC
		
		IF (@inp_iTransacationMasterId = 0)
		BEGIN
			SELECT @nTradingPolicyID = ISNULL(MAX(MapToId), 0)
			FROM vw_ApplicableTradingPolicyForUser  WHERE UserInfoId = @inp_iUserInfoId
			
			IF @nTradingPolicyID = 0
			BEGIN
				SET @out_nReturnValue = @ERR_APPLICABLETRADINGPOLICY_NOTFOUND
				RETURN (@out_nReturnValue)				
			END
		END
		ELSE
		BEGIN
			SELECT @nTradingPolicyID = TradingPolicyId
			FROM tra_TransactionMaster where TransactionMasterId = @inp_iTransacationMasterId AND UserInfoId = @inp_iUserInfoID
		END
		
		IF(EXISTS(SELECT MapToId FROM vw_ApplicableTradingWindowEventOtherForUser ATWEOFU
			JOIN rul_TradingWindowEvent TWE ON ATWEOFU.MapToId = TWE.TradingWindowEventId
			WHERE ATWEOFU.UserInfoId = @inp_iUserInfoId AND TWE.WindowCloseDate <= dbo.uf_com_GetServerDate() 
				  AND  dbo.uf_com_GetServerDate() < TWE.WindowOpenDate 
				  AND TWE.TradingWindowStatusCodeId = @nTradingWindowStatusActive
				  ))
				 
		BEGIN
			SET @nNonTradingPeriodFlag = 1
			
			SELECT  @dtWindowCloseFrom = TWE.WindowCloseDate,
					@dtWindowOpen = TWE.WindowOpenDate
			FROM vw_ApplicableTradingWindowEventOtherForUser ATWEOFU
			JOIN rul_TradingWindowEvent TWE ON ATWEOFU.MapToId = TWE.TradingWindowEventId
			WHERE ATWEOFU.UserInfoId = @inp_iUserInfoId AND TWE.WindowCloseDate <= dbo.uf_com_GetServerDate() 
				  AND  dbo.uf_com_GetServerDate() < TWE.WindowOpenDate 
				  AND TWE.TradingWindowStatusCodeId = @nTradingWindowStatusActive
		END
		-- Check for Trading window event - Financial
		IF(EXISTS(SELECT TradingWindowEventId FROM rul_TradingWindowEvent 
		where WindowCloseDate <= dbo.uf_com_GetServerDate() AND dbo.uf_com_GetServerDate() < WindowOpenDate
		AND EventTypeCodeId = @nTradingWindowEventTypeFinancialResult --and TradingWindowStatusCodeId = @nTradingWindowStatusActive
		))
		BEGIN
			SET @nNonTradingPeriodFlag = 1
			
			SELECT @dtWindowCloseFrom = WindowCloseDate,@dtWindowOpen = WindowOpenDate 
			FROM rul_TradingWindowEvent 
			WHERE WindowCloseDate <= dbo.uf_com_GetServerDate() AND dbo.uf_com_GetServerDate() < WindowOpenDate
			AND EventTypeCodeId = @nTradingWindowEventTypeFinancialResult --and TradingWindowStatusCodeId = @nTradingWindowStatusActive
			
		END
		
		-- check if need to use security pool for not 
		IF EXISTS(SELECT * FROM rul_TradingPolicyForTransactionMode 
						WHERE TradingPolicyId = @nTradingPolicyID
						AND MapToTypeCodeId = @nTransactionMode_MapToTypeCode_Preclearnace 
						AND TransactionModeCodeId in (@nTransactionMode_Buy, @nTransactionMode_Sell, @nTransactionMode_Cash_Exercise, @nTranscationMode_Cashless_Partial))
		BEGIN
			SET @bUseExerciseSecurityPool = 1
		END
		
		SELECT 
			TradingPolicyId,PreClrApprovalValidityLimit,PreClrSeekDeclarationForUPSIFlag,GenContraTradeNotAllowedLimit,
			PreClrUPSIDeclaration,@nNonTradingPeriodFlag AS NonTradingPeriodFlag,@dtWindowCloseFrom AS WindowCloseDate,
			DATEADD(DAY,-1,@dtWindowOpen) AS WindowOpenDate, 
			GenCashAndCashlessPartialExciseOptionForContraTrade, @bUseExerciseSecurityPool AS UseExerciseSecurityPool
		FROM rul_TradingPolicy 
		WHERE TradingPolicyId = @nTradingPolicyID

		SET @out_nReturnValue = 0
		RETURN @out_nReturnValue
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()
		
		-- Return common error if required, otherwise specific error.		
		SET @out_nReturnValue  = dbo.uf_com_GetErrorCode(@ERR_APPLICABLETRADINGPOLICY_DETAILS, ERROR_NUMBER())
		RETURN @out_nReturnValue		
	END CATCH
END

