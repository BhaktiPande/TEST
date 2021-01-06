IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_rul_ApplicableTradingPolicyDetails_OS')
DROP PROCEDURE [dbo].[st_rul_ApplicableTradingPolicyDetails_OS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[st_rul_ApplicableTradingPolicyDetails_OS]
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

		
		IF (@inp_iTransacationMasterId = 0)
		BEGIN
			SELECT @nTradingPolicyID = ISNULL(MAX(MapToId), 0)
			FROM vw_ApplicableTradingPolicyForUser_OS  WHERE UserInfoId = @inp_iUserInfoId
			
			IF @nTradingPolicyID = 0
			BEGIN
				SET @out_nReturnValue = @ERR_APPLICABLETRADINGPOLICY_NOTFOUND
				RETURN (@out_nReturnValue)				
			END
		END
		ELSE
		BEGIN
			SELECT @nTradingPolicyID = TradingPolicyId
			FROM tra_TransactionMaster_OS where TransactionMasterId = @inp_iTransacationMasterId AND UserInfoId = @inp_iUserInfoID
		END
		
		--IF(EXISTS(SELECT MapToId FROM vw_ApplicableTradingWindowEventOtherForUser ATWEOFU
		--	JOIN rul_TradingWindowEvent TWE ON ATWEOFU.MapToId = TWE.TradingWindowEventId
		--	WHERE ATWEOFU.UserInfoId = @inp_iUserInfoId AND TWE.WindowCloseDate <= dbo.uf_com_GetServerDate() 
		--		  AND  dbo.uf_com_GetServerDate() < TWE.WindowOpenDate 
		--		  AND TWE.TradingWindowStatusCodeId = @nTradingWindowStatusActive
		--		  ))
				 
		--BEGIN
		--	SET @nNonTradingPeriodFlag = 1
			
		--	SELECT  @dtWindowCloseFrom = TWE.WindowCloseDate,
		--			@dtWindowOpen = TWE.WindowOpenDate
		--	FROM vw_ApplicableTradingWindowEventOtherForUser ATWEOFU
		--	JOIN rul_TradingWindowEvent TWE ON ATWEOFU.MapToId = TWE.TradingWindowEventId
		--	WHERE ATWEOFU.UserInfoId = @inp_iUserInfoId AND TWE.WindowCloseDate <= dbo.uf_com_GetServerDate() 
		--		  AND  dbo.uf_com_GetServerDate() < TWE.WindowOpenDate 
		--		  AND TWE.TradingWindowStatusCodeId = @nTradingWindowStatusActive
		--END
		-- Check for Trading window event - Financial
		--IF(EXISTS(SELECT TradingWindowEventId FROM rul_TradingWindowEvent 
		--where WindowCloseDate <= dbo.uf_com_GetServerDate() AND dbo.uf_com_GetServerDate() < WindowOpenDate
		--AND EventTypeCodeId = @nTradingWindowEventTypeFinancialResult --and TradingWindowStatusCodeId = @nTradingWindowStatusActive
		--))
		--BEGIN
		--	SET @nNonTradingPeriodFlag = 1
			
		--	SELECT @dtWindowCloseFrom = WindowCloseDate,@dtWindowOpen = WindowOpenDate 
		--	FROM rul_TradingWindowEvent 
		--	WHERE WindowCloseDate <= dbo.uf_com_GetServerDate() AND dbo.uf_com_GetServerDate() < WindowOpenDate
		--	AND EventTypeCodeId = @nTradingWindowEventTypeFinancialResult --and TradingWindowStatusCodeId = @nTradingWindowStatusActive
			
		--END
		
		-- check if need to use security pool for not 
		IF EXISTS(SELECT * FROM rul_TradingPolicyForTransactionMode_OS 
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
		FROM rul_TradingPolicy_OS 
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

