IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_tra_TransactionDetailsValidation_OS')
DROP PROCEDURE [dbo].[st_tra_TransactionDetailsValidation_OS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Procedure to check validation.

Returns:		0, if Success.
				
Created by:     Tushar Wakchaure
Created on:		19-Mar-2019

-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_tra_TransactionDetailsValidation_OS]
	@inp_iTransactionDetailsId			BIGINT,
	@inp_iTransactionMasterId			BIGINT,
	@inp_iSecurityTypeCodeId			INT,
	@inp_iForUserInfoId					INT,
	@inp_iDMATDetailsID					INT,
	@inp_iCompanyId						INT,
	@inp_dtDateOfAcquisition			DATETIME,
	@inp_dtDateOfInitimationToCompany	DATETIME,
	@inp_iModeOfAcquisitionCodeId		INT ,
	@inp_iExchangeCodeId				INT,
	@inp_iTransactionTypeCodeId			INT,
	@inp_dQuantity						DECIMAL(10, 0),
	@inp_dValue							DECIMAL(10, 0),
	@inp_iLotSize                       INT,
    @inp_sContractSpecification VARCHAR(50),
	@inp_sCompanyName			VARCHAR(300),
	@inp_iLoggedInUserId	INT,
	@inp_sCalledFrom	VARCHAR(20) = '',
	@inp_dOtherExcerciseOptionQty decimal(10, 0),	
	@out_nWarningMsg					INT = 0 OUTPUT,
	@out_nReturnValue					INT = 0 OUTPUT,
	@out_nSQLErrCode					INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage					VARCHAR(500) = '' OUTPUT    -- Output SQL Error Message, if error occurred.	
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
	DECLARE @nDisclosureStatusConfirmed         INT = 148003
	
	-- Security type {Equity / Derivative}
	DECLARE @nSecurityType_Share				INT = 139001
	DECLARE @nSecurityType_Derivative			INT = 139002
	
	--- Error codes
	DECLARE @ERR_InitialReqBuyTransOnly INT = 17044 -- Case #1 - Transaction mode can only be 'Buy' for initial disclosure.
	DECLARE @ERR_SecurityUserTransaction_NotSameAsPreclearance INT = 17045 -- Case #2 - Security Type, User and transaction should be same as the one defined on preclearance.
	DECLARE @ERR_QtyExceedsLimitInPreclearance INT = 52087 -- Case #3 - Total numbers of trading quantity should not exceed the proposed trade quantity specified in the preclearance request.
	DECLARE @ERR_AllTransactionsShouldFallUnderSamePeriod INT = 17047 -- Case #4 - All the transactions entered together should be for the same period.
	DECLARE @ERR_ContiDisclosureNotAllowed_PEExists INT = 17048 -- Case #5 - Cannot save details for continuous disclosure, since period end disclosure for the future period is made.
	DECLARE @ERR_ContiDisclosureNotAllowed_PreclearanceRejected INT = 17060 -- Case #6 - If Preclearance request is rejected, user should not enter details against it
	DECLARE @ERR_SECURITYTYPEDOESNOTMATCH INT = 17327 -- case # 26 - Security type cannot be different for transactions of continuous disclosure.
	DECLARE @ERR_AcqDateShouldBeInThePeriodRange INT = 17331 -- Case #27 - Check while adding period end disclosure that the date is in the range of the selected period.
	DECLARE @ERR_AcqDateShouldBeGreaterThanPreclearanceApproveDate INT = 52108 -- case #28 - Date Of acquisition must be greater than date of approval. (in case of pre-clearance)
	DECLARE @ERR_AcqDateShouldBeGreaterThanInitialDisclosure INT = 52109 -- case #32 - Date Of acquisition must be greater than date of initial disclosure.
	DECLARE @ERR_QTYSUMERROR INT  = 16328  -- Case #34 Number of shares or Units must be sum of ESOP Excercise Qty and Other than ESOP Excercise Qty.
	DECLARE @ERR_NonNegativeNumberESOPAndOtherQty INT = 16329 -- Case #35 Enter valid data for ESOP Excercise Qty and Other than ESOP Excercise Qty.
	DECLARE @ERR_SELECTATLEASTONEPOOL INT = 16330 -- Case #36 Please select at least one option of exercise pool.', 'Please select at least one option of exercise pool.', 'en-US', 103008, 104001,122036, 1, dbo.uf_com_GetServerDate())
	DECLARE @ERR_TransactionDetailsForApplicablePeriod INT = 16331 -- Case #36 Transcation details must be entered should be for the applicable period.
	DECLARE @ERR_InitialDisclosureforRelative INT = 52110 -- Case #37 Enter initial disclosuer for relative first.
	DECLARE @ERR_ContinuousDisclosureforDupPNTEntry INT = 52086 -- Case #37 Enter initial disclosuer for relative first.
	DECLARE @ERR_UPDATEEXCERCISEBALANCEPOOL INT = 16327
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
	DECLARE @nEvent_Preclearance_Approve INT = 153046
	DECLARE @nMapToTypeCode_Preclearance INT = 132015
	
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
	DECLARE @nVirtualQuantity           INT = 0
	DECLARE @nActualQuantity            INT = 0
	DECLARE @nPeriodCodeId              INT = 124001

	DECLARE @nImptPostshareQtyCodeId_ForPledge INT
	DECLARE @nActionCodeId_ForPledge INT
	DECLARE @bIsAllowNegativeBalance BIT
	DECLARE @nFirstSecurityTypeCodeId     INT    

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
		FROM tra_TransactionMaster_OS 
		WHERE TransactionMasterId = @inp_iTransactionMasterId

		select @nImptPostshareQtyCodeId = impt_post_share_qty_code_id, @nActionCodeId = action_code_id from tra_TransactionTypeSettings_OS where trans_type_code_id = @inp_itransactiontypecodeid and mode_of_acquis_code_id = @inp_imodeofacquisitioncodeid and security_type_code_id = @inp_iSecurityTypeCodeId
		
		IF (@inp_iTransactionDetailsId != 0 AND NOT EXISTS (SELECT TransactionDetailsId FROM tra_TransactionDetails_OS WHERE TransactionMasterId = @inp_iTransactionMasterId AND TransactionDetailsId = @inp_iTransactionDetailsId))
		BEGIN
			SET @out_nReturnValue = @ERR_TRANSACTIONMASTER_SAVE
			RETURN @out_nReturnValue
		END
		IF ( NOT EXISTS (SELECT TransactionMasterId FROM tra_TransactionMaster_OS WHERE TransactionMasterId = @inp_iTransactionMasterId AND TransactionStatusCodeId IN(@nDisclosureStatusForDocumentUploaded,@nDisclosureStatusForNotConfirmed)))
		BEGIN
			SET @out_nReturnValue = @ERR_TRANSACTIONMASTER_SAVE
			RETURN @out_nReturnValue
		END

		IF @nDisclosureType = @nDisclosureType_Continuous
		BEGIN
		    IF @nPreclearanceId IS NOT NULL
			BEGIN
				print ' CASE #28 '
				-- While saving transaction details for pre-clearance taken, 
				-- check that date of acquisition must be greater than date of approval of per-clearance
				-- CASE #28
				SELECT @dtEventDate = EL.EventDate FROM eve_EventLog EL 
				WHERE EL.MapToTypeCodeId = @nMapToTypeCode_Preclearance AND EL.EventCodeId = @nEvent_Preclearance_Approve AND EL.MapToId = @nPreclearanceId
				IF @inp_dtDateOfAcquisition < convert(date,@dtEventDate)
				BEGIN
					SET @out_nReturnValue = @ERR_AcqDateShouldBeGreaterThanPreclearanceApproveDate
					RETURN @out_nReturnValue
				END

		    END
				
			-- Total numbers of trading quantity should not exceed the proposed trade quantity specified in the request.
			IF(@inp_iTransactionTypeCodeId=143002)
			BEGIN
				DECLARE @ActualQuantity INT=0
				SELECT @ActualQuantity=ActualQuantity
				FROM tra_BalancePool_OS WHERE DMATDetailsID=@inp_iDMATDetailsID AND CompanyID=@inp_iCompanyId AND SecurityTypeCodeId=@inp_iSecurityTypeCodeId
					
				DECLARE @nTotalTradeQnty INT=0
				DECLARE @nTotalTradingQty INT=0
				SELECT @nTotalTradeQnty= SUM(ISNULL(Quantity, 0)) FROM tra_TransactionDetails_OS WHERE
				TransactionMasterId = @inp_iTransactionMasterId AND TransactionDetailsId<>@inp_iTransactionDetailsId
					 
				IF(@nTotalTradeQnty='' OR @nTotalTradeQnty IS NULL)
				BEGIN
					SET @nTotalTradeQnty=0
				END

				IF(@inp_iSecurityTypeCodeId = 139004 OR @inp_iSecurityTypeCodeId = 139005)
				BEGIN
				    SET @nTotalTradingQty = @inp_dQuantity * @inp_iLotSize + @nTotalTradeQnty
				END
				ELSE
				BEGIN
					SET @nTotalTradingQty = @inp_dQuantity + @nTotalTradeQnty
                END

				IF(@nTotalTradingQty > @ActualQuantity)
				BEGIN
					SET @out_nReturnValue = @ERR_QtyExceedsLimitInPreclearance
					RETURN @out_nReturnValue
				END	
			END		
							
			-- Transaction should not be allow to enter data before the initial disclosure date
			-- Case #32
			SELECT @dtEventDate = MIN(TD.DateOfAcquisition) FROM tra_TransactionMaster_OS TM
			JOIN tra_TransactionDetails_OS TD ON TM.TransactionMasterId = TD.TransactionMasterId
			WHERE TD.ForUserInfoId = @inp_iForUserInfoId
			AND DisclosureTypeCodeId  = @nDisclosureType_Initial
			AND DMATDetailsID = @inp_iDMATDetailsID
			AND (SecurityTypeCodeId = @inp_iSecurityTypeCodeId OR SecurityTypeCodeId IS NULL)
			GROUP BY TD.DateOfAcquisition
			ORDER BY DateOfAcquisition DESC
				
			IF CONVERT(DATE, @inp_dtDateOfAcquisition) < CONVERT(DATE,@dtEventDate)
			BEGIN
				SET @out_nReturnValue = @ERR_AcqDateShouldBeGreaterThanInitialDisclosure
				RETURN @out_nReturnValue
			END

			-------------
			IF (NOT EXISTS (SELECT TM.TransactionMasterId FROM tra_TransactionMaster_OS TM 
				JOIN tra_TransactionDetails_OS TD ON TM.TransactionMasterId=TD.TransactionMasterId 
				WHERE TM.DisclosureTypeCodeId=@nDisclosureType_Initial AND TD.ForUserInfoId=@inp_iForUserInfoId AND TM.TransactionStatusCodeId = 148003))
			BEGIN
					SET @out_nReturnValue = @ERR_InitialDisclosureforRelative
					RETURN @out_nReturnValue
			END	

			IF(@inp_sCalledFrom <> 'MASSUPLOAD')
			BEGIN
			IF EXISTS (SELECT * FROM tra_TransactionMaster_OS TM 			
			INNER JOIN tra_PreclearanceRequest_NonImplementationCompany PR ON PR.PreclearanceRequestId = TM.PreclearanceRequestId
			WHERE TM.TransactionStatusCodeId <> @nDisclosureStatusConfirmed AND TM.DisclosureTypeCodeId = @nDisclosureType_Continuous
			AND PR.DMATDetailsID= @inp_iDMATDetailsID AND PR.CompanyID= @inp_iCompanyId AND PR.SecurityTypeCodeId= @inp_iSecurityTypeCodeId
			AND PR.ReasonForNotTradingCodeId IS NULL AND TM.TransactionMasterId <> @inp_iTransactionMasterId)
		    BEGIN
					   
			   SET @out_nReturnValue = @ERR_ContinuousDisclosureforDupPNTEntry			 
			   RETURN @out_nReturnValue
		    END
		   
		   DECLARE @nParentTransactionID INT=0

		   SELECT @nParentTransactionID=ISNULL(ParentTransactionMasterId,0) FROM tra_TransactionMaster_OS WHERE TransactionMasterId=@inp_iTransactionMasterId

		   IF(@nParentTransactionID=0)
		   BEGIN
				IF EXISTS (SELECT * FROM tra_TransactionMaster_OS TM 			
				INNER JOIN tra_PreclearanceRequest_NonImplementationCompany PR ON PR.PreclearanceRequestId = TM.PreclearanceRequestId
				WHERE TM.TransactionStatusCodeId = @nDisclosureStatusConfirmed AND TM.DisclosureTypeCodeId = @nDisclosureType_Continuous
				AND PR.DMATDetailsID= @inp_iDMATDetailsID AND PR.CompanyID= @inp_iCompanyId AND PR.SecurityTypeCodeId= @inp_iSecurityTypeCodeId
				AND PR.ReasonForNotTradingCodeId IS NULL AND TM.TransactionMasterId <> @inp_iTransactionMasterId AND IsPartiallyTraded=1)
				BEGIN			   
					SET @out_nReturnValue = @ERR_ContinuousDisclosureforDupPNTEntry			 
					RETURN @out_nReturnValue
				END
			END


			IF EXISTS (SELECT * FROM tra_TransactionMaster_OS TM 
				INNER JOIN tra_TransactionDetails_OS TD ON TD.TransactionMasterId = TM.TransactionMasterId
				WHERE TM.TransactionStatusCodeId <> @nDisclosureStatusConfirmed AND TM.DisclosureTypeCodeId = @nDisclosureType_Continuous
				AND DMATDetailsID= @inp_iDMATDetailsID AND CompanyID= @inp_iCompanyId AND SecurityTypeCodeId= @inp_iSecurityTypeCodeId AND TransactionDetailsId <> @inp_iTransactionDetailsId)
			BEGIN
				SET @out_nReturnValue = @ERR_ContinuousDisclosureforDupPNTEntry
				RETURN @out_nReturnValue
			END
			END
			---------------------------------------------------pledge-----------------------------------------------------
			--- Check availabale balance in Excercise pool for pledge quantity
			IF((@inp_iTransactionTypeCodeId = @nTransactionType_Pledge OR @inp_iTransactionTypeCodeId = @nTransactionType_PledgeRevoke OR @inp_iTransactionTypeCodeId = @nTransactionType_PledgeInvoke) AND @nImptPostshareQtyCodeId = @nNo AND @nActionCodeId = @nSell)--AND @inp_iSecurityTypeCodeId = @nSecurityType_Shares)
			--AND @nContraTradeOption = @nContraTradeQuantityBase)
			BEGIN
				EXEC @nTmpRet = st_tra_TransactionExcercisePoolValidation_OS @inp_iTransactionDetailsID,@inp_iTransactionMasterId,@inp_iForUserInfoId,
								@inp_dQuantity,@inp_iSecurityTypeCodeId,'PledgeQty',@inp_iLotSize,@inp_iDMATDetailsID,@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT, @out_sSQLErrMessage OUTPUT
			
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
					SELECT TransactionTypeCodeId,ModeOfAcquisitionCodeId, Quantity FROM tra_TransactionDetails_OS 
					WHERE TransactionMasterId = @inp_iTransactionMasterId AND SecurityTypeCodeId = @nShareSecurityType AND TransactionTypeCodeId IN (@nTransactionType_Pledge,@nTransactionType_PledgeRevoke,@nTransactionType_PledgeInvoke) AND ForUserInfoId = @inp_iForUserInfoId AND TransactionDetailsId != @inp_iTransactionDetailsID
	 
					OPEN TransactionDetail_CursorForPleadge
						
					FETCH NEXT FROM TransactionDetail_CursorForPleadge INTO 
						@nTransactionTypeCodeId, @nModeOfAcquisitionCodeId, @nQuantity		
					SET @nPledgeQuantity = 0
						
					WHILE @@FETCH_STATUS = 0
					BEGIN		
						select @nImptPostshareQtyCodeId_ForPledge = impt_post_share_qty_code_id, @nActionCodeId_ForPledge = action_code_id from tra_TransactionTypeSettings_OS where trans_type_code_id = @nTransactionTypeCodeId and mode_of_acquis_code_id = @nModeOfAcquisitionCodeId and security_type_code_id = @inp_iSecurityTypeCodeId	
								
						IF(@nImptPostshareQtyCodeId_ForPledge = @nNo AND @nActionCodeId_ForPledge = @nBuy)	
						BEGIN					        						
							SET @nPledgeQuantity = @nPledgeQuantity + @nQuantity
						END
						FETCH NEXT FROM TransactionDetail_CursorForPleadge INTO 
							@nTransactionTypeCodeId, @nModeOfAcquisitionCodeId, @nQuantity 		
					END
						
					CLOSE TransactionDetail_CursorForPleadge
					DEALLOCATE TransactionDetail_CursorForPleadge;
						
				    SELECT TOP 1 @out_nPledgeClosingBalance =  PledgeClosingBalance FROM [dbo].[tra_TransactionSummaryDMATWise_OS]  WHERE PeriodCodeId = @nPeriodCodeId  AND UserInfoId = @nUserInfoId_FromRelative AND UserInfoIdRelative = @inp_iForUserInfoId AND SecurityTypeCodeId = @inp_iSecurityTypeCodeId AND DMATDetailsID = @inp_iDMATDetailsID AND CompanyId = @inp_iCompanyId ORDER BY TransactionSummaryDMATWiseId DESC
				    
				    EXEC @nTmpRet = st_tra_GetClosingBalanceOfAnnualPeriod_OS @nUserInfoId_FromRelative, @inp_iForUserInfoId, @inp_iSecurityTypeCodeId, @inp_iDMATDetailsID, @inp_iCompanyId, @out_nClosingBalance OUTPUT, @out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT, @out_sSQLErrMessage OUTPUT
			
				    IF @inp_dQuantity + @nPledgeQuantity + @out_nPledgeClosingBalance > @out_nClosingBalance
				    BEGIN
					  SET @out_nReturnValue = @ERR_NEGATIVEERRORMESSAGE   --@ERR_TRANSACTIONMASTER_SAVE
					  RETURN @out_nReturnValue
				    END
			END
				
			IF(@inp_iTransactionTypeCodeId = @nTransactionType_Pledge OR @inp_iTransactionTypeCodeId = @nTransactionType_PledgeRevoke OR @inp_iTransactionTypeCodeId = @nTransactionType_PledgeInvoke)
			BEGIN
			    DECLARE @UserTypeCodeId INT=0

				SELECT @UserTypeCodeId=UserTypeCodeId FROM usr_userinfo WHERE userinfoid=@inp_iForUserInfoId
				IF(@UserTypeCodeId=101007)
				BEGIN
					SELECT @inp_iForUserInfoId=UserInfoId FROM usr_UserRelation WHERE UserInfoIdRelative=@inp_iForUserInfoId
				END
				 	
			   SELECT @nImptPostShareQtyCodeId = impt_post_share_qty_code_id, @nActionCodeID = action_code_id FROM tra_TransactionTypeSettings_OS WHERE trans_type_code_id = @inp_iTransactionTypeCodeId AND mode_of_acquis_code_id = @inp_iModeOfAcquisitionCodeId AND security_type_code_id = @inp_iSecurityTypeCodeId		
			   IF(@nImptPostShareQtyCodeId = @nNo)						     
			   BEGIN
				   IF(@nActionCodeID = @nSell)
				   BEGIN
						SELECT @nPledgeQuantity = PledgeQuantity FROM tra_BalancePool_OS 
						WHERE UserInfoId = @inp_iForUserInfoId AND SecurityTypeCodeId = @inp_iSecurityTypeCodeId AND DMATDetailsID = @inp_iDMATDetailsID AND CompanyID = @inp_iCompanyId			
						
						IF (@nPledgeQuantity < @inp_dQuantity)
						BEGIN
							SET @out_nReturnValue = @ERR_UPDATEEXCERCISEBALANCEPOOL
							RETURN @out_nReturnValue
						END
				   END
				   ELSE
				   BEGIN IF(@nActionCodeID = @nBuy)
						SELECT @nVirtualQuantity = VirtualQuantity, @nActualQuantity = ActualQuantity FROM tra_BalancePool_OS 
					WHERE UserInfoId = @inp_iForUserInfoId AND SecurityTypeCodeId = @nSecurityType_Share AND DMATDetailsID = @inp_iDMATDetailsID AND CompanyID = @inp_iCompanyId
					IF ( @nActualQuantity < @inp_dQuantity)
						BEGIN
							SET @out_nReturnValue = @ERR_UPDATEEXCERCISEBALANCEPOOL
							RETURN @out_nReturnValue
						END
				   END
			   END
			   ELSE IF(@nImptPostShareQtyCodeId = @nLess)	
			   BEGIN 
			      IF(@inp_iSecurityTypeCodeId = @nSecurityType_Share)
			      BEGIN			
					SELECT @nVirtualQuantity = VirtualQuantity, @nActualQuantity = ActualQuantity FROM tra_BalancePool_OS 
					WHERE UserInfoId = @inp_iForUserInfoId AND SecurityTypeCodeId = @nSecurityType_Share AND DMATDetailsID = @inp_iDMATDetailsID AND CompanyID = @inp_iCompanyId
					IF ( (@nActualQuantity) < @inp_dQuantity)
						BEGIN
							SET @out_nReturnValue = @ERR_UPDATEEXCERCISEBALANCEPOOL
							RETURN @out_nReturnValue
						END
				END
				  ELSE
					BEGIN
						-- For all secuirty type execept Shares
						SELECT @nVirtualQuantity = VirtualQuantity, @nActualQuantity = ActualQuantity FROM tra_BalancePool_OS 
						WHERE UserInfoId = @inp_iForUserInfoId AND SecurityTypeCodeId = @inp_iSecurityTypeCodeId AND DMATDetailsID = @inp_iDMATDetailsID  AND CompanyID = @inp_iCompanyId	 						
						-- validate requested quantity and quantity in pool 
						-- check quantity in pool and quantity requested for sell 
						IF (@nActualQuantity < @inp_dQuantity)
						BEGIN
							SET @out_nReturnValue = @ERR_UPDATEEXCERCISEBALANCEPOOL
							RETURN @out_nReturnValue
						END
					
					END				      
				  END	
			END	
            ------------------------------------------pledge---------------------------------------------------

		END

		RETURN 0
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue	=  @ERR_TRANSACTIONDETAILS_VALIDATION
	END CATCH
END
