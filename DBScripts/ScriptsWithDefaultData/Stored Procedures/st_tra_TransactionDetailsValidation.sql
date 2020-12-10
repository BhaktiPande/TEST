IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_tra_TransactionDetailsValidation')
DROP PROCEDURE [dbo].[st_tra_TransactionDetailsValidation]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Procedure to check whether the data to be entered for new entry or updation is valid.

Returns:		0, if Success.
				
Created by:		Arundhati
Created on:		12-May-2015

Modification History:
Modified By		Modified On		Description
Arundhati		01-Jun-2015		While checking preclearance user, if Relative's id is null, compare it with UserInfoId
Arundhati		01-Jun-2015		Preclearance id was not considered in where clause while checking against preclearance request.
Arundhati		26-Jun-2015		Case #26 is added. For continuous disclosure, all transaction must have same security type.
Arundhati		02-Jul-2015		Condition for case #5 is changed
Arundhati		07-Jul-2015		Added check for date of acquisition for Period end disclosure details.
Arundhati		08-Jul-2015		In case of transaction limit crosses the limit set in preclearance, raise warning, do not return from procedure
Amar			21-Jul-2015		Change the decimal(5,0) to (10,0) for @inp_dQuantity.
Parag			24-Sep-2015		Case #28. in case of pre-clearance, add check that date Of acquisition must be greater than date of approval.
Parag			09-Oct-2015		Made change for period end disclouser, get period end type set in trading policy (in case #4, #5, #27)
Parag			19-Oct-2015		Made change add validation that date of acquisition should be greater than date of initial disclosure  (case #32)
Parag			31-Oct-2015		Made change to use correct period type for validation 
Arundhati		31-Oct-2015		Codes (dates) for Period end date are changed. Now that are stored as the 1st of next month.
Parag			23-Nov-2015		Made change to handle condition when period end disclosure is not applicable for user
Tushar			02-Dec-2015		Added Column related to the Contra Trade change and add check for contra trade change
Tushar			03-Dec-2015		Bugs fix check validation in third setting rule.
Parag			05-Dec-2015		check for when first transcation is enter, that transcation should be between current period applicable
Parag			06-Dec-2015		Add Error message for Case #36 -- Transcation details must be entered should be for the applicable period.
Tushar			08-Dec-2015		Datatype change for INT to decimal for @inp_dESOPExcerciseOptionQty & @inp_dOtherExcerciseOptionQty
Parag			08-Dec-2015		Made chagne to fix last date issue in case of leap year for Feb
Parag			28-Dec-2015		Made change to fix issue of not able to enter transcation detail when period end disclosure is not applicable
Parag			25-Jan-2016		Made change to fix issue of "Arithmetic overflow error converting expression to data type int." occured when input quantity is 10 digit
								NOTE: "@nTotalTradingQuantity" field set to decimal same as value 
Gaurishankar	25-Feb-2016		Added check for - User should not save transaction details for another transaction master.
								- User should not edit or save transaction details after submitting the transaction.
Tushar			09-Mar-2016		Change related to Selection of QTY Yes/No configuration. 
								(Based on contra trade functionality)
Tushar			21-Apr-2016		Non negative balance validation for contra trade option- without quantity base.
Tushar			03-May-2016		Change the validation when user enter continuous disclosure. Check Date of acquisition of initial disclosure instead of 
								the submission date for allowing continuous disclosure submission. Date of acquisition for all continuous disclosure 
								must be greater than the Date of acquisition of initial disclosure
Tushar			14-Jun-2016		Changes for applying pool based validations for security types other than shares 
Gaurishankar	09-Aug-2016		Change for Allow Negative Balance. 
Parag			18-Aug-2016		Code merge with ESOP code
Tushar			06-Sep-2016		Change for maintaining DMAT wise pool and related validation.

Raghvendra		07-Sep-2016		Changed the GETDATE() call with function dbo.uf_com_GetServerDate(). This function will return the date to be used as server date.
Usage:
EXEC 
-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_tra_TransactionDetailsValidation]
	@inp_iTransactionDetailsId			BIGINT,
	@inp_iTransactionMasterId			BIGINT,
	@inp_iSecurityTypeCodeId			INT,
	@inp_iForUserInfoId					INT,
	@inp_iDMATDetailsID					INT,
	@inp_iCompanyId						INT,
	--@inp_dNoOfSharesVotingRightsAcquired decimal(5, 0),
	--@inp_dPercentageOfSharesVotingRightsAcquired decimal(4, 2),
	@inp_dtDateOfAcquisition			DATETIME,
	@inp_dtDateOfInitimationToCompany	DATETIME,
	@inp_iModeOfAcquisitionCodeId		INT ,
	--@inp_dShareHoldingSubsequentToAcquisition decimal(5, 0),
	@inp_iExchangeCodeId				INT,
	@inp_iTransactionTypeCodeId			INT,
	@inp_dQuantity						DECIMAL(10, 0),
	@inp_dValue							DECIMAL(10, 0),
	@inp_iLoggedInUserId				INT,
	@inp_dESOPExcerciseOptionQty		DECIMAL(10, 0),
	@inp_dOtherExcerciseOptionQty		DECIMAL(10, 0),
	@inp_bESOPExcerseOptionQtyFlag		BIT,
	@inp_bOtherESOPExcerseOptionFlag	BIT,
	@inp_iLotSize                       INT,
	@out_nWarningMsg					INT = 0 OUTPUT,
	@out_nReturnValue					INT = 0 OUTPUT,
	@out_nSQLErrCode					INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage					VARCHAR(500) = '' OUTPUT  -- Output SQL Error Message, if error occurred.	
AS
BEGIN
	
	DECLARE @sSQL								NVARCHAR(MAX) = ''
	DECLARE @ERR_TRANSACTIONDETAILS_VALIDATION	INT = 17042 -- Error occurred while validating transaction entry.
	
	/************  Constants  *******************/
	-- Disclosure type {Initial / Continuous / Period End}
	DECLARE @nDisclosureType_Initial			INT = 147001
	DECLARE @nDisclosureType_Continuous			INT = 147002
	DECLARE @nDisclosureType_PeriodEnd			INT = 147003
	
	-- Transaction Type {Buy / Sell}
	DECLARE @nTransaction_Buy					INT	= 143001
	DECLARE @nTransaction_Sell					INT = 143002
	
	-- Security type {Equity / Derivative}
	DECLARE @nSecurityType_Shares				INT = 139001
	DECLARE @nSecurityType_Derivative			INT = 139002
	
	--- Error codes
	DECLARE @ERR_InitialReqBuyTransOnly INT = 17044 -- Case #1 - Transaction mode can only be 'Buy' for initial disclosure.
	DECLARE @ERR_SecurityUserTransaction_NotSameAsPreclearance INT = 17045 -- Case #2 - Security Type, User and transaction should be same as the one defined on preclearance.
	DECLARE @ERR_QtyExceedsLimitInPreclearance INT = 17046 -- Case #3 - Total numbers of trading quantity should not exceed the proposed trade quantity specified in the preclearance request.
	DECLARE @ERR_AllTransactionsShouldFallUnderSamePeriod INT = 17047 -- Case #4 - All the transactions entered together should be for the same period.
	DECLARE @ERR_ContiDisclosureNotAllowed_PEExists INT = 17048 -- Case #5 - Cannot save details for continuous disclosure, since period end disclosure for the future period is made.
	DECLARE @ERR_ContiDisclosureNotAllowed_PreclearanceRejected INT = 17060 -- Case #6 - If Preclearance request is rejected, user should not enter details against it
	DECLARE @ERR_SECURITYTYPEDOESNOTMATCH INT = 17327 -- case # 26 - Security type cannot be different for transactions of continuous disclosure.
	DECLARE @ERR_AcqDateShouldBeInThePeriodRange INT = 17331 -- Case #27 - Check while adding period end disclosure that the date is in the range of the selected period.
	DECLARE @ERR_AcqDateShouldBeGreaterThanPreclearanceApproveDate INT = 17389 -- case #28 - Date Of acquisition must be greater than date of approval. (in case of pre-clearance)
	DECLARE @ERR_AcqDateShouldBeGreaterThanInitialDisclosure INT = 17395 -- case #32 - Date Of acquisition must be greater than date of initial disclosure.
	DECLARE @ERR_QTYSUMERROR INT  = 16328  -- Case #34 Number of shares or Units must be sum of ESOP Excercise Qty and Other than ESOP Excercise Qty.
	DECLARE @ERR_NonNegativeNumberESOPAndOtherQty INT = 16329 -- Case #35 Enter valid data for ESOP Excercise Qty and Other than ESOP Excercise Qty.
	DECLARE @ERR_SELECTATLEASTONEPOOL INT = 16330 -- Case #36 Please select at least one option of exercise pool.', 'Please select at least one option of exercise pool.', 'en-US', 103008, 104001,122036, 1, dbo.uf_com_GetServerDate())
	DECLARE @ERR_TransactionDetailsForApplicablePeriod INT = 16331 -- Case #36 Transcation details must be entered should be for the applicable period.
	DECLARE @ERR_InitialDisclosureforRelative INT = 50777 -- Case #37 Enter initial disclosuer for relative first.
	-- Variables
	DECLARE @nDisclosureType INT
	DECLARE @ERR_TRANSACTIONMASTER_SAVE INT = 16092
	----DECLARE @nSecurityType INT
	DECLARE @nPreclearanceId INT
	DECLARE @nTotalTradingQuantity DECIMAL(25, 4)
	DECLARE @nTotalTradingValue DECIMAL(25,4)
	DECLARE @nTransactionDetailsIdOld INT

	DECLARE @nPeriodType INT
	DECLARE @nYear INT
	DECLARE @dtDateOfAcqOld DATETIME
	DECLARE @nYearCodeIdOld INT
	DECLARE @nPeriodCodeIdOld INT
	DECLARE @nYearCodeIdNew INT
	DECLARE @nPeriodCodeIdNew INT
	
	DECLARE @dtPeriodEndForContinuous DATETIME
	DECLARE @nUserInfoId INT
	DECLARE @dtMaxDateOfAcquisition DATETIME
	DECLARE @RC INT
	
	DECLARE @dtEventDate DATETIME
	DECLARE @nEvent_Preclearance_Approve INT = 153016
	DECLARE @nMapToTypeCode_Preclearance INT = 132004
	
	DECLARE @nEvent_Initial_Disclosure_Enter INT = 153007
	DECLARE @nMapToTypeCode_Disclosure INT = 132005
	
	DECLARE @nPeriodTypeOld INT
	
	DECLARE @dtCurrentDate DATETIME = dbo.uf_com_GetServerDate()
	
	DECLARE @nTmpRet INT = 0
	
	DECLARE @nGenCashAndCashlessPartialExciseOptionForContraTrade INT
	
	DECLARE @dtNULLDate DATETIME = '1970-01-01'
	
	DECLARE @nDisclosureStatusForDocumentUploaded INT = 148001
	DECLARE @nDisclosureStatusForNotConfirmed INT = 148002
	
	DECLARE @nContraTradeOption				INT
	DECLARE @nContraTradeGeneralOption		INT = 175001
	DECLARE @nContraTradeQuantityBase		INT = 175002
	
	DECLARE @nTransactionType_Pledge       INT = 143006
	DECLARE @nTransactionType_PledgeRevoke INT = 143007
	DECLARE @nTransactionType_PledgeInvoke INT = 143008
	DECLARE @nLess INT = 505002
	DECLARE @nNo   INT = 505004
	DECLARE @nImptPostshareQtyCodeId INT
	DECLARE @nActionCodeId INT
	DECLARE @nBuy          INT = 504001
	DECLARE @nSell         INT = 504002

	DECLARE @out_nClosingBalance		DECIMAL(10,0) = 0
	DECLARE @out_nPledgeClosingBalance	DECIMAL(10,0) = 0
	DECLARE @ERR_NEGATIVEERRORMESSAGE	INT = 16430
	DECLARE @nUserInfoId_FromRelative   INT
	DECLARE @nUserType_Relative         INT = 101007
	DECLARE @nTransactionTypeCodeId     INT = NULL
	DECLARE @nModeOfAcquisitionCodeId   INT
	DECLARE @nQuantity                  DECIMAL(10,0)	
	DECLARE @nShareSecurityType			INT = 139001
	DECLARE @nPledgeQuantity            INT
	DECLARE @nPeriodCodeId              INT = 124001

	DECLARE @nImptPostshareQtyCodeId_ForPledge INT
	DECLARE @nActionCodeId_ForPledge INT
	DECLARE @bIsAllowNegativeBalance BIT
	BEGIN TRY
		
		SET NOCOUNT ON;
		-- Declare variables
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''

		
		SELECT @nPreclearanceId = PreclearanceRequestId,
			@nDisclosureType = DisclosureTypeCodeId
		FROM tra_TransactionMaster 
		WHERE TransactionMasterId = @inp_iTransactionMasterId
		
		-- Fetch Contra Trade Option
		SELECT @nContraTradeOption = ContraTradeOption
		FROM mst_Company WHERE IsImplementing = 1
		
		select @nImptPostshareQtyCodeId = impt_post_share_qty_code_id, @nActionCodeId = action_code_id from tra_TransactionTypeSettings where trans_type_code_id = @inp_itransactiontypecodeid and mode_of_acquis_code_id = @inp_imodeofacquisitioncodeid and security_type_code_id = @inp_iSecurityTypeCodeId
		
		SELECT @nGenCashAndCashlessPartialExciseOptionForContraTrade = TP.GenCashAndCashlessPartialExciseOptionForContraTrade FROM tra_TransactionMaster TM
		JOIN rul_TradingPolicy TP ON TM.TradingPolicyId = TP.TradingPolicyId
		WHERE TransactionMasterId = @inp_iTransactionMasterId
		IF (@inp_iTransactionDetailsId != 0 AND NOT EXISTS (SELECT TransactionDetailsId FROM tra_TransactionDetails WHERE TransactionMasterId = @inp_iTransactionMasterId AND TransactionDetailsId = @inp_iTransactionDetailsId))
		BEGIN
			SET @out_nReturnValue = @ERR_TRANSACTIONMASTER_SAVE
			RETURN @out_nReturnValue
		END
		IF ( NOT EXISTS (SELECT TransactionMasterId FROM tra_TransactionMaster WHERE TransactionMasterId = @inp_iTransactionMasterId AND TransactionStatusCodeId IN(@nDisclosureStatusForDocumentUploaded,@nDisclosureStatusForNotConfirmed)))
		BEGIN
			SET @out_nReturnValue = @ERR_TRANSACTIONMASTER_SAVE
			RETURN @out_nReturnValue
		END
		-- Validation Checks for initial disclosures
		IF @nDisclosureType = @nDisclosureType_Initial
		BEGIN
			-- If disclosure type = initial, transaction mode must be ‘buy’.
			-- Case #1
			EXEC @nTmpRet = st_tra_IsAllowNegativeBalanceForSecurity @inp_iSecurityTypeCodeId,@bIsAllowNegativeBalance OUTPUT,
						@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT, @out_sSQLErrMessage OUTPUT

				IF @out_nReturnValue <> 0
				BEGIN
					SET @out_nReturnValue = @out_nReturnValue --@ERR_CHECKISALLOWNEGATIVEBALANCE
					RETURN @out_nReturnValue
				END
			IF @bIsAllowNegativeBalance = 1 AND @inp_iTransactionTypeCodeId <> @nTransaction_Buy
			BEGIN
				SET @out_nReturnValue = @ERR_InitialReqBuyTransOnly
				RETURN @out_nReturnValue
			END
			print(1234567)
			--------------------------------------------END Case #1 ------------------------------------------------------------------			
		    --ESOP Excercise Qty and Other than ESOP Excercise Qty non negative number accept
				-- Case #35
			IF (@inp_iSecurityTypeCodeId = @nSecurityType_Shares AND @inp_dESOPExcerciseOptionQty<0 OR @inp_dOtherExcerciseOptionQty < 0)
			BEGIN
				SET @out_nReturnValue = @ERR_NonNegativeNumberESOPAndOtherQty
				RETURN @out_nReturnValue
			END			
			--------------------------------------------END Case #35 ------------------------------------------------------------------	
		
		
			-- Sum is Quanity = ESOP qty+ Other Qty
			-- Case #34
			IF ( @inp_iSecurityTypeCodeId = @nSecurityType_Shares AND @inp_dQuantity <> @inp_dESOPExcerciseOptionQty + @inp_dOtherExcerciseOptionQty)
			BEGIN			
				SET @out_nReturnValue = @ERR_QTYSUMERROR
				print('@out_nReturnValue')
				print(@out_nReturnValue)
				RETURN @out_nReturnValue
			END
			
			--------------------------------------------END Case #34 ------------------------------------------------------------------	
			
		END
		ELSE 
		BEGIN
			IF @nDisclosureType = @nDisclosureType_Continuous
			BEGIN
				IF @nPreclearanceId IS NOT NULL
				BEGIN
					print '	CASE #2 '
					-- When preclearance is taken, then security type {Equity / Derivative}, user id {Self / Relative’s id}, 
					-- transaction mode {Buy / Sell} should be blocked or should be same as the one defined in preclearance request.
					-- Case #2
					IF NOT EXISTS (SELECT PreclearanceRequestId FROM tra_PreclearanceRequest 
									WHERE PreclearanceRequestId = @nPreclearanceId
										AND SecurityTypeCodeId = @inp_iSecurityTypeCodeId
										AND ISNULL(UserInfoIdRelative, UserInfoId) = ISNULL(@inp_iForUserInfoId, 0)
										AND TransactionTypeCodeId = @inp_iTransactionTypeCodeId)
					BEGIN
						SET @out_nReturnValue = @ERR_SecurityUserTransaction_NotSameAsPreclearance
						RETURN @out_nReturnValue			
					END
					----------------------------------------------END Case #2 ----------------------------------------------------------------
					
					print '	CASE #3 '							
					-- Allow the user to enter transactions (total number of shares) up to the no of securities for which preclearance is taken. 
					-- CASE #3
					-- The system should allow user to add quantity though it exceeds the preclearance limits. Just give user a message
					SELECT @nTotalTradingQuantity = @inp_dQuantity + SUM(ISNULL(Quantity + Quantity2, 0)),
						@nTotalTradingValue = @inp_dValue + SUM(ISNULL(Value + Value2, 0))
					FROM tra_TransactionDetails 
					WHERE TransactionMasterId = @inp_iTransactionMasterId
						AND TransactionDetailsId <> @inp_iTransactionDetailsId
					
					IF @nTotalTradingQuantity IS NULL
					BEGIN
						SELECT @nTotalTradingQuantity = @inp_dQuantity,
								@nTotalTradingValue = @inp_dValue
					ENd

					IF EXISTS (SELECT * FROM tra_PreclearanceRequest PR WHERE PreclearanceRequestId = @nPreclearanceId AND (PR.SecuritiesToBeTradedQty < @nTotalTradingQuantity OR PR.SecuritiesToBeTradedValue < @nTotalTradingValue))
					BEGIN
						SET @out_nWarningMsg = @ERR_QtyExceedsLimitInPreclearance
						--RETURN @out_nReturnValue
					END
					----------------------------------------------END Case #3----------------------------------------------------------------
					
					print '	CASE #6 '
					-- If Preclearance request is rejected, user should not enter details against it
					-- CASE #6
					IF EXISTS (SELECT * FROM tra_PreclearanceRequest WHERE PreclearanceRequestId = @nPreclearanceId AND PreclearanceStatusCodeId = 144003)
					BEGIN
						SET @out_nReturnValue = @ERR_ContiDisclosureNotAllowed_PreclearanceRejected
						RETURN @out_nReturnValue					
					END
					----------------------------------------------END Case #6 ----------------------------------------------------------------
					
					print ' CASE #28 '
					-- While saving transaction details for pre-clearance taken, 
					-- check that date of acquisition must be greater than date of approval of per-clearance
					-- CASE #28
					SELECT @dtEventDate = EL.EventDate FROM eve_EventLog EL 
					WHERE EL.MapToTypeCodeId = @nMapToTypeCode_Preclearance AND EL.EventCodeId = @nEvent_Preclearance_Approve AND EL.MapToId = @nPreclearanceId
					IF @inp_dtDateOfAcquisition < convert(date,@dtEventDate)
					BEGIN
						SET @out_nReturnValue = 0 -- @ERR_AcqDateShouldBeGreaterThanPreclearanceApproveDate
						--RETURN @out_nReturnValue
					END
					----------------------------------------------END Case #28 ----------------------------------------------------------------
					
					----------------------------------------------Case #37 ----------------------------------------------------------------
					print('@inp_iForUserInfoId')
					print(@inp_iForUserInfoId)
					IF (NOT EXISTS (SELECT TM.TransactionMasterId FROM tra_TransactionMaster TM 
						JOIN tra_TransactionDetails TD ON TM.TransactionMasterId=TD.TransactionMasterId 
						WHERE TM.DisclosureTypeCodeId in (@nDisclosureType_Initial,@nDisclosureType_Continuous,@nDisclosureType_PeriodEnd)		
						 AND TD.ForUserInfoId=@inp_iForUserInfoId))
					BEGIN
							SET @out_nReturnValue = @ERR_InitialDisclosureforRelative
							RETURN @out_nReturnValue
					END	
				----------------------------------------------END Case #37 ----------------------------------------------------------------
				
					
				END
				ELSE
				BEGIN
					-- Security type cannot be different for transactions of continuous disclosure.
					-- CASE #26
					IF EXISTS (SELECT TransactionMasterId FROM tra_TransactionMaster WHERE TransactionMasterId = @inp_iTransactionMasterId AND SecurityTypeCodeId IS NOT NULL)
					BEGIN
						IF NOT EXISTS(SELECT TransactionMasterId FROM tra_TransactionMaster WHERE TransactionMasterId = @inp_iTransactionMasterId AND SecurityTypeCodeId = @inp_iSecurityTypeCodeId)
						BEGIN
						SET @out_nReturnValue = @ERR_SECURITYTYPEDOESNOTMATCH
						RETURN @out_nReturnValue
						END
					END
					----------------------------------------------END Case #26 ----------------------------------------------------------------
					
					---------------Case #36--------------------------------
				IF(@nGenCashAndCashlessPartialExciseOptionForContraTrade = 172003 AND (@inp_bESOPExcerseOptionQtyFlag IS NULL OR @inp_bESOPExcerseOptionQtyFlag = 0) 
				AND (@inp_bOtherESOPExcerseOptionFlag IS NULL OR @inp_bOtherESOPExcerseOptionFlag = 0) AND @inp_iSecurityTypeCodeId = @nSecurityType_Shares
				AND @inp_iTransactionTypeCodeId = @nTransaction_Sell
				AND @nContraTradeOption = @nContraTradeQuantityBase)
				BEGIN
					SET @out_nReturnValue = @ERR_SELECTATLEASTONEPOOL
					RETURN @out_nReturnValue
				END
				---------------------------------------------END Case #36 ----------------------------------------------------------------
					
					-- Check availabale balance in Excercise pool
				-- if Transaction type Sell and Secuority Type Shares
				---------------Case #33--------------------------------
				IF(@nImptPostshareQtyCodeId = @nLess)--AND @inp_iSecurityTypeCodeId = @nSecurityType_Shares)
				--AND @nContraTradeOption = @nContraTradeQuantityBase)
				BEGIN
					EXEC @nTmpRet = st_tra_TransactionExcercisePoolValidation @inp_iTransactionDetailsID,@inp_iTransactionMasterId,@inp_iForUserInfoId,
									@inp_dQuantity,@inp_bESOPExcerseOptionQtyFlag,@inp_bOtherESOPExcerseOptionFlag,@inp_iSecurityTypeCodeId,'OtherQty',@inp_iLotSize,@inp_iDMATDetailsID,@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT, @out_sSQLErrMessage OUTPUT
			
					IF @out_nReturnValue <> 0
					BEGIN
						SET @out_nReturnValue = @out_nReturnValue--@ERR_TRANSACTIONMASTER_SAVE
						RETURN @out_nReturnValue
					END
				END
				
				
				--- Check availabale balance in Excercise pool for pledge quantity
				IF((@inp_iTransactionTypeCodeId = @nTransactionType_Pledge OR @inp_iTransactionTypeCodeId = @nTransactionType_PledgeRevoke OR @inp_iTransactionTypeCodeId = @nTransactionType_PledgeInvoke) AND @nImptPostshareQtyCodeId = @nNo AND @nActionCodeId = @nSell)--AND @inp_iSecurityTypeCodeId = @nSecurityType_Shares)
				--AND @nContraTradeOption = @nContraTradeQuantityBase)
				BEGIN
					EXEC @nTmpRet = st_tra_TransactionExcercisePoolValidation @inp_iTransactionDetailsID,@inp_iTransactionMasterId,@inp_iForUserInfoId,
									@inp_dQuantity,@inp_bESOPExcerseOptionQtyFlag,@inp_bOtherESOPExcerseOptionFlag,@inp_iSecurityTypeCodeId,'PledgeQty',@inp_iLotSize,@inp_iDMATDetailsID,@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT, @out_sSQLErrMessage OUTPUT
			
					IF @out_nReturnValue <> 0
					BEGIN
						SET @out_nReturnValue = @out_nReturnValue--@ERR_TRANSACTIONMASTER_SAVE
						RETURN @out_nReturnValue
					END
				END
				
				IF((@inp_iTransactionTypeCodeId = @nTransactionType_Pledge OR @inp_iTransactionTypeCodeId = @nTransactionType_PledgeRevoke OR @inp_iTransactionTypeCodeId = @nTransactionType_PledgeInvoke) AND @nImptPostshareQtyCodeId = @nNo AND @nActionCodeId = @nBuy)--AND @inp_iSecurityTypeCodeId = @nSecurityType_Shares)
				BEGIN				     
				     IF((select UserTypeCodeId from usr_UserInfo where UserInfoId = @inp_iForUserInfoId) = @nUserType_Relative)
				     BEGIN
				       select @nUserInfoId_FromRelative = UserInfoId from usr_UserRelation where UserInfoIdRelative = @inp_iForUserInfoId
				     END
				     ELSE
				     BEGIN
				        set @nUserInfoId_FromRelative = @inp_iForUserInfoId
				     END
				    
				    DECLARE TransactionDetail_CursorForPleadge CURSOR FOR 
							SELECT TransactionTypeCodeId,ModeOfAcquisitionCodeId, Quantity FROM tra_TransactionDetails 
							WHERE TransactionMasterId = @inp_iTransactionMasterId AND SecurityTypeCodeId = @nShareSecurityType AND TransactionTypeCodeId IN (@nTransactionType_Pledge,@nTransactionType_PledgeRevoke,@nTransactionType_PledgeInvoke) AND ForUserInfoId = @inp_iForUserInfoId AND TransactionDetailsId != @inp_iTransactionDetailsID
	 
						OPEN TransactionDetail_CursorForPleadge
						
						FETCH NEXT FROM TransactionDetail_CursorForPleadge INTO 
							@nTransactionTypeCodeId, @nModeOfAcquisitionCodeId, @nQuantity
							
						SET @nPledgeQuantity = 0
						
						WHILE @@FETCH_STATUS = 0
						BEGIN
								
							select @nImptPostshareQtyCodeId_ForPledge = impt_post_share_qty_code_id, @nActionCodeId_ForPledge = action_code_id from tra_TransactionTypeSettings where trans_type_code_id = @nTransactionTypeCodeId and mode_of_acquis_code_id = @nModeOfAcquisitionCodeId and security_type_code_id = @inp_iSecurityTypeCodeId	
								
							IF(@nImptPostshareQtyCodeId_ForPledge = @nNo AND @nActionCodeId_ForPledge = @nBuy)	
							BEGIN							        						
							  SET @nPledgeQuantity = @nPledgeQuantity + @nQuantity
							END
							
							FETCH NEXT FROM TransactionDetail_CursorForPleadge INTO 
								@nTransactionTypeCodeId, @nModeOfAcquisitionCodeId, @nQuantity 	
							
						END
						
						CLOSE TransactionDetail_CursorForPleadge
						DEALLOCATE TransactionDetail_CursorForPleadge;
						
				    SELECT TOP 1 @out_nPledgeClosingBalance =  PledgeClosingBalance FROM [dbo].[tra_TransactionSummary]  WHERE PeriodCodeId = @nPeriodCodeId  AND UserInfoId = @nUserInfoId_FromRelative AND UserInfoIdRelative = @inp_iForUserInfoId AND SecurityTypeCodeId = @inp_iSecurityTypeCodeId  ORDER BY TransactionSummaryId DESC
				    
					EXEC @nTmpRet = st_tra_GetClosingBalanceOfAnnualPeriod @nUserInfoId_FromRelative, @inp_iForUserInfoId, @inp_iSecurityTypeCodeId, @out_nClosingBalance OUTPUT, @out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT, @out_sSQLErrMessage OUTPUT
			
					IF @inp_dQuantity + @nPledgeQuantity + @out_nPledgeClosingBalance > @out_nClosingBalance
					BEGIN
						SET @out_nReturnValue = @ERR_NEGATIVEERRORMESSAGE   --@ERR_TRANSACTIONMASTER_SAVE
						RETURN @out_nReturnValue
					END
				END				
				----------------------------------------------END Case #33 ----------------------------------------------------------------
				----------------------------------------------Case #37 ----------------------------------------------------------------
					IF (NOT EXISTS (SELECT TM.TransactionMasterId FROM tra_TransactionMaster TM 
						JOIN tra_TransactionDetails TD ON TM.TransactionMasterId=TD.TransactionMasterId 
						WHERE TM.DisclosureTypeCodeId in (@nDisclosureType_Initial,@nDisclosureType_Continuous,@nDisclosureType_PeriodEnd)
						AND TD.ForUserInfoId=@inp_iForUserInfoId))
					BEGIN
							SET @out_nReturnValue = @ERR_InitialDisclosureforRelative
							RETURN @out_nReturnValue
					END	
				----------------------------------------------END Case #37 ----------------------------------------------------------------
				END			
				
			END
			ELSE IF @nDisclosureType = @nDisclosureType_PeriodEnd
			BEGIN
				print 'Period End Disclosure checks'
				-- Check while adding period end disclosure that the date is in the range of the selected period. 
				-- Case #27
				
				SELECT @nPeriodType = CASE 
										WHEN TP.DiscloPeriodEndFreq = 137001 THEN 123001 -- Yearly
										WHEN TP.DiscloPeriodEndFreq = 137002 THEN 123003 -- Quarterly
										WHEN TP.DiscloPeriodEndFreq = 137003 THEN 123004 -- Monthly
										WHEN TP.DiscloPeriodEndFreq = 137004 THEN 123002 -- half yearly
										ELSE TP.DiscloPeriodEndFreq 
									 END 
				FROM tra_TransactionMaster TM 
				JOIN tra_UserPeriodEndMapping UPEMap ON UPEMap.PEEndDate = TM.PeriodEndDate AND UPEMap.UserInfoId = TM.UserInfoId
															AND TM.TransactionMasterId = @inp_iTransactionMasterId
				JOIN rul_TradingPolicy TP ON UPEMap.TradingPolicyId = TP.TradingPolicyId 
				
				EXECUTE @RC = [st_tra_PeriodEndDisclosureStartEndDate2] 
				   @nYearCodeIdNew OUTPUT
				  ,@nPeriodCodeIdNew OUTPUT
				  ,@inp_dtDateOfAcquisition
				  ,@nPeriodType
				  ,0
				  ,@dtDateOfAcqOld OUTPUT
				  ,@dtPeriodEndForContinuous OUTPUT
				  ,@out_nReturnValue OUTPUT
				  ,@out_nSQLErrCode OUTPUT
				  ,@out_sSQLErrMessage OUTPUT
				
				IF NOT EXISTS(SELECT * FROM tra_TransactionMaster
								WHERE TransactionMasterId = @inp_iTransactionMasterId
									AND PeriodEndDate = @dtPeriodEndForContinuous)
				BEGIN
					SET @out_nReturnValue = @ERR_AcqDateShouldBeInThePeriodRange
					RETURN @out_nReturnValue
				END				

				SELECT @nYearCodeIdNew = null, @nPeriodCodeIdNew = null, @dtDateOfAcqOld = null, @dtPeriodEndForContinuous = null
				----------------------------------------------END Case #27 ----------------------------------------------------------------

			END
			
			print 'Common checks for Continuous & Period End disclosure'
			
			-- Transaction should not be allow to enter data before the initial disclosure date
			-- Case #32
			/*SELECT @dtEventDate = EL.EventDate FROM eve_EventLog EL 
			WHERE 
				EL.MapToTypeCodeId = @nMapToTypeCode_Disclosure AND 
				EL.EventCodeId = @nEvent_Initial_Disclosure_Enter AND 
				EL.UserInfoId = (SELECT TM.UserInfoId FROM tra_TransactionMaster TM WHERE TM.TransactionMasterId = @inp_iTransactionMasterId)
				
				*/
				
			SELECT TOP 1 @dtEventDate = TD.DateOfAcquisition FROM tra_TransactionMaster TM
			JOIN tra_TransactionDetails TD ON TM.TransactionMasterId = TD.TransactionMasterId
			WHERE TM.UserInfoId = (SELECT TM.UserInfoId FROM tra_TransactionMaster TM WHERE TM.TransactionMasterId = @inp_iTransactionMasterId)
			AND DisclosureTypeCodeId  = @nDisclosureType_Initial
			ORDER BY DateOfAcquisition DESC
				
			IF CONVERT(DATE, @inp_dtDateOfAcquisition) < CONVERT(DATE,@dtEventDate)
			BEGIN
				SET @out_nReturnValue = @ERR_AcqDateShouldBeGreaterThanInitialDisclosure
				RETURN @out_nReturnValue
			END
			----------------------------------------------END Case #32 ----------------------------------------------------------------
			
			
			-- All the transactions should be within same period. 
			-- E.g. For a quarterly system, 2 entries, 1: for 22nd Jun and 2: for 5th July should not be entered against same TransactionMasterId
			-- Case #4
			SELECT @nTransactionDetailsIdOld = MAX(TransactionDetailsId) 
			FROM tra_TransactionDetails
			WHERE TransactionMasterId = @inp_iTransactionMasterId
				AND TransactionDetailsId <> @inp_iTransactionDetailsId
			
			--print 'TransactionDetailsIdOld = ' + convert(varchar, ISNULL(@nTransactionDetailsIdOld, 0))
			
			IF @nTransactionDetailsIdOld IS NOT NULL
			BEGIN
				SELECT @nPeriodType = CASE 
											WHEN TP.DiscloPeriodEndFreq = 137001 THEN 123001 -- Yearly
											WHEN TP.DiscloPeriodEndFreq = 137002 THEN 123003 -- Quarterly
											WHEN TP.DiscloPeriodEndFreq = 137003 THEN 123004 -- Monthly
											WHEN TP.DiscloPeriodEndFreq = 137004 THEN 123002 -- half yearly
											ELSE TP.DiscloPeriodEndFreq 
										 END 
				FROM tra_TransactionMaster TM 
				JOIN tra_UserPeriodEndMapping UPEMap ON UPEMap.PEEndDate = TM.PeriodEndDate AND UPEMap.UserInfoId = TM.UserInfoId 
															AND TM.TransactionMasterId = @inp_iTransactionMasterId
				JOIN rul_TradingPolicy TP ON UPEMap.TradingPolicyId = TP.TradingPolicyId
				
				
				--get year code id and period code id from earlier date of acquication 
				SELECT @dtDateOfAcqOld = DateOfAcquisition FROM tra_TransactionDetails WHERE TransactionDetailsId = @nTransactionDetailsIdOld
				
				SELECT @nYear = YEAR(@dtDateOfAcqOld) -- Find Year
				
				IF MONTH(@dtDateOfAcqOld) < 4
				BEGIN
					SET @nYear = @nYear - 1
				END

				SELECT @nYearCodeIdOld = CodeID FROM com_Code WHERE CodeGroupId = 125 AND CodeName LIKE CONVERT(VARCHAR(4), @nYear) + '%'

				-- Find PeriodCodeId
				IF (@nPeriodType IS NOT NULL) -- check if PE is appliable or not by checking period type
				BEGIN
					SELECT TOP(1) @nPeriodCodeIdOld = CodeID FROM com_Code 
					WHERE CodeGroupId = 124 AND ParentCodeId = @nPeriodType AND @dtDateOfAcqOld <= DATEADD(DAY, -1, DATEADD(YEAR, @nYear - 1970, CONVERT(DATETIME, Description)))
					ORDER BY CONVERT(DATETIME, Description) ASC
				END
				ELSE
				BEGIN
					-- period end disclosure is not appliable 
					
					SET @nPeriodCodeIdOld = NULL
				END
				
				
				--get year code id and period code id from current date of acquication 
				SELECT @nYear = YEAR(@inp_dtDateOfAcquisition)-- Find Year
				
				IF MONTH(@inp_dtDateOfAcquisition) < 4
				BEGIN
					SET @nYear = @nYear - 1
				END

				SELECT @nYearCodeIdNew = CodeID FROM com_Code WHERE CodeGroupId = 125 AND CodeName LIKE CONVERT(VARCHAR(4), @nYear) + '%'

				-- Find PeriodCodeId
				IF (@nPeriodType IS NOT NULL) -- check if PE is appliable or not by checking period type
				BEGIN
					SELECT TOP(1) @nPeriodCodeIdNew = CodeID FROM com_Code 
					WHERE CodeGroupId = 124 AND ParentCodeId = @nPeriodType AND @inp_dtDateOfAcquisition <= DATEADD(DAY, -1, DATEADD(YEAR, @nYear - 1970, CONVERT(DATETIME, Description)))
					ORDER BY CONVERT(DATETIME, Description) ASC
				END
				ELSE 
				BEGIN
					-- period end disclosure is not appliable 
					
					SET @nPeriodCodeIdNew = NULL
				END
				
				
			
				IF (ISNULL(@nPeriodCodeIdOld,0) <> ISNULL(@nPeriodCodeIdNew,0) OR @nYearCodeIdNew <> @nYearCodeIdOld)
				BEGIN
					SET @out_nReturnValue = @ERR_AllTransactionsShouldFallUnderSamePeriod
					RETURN @out_nReturnValue
				END
			END
			ELSE 
			BEGIN
				-- case to check valid period end date for first transcation details enter 
				-- ie when first transcation is enter, that transcation should be between current period applicable
				DECLARE @dtPEStartDate DATETIME
				DECLARE @dtPEEndDate DATETIME
				DECLARE @dtNextPEStartDate DATETIME
				
				SELECT @dtPEStartDate = UPEMap.PEStartDate, @dtPEEndDate = UPEMap.PEEndDate FROM tra_UserPeriodEndMapping UPEMap 
				JOIN tra_TransactionMaster TM ON ISNULL(UPEMap.PEEndDate,@dtNULLDate) = ISNULL(TM.PeriodEndDate,@dtNULLDate)
				AND TM.PeriodEndDate IS NOT NULL AND UPEMap.UserInfoId = TM.UserInfoId AND TM.TransactionMasterId = @inp_iTransactionMasterId
				
				--print 'start '+convert(varchar, ISNULL(@dtPEStartDate, 'NULL'))+' end '+convert(varchar, ISNULL(@dtPEEndDate, 'NULL'))
				--		+ ' acquistion '+convert(varchar, @inp_dtDateOfAcquisition)
						
				-- check if for current transaction period end date is exists or not 
				IF (@dtPEEndDate IS NOT NULL AND 
						CONVERT(date,@inp_dtDateOfAcquisition) < @dtPEStartDate OR CONVERT(date,@inp_dtDateOfAcquisition) > @dtPEEndDate)
				BEGIN
					SET @out_nReturnValue = @ERR_TransactionDetailsForApplicablePeriod
					RETURN @out_nReturnValue
				END
				
				-- check if current transcation PE date is null ie period end is not applicable 
				IF EXISTS(SELECT PeriodEndDate FROM tra_TransactionMaster 
							WHERE TransactionMasterId = @inp_iTransactionMasterId AND PeriodEndDate IS NULL)
				BEGIN
					SELECT TOP(1) @dtPEStartDate = UPEMap.PEStartDate, @dtPEEndDate = UPEMap.PEEndDate FROM tra_UserPeriodEndMapping UPEMap 
					JOIN tra_TransactionMaster TM ON UPEMap.UserInfoId = TM.UserInfoId AND TM.TransactionMasterId = @inp_iTransactionMasterId
					WHERE UPEMap.PEEndDate IS NULL ORDER BY UPEMap.UserPeriodEndMappingId DESC
					
					SELECT TOP(1) @dtNextPEStartDate = UPEMap.PEStartDate FROM tra_UserPeriodEndMapping UPEMap
					JOIN tra_TransactionMaster TM ON UPEMap.UserInfoId = TM.UserInfoId AND TM.TransactionMasterId = @inp_iTransactionMasterId
					WHERE UPEMap.PEEndDate IS NOT NULL ORDER BY UPEMap.UserPeriodEndMappingId DESC
						
					--print 'Start date'+convert(varchar, ISNULL(@dtPEStartDate, 'NULL')) +'End date'+convert(varchar, ISNULL(@dtPEStartDate, 'NULL'))
					--		+ 'Next Period date'+convert(varchar, ISNULL(@dtPEStartDate, 'NULL'))
					
					-- check if start date exists where period end disclosure is not applicable
					IF (@dtPEStartDate IS NOT NULL)
					BEGIN
						IF (@dtNextPEStartDate IS NOT NULL AND @dtNextPEStartDate > @dtPEStartDate)
						BEGIN
							-- case where last period end is not appliable 
							-- in this case date of acquisition must be before next period end disclosure
							IF (CONVERT(date,@inp_dtDateOfAcquisition) < @dtPEStartDate AND CONVERT(date,@inp_dtDateOfAcquisition) > @dtNextPEStartDate)
							BEGIN
								SET @out_nReturnValue = @ERR_TransactionDetailsForApplicablePeriod
								RETURN @out_nReturnValue
							END
						END
						ELSE
						BEGIN
							IF(CONVERT(date,@inp_dtDateOfAcquisition) < @dtPEStartDate)
							BEGIN
								SET @out_nReturnValue = @ERR_TransactionDetailsForApplicablePeriod
								RETURN @out_nReturnValue
							END
						END		
					END
					-- case where for first period, period end is not appliable and next period is with period end is appliable 
					--ELSE IF(@dtPEStartDate IS NULL AND @dtNextPEStartDate IS NOT NULL AND CONVERT(date,@inp_dtDateOfAcquisition) > @dtNextPEStartDate)
					--BEGIN
					--print 'msg4'
					--print '@dtNextPEStartDate'+cast(@dtNextPEStartDate as varchar(50))+''
					--print '@dtPEStartDate'+cast(@dtPEStartDate as varchar(50))+'' 
					--	SET @out_nReturnValue = @ERR_TransactionDetailsForApplicablePeriod
					--	RETURN @out_nReturnValue
					--END
				END
			END
			---------------------------------------------END Case #4 -----------------------------------------------------------------			
			
			-- While saving Continuous disclosure, check if PE disclosure for the same period or any period after that is not there. 
			-- If such record is found, do not allow the user to save the continuous disclosure
			-- Case #5
			SELECT @dtPeriodEndForContinuous = TM.PeriodEndDate
			FROM tra_TransactionDetails TD JOIN tra_TransactionMaster TM ON TM.TransactionMasterId = TD.TransactionMasterId
			WHERE TD.TransactionMasterId = @inp_iTransactionMasterId
			
			IF EXISTS (SELECT TransactionMasterId
						FROM tra_TransactionMaster TM
							JOIN eve_EventLog EL ON EL.UserInfoId = TM.UserInfoId AND EL.EventCodeId IN (153029, 153030)-- = 153037 
								AND MapToTypeCodeId = 132005 AND MapToId = TM.TransactionMasterId
						WHERE TM.PeriodEndDate >= @dtPeriodEndForContinuous AND EL.UserInfoId = @nUserInfoId)
			BEGIN
				SET @out_nReturnValue = @ERR_ContiDisclosureNotAllowed_PEExists
				RETURN @out_nReturnValue
			END
			---------------------------------------------END Case #5 -----------------------------------------------------------------
			
				---------------Case #36--------------------------------
			IF(@nGenCashAndCashlessPartialExciseOptionForContraTrade = 172003 AND (@inp_bESOPExcerseOptionQtyFlag IS NULL OR @inp_bESOPExcerseOptionQtyFlag = 0) 
				AND (@inp_bOtherESOPExcerseOptionFlag IS NULL OR @inp_bOtherESOPExcerseOptionFlag = 0) AND @inp_iSecurityTypeCodeId = @nSecurityType_Shares
				AND @inp_iTransactionTypeCodeId = @nTransaction_Sell
				AND @nContraTradeOption = @nContraTradeQuantityBase)
			BEGIN
				SET @out_nReturnValue = @ERR_SELECTATLEASTONEPOOL
				RETURN @out_nReturnValue
			END
			----------------------------------------------END Case #36 ----------------------------------------------------------------
			
		-- Check availabale balance in Excercise pool
			-- if Transaction type Sell and Secuority Type Shares
			---------------Case #33--------------------------------
			IF(@nImptPostshareQtyCodeId = @nLess)--AND @inp_iSecurityTypeCodeId = @nSecurityType_Shares)
			   --AND @nContraTradeOption = @nContraTradeQuantityBase)
			BEGIN
				EXEC @nTmpRet = st_tra_TransactionExcercisePoolValidation @inp_iTransactionDetailsID,@inp_iTransactionMasterId,@inp_iForUserInfoId,
								@inp_dQuantity,@inp_bESOPExcerseOptionQtyFlag,@inp_bOtherESOPExcerseOptionFlag,@inp_iSecurityTypeCodeId,'OtherQty',@inp_iLotSize,@inp_iDMATDetailsID,@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT, @out_sSQLErrMessage OUTPUT
		
				IF @out_nReturnValue <> 0
				BEGIN
					SET @out_nReturnValue = @out_nReturnValue--@ERR_TRANSACTIONMASTER_SAVE
					RETURN @out_nReturnValue
				END
			END
			
			--- Check availabale balance in Excercise pool for pledge quantity
			IF((@inp_iTransactionTypeCodeId = @nTransactionType_Pledge OR @inp_iTransactionTypeCodeId = @nTransactionType_PledgeRevoke OR @inp_iTransactionTypeCodeId = @nTransactionType_PledgeInvoke) AND @nImptPostshareQtyCodeId = @nNo AND @nActionCodeId = @nSell)--AND @inp_iSecurityTypeCodeId = @nSecurityType_Shares)
			BEGIN
				EXEC @nTmpRet = st_tra_TransactionExcercisePoolValidation @inp_iTransactionDetailsID,@inp_iTransactionMasterId,@inp_iForUserInfoId,
								@inp_dQuantity,@inp_bESOPExcerseOptionQtyFlag,@inp_bOtherESOPExcerseOptionFlag,@inp_iSecurityTypeCodeId,'PledgeQty',@inp_iLotSize,@inp_iDMATDetailsID,@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT, @out_sSQLErrMessage OUTPUT
		
				IF @out_nReturnValue <> 0
				BEGIN
					SET @out_nReturnValue = @out_nReturnValue--@ERR_TRANSACTIONMASTER_SAVE
					RETURN @out_nReturnValue
				END
			END
			
			IF((@inp_iTransactionTypeCodeId = @nTransactionType_Pledge OR @inp_iTransactionTypeCodeId = @nTransactionType_PledgeRevoke OR @inp_iTransactionTypeCodeId = @nTransactionType_PledgeInvoke) AND @nImptPostshareQtyCodeId = @nNo AND @nActionCodeId = @nBuy)--AND @inp_iSecurityTypeCodeId = @nSecurityType_Shares)
			BEGIN
			     IF((select UserTypeCodeId from usr_UserInfo where UserInfoId = @inp_iForUserInfoId) = @nUserType_Relative)
			     BEGIN
			       select @nUserInfoId_FromRelative = UserInfoId from usr_UserRelation where UserInfoIdRelative = @inp_iForUserInfoId
			     END
			     ELSE
			     BEGIN
			        set @nUserInfoId_FromRelative = @inp_iForUserInfoId
			     END
			    
			    DECLARE TransactionDetail_Cursor_ForPleadge CURSOR FOR 
						SELECT TransactionTypeCodeId,ModeOfAcquisitionCodeId, Quantity FROM tra_TransactionDetails 
						WHERE TransactionMasterId = @inp_iTransactionMasterId AND SecurityTypeCodeId = @nShareSecurityType AND TransactionTypeCodeId IN (@nTransactionType_Pledge,@nTransactionType_PledgeRevoke,@nTransactionType_PledgeInvoke) AND ForUserInfoId = @inp_iForUserInfoId AND TransactionDetailsId != @inp_iTransactionDetailsID
 
					OPEN TransactionDetail_Cursor_ForPleadge
					
					FETCH NEXT FROM TransactionDetail_Cursor_ForPleadge INTO 
						@nTransactionTypeCodeId, @nModeOfAcquisitionCodeId, @nQuantity
						
					SET @nPledgeQuantity = 0
					
					WHILE @@FETCH_STATUS = 0
					BEGIN
							
						select @nImptPostshareQtyCodeId_ForPledge = impt_post_share_qty_code_id, @nActionCodeId_ForPledge = action_code_id from tra_TransactionTypeSettings where trans_type_code_id = @nTransactionTypeCodeId and mode_of_acquis_code_id = @nModeOfAcquisitionCodeId and security_type_code_id = @inp_iSecurityTypeCodeId	
							
						IF(@nImptPostshareQtyCodeId_ForPledge = @nNo AND @nActionCodeId_ForPledge = @nBuy)	
						BEGIN							        						
						  SET @nPledgeQuantity = @nPledgeQuantity + @nQuantity
						END
						
						FETCH NEXT FROM TransactionDetail_Cursor_ForPleadge INTO 
							@nTransactionTypeCodeId, @nModeOfAcquisitionCodeId, @nQuantity 	
						
					END
					
					CLOSE TransactionDetail_Cursor_ForPleadge
					DEALLOCATE TransactionDetail_Cursor_ForPleadge;
					
			    SELECT TOP 1 @out_nPledgeClosingBalance =  PledgeClosingBalance FROM [dbo].[tra_TransactionSummary]  WHERE PeriodCodeId = @nPeriodCodeId  AND UserInfoId = @nUserInfoId_FromRelative AND UserInfoIdRelative = @inp_iForUserInfoId AND SecurityTypeCodeId = @inp_iSecurityTypeCodeId  ORDER BY TransactionSummaryId DESC
			    
				EXEC @nTmpRet = st_tra_GetClosingBalanceOfAnnualPeriod @nUserInfoId_FromRelative, @inp_iForUserInfoId, @inp_iSecurityTypeCodeId, @out_nClosingBalance OUTPUT, @out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT, @out_sSQLErrMessage OUTPUT
		
				IF @inp_dQuantity + @nPledgeQuantity + @out_nPledgeClosingBalance > @out_nClosingBalance
				BEGIN
					SET @out_nReturnValue = @ERR_NEGATIVEERRORMESSAGE   --@ERR_TRANSACTIONMASTER_SAVE
					RETURN @out_nReturnValue
				END
			END
			----------------------------------------------END Case #33 ----------------------------------------------------------------
			
			
		END

		RETURN 0
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue	=  @ERR_TRANSACTIONDETAILS_VALIDATION
	END CATCH
END
