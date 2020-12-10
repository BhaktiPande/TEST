IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_tra_TradingTransactionMasterCreate_Override')
DROP PROCEDURE [dbo].[st_tra_TradingTransactionMasterCreate_Override]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Override procedure for Create and fetch TradingTransaction Master details. This procedure will ahve parameter to have the 
				Select query at end of the procedure or not. Also this procedure will have an output parameter for TransactionMasterId

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
Raghvendra		12-Oct-2015		Moved the logic from st_tra_TradingTransactionMasterCreate to st_tra_TradingTransactionMasterCreate_Override, so that it can be customised to
								return the select query conditionally and also can set the transaction master id to out parameter.
Parag			20-Oct-2015		Made check to add PE records in "tra_UserPeriodEndMapping" table for user, 
Parag			02-Nov-2015		Codes (dates) for Period end date are changed. Now that are stored as the 1st of next month.
Parag			04-Nov-2015		Get and set period end date from transacation master, if input period end date is null - period end date is neeed for validation.
Parag			17-Nov-2015		Made change to generate PE records from TP change from higher to lower period 
Parag			23-Nov-2015		Made change to handle condition when period end disclosure is not applicable for user
Tushar			30-Nov-2015		Call procedure  st_tra_UpdateExerciseAndOtherQuantity for update ESOP and Other Quantity.
Parag			02-Dec-2015		Made change to update exercise pool
Parag			03-Dec-2015		Made change to call update exercise pool procedure with parameter
Parag			05-Dec-2015		Made change to fix issue of period end disclosure end date not able to set for transcation
Parag			06-Dec-2015		Made change to fix issue of period end disclosure end date for perclearance request
Parag			15-Dec-2015		Made change to fix issue of exercise pool updating when softcopy/hardcopy submitted 
Raghvendra		31-Mar-2016		Fix to return correct error code in the Catch block for the procedure
Tushar			09-May-2016		Mantis Bugs:- 8829 
								If user does not add any transaction and clicks on submit then we will 
								mark as no period end and in letter all the continuous disclosure transactions added in the period will be seen.
Tushar			17-May-2016		1. Add New Column Display Sequential Number for Continuous Disclosure.
								2. For PNT/PNR:-When Transaction Submit Increment Above Column & save in table.
								3.For PCL:- When Pre clearance request raised Increment Above Column & save in table.
								4.For Display Rolling Number logic is as follows:-
									 A) If Pre clearance  Transaction is raised then show dIsplay number as "PCL + <DisplayRollingNumber>".
									 B) For continuous disclosure records for Insider show  "PNT"  before the transaction is submitted & after submission show "PNT +    	<DisplayRollingNumber>".                                                      
									 C) For continuous disclosure for employee non insider show  PNR before transaction is submitted and show "PNR + <DisplayRollingNumber>" after the transaction is submitted.

AniketS			2-Jun-2016		Added new column for UPSI declaration on Continuous Disclosures page(YES BANK customization)
Raghvendra		07-Sep-2016		Changed the GETDATE() call with function dbo.uf_com_GetServerDate(). This function will return the date to be used as server date.
Gaurishankar	22-Sep-2016		Added column ,ConfirmCompanyHoldingsFor ,ConfirmNonCompanyHoldingsFor for select
Tushar			27-Oct-2016		Calculating SecuritiesPriorToAcquisition,PerOfSharesPreTransaction,PerOfSharesPostTransaction
								& SecuritiesPostToAcquisition for transaction details while submitting.							
Usage:
EXEC [st_tra_TradingTransactionMasterCreate] 1
-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_tra_TradingTransactionMasterCreate_Override]
	@inp_sTransactionMasterId								BIGINT,
	@inp_sPreclearanceRequestId								BIGINT = null,
	@inp_iUserInfoId										INT = null,
	@inp_iDisclosureTypeCodeId								INT = null,
	@inp_iTransactionStatusCodeId							INT = null,
	@inp_sNoHoldingFlag										bit = null,
	@inp_iTradingPolicyId									INT = null,
	@inp_dtPeriodEndDate									DATETIME = null,
	@inp_bPartiallyTradedFlag								bit = null,
	@inp_bSoftCopyReq										bit = null,
	@inp_bHardCopyReq										bit = null,
	@inp_dtHCpByCOSubmission								DATETIME = null,
	@inp_nUserId											INT,
	@inp_sCalledFrom										VARCHAR(20) = '',--This is to conditionally execute the last SELECT statement ,as the select is not required in MASSUPLOAD CALL
	@inp_SeekDeclarationFromEmpRegPossessionOfUPSIFlag		BIT = NULL,
	@inp_CDDuringPE											BIT= NULL,
	@inp_InsiderIDFlag										BIT= NULL,
	@out_nTransactionMasterId								BIGINT = 0 OUTPUT,	--This will return the Transaction MasterId for the corresponding transaction getting saved. This is used in case when the procedure is called from MASS Upload
	@out_nDisclosureCompletedFlag							INT = 0 OUTPUT,
	@out_nReturnValue										INT = 0 OUTPUT,
	@out_nSQLErrCode										INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage										NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.	
AS
BEGIN

	DECLARE @ERR_TRANSACTIONMASTER_SAVE INT
	DECLARE @ERR_TRANSACTIONMASTER_NOTFOUND INT
	DECLARE @ERR_TRADINGPOLICY_NOTFOUND INT
	DECLARE @ERR_TRADINGDETAIL_NOTFOUND INT
	DECLARE @ERR_TRADINGDETAIL_DOCUMENT_NOTFOUND INT
	DECLARE @sSQL NVARCHAR(MAX) = ''
	DECLARE @sSETSQL NVARCHAR(MAX) = ''
	DECLARE @nTmpRet INT = 0
	DECLARE @TradingPolicyId INT = 0
	DECLARE @CONST_DISCLOSURE_STATUS_FOR_DOCUMENTUPLOAD INT = 148001
	DECLARE @CONST_DISCLOSURE_STATUS_FOR_NOT_CONFIRM INT = 148002
	DECLARE @CONST_DISCLOSURE_STATUS_FOR_CONFIRM INT = 148007
	DECLARE @CONST_DISCLOSURE_STATUS_HARDCOPY_BY_CO INT = 148006
	DECLARE @CONST_INITIAL_DISCLOSURE_TYPE_CODEID INT = 147001
	DECLARE @CONST_CONTINUOUS_DISCLOSURE_TYPE_CODEID INT = 147002
	DECLARE @CONST_INITIAL_DISCLOSURE_CONFIRM_EVENT INT = 153035
	DECLARE @CONST_DOCUMENT_DISCLOSURE_TRANSACTION INT = 132005
	DECLARE @CONST_PURPOSECODE_DETAILS_UPLOAD INT = 133003
	DECLARE @nParentTransactionMasterId INT = NULL
	DECLARE @nPCLReq INT = 0
	DECLARE @CONST_DISCLOSURE_STATUS_SOFTCOPY INT = 148004
	DECLARE @DBNAME VARCHAR(100) = UPPER((SELECT DB_NAME()))
	DECLARE @FIND_AXISBANK VARCHAR(50) = 'AXISBANK'	
	
	DECLARE @RC INT
	
	DECLARE @dtCurrentDate DATETIME = dbo.uf_com_GetServerDate()
			
	CREATE TABLE #tmpEvaluatePercentagePrePostTransaction (TransactionDetailsId BIGINT NOT NULL, SecuritiesPriorToAcquisition DECIMAL(20,0) NOT NULL,
	PerOfSharesPreTransaction DECIMAL(5,2) NOT NULL,PerOfSharesPostTransaction DECIMAL(5,2) NOT NULL,SecuritiesPostToAcquisition DECIMAL(20,0) NOT NULL)
	DECLARE @nGenSecuritiesPriortoAcquisitionManualInputorAutoCalculate INT						
	
	-- flag to indicate what action to be taken
	-- 0: NO ACTION
	-- 1: add records as per current TP for current period, 
	-- 2: record is already added into tra_UserPeriodEndMapping table
	-- 3: add next period records as per previous TP stored in tra_UserPeriodEndMapping table
	DECLARE @nActinFlag		 		INT
	
	DECLARE @nApplicableTP 			INT
	DECLARE @nYearCodeId	 		INT
	DECLARE @nPeriodCodeId  		INT
	DECLARE @dtPEStartDate 			DATETIME
	DECLARE @dtPEEndDate 			DATETIME
	DECLARE @bChangePEDate			BIT
	DECLARE @dtPEEndDateToUpdate	DATETIME
	
	DECLARE @bIsUpdateExercisePool	BIT = 0
	DECLARE @nLoginUSERTYPE INT 
	DECLARE @USERTYPE_ADMIN INT = 1010001
	DECLARE @USERTYPE_COUSER INT = 1010002

	DECLARE @nDisplayRollingNumber BIGINT = NULL
	
	
	CREATE TABLE #tmpTransactionDetails (ID INT IDENTITY NOT NULL,TransactionDetailsId BIGINT NOT NULL,TransactionMasterId BIGINT NOT NULL, SecuritiesPriorToAcquisition DECIMAL(20,0) NOT NULL,
	TransactionTypeCodeId BIGINT NOT NULL,Quantity DECIMAL(20,0),SecurityTypeCodeID INT,Foruserinfoid INT,ModeOfAcquisitionCodeId INT,Quantity2 DECIMAL(20,0))
	
	DECLARE @TDID INT
	DECLARE @nTransactionTypeCodeId INT
	DECLARE @nQuantity DECIMAL(20,0)
	DECLARE @nQuantity2 DECIMAL(20,0)	
	DECLARE @SecuritiesPriorToAcquisition DECIMAL(20,0)
	DECLARE @Balance DECIMAL(20,0)
	DECLARE @TransactionType_Buy INT=143001
	DECLARE @TransactionType_Sell INT=143002
	DECLARE @TotalRows INT
	DECLARE @nCount INT = 0

	BEGIN TRY
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;
		
		--Initialize variables
		SELECT	@ERR_TRANSACTIONMASTER_NOTFOUND = 16091,
				@ERR_TRANSACTIONMASTER_SAVE = 16092,
				@ERR_TRADINGPOLICY_NOTFOUND = 16093,
				@ERR_TRADINGDETAIL_NOTFOUND = 16179,
				@ERR_TRADINGDETAIL_DOCUMENT_NOTFOUND = 16188
				
		-- if period end date is not set then set from transascation master because its needed for validation
		IF(@inp_dtPeriodEndDate IS NULL AND @inp_sTransactionMasterId <> 0)
		BEGIN
			SELECT @inp_dtPeriodEndDate = PeriodEndDate FROM tra_TransactionMaster WHERE TransactionMasterId = @inp_sTransactionMasterId
		END		  

		/*Find the user type for checking when to set the date of intimation to company against the transaction*/
		SELECT @nLoginUSERTYPE = UserTypeCodeId FROM usr_UserInfo WHERE UserInfoId = @inp_nUserId

		/*this condition is added to make stock exchange submission and period end submission independant*/
		IF(@inp_dtHCpByCOSubmission IS NOT NULL)
		BEGIN		
		UPDATE tra_TransactionMaster		
		SET	HardCopyByCOSubmissionDate = @inp_dtHCpByCOSubmission,
			TransactionStatusCodeId = @inp_iTransactionStatusCodeId
		WHERE TransactionMasterId = @inp_sTransactionMasterId		
		END		
		ELSE
		BEGIN
		
				
		EXEC @nTmpRet = st_tra_TransactionMasterValidation @inp_sTransactionMasterId, @inp_iUserInfoId, @inp_iDisclosureTypeCodeId,
			@inp_iTransactionStatusCodeId, @inp_sNoHoldingFlag, @inp_iTradingPolicyId, @inp_dtPeriodEndDate,
			0, @inp_nUserId, @out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT, @out_sSQLErrMessage OUTPUT
		
		IF @out_nReturnValue <> 0
		BEGIN
			SET @out_nReturnValue = @out_nReturnValue--@ERR_TRANSACTIONMASTER_SAVE
			RETURN @out_nReturnValue
		END
		
		EXEC @nTmpRet = st_tra_UpdateExerciseAndOtherQuantity @inp_sTransactionMasterId,@inp_sPreclearanceRequestId,@inp_iDisclosureTypeCodeId,
			@inp_iTransactionStatusCodeId,@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT, @out_sSQLErrMessage OUTPUT
		
		IF @out_nReturnValue <> 0
		BEGIN
			SET @out_nReturnValue = @out_nReturnValue--@ERR_TRANSACTIONMASTER_SAVE
			RETURN @out_nReturnValue
		END
		
		--Save the TransactionMaster details
		IF @inp_sTransactionMasterId = 0
		BEGIN
		--IF (@inp_iDisclosureTypeCodeId IN(@CONST_CONTINUOUS_DISCLOSURE_TYPE_CODEID) OR NOT EXISTS(SELECT TransactionMasterId FROM tra_TransactionMaster 
		--					WHERE DisclosureTypeCodeId = @inp_iDisclosureTypeCodeId  
		--					and UserInfoId = @inp_iUserInfoId and (@inp_dtPeriodEndDate IS NULL or PeriodEndDate = @inp_dtPeriodEndDate)))						
			DECLARE @nCheckForInitDisc INT=0
								
			SELECT @nCheckForInitDisc = count(TransactionMasterId) FROM tra_TransactionMaster WHERE UserInfoId=@inp_iUserInfoId AND DisclosureTypeCodeId=147001 and TransactionStatusCodeId in(148003,148004,148005,148006)
			
			IF(@nCheckForInitDisc>0)
			BEGIN
			SET @inp_InsiderIDFlag=1
			END	
			ELSE
			BEGIN
			SET @inp_InsiderIDFlag=0
			END	
			
			IF (@inp_iDisclosureTypeCodeId = @CONST_CONTINUOUS_DISCLOSURE_TYPE_CODEID OR NOT EXISTS(SELECT TransactionMasterId FROM tra_TransactionMaster 
							WHERE DisclosureTypeCodeId = @inp_iDisclosureTypeCodeId  
							and UserInfoId = @inp_iUserInfoId and InsiderIDFlag =@inp_InsiderIDFlag	 and (@inp_dtPeriodEndDate IS NULL or PeriodEndDate = @inp_dtPeriodEndDate)))			
			BEGIN
				-- If Preclearance Id is non zero, and transaction masterid = 0, 
				-- and it is the not first transaction, then get trading policy id from the parent transaction, aslo set parent transation id
				IF @inp_sTransactionMasterId = 0 AND ISNULL(@inp_sPreclearanceRequestId, 0) <> 0
					AND EXISTS(SELECT * FROM tra_TransactionMaster WHERE PreclearanceRequestId = @inp_sPreclearanceRequestId)
				BEGIN
					SELECT @TradingPolicyId = TradingPolicyId,
						@nParentTransactionMasterId = TransactionMasterId,
						@nDisplayRollingNumber = DisplayRollingNumber
					FROM tra_TransactionMaster
					WHERE PreclearanceRequestId = @inp_sPreclearanceRequestId
						AND ParentTransactionMasterId IS NULL 
						
					-- Set "ShowAddButton" flag to 0 in Preclearance table
					UPDATE tra_PreclearanceRequest
					SET ShowAddButton = 0
					WHERE PreclearanceRequestId = @inp_sPreclearanceRequestId
				END
				ELSE
				BEGIN					
					DECLARE @UsrInfoId INT=0
					DECLARE @UsrInfoId1 INT
					SELECT @UsrInfoId=UserInfoId FROM usr_UserRelation WHERE UserInfoIdRelative=@inp_iUserInfoId
					IF(@UsrInfoId!=0)
					BEGIN					
					SET @UsrInfoId1=@UsrInfoId
					END
					ELSE
					BEGIN
					SET @UsrInfoId1=@inp_iUserInfoId
					END
									
					SELECT @TradingPolicyId = ISNULL(MAX(MapToId), 0) FROM vw_ApplicableTradingPolicyForUser  where UserInfoId = @UsrInfoId1
					IF @TradingPolicyId = 0
					BEGIN
						SET @out_nReturnValue = @ERR_TRADINGPOLICY_NOTFOUND
						RETURN (@out_nReturnValue)				
					END
				END		
				
				-- in case of per clearance request made for partial transcation enter 
				-- get period end date of partent perclearance request and use that for all preclearance request until preclearnace is closed
				IF (@inp_sPreclearanceRequestId IS NOT NULL AND @nParentTransactionMasterId IS NOT NULL)
				BEGIN
					SELECT @inp_dtPeriodEndDate = PeriodEndDate FROM tra_TransactionMaster WHERE TransactionMasterId = @nParentTransactionMasterId
				END
				ELSE
				BEGIN	
					--made this change for period end-user has to submit his relatives initial dsclousre
					--changed current date to created on date
					DECLARE @nUserTypeCode INT = (SELECT UserTypeCodeId FROM usr_UserInfo WHERE UserInfoId=@inp_iUserInfoId)
					IF(@inp_iDisclosureTypeCodeId = @CONST_INITIAL_DISCLOSURE_TYPE_CODEID AND @nUserTypeCode=101007)
					BEGIN
						SET @dtCurrentDate = (select CreatedOn from usr_UserInfo where UserInfoId = @inp_iUserInfoId)
					END		
					EXECUTE @RC = [st_tra_PeriodEndDisclosureGetApplicablePeriodDetail]
									@inp_iUserInfoId, 
									@TradingPolicyId, 
									@dtCurrentDate,
									@nActinFlag OUTPUT,
									@nApplicableTP OUTPUT, 
									@nYearCodeId OUTPUT, 
									@nPeriodCodeId OUTPUT, 
									@dtPEStartDate OUTPUT, 
									@dtPEEndDate OUTPUT, 
									@bChangePEDate OUTPUT, 
									@dtPEEndDateToUpdate OUTPUT, 									
									@out_nReturnValue OUTPUT,
									@out_nSQLErrCode OUTPUT,
									@out_sSQLErrMessage OUTPUT
				
					IF @out_nReturnValue <> 0
					BEGIN
						RETURN @out_nReturnValue
					END				
									
					-- check flag to update record 
					IF((@nActinFlag = 1 OR @nActinFlag = 3) AND @inp_CDDuringPE<>1  AND ((@nCheckForInitDisc=0 AND @inp_iDisclosureTypeCodeId=147001) OR (@nCheckForInitDisc=1 AND @inp_iDisclosureTypeCodeId=147002))) 
					BEGIN
						--print  'UserInfoId '+convert(varchar, @inp_iUserInfoId) + '   TradingPolicy '+convert(varchar, @nApplicableTP) 
						--	+ '   YearCodeId '+convert(varchar, @nYearCodeId) + '   PeriodCodeId '+convert(varchar, ISNULL(@nPeriodCodeId,0)) 
						--	+ '   PEStartDate '+case when @dtPEStartDate is null then 'NULL ' else convert(varchar, @dtPEStartDate) end
						--	+ '   PEEndDate '+case when @dtPEEndDate is null then 'NULL ' else convert(varchar, @dtPEEndDate) end
						--	+ '   ChangePEDate '+convert(varchar, @bChangePEDate) 
						--	+ '   PEEndDateToUpdate '+case when @dtPEEndDateToUpdate is null then 'NULL ' else convert(varchar, @dtPEEndDateToUpdate) end
							
						-- add record into table
						INSERT INTO tra_UserPeriodEndMapping 
							(UserInfoId, TradingPolicyId, YearCodeId, PeriodCodeId, PEStartDate, PEEndDate, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
						VALUES
							(@inp_iUserInfoId, @nApplicableTP, @nYearCodeId, @nPeriodCodeId, @dtPEStartDate, @dtPEEndDate, @inp_iUserInfoId, dbo.uf_com_GetServerDate(), @inp_iUserInfoId, dbo.uf_com_GetServerDate())
											
						SET @inp_dtPeriodEndDate = @dtPEEndDate -- override input date with applicable PE date						
						-- check flag to know if need to update period end date with new date in transaction master table 
						-- this is mainly because period type change from lower to higher 
						IF (@bChangePEDate = 1)
						BEGIN
							UPDATE tra_TransactionMaster SET PeriodEndDate = @dtPEEndDate 
							WHERE UserInfoId = @inp_iUserInfoId AND PeriodEndDate = @dtPEEndDateToUpdate
							
						END						
					END
					ELSE IF(@nActinFlag = 2 AND @inp_CDDuringPE<>1)
					BEGIN					
					   	SET @inp_dtPeriodEndDate = @dtPEEndDate -- override input date with applicable PE date
						
						-- check flag to know if need to update period end date with new date in transaction master table 
						-- this is mainly because period type change from lower to higher 
						IF (@bChangePEDate = 1)
						BEGIN
							UPDATE tra_TransactionMaster SET PeriodEndDate = @dtPEEndDate 
						   	WHERE UserInfoId = @inp_iUserInfoId AND PeriodEndDate = @dtPEEndDateToUpdate
						END
					END
				END
				
		Insert into tra_TransactionMaster(ParentTransactionMasterId,PreclearanceRequestId,UserInfoId,DisclosureTypeCodeId,
						TransactionStatusCodeId,NoHoldingFlag,TradingPolicyId,PeriodEndDate,DisplayRollingNumber,
						CreatedBy,CreatedOn,ModifiedBy,ModifiedOn,SeekDeclarationFromEmpRegPossessionOfUPSIFlag,CDDuringPE,InsiderIDFlag 
						)
		Values (@nParentTransactionMasterId,@inp_sPreclearanceRequestId,@inp_iUserInfoId,@inp_iDisclosureTypeCodeId,
						@inp_iTransactionStatusCodeId,@inp_sNoHoldingFlag,@TradingPolicyId,@inp_dtPeriodEndDate,
						@nDisplayRollingNumber,@inp_nUserId,dbo.uf_com_GetServerDate(),@inp_nUserId,dbo.uf_com_GetServerDate(),
						@inp_SeekDeclarationFromEmpRegPossessionOfUPSIFlag ,@inp_CDDuringPE,@inp_InsiderIDFlag 
						)
		SET @inp_sTransactionMasterId = SCOPE_IDENTITY()
			END	
			ELSE
			BEGIN			
				SELECT @inp_sTransactionMasterId = TransactionMasterId 
				FROM   tra_TransactionMaster 
				WHERE  DisclosureTypeCodeId = @inp_iDisclosureTypeCodeId  
				  and  UserInfoId = @inp_iUserInfoId 
				  and  (@inp_dtPeriodEndDate IS NULL or PeriodEndDate = @inp_dtPeriodEndDate)
			END
		END
		ELSE
		BEGIN
			--Check if the TransactionMaster whose details are being updated exists
			IF (NOT EXISTS(SELECT TransactionMasterId FROM tra_TransactionMaster WHERE TransactionMasterId = @inp_sTransactionMasterId))			
			BEGIN	
				SET @out_nReturnValue = @ERR_TRANSACTIONMASTER_NOTFOUND
				RETURN (@out_nReturnValue)
			END
			ELSE
			BEGIN
				-- check if need to update exercise pool or not 
				IF EXISTS(SELECT TransactionMasterId FROM tra_TransactionMaster WHERE TransactionMasterId = @inp_sTransactionMasterId 
							AND TransactionStatusCodeId in (@CONST_DISCLOSURE_STATUS_FOR_DOCUMENTUPLOAD, @CONST_DISCLOSURE_STATUS_FOR_NOT_CONFIRM)) 
					AND (@inp_iTransactionStatusCodeId = @CONST_DISCLOSURE_STATUS_FOR_CONFIRM)
				BEGIN
					SET @bIsUpdateExercisePool = 1
				END				
				
				IF @inp_iTransactionStatusCodeId = @CONST_DISCLOSURE_STATUS_FOR_CONFIRM
				BEGIN
				    IF @inp_sNoHoldingFlag = 1
				    BEGIN
				        Delete from tra_TransactionDetails
				        where TransactionMasterId = @inp_sTransactionMasterId
				    END
				    ELSE
				    BEGIN
						IF (NOT EXISTS(SELECT * FROM tra_TransactionDetails where TransactionMasterId = @inp_sTransactionMasterId))
						BEGIN
							IF @inp_iDisclosureTypeCodeId <> 147003
							BEGIN
								SET @out_nReturnValue = @ERR_TRADINGDETAIL_NOTFOUND
								RETURN (@out_nReturnValue)
							END
							ELSE IF  @inp_iDisclosureTypeCodeId = 147003
							BEGIN
								SET @inp_sNoHoldingFlag = 1
							END
						END
						
						-- Call procedure to decide if preclearance was req
						EXEC st_tra_TransactionMasterIsPCLReq @inp_sTransactionMasterId, @out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT, @out_sSQLErrMessage OUTPUT
						IF @out_nReturnValue <> 0
						BEGIN
							RETURN @out_nReturnValue
						END
				    END
				    
				    IF @inp_iDisclosureTypeCodeId = 147002
					BEGIN
						SELECT @nGenSecuritiesPriortoAcquisitionManualInputorAutoCalculate = GenSecuritiesPriortoAcquisitionManualInputorAutoCalculate 
						FROM tra_TransactionMaster TM 
						JOIN rul_TradingPolicy TP ON TM.TradingPolicyId = TP.TradingPolicyId
						WHERE TM.TransactionMasterId = @inp_sTransactionMasterId
						
						IF @nGenSecuritiesPriortoAcquisitionManualInputorAutoCalculate  = 0
						BEGIN													
							EXECUTE st_tra_EvaluatePercentagePrePostTransactionSecuritiesPriorToAcquisition 
							@inp_sTransactionMasterId,							
							@out_nReturnValue OUTPUT,
							@out_nSQLErrCode OUTPUT,
							@out_sSQLErrMessage OUTPUT							
							
							IF @out_nReturnValue <> 0
							BEGIN
								RETURN @out_nReturnValue
							END
							
							UPDATE TD 
							SET SecuritiesPriorToAcquisition = Temp.SecuritiesPriorToAcquisition,
								PerOfSharesPreTransaction = Temp.PerOfSharesPreTransaction,
								PerOfSharesPostTransaction = Temp.PerOfSharesPostTransaction
							FROM tra_TransactionDetails TD 
							JOIN(SELECT TransactionDetailsId,SecuritiesPriorToAcquisition,PerOfSharesPreTransaction,PerOfSharesPostTransaction  
								 FROM #tmpEvaluatePercentagePrePostTransaction) Temp ON Temp.TransactionDetailsId = TD.TransactionDetailsId
						 END
						DROP TABLE #tmpEvaluatePercentagePrePostTransaction
					  END
				    
				    -- check if update security pool or not 
					IF (@bIsUpdateExercisePool = 1)
					BEGIN
						-- update exercise pool 
						EXECUTE @RC = [st_tra_ExerciseBalancePoolUpdateDetails] 
								@CONST_DOCUMENT_DISCLOSURE_TRANSACTION,
								NULL,
								@inp_sTransactionMasterId,
								@out_nReturnValue OUTPUT,
								@out_nSQLErrCode OUTPUT,
								@out_sSQLErrMessage OUTPUT
						
						IF @out_nReturnValue <> 0
						BEGIN
							RETURN @out_nReturnValue
						END
					END
						
				    /*
					Change done by Raghvendra:
					Change to Update the Date Of Intimation to Company for all the transaction details 
					to current date when login user is insider and has submitted the transaction 
					*/
					IF(CHARINDEX(@FIND_AXISBANK, @DBNAME) = 0)	
					BEGIN
						IF (@nLoginUSERTYPE <> @USERTYPE_ADMIN AND  @nLoginUSERTYPE <> @USERTYPE_COUSER)
						BEGIN
							UPDATE tra_TransactionDetails SET DateOfInitimationToCompany = GETDATE() 
							WHERE TransactionMasterId = @inp_sTransactionMasterId AND DateOfInitimationToCompany IS NULL
						END
					END
					
					UPDATE tra_TransactionMaster
					SET	TransactionStatusCodeId = @inp_iTransactionStatusCodeId
					    ,NoHoldingFlag = @inp_sNoHoldingFlag
						,ModifiedBy = @inp_nUserId
						,ModifiedOn = dbo.uf_com_GetServerDate()
						,SeekDeclarationFromEmpRegPossessionOfUPSIFlag = @inp_SeekDeclarationFromEmpRegPossessionOfUPSIFlag
					WHERE TransactionMasterId = @inp_sTransactionMasterId
					
				END
				ELSE IF (@inp_iTransactionStatusCodeId = @CONST_DISCLOSURE_STATUS_FOR_DOCUMENTUPLOAD)
				BEGIN
					IF (NOT EXISTS(SELECT * FROM com_DocumentObjectMapping 
									where MapToId = @inp_sTransactionMasterId
									and MapToTypeCodeId = @CONST_DOCUMENT_DISCLOSURE_TRANSACTION
									and PurposeCodeId = @CONST_PURPOSECODE_DETAILS_UPLOAD))
					BEGIN
						SET @out_nReturnValue = @ERR_TRADINGDETAIL_DOCUMENT_NOTFOUND
						RETURN (@out_nReturnValue)
					END
										
					UPDATE tra_TransactionMaster
					SET	TransactionStatusCodeId = @inp_iTransactionStatusCodeId
						,ModifiedBy = @inp_nUserId
						,ModifiedOn = dbo.uf_com_GetServerDate()
						,SeekDeclarationFromEmpRegPossessionOfUPSIFlag = @inp_SeekDeclarationFromEmpRegPossessionOfUPSIFlag
					WHERE TransactionMasterId = @inp_sTransactionMasterId
				END
				
				ELSE
				BEGIN				
					IF @inp_iDisclosureTypeCodeId = 147002
					BEGIN						
						SELECT @nGenSecuritiesPriortoAcquisitionManualInputorAutoCalculate = GenSecuritiesPriortoAcquisitionManualInputorAutoCalculate 
						FROM tra_TransactionMaster TM 
						JOIN rul_TradingPolicy TP ON TM.TradingPolicyId = TP.TradingPolicyId
						WHERE TM.TransactionMasterId = @inp_sTransactionMasterId
						
						IF @nGenSecuritiesPriortoAcquisitionManualInputorAutoCalculate  = 0
						BEGIN					
							--INSERT INTO #tmpEvaluatePercentagePrePostTransaction
							EXECUTE @RC = st_tra_EvaluatePercentagePrePostTransactionSecuritiesPriorToAcquisition 
							@inp_sTransactionMasterId,							
							@out_nReturnValue OUTPUT,
							@out_nSQLErrCode OUTPUT,
							@out_sSQLErrMessage OUTPUT
					
							IF @out_nReturnValue <> 0
							BEGIN
								RETURN @out_nReturnValue
							END
							
							UPDATE TD 
							SET SecuritiesPriorToAcquisition = Temp.SecuritiesPriorToAcquisition,
								PerOfSharesPreTransaction = Temp.PerOfSharesPreTransaction,
								PerOfSharesPostTransaction = Temp.PerOfSharesPostTransaction,
								ModifiedBy = @inp_nUserId,
								ModifiedOn = GETDATE()
							FROM tra_TransactionDetails TD 
							JOIN(SELECT TransactionDetailsId,SecuritiesPriorToAcquisition,PerOfSharesPreTransaction,PerOfSharesPostTransaction  
								 FROM #tmpEvaluatePercentagePrePostTransaction) Temp ON Temp.TransactionDetailsId = TD.TransactionDetailsId
						END
						DROP TABLE #tmpEvaluatePercentagePrePostTransaction
					END
				
					-- check if update security pool or not 
					IF (@bIsUpdateExercisePool = 1)
					BEGIN
						-- update exercise pool 
						EXECUTE @RC = [st_tra_ExerciseBalancePoolUpdateDetails] 
								@CONST_DOCUMENT_DISCLOSURE_TRANSACTION,
								NULL,
								@inp_sTransactionMasterId,
								@out_nReturnValue OUTPUT,
								@out_nSQLErrCode OUTPUT,
								@out_sSQLErrMessage OUTPUT
						
						IF @out_nReturnValue <> 0
						BEGIN
							RETURN @out_nReturnValue
						END
					END
					
					
					UPDATE tra_TransactionMaster
					SET	TransactionStatusCodeId = @inp_iTransactionStatusCodeId
						,ModifiedBy = @inp_nUserId
						,ModifiedOn = dbo.uf_com_GetServerDate()
						,SeekDeclarationFromEmpRegPossessionOfUPSIFlag = @inp_SeekDeclarationFromEmpRegPossessionOfUPSIFlag
					WHERE TransactionMasterId = @inp_sTransactionMasterId
					
					IF(CHARINDEX(@FIND_AXISBANK, @DBNAME) > 0)	
					BEGIN					
						IF (@nLoginUSERTYPE <> @USERTYPE_ADMIN AND  @nLoginUSERTYPE <> @USERTYPE_COUSER AND @inp_iTransactionStatusCodeId = @CONST_DISCLOSURE_STATUS_SOFTCOPY)
						BEGIN
							UPDATE tra_TransactionDetails SET DateOfInitimationToCompany = GETDATE() 
							WHERE TransactionMasterId = @inp_sTransactionMasterId AND DateOfInitimationToCompany IS NULL
						END
					END
					
					IF @inp_iTransactionStatusCodeId = @CONST_DISCLOSURE_STATUS_HARDCOPY_BY_CO
					BEGIN
						UPDATE tra_TransactionMaster
						SET	HardCopyByCOSubmissionDate = @inp_dtHCpByCOSubmission
						WHERE TransactionMasterId = @inp_sTransactionMasterId
					END
				END
				
				EXEC @nTmpRet = st_tra_TradingTransactionMasterConfirm @inp_sTransactionMasterId, @inp_nUserId, @out_nReturnValue, @out_nSQLErrCode, @out_sSQLErrMessage
				IF @out_nReturnValue <> 0
				BEGIN
					SET @out_nReturnValue = @ERR_TRANSACTIONMASTER_SAVE
					RETURN @out_nReturnValue
				END
				
				--IF (@inp_iTransactionStatusCodeId IS NOT NULL AND @inp_iTransactionStatusCodeId <> 0)
				--BEGIN
				--	SELECT @sSETSQL = @sSETSQL + ' ,TransactionStatusCodeId ='+ CONVERT(nvarchar,@inp_iTransactionStatusCodeId)
				--END
				--IF (@inp_sNoHoldingFlag IS NOT NULL)
				--BEGIN
				--	SELECT @sSETSQL = @sSETSQL + ' ,NoHoldingFlag ='+ CONVERT(nvarchar,@inp_sNoHoldingFlag)
				--END
				--IF (@inp_bPartiallyTradedFlag IS NOT NULL )
				--BEGIN
				--	SELECT @sSETSQL = @sSETSQL + ' ,PartiallyTradedFlag ='+ CONVERT(nvarchar,@inp_bPartiallyTradedFlag)
				--END
				--IF (@inp_bSoftCopyReq IS NOT NULL)
				--BEGIN
				--	SELECT @sSETSQL = @sSETSQL + ' ,SoftCopyReq ='+ CONVERT(nvarchar,@inp_bSoftCopyReq)
				--END
				--IF (@inp_bHardCopyReq IS NOT NULL)
				--BEGIN
				--	SELECT @sSETSQL = @sSETSQL + ' ,HardCopyReq ='+ CONVERT(nvarchar,@inp_bHardCopyReq)
				--END
				--IF(@sSETSQL <> '')
				--BEGIN 
					
				--	SELECT @sSQL = @sSQL +  'UPDATE tra_TransactionMaster' +
				--							' SET ModifiedBy = '+ CONVERT(nvarchar, @inp_nUserId)+
				--							' ,ModifiedOn = dbo.uf_com_GetServerDate()'   + @sSETSQL
				--	SELECT @sSQL = @sSQL +  ' WHERE TransactionMasterId ='+ CONVERT(nvarchar,@inp_sTransactionMasterId)  
				
				--	PRINT(@sSQL)  
				--	EXEC(@sSQL)  
				--END
			END
		END
		
		
	IF(@inp_iDisclosureTypeCodeId=147002)
	BEGIN
		DECLARE @dPaidUpShare DECIMAL(30,0)
		DECLARE @inp_dtAuthorizedShareCapitalDate DATETIME  = GETDATE()
		DECLARE @nMultiplier INT  = 100
		DECLARE @dPrePercentage DECIMAL(5,2)=0
		DECLARE @dPostPercentage DECIMAL(5,2)=0
		DECLARE @SecurityTypeCodeId INT
		DECLARE @nModeOfAcquisitionCodeId INT		
		DECLARE @nImpactOnPostQuantity INT		
		DECLARE @nImpactonPostShareQuantityAdd INT  = 505001
		DECLARE @nImpactonPostShareQuantityLess INT  = 505002
		DECLARE @nImpactonPostShareQuantityBoth INT  = 505003
		DECLARE @nImpactonPostShareQuantityNo INT  = 505004
		DECLARE @SecurityType_Share INT=139001	
		DECLARE @TotalUsrRows INT	=0    
		DECLARE @nUsrCount INT=0
		DECLARE @nUsrID INT=0            
            
            SELECT TOP 1 @dPaidUpShare =  PaidUpShare FROM com_CompanyPaidUpAndSubscribedShareCapital SC
            INNER JOIN mst_Company C ON SC.CompanyID = C.CompanyId
            WHERE C.IsImplementing = 1
            AND PaidUpAndSubscribedShareCapitalDate <= @inp_dtAuthorizedShareCapitalDate
            ORDER BY PaidUpAndSubscribedShareCapitalDate DESC         
            
            INSERT INTO #tmpTransactionDetails(TransactionDetailsId,TransactionMasterId, SecuritiesPriorToAcquisition,TransactionTypeCodeId,Quantity,SecurityTypeCodeID,Foruserinfoid,ModeOfAcquisitionCodeId,Quantity2)
            SELECT TransactionDetailsId,TransactionMasterId,SecuritiesPriorToAcquisition,TransactionTypeCodeId,Quantity,SecurityTypeCodeId,ForUserInfoId,ModeOfAcquisitionCodeId,Quantity2 FROM tra_TransactionDetails 
            WHERE TransactionMasterId=@inp_sTransactionMasterId ORDER BY Foruserinfoid,DateOfAcquisition,TransactionDetailsId
            
            --select * from #tmpTransactionDetails
            
            CREATE TABLE #tmpTransactionUsrDetails (ID INT IDENTITY NOT NULL,TotRows INT NOT NULL,Foruserinfoid INT)
            INSERT INTO #tmpTransactionUsrDetails(TotRows, Foruserinfoid)       
            SELECT count(TransactionDetailsId) AS TotRows,Foruserinfoid FROM #tmpTransactionDetails GROUP BY Foruserinfoid
            
            SELECT @TotalUsrRows=COUNT(*) FROM #tmpTransactionUsrDetails
                                         
            WHILE @nUsrCount<@TotalUsrRows
            BEGIN 
            SET @nCount=0
            SELECT @TotalRows=COUNT(*) FROM #tmpTransactionDetails WHERE Foruserinfoid=(SELECT Foruserinfoid FROM #tmpTransactionUsrDetails WHERE ID=@nUsrCount+1)
            
            WHILE @nCount<@TotalRows
                  BEGIN                        
                        IF(@nCount=0)
                        BEGIN
                        SELECT @SecuritiesPriorToAcquisition=SecuritiesPriorToAcquisition FROM #tmpTransactionDetails WHERE ID=@nUsrID+1
                        END
                        ELSE
                        BEGIN
                        SET @SecuritiesPriorToAcquisition=@Balance
                        END
                        SELECT @TDID=TransactionDetailsId,@nTransactionTypeCodeId=TransactionTypeCodeId,@nQuantity=Quantity,@nQuantity2=Quantity2,@SecurityTypeCodeId=SecurityTypeCodeID,@nModeOfAcquisitionCodeId=ModeOfAcquisitionCodeId FROM #tmpTransactionDetails WHERE ID=@nUsrID+1
                                                
                        EXEC @RC =  st_tra_GetImpactOnPostQuantity @nTransactionTypeCodeId,@nModeOfAcquisitionCodeId,@SecurityTypeCodeId,@nImpactOnPostQuantity OUTPUT,
						@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT, @out_sSQLErrMessage OUTPUT
						                    
                        IF @nCount=0
                        BEGIN 
                                                 
							  IF @nImpactOnPostQuantity = @nImpactonPostShareQuantityAdd
							  BEGIN								
								SET @Balance=@SecuritiesPriorToAcquisition+@nQuantity
							  END
							  ELSE IF @nImpactOnPostQuantity = @nImpactonPostShareQuantityLess
							  BEGIN								
								SET @Balance=@SecuritiesPriorToAcquisition-@nQuantity
							  END
							  ELSE IF @nImpactOnPostQuantity = @nImpactonPostShareQuantityBoth OR @nImpactOnPostQuantity = @nImpactonPostShareQuantityNo
							  BEGIN
								SET @Balance=@SecuritiesPriorToAcquisition
							  END 
							  
							  IF(@nTransactionTypeCodeId=143005)
							  BEGIN
								SET @Balance=@Balance-@nQuantity2
							  END                       
                              
                              IF @SecurityTypeCodeId=@SecurityType_Share  
                              BEGIN									  
								SET @dPostPercentage = ((@Balance)* @nMultiplier) / @dPaidUpShare 	
								UPDATE tra_TransactionDetails SET PerOfSharesPostTransaction=@dPostPercentage WHERE TransactionDetailsId=@TDID
                              END					  
							  				                              
                        END
                                                
                        IF @nCount>0
                        BEGIN                                     
                              IF @nCount=1
                              BEGIN	
                                                                                         
								  IF @SecurityTypeCodeId=@SecurityType_Share
                                  BEGIN 
                                      SET @dPrePercentage = (@Balance * @nMultiplier) / @dPaidUpShare 
                                  END
                                    
                                  IF  @SecurityTypeCodeId=@SecurityType_Share AND @nImpactOnPostQuantity = @nImpactonPostShareQuantityAdd
                                  BEGIN
                                        SET @dPostPercentage = ((@Balance + @nQuantity )* @nMultiplier) / @dPaidUpShare 
                                  END
                                  ELSE IF @SecurityTypeCodeId=@SecurityType_Share AND @nImpactOnPostQuantity = @nImpactonPostShareQuantityLess
                                  BEGIN
                                        SET @dPostPercentage = ((@Balance - @nQuantity )* @nMultiplier) / @dPaidUpShare 
                                  END
                                  ELSE IF @nImpactOnPostQuantity = @nImpactonPostShareQuantityBoth OR @nImpactOnPostQuantity = @nImpactonPostShareQuantityNo
								  BEGIN
										SET @dPostPercentage = (@Balance * @nMultiplier) / @dPaidUpShare 
								  END 
                                  
                                  IF @SecurityTypeCodeId=@SecurityType_Share  
                                  BEGIN		
									UPDATE tra_TransactionDetails SET SecuritiesPriorToAcquisition=@Balance,PerOfSharesPreTransaction=@dPrePercentage,PerOfSharesPostTransaction=@dPostPercentage WHERE TransactionDetailsId=@TDID
                                  END
                                  ELSE  
                                  BEGIN		
									UPDATE tra_TransactionDetails SET SecuritiesPriorToAcquisition=@Balance WHERE TransactionDetailsId=@TDID
                                  END
                                                                   
                                  IF @nImpactOnPostQuantity = @nImpactonPostShareQuantityAdd
								  BEGIN								
									SET @Balance=@SecuritiesPriorToAcquisition+@nQuantity
								  END
								  ELSE IF @nImpactOnPostQuantity = @nImpactonPostShareQuantityLess
								  BEGIN								
									SET @Balance=@SecuritiesPriorToAcquisition-@nQuantity
								  END
								  ELSE IF @nImpactOnPostQuantity = @nImpactonPostShareQuantityBoth OR @nImpactOnPostQuantity = @nImpactonPostShareQuantityNo
								  BEGIN
									SET @Balance=@SecuritiesPriorToAcquisition
								  END 
								  IF(@nTransactionTypeCodeId=143005)
								  BEGIN
									SET @Balance=@Balance-@nQuantity2
								  END  
							  END
							                                
                              ELSE
                              BEGIN
                              							                                    
                                  IF @SecurityTypeCodeId=@SecurityType_Share 
                                  BEGIN
                                        SET @dPrePercentage = (@Balance * @nMultiplier) / @dPaidUpShare 
                                  END
                              
                                  IF  @SecurityTypeCodeId=@SecurityType_Share AND @nImpactOnPostQuantity = @nImpactonPostShareQuantityAdd
                                  BEGIN
                                        SET @dPostPercentage = ((@Balance + @nQuantity )* @nMultiplier) / @dPaidUpShare 
                                  END
                                  ELSE IF @SecurityTypeCodeId=@SecurityType_Share AND @nImpactOnPostQuantity = @nImpactonPostShareQuantityLess
                                  BEGIN
                                        SET @dPostPercentage = ((@Balance - @nQuantity )* @nMultiplier) / @dPaidUpShare 
                                  END
                                  ELSE IF @nImpactOnPostQuantity = @nImpactonPostShareQuantityBoth OR @nImpactOnPostQuantity = @nImpactonPostShareQuantityNo
								  BEGIN
										SET @dPostPercentage = (@Balance * @nMultiplier) / @dPaidUpShare 
								  END 
                                  
                                  IF @SecurityTypeCodeId=@SecurityType_Share  
                                  BEGIN		
									UPDATE tra_TransactionDetails SET SecuritiesPriorToAcquisition=@Balance,PerOfSharesPreTransaction=@dPrePercentage,PerOfSharesPostTransaction=@dPostPercentage WHERE TransactionDetailsId=@TDID
                                  END
                                  ELSE  
                                  BEGIN		
									UPDATE tra_TransactionDetails SET SecuritiesPriorToAcquisition=@Balance WHERE TransactionDetailsId=@TDID
                                  END                                 
                                  
                                  IF @nImpactOnPostQuantity = @nImpactonPostShareQuantityAdd
								  BEGIN								
									SET @Balance=@SecuritiesPriorToAcquisition+@nQuantity
								  END
								  ELSE IF @nImpactOnPostQuantity = @nImpactonPostShareQuantityLess
								  BEGIN								
									SET @Balance=@SecuritiesPriorToAcquisition-@nQuantity
								  END
								  ELSE IF @nImpactOnPostQuantity = @nImpactonPostShareQuantityBoth OR @nImpactOnPostQuantity = @nImpactonPostShareQuantityNo
								  BEGIN
									SET @Balance=@SecuritiesPriorToAcquisition
								  END 
								  IF(@nTransactionTypeCodeId=143005)
								  BEGIN
									SET @Balance=@Balance-@nQuantity2
								  END                                                                
                              END                              
                        END
                        SET @nCount = @nCount + 1
                        SET @nUsrID=@nUsrID+1
                  END
				SET @nUsrCount=@nUsrCount+1
            END  
            DROP TABLE #tmpTransactionUsrDetails    
	END   
                  
            DROP TABLE #tmpTransactionDetails
            
		
		--Check COnfirmation Event is occured or not
		IF(EXISTS(SELECT EL.EventLogId FROM eve_EventLog EL
					JOIN tra_TransactionMaster TM ON EL.MapToId  = TM.TransactionMasterId AND MapToTypeCodeId = 132005
					WHERE EL.EventCodeId = @CONST_INITIAL_DISCLOSURE_CONFIRM_EVENT 
						AND TM.DisclosureTypeCodeId = @CONST_INITIAL_DISCLOSURE_TYPE_CODEID 
						AND TransactionMasterId = @inp_sTransactionMasterId))
		BEGIN
			SET @out_nDisclosureCompletedFlag = 1
		END
		
		SELECT @out_nTransactionMasterId = @inp_sTransactionMasterId
		END
		-- in case required to return for partial save case.
		IF @inp_sCalledFrom <> 'MASSUPLOAD'
		BEGIN
			Select TransactionMasterId, PreclearanceRequestId, UserInfoId, DisclosureTypeCodeId, TransactionStatusCodeId, NoHoldingFlag, TradingPolicyId,PeriodEndDate ,ConfirmCompanyHoldingsFor
			  ,ConfirmNonCompanyHoldingsFor,CDDuringPE,HardCopyReq
				From tra_TransactionMaster
				Where TransactionMasterId = @inp_sTransactionMasterId
		END
		
		SET @out_nReturnValue = 0
		RETURN @out_nReturnValue
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()
		SET @out_nSQLErrCode = @ERR_TRANSACTIONMASTER_SAVE;
		-- Return common error if required, otherwise specific error.		
		SET @out_nReturnValue  = dbo.uf_com_GetErrorCode(@ERR_TRANSACTIONMASTER_SAVE, ERROR_NUMBER())
		RETURN @out_nReturnValue		
	END CATCH
END