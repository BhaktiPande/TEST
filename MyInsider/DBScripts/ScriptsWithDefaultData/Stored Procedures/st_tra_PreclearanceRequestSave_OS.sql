IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_tra_PreclearanceRequestSave_OS')
DROP PROCEDURE [dbo].[st_tra_PreclearanceRequestSave_OS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Saves the PreclearanceRequest details for non implementing company

Returns:		0, if Success.
				
Created by:		Parag
Created on:		22-Sept-2016

Modification History:
Modified By		Modified On		Description

Usage:

-------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[st_tra_PreclearanceRequestSave_OS] 
	@inp_tblPreClearanceList	        PreClearanceListType READONLY,
	@inp_nPreclearanceRequestId         INT = NULL,
	@inp_nPreclearanceNotTakenFlag	    BIT,
	@inp_iReasonForNotTradingCodeId		INT,
	@inp_sReasonForNotTradingText		VARCHAR(30),
	@inp_nUserId						INT,
	@inp_iPreclearanceStatusCodeId      INT,
	@inp_sReasonForRejection			VARCHAR(200),
	@inp_sReasonForApproval				VARCHAR(200),
	@inp_iReasonForApprovalCodeId		INT,
	@inp_iDisplaySequenceNo             INT,
	@out_nReturnValue					INT = 0 OUTPUT,
	@out_nSQLErrCode					INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage					NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
AS
BEGIN
	DECLARE @nSecurityType_Share INT = 139001
	DECLARE @nTotalCount INT
	DECLARE @nCounter INT = 0
	DECLARE @nPreclearanceRequestId INT
	DECLARE @nRlSearchAuditId INT
	DECLARE @nRlSearchAuditIdOS INT
	DECLARE @nPreclearanceRequestForCodeId INT	
	DECLARE @nUserInfoId INT
	DECLARE @nUserInfoIdRelative INT
	DECLARE @nTransactionTypeCodeId INT
	DECLARE @nSecurityTypeCodeId INT
	DECLARE @nSecuritiesToBeTradedQty decimal(15, 4)
	DECLARE @nSecuritiesToBeTradedValue	decimal(20, 4)
	DECLARE @nModeOfAcquisitionCodeId INT 
	DECLARE @nDMATDetailsID INT
	DECLARE @nPreclearanceStatusCodeId INT
	DECLARE @nCompanyId INT
	DECLARE @nApprovedBy INT
	DECLARE @nOtherQuantity_FromPool DECIMAL(15,4) = NULL
	DECLARE @nReasonForNotTradingCodeId INT = NULL
	DECLARE @nReasonForNotTradingText VARCHAR(500) = NULL
	DECLARE @bIsAutoApprove BIT
	DECLARE @nPreclearanceStatusCode INT

	DECLARE @ERR_PRECLEARANCEREQUEST_SAVE_ERROR	INT = 17512 -- Error occured while saving preclearance for non implementing company
	
	DECLARE @DisplaySequenceNo INT = 0
	DECLARE @PledgeOptionQty DECIMAL(15, 4) = 0
	DECLARE @nOtherExcerciseOptionQty DECIMAL(15,4) = 0
	DECLARE @nPledgeOptionQty DECIMAL(15,4) = 0

	DECLARE @nTransactionType_Buy INT = 143001
	DECLARE @nTransactionType_Sell INT = 143002
	DECLARE @TranscationType_Pledge INT = 143006
	DECLARE @TranscationType_PledgeInvoke INT = 143008
	DECLARE @TranscationType_PledgeRevoke INT = 143007
	DECLARE @imptpostshareqtycodeid INT
	DECLARE @nContinousDisclosureType INT	= 147002
	--Pledge impact on Post quantity
	DECLARE @PledgeImpactOnPostQuantity_Add INT = 505001
    DECLARE @PledgeImpactOnPostQuantity_Less INT = 505002    
    DECLARE @PledgeImpactOnPostQuantity_No INT = 505004 

	DECLARE @ConfigurationType_RestrictedListSetting INT = 180003
	DECLARE @ConfigurationCode_PreclearanceApproval INT = 185002
	DECLARE @ConfigurationCode_PreclearanceAllowZero INT = 185003
	DECLARE @ApprovalType INT = 0
	DECLARE @PreclearanceApproval_AutoApprove INT = 187001
	DECLARE @PreclearanceApproval_Mannual INT = 187002
	DECLARE @PreclearanceStatus_Approve INT = 144002
    DECLARE @MapToTypeCodeId_PreClearance_NonImplementationCompany INT = 132015
    DECLARE @nDisclosureStatusNotConfirmed INT = 148002
    DECLARE @nTradingPolicyID INT
	DECLARE @nMapToTypePreclearance INT = 132004
	DECLARE @nTransactionMasterID BIGINT
	DECLARE @nMaxDisplayRollingNumber BIGINT = 0
	DECLARE @RC INT
	DECLARE @nDiscStatusDocUploaded	INT	= 148001
	DECLARE @nIsPartiallyTradedFlag	INT
	DECLARE @nShowAddButtonFlag	INT

	DECLARE @nPreClearanceStatus_Approve INT = 144002
	DECLARE @nPreClearanceStatus_Reject INT = 144003

	DECLARE @nPreclearanceApprovedBy INT
    DECLARE @dtPreclearanceApprovedOn DATETIME
	
	DECLARE @ERR_DETAILSFOUND INT= 53006

	--Temp Tables
	CREATE TABLE #tempPreClearanceList(ID INT IDENTITY(1,1) ,[PreclearanceRequestId][INT] NULL,[RlSearchAuditId][INT] NOT NULL,[PreclearanceRequestForCodeId]	[INT] NOT NULL,	[UserInfoId][INT] NOT NULL,[UserInfoIdRelative]	[INT] NULL,
	[TransactionTypeCodeId]	[INT] NOT NULL,[SecurityTypeCodeId]	[INT] NOT NULL,[SecuritiesToBeTradedQty]	[decimal](15, 4) NOT NULL,[SecuritiesToBeTradedValue]	[decimal](20, 4) NOT NULL,
	[ModeOfAcquisitionCodeId]	[INT] NOT NULL,[DMATDetailsID]	[INT] NOT NULL,[PreclearanceStatusCodeId]	[INT] NOT NULL,[CompanyId]	[INT] NOT NULL,[ApprovedBy] [INT] NOT NULL)

	BEGIN TRY
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''
		
		IF @inp_nPreclearanceNotTakenFlag = 0
		BEGIN
			IF @inp_nPreclearanceRequestId IS NULL OR @inp_nPreclearanceRequestId = 0
			BEGIN
				INSERT INTO #tempPreClearanceList
				SELECT * FROM @inp_tblPreClearanceList

				-- get next display sequence number
				SELECT @DisplaySequenceNo= MAX(DisplaySequenceNo) FROM tra_PreclearanceRequest_NonImplementationCompany
				
					SET @DisplaySequenceNo = ISNULL(@DisplaySequenceNo,0) + 1
					
				SET @nTotalCount = (SELECT count(ID) FROM #tempPreClearanceList)
				WHILE(@nCounter < @nTotalCount)
				BEGIN
					SET @nCounter = @nCounter + 1
			
					SELECT @nPreclearanceRequestId = PreclearanceRequestId,
					@nRlSearchAuditId = RlSearchAuditId,
					@nUserInfoId = UserInfoId,
					@nUserInfoIdRelative = UserInfoIdRelative,
					@nTransactionTypeCodeId = TransactionTypeCodeId,
					@nSecurityTypeCodeId = SecurityTypeCodeId,
					@nSecuritiesToBeTradedQty = SecuritiesToBeTradedQty,
					@nSecuritiesToBeTradedValue = SecuritiesToBeTradedValue,
					@nModeOfAcquisitionCodeId = ModeOfAcquisitionCodeId,
					@nDMATDetailsID = DMATDetailsID,
					@nPreclearanceStatusCodeId = PreclearanceStatusCodeId,
					@nPreclearanceRequestForCodeId = PreclearanceRequestForCodeId,
					@nCompanyId = CompanyId,
					@nApprovedBy = ApprovedBy
					FROM #tempPreClearanceList WHERE ID = @nCounter
					-- check exercise pool option and set quantity for preclearance 
					IF (@nSecurityTypeCodeId  = @nSecurityType_Share)
					BEGIN
						SELECT @nOtherQuantity_FromPool = VirtualQuantity FROM tra_BalancePool_OS 
						WHERE UserInfoId = @nUserInfoId AND SecurityTypeCodeId = @nSecurityType_Share AND DMATDetailsID = @nDMATDetailsID AND CompanyID = @nCompanyId

						IF (@nOtherQuantity_FromPool IS NULL)
						BEGIN
							-- set quantity because there is nothing in pool
							SET @nOtherQuantity_FromPool = 0
						END

						IF (@nTransactionTypeCodeId = @nTransactionType_Buy)
						BEGIN
							SET @nOtherExcerciseOptionQty = @nSecuritiesToBeTradedQty
						END
						ELSE IF (@nTransactionTypeCodeId = @nTransactionType_Sell)
						BEGIN
							SET @nOtherExcerciseOptionQty = @nSecuritiesToBeTradedQty
						END
						ELSE IF (@nTransactionTypeCodeId = @TranscationType_Pledge OR @nTransactionTypeCodeId = @TranscationType_PledgeRevoke OR @nTransactionTypeCodeId = @TranscationType_PledgeInvoke)
						BEGIN
							SELECT @imptpostshareqtycodeid = impt_post_share_qty_code_id FROM tra_TransactionTypeSettings WHERE trans_type_code_id = @nTransactionTypeCodeId 
							AND mode_of_acquis_code_id = @nModeOfAcquisitionCodeId AND security_type_code_id = @nSecurityTypeCodeId
						    					   
							IF(@imptpostshareqtycodeid = @PledgeImpactOnPostQuantity_No)						     
							BEGIN
								SET @nPledgeOptionQty = @nSecuritiesToBeTradedQty
							END
							ELSE IF(@imptpostshareqtycodeid = @PledgeImpactOnPostQuantity_Add)
							BEGIN 
								SET @nOtherExcerciseOptionQty = @nSecuritiesToBeTradedQty
							END
							ELSE IF(@imptpostshareqtycodeid = @PledgeImpactOnPostQuantity_Less)	
							BEGIN
								SET @nOtherExcerciseOptionQty = @nSecuritiesToBeTradedQty
							END					   							
						END
					END
					ELSE
					BEGIN
					IF (@nTransactionTypeCodeId = @TranscationType_Pledge OR @nTransactionTypeCodeId = @TranscationType_PledgeRevoke OR @nTransactionTypeCodeId = @TranscationType_PledgeInvoke)
					BEGIN							
						SELECT @imptpostshareqtycodeid = impt_post_share_qty_code_id FROM tra_TransactionTypeSettings WHERE trans_type_code_id = @nTransactionTypeCodeId 
						AND mode_of_acquis_code_id = @nModeOfAcquisitionCodeId AND security_type_code_id = @nSecurityTypeCodeId
												   
						IF(@imptpostshareqtycodeid = @PledgeImpactOnPostQuantity_No)						     
						BEGIN
							SET @nPledgeOptionQty = @nSecuritiesToBeTradedQty
						END
						ELSE
						BEGIN
							SET @nOtherExcerciseOptionQty = @nSecuritiesToBeTradedQty
						END
					END
					ELSE
					BEGIN						
						SET @nOtherExcerciseOptionQty = @nSecuritiesToBeTradedQty
					END			
				END

	--IF(@nTransactionTypeCodeId=143002)
	--BEGIN
	--	DECLARE @nCheckSecurityType INT=0
	--	SELECT @nCheckSecurityType=SecurityTypeCodeID FROM dbo.rul_TradingPolicyForProhibitSecurityTypes_OS WHERE TradingPolicyId=@nTradingPolicyID and SecurityTypeCodeID=@nSecurityTypeCodeId
	--	IF(@nCheckSecurityType<>0)	
	--	BEGIN
	--	/*---------- 25% AND 50000 LOGIC---------*/
	--		DECLARE @nPeriodType INT	
	--		DECLARE @nYearCodeId INT
	--		DECLARE @nPeriodCodeId INT
	--		DECLARE @dtStartDate DATETIME
	--		DECLARE @dtEndDate DATETIME
	--		DECLARE @nHoldingUsrCount BIGINT=0
	--		DECLARE @nHoldingTotcount INT=0
	--		DECLARE @nPeriodCode INT=124001			    
	--		DECLARE @nPreQuantity INT=0
	--		DECLARE @nTradedQty INT=0
	--		DECLARE @nTotQty decimal(10,2)=0
	--		DECLARE @nProhibitPreClrOnPerQty decimal(10,2)=0		
	--		DECLARE @nProhibitPreClrOnQuantity INT=0
				
	--		DECLARE @nTotSecurityCnt INT=0
	--		DECLARE @nSecurityCnt INT=0
	--		DECLARE @nCount       INT=0
	--		DECLARE @TotalRows    INT=0
	--		DECLARE @nHoldingSecurityCount INT=0
	--		DECLARE @nHoldingSecurityUsrCount INT=0
	--		DECLARE @out_sPeriodEnddate NVARCHAR(500)

	--		SELECT 
	--			@nPeriodType = CASE 
	--			WHEN TP.ProhibitPreClrForPeriod = 137001 THEN 123001 -- Yearly
	--			WHEN TP.ProhibitPreClrForPeriod = 137002 THEN 123003 -- Quarterly
	--			WHEN TP.ProhibitPreClrForPeriod = 137003 THEN 123004 -- Monthly
	--			WHEN TP.ProhibitPreClrForPeriod = 137004 THEN 123002 -- half yearly
	--			ELSE TP.DiscloPeriodEndFreq 
	--			END					  				
	--		FROM 
	--			rul_TradingPolicy_OS TP 
	--		WHERE TP.TradingPolicyId = @nTradingPolicyID
	
	--		DECLARE @dtPreclearanceDate DATETIME
	--		SELECT @dtPreclearanceDate=dbo.uf_com_GetServerDate()

	--		EXECUTE st_tra_PeriodEndDisclosureStartEndDate2
	--		@nYearCodeId OUTPUT, @nPeriodCodeId OUTPUT,@dtPreclearanceDate,@nPeriodType, 0, 
	--		@dtStartDate OUTPUT, @dtEndDate OUTPUT, 
	--		@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT, @out_sSQLErrMessage OUTPUT
	--		SET @out_sPeriodEnddate = dbo.uf_rpt_FormatDateValue(@dtEndDate,0) 
			
	--		CREATE TABLE #tmpProhibitSecurityTypes (ID INT IDENTITY(1,1),SecurityType INT)
	--		INSERT INTO #tmpProhibitSecurityTypes
	--		SELECT SecurityTypeCodeID FROM dbo.rul_TradingPolicyForProhibitSecurityTypes_OS WHERE TradingPolicyId=@nTradingPolicyID
	--		SELECT @nTotSecurityCnt=COUNT(ID) FROM #tmpProhibitSecurityTypes
	--		WHILE @nSecurityCnt<@nTotSecurityCnt
	--		BEGIN
				
	--			CREATE TABLE #tmpYearCodeId(ID INT IDENTITY NOT NULL,YearCodeId BIGINT NOT NULL,UserInfoIdRelative BIGINT NOT NULL,UserInfoId BIGINT NOT NULL)

	--			INSERT INTO #tmpYearCodeId(YearCodeId,UserInfoIdRelative,UserInfoId)

	--			SELECT MAX(YearCodeId) AS YearCodeId ,UserInfoIdRelative,UserInfoId FROM tra_TransactionSummaryDMATWise_OS 
	--			WHERE UserInfoId=@nUserInfoId and PeriodCodeId=@nPeriodCode and SecurityTypeCodeId=(SELECT SecurityType FROM #tmpProhibitSecurityTypes WHERE ID=@nSecurityCnt+1) AND CompanyId = @nCompanyId
	--			GROUP BY UserInfoIdRelative,UserInfoId
				
	--			SELECT @TotalRows=COUNT(YearCodeId) FROM #tmpYearCodeId
	--			WHILE @nCount<@TotalRows
	--			BEGIN
	--					SELECT 
	--						@nHoldingSecurityUsrCount = ISNULL(TS.ClosingBalance, 0)
	--					FROM 
	--						tra_TransactionSummary TS
	--					WHERE 
	--						TS.PeriodCodeId=@nPeriodCode AND TS.UserInfoIdRelative=(SELECT UserInfoIdRelative FROM #tmpYearCodeId WHERE ID=@nCount+1) AND TS.SecurityTypeCodeId=(SELECT SecurityType FROM #tmpProhibitSecurityTypes WHERE ID=@nSecurityCnt+1) AND TS.YearCodeId=(SELECT YearCodeId FROM #tmpYearCodeId WHERE ID=@nCount+1)

				
	--			SET @nHoldingSecurityCount=@nHoldingSecurityUsrCount +@nHoldingSecurityCount
				
	--			SET @nCount=@nCount+1
	--			END
	--			SET @nCount=0
	--			SET @TotalRows=0
	--			DROP TABLE #tmpYearCodeId
				
	--			SET @nHoldingTotcount=@nHoldingTotcount+@nHoldingSecurityCount	
	--			SET @nHoldingSecurityCount=0	
	--			SET @nSecurityCnt=@nSecurityCnt+1
	--		END		
	--		DROP TABLE #tmpProhibitSecurityTypes	
		
	--		SELECT 
	--			@nTradedQty=isnull(SUM(Quantity),0)
	--		FROM 
	--			tra_TransactionDetails TD JOIN tra_TransactionMaster TM
	--			ON TD.TransactionMasterId=TM.TransactionMasterId
	--		WHERE 
	--			ForUserInfoId=@nUserInfoId AND DisclosureTypeCodeId=@nContinousDisclosureType
	--			AND DateOfAcquisition>= @dtStartDate AND  DateOfAcquisition<=@dtEndDate
		
	--		SET @nTotQty = @nPreQuantity + @nTradedQty + @inp_dSecuritiesToBeTradedQty		
		
			
	--		DECLARE @nBasedOnPerFlag INT=0
	--		DECLARE @nBasedOnQtyFlag INT=0
			
	--		SELECT @nBasedOnPerFlag=ProhibitPreClrPercentageAppFlag,@nBasedOnQtyFlag=ProhibitPreClrOnQuantityAppFlag FROM rul_TradingPolicy WHERE  TradingPolicyId=@nTradingPolicyID
			
	--		IF(@nBasedOnPerFlag=1)
	--		BEGIN
	--			SELECT @nProhibitPreClrOnPerQty=((@nHoldingTotcount*ProhibitPreClrOnPercentage)/100),@out_sProhibitOnPer=ProhibitPreClrOnPercentage FROM rul_TradingPolicy WHERE  TradingPolicyId=@nTradingPolicyID
	--		END
			
	--		IF(@nBasedOnQtyFlag=1)
	--		BEGIN
	--			SELECT @nProhibitPreClrOnQuantity=ProhibitPreClrOnQuantity FROM rul_TradingPolicy WHERE  TradingPolicyId=@nTradingPolicyID
	--			SET @out_sProhibitOnQuantity=@nProhibitPreClrOnQuantity
	--		end
			
	--		IF(@nBasedOnPerFlag=1 OR @nBasedOnQtyFlag=1)
	--		BEGIN
	--			IF(@nProhibitPreClrOnQuantity>@nProhibitPreClrOnPerQty)
	--			BEGIN			
	--				IF(@nProhibitPreClrOnQuantity<@nTotQty)
	--				BEGIN					
	--					SET @out_nReturnValue =  @ERR_PREQTYEXCEEDTHANQTY
	--					RETURN (@out_nReturnValue)			   
	--				END
	--			END
	--			ELSE
	--			BEGIN			
	--				IF(@nProhibitPreClrOnPerQty<@nTotQty)
	--				BEGIN			
	--					SET @out_nReturnValue =  @ERR_PREQTYEXCEEDTHANPER
	--					RETURN (@out_nReturnValue)					
	--				END
	--			END
	--		END			
	--	END	
	--END
					-- check if pre-clearance is auto approve or not, if auto approve then change status to approve
					SELECT @ApprovalType = ISNULL(ConfigurationValueCodeId,0) FROM com_CompanySettingConfiguration 
					WHERE ConfigurationTypeCodeId = @ConfigurationType_RestrictedListSetting AND ConfigurationCodeId = @ConfigurationCode_PreclearanceApproval
					SET @nPreclearanceStatusCode = CASE WHEN @ApprovalType = @PreclearanceApproval_AutoApprove THEN @PreclearanceStatus_Approve ELSE @nPreclearanceStatusCodeId END
					SET @bIsAutoApprove = CASE WHEN @ApprovalType = @PreclearanceApproval_AutoApprove THEN 1 ELSE 0 END
					DECLARE @nIsPartiallyTraded INT = 1

					INSERT INTO tra_PreclearanceRequest_NonImplementationCompany(RlSearchAuditId,DisplaySequenceNo,PreclearanceRequestForCodeId,UserInfoId,UserInfoIdRelative,TransactionTypeCodeId,
					SecurityTypeCodeId,SecuritiesToBeTradedQty,PreclearanceStatusCodeId,CompanyId,
					DMATDetailsID,ReasonForNotTradingCodeId,ReasonForNotTradingText,SecuritiesToBeTradedValue, IsAutoApproved,
					CreatedBy,CreatedOn,ModifiedBy,ModifiedOn,OtherExcerciseOptionQty, PledgeOptionQty, ModeOfAcquisitionCodeId,ApprovedBy,ApprovedOn,IsPartiallyTraded)
					VALUES (
					@nRlSearchAuditId,@DisplaySequenceNo,@nPreclearanceRequestForCodeId,@nUserInfoId,@nUserInfoIdRelative,@nTransactionTypeCodeId,
					@nSecurityTypeCodeId,@nSecuritiesToBeTradedQty,@nPreclearanceStatusCode,@nCompanyId,@nDMATDetailsID,@nReasonForNotTradingCodeId,@nReasonForNotTradingText,@nSecuritiesToBeTradedValue, @bIsAutoApprove,
					@nUserInfoId, dbo.uf_com_GetServerDate(), @nUserInfoId, dbo.uf_com_GetServerDate(), @nOtherExcerciseOptionQty, @nPledgeOptionQty,
					@nModeOfAcquisitionCodeId,@nApprovedBy,dbo.uf_com_GetServerDate(),@nIsPartiallyTraded)
					
					SET @nPreclearanceRequestId = SCOPE_IDENTITY()
					--Generate FORM E on auto approval
					IF @ApprovalType = @PreclearanceApproval_AutoApprove OR @bIsAutoApprove = 1
					BEGIN
					EXEC @out_nReturnValue = st_tra_GenerateFormDetails 
															@MapToTypeCodeId_PreClearance_NonImplementationCompany,
															@DisplaySequenceNo,
															@nUserInfoId,
															@out_nReturnValue = @out_nReturnValue OUTPUT,
															@out_nSQLErrCode = @out_nSQLErrCode OUTPUT,
															@out_sSQLErrMessage = @out_sSQLErrMessage OUTPUT
					END
					SELECT 1 -- this select statement is for PetaPoco

					SELECT  @nTradingPolicyID = ISNULL(MAX(MapToId), 0) FROM vw_ApplicableTradingPolicyForUser_OS  where UserInfoId = @nUserInfoId
					
					EXEC @out_nReturnValue = st_tra_TradingTransactionMasterCreate_OS 0,@nPreclearanceRequestId,@nUserInfoId,@nContinousDisclosureType,
			    															@nDisclosureStatusNotConfirmed,0,@nTradingPolicyID,NULL,NULL,NULL,NULL,@nUserInfoId,
			    															0,NULL,0,@out_nReturnValue = @out_nReturnValue OUTPUT,@out_nSQLErrCode = @out_nSQLErrCode OUTPUT,
																			@out_sSQLErrMessage = @out_sSQLErrMessage OUTPUT

					
					IF(@out_nReturnValue > 0)
					BEGIN
						RETURN @out_nReturnValue
					END
					
					SELECT @nTransactionMasterID = TransactionMasterId 
								FROM tra_TransactionMaster_OS WHERE PreclearanceRequestId = @nPreclearanceRequestId
					
								-- Calculate Max Display Rolling Number 
									SELECT @nMaxDisplayRollingNumber = MAX(ISNULL(DisplayRollingNumber,0)) FROM tra_TransactionMaster_OS WHERE DisclosureTypeCodeId = @nContinousDisclosureType
									SET @nMaxDisplayRollingNumber = @nMaxDisplayRollingNumber + 1
						
									UPDATE tra_TransactionMaster_OS
									SET DisplayRollingNumber = @nMaxDisplayRollingNumber
									WHERE TransactionMasterId = @nTransactionMasterID
					
								--select @inp_nPreclearanceRequestId as 'PCL ID'
								-- update exercise pool 
								EXECUTE @RC = [st_tra_ExerciseBalancePoolUpdateDetails_OS] 
										@nMapToTypePreclearance,
										@nPreclearanceRequestId,
										NULL,
										@out_nReturnValue OUTPUT,
										@out_nSQLErrCode OUTPUT,
										@out_sSQLErrMessage OUTPUT
							
								IF @out_nReturnValue <> 0
								BEGIN								
									RETURN @out_nReturnValue
								END
						
								--CLEAR VARIABLES
								SET @nOtherQuantity_FromPool= 0
								SET @nOtherExcerciseOptionQty = 0
								SET @nPledgeOptionQty = 0
				END 
			END
			ELSE
			BEGIN
				--Fetech security Type code id
				SELECT @nSecurityTypeCodeId  = SecurityTypeCodeId FROM tra_PreclearanceRequest_NonImplementationCompany 
				WHERE PreclearanceRequestId = @inp_nPreclearanceRequestId
							
				IF @inp_iReasonForNotTradingCodeId IS NOT NULL OR @inp_iReasonForNotTradingCodeId <> 0
				BEGIN
					-- Check if transaction details are entered and transaction is not submitted
					IF EXISTS (SELECT TransactionDetailsId
									FROM tra_TransactionMaster_OS TM JOIN tra_TransactionDetails_OS TD ON TM.TransactionMasterId = TD.TransactionMasterId
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
									FROM tra_TransactionMaster_OS TM JOIN tra_TransactionDetails_OS TD ON TM.TransactionMasterId = TD.TransactionMasterId
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
						FROM tra_PreclearanceRequest_NonImplementationCompany PR JOIN tra_TransactionMaster_OS TM ON TM.PreclearanceRequestId = PR.PreclearanceRequestId
						WHERE TransactionStatusCodeId = @nDisclosureStatusNotConfirmed AND TM.PreclearanceRequestId = @inp_nPreclearanceRequestId
						
						IF @listStr IS NOT NULL AND @listStr <> ''
						BEGIN
						--select @listStr as 'ass'
						declare @sql VARCHAR(MAX)
						set @sql = 'delete from tra_TransactionMaster_OS where TransactionMasterId in(' + CONVERT(VARCHAR(max),@listStr) + ')'
						exec(@sql)
							---DELETE FROM tra_TransactionMaster
							--WHERE TransactionMasterId = @nTransactionIdToBeRemoved
						END
					END
					UPDATE tra_PreclearanceRequest_NonImplementationCompany
					SET ReasonForNotTradingCodeId = @inp_iReasonForNotTradingCodeId,
						ReasonForNotTradingText = @inp_sReasonForNotTradingText,
						IsPartiallyTraded = @nIsPartiallyTradedFlag,
						ShowAddButton = @nShowAddButtonFlag,
						ModifiedBy = @inp_nUserId,
						ModifiedOn = dbo.uf_com_GetServerDate()
					WHERE PreclearanceRequestId = @inp_nPreclearanceRequestId
					
					-- Update IsPartiallyTradedFlag and ShowAddButton flags
					
					-- update exercise pool -- for case of partial trade or no traded
					EXECUTE @RC = [st_tra_ExerciseBalancePoolUpdateDetails_OS]
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
						UPDATE tra_PreclearanceRequest_NonImplementationCompany
						SET PreclearanceStatusCodeId = @inp_iPreclearanceStatusCodeId,
						ReasonForRejection = @inp_sReasonForRejection,
						ReasonForApproval  = @inp_sReasonForApproval,
						ReasonForApprovalCodeId = @inp_iReasonForApprovalCodeId,
						ApprovedBy = @nPreclearanceApprovedBy,
						ApprovedOn = @dtPreclearanceApprovedOn,
						ModifiedBy = @inp_nUserId,
						ModifiedOn = dbo.uf_com_GetServerDate()
						WHERE PreclearanceRequestId = @inp_nPreclearanceRequestId
						
						DECLARE @nDisplaySeqNo INT 
						DECLARE @IsApproved INT 
						SELECT @nDisplaySeqNo = DisplaySequenceNo FROM tra_PreclearanceRequest_NonImplementationCompany WHERE PreclearanceRequestId= @inp_nPreclearanceRequestId
						SELECT TOP 1 @IsApproved = PreclearanceRequestId FROM tra_PreclearanceRequest_NonImplementationCompany WHERE DisplaySequenceNo = @nDisplaySeqNo AND PreclearanceStatusCodeId = @nPreClearanceStatus_Approve
						--Generate FORM E
						IF (@inp_iPreclearanceStatusCodeId = @nPreClearanceStatus_Approve OR @IsApproved>1)
						BEGIN
							EXEC @out_nReturnValue = st_tra_GenerateFormDetails @MapToTypeCodeId_PreClearance_NonImplementationCompany,@inp_iDisplaySequenceNo,@inp_nUserId,@out_nReturnValue = @out_nReturnValue OUTPUT,@out_nSQLErrCode = @out_nSQLErrCode OUTPUT,
																	@out_sSQLErrMessage = @out_sSQLErrMessage OUTPUT
						END
						
						IF(@out_nReturnValue > 0)
						BEGIN
							RETURN @out_nReturnValue
						END
					
					-- update exercise pool -- for case of reject 
					IF (@inp_iPreclearanceStatusCodeId = @nPreClearanceStatus_Reject)
					BEGIN
						EXECUTE @RC = [st_tra_ExerciseBalancePoolUpdateDetails_OS] 
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

		SELECT 1
		
	END TRY

	BEGIN CATCH	
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()	
		SET @out_nReturnValue =  dbo.uf_com_GetErrorCode(@ERR_PRECLEARANCEREQUEST_SAVE_ERROR, ERROR_NUMBER())
		
		RETURN @out_nReturnValue
	END CATCH
END