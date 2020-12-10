IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_tra_PreclearanceRequestSave')
DROP PROCEDURE [dbo].[st_tra_PreclearanceRequestSave]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Saves the PreclearanceRequest details

Returns:		0, if Success.
				
Created by:		Tushar Tekawade
Created on:		21-Apr-2015
Modification History:
Modified By		Modified On		Description
Tushar			25-Apr-2015		Add Trading Policy ID in Table.
Tushar			14-May-2015		Add Call for Save Transaction Master st_tra_TradingTransactionMasterCreate procedure.
Tushar			15-May-2015		Add Error Code Number in procedure.
Tushar			18-May-2015		Add Code for Update Preclearance Status.
Tushar			19-May-2015		Chnages for new chnages for Security wise limits.
Tushar			27-May-2015		Add new column SecuritiesToBeTradedValue
Tushar			27-May-2015		Autoapprove condition change.
Tushar			29-May-2015		Autoapprove condition change check ApproveRequiredfor all Trade flag.
Tushar			29-May-2015		Add code for Update Not Trading Part.
Tushar			01-Jun-2015     Change logic for getting applicable trading policy. 
Tushar			02-Jun-2015     Change logic for getting applicable trading policy. 
Tushar			13-Jun-2015		Add Parameter @inp_dtHCpByCOSubmission is NULL WHILE call Create TradingTransactionMasterCreate.
Tushar			25-Jun-2015		Add condition for System should restrict user for Pre-Clearance Request for selected 
								transaction type during non-trading period.
Tushar			04-Jul-2015		Add Autoapprove case on Value of Shares
Tushar			08-Jul-2015		Change Query for autoapprove case.
Tushar			17-Jul-2015		1. Change Query for autoapprove case.
								2. Add Condition for Contra Trade Case.
Tushar			20-Jul-2015		Change Condition for Contra Trade Case.
Arundhati		12-Aug-2015		Changes related to Partial trading
Arundhati		28-Aug-2015		Changes for validation due to changes in trading policy
Arundhati		09-Sep-2015		Autoapprove flag value checked agains 1
Tushar			02-Nov-2015		Financial Year block out period remove event active status condition.
Parag			25-Nov-2015		Made change to save flag for which security pool should be use for per-clearance
Parag			27-Nov-2015		Made change to save security pool quantity distribution 
Parag			03-Dec-2015		Made change to call update exercise pool procedure with parameter
Parag			08-Dec-2015		Made change to use decimal instead of int for quantity field
Tushar			10-Dec-2015		Contra Trade check for Sell Transaction Type check ESOP and other Qty.
Tushar			11-Dec-2015		If Transaction Type Sell and security type shares then contra trade check on the basis of quantity.
								AND Transaction Type Sell and security type not shares then only check opposite transaction as old behaviour.
								for this pass secuirity type param for contra trade check
Tushar			08-Mar-2016		Change related to Selection of QTY Yes/No configuration. 
								(Based on contra trade functionality)
Tushar			28-Apr-2016		Change Pre clearance request message for contra trade.show Date and transaction type till in message.
Tushar			17-May-2016		1. Add New Column Display Sequential Number for Continuous Disclosure.
								2. For PNT/PNR:-When Transaction Submit Increment Above Column & save in table.
								3.For PCL:- When Pre clearance request raised Increment Above Column & save in table.
								4.For Display Rolling Number logic is as follows:-
									 A) If Pre clearance  Transaction is raised then show dIsplay number as "PCL + <DisplayRollingNumber>".
									 B) For continuous disclosure records for Insider show  "PNT"  before the transaction is submitted & after submission show "PNT +    	<DisplayRollingNumber>".                                                      
									 C) For continuous disclosure for employee non insider show  PNR before transaction is submitted and show "PNR + <DisplayRollingNumber>" after the transaction is submitted.

Tushar			14-Jun-2016		Changes for applying pool based validations for security types other than shares 
Tushar			05-Jul-2016		Update Security Type in Transaction master table while raising preclerance & Delete multiple transaction for partial trade case. 
Tushar			08-Aug-2016		Update Security Type in Transaction master table while not traded preclearace.
Parag			18-Aug-2016		Code merge with ESOP code
Tushar			03-Sep-2016		Change for maintaining DMAT wise pool and related validation.
Raghvendra		07-Sep-2016		Changed the GETDATE() call with function dbo.uf_com_GetServerDate(). This function will return the date to be used as server date.
Tushar			13-Sep-2016		Changes for FORM E generation and showing download link on page.
Tushar			25-Oct-2016		In AutoApprove case update approved by and Approve on fields.
Usage:
DECLARE @RC int
EXEC st_tra_PreclearanceRequestSave ,1
-------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[st_tra_PreclearanceRequestSave] 
	@inp_nPreclearanceRequestId					BIGINT,
	@inp_iPreclearanceRequestForCodeId			INT,
	@inp_iUserInfoId							INT,
	@inp_iUserInfoIdRelative					INT,
	@inp_iTransactionTypeCodeId					INT,
	@inp_iSecurityTypeCodeId					INT,
	@inp_dSecuritiesToBeTradedQty				DECIMAL(15,4),
	@inp_iPreclearanceStatusCodeId				INT,
	@inp_iCompanyId								INT,
	@inp_dProposedTradeRateRangeFrom			DECIMAL(15,4),
	@inp_dProposedTradeRateRangeTo				DECIMAL(15,4),
	@inp_iDMATDetailsID							INT,
	@inp_iReasonForNotTradingCodeId				INT,
	@inp_sReasonForNotTradingText				VARCHAR(30),
	@inp_nPreclearanceNotTakenFlag				BIT,
	@inp_sReasonForRejection					VARCHAR(200),
	@inp_dSecuritiesToBeTradedValue				DECIMAL(15,4),
	@inp_nUserId								INT,						-- Id of the user inserting/updating the PreclearanceRequest
	@inp_bESOPExcerciseOptionQtyFlag			BIT,
	@inp_bOtherESOPExcerciseOptionQtyFlag		BIT,
	@inp_iModeOfAcquisitionCodeId               INT,
	@inp_sReasonForApproval						VARCHAR(200),
	@inp_iReasonForApprovalCodeId				INT,
	@out_sContraTradeTillDate				    NVARCHAR(500) OUTPUT,
	@out_nReturnValue							INT = 0 OUTPUT,
	@out_nSQLErrCode							INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage							NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
AS
BEGIN

	DECLARE @ERR_PRECLEARANCEREQUEST_SAVE			INT
	DECLARE @ERR_PRECLEARANCEREQUEST_NOTFOUND		INT
	DECLARE @ERR_CONTRATRADEOCCURED					INT
	
	DECLARE @ERR_DOCUMENTUPLOADED					INT
	DECLARE @ERR_DETAILSFOUND						INT
	
	DECLARE @nTransactionMasterID					BIGINT
	DECLARE @nTradingPolicyID						INT
	DECLARE @nContinousDisclosureType				INT
	DECLARE @nDisclosureStatusNotConfirmed			INT
	DECLARE @nPreClrSingleTransTradeNoShares		INT
	DECLARE @nPreClrSingleTransTradeValueOfShares	INT
	DECLARE @nStExSubmitTradeDiscloAllTradeFlag		INT
	DECLARE @ERR_TRADINGPOLICY_NOTFOUND				INT
	
	DECLARE @nOtherFlag								BIT = 0 -- default value set
	DECLARE @nFinnancialFlag						BIT = 0 -- default value set
	DECLARE @ERR_PROHIBITNONTRADINGPERIOD			INT
	DECLARE @nTradingWindowStatusActive				INT
	DECLARE @nProhibitPreclearanceduringnontrading	INT
	DECLARE @nTradingWindowEventTypeFinancialResult	INT
	DECLARE @nTradingWindowEventTypeOther			INT
	DECLARE @nMapToTypePreclearance					INT
	
	DECLARE @bIsAutoApprove							INT = 0
	
	DECLARE @out_bIsContraTrade						BIT
	DECLARE @out_dtContraTradeTillDate				DATETIME
	DECLARE @nTmpRet INT = 0
	DECLARE @nIsPartiallyTradedFlag					INT
	DECLARE @nShowAddButtonFlag						INT
	DECLARE @nTransactionIdToBeRemoved				INT
	
	DECLARE @nExciseOptionForContraTrade INT 
	
	DECLARE @nPoolOption_ESOPExciseOptionFirstandThenOtherShares INT = 172001
	DECLARE @nPoolOption_OtherSharesFirstThenESOPExciseOption INT = 172002
	DECLARE @nPoolOption_UserSelectionOnPreClearanceAndTradeDetailsSubmission INT = 172003
	
	DECLARE @nESOPExcerciseOptionQty DECIMAL(15,4) = 0
	DECLARE @nOtherExcerciseOptionQty DECIMAL(15,4) = 0
	DECLARE @nPledgeOptionQty DECIMAL(15,4) = 0
	
	DECLARE @nSecurityType_Share INT = 139001
	
	DECLARE @nESOPQuanity_FromPool DECIMAL(15,4) = NULL
	DECLARE @nOtherQuantity_FromPool DECIMAL(15,4) = NULL
	
	DECLARE @nTransactionType_Buy INT = 143001
	DECLARE @nTransactionType_Sell INT = 143002
	DECLARE @nTransactionType_CashExercies INT = 143003
	DECLARE @nTransactionType_CashlessAll INT = 143004
	DECLARE @nTransactionType_CashlessPartail INT = 143005
	DECLARE @nTransactionType_Pledge INT = 143006
	DECLARE @nTransactionType_PledgeRevoke INT = 143007
	DECLARE @nTransactionType_PledgeInvoke INT = 143008
	
	DECLARE @nPreClearanceStatus_Approve INT = 144002
	DECLARE @nPreClearanceStatus_Reject INT = 144003
	
	DECLARE @nContraTradeOption INT
	DECLARE @nContraTradeQuantityBase INT = 175002
	
	DECLARE @RC INT
	
	DECLARE @nMaxDisplayRollingNumber BIGINT = 0
	DECLARE @imptpostshareqtycodeid INT
	--Impact on Post Share quantity
	DECLARE @nAdd INT = 505001
    DECLARE @nLess INT = 505002    
    DECLARE @nNo INT = 505004 
    
    DECLARE @nPreclearanceApprovedBy INT
    DECLARE @dtPreclearanceApprovedOn DATETIME
	
	BEGIN TRY
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;
		
		CREATE TABLE #temp(TransactionType INT)
		
		--Initialize variables
		SELECT	@ERR_PRECLEARANCEREQUEST_NOTFOUND	= 17096,
				@ERR_PRECLEARANCEREQUEST_SAVE		= 17099,
				@nContinousDisclosureType			= 147002,
				@nDisclosureStatusNotConfirmed		= 148002,
				@ERR_TRADINGPOLICY_NOTFOUND			= 16093,
				@ERR_PROHIBITNONTRADINGPERIOD		= 17326,
				@ERR_CONTRATRADEOCCURED				= 17343,
				@ERR_DOCUMENTUPLOADED				= 17357, -- Cannot submit reason for not trading, as details are not yet submitted for a transaction for which document is uploaded.
				@ERR_DETAILSFOUND					= 17358 -- Cannot submit reason for not trading, as details are entered but not yet submitted for a transaction.
				
		SET @nTradingWindowStatusActive = 131002
		SET @nProhibitPreclearanceduringnontrading = 132007
		SET @nTradingWindowEventTypeFinancialResult  = 126001
		SET @nTradingWindowEventTypeOther	= 126002
		SET @nMapToTypePreclearance = 132004
		-- This part for Check COntra Trade Case
		-- Start Here
		
		-- Fetch Contra Trade Option
		SELECT @nContraTradeOption = ContraTradeOption
		FROM mst_Company WHERE IsImplementing = 1
		
		IF @inp_nPreclearanceRequestId IS NULL OR @inp_nPreclearanceRequestId = 0
		BEGIN
			--Call Contra Trade check
			EXEC @nTmpRet = st_tra_TransactionCheckForContraTrade @inp_iUserInfoID, @inp_iTransactionTypeCodeID,@inp_iSecurityTypeCodeId,@inp_dSecuritiesToBeTradedQty,
							@inp_bESOPExcerciseOptionQtyFlag,@inp_bOtherESOPExcerciseOptionQtyFlag,@inp_iModeOfAcquisitionCodeId,@inp_iDMATDetailsID,@out_bIsContraTrade OUTPUT,@out_dtContraTradeTillDate OUTPUT,
							@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT, @out_sSQLErrMessage OUTPUT
		
			IF @out_nReturnValue <> 0
			BEGIN
				SET @out_nReturnValue = @out_nReturnValue --@ERR_TRANSACTIONMASTER_SAVE
				RETURN @out_nReturnValue
			END
			
			IF(@out_bIsContraTrade = 1)
			BEGIN
				SET @out_sContraTradeTillDate = (SELECT dbo.uf_rpt_FormatDateValue(@out_dtContraTradeTillDate,0))
				SET @out_nReturnValue = @ERR_CONTRATRADEOCCURED
				RETURN (@out_nReturnValue)	
			END
			--End Here
		END
		
		--Get Applicable Trading Policy	
		SELECT @nTradingPolicyID = ISNULL(MAX(MapToId), 0) 
		FROM vw_ApplicableTradingPolicyForUser  
		WHERE UserInfoId = @inp_iUserInfoId
		
		--Check If any applicable policy apply for that user if no then give error message
		IF @nTradingPolicyID = 0 AND (@inp_nPreclearanceRequestId IS NULL OR @inp_nPreclearanceRequestId = 0)
		BEGIN
			SET @out_nReturnValue = @ERR_TRADINGPOLICY_NOTFOUND
			RETURN (@out_nReturnValue)				
		END
		
		
		--Check Preclearance Trade Approve Required Flag		  
		SELECT 
			@nStExSubmitTradeDiscloAllTradeFlag =  PreClrTradesApprovalReqFlag,
			@nExciseOptionForContraTrade = GenCashAndCashlessPartialExciseOptionForContraTrade
		FROM rul_TradingPolicy 
		WHERE TradingPolicyId = @nTradingPolicyID
		
		IF @nStExSubmitTradeDiscloAllTradeFlag = 0
		BEGIN
			--Get Security Limit
			SELECT @nPreClrSingleTransTradeNoShares = TPSWL.NoOfShares,
				  @nPreClrSingleTransTradeValueOfShares = TPSWL.ValueOfShares
			FROM rul_TradingPolicySecuritywiseLimits TPSWL
			WHERE TPSWL.TradingPolicyId = @nTradingPolicyID and (SecurityTypeCodeId IS NULL OR SecurityTypeCodeId = @inp_iSecurityTypeCodeId) 
				  AND MapToTypeCodeId = @nMapToTypePreclearance
		END
		
		--If Preclearance Not Taken Case
		IF @inp_nPreclearanceNotTakenFlag = 0
		BEGIN
			--Save the PreclearanceRequest details
			IF @inp_nPreclearanceRequestId IS NULL OR @inp_nPreclearanceRequestId = 0
			BEGIN	
				/*
					Prohibited during Non Trading Period
				*/
				INSERT INTO #temp SELECT TransactionModeCodeId FROM rul_TradingPolicyForTransactionMode 
				WHERE MapToTypeCodeId = @nProhibitPreclearanceduringnontrading AND TradingPolicyId = @nTradingPolicyID
				
				IF(EXISTS(SELECT TransactionType from  #temp WHERE TransactionType = @inp_iTransactionTypeCodeId))
				BEGIN
					-- Check for Trading window event - Other
					IF(EXISTS(SELECT MapToId FROM vw_ApplicableTradingWindowEventOtherForUser ATWEOFU
						JOIN rul_TradingWindowEvent TWE ON ATWEOFU.MapToId = TWE.TradingWindowEventId
						WHERE ATWEOFU.UserInfoId = @inp_iUserInfoId AND TWE.WindowCloseDate <= dbo.uf_com_GetServerDate() 
							  AND  dbo.uf_com_GetServerDate() < TWE.WindowOpenDate 
							  AND TWE.TradingWindowStatusCodeId = @nTradingWindowStatusActive))
							 
					BEGIN
						SET @nOtherFlag = 1
					END
					-- Check for Trading window event - Financial
					IF(EXISTS(SELECT TradingWindowEventId FROM rul_TradingWindowEvent 
					where WindowCloseDate <= dbo.uf_com_GetServerDate() AND dbo.uf_com_GetServerDate() < WindowOpenDate
					AND EventTypeCodeId = @nTradingWindowEventTypeFinancialResult --and TradingWindowStatusCodeId = @nTradingWindowStatusActive
					))
					BEGIN
						SET @nFinnancialFlag = 1
					END
					
					IF(@nOtherFlag=1 OR @nFinnancialFlag = 1)
					BEGIN
						SET @out_nReturnValue = @ERR_PROHIBITNONTRADINGPERIOD
						RETURN (@out_nReturnValue)	
					END
					
				END
					
			
						
					
					--IF (@nStExSubmitTradeDiscloAllTradeFlag = 0 AND 
					--(@nPreClrSingleTransTradeNoShares IS NULL OR @nPreClrSingleTransTradeNoShares > @inp_dSecuritiesToBeTradedQty)) 
					--BEGIN
					--	SET @inp_iPreclearanceStatusCodeId = 144002
					--END
					
					/*
					IF (@nStExSubmitTradeDiscloAllTradeFlag = 1 OR 
						(@nPreClrSingleTransTradeNoShares < @inp_dSecuritiesToBeTradedQty) OR
						(@nPreClrSingleTransTradeValueOfShares < @inp_dSecuritiesToBeTradedValue))
					BEGIN
						SET @bIsAutoApprove = 1
					END	
					*/
					-- Perform other validation checks
					EXEC st_tra_PreclearanceRequestSaveValidations @inp_nPreclearanceRequestId, @nTradingPolicyID, @inp_iUserInfoId, 
										@inp_iTransactionTypeCodeId, @inp_iSecurityTypeCodeId, @inp_dSecuritiesToBeTradedQty,
										@inp_iPreclearanceStatusCodeId, @inp_dProposedTradeRateRangeFrom, @inp_dProposedTradeRateRangeTo,
										@inp_dSecuritiesToBeTradedValue, @inp_bESOPExcerciseOptionQtyFlag, @inp_bOtherESOPExcerciseOptionQtyFlag,@nContraTradeOption, @inp_iModeOfAcquisitionCodeId,@inp_iDMATDetailsID,
										@bIsAutoApprove OUTPUT, @out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT,
										@out_sSQLErrMessage OUTPUT
																				
					IF @out_nReturnValue <> 0
					BEGIN
						RETURN
					END
					
					IF @bIsAutoApprove = 1
					BEGIN
						SET @inp_iPreclearanceStatusCodeId = 144002
						SET @nPreclearanceApprovedBy = 1
						SET @dtPreclearanceApprovedOn = dbo.uf_com_GetServerDate() 
					END
					
					-- check exercise pool option and set quantity for preclearance 
					IF (@inp_iSecurityTypeCodeId  = @nSecurityType_Share)
					BEGIN
						SELECT @nESOPQuanity_FromPool = ESOPQuantity, @nOtherQuantity_FromPool = OtherQuantity FROM tra_ExerciseBalancePool 
						WHERE UserInfoId = @inp_iUserInfoId AND SecurityTypeCodeId = @nSecurityType_Share AND DMATDetailsID = @inp_iDMATDetailsID
						
						
						IF (@nESOPQuanity_FromPool IS NULL AND @nOtherQuantity_FromPool IS NULL)
						BEGIN
							-- set quantity because there is nothing in pool
							SET @nESOPQuanity_FromPool = 0
							SET @nOtherQuantity_FromPool = 0
						END
						
						IF (@inp_iTransactionTypeCodeId = @nTransactionType_Buy)
						BEGIN
							SET @nOtherExcerciseOptionQty = @inp_dSecuritiesToBeTradedQty
						END
						ELSE IF (@inp_iTransactionTypeCodeId = @nTransactionType_CashExercies)
						BEGIN
							IF(@nContraTradeOption = @nContraTradeQuantityBase)
							BEGIN
								SET @nESOPExcerciseOptionQty = @inp_dSecuritiesToBeTradedQty
							END
							ELSE
							BEGIN
								SET @nOtherExcerciseOptionQty = @inp_dSecuritiesToBeTradedQty
							END
						END
						ELSE IF (@inp_iTransactionTypeCodeId = @nTransactionType_CashlessPartail)
						BEGIN
							IF(@nContraTradeOption = @nContraTradeQuantityBase)
							BEGIN
								SET @nESOPExcerciseOptionQty = @inp_dSecuritiesToBeTradedQty
							END
							ELSE
							BEGIN
								SET @nOtherExcerciseOptionQty = @inp_dSecuritiesToBeTradedQty
							END
						END
						ELSE IF (@inp_iTransactionTypeCodeId = @nTransactionType_Sell)
						BEGIN
						IF(@nContraTradeOption = @nContraTradeQuantityBase)
						BEGIN
							IF (@nExciseOptionForContraTrade = @nPoolOption_ESOPExciseOptionFirstandThenOtherShares)
							BEGIN
								IF (@inp_dSecuritiesToBeTradedQty <= @nESOPQuanity_FromPool)
								BEGIN
									SET @nESOPExcerciseOptionQty = @inp_dSecuritiesToBeTradedQty
								END
								ELSE
								BEGIN
									SET @nESOPExcerciseOptionQty = @nESOPQuanity_FromPool
									SET @nOtherExcerciseOptionQty = @inp_dSecuritiesToBeTradedQty - @nESOPQuanity_FromPool
								END
							END
							ELSE IF (@nExciseOptionForContraTrade = @nPoolOption_OtherSharesFirstThenESOPExciseOption)
							BEGIN
								IF (@inp_dSecuritiesToBeTradedQty <= @nOtherQuantity_FromPool)
								BEGIN
									SET @nOtherExcerciseOptionQty = @inp_dSecuritiesToBeTradedQty
								END
								ELSE
								BEGIN
									SET @nOtherExcerciseOptionQty = @nOtherQuantity_FromPool
									SET @nESOPExcerciseOptionQty =@inp_dSecuritiesToBeTradedQty -  @nOtherQuantity_FromPool
									
								END
							END
							ELSE IF (@nExciseOptionForContraTrade = @nPoolOption_UserSelectionOnPreClearanceAndTradeDetailsSubmission)
							BEGIN
								IF (@inp_bESOPExcerciseOptionQtyFlag = 1 AND @inp_bOtherESOPExcerciseOptionQtyFlag = 1)
								BEGIN
									IF (@inp_dSecuritiesToBeTradedQty <= @nESOPQuanity_FromPool)
									BEGIN
										SET @nESOPExcerciseOptionQty = @inp_dSecuritiesToBeTradedQty
									END
									ELSE
									BEGIN
										SET @nESOPExcerciseOptionQty = @nESOPQuanity_FromPool
										SET @nOtherExcerciseOptionQty = @inp_dSecuritiesToBeTradedQty - @nESOPQuanity_FromPool
									END
								END
								ELSE IF (@inp_bESOPExcerciseOptionQtyFlag = 1 AND @inp_bOtherESOPExcerciseOptionQtyFlag = 0)
								BEGIN
									SET @nESOPExcerciseOptionQty = @inp_dSecuritiesToBeTradedQty
								END
								ELSE IF (@inp_bESOPExcerciseOptionQtyFlag = 0 AND @inp_bOtherESOPExcerciseOptionQtyFlag = 1)
								BEGIN
									SET @nOtherExcerciseOptionQty = @inp_dSecuritiesToBeTradedQty
								END
							END
						END
						ELSE
						BEGIN
							SET @nOtherExcerciseOptionQty = @inp_dSecuritiesToBeTradedQty
						END
						END
						ELSE IF (@inp_iTransactionTypeCodeId = @nTransactionType_Pledge OR @inp_iTransactionTypeCodeId = @nTransactionType_PledgeRevoke OR @inp_iTransactionTypeCodeId = @nTransactionType_PledgeInvoke)
						BEGIN	
						
						   select @imptpostshareqtycodeid = impt_post_share_qty_code_id from tra_TransactionTypeSettings where trans_type_code_id = @inp_itransactiontypecodeid and mode_of_acquis_code_id = @inp_iModeOfAcquisitionCodeId and security_type_code_id = @inp_iSecurityTypeCodeId
						    					   
						   IF(@imptpostshareqtycodeid = @nNo)						     
						   BEGIN
							   SET @nPledgeOptionQty = @inp_dSecuritiesToBeTradedQty
					END
						   ELSE IF(@imptpostshareqtycodeid = @nAdd)
						   BEGIN 
							  SET @nOtherExcerciseOptionQty = @inp_dSecuritiesToBeTradedQty
						   END
						   ELSE IF(@imptpostshareqtycodeid = @nLess)	
						   BEGIN
								IF(@nContraTradeOption = @nContraTradeQuantityBase)
								BEGIN
									IF (@nExciseOptionForContraTrade = @nPoolOption_ESOPExciseOptionFirstandThenOtherShares)
									BEGIN
										IF (@inp_dSecuritiesToBeTradedQty <= @nESOPQuanity_FromPool)
										BEGIN
											SET @nESOPExcerciseOptionQty = @inp_dSecuritiesToBeTradedQty
										END
					ELSE
					BEGIN
											SET @nESOPExcerciseOptionQty = @nESOPQuanity_FromPool
											SET @nOtherExcerciseOptionQty = @inp_dSecuritiesToBeTradedQty - @nESOPQuanity_FromPool
										END
									END
									ELSE IF (@nExciseOptionForContraTrade = @nPoolOption_OtherSharesFirstThenESOPExciseOption)
									BEGIN
										IF (@inp_dSecuritiesToBeTradedQty <= @nOtherQuantity_FromPool)
										BEGIN
						SET @nOtherExcerciseOptionQty = @inp_dSecuritiesToBeTradedQty
					END
										ELSE
										BEGIN
											SET @nOtherExcerciseOptionQty = @nOtherQuantity_FromPool
											SET @nESOPExcerciseOptionQty = @inp_dSecuritiesToBeTradedQty -  @nOtherQuantity_FromPool
											
										END
									END
									ELSE IF (@nExciseOptionForContraTrade = @nPoolOption_UserSelectionOnPreClearanceAndTradeDetailsSubmission)
									BEGIN
										IF (@inp_bESOPExcerciseOptionQtyFlag = 1 AND @inp_bOtherESOPExcerciseOptionQtyFlag = 1)
										BEGIN
											IF (@inp_dSecuritiesToBeTradedQty <= @nESOPQuanity_FromPool)
											BEGIN
												SET @nESOPExcerciseOptionQty = @inp_dSecuritiesToBeTradedQty
											END
											ELSE
											BEGIN
												SET @nESOPExcerciseOptionQty = @nESOPQuanity_FromPool
												SET @nOtherExcerciseOptionQty = @inp_dSecuritiesToBeTradedQty - @nESOPQuanity_FromPool
											END
										END
										ELSE IF (@inp_bESOPExcerciseOptionQtyFlag = 1 AND @inp_bOtherESOPExcerciseOptionQtyFlag = 0)
										BEGIN
											SET @nESOPExcerciseOptionQty = @inp_dSecuritiesToBeTradedQty
										END
										ELSE IF (@inp_bESOPExcerciseOptionQtyFlag = 0 AND @inp_bOtherESOPExcerciseOptionQtyFlag = 1)
										BEGIN
											SET @nOtherExcerciseOptionQty = @inp_dSecuritiesToBeTradedQty
										END
									END
								END
								ELSE
								BEGIN
									SET @nOtherExcerciseOptionQty = @inp_dSecuritiesToBeTradedQty
								END
								END					   							
						END
					END
					ELSE
					BEGIN
					    IF (@inp_iTransactionTypeCodeId = @nTransactionType_Pledge OR @inp_iTransactionTypeCodeId = @nTransactionType_PledgeRevoke OR @inp_iTransactionTypeCodeId = @nTransactionType_PledgeInvoke)
						BEGIN							
						   select @imptpostshareqtycodeid = impt_post_share_qty_code_id from tra_TransactionTypeSettings where trans_type_code_id = @inp_itransactiontypecodeid and mode_of_acquis_code_id = @inp_iModeOfAcquisitionCodeId and security_type_code_id = @inp_iSecurityTypeCodeId
												   
						   IF(@imptpostshareqtycodeid = @nNo)						     
						   BEGIN
							   SET @nPledgeOptionQty = @inp_dSecuritiesToBeTradedQty
						   END
						   ELSE
						   BEGIN
							  SET @nOtherExcerciseOptionQty = @inp_dSecuritiesToBeTradedQty
						   END
						  END
						ELSE
						BEGIN						
							SET @nOtherExcerciseOptionQty = @inp_dSecuritiesToBeTradedQty
						END
					END
			
					INSERT INTO tra_PreclearanceRequest(PreclearanceRequestForCodeId,UserInfoId,UserInfoIdRelative,TransactionTypeCodeId,
							SecurityTypeCodeId,SecuritiesToBeTradedQty,PreclearanceStatusCodeId,CompanyId,ProposedTradeRateRangeFrom,
							ProposedTradeRateRangeTo,DMATDetailsID,ReasonForNotTradingCodeId,ReasonForNotTradingText,SecuritiesToBeTradedValue, IsAutoApproved,
							CreatedBy,CreatedOn,ModifiedBy,ModifiedOn, ESOPExcerciseOptionQtyFlag, OtherESOPExcerciseOptionQtyFlag, 
							ESOPExcerciseOptionQty, OtherExcerciseOptionQty, PledgeOptionQty, ModeOfAcquisitionCodeId,PreclearanceApprovedBy,PreclearanceApprovedOn)
					VALUES (
							@inp_iPreclearanceRequestForCodeId,@inp_iUserInfoId,@inp_iUserInfoIdRelative,@inp_iTransactionTypeCodeId,
							@inp_iSecurityTypeCodeId,@inp_dSecuritiesToBeTradedQty,@inp_iPreclearanceStatusCodeId,@inp_iCompanyId,@inp_dProposedTradeRateRangeFrom,
							@inp_dProposedTradeRateRangeTo,@inp_iDMATDetailsID,@inp_iReasonForNotTradingCodeId,@inp_sReasonForNotTradingText,@inp_dSecuritiesToBeTradedValue, @bIsAutoApprove,
							@inp_nUserId, dbo.uf_com_GetServerDate(), @inp_nUserId, dbo.uf_com_GetServerDate(), @inp_bESOPExcerciseOptionQtyFlag, @inp_bOtherESOPExcerciseOptionQtyFlag,
							@nESOPExcerciseOptionQty, @nOtherExcerciseOptionQty, @nPledgeOptionQty, @inp_iModeOfAcquisitionCodeId,@nPreclearanceApprovedBy,@dtPreclearanceApprovedOn)
							
					SET @inp_nPreclearanceRequestId = SCOPE_IDENTITY()
				
					EXEC @out_nReturnValue = st_tra_TradingTransactionMasterCreate 0,@inp_nPreclearanceRequestId,@inp_iUserInfoId,@nContinousDisclosureType,
			    												@nDisclosureStatusNotConfirmed,0,@nTradingPolicyID,NULL,NULL,NULL,NULL,NULL,
			    												@inp_nUserId,NULL,0,@out_nReturnValue = @out_nReturnValue OUTPUT,@out_nSQLErrCode = @out_nSQLErrCode OUTPUT,
																@out_sSQLErrMessage = @out_sSQLErrMessage OUTPUT
																
					IF(@out_nReturnValue > 0)
					BEGIN
						RETURN @out_nReturnValue
					END
					--Generate FORM E
					IF @bIsAutoApprove = 1
					BEGIN
						EXEC @out_nReturnValue = st_tra_GenerateFormDetails @nMapToTypePreclearance,@inp_nPreclearanceRequestId,@inp_nUserId,@out_nReturnValue = @out_nReturnValue OUTPUT,@out_nSQLErrCode = @out_nSQLErrCode OUTPUT,
																@out_sSQLErrMessage = @out_sSQLErrMessage OUTPUT
					END
					
					IF(@out_nReturnValue > 0)
					BEGIN
						RETURN @out_nReturnValue
					END
					
					--SET @nTransactionMasterID = SCOPE_IDENTITY()
					SELECT @nTransactionMasterID = TransactionMasterId 
					FROM tra_TransactionMaster WHERE PreclearanceRequestId = @inp_nPreclearanceRequestId
					--SELECT @nTransactionMasterID AS '@nTransactionMasterID'
					-- Calculate Max Display Rolling Number 
						SELECT @nMaxDisplayRollingNumber = MAX(ISNULL(DisplayRollingNumber,0)) FROM tra_TransactionMaster WHERE DisclosureTypeCodeId = @nContinousDisclosureType
						SET @nMaxDisplayRollingNumber = @nMaxDisplayRollingNumber + 1
						
						UPDATE tra_TransactionMaster
						SET DisplayRollingNumber = @nMaxDisplayRollingNumber,
							SecurityTypeCodeId = @inp_iSecurityTypeCodeId
						WHERE TransactionMasterId = @nTransactionMasterID
					
					--select @inp_nPreclearanceRequestId as 'PCL ID'
					-- update exercise pool 
					EXECUTE @RC = [st_tra_ExerciseBalancePoolUpdateDetails] 
							@nMapToTypePreclearance,
							@inp_nPreclearanceRequestId,
							NULL,
							@out_nReturnValue OUTPUT,
							@out_nSQLErrCode OUTPUT,
							@out_sSQLErrMessage OUTPUT
							
					IF @out_nReturnValue <> 0
					BEGIN
						RETURN @out_nReturnValue
					END
			END
			ELSE
			BEGIN
				--Fetech security Type code id
				SELECT @inp_iSecurityTypeCodeId  = SecurityTypeCodeId FROM tra_PreclearanceRequest 
				WHERE PreclearanceRequestId = @inp_nPreclearanceRequestId
				
				UPDATE tra_TransactionMaster
				SET SecurityTypeCodeId = @inp_iSecurityTypeCodeId
				WHERE TransactionMasterId = @nTransactionMasterID
			
				IF @inp_iReasonForNotTradingCodeId IS NOT NULL OR @inp_iReasonForNotTradingCodeId <> 0
				BEGIN
					-- Check if transaction with status Document uploaded is found, throw error
					IF EXISTS (SELECT TransactionMasterId
									FROM tra_TransactionMaster TM
									WHERE PreclearanceRequestId = @inp_nPreclearanceRequestId
										AND TransactionStatusCodeId = 148001)
					BEGIN
						SELECT @out_nReturnValue = @ERR_DOCUMENTUPLOADED
						RETURN @out_nReturnValue
					END

					-- Check if transaction details are entered and transaction is not submitted
					IF EXISTS (SELECT TransactionDetailsId
									FROM tra_TransactionMaster TM JOIN tra_TransactionDetails TD ON TM.TransactionMasterId = TD.TransactionMasterId
									WHERE PreclearanceRequestId = @inp_nPreclearanceRequestId
										AND TransactionStatusCodeId = 148002)
					BEGIN
						SELECT @out_nReturnValue = @ERR_DETAILSFOUND
						RETURN @out_nReturnValue
					END
					
					-- All transactions are either submitted Or the last transaction is pending but details are not entered
					-- If there are more than one transaction, and last transaction is pending, it will be removed						
					
					-- Check if transaction details are not entered. This is the first transaction for which NotTraded option is selected.
					IF NOT EXISTS (SELECT TransactionDetailsId
									FROM tra_TransactionMaster TM JOIN tra_TransactionDetails TD ON TM.TransactionMasterId = TD.TransactionMasterId
									WHERE PreclearanceRequestId = @inp_nPreclearanceRequestId
										AND TransactionStatusCodeId <> 148001)
					BEGIN
						SELECT @nIsPartiallyTradedFlag = 2, @nShowAddButtonFlag = 0
					END
					ELSE 
					-- This is the case where some transactions are submitted, but there are no more details to enter, 
					-- and preclearance quantity is not reached
					BEGIN
						SELECT @nIsPartiallyTradedFlag = 1, @nShowAddButtonFlag = 0						
					END
				
					-- If there are more than 1 record against preclearance, and the last record is Not Submitted, remove that record
					IF @nIsPartiallyTradedFlag = 1
					BEGIN
						--SELECT @nTransactionIdToBeRemoved = TransactionMasterId
						--FROM tra_PreclearanceRequest PR JOIN tra_TransactionMaster TM ON TM.PreclearanceRequestId = PR.PreclearanceRequestId
						--WHERE TransactionStatusCodeId = 148002 AND TM.PreclearanceRequestId = @inp_nPreclearanceRequestId
						DECLARE @listStr VARCHAR(MAX)
						SELECT  @listStr = COALESCE(@listStr+', ' ,'') + CONVERT(VARCHAR(MAX), TransactionMasterId) 
						FROM tra_PreclearanceRequest PR JOIN tra_TransactionMaster TM ON TM.PreclearanceRequestId = PR.PreclearanceRequestId
						WHERE TransactionStatusCodeId = 148002 AND TM.PreclearanceRequestId = @inp_nPreclearanceRequestId
						
						IF @listStr IS NOT NULL AND @listStr <> ''
						BEGIN
						--select @listStr as 'ass'
						declare @sql VARCHAR(MAX)
						set @sql = 'delete from tra_TransactionMaster where TransactionMasterId in(' + CONVERT(VARCHAR(max),@listStr) + ')'
						exec(@sql)
							---DELETE FROM tra_TransactionMaster
							--WHERE TransactionMasterId = @nTransactionIdToBeRemoved
						END
					END
					UPDATE tra_PreclearanceRequest
					SET ReasonForNotTradingCodeId = @inp_iReasonForNotTradingCodeId,
						ReasonForNotTradingText = @inp_sReasonForNotTradingText,
						IsPartiallyTraded = @nIsPartiallyTradedFlag,
						ShowAddButton = @nShowAddButtonFlag,
						ModifiedBy = @inp_nUserId,
						ModifiedOn = dbo.uf_com_GetServerDate()
					WHERE PreclearanceRequestId = @inp_nPreclearanceRequestId
					
					-- Update IsPartiallyTradedFlag and ShowAddButton flags
					
					-- update exercise pool -- for case of partial trade or no traded
					EXECUTE @RC = [st_tra_ExerciseBalancePoolUpdateDetails] 
							132005,
							@inp_nPreclearanceRequestId,
							NULL,
							@out_nReturnValue OUTPUT,
							@out_nSQLErrCode OUTPUT,
							@out_sSQLErrMessage OUTPUT
							
					IF @out_nReturnValue <> 0
					BEGIN
						RETURN @out_nReturnValue
					END
				END
				ELSE
					BEGIN
						IF @inp_iPreclearanceStatusCodeId = @nPreClearanceStatus_Approve
						BEGIN
							SET @nPreclearanceApprovedBy = @inp_nUserId
							SET @dtPreclearanceApprovedOn = dbo.uf_com_GetServerDate() 
						END
						UPDATE tra_PreclearanceRequest
						SET PreclearanceStatusCodeId = @inp_iPreclearanceStatusCodeId,
						ReasonForRejection = @inp_sReasonForRejection,
						ReasonForApproval  = @inp_sReasonForApproval,
						ReasonForApprovalCodeId = @inp_iReasonForApprovalCodeId,
						PreclearanceApprovedBy = @nPreclearanceApprovedBy,
						PreclearanceApprovedOn = @dtPreclearanceApprovedOn,
						ModifiedBy = @inp_nUserId,
						ModifiedOn = dbo.uf_com_GetServerDate()
						WHERE PreclearanceRequestId = @inp_nPreclearanceRequestId
						
						--Generate FORM E
						IF @inp_iPreclearanceStatusCodeId = @nPreClearanceStatus_Approve
						BEGIN
							EXEC @out_nReturnValue = st_tra_GenerateFormDetails @nMapToTypePreclearance,@inp_nPreclearanceRequestId,@inp_nUserId,@out_nReturnValue = @out_nReturnValue OUTPUT,@out_nSQLErrCode = @out_nSQLErrCode OUTPUT,
																	@out_sSQLErrMessage = @out_sSQLErrMessage OUTPUT
						END
						
						IF(@out_nReturnValue > 0)
						BEGIN
							RETURN @out_nReturnValue
						END
					
					-- update exercise pool -- for case of reject 
					IF (@inp_iPreclearanceStatusCodeId = @nPreClearanceStatus_Reject)
					BEGIN
						EXECUTE @RC = [st_tra_ExerciseBalancePoolUpdateDetails] 
								@nMapToTypePreclearance,
								@inp_nPreclearanceRequestId,
								NULL,
								@out_nReturnValue OUTPUT,
								@out_nSQLErrCode OUTPUT,
								@out_sSQLErrMessage OUTPUT
								
						IF @out_nReturnValue <> 0
						BEGIN
							RETURN @out_nReturnValue
						END
					END
				END
				
			END
		END
	
	
		
		IF @inp_nPreclearanceNotTakenFlag = 0
		BEGIN
		
			-- in case required to return for partial save case.
			SELECT PR.PreclearanceRequestId, PreclearanceRequestForCodeId, PR.UserInfoId, UserInfoIdRelative, 
				   TransactionTypeCodeId, PR.SecurityTypeCodeId, SecuritiesToBeTradedQty, PreclearanceStatusCodeId, 
				   CompanyId, ProposedTradeRateRangeFrom, ProposedTradeRateRangeTo, DMATDetailsID, 
				   ReasonForNotTradingCodeId, ReasonForNotTradingText,TM.TransactionMasterId,TM.TradingPolicyId,PR.SecuritiesToBeTradedValue 
			FROM tra_PreclearanceRequest PR
			LEFT JOIN tra_TransactionMaster TM ON PR.PreclearanceRequestId = TM.PreclearanceRequestId
			WHERE (@inp_nPreclearanceRequestId IS NULL OR @inp_nPreclearanceRequestId = 0) OR PR.PreclearanceRequestId = @inp_nPreclearanceRequestId
				  AND TM.TransactionMasterId = @nTransactionMasterID
		END
		ELSE
		BEGIN
			SELECT * FROM tra_TransactionMaster 
			WHERE TransactionMasterId = @nTransactionMasterID
		END
		
	
		--drop tem table
		DROP TABLE #temp
		
		SET @out_nReturnValue = 0
		RETURN @out_nReturnValue
		
		
	END	 TRY
	
	BEGIN CATCH	
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()	
		
		
		--drop tem table
		DROP TABLE #temp
		
		-- Return common error if required, otherwise specific error.		
		SET @out_nReturnValue =  dbo.uf_com_GetErrorCode(@ERR_PRECLEARANCEREQUEST_SAVE, ERROR_NUMBER())
		RETURN @out_nReturnValue
	END CATCH
END