IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_tra_TradingTransactionMasterCreate_Override_OS')
DROP PROCEDURE [dbo].[st_tra_TradingTransactionMasterCreate_Override_OS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_tra_TradingTransactionMasterCreate_Override_OS]
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
	@inp_nUserId											INT,
	@inp_sCalledFrom										VARCHAR(20) = '',--This is to conditionally execute the last SELECT statement ,as the select is not required in MASSUPLOAD CALL
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
			SELECT @inp_dtPeriodEndDate = PeriodEndDate FROM tra_TransactionMaster_OS WHERE TransactionMasterId = @inp_sTransactionMasterId
		END		  

		/*Find the user type for checking when to set the date of intimation to company against the transaction*/
		SELECT @nLoginUSERTYPE = UserTypeCodeId FROM usr_UserInfo WHERE UserInfoId = @inp_nUserId
						
		EXEC @nTmpRet = st_tra_TransactionMasterValidation_OS @inp_sTransactionMasterId, @inp_iUserInfoId, @inp_iDisclosureTypeCodeId,
			@inp_dtPeriodEndDate, @out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT, @out_sSQLErrMessage OUTPUT
		
		IF @out_nReturnValue <> 0
		BEGIN
			SET @out_nReturnValue = @out_nReturnValue
			RETURN @out_nReturnValue
		END
		
		EXEC @nTmpRet = st_tra_UpdateOtherQuantity_OS @inp_sTransactionMasterId,@inp_sPreclearanceRequestId,@inp_iDisclosureTypeCodeId,
			@inp_iTransactionStatusCodeId,@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT, @out_sSQLErrMessage OUTPUT
		
		IF @out_nReturnValue <> 0
		BEGIN
			SET @out_nReturnValue = @out_nReturnValue--@ERR_TRANSACTIONMASTER_SAVE
			RETURN @out_nReturnValue
		END
		
		--Save the TransactionMaster details
		IF @inp_sTransactionMasterId = 0
		BEGIN		
			
			DECLARE @nCheckForInitDisc INT=0								
			SELECT @nCheckForInitDisc = count(TransactionMasterId) FROM tra_TransactionMaster_OS WHERE UserInfoId=@inp_iUserInfoId AND DisclosureTypeCodeId=147001 and TransactionStatusCodeId in(148003,148004,148005,148006)
			
			IF(@nCheckForInitDisc>0)
			BEGIN
			SET @inp_InsiderIDFlag=1
			END	
			ELSE
			BEGIN
			SET @inp_InsiderIDFlag=0
			END	
			
			IF (@inp_iDisclosureTypeCodeId = @CONST_CONTINUOUS_DISCLOSURE_TYPE_CODEID OR NOT EXISTS(SELECT TransactionMasterId FROM tra_TransactionMaster_OS 
							WHERE DisclosureTypeCodeId = @inp_iDisclosureTypeCodeId  
							and UserInfoId = @inp_iUserInfoId and InsiderIDFlag =@inp_InsiderIDFlag	 and (@inp_dtPeriodEndDate IS NULL or PeriodEndDate = @inp_dtPeriodEndDate)))			
			BEGIN
			
				-- If Preclearance Id is non zero, and transaction masterid = 0, 
				-- and it is the not first transaction, then get trading policy id from the parent transaction, aslo set parent transation id
				IF @inp_sTransactionMasterId = 0 AND ISNULL(@inp_sPreclearanceRequestId, 0) <> 0
					AND EXISTS(SELECT * FROM tra_TransactionMaster_OS WHERE PreclearanceRequestId = @inp_sPreclearanceRequestId)
				BEGIN
					
					SELECT @TradingPolicyId = TradingPolicyId,
						@nParentTransactionMasterId = TransactionMasterId,
						@nDisplayRollingNumber = DisplayRollingNumber
					FROM tra_TransactionMaster_OS
					WHERE PreclearanceRequestId = @inp_sPreclearanceRequestId
						AND ParentTransactionMasterId IS NULL 
						
					-- Set "ShowAddButton" flag to 0 in Preclearance table
					--UPDATE tra_PreclearanceRequest
					--SET ShowAddButton = 0
					--WHERE PreclearanceRequestId = @inp_sPreclearanceRequestId
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
									
					SELECT @TradingPolicyId = ISNULL(MAX(MapToId), 0) FROM vw_ApplicableTradingPolicyForUser_OS  where UserInfoId = @UsrInfoId1
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
					SELECT @inp_dtPeriodEndDate = PeriodEndDate FROM tra_TransactionMaster_OS WHERE TransactionMasterId = @nParentTransactionMasterId
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
					EXECUTE @RC = [st_tra_PeriodEndDisclosureGetApplicablePeriodDetail_OS]
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
					IF((@nActinFlag = 1 OR @nActinFlag = 3) AND @inp_CDDuringPE<>1 AND ((@nCheckForInitDisc=0 AND @inp_iDisclosureTypeCodeId=147001) OR (@nCheckForInitDisc=1 AND @inp_iDisclosureTypeCodeId=147002))) 
					BEGIN	
						INSERT INTO tra_UserPeriodEndMapping_OS 
							(UserInfoId, TradingPolicyId, YearCodeId, PeriodCodeId, PEStartDate, PEEndDate, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
						VALUES
							(@inp_iUserInfoId, @nApplicableTP, @nYearCodeId, @nPeriodCodeId, @dtPEStartDate, @dtPEEndDate, @inp_iUserInfoId, dbo.uf_com_GetServerDate(), @inp_iUserInfoId, dbo.uf_com_GetServerDate())
											
						SET @inp_dtPeriodEndDate = @dtPEEndDate -- override input date with applicable PE date						
						-- check flag to know if need to update period end date with new date in transaction master table 
						-- this is mainly because period type change from lower to higher 
						IF (@bChangePEDate = 1)
						BEGIN
						
							UPDATE tra_TransactionMaster_OS SET PeriodEndDate = @dtPEEndDate 
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
						
							UPDATE tra_TransactionMaster_OS SET PeriodEndDate = @dtPEEndDate 
						   	WHERE UserInfoId = @inp_iUserInfoId AND PeriodEndDate = @dtPEEndDateToUpdate
						END
					END
				END

				IF(@inp_iDisclosureTypeCodeId = @CONST_CONTINUOUS_DISCLOSURE_TYPE_CODEID)
				BEGIN
					DECLARE @nUserID INT =0
					SELECT @nUserID=UserInfoId FROM usr_UserRelation WHERE UserInfoIdRelative=@inp_iUserInfoId
					IF @nUserID!=0
					BEGIN
						SET @inp_iUserInfoId = @nUserID
					END
				END 
		Insert into tra_TransactionMaster_OS(ParentTransactionMasterId,PreclearanceRequestId,UserInfoId,DisclosureTypeCodeId,
						TransactionStatusCodeId,NoHoldingFlag,TradingPolicyId,PeriodEndDate,DisplayRollingNumber,
						CreatedBy,CreatedOn,ModifiedBy,ModifiedOn,CDDuringPE,InsiderIDFlag 
						)
		Values (@nParentTransactionMasterId,@inp_sPreclearanceRequestId,@inp_iUserInfoId,@inp_iDisclosureTypeCodeId,
						@inp_iTransactionStatusCodeId,@inp_sNoHoldingFlag,@TradingPolicyId,@inp_dtPeriodEndDate,
						@nDisplayRollingNumber,@inp_nUserId,dbo.uf_com_GetServerDate(),@inp_nUserId,dbo.uf_com_GetServerDate(),
						@inp_CDDuringPE,@inp_InsiderIDFlag 
						)
		SET @inp_sTransactionMasterId = SCOPE_IDENTITY()
			END	
			ELSE
			BEGIN			
				SELECT @inp_sTransactionMasterId = TransactionMasterId 
				FROM   tra_TransactionMaster_OS 
				WHERE  DisclosureTypeCodeId = @inp_iDisclosureTypeCodeId  
				  and  UserInfoId = @inp_iUserInfoId 
				  and  (@inp_dtPeriodEndDate IS NULL or PeriodEndDate = @inp_dtPeriodEndDate)
			END
		END
		ELSE
		BEGIN
			--Check if the TransactionMaster whose details are being updated exists
			IF (NOT EXISTS(SELECT TransactionMasterId FROM tra_TransactionMaster_OS WHERE TransactionMasterId = @inp_sTransactionMasterId))			
			BEGIN	
				SET @out_nReturnValue = @ERR_TRANSACTIONMASTER_NOTFOUND
				RETURN (@out_nReturnValue)
			END
			ELSE
			BEGIN
				-- check if need to update exercise pool or not 
				IF EXISTS(SELECT TransactionMasterId FROM tra_TransactionMaster_OS WHERE TransactionMasterId = @inp_sTransactionMasterId 
							AND TransactionStatusCodeId in (@CONST_DISCLOSURE_STATUS_FOR_DOCUMENTUPLOAD, @CONST_DISCLOSURE_STATUS_FOR_NOT_CONFIRM)) 
					AND (@inp_iTransactionStatusCodeId = @CONST_DISCLOSURE_STATUS_FOR_CONFIRM)
				BEGIN
					SET @bIsUpdateExercisePool = 1
				END				
				
				IF @inp_iTransactionStatusCodeId = @CONST_DISCLOSURE_STATUS_FOR_CONFIRM
				BEGIN
				    IF @inp_sNoHoldingFlag = 1
				    BEGIN
				        Delete from tra_TransactionDetails_OS
				        where TransactionMasterId = @inp_sTransactionMasterId
				    END
				    ELSE
				    BEGIN
						IF (NOT EXISTS(SELECT * FROM tra_TransactionDetails_OS where TransactionMasterId = @inp_sTransactionMasterId))
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
						--EXEC st_tra_TransactionMasterIsPCLReq @inp_sTransactionMasterId, @out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT, @out_sSQLErrMessage OUTPUT
						--IF @out_nReturnValue <> 0
						--BEGIN
						--	RETURN @out_nReturnValue
						--END
				    END
				    				    
				    -- check if update security pool or not 
					IF (@bIsUpdateExercisePool = 1)
					BEGIN						
						EXECUTE @RC = [st_tra_ExerciseBalancePoolUpdateDetails_OS] 
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
							UPDATE tra_TransactionDetails_OS SET DateOfInitimationToCompany = GETDATE() 
							WHERE TransactionMasterId = @inp_sTransactionMasterId AND DateOfInitimationToCompany IS NULL
						END
					END	
					
					UPDATE tra_TransactionMaster_OS
					SET	TransactionStatusCodeId = @inp_iTransactionStatusCodeId				
						,ModifiedBy = @inp_nUserId
						,ModifiedOn = dbo.uf_com_GetServerDate()						
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
					
					UPDATE tra_TransactionMaster_OS
					SET	TransactionStatusCodeId = @inp_iTransactionStatusCodeId
						,ModifiedBy = @inp_nUserId
						,ModifiedOn = dbo.uf_com_GetServerDate()						
					WHERE TransactionMasterId = @inp_sTransactionMasterId				
				END				
				ELSE
				BEGIN				
					-- check if update security pool or not 
					IF (@bIsUpdateExercisePool = 1)
					BEGIN						
						EXECUTE @RC = [st_tra_ExerciseBalancePoolUpdateDetails_OS] 
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
					
					UPDATE tra_TransactionMaster_OS
					SET	TransactionStatusCodeId = @inp_iTransactionStatusCodeId				
						,ModifiedBy = @inp_nUserId
						,ModifiedOn = dbo.uf_com_GetServerDate()						
					WHERE TransactionMasterId = @inp_sTransactionMasterId				
					
					IF(CHARINDEX(@FIND_AXISBANK, @DBNAME) > 0)	
					BEGIN					
						IF (@nLoginUSERTYPE <> @USERTYPE_ADMIN AND  @nLoginUSERTYPE <> @USERTYPE_COUSER AND @inp_iTransactionStatusCodeId = @CONST_DISCLOSURE_STATUS_SOFTCOPY)
						BEGIN
							UPDATE tra_TransactionDetails_OS SET DateOfInitimationToCompany = GETDATE() 
							WHERE TransactionMasterId = @inp_sTransactionMasterId AND DateOfInitimationToCompany IS NULL
						END
					END
							
				END
				
				EXEC @nTmpRet = st_tra_TradingTransactionMasterConfirm_OS @inp_sTransactionMasterId, @inp_nUserId, @out_nReturnValue, @out_nSQLErrCode, @out_sSQLErrMessage
				IF @out_nReturnValue <> 0
				BEGIN
					SET @out_nReturnValue = @ERR_TRANSACTIONMASTER_SAVE
					RETURN @out_nReturnValue
				END		
			END
		END
		 
		--Check COnfirmation Event is occured or not
		IF(EXISTS(SELECT EL.EventLogId FROM eve_EventLog EL
					JOIN tra_TransactionMaster_OS TM ON EL.MapToId  = TM.TransactionMasterId AND MapToTypeCodeId = 132005
					WHERE EL.EventCodeId = @CONST_INITIAL_DISCLOSURE_CONFIRM_EVENT 
						AND TM.DisclosureTypeCodeId = @CONST_INITIAL_DISCLOSURE_TYPE_CODEID 
						AND TransactionMasterId = @inp_sTransactionMasterId))
		BEGIN
			SET @out_nDisclosureCompletedFlag = 1
		END
		
		SELECT @out_nTransactionMasterId = @inp_sTransactionMasterId
		
		-- in case required to return for partial save case.
		IF @inp_sCalledFrom <> 'MASSUPLOAD'
		BEGIN
			Select TransactionMasterId, PreclearanceRequestId, UserInfoId, DisclosureTypeCodeId, TransactionStatusCodeId, NoHoldingFlag, TradingPolicyId,PeriodEndDate, 
			 CDDuringPE,HardCopyReq
				From tra_TransactionMaster_OS
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