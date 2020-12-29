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
	@inp_PreclearanceValidityDateOld            DATETIME,
	@inp_PreclearanceValidityDateUpdatedByCO    DATETIME = NULL,
	@out_sContraTradeTillDate				    NVARCHAR(500) OUTPUT,
	@out_nReturnValue							INT = 0 OUTPUT,
	@out_nSQLErrCode							INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage							NVARCHAR(500) = '' OUTPUT,	-- Output SQL Error Message, if error occurred.
	@out_sPeriodEnddate							NVARCHAR(500) OUTPUT,
	@out_sApproveddate							NVARCHAR(500) OUTPUT,
	@out_sPreValiditydate						NVARCHAR(500) OUTPUT,
	@out_sProhibitOnPer							NVARCHAR(500) OUTPUT,
	@out_sProhibitOnQuantity					NVARCHAR(500) OUTPUT,
	@inp_Currency INT=0
AS
BEGIN

	DECLARE @ERR_PRECLEARANCEREQUEST_SAVE			INT
	DECLARE @ERR_PRECLEARANCEREQUEST_NOTFOUND		INT
	DECLARE @ERR_CONTRATRADEOCCURED					INT
	
	DECLARE @ERR_DOCUMENTUPLOADED					INT
	DECLARE @ERR_DETAILSFOUND						INT
	DECLARE @ERR_PRECLEARANCEREQUEST_PENDING		INT
	DECLARE @ERR_PRECLEARANCEREQUEST_REJECTED		INT
	DECLARE @ERR_TRADEINGPENDING_FORPRECLEARANCEREQUEST INT
	DECLARE @ERR_TRADINGDONEWITHOUTPRECREQ			INT
	DECLARE @ERR_NOTTRADEDAFTERPREVALIDITY          INT
	DECLARE @ERR_TRADEDAFTERPREVALIDITY				INT
	DECLARE @ERR_SOFTCOPYNOTSUBMITTED				INT
	DECLARE @ERR_HARDCOPYNOTSUBMITTED				INT
	DECLARE @ERR_PREPARTIALLYTRADED				    INT
	DECLARE @ERR_PREQTYEXCEEDTHANPER				INT
	DECLARE @ERR_PREQTYEXCEEDTHANQTY			    INT
	DECLARE @ERR_NonTradingDays			            INT = 52122
	
	DECLARE @nTransactionMasterID					BIGINT
	DECLARE @nTradingPolicyID						INT
	DECLARE @nContinousDisclosureType				INT
	DECLARE @nDisclosureStatusNotConfirmed			INT
	DECLARE @nDiscStatusDocUploaded						INT
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
	DECLARE @nIsPreClearanceEditable INT = 0
	DECLARE @nContraTradeQuantityBase INT = 175002
	DECLARE @ERR_InitialDisclosureforRelative           INT = 50777 -- Case #37 Enter initial disclosuer for relative first.
	
	DECLARE @nBuyQuantityOld DECIMAL = 0
	DECLARE @nSellQuantityOld DECIMAL = 0
	DECLARE @nQuantity DECIMAL = 0

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
				@nDiscStatusDocUploaded				= 148001,
				@ERR_TRADINGPOLICY_NOTFOUND			= 16093,
				@ERR_PROHIBITNONTRADINGPERIOD		= 17326,
				@ERR_CONTRATRADEOCCURED				= 17343,
				@ERR_DOCUMENTUPLOADED				= 17357, -- Cannot submit reason for not trading, as details are not yet submitted for a transaction for which document is uploaded.
				@ERR_DETAILSFOUND					= 17358, -- Cannot submit reason for not trading, as details are entered but not yet submitted for a transaction.
				@ERR_PRECLEARANCEREQUEST_PENDING	= 50714,
				@ERR_PRECLEARANCEREQUEST_REJECTED	= 50715,
				@ERR_TRADEINGPENDING_FORPRECLEARANCEREQUEST         =50716,
				@ERR_TRADINGDONEWITHOUTPRECREQ     =50717,
				@ERR_NOTTRADEDAFTERPREVALIDITY     =50718,
				--@ERR_NOTTRADEDAFTERPREVALIDITY     =50719,
				@ERR_TRADEDAFTERPREVALIDITY        =50720,
				@ERR_SOFTCOPYNOTSUBMITTED        =50721,
				@ERR_HARDCOPYNOTSUBMITTED		 =50722,
				@ERR_PREPARTIALLYTRADED			 =50723,
				@ERR_PREQTYEXCEEDTHANPER		 =50724,
			    @ERR_PREQTYEXCEEDTHANQTY			 =50725
				
		SET @nTradingWindowStatusActive = 131002
		SET @nProhibitPreclearanceduringnontrading = 132007
		SET @nTradingWindowEventTypeFinancialResult  = 126001
		SET @nTradingWindowEventTypeOther	= 126002
		SET @nMapToTypePreclearance = 132004
		
		CREATE TABLE #tmpTrading(ApplicabilityMstId INT,UserInfoId INT,MapToId INT)
		-- This part for Check COntra Trade Case
		-- Start Here
		
		-- Fetch Contra Trade Option
		SELECT @nContraTradeOption = ContraTradeOption, @nIsPreClearanceEditable = IsPreClearanceEditable
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
		INSERT INTO #tmpTrading(ApplicabilityMstId,UserInfoId,MapToId)
		EXEC st_tra_GetTradingPolicy
		
		SELECT @nTradingPolicyID = ISNULL(MAX(MapToId), 0) 
		FROM #tmpTrading  
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
				
					IF(@inp_iUserInfoIdRelative IS NOT NULL AND @inp_iUserInfoIdRelative!='')
					BEGIN
						IF (NOT EXISTS (SELECT TM.TransactionMasterId FROM tra_TransactionMaster TM 
							JOIN tra_TransactionDetails TD ON TM.TransactionMasterId=TD.TransactionMasterId 
							WHERE TM.DisclosureTypeCodeId in(147001,147002,147003) AND TD.ForUserInfoId=@inp_iUserInfoIdRelative))
							BEGIN
					
								SET @out_nReturnValue = @ERR_InitialDisclosureforRelative
								RETURN @out_nReturnValue
							END
					END
					print(123242)
					-- Perform other validation checks
					EXEC st_tra_PreclearanceRequestSaveValidations @inp_nPreclearanceRequestId, @nTradingPolicyID, @inp_iUserInfoId, 
										@inp_iTransactionTypeCodeId, @inp_iSecurityTypeCodeId, @inp_dSecuritiesToBeTradedQty,
										@inp_iPreclearanceStatusCodeId, @inp_dProposedTradeRateRangeFrom, @inp_dProposedTradeRateRangeTo,
										@inp_dSecuritiesToBeTradedValue, @inp_bESOPExcerciseOptionQtyFlag, @inp_bOtherESOPExcerciseOptionQtyFlag,@nContraTradeOption, @inp_iModeOfAcquisitionCodeId,@inp_iDMATDetailsID,
										@bIsAutoApprove OUTPUT, @out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT,
										@out_sSQLErrMessage OUTPUT
																				
					IF @out_nReturnValue <> 0
					BEGIN
				print(@out_nReturnValue)
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

					
/*--------------------------------------------Logic implemented for Airtel Customization---------------------------------------------------*/
			--IsProhibitPreClrFunctionalityApplicable
DECLARE @nIsProhibitPreClrFunctionalityApplicable INT=0
SELECT @nIsProhibitPreClrFunctionalityApplicable=IsProhibitPreClrFunctionalityApplicable FROM rul_TradingPolicy WHERE TradingPolicyId=@nTradingPolicyID
IF(@nIsProhibitPreClrFunctionalityApplicable=1)
BEGIN

	DECLARE @nPeriodType INT	
	DECLARE @nYearCodeId INT
	DECLARE @nPeriodCodeId INT
	DECLARE @dtStartDate DATETIME
	DECLARE @dtEndDate DATETIME
	DECLARE @nPreclearanceRequestId INT=0
	DECLARE @nPreclearanceRequestRejectedId INT=0
	DECLARE @dtPreclearanceApproveDate DATETIME
	DECLARE @dtPreclearanceValidityDate DATETIME
	DECLARE @nPreClrApprovalValidityLimit INT
	DECLARE @nTradeSubmitValidityLimit INT

	SELECT 
		@nPeriodType = CASE 
		WHEN TP.ProhibitPreClrForPeriod = 137001 THEN 123001 -- Yearly
		WHEN TP.ProhibitPreClrForPeriod = 137002 THEN 123003 -- Quarterly
		WHEN TP.ProhibitPreClrForPeriod = 137003 THEN 123004 -- Monthly
		WHEN TP.ProhibitPreClrForPeriod = 137004 THEN 123002 -- half yearly
		ELSE TP.DiscloPeriodEndFreq 
		END					  				
	FROM 
		rul_TradingPolicy TP 
	WHERE TP.TradingPolicyId = @nTradingPolicyID
	
	DECLARE @dtPreclearanceDate DATETIME
	SELECT @dtPreclearanceDate=dbo.uf_com_GetServerDate()
	
	EXECUTE st_tra_PeriodEndDisclosureStartEndDate2
	@nYearCodeId OUTPUT, @nPeriodCodeId OUTPUT,@dtPreclearanceDate,@nPeriodType, 0, 
	@dtStartDate OUTPUT, @dtEndDate OUTPUT, 
	@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT, @out_sSQLErrMessage OUTPUT
	SET @out_sPeriodEnddate = dbo.uf_rpt_FormatDateValue(@dtEndDate,0) 
	

/*----------Case 9: Previous Pre-clearance not approved--------------------------------------*/
	DECLARE @nPreclearancePendingFromCo INT=0
	DECLARE @nPrePendingStatus INT =144001
	
	SELECT 
		@nPreclearancePendingFromCo=COUNT(PreclearanceRequestId)
	FROM 
		tra_PreclearanceRequest 
	WHERE 
		UserInfoId=@inp_iUserInfoId AND PreclearanceStatusCodeId=@nPrePendingStatus
		AND CreatedOn>=@dtStartDate AND CreatedOn<=@dtEndDate 
		
	IF(@nPreclearancePendingFromCo>0)
	BEGIN
		SET @out_nReturnValue = @ERR_PRECLEARANCEREQUEST_PENDING
		RETURN (@out_nReturnValue)	
	END

/*----Case 9 is Closed-------------------------------------------------*/


/*------Case 10: Previous Pre-clearance rejected----------------------------------------------------------*/
	
	SELECT 
		@nPreclearanceRequestRejectedId=COUNT(PreclearanceRequestId)
	FROM 
		tra_PreclearanceRequest 
	WHERE 
		UserInfoId=@inp_iUserInfoId AND ModifiedOn >=@dtStartDate 
		AND ModifiedOn<=@dtEndDate AND PreclearanceStatusCodeId=@nPreClearanceStatus_Reject   

	IF(@nPreclearanceRequestRejectedId>0)
	BEGIN		
		SET @out_nReturnValue = @ERR_PRECLEARANCEREQUEST_REJECTED
		RETURN (@out_nReturnValue)
	END	
/*-------------------------Case 10 Closed----------------------------------------------------------------------*/

/*---Case 1 : Previous Preclearance is open--------*/

	DECLARE @nTotPreTradedQty INT=0
	declare @nPreclearanceId int
	DECLARE @dtPreApproveDate DATETIME
	DECLARE @nPreClrApprovValidityLimit INT=0

	SELECT  @nPreclearanceId=MAX(PreclearanceRequestId) FROM tra_PreclearanceRequest WHERE UserInfoId=@inp_iUserInfoId AND ModifiedOn >=@dtStartDate AND ModifiedOn<=@dtEndDate AND ReasonForNotTradingCodeId IS NULL

	SELECT @dtPreApproveDate=PreclearanceApprovedOn from tra_PreclearanceRequest where PreclearanceRequestId=@nPreclearanceId

	SELECT 
		@nPreClrApprovValidityLimit=PreClrApprovalValidityLimit
	FROM 
		rul_TradingPolicy 
	WHERE 
		TradingPolicyId =(SELECT DISTINCT TradingPolicyId FROM tra_TransactionMaster WHERE PreclearanceRequestId=@nPreclearanceId)

	SET @out_sPreValiditydate=dbo.uf_rpt_FormatDateValue((@dtPreApproveDate + @nPreClrApprovValidityLimit),0)
--set @out_sApproveddate= dbo.uf_rpt_FormatDateValue(@dtPreclearanceApproveDate,0) 

	IF(@nPreclearanceId IS NOT NULL AND @nPreclearanceId<>'')
	BEGIN		
		SELECT @nTotPreTradedQty=ISNULL(SUM(Quantity),0) FROM tra_TransactionDetails TD
		JOIN tra_TransactionMaster TM ON TD.TransactionMasterId=TM.TransactionMasterId
		WHERE TM.PreclearanceRequestId=@nPreclearanceId AND UserInfoId=@inp_iUserInfoId			
			
			IF(@nTotPreTradedQty=0)
			BEGIN			
				PRINT('Previous Preclearance is open(pre approved but trade is not done)')
				SET @out_nReturnValue = @ERR_TRADEINGPENDING_FORPRECLEARANCEREQUEST
				RETURN (@out_nReturnValue)
			END
	END	


/*------- Case 13 : Pre-clearance not taken */
	DECLARE @nPntTransId INT = 0
	SELECT 
		@nPntTransId=COUNT(TM.TransactionMasterId) 
	FROM 
		tra_transactionmaster TM JOIN tra_TransactionDetails TD ON TM.TransactionMasterId=TD.TransactionMasterId 
	WHERE 
		TD.DateOfAcquisition >= @dtStartDate AND TD.DateOfAcquisition <= @dtEndDate AND TM.PreclearanceRequestId IS NULL 
		AND TM.DisclosureTypeCodeId=@nContinousDisclosureType AND tM.UserInfoId=@inp_iUserInfoId

	IF(@nPntTransId>0)
	BEGIN
		PRINT('PNT done without Preclearance')
		SET @out_nReturnValue = @ERR_TRADINGDONEWITHOUTPRECREQ
		RETURN (@out_nReturnValue)
	END

/*--------Case 13 end----------*/

/*-------Case 2b: Previous Pre-clearance not traded and reason provided for not trade after the pre-clearance validity------*/

	DECLARE @nPreclearanceIdToCheckTradeTrans INT
	SELECT  @nPreclearanceIdToCheckTradeTrans=MAX(PreclearanceRequestId) FROM tra_PreclearanceRequest WHERE UserInfoId=@inp_iUserInfoId 

	SELECT @dtPreclearanceApproveDate=PreclearanceApprovedOn FROM tra_PreclearanceRequest WHERE PreclearanceRequestId=@nPreclearanceIdToCheckTradeTrans
	
	SET @out_sApproveddate= dbo.uf_rpt_FormatDateValue(@dtPreclearanceApproveDate,0)  

	SELECT 
		@nPreClrApprovalValidityLimit=PreClrApprovalValidityLimit,@nTradeSubmitValidityLimit=StExTradePerformDtlsSubmitToCOByInsdrLimit
	FROM 
		rul_TradingPolicy 
	WHERE 
		TradingPolicyId =(SELECT DISTINCT TradingPolicyId FROM tra_TransactionMaster WHERE PreclearanceRequestId=@nPreclearanceIdToCheckTradeTrans)	    

	SET @dtPreclearanceValidityDate=@dtPreclearanceApproveDate+@nPreClrApprovalValidityLimit
	SET @out_sPreValiditydate=dbo.uf_rpt_FormatDateValue(@dtPreclearanceValidityDate,0)
	
	SELECT 
		@nPreclearanceRequestId=PreclearanceRequestId
	FROM 
		tra_PreclearanceRequest 
	WHERE 
		UserInfoId=@inp_iUserInfoId 
		and PreclearanceRequestId=@nPreclearanceIdToCheckTradeTrans
		and ModifiedOn>@dtPreclearanceValidityDate
		AND ReasonForNotTradingCodeId IS NOT NULL	
		AND ModifiedOn >@dtStartDate AND ModifiedOn<@dtEndDate

	IF(@nPreclearanceRequestId>0)
	BEGIN
		SET @out_nReturnValue = @ERR_NOTTRADEDAFTERPREVALIDITY
		RETURN (@out_nReturnValue)
	END

/*------Case 2b is closed--------------------------------------------------------------------------------------*/



/*-------Case 3: Traded after Pre-clearance validity period ----------------------------------------------------*/

	DECLARE @nTradingTransId INT=0
	SELECT 
		@nTradingTransId=TP.PreclearanceRequestId
	FROM 
		tra_PreclearanceRequest TP JOIN tra_TransactionMaster TM
		ON TP.PreclearanceRequestId=TM.PreclearanceRequestId
		JOIN tra_TransactionDetails TD ON TM.TransactionMasterId=TD.TransactionMasterId
	WHERE 
		TM.UserInfoId=@inp_iUserInfoId AND TM.PreclearanceRequestId=@nPreclearanceIdToCheckTradeTrans
		AND TD.DateOfAcquisition>@dtPreclearanceValidityDate AND IsPartiallyTraded=0
		AND TD.DateOfAcquisition>@dtStartDate AND TD.DateOfAcquisition<@dtEndDate

	IF(@nTradingTransId>0)
	BEGIN 
	SET @out_nReturnValue = @ERR_TRADEDAFTERPREVALIDITY
		RETURN (@out_nReturnValue)
	END
/*------Case 3 is closed---------------------------------------------------------------------------------------*/

/*-------------------Case 6  Traded against pre-clearance but softcopy and hard copy not submitted
within pre-clearance validity + 2days------------------*/

	DECLARE @nSoftCopyPendinCount INT=0
	DECLARE @nSoftCopyTransId INT=0
	DECLARE @nSoftCopyNotSubmittedinStipulatesTime INT=0
	DECLARE @dtPreclearanceValidityDateForSoftCopy datetime
	DECLARE @nSoftCopySubmitted INT=153021
	SET @dtPreclearanceValidityDateForSoftCopy=@dtPreclearanceApproveDate+@nPreClrApprovalValidityLimit+@nTradeSubmitValidityLimit

	SELECT 
	@nSoftCopyTransId=TM.TransactionMasterId
	FROM 
	tra_TransactionMaster TM	  		
	WHERE 
	TM.TransactionStatusCodeId IN(148007) 
	AND 
	TM.UserInfoId=@inp_iUserInfoId
	AND TM.DisclosureTypeCodeId=@nContinousDisclosureType AND SoftCopyReq=1 

	IF(@nSoftCopyTransId<>0)
	BEGIN
		SELECT @nSoftCopyPendinCount=EventLogId FROM eve_EventLog WHERE UserInfoId=@inp_iUserInfoId AND MapToId=@nSoftCopyTransId AND EventCodeId=@nSoftCopySubmitted 
		
		SELECT @nSoftCopyNotSubmittedinStipulatesTime=EventLogId FROM eve_EventLog WHERE UserInfoId=@inp_iUserInfoId AND MapToId=@nSoftCopyTransId AND EventCodeId=@nSoftCopySubmitted AND eve_EventLog.EventDate>= @dtPreclearanceValidityDateForSoftCopy AND eve_EventLog.EventDate>@dtStartDate AND eve_EventLog.EventDate<@dtEndDate
		
		IF((@nSoftCopyPendinCount=0 and @nSoftCopyNotSubmittedinStipulatesTime=0) or(@nSoftCopyPendinCount<>0 and @nSoftCopyNotSubmittedinStipulatesTime<>0) )
		BEGIN			
			SET @out_nReturnValue = @ERR_SOFTCOPYNOTSUBMITTED
			RETURN (@out_nReturnValue)
		END
	END
/*-------------------Case 6 Closed------------------*/

/*Case 7: Traded against pre-clearance and softcopy submitted but hard copy not submitted--------------------------------------*/

	DECLARE @nHardCopyPendinCount INT=0
	DECLARE @nHardCopyTransId INT=0
	DECLARE @nHardCopyNotSubmittedinStipulatesTime INT=0
	DECLARE @nHardCopySubmitted INT = 153022
	DECLARE @dtPreclearanceValidityDateForHardCopy DATETIME
	DECLARE @nDiscStatusSoftCopySubmitted INT =148004
	SET @dtPreclearanceValidityDateForHardCopy=@dtPreclearanceApproveDate+@nPreClrApprovalValidityLimit+@nTradeSubmitValidityLimit
	SELECT 
	@nHardCopyTransId=TM.TransactionMasterId
	FROM 
	tra_TransactionMaster TM	  		
	WHERE 
	TM.TransactionStatusCodeId IN(@nDiscStatusSoftCopySubmitted) 
	AND 
	TM.UserInfoId=@inp_iUserInfoId
	AND TM.DisclosureTypeCodeId=@nContinousDisclosureType AND SoftCopyReq=1 AND HardCopyReq=1  

	IF(@nHardCopyTransId<>0)
	BEGIN
		SELECT @nHardCopyPendinCount=EventLogId FROM eve_EventLog WHERE UserInfoId=@inp_iUserInfoId AND MapToId=@nHardCopyTransId AND EventCodeId=@nHardCopySubmitted 

		SELECT @nHardCopyNotSubmittedinStipulatesTime=EventLogId FROM eve_EventLog WHERE UserInfoId=@inp_iUserInfoId AND MapToId=@nHardCopyTransId AND EventCodeId=@nHardCopySubmitted and eve_EventLog.EventDate>= @dtPreclearanceValidityDateForHardCopy AND eve_EventLog.EventDate>@dtStartDate AND eve_EventLog.EventDate<@dtEndDate

		IF((@nHardCopyPendinCount=0 AND @nHardCopyNotSubmittedinStipulatesTime=0) OR (@nHardCopyPendinCount<>0 AND @nHardCopyNotSubmittedinStipulatesTime<>0) )
		BEGIN		
			SET @out_nReturnValue = @ERR_HARDCOPYNOTSUBMITTED
			RETURN (@out_nReturnValue)
		END
	END

/*------------ Case 7 Closed-------------------------------------------------*/


/*---Case 14 : Previous Preclearance is partially traded--------*/
	DECLARE @nTotPrePartiallyTradedQty INT=0
	DECLARE @nPreQty INT=0	

	SELECT @nPreQty=cast(ISNULL(SecuritiesToBeTradedQty,0) as int)
	FROM tra_PreclearanceRequest WHERE PreclearanceRequestId=@nPreclearanceIdToCheckTradeTrans AND ReasonForNotTradingCodeId IS NULL AND ReasonForNotTradingText IS NULL AND PreclearanceStatusCodeId<>@nPreClearanceStatus_Reject
	
	SELECT 
		@nTotPrePartiallyTradedQty=ISNULL(SUM(Quantity),0) 
	FROM 
		tra_TransactionDetails WHERE TransactionMasterId IN
		(SELECT TransactionMasterId FROM tra_TransactionMaster WHERE TransactionStatusCodeId NOT IN(@nDisclosureStatusNotConfirmed,@nDiscStatusDocUploaded)
		AND PreclearanceRequestId =@nPreclearanceIdToCheckTradeTrans
		)

	IF(@nTotPrePartiallyTradedQty<>@nPreQty AND @nPreQty<>0)
	BEGIN
		SET @out_nReturnValue = @ERR_PREPARTIALLYTRADED
		RETURN (@out_nReturnValue)
	END

/*-----Case 1 is closed----------------------------------------------------------------------------------------*/

	IF(@inp_iTransactionTypeCodeId=143002)
	BEGIN
		DECLARE @nCheckSecurityType INT=0
		SELECT @nCheckSecurityType=SecurityTypeCodeID FROM dbo.rul_TradingPolicyForProhibitSecurityTypes WHERE TradingPolicyId=@nTradingPolicyID and SecurityTypeCodeID=@inp_iSecurityTypeCodeId
		IF(@nCheckSecurityType<>0)	
		BEGIN
		/*---------- 25% AND 50000 LOGIC---------*/

			DECLARE @nHoldingUsrCount BIGINT=0
			DECLARE @nHoldingTotcount INT=0
			DECLARE @nPeriodCode INT=124001			    
			DECLARE @nPreQuantity INT=0
			DECLARE @nTradedQty INT=0
			DECLARE @nTotQty decimal(10,2)=0
			DECLARE @nProhibitPreClrOnPerQty decimal(10,2)=0		
			DECLARE @nProhibitPreClrOnQuantity INT=0
				
			DECLARE @nTotSecurityCnt INT=0
			DECLARE @nSecurityCnt INT=0
			DECLARE @nCount       INT=0
			DECLARE @TotalRows    INT=0
			DECLARE @nHoldingSecurityCount INT=0
			DECLARE @nHoldingSecurityUsrCount INT=0
			
			CREATE TABLE #tmpProhibitSecurityTypes (ID INT IDENTITY(1,1),SecurityType INT)
			INSERT INTO #tmpProhibitSecurityTypes
			SELECT SecurityTypeCodeID FROM dbo.rul_TradingPolicyForProhibitSecurityTypes WHERE TradingPolicyId=@nTradingPolicyID
			SELECT @nTotSecurityCnt=COUNT(ID) FROM #tmpProhibitSecurityTypes
			WHILE @nSecurityCnt<@nTotSecurityCnt
			BEGIN
				
				CREATE TABLE #tmpYearCodeId(ID INT IDENTITY NOT NULL,YearCodeId BIGINT NOT NULL,UserInfoIdRelative BIGINT NOT NULL,UserInfoId BIGINT NOT NULL)

				INSERT INTO #tmpYearCodeId(YearCodeId,UserInfoIdRelative,UserInfoId)

				SELECT MAX(YearCodeId) AS YearCodeId ,UserInfoIdRelative,UserInfoId FROM tra_TransactionSummary 
				WHERE UserInfoId=@inp_iUserInfoId and PeriodCodeId=@nPeriodCode and SecurityTypeCodeId=(SELECT SecurityType FROM #tmpProhibitSecurityTypes WHERE ID=@nSecurityCnt+1) GROUP BY UserInfoIdRelative,UserInfoId

				SELECT @TotalRows=COUNT(YearCodeId) FROM #tmpYearCodeId
				WHILE @nCount<@TotalRows
				BEGIN
						SELECT 
							@nHoldingSecurityUsrCount = ISNULL(TS.ClosingBalance, 0)
						FROM 
							tra_TransactionSummary TS
						WHERE 
							TS.PeriodCodeId=@nPeriodCode AND TS.UserInfoIdRelative=(SELECT UserInfoIdRelative FROM #tmpYearCodeId WHERE ID=@nCount+1) AND TS.SecurityTypeCodeId=(SELECT SecurityType FROM #tmpProhibitSecurityTypes WHERE ID=@nSecurityCnt+1) AND TS.YearCodeId=(SELECT YearCodeId FROM #tmpYearCodeId WHERE ID=@nCount+1)

				
				SET @nHoldingSecurityCount=@nHoldingSecurityUsrCount +@nHoldingSecurityCount
				
				SET @nCount=@nCount+1
				END
				SET @nCount=0
				SET @TotalRows=0
				DROP TABLE #tmpYearCodeId
				
				SET @nHoldingTotcount=@nHoldingTotcount+@nHoldingSecurityCount	
				SET @nHoldingSecurityCount=0	
				SET @nSecurityCnt=@nSecurityCnt+1
			END		
			DROP TABLE #tmpProhibitSecurityTypes	
		
			SELECT 
				@nTradedQty=isnull(SUM(Quantity),0)
			FROM 
				tra_TransactionDetails TD JOIN tra_TransactionMaster TM
				ON TD.TransactionMasterId=TM.TransactionMasterId
			WHERE 
				ForUserInfoId=@inp_iUserInfoId AND DisclosureTypeCodeId=@nContinousDisclosureType
				AND DateOfAcquisition>= @dtStartDate AND  DateOfAcquisition<=@dtEndDate
		
			SET @nTotQty = @nPreQuantity + @nTradedQty + @inp_dSecuritiesToBeTradedQty		
		
			
			DECLARE @nBasedOnPerFlag INT=0
			DECLARE @nBasedOnQtyFlag INT=0
			
			SELECT @nBasedOnPerFlag=ProhibitPreClrPercentageAppFlag,@nBasedOnQtyFlag=ProhibitPreClrOnQuantityAppFlag FROM rul_TradingPolicy WHERE  TradingPolicyId=@nTradingPolicyID
			
			IF(@nBasedOnPerFlag=1)
			BEGIN
				SELECT @nProhibitPreClrOnPerQty=((@nHoldingTotcount*ProhibitPreClrOnPercentage)/100),@out_sProhibitOnPer=ProhibitPreClrOnPercentage FROM rul_TradingPolicy WHERE  TradingPolicyId=@nTradingPolicyID
			END
			
			IF(@nBasedOnQtyFlag=1)
			BEGIN
				SELECT @nProhibitPreClrOnQuantity=ProhibitPreClrOnQuantity FROM rul_TradingPolicy WHERE  TradingPolicyId=@nTradingPolicyID
				SET @out_sProhibitOnQuantity=@nProhibitPreClrOnQuantity
			end
			
			IF(@nBasedOnPerFlag=1 OR @nBasedOnQtyFlag=1)
			BEGIN
				IF(@nProhibitPreClrOnQuantity>@nProhibitPreClrOnPerQty)
				BEGIN			
					IF(@nProhibitPreClrOnQuantity<@nTotQty)
					BEGIN					
						SET @out_nReturnValue =  @ERR_PREQTYEXCEEDTHANQTY
						RETURN (@out_nReturnValue)			   
					END
				END
				ELSE
				BEGIN			
					IF(@nProhibitPreClrOnPerQty<@nTotQty)
					BEGIN			
						SET @out_nReturnValue =  @ERR_PREQTYEXCEEDTHANPER
						RETURN (@out_nReturnValue)					
					END
				END
			END			
		END	
	END
/*---------- 25% AND 50000 LOGIC CLOSED --------*/
END
/*--------------------------------------------End for Airtel Customization---------------------------------------------------*/			

INSERT INTO tra_PreclearanceRequest(PreclearanceRequestForCodeId,UserInfoId,UserInfoIdRelative,TransactionTypeCodeId,
		SecurityTypeCodeId,SecuritiesToBeTradedQty,PreclearanceStatusCodeId,CompanyId,ProposedTradeRateRangeFrom,
		ProposedTradeRateRangeTo,DMATDetailsID,ReasonForNotTradingCodeId,ReasonForNotTradingText,SecuritiesToBeTradedValue, IsAutoApproved,
		CreatedBy,CreatedOn,ModifiedBy,ModifiedOn, ESOPExcerciseOptionQtyFlag, OtherESOPExcerciseOptionQtyFlag, 
		ESOPExcerciseOptionQty, OtherExcerciseOptionQty, PledgeOptionQty, ModeOfAcquisitionCodeId,PreclearanceApprovedBy,PreclearanceApprovedOn,SecuritiesToBeTradedQtyOld,CurrencyID)
VALUES (
		@inp_iPreclearanceRequestForCodeId,@inp_iUserInfoId,@inp_iUserInfoIdRelative,@inp_iTransactionTypeCodeId,
		@inp_iSecurityTypeCodeId,@inp_dSecuritiesToBeTradedQty,@inp_iPreclearanceStatusCodeId,@inp_iCompanyId,@inp_dProposedTradeRateRangeFrom,
		@inp_dProposedTradeRateRangeTo,@inp_iDMATDetailsID,@inp_iReasonForNotTradingCodeId,@inp_sReasonForNotTradingText,@inp_dSecuritiesToBeTradedValue, @bIsAutoApprove,
		@inp_nUserId, dbo.uf_com_GetServerDate(), @inp_nUserId, dbo.uf_com_GetServerDate(), @inp_bESOPExcerciseOptionQtyFlag, @inp_bOtherESOPExcerciseOptionQtyFlag,
		@nESOPExcerciseOptionQty, @nOtherExcerciseOptionQty, @nPledgeOptionQty, @inp_iModeOfAcquisitionCodeId,@nPreclearanceApprovedBy,@dtPreclearanceApprovedOn,@inp_dSecuritiesToBeTradedQty,@inp_Currency)
						
					SET @inp_nPreclearanceRequestId = SCOPE_IDENTITY()
				
					EXEC @out_nReturnValue = st_tra_TradingTransactionMasterCreate 0,@inp_nPreclearanceRequestId,@inp_iUserInfoId,@nContinousDisclosureType,
			    												@nDisclosureStatusNotConfirmed,0,@nTradingPolicyID,NULL,NULL,NULL,NULL,NULL,
			    												@inp_nUserId,NULL,0,@out_nReturnValue = @out_nReturnValue OUTPUT,@out_nSQLErrCode = @out_nSQLErrCode OUTPUT,
																@out_sSQLErrMessage = @out_sSQLErrMessage OUTPUT

					IF @bIsAutoApprove = 1
					BEGIN
						DECLARE @out_PreclearanceValidityDate DATETIME

						SELECT @out_PreclearanceValidityDate=EventDate FROM eve_EventLog WHERE MapToId=@inp_nPreclearanceRequestId and EventCodeId=153018
						update tra_PreclearanceRequest SET
						PreclearanceValidityDateOld=@out_PreclearanceValidityDate
												WHERE PreclearanceRequestId = @inp_nPreclearanceRequestId
					End
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
										AND TransactionStatusCodeId = @nDiscStatusDocUploaded)
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
										AND TransactionStatusCodeId <> @nDiscStatusDocUploaded)
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
						WHERE TransactionStatusCodeId = @nDisclosureStatusNotConfirmed AND TM.PreclearanceRequestId = @inp_nPreclearanceRequestId
						
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

						-- For Vedanta 
						IF EXISTS (SELECT * FROM NonTradingDays WHERE NonTradDay = CONVERT(datetime, @inp_PreclearanceValidityDateUpdatedByCO))
					    BEGIN
						  SET @out_nReturnValue = @ERR_NonTradingDays
		                  RETURN @out_nReturnValue
					    END

						UPDATE tra_PreclearanceRequest
						SET SecuritiesToBeTradedQty = @inp_dSecuritiesToBeTradedQty,
						    OtherExcerciseOptionQty = @inp_dSecuritiesToBeTradedQty,
						    PreclearanceValidityDateOld = @inp_PreclearanceValidityDateOld,
							PreclearanceValidityDateUpdatedByCO = @inp_PreclearanceValidityDateUpdatedByCO
						WHERE PreclearanceRequestId = @inp_nPreclearanceRequestId


						IF (@inp_iPreclearanceStatusCodeId = @nPreClearanceStatus_Approve AND @nIsPreClearanceEditable = 524001)
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
		
/*--------------------------------------------Logic implemented for Not Traded---------------------------------------------------*/
   IF @inp_iReasonForNotTradingCodeId IS NOT NULL OR @inp_iReasonForNotTradingCodeId <> 0
	BEGIN	
		
		DECLARE @nPreApprovedStatus INT =144002 ---Approved		
		DECLARE @nNotTradeResonCodeId INT=0 
		DECLARE @nMapToTypeCodeId INT=132004
		DECLARE @nMapToId INT=0
		DECLARE @nModifiedBy INT=0
		DECLARE @nUserInfoId INT = 0
		DECLARE @nEventCodeID_PreClearanceNotTraded INT =153068 --Not Traded

		SELECT @nNotTradeResonCodeId = MAX(ReasonForNotTradingCodeId) FROM tra_PreclearanceRequest WHERE PreclearanceRequestId = @inp_nPreclearanceRequestId				
	
		SELECT @nPreApprovedStatus= MAX(PreclearanceStatusCodeId)FROM tra_PreclearanceRequest WHERE PreclearanceStatusCodeId=@nPreApprovedStatus and PreclearanceRequestId = @inp_nPreclearanceRequestId
	

		SELECT  @nMapToId=MAX(PreclearanceRequestId) FROM tra_PreclearanceRequest WHERE PreclearanceRequestId = @inp_nPreclearanceRequestId
	

		SELECT @nModifiedBy = max(ModifiedBy) FROM tra_PreclearanceRequest WHERE PreclearanceRequestId = @inp_nPreclearanceRequestId 
		

		SELECT @nUserInfoId = max(UserInfoId) FROM tra_PreclearanceRequest WHERE PreclearanceRequestId = @inp_nPreclearanceRequestId 
		

		IF(@nPreApprovedStatus=144002 AND @nNotTradeResonCodeId IS NOT NULL)
		BEGIN		
		 IF(NOT EXISTS(SELECT EventLogId From eve_EventLog WHERE UserInfoId = @nUserInfoId AND MapToTypeCodeId = @nMapToTypeCodeId AND MapToId = @nMapToId AND EventCodeId = @nEventCodeID_PreClearanceNotTraded))
			BEGIN			
				INSERT INTO eve_EventLog(EventCodeId, EventDate, UserInfoId, MapToTypeCodeId, MapToId, CreatedBy)
						VALUES(@nEventCodeID_PreClearanceNotTraded,dbo.uf_com_GetServerDate(),@nUserInfoId, @nMapToTypeCodeId, @nMapToId, @nModifiedBy)
			END 
		END	
	END

/*--------------------------------------------Logic implemented for Not Traded---------------------------------------------------*/	
	
		--drop tem table
		DROP TABLE #temp
		DROP TABLE #tmpTrading
		
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