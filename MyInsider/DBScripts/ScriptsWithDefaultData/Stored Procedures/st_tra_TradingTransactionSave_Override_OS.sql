IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_tra_TradingTransactionSave_Override_OS')
DROP PROCEDURE [dbo].[st_tra_TradingTransactionSave_Override_OS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_tra_TradingTransactionSave_Override_OS] 
	@inp_iTransactionDetailsId BIGINT,
	@inp_iTransactionMasterId BIGINT,
	@inp_iSecurityTypeCodeId INT,
	@inp_iForUserInfoId INT,
	@inp_iDMATDetailsID INT,
	@inp_iCompanyId INT,
	@inp_dtDateOfAcquisition DATETIME,
	@inp_dtDateOfInitimationToCompany DATETIME,
	@inp_iModeOfAcquisitionCodeId INT ,
	@inp_iExchangeCodeId INT,
	@inp_iTransactionTypeCodeId INT,
	@inp_dQuantity decimal(10, 0),
	@inp_dValue decimal(10, 0),
	@inp_iLotSize INT,	
	@inp_sContractSpecification VARCHAR(50),
	@inp_sCompanyName			VARCHAR(300),
	@inp_iLoggedInUserId	INT,
	@inp_sCalledFrom	VARCHAR(20) = '',
	@inp_dOtherExcerciseOptionQty decimal(10, 0),	
	@out_nTransactionDetailsID BIGINT = 0 OUTPUT,
	@out_nReturnValue		INT = 0 OUTPUT,
	@out_nSQLErrCode		INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage		NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
AS
BEGIN

	DECLARE @ERR_TRADINGTRANSACTIONDETAILS_SAVE INT 
	DECLARE @ERR_TRADINGTRANSACTIONDETAILS_NOTFOUND INT
	DECLARE @nTmpRet INT = 0
	DECLARE @dQuantity decimal(10, 0)
	DECLARE @dValue decimal(10, 0)
	DECLARE @nWarningMsg INT
	DECLARE @nPCLID BIGINT
	DECLARE @nDisclosureType INT
	DECLARE @nUserInfoID	BIGINT	
	DECLARE @nTradingPolicyID	INT	
	DECLARE @DBNAME VARCHAR(100) = UPPER((SELECT DB_NAME()))
	DECLARE @FIND_AXISBANK VARCHAR(50) = 'AXISBANK'		
	DECLARE @nAutoSubmitTransactionFlag					INT
	DECLARE @nAutoSubmitYesTransactionFlag				INT = 178002
	DECLARE @nDisclosureTypeInitial INT = 147001
	
	
	BEGIN TRY
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;
		
		--Initialize variables
		SELECT	@ERR_TRADINGTRANSACTIONDETAILS_SAVE = 17328,  -- Not defined
				@ERR_TRADINGTRANSACTIONDETAILS_NOTFOUND = 17329 -- Not defined
		

		SELECT @nPCLID = TM.PreclearanceRequestId ,	
		@nDisclosureType = TM.DisclosureTypeCodeId,
		@nUserInfoID = TM.UserInfoId,
		@nTradingPolicyID = TM.TradingPolicyId
		FROM tra_TransactionMaster_OS TM
		LEFT JOIN tra_PreclearanceRequest_NonImplementationCompany PR ON TM.PreclearanceRequestId = PR.PreclearanceRequestId
		WHERE TransactionMasterId = @inp_iTransactionMasterId
	
		--made this change for period end-user has to submit his relatives initial dsclousre
		--changed date of acq from current date to created on date
		IF @nDisclosureType  = @nDisclosureTypeInitial AND @inp_dtDateOfAcquisition IS NULL
		BEGIN
			SET @inp_dtDateOfAcquisition = (select CreatedOn from usr_UserInfo where UserInfoId = @nUserInfoID)
		END

		IF(@nPCLID IS NOT NULL AND @nPCLID > 0)
		BEGIN
		    print '1';
			--SET @inp_bESOPExcerseOptionQtyFlag = @bESOPExcerseOptionQtyFlag 
			--SET @inp_bOtherESOPExcerseOptionFlag = @bOtherExcerseOptionQtyFlag
		END
		
		SELECT @dQuantity = @inp_dQuantity, -- + @inp_dQuantity2,
				@dValue = @inp_dValue --+ @inp_dValue2
				
		
	
		EXEC @nTmpRet = st_tra_TransactionDetailsValidation_OS @inp_iTransactionDetailsId, @inp_iTransactionMasterId, @inp_iSecurityTypeCodeId, 
															@inp_iForUserInfoId, @inp_iDMATDetailsID, @inp_iCompanyId, 
															@inp_dtDateOfAcquisition, @inp_dtDateOfInitimationToCompany, @inp_iModeOfAcquisitionCodeId, 
															@inp_iExchangeCodeId, 
															@inp_iTransactionTypeCodeId, @dQuantity, @dValue,	
															@inp_iLotSize, @inp_sContractSpecification, @inp_sCompanyName, @inp_iLoggedInUserId, 
															@inp_sCalledFrom, @inp_dOtherExcerciseOptionQty,
															@nWarningMsg OUTPUT, @out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT, @out_sSQLErrMessage OUTPUT
		
		IF @out_nReturnValue <> 0
		BEGIN
			--SET @out_nReturnValue = @ERR_TRADINGTRANSACTIONDETAILS_SAVE
			RETURN @out_nReturnValue
		END
		
		--Save the Trading transaction details 
		IF(@inp_iSecurityTypeCodeId=0 OR @inp_iSecurityTypeCodeId='')
		BEGIN
		SET @inp_iSecurityTypeCodeId=NULL
		END
		IF(@inp_iCompanyId=0 OR @inp_iCompanyId='')
		BEGIN
		SET @inp_iCompanyId=NULL
		END
		
		IF @inp_iTransactionDetailsId = 0
		BEGIN				
			Insert into tra_TransactionDetails_OS(
						TransactionMasterId
						,SecurityTypeCodeId
						,ForUserInfoId
						,DMATDetailsID
						,CompanyId					
						,DateOfAcquisition
						,DateOfInitimationToCompany
						,ModeOfAcquisitionCodeId				
						,ExchangeCodeId
						,TransactionTypeCodeId
						,Quantity
						,Value
						,LotSize
						,ContractSpecification
						,OtherExcerciseOptionQty				
						,CreatedBy, CreatedOn, ModifiedBy, ModifiedOn )
			Values (
						@inp_iTransactionMasterId ,
						@inp_iSecurityTypeCodeId ,
						@inp_iForUserInfoId ,
						@inp_iDMATDetailsID ,
						@inp_iCompanyId ,					
						@inp_dtDateOfAcquisition ,
						--CASE WHEN (CHARINDEX(@FIND_AXISBANK, @DBNAME) > 0) THEN NULL ELSE @inp_dtDateOfInitimationToCompany END ,
						ISNULL(@inp_dtDateOfInitimationToCompany, GETDATE()),
						@inp_iModeOfAcquisitionCodeId  ,				
						@inp_iExchangeCodeId ,
						@inp_iTransactionTypeCodeId ,
						@inp_dQuantity ,
						@inp_dValue,
						@inp_iLotSize,
						@inp_sContractSpecification,
						@inp_dOtherExcerciseOptionQty,
						@inp_iLoggedInUserId, dbo.uf_com_GetServerDate(), @inp_iLoggedInUserId, dbo.uf_com_GetServerDate() )
						SELECT @inp_iTransactionDetailsId = SCOPE_IDENTITY()
		END
		ELSE
		BEGIN
			--Check if the RoleMaster whose details are being updated exists
			IF (NOT EXISTS(SELECT TransactionDetailsId FROM tra_TransactionDetails_OS WHERE TransactionDetailsId = @inp_iTransactionDetailsId))		
			BEGIN
				SET @out_nReturnValue = @ERR_TRADINGTRANSACTIONDETAILS_NOTFOUND
				RETURN (@out_nReturnValue)
			END			
			Update tra_TransactionDetails_OS
			Set 	TransactionMasterId = @inp_iTransactionMasterId
					,SecurityTypeCodeId = @inp_iSecurityTypeCodeId
					,ForUserInfoId = @inp_iForUserInfoId
					,DMATDetailsID = @inp_iDMATDetailsID
					,CompanyId = @inp_iCompanyId				
					,DateOfAcquisition = @inp_dtDateOfAcquisition
					,DateOfInitimationToCompany = ISNULL(@inp_dtDateOfInitimationToCompany, GETDATE())
					,ModeOfAcquisitionCodeId = @inp_iModeOfAcquisitionCodeId			
					,ExchangeCodeId = @inp_iExchangeCodeId
					,TransactionTypeCodeId = @inp_iTransactionTypeCodeId
					,Quantity = @inp_dQuantity
					,Value = @inp_dValue				
					,LotSize = @inp_iLotSize
					,ContractSpecification = @inp_sContractSpecification				
					,ModifiedBy	= @inp_iLoggedInUserId
					,ModifiedOn = dbo.uf_com_GetServerDate()
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
				,TD.CompanyId				
				,DateOfAcquisition
				,DateOfInitimationToCompany
				,ModeOfAcquisitionCodeId			
				,ExchangeCodeId
				,TransactionTypeCodeId
				,Quantity
				,[Value]			
				,LotSize
				,ContractSpecification				
				,UI.UserTypeCodeId
				From tra_TransactionDetails_OS TD
				JOIN usr_UserInfo UI ON TD.ForUserInfoId=UI.UserInfoId
				Where TransactionDetailsId = @inp_iTransactionDetailsId	
		END
		EXEC st_tra_UpdatePeriodendForTransactionMaster_OS	@inp_iTransactionMasterId
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