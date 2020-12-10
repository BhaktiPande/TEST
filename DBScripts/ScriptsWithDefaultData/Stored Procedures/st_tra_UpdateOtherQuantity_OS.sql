IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_tra_UpdateOtherQuantity_OS')
DROP PROCEDURE [dbo].[st_tra_UpdateOtherQuantity_OS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	This procedure is used for Update OtherExcerciseOptionQty column
				while submitting transaction. and while sell type transaction check then check available qty 
				exists in balance pool

Returns:		0, if Success.
				
Created by:		Priyanka
Created on:		21-FEB-2019
-------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[st_tra_UpdateOtherQuantity_OS] 
	@inp_iTransactionMasterID					BIGINT,
	@inp_sPreclearanceRequestId					BIGINT = NULL,
	@inp_iDisclosureTypeCodeId					INT,
	@inp_iTransactionStatusCodeId				INT,
	@out_nReturnValue							INT = 0 OUTPUT,
	@out_nSQLErrCode							INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage							NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
AS
BEGIN
	
	--Declare Variable
	DECLARE @ERR_UPDATEEXCERCISEBALANCEPOOL							INT
	DECLARE @nUserInfoID											INT
	DECLARE @nCompanyID												INT
	DECLARE @TrasnactionDetailsID									INT
	DECLARE @Quantity												DECIMAL(10, 0)
	
	DECLARE @nBuyTransctionType										INT = 143001
	DECLARE @nSellTransctionType									INT = 143002
	DECLARE @nPledgeTransctionType                                  INT = 143006
	DECLARE @nPledgeRevokeTransctionType                            INT = 143007
	DECLARE @nPledgeInvokeTransctionType                            INT = 143008
	
	DECLARE @nShareSecurityType										INT = 139001
	DECLARE @nWarrantsSecurityType									INT = 139002
	DECLARE @nConvertibleDebenturesType								INT = 139003
	DECLARE @nFutureContractsSecurityType							INT = 139004
	DECLARE @nOptionContractsSecurityType							INT = 139005
	
	DECLARE @nTransStatus_Confirmed									INT = 148007
	
	SET @ERR_UPDATEEXCERCISEBALANCEPOOL		= 16327
	
	DECLARE @nSumDetailsQuantity	DECIMAL(10, 0) 
	DECLARE @nPCLQuantity			DECIMAL(10, 0) 
	DECLARE @nOverTradedDifferenceQty	DECIMAL(10, 0)

	DECLARE @nPCLOtherExerciseOptionQuantity						DECIMAL(10, 0) = 0
	DECLARE @nPreClearanceTrasactionType	INT
	DECLARE @nSecurityTypeCodeID	INT
	DECLARE @nPreClearanceModeOfAcquisition INT
	DECLARE @nPreClearanceSecurityTypeCodeId INT
	
	--Impact on Post Share quantity  
	DECLARE @nAdd  INT = 505001
	DECLARE @nLess INT = 505002
	DECLARE @nBoth INT = 505003
	
	DECLARE @nPCLDMATDetailsID INT
	DECLARE @TDDMATDEtailsID INT
	DECLARE @nTDSecurityTypeCodeID INT
	DECLARE @nPCLCompanyID INT
	
	BEGIN TRY
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;
		--Curosr Start
				
				
	IF (@inp_iTransactionMasterId <> 0 AND @inp_iTransactionStatusCodeId = @nTransStatus_Confirmed AND @inp_iDisclosureTypeCodeId <> 147001)
	BEGIN	
		
		DECLARE @GetTrasnactionDetailsID CURSOR 

		SELECT @nUserInfoID = UserInfoID FROM tra_TransactionMaster_OS WHERE TransactionMasterId = @inp_iTransactionMasterID
		print '@nUserInfoID'
		print @nUserInfoID	
		SELECT @inp_sPreclearanceRequestId = PreclearanceRequestId  FROM tra_TransactionMaster_OS 
		WHERE TransactionMasterId = @inp_iTransactionMasterId
		print '@inp_sPreclearanceRequestId'
		print @inp_sPreclearanceRequestId
		IF @inp_sPreclearanceRequestId IS  NOT NULL OR @inp_sPreclearanceRequestId <> 0
		BEGIN 
			SELECT @nSecurityTypeCodeID =  SecurityTypeCodeId,
			@nPCLDMATDetailsID = DMATDetailsID,
			@nPCLCompanyID = CompanyId
			FROM tra_PreclearanceRequest_NonImplementationCompany WHERE PreclearanceRequestId = @inp_sPreclearanceRequestId
		END
		ELSE
		BEGIN
			SELECT TOP 1 @nSecurityTypeCodeID = SecurityTypeCodeId 
			FROM tra_TransactionDetails_OS WHERE TransactionMasterId = @inp_iTransactionMasterId
		END
		
		--Check this secuirty type allow negative balance flag
		--SET @bIsAllowNegativeBalance =  dbo.uf_tra_IsAllowNegativeBalanceForSecurity(@nSecurityTypeCodeID)
		
		--check is allow negative balance for that secuirty type
			--EXEC @nTmpRet = st_tra_IsAllowNegativeBalanceForSecurity @nSecurityTypeCodeID,@bIsAllowNegativeBalance OUTPUT,
			--				@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT, @out_sSQLErrMessage OUTPUT
		
			--IF @out_nReturnValue <> 0
			--BEGIN
			--	SET @out_nReturnValue = @out_nReturnValue --@ERR_CHECKISALLOWNEGATIVEBALANCE
			--	RETURN @out_nReturnValue
			--END
		
		/*
	    
			Create Temp Table and save balance in per details
	    
	    */
	    
	    CREATE TABLE #tabledematwise(DMATID INT,SecurityTypeCodeID INT,CompanyID INT, OtherBalance DECIMAL(15,0))
	    
	    INSERT INTO #tabledematwise	
		SELECT DMATDetailsID,SecurityTypeCodeId,CompanyId,0 FROM tra_TransactionDetails_OS 
		WHERE TransactionMasterId = @inp_iTransactionMasterId
		GROUP BY SecurityTypeCodeId,DMATDetailsID,CompanyId
		
		UPDATE TW 
		SET OtherBalance = EBP.ActualQuantity
		FROM #tabledematwise TW
		JOIN tra_BalancePool_OS EBP ON EBP.DMATDetailsID = TW.DMATID
		AND TW.SecurityTypeCodeID = EBP.SecurityTypeCodeId
		AND TW.CompanyID = EBP.CompanyID
		WHERE EBP.UserInfoId = @nUserInfoID 
		
		UPDATE  TD
		SET TD.OtherExcerciseOptionQty = TD.Quantity
		FROM tra_TransactionMaster_OS TM
		JOIN tra_TransactionDetails_OS TD ON TM.TransactionMasterId = TD.TransactionMasterId
		WHERE TD.TransactionTypeCodeId IN(@nBuyTransctionType,@nPledgeTransctionType,@nPledgeRevokeTransctionType,@nPledgeInvokeTransctionType) 
		AND TD.SecurityTypeCodeId IN(@nShareSecurityType, @nWarrantsSecurityType,@nConvertibleDebenturesType,
													@nFutureContractsSecurityType,@nOptionContractsSecurityType) 
		AND TM.TransactionMasterId = @inp_iTransactionMasterID 
		  			
		UPDATE TW
		SET OtherBalance = OtherBalance + Qty
		FROM #tabledematwise TW JOIN
		(SELECT DMATDetailsID, CompanyId, ISNULL(SUM(Quantity),0) AS  Qty FROM tra_TransactionDetails_OS 
		WHERE TransactionMasterId = @inp_iTransactionMasterId
			AND TransactionTypeCodeId IN (@nBuyTransctionType) AND SecurityTypeCodeId = @nShareSecurityType
		GROUP BY TransactionMasterId,DMATDetailsID,CompanyId) TD ON tw.DMATID = TD.DMATDetailsID
				
				IF(@inp_sPreclearanceRequestId IS NOT NULL)
				BEGIN
					-- get pre clearance exercise pool quantity which is set when preclearance is taken
					SELECT @nPCLOtherExerciseOptionQuantity = OtherExcerciseOptionQty, 
						@nPreClearanceTrasactionType = TransactionTypeCodeId, @nPreClearanceModeOfAcquisition = ModeOfAcquisitionCodeId, 
						@nPreClearanceSecurityTypeCodeId = SecurityTypeCodeId 
					FROM tra_PreclearanceRequest_NonImplementationCompany 
					WHERE PreclearanceRequestId = @inp_sPreclearanceRequestId AND SecurityTypeCodeId = @nShareSecurityType AND DMATDetailsID = @nPCLDMATDetailsID 
					AND CompanyId = @nPCLCompanyID					
					
					IF (@nLess = (select IMPT_POST_SHARE_QTY_CODE_ID from tra_TransactionTypeSettings_OS where MODE_OF_ACQUIS_CODE_ID = @nPreClearanceModeOfAcquisition 
						AND TRANS_TYPE_CODE_ID = @nPreClearanceTrasactionType AND SECURITY_TYPE_CODE_ID = @nPreClearanceSecurityTypeCodeId))
					BEGIN
					UPDATE TW
							SET
							OtherBalance = OtherBalance + OtherQty
						FROM #tabledematwise TW 
						JOIN(
						SELECT DMATDetailsID,ISNULL(ActualQuantity,0) AS OtherQty FROM tra_BalancePool_OS 
						WHERE UserInfoId = @nUserInfoID	AND SecurityTypeCodeId = @nSecurityTypeCodeID AND DMATDetailsID = @nPCLDMATDetailsID 
						AND CompanyID = @nPCLCompanyID) EBP ON EBP.DMATDetailsID = TW.DMATID
					END
				END
									
				IF(@inp_sPreclearanceRequestId IS NOT NULL)	
				BEGIN
					SELECT  @nSumDetailsQuantity = SUM(TD.Quantity),
							@nPCLQuantity = PR.SecuritiesToBeTradedQty
					FROM tra_TransactionMaster_OS TM 
					JOIN tra_TransactionDetails_OS TD ON TM.TransactionMasterId = TD.TransactionMasterId
					JOIN tra_PreclearanceRequest_NonImplementationCompany PR ON TM.PreclearanceRequestId = PR.PreclearanceRequestId
					WHERE TD.TransactionTypeCodeId = 143002 
					AND TD.SecurityTypeCodeId = @nSecurityTypeCodeID AND TM.PreclearanceRequestId IS NOT NULL 
					AND TM.PreclearanceRequestId =  @inp_sPreclearanceRequestId
					GROUP BY TM.PreclearanceRequestId,PR.SecuritiesToBeTradedQty
						
					SET @nOverTradedDifferenceQty = @nPCLQuantity - @nSumDetailsQuantity
				
				   --select @nOverTradedDifferenceQty,@nSumDetailsQuantity,@nPCLQuantity
				 
					IF(@nOverTradedDifferenceQty<0)
					BEGIN
						
						UPDATE #tabledematwise
						SET OtherBalance = OtherBalance+@nPCLOtherExerciseOptionQuantity
						WHERE SecurityTypeCodeId = @nSecurityTypeCodeID AND DMATID = @nPCLDMATDetailsID AND CompanyID = @nPCLCompanyID
					END 
				END
				
				
				--Curosr Start
				
					
				SET @GetTrasnactionDetailsID = CURSOR FOR
					--Select Transaction details Quantity, Balance pool quantity
					SELECT TransactionDetailsID,Quantity,DMATDetailsID,TD.SecurityTypeCodeId,CompanyId
					FROM tra_TransactionDetails_OS TD
					JOIN tra_TransactionMaster_OS TM ON TM.TransactionMasterId = TD.TransactionMasterId
					WHERE TD.TransactionMasterID = @inp_iTransactionMasterID
					AND TD.TransactionTypeCodeId = @nSellTransctionType AND TD.SecurityTypeCodeId =  @nSecurityTypeCodeID
				
				OPEN @GetTrasnactionDetailsID
				DECLARE @ntmpty INT = 0
				FETCH NEXT FROM @GetTrasnactionDetailsID INTO @TrasnactionDetailsID,@Quantity,@TDDMATDEtailsID,@nTDSecurityTypeCodeID,@nCompanyID
				
				WHILE @@FETCH_STATUS = 0
				BEGIN
							UPDATE tra_TransactionDetails_OS
							SET OtherExcerciseOptionQty = @Quantity
							WHERE TransactionDetailsId = @TrasnactionDetailsID
						
				FETCH NEXT FROM @GetTrasnactionDetailsID INTO @TrasnactionDetailsID,@Quantity,@TDDMATDEtailsID,@nTDSecurityTypeCodeID,@nCompanyID
				END	
				CLOSE @GetTrasnactionDetailsID
				DEALLOCATE @GetTrasnactionDetailsID
		END
	RETURN @out_nReturnValue
		
		
	END	 TRY
	
	BEGIN CATCH	
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()	
		
		-- Return common error if required, otherwise specific error.		
		SET @out_nReturnValue =  dbo.uf_com_GetErrorCode(@ERR_UPDATEEXCERCISEBALANCEPOOL, ERROR_NUMBER())
		RETURN @out_nReturnValue
	END CATCH
END