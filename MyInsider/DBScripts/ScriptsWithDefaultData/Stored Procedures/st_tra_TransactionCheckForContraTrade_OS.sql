IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_tra_TransactionCheckForContraTrade_OS')
DROP PROCEDURE [dbo].[st_tra_TransactionCheckForContraTrade_OS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
Description:	Check wheather contra trade is present or not

Returns:		0, if Success.
				
Created by:		Priyanka
Created on:		19-Feb-2019

Usage:
EXEC st_tra_TransactionCheckForContraTrade_OS 1
-------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[st_tra_TransactionCheckForContraTrade_OS]
	@inp_iUserInfoID									INT,						-- Id of the PreclearanceRequest whose details are to be fetched.
	@inp_iTransactionTypeCodeID							INT,						--Transaction Type
	@inp_iSecurityTypeCodeId							INT,
	@inp_iModeOfAcquisitionCodeId                       INT,
	@inp_iDMATDetailsID									INT,
	@inp_iCompanyID                                     INT,
	@out_bIsContraTrade									BIT = 0 OUTPUT,
	@out_dtIsContraTradeTillDate					    DATETIME OUTPUT,
	@out_nReturnValue									INT = 0 OUTPUT,
	@out_nSQLErrCode									INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage									NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
	
AS
BEGIN
	--Declare Variable
	DECLARE @ERR_TRANSACTIONCHECKFORCONTRATRADE			INT = 17342
	DECLARE @ERR_UPDATEEXCERCISEBALANCEPOOL				INT
	DECLARE @bIsContraTrade								BIT = 1
	DECLARE @nContinuousDisclosureType					INT = 147002
	DECLARE @nPeriodEndDisclosureType					INT = 147003
	DECLARE @nBuyTransactionType						INT = 143001
	DECLARE @nSellTransactionType						INT = 143002
	DECLARE @nCashExciseTransactionType					INT = 143003
	DECLARE @nCashlessAllTransactionType				INT = 143004
	DECLARE @nCashlessPartialTransactionType			INT = 143005
	DECLARE @nPledgeTransactionType                     INT = 143006
	DECLARE @nPledgeRevokeTransactionType               INT = 143007
	DECLARE @nPledgeInvokeTransactionType               INT = 143008	
	
	DECLARE @nTradingPolicyID							INT = 0
	DECLARE @nGenContraTradeNotAllowedLimit				INT	= 0
	
	DECLARE @nGenCashAndCashlessPartialExciseOptionForContraTrade	INT
	DECLARE @nESOPFirstOptionThenOther								INT = 172001
	DECLARE @nOtherFirstThenESOP									INT = 172002
	DECLARE @nUserSelectionRule										INT = 172003
	
	DECLARE @nESOPPoolQty												DECIMAL(10, 0)
	DECLARE @nOtherPoolQty												DECIMAL(10, 0)
	
	DECLARE @nESOSplitPQty											DECIMAL(10, 0) = 0
	DECLARE @nOtherSplitQty											DECIMAL(10, 0) = 0
	
	DECLARE @bESOPExcerseOptionQtyFlag		BIT
	DECLARE @bOtherESOPExcerseOptionFlag	BIT
	
	SET @ERR_UPDATEEXCERCISEBALANCEPOOL		= 16327
	
	DECLARE @nPreClearanceStatus_Rejected	INT = 144003
	DECLARE @nPreClearanceStatus_Approve	INT = 144002
	
	
	DECLARE @nContraTradeOption				INT
	DECLARE @nContraTradeGeneralOption		INT = 175001
	DECLARE @nContraTradeQuantityBase		INT = 175002
	
	DECLARE @nContraTradeBasedOn INT
	DECLARE @nContraTradeBasedOnAllSecurityType		INT = 177001
	DECLARE @nContraTradeBasedOnIndivisualSecurityType		INT = 177002
	
	DECLARE @nMapToTypeTradingPolicyExceptionforTransactionMode INT = 132008
	DECLARE @nMapToTypeContraTradeBasedOn INT						= 132013
	
	DECLARE @dtContraTradeTransactionDetailsID BIGINT
	DECLARE @dtContraTradeTillDate DATETIME
	
	DECLARE @nContraTrade_No         INT = 506002
	DECLARE @bIsContraTradeSettings  BIT = 1
	DECLARE @nIndividualSecurityType INT = 177002
	
	BEGIN TRY
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;
		
		--Create Temp Table for Fetching applicable Transaction Type for That policy which ar exempted for disclosure
		CREATE TABLE #temp(TransactionType INT)
		CREATE TABLE #tempContraTradeSecurityType(SecurityTypeCodeID INT)
		CREATE TABLE #tempTransactionTypeSettings(TransactionType INT, ModeOfAcquisitionCodeId INT, SecurityTypeCodeId INT)
		--Get Applicible Trading policy for that user
		SELECT @nTradingPolicyID = ISNULL(MAX(MapToId), 0)
		FROM vw_ApplicableTradingPolicyForUser_OS  WHERE UserInfoId = @inp_iUserInfoID
		
		-- Set Value For Contra Trade Not Allowed Limit
		SELECT @nGenContraTradeNotAllowedLimit = GenContraTradeNotAllowedLimit 
			   ,@nGenCashAndCashlessPartialExciseOptionForContraTrade = GenCashAndCashlessPartialExciseOptionForContraTrade
			   ,@nContraTradeBasedOn = ContraTradeBasedOn 
		FROM rul_TradingPolicy_OS 
		WHERE TradingPolicyId = @nTradingPolicyID
	
		--Insert Exempted Transaction In Temp Table
		--For OS,rul_TradingPolicyForTransactionMode_OS is empty
		INSERT INTO #temp 
		SELECT TransactionModeCodeId 
		FROM rul_TradingPolicyForTransactionMode_OS 
		WHERE TradingPolicyId = @nTradingPolicyID AND MapToTypeCodeId = @nMapToTypeTradingPolicyExceptionforTransactionMode
		
		-- Insert contra Trade security
		INSERT INTO #tempContraTradeSecurityType
		SELECT SecurityTypeCodeID 
		FROM rul_TradingPolicyForSecurityMode_OS 
		WHERE TradingPolicyId = @nTradingPolicyID AND MapToTypeCodeId = @nMapToTypeContraTradeBasedOn
		
		INSERT INTO #tempTransactionTypeSettings
		SELECT DISTINCT TRANS_TYPE_CODE_ID, MODE_OF_ACQUIS_CODE_ID, SECURITY_TYPE_CODE_ID 
		FROM tra_TransactionTypeSettings_OS WHERE CONTRA_TRADE_CODE_ID = @nContraTrade_No AND security_type_code_id = CASE WHEN @nContraTradeBasedOn = @nIndividualSecurityType THEN @inp_iSecurityTypeCodeId ELSE security_type_code_id END
		
			-- Declare the return variable here
		DECLARE @tmpOppositeTranasction TABLE (TransactionCodeId INT, OppositeTransactionCodeId INT)
		DECLARE @tmpExceptionTransactionCodes TABLE(TransactionCodeId INT)
		
		INSERT INTO @tmpOppositeTranasction (TransactionCodeId, OppositeTransactionCodeId)
		SELECT * FROM tra_OppositeTranasctionCodes_OS
		
		
		DELETE OppTra
		FROM @tmpOppositeTranasction OppTra JOIN #temp ExcTra 
		ON ExcTra.TransactionType IN (OppTra.TransactionCodeId, OppTra.OppositeTransactionCodeId)

		-- Fetch Contra Trade Option
		SELECT @nContraTradeOption = ContraTradeOption
		FROM mst_Company WHERE IsImplementing = 1
		
		--Check Wheathe rtransaction type in exempt case then allow trade else check wheathe condition for contra trade 
	    SELECT @bIsContraTradeSettings = [dbo].[uf_tra_CheckForContraTrade_OS](@inp_iTransactionTypeCodeID,@inp_iModeOfAcquisitionCodeId,@inp_iSecurityTypeCodeId)
	    
		IF((@bIsContraTradeSettings = 1) OR NOT EXISTS(SELECT SecurityTypeCodeID FROM #tempContraTradeSecurityType WHERE SecurityTypeCodeID = @inp_iSecurityTypeCodeId))
		BEGIN
			SET @bIsContraTrade = 0
		END
		ELSE IF(@inp_iTransactionTypeCodeID <> @nCashlessAllTransactionType AND 
				@inp_iTransactionTypeCodeID <> @nCashlessPartialTransactionType)
		BEGIN
			/*
				If Transaction Type Buy
				1. Check transaction in Continuous Disclosure Type & Period End Disclosure Type
				2. If Preclearance is Taken in Prior Days for Contra Trade Case and doesnot 
				   enter details for it but also consider for contra trade case.
				3. Exmpted Transaction doesnot consider
				4. Transaction Type <> Cash Excise, Buy, Pledge OR Pledge Revoke,
				5. Not Traded Ignore
			*/
			IF (@inp_iTransactionTypeCodeID = @nBuyTransactionType)
			BEGIN
			
				SELECT TOP 1  @dtContraTradeTransactionDetailsID =  CASE WHEN TD.DateOfAcquisition IS NOT NULL THEN TD.TransactionDetailsId ELSE PR.PreclearanceRequestId END
				,@dtContraTradeTillDate =  CASE WHEN TD.DateOfAcquisition IS NOT NULL THEN TD.DateOfAcquisition ELSE PR.CreatedOn END
				FROM tra_TransactionMaster_OS TM 
				LEFT JOIN tra_TransactionDetails_OS TD  ON TM.TransactionMasterId = TD.TransactionMasterId
				LEFT JOIN tra_PreclearanceRequest_NonImplementationCompany PR ON TM.PreclearanceRequestId = PR.PreclearanceRequestId
				WHERE TM.UserInfoId = @inp_iUserInfoID  
					  AND TM.DisclosureTypeCodeId IN(@nContinuousDisclosureType,@nPeriodEndDisclosureType) 
					  AND ((ABS(DATEDIFF(DAY,dbo.uf_com_GetServerDate(),PR.CreatedOn)) <= @nGenContraTradeNotAllowedLimit) 
							OR (ABS(DATEDIFF(DAY,dbo.uf_com_GetServerDate(),TD.DateOfAcquisition)) <= @nGenContraTradeNotAllowedLimit )) 					 
					  AND (NOT EXISTS(select 1 from #tempTransactionTypeSettings TTS where (PR.TransactionTypeCodeId = TTS.TransactionType and PR.ModeOfAcquisitionCodeId = TTS.ModeOfAcquisitionCodeId and PR.SecurityTypeCodeId = TTS.SecurityTypeCodeId) OR (TD.TransactionTypeCodeId = TTS.TransactionType and TD.ModeOfAcquisitionCodeId = TTS.ModeOfAcquisitionCodeId and TD.SecurityTypeCodeId = TTS.SecurityTypeCodeId)))
					  AND ((PR.TransactionTypeCodeId NOT IN(@nBuyTransactionType,@nPledgeTransactionType,@nPledgeRevokeTransactionType)) 
							OR (TD.TransactionTypeCodeId NOT IN(@nBuyTransactionType,@nPledgeTransactionType,@nPledgeRevokeTransactionType)))
					  AND ((PR.IsPartiallyTraded <> 2 AND PR.PreclearanceStatusCodeId <> @nPreClearanceStatus_Rejected)
							OR TM.PreclearanceRequestId IS NULL AND TD.TransactionDetailsId IS NOT NULL)
					  AND ((@nContraTradeBasedOn = @nContraTradeBasedOnAllSecurityType AND((PR.SecurityTypeCodeId IN(SELECT * FROM #tempContraTradeSecurityType))
					        OR (TD.SecurityTypeCodeId IN(SELECT * FROM #tempContraTradeSecurityType))))
					        OR @nContraTradeBasedOn = @nContraTradeBasedOnIndivisualSecurityType 
					        AND((PR.SecurityTypeCodeId = @inp_iSecurityTypeCodeId) OR TD.SecurityTypeCodeId = @inp_iSecurityTypeCodeId))
					  AND PR.CompanyId = @inp_iCompanyID
						    ORDER BY CASE WHEN TD.DateOfAcquisition IS NOT NULL THEN TD.DateOfAcquisition ELSE PR.CreatedOn END DESC
				
				IF(@dtContraTradeTransactionDetailsID IS NOT NULL AND @dtContraTradeTransactionDetailsID > 0)
				BEGIN
					SET @bIsContraTrade = 1
					SET @out_dtIsContraTradeTillDate = DATEADD(DAY,@nGenContraTradeNotAllowedLimit,@dtContraTradeTillDate)
				END
				ELSE
				BEGIN
					SET @bIsContraTrade = 0
				END
			END
			/*
				If Transaction Type Sell
				1. Check transaction in Continuous Disclosure Type & Period End Disclosure Type
				2. If Preclearance is Taken in Prior Days for Contra Trade Case and doesnot 
				   enter details for it but also consider for contra trade case.
				3. Exmpted Transaction doesnot consider
				4. Transaction Type <> Sell,Pledge, Pledge Revoke Or Pledge Invoke
				5. Not Traded Ignore
			*/
			ELSE IF(@inp_iTransactionTypeCodeID = @nSellTransactionType OR @inp_iTransactionTypeCodeID = @nPledgeInvokeTransactionType)
			BEGIN
				IF(@nContraTradeOption = @nContraTradeQuantityBase)
				BEGIN
						SELECT TOP 1 @dtContraTradeTransactionDetailsID = CASE WHEN TD.DateOfAcquisition IS NOT NULL THEN TD.TransactionDetailsId ELSE PR.PreclearanceRequestId END
						,@dtContraTradeTillDate =  CASE WHEN TD.DateOfAcquisition IS NOT NULL THEN TD.DateOfAcquisition ELSE PR.CreatedOn END
										FROM tra_TransactionMaster_OS TM 
										LEFT JOIN tra_TransactionDetails_OS TD  ON TM.TransactionMasterId = TD.TransactionMasterId
										LEFT JOIN tra_PreclearanceRequest_NonImplementationCompany PR ON TM.PreclearanceRequestId = PR.PreclearanceRequestId
							  WHERE TM.UserInfoId = @inp_iUserInfoID  
							  AND PR.CompanyId = @inp_iCompanyID
							  AND TM.DisclosureTypeCodeId IN(@nContinuousDisclosureType,@nPeriodEndDisclosureType) 
							  AND ((ABS(DATEDIFF(DAY,dbo.uf_com_GetServerDate(),PR.CreatedOn))<= @nGenContraTradeNotAllowedLimit) 
									OR (ABS(DATEDIFF(DAY,dbo.uf_com_GetServerDate(),TD.DateOfAcquisition)) <= @nGenContraTradeNotAllowedLimit) )							  
							  AND (NOT EXISTS(select 1 from #tempTransactionTypeSettings TTS where (PR.TransactionTypeCodeId = TTS.TransactionType and PR.ModeOfAcquisitionCodeId = TTS.ModeOfAcquisitionCodeId and PR.SecurityTypeCodeId = TTS.SecurityTypeCodeId) OR (TD.TransactionTypeCodeId = TTS.TransactionType and TD.ModeOfAcquisitionCodeId = TTS.ModeOfAcquisitionCodeId and TD.SecurityTypeCodeId = TTS.SecurityTypeCodeId)))
							  AND ((PR.TransactionTypeCodeId NOT IN(@nSellTransactionType,@nPledgeTransactionType,@nPledgeRevokeTransactionType,@nPledgeInvokeTransactionType)) 
									OR (TD.TransactionTypeCodeId NOT IN(@nSellTransactionType,@nPledgeTransactionType,@nPledgeRevokeTransactionType,@nPledgeInvokeTransactionType)))
							  AND ((PR.IsPartiallyTraded <> 2 AND PR.PreclearanceStatusCodeId <> @nPreClearanceStatus_Rejected)
								   OR TM.PreclearanceRequestId IS NULL AND TD.TransactionDetailsId IS NOT NULL)
							 AND ((@nContraTradeBasedOn = @nContraTradeBasedOnAllSecurityType AND((PR.SecurityTypeCodeId IN(SELECT * FROM #tempContraTradeSecurityType))
									OR (TD.SecurityTypeCodeId IN(SELECT * FROM #tempContraTradeSecurityType))))
									OR @nContraTradeBasedOn = @nContraTradeBasedOnIndivisualSecurityType 
									AND((PR.SecurityTypeCodeId = @inp_iSecurityTypeCodeId) OR TD.SecurityTypeCodeId = @inp_iSecurityTypeCodeId))
						ORDER BY CASE WHEN TD.DateOfAcquisition IS NOT NULL THEN TD.DateOfAcquisition ELSE PR.CreatedOn END DESC
						
						IF(@dtContraTradeTransactionDetailsID IS NOT NULL AND @dtContraTradeTransactionDetailsID > 0)
						BEGIN
							SET @bIsContraTrade = 1
							SET @out_dtIsContraTradeTillDate = DATEADD(DAY,@nGenContraTradeNotAllowedLimit,@dtContraTradeTillDate)
						END
						ELSE
						BEGIN
							SET @bIsContraTrade = 0
						END
				 -- check existing flag value, if contra trade flag is false then check on historic data if there is contra trade or not 
				END
				ELSE IF(@nContraTradeOption = @nContraTradeGeneralOption)
				BEGIN
					SELECT TOP 1 @dtContraTradeTransactionDetailsID = CASE WHEN TD.DateOfAcquisition IS NOT NULL THEN TD.TransactionDetailsId ELSE PR.PreclearanceRequestId END
					,@dtContraTradeTillDate =  CASE WHEN TD.DateOfAcquisition IS NOT NULL THEN TD.DateOfAcquisition ELSE PR.CreatedOn END
					FROM tra_TransactionMaster_OS TM 
					LEFT JOIN tra_TransactionDetails_OS TD  ON TM.TransactionMasterId = TD.TransactionMasterId
					LEFT JOIN tra_PreclearanceRequest_NonImplementationCompany PR ON TM.PreclearanceRequestId = PR.PreclearanceRequestId
					WHERE TM.UserInfoId = @inp_iUserInfoID  
					AND PR.CompanyId = @inp_iCompanyID
						  AND TM.DisclosureTypeCodeId IN(@nContinuousDisclosureType,@nPeriodEndDisclosureType) 
						  AND ((ABS(DATEDIFF(DAY,dbo.uf_com_GetServerDate(),PR.CreatedOn)) <= @nGenContraTradeNotAllowedLimit) 
								OR (ABS(DATEDIFF(DAY,dbo.uf_com_GetServerDate(),TD.DateOfAcquisition)) <= @nGenContraTradeNotAllowedLimit )) 				
						  AND (NOT EXISTS(select 1 from #tempTransactionTypeSettings TTS where (PR.TransactionTypeCodeId = TTS.TransactionType and PR.ModeOfAcquisitionCodeId = TTS.ModeOfAcquisitionCodeId and PR.SecurityTypeCodeId = TTS.SecurityTypeCodeId) OR (TD.TransactionTypeCodeId = TTS.TransactionType and TD.ModeOfAcquisitionCodeId = TTS.ModeOfAcquisitionCodeId and TD.SecurityTypeCodeId = TTS.SecurityTypeCodeId)))
						  AND ((PR.TransactionTypeCodeId NOT IN(@nSellTransactionType,@nPledgeTransactionType,@nPledgeRevokeTransactionType,@nPledgeInvokeTransactionType)) 
								OR (TD.TransactionTypeCodeId NOT IN(@nSellTransactionType,@nPledgeTransactionType,@nPledgeRevokeTransactionType,@nPledgeInvokeTransactionType)))
						  AND ((PR.IsPartiallyTraded <> 2 AND PR.PreclearanceStatusCodeId <> @nPreClearanceStatus_Rejected)
								OR TM.PreclearanceRequestId IS NULL AND TD.TransactionDetailsId IS NOT NULL)
						  AND ((@nContraTradeBasedOn = @nContraTradeBasedOnAllSecurityType AND((PR.SecurityTypeCodeId IN(SELECT * FROM #tempContraTradeSecurityType))
								OR (TD.SecurityTypeCodeId IN(SELECT * FROM #tempContraTradeSecurityType))))
								OR @nContraTradeBasedOn = @nContraTradeBasedOnIndivisualSecurityType 
								AND((PR.SecurityTypeCodeId = @inp_iSecurityTypeCodeId) OR TD.SecurityTypeCodeId = @inp_iSecurityTypeCodeId))
					ORDER BY CASE WHEN TD.DateOfAcquisition IS NOT NULL THEN TD.DateOfAcquisition ELSE PR.CreatedOn END DESC

				IF(@dtContraTradeTransactionDetailsID IS NOT NULL AND @dtContraTradeTransactionDetailsID > 0)
				BEGIN
					SET @out_dtIsContraTradeTillDate = DATEADD(DAY,@nGenContraTradeNotAllowedLimit,@dtContraTradeTillDate)
					SET @bIsContraTrade = 1
				END
				ELSE
				BEGIN
					SET @bIsContraTrade = 0
				END
				END
			END
			
		END
		--SET @bIsContraTrade = 0
		--Set Contra Trade Value
		SELECT @out_bIsContraTrade = @bIsContraTrade
		
		SET @out_nReturnValue = 0
		RETURN @out_nReturnValue
		
		-- Drop Temp Table.
		DROP TABLE #temp
		
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()
		
		-- Return common error if required, otherwise specific error.		
		SET @out_nReturnValue  = dbo.uf_com_GetErrorCode(@ERR_TRANSACTIONCHECKFORCONTRATRADE, ERROR_NUMBER())
		
		RETURN @out_nReturnValue
		
	END CATCH
END

