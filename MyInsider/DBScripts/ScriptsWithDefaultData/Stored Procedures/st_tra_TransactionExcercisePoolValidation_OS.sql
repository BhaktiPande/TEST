IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_tra_TransactionExcercisePoolValidation_OS')
DROP PROCEDURE [dbo].[st_tra_TransactionExcercisePoolValidation_OS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Balance pool validation for OS

Returns:		0, if Success.
				
Created by:		Tushar Wakchaure
Created on:		12-Apr-2019

-------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[st_tra_TransactionExcercisePoolValidation_OS] 
	@inp_iTransactionDetailsID					BIGINT,
	@inp_iTransactionMasterId					BIGINT,
	@inp_iForUserInfoId							INT,
	@inp_dQuantity								DECIMAL(10, 0),
	@inp_iSecurityTypeCodeId					INT,
	@inp_sType         			                NVARCHAR(50),
	@inp_iLotSize                               INT,
	@inp_iDMATDetailsID							INT,
	@out_nReturnValue							INT = 0 OUTPUT,
	@out_nSQLErrCode							INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage							NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
AS
BEGIN
	
	--Declare Variable
	DECLARE @ERR_UPDATEEXCERCISEBALANCEPOOL							INT
	DECLARE @ERR_NEGATIVEERRORMESSAGE								INT
	DECLARE @nGenCashAndCashlessPartialExciseOptionForContraTrade	INT
	DECLARE @nESOPQty												INT
	DECLARE @nOtherQty												INT
	DECLARE @nBuyTransctionType										INT = 143001
	DECLARE @nCashExcerciseTransctionType							INT = 143003
	DECLARE @nCashlessPartialTransctionType							INT = 143005
	DECLARE @nShareSecurityType										INT = 139001
	DECLARE @nESOPFirstOptionThenOther								INT = 172001
	DECLARE @nOtherFirstThenESOP									INT = 172002
	DECLARE @nUserSelectionRule										INT = 172003
	DECLARE @nBuyTransactionTotalQuanity							DECIMAL(10, 0)
	DECLARE @nESOPTransactionTotalQuanity							DECIMAL(10, 0)
	DECLARE @nESOPTransactionPartialTotalQuanity					DECIMAL(10, 0)
	DECLARE @nPCLID													BIGINT
	
	SET @ERR_UPDATEEXCERCISEBALANCEPOOL = 16327
	SET @ERR_NEGATIVEERRORMESSAGE		= 16430
	
	
	DECLARE @nContraTradeOption				INT
	DECLARE @nContraTradeGeneralOption		INT = 175001
	DECLARE @nContraTradeQuantityBase		INT = 175002
	
	DECLARE @nPledgeQty	INT 
    DECLARE @nTransactionType_Pledge INT = 143006
	DECLARE @nTransactionType_PledgeRevoke INT = 143007
	DECLARE @nTransactionType_PledgeInvoke INT = 143008
	
	DECLARE @nTransactionTypeCodeId INT = NULL
	DECLARE @nModeOfAcquisitionCodeId INT
	DECLARE @nQuantity DECIMAL(10,0)
	DECLARE @nQuantity2 DECIMAL(10,0)
	--DECLARE @nESOPQuanity DECIMAL(15,4) = 0
	DECLARE @nOtherQuantity DECIMAL(15,4) = 0
	DECLARE @nPledgeQuantity DECIMAL(15,4) = 0	
	DECLARE @nQuantityForOther INT	
	DECLARE @nQuantityForPledge INT
	DECLARE @nLess INT = 505002
	DECLARE @nUserInfoId_FromRelative   INT
	DECLARE @nUserType_Relative         INT = 101007
	DECLARE @out_nPledgeClosingBalance	DECIMAL(10,0) = 0
	DECLARE @nPeriodCodeId              INT = 124001

	DECLARE @bIsAllowNegativeBalance BIT
	DECLARE @nTmpRet INT
	
	DECLARE @nLotSize INT
	
	BEGIN TRY
	print @inp_sType
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;
		
		IF(@inp_iLotSize != 0 AND @inp_iLotSize IS NOT NULL)
		BEGIN
		  SET @inp_dQuantity = @inp_dQuantity * @inp_iLotSize
		END
						
				print 'other secuirty case'
				IF @nPCLID IS NULL
				 BEGIN
				     --set quantity
					SET @nOtherQuantity = 0 								
					SET @nPledgeQuantity = 0
				    
					SELECT @nOtherQty = ActualQuantity, @nPledgeQty = PledgeQuantity
					FROM tra_BalancePool_OS 
					 WHERE UserInfoId = @inp_iForUserInfoId AND SecurityTypeCodeId = @inp_iSecurityTypeCodeId AND DMATDetailsID = @inp_iDMATDetailsID					 
					 
					IF((select UserTypeCodeId from usr_UserInfo where UserInfoId = @inp_iForUserInfoId) = @nUserType_Relative)
				     BEGIN
				       select @nUserInfoId_FromRelative = UserInfoId from usr_UserRelation where UserInfoIdRelative = @inp_iForUserInfoId
				     END
				     ELSE
				     BEGIN
				        set @nUserInfoId_FromRelative = @inp_iForUserInfoId
				     END
				     SELECT TOP 1 @out_nPledgeClosingBalance =  PledgeClosingBalance FROM [dbo].[tra_TransactionSummaryDMATWise_OS]  WHERE PeriodCodeId = @nPeriodCodeId  AND UserInfoId = @nUserInfoId_FromRelative AND UserInfoIdRelative = @inp_iForUserInfoId AND SecurityTypeCodeId = @inp_iSecurityTypeCodeId  ORDER BY TransactionSummaryDMATWiseId DESC
					 
					DECLARE TransactionDetail_Cursor CURSOR FOR 
						SELECT TransactionTypeCodeId,ModeOfAcquisitionCodeId, Quantity, LotSize  FROM tra_TransactionDetails_OS 
						WHERE TransactionMasterId = @inp_iTransactionMasterId AND SecurityTypeCodeId = @inp_iSecurityTypeCodeId AND ForUserInfoId = @inp_iForUserInfoId AND TransactionDetailsId != @inp_iTransactionDetailsID
 
					OPEN TransactionDetail_Cursor
					
					FETCH NEXT FROM TransactionDetail_Cursor INTO 
						@nTransactionTypeCodeId, @nModeOfAcquisitionCodeId, @nQuantity, @nLotSize 
					
					WHILE @@FETCH_STATUS = 0
					BEGIN
																    							
						select top 1 @nQuantityForOther = nOtherQuantity, @nQuantityForPledge = nPledgeQuantity from uf_tra_GetOtherAndPledgeQuantityForValidation(@nQuantity,@nModeOfAcquisitionCodeId,@nTransactionTypeCodeId,@inp_iSecurityTypeCodeId, ISNULL(@nLotSize,0))
						
						IF(@inp_sType = 'OtherQty')	
						BEGIN
							SET @nOtherQuantity = @nOtherQuantity + @nQuantityForOther
						END
						ELSE IF (@inp_sType = 'PledgeQty')
						BEGIN 								        						
							SET @nPledgeQuantity = @nPledgeQuantity + @nQuantityForPledge
						END
						
						FETCH NEXT FROM TransactionDetail_Cursor INTO 
							@nTransactionTypeCodeId, @nModeOfAcquisitionCodeId, @nQuantity, @nQuantity2, @nLotSize	
						
					END
					
					CLOSE TransactionDetail_Cursor
					DEALLOCATE TransactionDetail_Cursor;
						 
				    
					IF(@inp_sType = 'OtherQty')	
					BEGIN
						IF(((ROUND(@inp_dQuantity,0)) + (ROUND(@nOtherQuantity,0))) > (ROUND(@nOtherQty,0)) AND @bIsAllowNegativeBalance = 1)
						BEGIN	
							SET @out_nReturnValue = @ERR_NEGATIVEERRORMESSAGE
							RETURN @out_nReturnValue
						END  
					END
					ELSE IF (@inp_sType = 'PledgeQty')
					BEGIN	
					    PRINT 'PLG'				
						IF((ROUND(@inp_dQuantity,0) + ROUND(@nPledgeQuantity,0)) > ROUND(@out_nPledgeClosingBalance,0))
						BEGIN
							SET @out_nReturnValue = @ERR_NEGATIVEERRORMESSAGE
							RETURN @out_nReturnValue
						END 
					END
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