IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_tra_TradingTransactionSave_Override')
DROP PROCEDURE [dbo].[st_tra_TradingTransactionSave_Override]
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
Raghvendra		12-Oct-2015	Moved the logic from st_tra_TradingTransactionSave to st_tra_TradingTransactionSave_Override, so that the output of the procedure can be customised.
Gaurishankar	25-Nov-2015	Added new parameter for New disclosure and contra trade change
Tushar			02-Dec-2015	Added Column related to the Contra Trade change 
Tushar			03-Dec-2015 Change condition for selection ESOP and Other flag in case precleanrce
Tushar			08-Dec-2015	Datatype change for INT to decimal for @inp_dESOPExcerciseOptionQty & @inp_dOtherExcerciseOptionQty
Tushar			12-Jan-2016	DateOfBecomingInsider is editable remove from transaction details page. 
Raghvendra		31-Mar-2016	Fixed to set the DateOfAcquisition as only date part and not DateTime
Tushar			04-May-2016	Change the logic to save the Date of Acquisition set in initial disclosure 
							Following cases are used for to set the value of Date of Acquisition of Initial Disclosure based on user being insider or not-
							If User in Insider Type - 
							IF Date of Becoming Insider  <=  Go live date set in Trading policy under the label 
															 (Initial Disclosure before of application go live)
									THEN Date of Acquisition of Initial Disclosure is =  applicable Periods first date.
							ELSE
									THEN Date of Acquisition of Initial Disclosure is = Date of Becoming Insider
							IF User is Non Insider Type-
							IF Date of Joining  <=  Go live date set in Trading policy under the label 
															 (Initial Disclosure before of application go live)
									THEN Date of Acquisition of Initial Disclosure is =  applicable Periods first date.
							ELSE
									THEN Date of Acquisition of Initial Disclosure is = Date of Joining
							Note:- In Trading Policy Period only set in Multiple Transaction Trade Above for condition.
								   If Period is not found or it null then this case is not handled.
							       (Discuss with Deepak on 4 May 2016) 		
Tushar		20-Jun-2016		If AutoSubmit Trannsaction flag Yes Then Calculate date else set current date for date of acquaisation for
							Initial Disclosure.		
Tushar		12-Aug-2016		Update Security Type code id in Transaction Master for first transaction details before validation of transaction details.	
Raghvendra	07-Sep-2016		Changed the GETDATE() call with function dbo.uf_com_GetServerDate(). This function will return the date to be used as server date.
Usage:
DECLARE @RC int
EXEC st_tra_TradingTransactionSave ,1
-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_tra_TradingTransactionSave_Override] 
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
	@inp_iLoggedInUserId	INT,
	@inp_sCalledFrom	VARCHAR(20) = '',	
	@inp_bSegregateESOPAndOtherExcerciseOptionQtyFalg BIT,
	@inp_dESOPExcerciseOptionQty decimal(10, 0),
	@inp_dOtherExcerciseOptionQty decimal(10, 0),
	@inp_bESOPExcerseOptionQtyFlag BIT,
	@inp_bOtherESOPExcerseOptionFlag BIT,
	@inp_sContractSpecification VARCHAR(50),
	@out_nTransactionDetailsID BIGINT = 0 OUTPUT,
	@out_nReturnValue		INT = 0 OUTPUT,
	@out_nSQLErrCode		INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage		NVARCHAR(500) = '' OUTPUT,	-- Output SQL Error Message, if error occurred.
	@inp_CurrencyId int=0
AS
BEGIN

	DECLARE @ERR_TRADINGTRANSACTIONDETAILS_SAVE INT 
	DECLARE @ERR_TRADINGTRANSACTIONDETAILS_NOTFOUND INT
	DECLARE @nTmpRet INT = 0
	DECLARE @dQuantity decimal(10, 0)
	DECLARE @dValue decimal(10, 0)
	DECLARE @nWarningMsg INT
	DECLARE @nPCLID BIGINT
	DECLARE @bESOPExcerseOptionQtyFlag BIT
	DECLARE @bOtherExcerseOptionQtyFlag BIT
	DECLARE @nDisclosureType INT
	DECLARE @nDisclosureTypeInitial INT = 147001
	DECLARE @nUserInfoID	BIGINT
	DECLARE @nDateOfBecomingInsider DATETIME
	DECLARE @nDateOfJoining DATETIME
	DECLARE @nTradingPolicyID	INT
	DECLARE @nApplicationGoLiveDate	DATETIME
	DECLARE @nPeriodType								INT
	DECLARE @dtPEStartDate								DATETIME
	DECLARE @dtPEEndDate								DATETIME
	DECLARE @nYearCodeId								INT, 
			@nPeriodCodeId								INT 
	DECLARE @dtToday									DATETIME = dbo.uf_com_GetServerDate()
	DECLARE @DBNAME VARCHAR(100) = UPPER((SELECT DB_NAME()))
	DECLARE @FIND_AXISBANK VARCHAR(50) = 'AXISBANK'	
	
	DECLARE @nAutoSubmitTransactionFlag					INT
	DECLARE @nAutoSubmitYesTransactionFlag				INT = 178002
	
	
	BEGIN TRY
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;
		
		--if(@inp_dtDateOfAcquisition IS NULL)
		--BEGIN
		--	SELECT @inp_dtDateOfAcquisition = CONVERT(Date, dbo.uf_com_GetServerDate())
		--END
		
		--Initialize variables
		SELECT	@ERR_TRADINGTRANSACTIONDETAILS_SAVE = 17328,  -- Not defined
				@ERR_TRADINGTRANSACTIONDETAILS_NOTFOUND = 17329 -- Not defined
		
	
		SELECT @nPCLID = TM.PreclearanceRequestId ,
		@bESOPExcerseOptionQtyFlag = ESOPExcerciseOptionQtyFlag,
		@bOtherExcerseOptionQtyFlag = OtherESOPExcerciseOptionQtyFlag,
		@nDisclosureType = TM.DisclosureTypeCodeId,
		@nUserInfoID = TM.UserInfoId,
		@nTradingPolicyID = TM.TradingPolicyId
		FROM tra_TransactionMaster TM
		LEFT JOIN tra_PreclearanceRequest PR ON TM.PreclearanceRequestId = PR.PreclearanceRequestId
		WHERE TransactionMasterId = @inp_iTransactionMasterId
		
		/*
		If User in Insider Type - 
							IF Date of Becoming Insider  <=  Go live date set in Trading policy under the label 
															 (Initial Disclosure before of application go live)
									THEN Date of Acquisition of Initial Disclosure is =  applicable Periods first date.
							ELSE
									THEN Date of Acquisition of Initial Disclosure is = Date of Becoming Insider
							IF User is Non Insider Type-
							IF Date of Joining  <=  Go live date set in Trading policy under the label 
															 (Initial Disclosure before of application go live)
									THEN Date of Acquisition of Initial Disclosure is =  applicable Periods first date.
							ELSE
									THEN Date of Acquisition of Initial Disclosure is = Date of Joining
		
		*/
		IF (@nDisclosureType  = @nDisclosureTypeInitial AND @inp_dtDateOfAcquisition IS NULL)
		BEGIN
			DECLARE @nUserInfoID1 INT
			DECLARE @nUserTypeCode INT
			SELECT @nUserTypeCode=UserTypeCodeId FROM usr_UserInfo WHERE UserInfoId=@nUserInfoID
			
			SELECT @nAutoSubmitTransactionFlag = AutoSubmitTransaction
			 FROM mst_Company WHERE IsImplementing = 1
			IF @nAutoSubmitTransactionFlag = @nAutoSubmitYesTransactionFlag
			BEGIN
				IF(@nUserTypeCode=101007)
				BEGIN
					SELECT @nUserInfoID1=UserInfoId FROM usr_UserRelation WHERE UserInfoIdRelative=@nUserInfoID
				END
				ELSE
				BEGIN
					SET @nUserInfoID1=@nUserInfoID
				END
				SELECT @nDateOfBecomingInsider = DateOfBecomingInsider,
				 @nDateOfJoining =  DateOfJoining  
				 FROM usr_UserInfo WHERE UserInfoId = @nUserInfoID1
				
				SELECT @nApplicationGoLiveDate = DiscloInitDateLimit,
						@nPeriodType = StExMultiTradeFreq
				FROM rul_TradingPolicy 
				WHERE TradingPolicyId = @nTradingPolicyID
				
				
				--SELECT @nDateOfBecomingInsider,@nDateOfJoining,@nApplicationGoLiveDate,@nPeriodType
				----print 'Find PE dates'
				SET @nPeriodType = CASE WHEN @nPeriodType = 137001 THEN 123001 -- Yearly
									WHEN @nPeriodType = 137002	THEN 123003 -- Quarterly
									WHEN @nPeriodType = 137003	THEN 123004 -- Monthly
									WHEN @nPeriodType = 137004	THEN 123002 -- Weekly
									ELSE @nPeriodType
									END

				EXECUTE st_tra_PeriodEndDisclosureStartEndDate2
				   @nYearCodeId OUTPUT, @nPeriodCodeId OUTPUT,@dtToday, @nPeriodType, 0, @dtPEStartDate OUTPUT, @dtPEEndDate OUTPUT, @out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT, @out_sSQLErrMessage OUTPUT
				   
				
				IF (@nDateOfBecomingInsider IS NOT NULL AND @nDateOfBecomingInsider <= @nApplicationGoLiveDate)
				BEGIN
					SET @inp_dtDateOfAcquisition = @dtPEStartDate
				END
				ELSE IF @nDateOfBecomingInsider IS NOT NULL AND @nDateOfBecomingInsider > @nApplicationGoLiveDate
				BEGIN
					SET @inp_dtDateOfAcquisition = @nDateOfBecomingInsider
				END
				ELSE IF @nDateOfBecomingInsider IS NULL AND @nDateOfJoining <= @nApplicationGoLiveDate
				BEGIN
					SET @inp_dtDateOfAcquisition = @dtPEStartDate
				END
				ELSE IF @nDateOfBecomingInsider IS NULL AND @nDateOfJoining > @nApplicationGoLiveDate
				BEGIN
					SET @inp_dtDateOfAcquisition = @nDateOfJoining
				END
				END
			ELSE
			BEGIN
				SET @inp_dtDateOfAcquisition = (select CreatedOn from usr_UserInfo where UserInfoId = @nUserInfoID)
			END

			--made this change for period end-user has to submit his relatives initial dsclousre
			--changed date of acq from current date to created on date
			IF @nUserTypeCode = 101007
			BEGIN
				SET @inp_dtDateOfAcquisition = (select CreatedOn from usr_UserInfo where UserInfoId = @nUserInfoID)
			END
		END
		
		--select @inp_dtDateOfAcquisition
		
		IF(@nPCLID IS NOT NULL AND @nPCLID > 0)
		BEGIN
			SET @inp_bESOPExcerseOptionQtyFlag = @bESOPExcerseOptionQtyFlag 
			SET @inp_bOtherESOPExcerseOptionFlag = @bOtherExcerseOptionQtyFlag
		END
		
		SELECT @dQuantity = @inp_dQuantity, -- + @inp_dQuantity2,
				@dValue = @inp_dValue --+ @inp_dValue2
				
		-- Update Security type in TransactionMaster, if the disclosure type is continuous and this is the first transaction detail entry
		IF EXISTS (SELECT TransactionMasterId FROM tra_TransactionMaster WHERE TransactionMasterId = @inp_iTransactionMasterId AND DisclosureTypeCodeId = 147002)
		BEGIN
			-- Update transaction master, if it is first transaction
			IF NOT EXISTS(SELECT * FROM tra_TransactionDetails WHERE TransactionMasterId = @inp_iTransactionMasterId)
			BEGIN
				UPDATE tra_TransactionMaster
				SET SecurityTypeCodeId = @inp_iSecurityTypeCodeId
				WHERE TransactionMasterId = @inp_iTransactionMasterId
			END
		END
				
		EXEC @nTmpRet = st_tra_TransactionDetailsValidation @inp_iTransactionDetailsId, @inp_iTransactionMasterId, @inp_iSecurityTypeCodeId, 
															@inp_iForUserInfoId, @inp_iDMATDetailsID, @inp_iCompanyId, 
															--@inp_dNoOfSharesVotingRightsAcquired, @inp_dPercentageOfSharesVotingRightsAcquired, 
															@inp_dtDateOfAcquisition, @inp_dtDateOfInitimationToCompany, @inp_iModeOfAcquisitionCodeId, 
															--@inp_dShareHoldingSubsequentToAcquisition, 
															@inp_iExchangeCodeId, 
															@inp_iTransactionTypeCodeId, @dQuantity, @dValue, @inp_iLoggedInUserId,
															@inp_dESOPExcerciseOptionQty ,@inp_dOtherExcerciseOptionQty ,
															@inp_bESOPExcerseOptionQtyFlag, @inp_bOtherESOPExcerseOptionFlag, @inp_iLotSize,
															@nWarningMsg OUTPUT, @out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT, @out_sSQLErrMessage OUTPUT
		
		IF @out_nReturnValue <> 0
		BEGIN
			--SET @out_nReturnValue = @ERR_TRADINGTRANSACTIONDETAILS_SAVE
			RETURN @out_nReturnValue
		END
		
		-- DateOfBecomingInsider is editable remove from transaction details page. 
		
		/*UPDATE u 
		SET DateOfBecomingInsider = @inp_dDateOfBecomingInsider,
			ModifiedBy = @inp_iLoggedInUserId,
			ModifiedOn = dbo.uf_com_GetServerDate()
		FROM usr_UserInfo u JOIN tra_TransactionMaster t ON u.UserInfoId = t.UserInfoId
		WHERE t.TransactionMasterId = @inp_iTransactionMasterId*/

	
		
		
		--Save the Trading transaction details 
		IF @inp_iTransactionDetailsId = 0
		BEGIN
			--IF NOT EXISTS(SELECT TransactionDetailsId FROM tra_TransactionDetails WHERE TransactionDetailsId = @inp_iTransactionDetailsId )
			--BEGIN
			--	SET @inp_iIsDefault = 1
			--END		
			Insert into tra_TransactionDetails(
						TransactionMasterId
					  ,SecurityTypeCodeId
					  ,ForUserInfoId
					  ,DMATDetailsID
					  ,CompanyId
					  ,SecuritiesPriorToAcquisition
					  ,PerOfSharesPreTransaction
					  ,DateOfAcquisition
					  ,DateOfInitimationToCompany
					  ,ModeOfAcquisitionCodeId
					  ,PerOfSharesPostTransaction
					  ,ExchangeCodeId
					  ,TransactionTypeCodeId
					  ,Quantity
					  ,Value
					  ,Quantity2
					  ,Value2
					  ,TransactionLetterId
					  ,LotSize
					  ,ContractSpecification
					  ,SegregateESOPAndOtherExcerciseOptionQtyFalg
					  ,ESOPExcerciseOptionQty
					  ,OtherExcerciseOptionQty
					  ,ESOPExcerseOptionQtyFlag
					  ,OtherESOPExcerseOptionFlag
					  ,CreatedBy, CreatedOn, ModifiedBy, ModifiedOn,CurrencyId )
			Values (
					@inp_iTransactionMasterId ,
					@inp_iSecurityTypeCodeId ,
					@inp_iForUserInfoId ,
					@inp_iDMATDetailsID ,
					@inp_iCompanyId ,
					@inp_dSecuritiesPriorToAcquisition,
					@inp_dPerOfSharesPreTransaction ,
					@inp_dtDateOfAcquisition ,
					CASE WHEN (CHARINDEX(@FIND_AXISBANK, @DBNAME) > 0) THEN NULL ELSE @inp_dtDateOfInitimationToCompany END ,
					@inp_iModeOfAcquisitionCodeId  ,
					@inp_dPerOfSharesPostTransaction ,
					@inp_iExchangeCodeId ,
					@inp_iTransactionTypeCodeId ,
					@inp_dQuantity ,
					@inp_dValue,
					@inp_dQuantity2 ,
					@inp_dValue2,
					@inp_iTransactionLetterId,
					@inp_iLotSize,
					@inp_sContractSpecification,
					@inp_bSegregateESOPAndOtherExcerciseOptionQtyFalg,
					@inp_dESOPExcerciseOptionQty,
					@inp_dOtherExcerciseOptionQty,
					@inp_bESOPExcerseOptionQtyFlag,
					@inp_bOtherESOPExcerseOptionFlag,
					@inp_iLoggedInUserId, dbo.uf_com_GetServerDate(), @inp_iLoggedInUserId, dbo.uf_com_GetServerDate(),@inp_CurrencyId )
					SELECT @inp_iTransactionDetailsId = SCOPE_IDENTITY()
		END
		ELSE
		BEGIN
			--Check if the RoleMaster whose details are being updated exists
			IF (NOT EXISTS(SELECT TransactionDetailsId FROM tra_TransactionDetails WHERE TransactionDetailsId = @inp_iTransactionDetailsId))		
			BEGIN
				SET @out_nReturnValue = @ERR_TRADINGTRANSACTIONDETAILS_NOTFOUND
				RETURN (@out_nReturnValue)
			END			
			Update tra_TransactionDetails
			Set 	TransactionMasterId = @inp_iTransactionMasterId
					,SecurityTypeCodeId = @inp_iSecurityTypeCodeId
					,ForUserInfoId = @inp_iForUserInfoId
					,DMATDetailsID = @inp_iDMATDetailsID
					,CompanyId = @inp_iCompanyId
					,SecuritiesPriorToAcquisition = @inp_dSecuritiesPriorToAcquisition
					,PerOfSharesPreTransaction = @inp_dPerOfSharesPreTransaction
					,DateOfAcquisition = @inp_dtDateOfAcquisition
					,DateOfInitimationToCompany = @inp_dtDateOfInitimationToCompany
					,ModeOfAcquisitionCodeId = @inp_iModeOfAcquisitionCodeId
					,PerOfSharesPostTransaction = @inp_dPerOfSharesPostTransaction
					,ExchangeCodeId = @inp_iExchangeCodeId
					,TransactionTypeCodeId = @inp_iTransactionTypeCodeId
					,Quantity = @inp_dQuantity
					,Value = @inp_dValue
					,Quantity2 = @inp_dQuantity2
					,Value2 = @inp_dValue2
					,TransactionLetterId = @inp_iTransactionLetterId
					,LotSize = @inp_iLotSize
					,ContractSpecification = @inp_sContractSpecification
					,SegregateESOPAndOtherExcerciseOptionQtyFalg = @inp_bSegregateESOPAndOtherExcerciseOptionQtyFalg
					,ESOPExcerciseOptionQty = @inp_dESOPExcerciseOptionQty
					,OtherExcerciseOptionQty = @inp_dOtherExcerciseOptionQty
					,ESOPExcerseOptionQtyFlag = @inp_bESOPExcerseOptionQtyFlag
					,OtherESOPExcerseOptionFlag = @inp_bOtherESOPExcerseOptionFlag
					,ModifiedBy	= @inp_iLoggedInUserId
					,ModifiedOn = dbo.uf_com_GetServerDate()
					,CurrencyId=@inp_CurrencyId
			Where TransactionDetailsId = @inp_iTransactionDetailsId	
			
		END
		
		SELECT @out_nTransactionDetailsID = @inp_iTransactionDetailsId
		-- in case required to return for partial save case.
		IF @inp_sCalledFrom <> 'MASSUPLOAD'
		BEGIN
			Select TransactionDetailsId,
				TransactionMasterId
				,SecurityTypeCodeId
				,ForUserInfoId
				,DMATDetailsID
				,CompanyId
				,SecuritiesPriorToAcquisition
				,PerOfSharesPreTransaction
				,DateOfAcquisition
				,DateOfInitimationToCompany
				,ModeOfAcquisitionCodeId
				,PerOfSharesPostTransaction
				,ExchangeCodeId
				,TransactionTypeCodeId
				,Quantity
				,Value
				,Quantity2
				,Value2
				,TransactionLetterId
				,LotSize
				,ContractSpecification
				,SegregateESOPAndOtherExcerciseOptionQtyFalg
				,ESOPExcerciseOptionQty
				,OtherExcerciseOptionQty
				,ESOPExcerseOptionQtyFlag
				,OtherESOPExcerseOptionFlag
				,CurrencyId
				From tra_TransactionDetails
				Where TransactionDetailsId = @inp_iTransactionDetailsId	
		END

		SET @out_nReturnValue = 0
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