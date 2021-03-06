IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_tra_TradingTransactionDetails')
DROP PROCEDURE [dbo].[st_tra_TradingTransactionDetails]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Get the TradingTransaction details

Returns:		0, if Success.
				
Created by:		gaurishankar
Created on:		15-Apr-2015

Modification History:
Modified By		Modified On	Description
Amar			22-May-2015 Changed and added  few parameters as per changes in UI.
Gaurishankar	25-Nov-2015	Added new parameter for New disclosure and contra trade change
Raghvendra		10-Mar-2016	Change to show the current date for DateOfIntemation to company when value is null
Gaurishankar	09-Aug-2016	Change for Allow Negative Balance.
Tushar			07-Sep-2016	Change for maintaining DMAT wise pool and related validation. 
Raghvendra		07-Sep-2016	Changed the GETDATE() call with function dbo.uf_com_GetServerDate(). This function will return the date to be used as server date.
Parag			27-Oct-2016		Made change to show calculated pre/post sequrity and precent for continuous disclosure which are not submitted

Usage:
EXEC st_tra_TradingTransactionDetails 1
-------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[st_tra_TradingTransactionDetails]
	@inp_iTransactionDetailsId	BIGINT,							-- Id of the TradingTransaction whose details are to be fetched.
	@out_nReturnValue			INT = 0 OUTPUT,
	@out_nSQLErrCode			INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage			NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
	
AS
BEGIN
	DECLARE @ERR_TRADINGTRANSACTIONDETAILS_GETDETAILS INT
	DECLARE @ERR_TRADINGTRANSACTIONDETAILS_NOTFOUND INT

	DECLARE @nTransactionMasterId BIGINT
	DECLARE @nTradingPolicy INT
	DECLARE @nDisclosureType_Continuous INT = 147002

	DECLARE @nTransStatus_DocumentUploaded INT = 148001,
			@nTransStatus_NotConfirmed INT = 148002

	DECLARE @nSecuritiesPriorToAcquisition DECIMAL(20,0) = NULL
	DECLARE @nSecuritiesPostToAcquisition DECIMAL(20,0) = NULL
	DECLARE @nPerOfSharesPreTransaction DECIMAL(5,2) = NULL
	DECLARE @nPerOfSharesPostTransaction DECIMAL(5,2) = NULL

	BEGIN TRY
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;

		--Initialize variables
		SELECT	@ERR_TRADINGTRANSACTIONDETAILS_NOTFOUND = -1,
				@ERR_TRADINGTRANSACTIONDETAILS_GETDETAILS = -1

		--Check if the RoleMaster whose details are being fetched exists
		IF (NOT EXISTS(SELECT TransactionDetailsId FROM tra_TransactionDetails WHERE TransactionDetailsId = @inp_iTransactionDetailsId	))
		BEGIN
			SET @out_nReturnValue = @ERR_TRADINGTRANSACTIONDETAILS_NOTFOUND
			RETURN (@out_nReturnValue)
		END

		CREATE TABLE #tmpEvaluatePercentagePrePostTransaction 
							(TransactionDetailsId BIGINT NOT NULL, SecuritiesPriorToAcquisition DECIMAL(20,0) NOT NULL,
							PerOfSharesPreTransaction DECIMAL(5,2) NOT NULL, PerOfSharesPostTransaction DECIMAL(5,2) NOT NULL,
							SecuritiesPostToAcquisition DECIMAL(20,0) NOT NULL)

		-- in case of continuous disclosure which is not submitted, get securities prior and post to acquisition and percent of share pre and post transcation
		-- and calculation for pre/post sequrity and precent is auto in trading policy
		SELECT @nTradingPolicy = tm.TradingPolicyId, @nTransactionMasterId = tm.TransactionMasterId
		FROM tra_TransactionDetails td LEFT JOIN tra_TransactionMaster tm ON td.TransactionMasterId = tm.TransactionMasterId
		WHERE td.TransactionDetailsId = @inp_iTransactionDetailsId AND tm.DisclosureTypeCodeId = @nDisclosureType_Continuous 
		AND tm.TransactionStatusCodeId in (@nTransStatus_DocumentUploaded, @nTransStatus_NotConfirmed)

		IF EXISTS (SELECT TradingPolicyId FROM rul_TradingPolicy tp WHERE tp.TradingPolicyId = @nTradingPolicy 
						AND tp.GenSecuritiesPriortoAcquisitionManualInputorAutoCalculate = 0)
		BEGIN

			EXECUTE st_tra_EvaluatePercentagePrePostTransactionSecuritiesPriorToAcquisition 
						@nTransactionMasterId,
						@out_nReturnValue OUTPUT,
						@out_nSQLErrCode OUTPUT,
						@out_sSQLErrMessage OUTPUT

			SELECT 
				@nSecuritiesPriorToAcquisition = tmp.SecuritiesPriorToAcquisition,
				@nSecuritiesPostToAcquisition = tmp.SecuritiesPostToAcquisition,
				@nPerOfSharesPreTransaction = tmp.PerOfSharesPreTransaction,
				@nPerOfSharesPostTransaction = tmp.PerOfSharesPostTransaction
			FROM #tmpEvaluatePercentagePrePostTransaction tmp WHERE tmp.TransactionDetailsId = @inp_iTransactionDetailsId
		END
		
		--Fetch the RoleMaster details
		Select TD.TransactionMasterId
					,TD.SecurityTypeCodeId
					,ForUserInfoId
					,DMATDetailsID
					,CompanyId
					,CASE WHEN @nSecuritiesPriorToAcquisition IS NULL THEN SecuritiesPriorToAcquisition ELSE @nSecuritiesPriorToAcquisition END as 'SecuritiesPriorToAcquisition'
					,CASE WHEN @nPerOfSharesPreTransaction IS NULL THEN PerOfSharesPreTransaction ELSE @nPerOfSharesPreTransaction END as 'PerOfSharesPreTransaction'
					,DateOfAcquisition
					,ISNULL(DateOfInitimationToCompany,dbo.uf_com_GetServerDate()) AS DateOfInitimationToCompany
					,ModeOfAcquisitionCodeId
					,CASE WHEN @nPerOfSharesPostTransaction IS NULL THEN PerOfSharesPostTransaction ELSE @nPerOfSharesPostTransaction END as 'PerOfSharesPostTransaction'
					,ExchangeCodeId
					,TransactionTypeCodeId
					,CASE WHEN (TM.DisclosureTypeCodeId = 147001 AND TD.TransactionTypeCodeId = 143002) THEN Quantity * (-1) ELSE Quantity END AS Quantity
					,Value
					,Quantity2
					,Value2
					,TransactionLetterId
					,LotSize					
					,SegregateESOPAndOtherExcerciseOptionQtyFalg 
					,ESOPExcerciseOptionQty 
					,OtherExcerciseOptionQty 
					,ESOPExcerseOptionQtyFlag 
					,OtherESOPExcerseOptionFlag
					,ContractSpecification
					,TransactionDetailsId
			From tra_TransactionDetails TD
			INNER JOIN tra_TransactionMaster TM ON TM.TransactionMasterId =  TD.TransactionMasterId
			Where TransactionDetailsId = @inp_iTransactionDetailsId	
		

		DROP TABLE #tmpEvaluatePercentagePrePostTransaction

		SET @out_nReturnValue = 0
		RETURN @out_nReturnValue
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()
		
		-- Return common error if required, otherwise specific error.		
		SET @out_nReturnValue  = dbo.uf_com_GetErrorCode(@ERR_TRADINGTRANSACTIONDETAILS_GETDETAILS, ERROR_NUMBER())
		RETURN @out_nReturnValue		
	END CATCH
END

