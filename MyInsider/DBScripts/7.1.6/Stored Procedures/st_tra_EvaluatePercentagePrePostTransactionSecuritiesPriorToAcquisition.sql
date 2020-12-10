IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_tra_EvaluatePercentagePrePostTransactionSecuritiesPriorToAcquisition')
DROP PROCEDURE [dbo].[st_tra_EvaluatePercentagePrePostTransactionSecuritiesPriorToAcquisition]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	This procedure used for getting values of SecuritiesPriorToAcquisition,PerOfSharesPreTransaction,PerOfSharesPostTransaction
				& SecuritiesPostToAcquisition for transaction details while submitting and editing details.

Returns:		0, if Success.
				
Created by:		Tushar
Created on:		27-Oct-2016
Modification History:
Modified By		Modified On		Description

Usage:
CREATE TABLE #tmpEvaluatePercentagePrePostTransaction (TransactionDetailsId BIGINT NOT NULL, SecuritiesPriorToAcquisition DECIMAL(20,0) NOT NULL,
				PerOfSharesPreTransaction DECIMAL(5,2) NOT NULL,PerOfSharesPostTransaction DECIMAL(5,2) NOT NULL,SecuritiesPostToAcquisition DECIMAL(20,0) NOT NULL)
-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_tra_EvaluatePercentagePrePostTransactionSecuritiesPriorToAcquisition]
	@inp_iTransactionMasterId				BIGINT,
	@out_nReturnValue						INT = 0 OUTPUT,
	@out_nSQLErrCode						INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage						NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
AS
BEGIN

	DECLARE @ERR_EvaluatePercentagePrePostTransactionSecuritiesPriorToAcquisition INT = 17531 -- Error occurred while calculating  Percentage of pre & post transaction for securities.
	DECLARE @nRetValue INT

	BEGIN TRY
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;

		--Initialize variables
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''
		
		DECLARE @TDID BIGINT,@nTransactionTypeCodeId BIGINT,@nModeOfAcquisitionCodeId INT,@nQuantity DECIMAL(15,0),@nQuantity2 DECIMAL(15,0),
			    @dtDateOfAcquisition DATETIME,@iUserInfoId INT,@iForUserInfoId INT,
			    @nSecurityTypeCodeId INT
		
		DECLARE @out_dClosingBalance DECIMAL(30,0) = 0
		DECLARE @dPaidUpShare DECIMAL(30,0)
		
		DECLARE @dPrePercentage DECIMAL(5,2)
		DECLARE @dPostPercentage DECIMAL(5,2)
		DECLARE @dPostAcq DECIMAL(30,0) = 0
		
		DECLARE @inp_dtAuthorizedShareCapitalDate DATETIME  = GETDATE()
		DECLARE @nImpactOnPostQuantity INT
				
		DECLARE @RC INT
		
		DECLARE @nMultiplier INT  = 100
		DECLARE @nBuyTransactionType INT = 143001
		DECLARE @nSellTransactionType INT = 143002
		DECLARE @nESOPTransactionType INT = 143003
		DECLARE @nCashPartialTransactionType INT = 143004
		DECLARE @nCashlessAllTransactionType INT = 143005
		DECLARE @nPledge INT  = 143006
		DECLARE @nPledgeRevoke INT  = 143007
		DECLARE @nPledgeInvoke INT  = 143008
		
		DECLARE @nImpactonPostShareQuantityAdd INT  = 505001
		DECLARE @nImpactonPostShareQuantityLess INT  = 505002
		DECLARE @nImpactonPostShareQuantityBoth INT  = 505003
		DECLARE @nImpactonPostShareQuantityNo INT  = 505004
		
		DECLARE @nPeriodCodeId INT = 124001
		
		
		--DECLARE @tmpTable Table(TransactionDetailsID BIGINT,SecuirtiesPriorAquasation DECIMAL(30,0),PrePercentage DECIMAL(5,2),PostPercentage DECIMAL(5,2),PostAcquasation DECIMAL(30,0))
		print convert(varchar(max), @inp_iTransactionMasterId)
		-- Fetch Paid Up Share 
		SELECT TOP 1 @dPaidUpShare =  PaidUpShare 
		FROM com_CompanyPaidUpAndSubscribedShareCapital SC
		INNER JOIN mst_Company C ON SC.CompanyID = C.CompanyId
		WHERE C.IsImplementing = 1
		AND PaidUpAndSubscribedShareCapitalDate <= @inp_dtAuthorizedShareCapitalDate
		ORDER BY PaidUpAndSubscribedShareCapitalDate DESC
		
		DECLARE TransactionDetail_CursorForPrePost CURSOR LOCAL FOR 
		SELECT TOP 1 TransactionDetailsId, TransactionTypeCodeId,ModeOfAcquisitionCodeId, Quantity,Quantity2,DateOfAcquisition,TM.UserInfoId,ForUserInfoId,TD.SecurityTypeCodeId 
		FROM tra_TransactionDetails TD
		JOIN tra_TransactionMaster TM ON TM.TransactionMasterId = TD.TransactionMasterId
		WHERE TD.TransactionMasterId = @inp_iTransactionMasterId 

		OPEN TransactionDetail_CursorForPrePost
			
		FETCH NEXT FROM TransactionDetail_CursorForPrePost INTO 
						@TDID,@nTransactionTypeCodeId,@nModeOfAcquisitionCodeId, @nQuantity,@nQuantity2,@dtDateOfAcquisition,
						@iUserInfoId,@iForUserInfoId,@nSecurityTypeCodeId
				
		DECLARE @nCount INT = 0		
			
		WHILE @@FETCH_STATUS = 0
		BEGIN
		
			  SELECT TOP 1  @out_dClosingBalance =  ClosingBalance FROM [dbo].[tra_TransactionSummary]
			  WHERE PeriodCodeId = @nPeriodCodeId
			  AND UserInfoId = @iUserInfoId
			  AND UserInfoIdRelative = @iForUserInfoId
			  AND SecurityTypeCodeId = @nSecurityTypeCodeId
			  ORDER BY TransactionSummaryId DESC
			
			--SELECT @TDID,@nTransactionTypeCodeId,@nModeOfAcquisitionCodeId, @nQuantity,@nQuantity2,@dtDateOfAcquisition,@iUserInfoId,@iForUserInfoId,@nSecurityTypeCodeId
			
			--EXEC @RC = st_tra_GetClosingBalanceOfAnnualPeriod @iUserInfoId,@iForUserInfoId,@nSecurityTypeCodeId,@out_dClosingBalance OUTPUT,
			--				@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT, @out_sSQLErrMessage OUTPUT

			--IF @out_nReturnValue <> 0
			--BEGIN
			--	SET @out_nReturnValue = @out_nReturnValue --VALIDATION
			--	RETURN @out_nReturnValue
			--END
			--select @out_dClosingBalance AS ClosingBalance
			-- Calculate Pre Percentage
			SET @dPrePercentage = (@out_dClosingBalance * @nMultiplier) / @dPaidUpShare 
			
			--Calculate Post percentage
			IF @nTransactionTypeCodeId = @nBuyTransactionType OR @nTransactionTypeCodeId = @nESOPTransactionType
			BEGIN
				SET @dPostPercentage = ((@out_dClosingBalance + @nQuantity )* @nMultiplier) / @dPaidUpShare 
			END
			ELSE IF @nTransactionTypeCodeId = @nSellTransactionType
			BEGIN
				SET @dPostPercentage = ((@out_dClosingBalance - @nQuantity )* @nMultiplier) / @dPaidUpShare 
			END
			ELSE IF @nTransactionTypeCodeId = @nCashPartialTransactionType
			BEGIN
				SET @dPostPercentage = (@out_dClosingBalance * @nMultiplier) / @dPaidUpShare 
			END
			ELSE IF @nTransactionTypeCodeId = @nCashlessAllTransactionType
			BEGIN
				SET @dPostPercentage = ((@out_dClosingBalance + @nQuantity - @nQuantity2)* @nMultiplier) / @dPaidUpShare 
			END
			ELSE IF @nTransactionTypeCodeId = @nPledge OR @nTransactionTypeCodeId = @nPledgeRevoke
			BEGIN
				SET @dPostPercentage = (@out_dClosingBalance * @nMultiplier) / @dPaidUpShare 
			END
			ELSE IF @nTransactionTypeCodeId = @nPledgeInvoke
			BEGIN
				SET @dPostPercentage = ((@out_dClosingBalance - @nQuantity )* @nMultiplier) / @dPaidUpShare 
			END
		
			/*EXEC @RC =  st_tra_GetImpactOnPostQuantity @nTransactionTypeCodeId,@nModeOfAcquisitionCodeId,@nSecurityTypeCodeId,@nImpactOnPostQuantity OUTPUT,
						@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT, @out_sSQLErrMessage OUTPUT
			
			
			IF @out_nReturnValue <> 0
			BEGIN
				SET @out_nReturnValue = @out_nReturnValue --VALIDATION
				RETURN @out_nReturnValue
			END*/
			
			IF @nCount  > 0
			BEGIN
				SET @out_dClosingBalance = @dPostAcq
				--select @out_dClosingBalance AS ClosingBalance
			END
			/*
			IF @nImpactOnPostQuantity = @nImpactonPostShareQuantityAdd
			BEGIN
				SET @dPostAcq  = @out_dClosingBalance + @nQuantity
			END
			ELSE IF @nImpactOnPostQuantity = @nImpactonPostShareQuantityLess
			BEGIN
				SET @dPostAcq  = @out_dClosingBalance - @nQuantity
			END
			ELSE IF @nImpactOnPostQuantity = @nImpactonPostShareQuantityBoth OR @nImpactOnPostQuantity = @nImpactonPostShareQuantityNo
			BEGIN
				SET @dPostAcq  = @out_dClosingBalance
			END
			*/
			
			IF @nTransactionTypeCodeId  = @nBuyTransactionType OR @nTransactionTypeCodeId = @nESOPTransactionType
			BEGIN
				SET @dPostAcq  = @out_dClosingBalance + @nQuantity
			END
			ELSE IF @nTransactionTypeCodeId  = @nSellTransactionType
			BEGIN
				SET @dPostAcq  = @out_dClosingBalance - @nQuantity
			END
			ELSE IF @nTransactionTypeCodeId  = @nCashPartialTransactionType
			BEGIN
				SET @dPostAcq  = @out_dClosingBalance + (@nQuantity - @nQuantity2)
			END
			
			INSERT INTO #tmpEvaluatePercentagePrePostTransaction(TransactionDetailsId,SecuritiesPriorToAcquisition,PerOfSharesPreTransaction,
						PerOfSharesPostTransaction,SecuritiesPostToAcquisition)
			VALUES(@TDID,@out_dClosingBalance,@dPrePercentage,@dPostPercentage,@dPostAcq)
			
			SET @nCount = @nCount + 1
			
		FETCH NEXT FROM TransactionDetail_CursorForPrePost INTO 
		@TDID,@nTransactionTypeCodeId,@nModeOfAcquisitionCodeId, @nQuantity,@nQuantity2,@dtDateOfAcquisition,@iUserInfoId,@iForUserInfoId,@nSecurityTypeCodeId
		
		END
		CLOSE TransactionDetail_CursorForPrePost
		DEALLOCATE TransactionDetail_CursorForPrePost;
	
		--SELECT * FROM #tmpEvaluatePercentagePrePostTransaction
		
		SET @out_nReturnValue = 0
		RETURN @out_nReturnValue
		
	END	 TRY
	
	BEGIN CATCH	
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()	
		
		-- Return common error if required, otherwise specific error.		
		SET @out_nReturnValue =  dbo.uf_com_GetErrorCode(@ERR_EvaluatePercentagePrePostTransactionSecuritiesPriorToAcquisition, ERROR_NUMBER())
		RETURN @out_nReturnValue
	END CATCH
END