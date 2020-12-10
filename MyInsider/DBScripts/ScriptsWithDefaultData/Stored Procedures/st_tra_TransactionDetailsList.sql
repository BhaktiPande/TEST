IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_tra_TransactionDetailsList')
DROP PROCEDURE [dbo].[st_tra_TransactionDetailsList]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Procedure to list transaction data.

Returns:		0, if Success.
				
Created by:		Arundhati
Created on:		08-Apr-2015

Modification History:
Modified By		Modified On		Description
Amar            19-May-2015     Resolved ambiguous column name Security type code.
Amar			22-May-2015		Changed column names to SecuritiesPriorToAcquisition, PerOfSharesPreTransaction 
								and PerOfSharesPostTransaction
Arundahti		12-Jun-2015		Show TransactionTye = <Empty> for Initial disclosure, instead of Buy
Arundahti		17-Jul-2015		Added one more parameter to know if it is for letter
								If it is called for Letter, ignore parameter @inp_nSecurityTypeCodeId
Parag			11-Dec-2015		Made change to show all transcation made in period when transcation type is period end disclosure
Raghvendra		14-Jan-2016		Fix for showing - instead of empty space for the transaction type in case of initial disclosure.
Raghvendra		15-Jan-2016		Fix for showing - instead of empty space for the transaction type in case of initial disclosure.
Raghvendra		15-Jan-2016		Fix for showing - instead of empty space for corporate type insider.
Raghvendra		10-Mar-2016		Change to show the current date as Date of Intimation to company for insider and employee if the 
								transaction is not submitted, else show the date from database.
Raghvendra		1-Apr-2016		Change for Mantis point 8586 for showing the column security type in the grid shown at the bottom of the CreateLetter screen.
Raghvendra		7-Apr-2016		Change to show the company name in the transaction list on create letter page for corporate user.
Raghvendra		14-Apr-2016     Added condition to show the displaycode for the country and if not available then show the Codename, in the address part.
Raghvendra		1-Mar-2016		Fix for transaction details not seen on the Transaction entry screen when transactions entered by Corporate users.
								Added the missing condition for the sorting based on Security type column.
Parag			10-May-2016		made change to show user details save at time of transaction submitted
Parag			05-Aug-2016		Made change to show negative balance. ie when transaction type is sell then quantity is shown in negative
Raghvendra		07-Sep-2016		Changed the GETDATE() call with function dbo.uf_com_GetServerDate(). This function will return the date to be used as server date.
Tushar/RW		05-Oct-2016		Change related to hiding Pre & Post transaction percentage values for non share type securities.
Parag			28-Oct-2016		Made change to show calculated pre/post sequrity and precent for continuous disclosure which are not submitted
Tushar          08-May-2017     Modified to replace actual date of intimation with letter creation date on create letter page.
Usage:
EXEC 
-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_tra_TransactionDetailsList]
	@inp_iPageSize				INT = 10
	,@inp_iPageNo				INT = 1
	,@inp_sSortField			VARCHAR(255)
	,@inp_sSortOrder			VARCHAR(5)
	,@inp_iTransactionMasterId	INT
	,@inp_nSecurityTypeCodeId	INT
	,@inp_iIsForLetter			INT
	,@inp_isFromView			INT=0
	,@inp_nUserInfoId			INT=0
	,@out_nReturnValue			INT = 0 OUTPUT
	,@out_nSQLErrCode			INT = 0 OUTPUT				-- Output SQL Error Number, if error occurred.
	,@out_sSQLErrMessage		VARCHAR(500) = '' OUTPUT  -- Output SQL Error Message, if error occurred.	
AS
BEGIN
	DECLARE @sSQL NVARCHAR(MAX) = ''
	DECLARE @ERR_TRANSACTIONDETAILS_LIST INT = 16016 -- Error occurred while fetching list of transactions.
	
	DECLARE @nDisclosureType_Initial INT = 147001
	DECLARE @nDisclosureType_PeriodEnd INT = 147003
	
	DECLARE @dtPeriodEndDate DATETIME
	DECLARE @nDisclosureTypeCodeId INT
	DECLARE @nUserInfoId INT
	
	DECLARE @nEventCodeID_InitDetailsSubmitted INT = 153007
	DECLARE @nEventCodeID_ContiDetailsSubmitted INT = 153019
	
	DECLARE @nTranStatus_NotConfirm INT = 148002
	DECLARE @nTranStatus_DocUpload INT = 148001
	DECLARE @nTranStatus_Submitted INT = 148007
	DECLARE @nTranStatus_SoftCopySubmit INT = 148004
	DECLARE @nTranStatus_HardCopySubmit INT = 148005
	DECLARE @nTranStatus_StockExSubmit INT = 148006
	DECLARE @nTranStatus_Confirm INT = 148003
	
	DECLARE @SECURITY_TYPE_SHARES INT = 139001
	DECLARE @SECURITY_TYPE_WARRANTS INT = 139002
	DECLARE @SECURITY_TYPE_CONVERTABLEDEBENTURES INT = 139003
	DECLARE @SECURITY_TYPE_FUTURECONTRACTS INT = 139004
	DECLARE @SECURITY_TYPE_OPTIONCONTRACTS INT = 139005
	DECLARE @nUserType_Corporate INT = 101004
	
	DECLARE @TRANSACTION_TYPE_BUY INT = 143001
	DECLARE @TRANSACTION_TYPE_SELL INT = 143002
	
	DECLARE @bShowOriginalUserDetails BIT = 1
	DECLARE @bFormDetailsFlag BIT = 0 -- default flag used to get user details saved for transaction

	CREATE TABLE #tmpTransactions(TransactionMasterId INT)


	DECLARE @nTradingPolicy INT
	DECLARE @nDisclosureType_Continuous INT = 147002


	DECLARE @nSecuritiesPriorToAcquisition DECIMAL(20,0) = NULL
	DECLARE @nSecuritiesPostToAcquisition DECIMAL(20,0) = NULL
	DECLARE @nPerOfSharesPreTransaction DECIMAL(20,2) = NULL
	DECLARE @nPerOfSharesPostTransaction DECIMAL(20,2) = NULL

	DECLARE @nTransactionStatus INT
	DECLARE @inp_dtAuthorizedShareCapitalDate DATETIME  = GETDATE()
	DECLARE @dPaidUpShare DECIMAL(30,0)
	DECLARE @nMultiplier INT  = 100


	BEGIN TRY

	SELECT TOP 1 @dPaidUpShare =  PaidUpShare 
		FROM com_CompanyPaidUpAndSubscribedShareCapital SC
		INNER JOIN mst_Company C ON SC.CompanyID = C.CompanyId
		WHERE C.IsImplementing = 1
		AND PaidUpAndSubscribedShareCapitalDate <= @inp_dtAuthorizedShareCapitalDate
		ORDER BY PaidUpAndSubscribedShareCapitalDate DESC

		
		SET NOCOUNT ON;
		-- Declare variables
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''

		IF @inp_iIsForLetter IS NULL OR @inp_iIsForLetter <> 1
		BEGIN
			-- check disclosure type 
			SELECT @dtPeriodEndDate = TM.PeriodEndDate, 
				@nDisclosureTypeCodeId = TM.DisclosureTypeCodeId,
				@nUserInfoId = TM.UserInfoId
			FROM tra_TransactionMaster TM WHERE TransactionMasterId = @inp_iTransactionMasterId
			
			IF(@inp_isFromView=1)
			BEGIN
			-- in case of period end fetch all transcation sumitted 
			IF (@nDisclosureTypeCodeId = @nDisclosureType_PeriodEnd)
			BEGIN				
				INSERT INTO #tmpTransactions(TransactionMasterId)
				SELECT TM.TransactionMasterId FROM tra_TransactionMaster TM 
				JOIN eve_EventLog EL ON 
					EL.EventCodeId IN (@nEventCodeID_InitDetailsSubmitted, @nEventCodeID_ContiDetailsSubmitted) 
					AND EL.MapToId = TM.TransactionMasterId
				JOIN tra_TransactionDetails TD on TM.TransactionMasterId=TD.TransactionMasterId	
				WHERE TM.PeriodEndDate = @dtPeriodEndDate
					AND TD.ForUserInfoId = @inp_nUserInfoId
					AND TD.SecurityTypeCodeId=@inp_nSecurityTypeCodeId
			END
			END
			
			INSERT INTO #tmpTransactions(TransactionMasterId)
			SELECT @inp_iTransactionMasterId
			
		END
		ELSE
		BEGIN
			INSERT INTO #tmpTransactions
			EXEC st_tra_TransactionIdsForLetter @inp_iTransactionMasterId
			
			SELECT @inp_nSecurityTypeCodeId = NULL
		END
			-- Based on search parameters, insert only the Primary Index Field in the temporary table.
		SELECT @sSQL = @sSQL + 'INSERT INTO #tmpList (RowNumber, EntityID)'


		IF @inp_sSortOrder IS NULL OR @inp_sSortOrder = ''
		BEGIN 
			SELECT @inp_sSortOrder = 'ASC'
		END
		
		IF @inp_sSortField IS NULL OR @inp_sSortField = ''
		BEGIN 
			SELECT @inp_sSortField = 'TD.TransactionDetailsId '
		END 
		
		
		IF @inp_sSortField = 'tra_grd_16001' -- 
		BEGIN 
			SELECT @inp_sSortField = 'UF.FirstName ' + @inp_sSortOrder + ', UF.LastName ' 
		END 
		
		IF @inp_sSortField = 'tra_grd_16002' -- 
		BEGIN 
			SELECT @inp_sSortField = 'UF.PAN ' 
		END 

		IF @inp_sSortField = 'tra_grd_16003' -- 
		BEGIN 
			SELECT @inp_sSortField = 'CASE WHEN TM.UserInfoId = TD.ForUserInfoId THEN ''Self'' ELSE CRelation.CodeName END ' 
		END 

		IF @inp_sSortField = 'tra_grd_16004' -- 
		BEGIN 
			SELECT @inp_sSortField = 'DD.DEMATAccountNumber ' 
		END 

		IF @inp_sSortField = 'tra_grd_16005' -- 
		BEGIN 
			SELECT @inp_sSortField = 'TD.SecuritiesPriorToAcquisition ' 
		END 

		IF @inp_sSortField = 'tra_grd_16006' -- 
		BEGIN 
			SELECT @inp_sSortField = 'TD.PerOfSharesPreTransaction ' 
		END 

		IF @inp_sSortField = 'tra_grd_16007' -- 
		BEGIN 
			SELECT @inp_sSortField = 'TD.DateOfAcquisition ' 
		END 

		IF @inp_sSortField = 'tra_grd_16008' -- 
		BEGIN 
			SELECT @inp_sSortField = 'TD.DateOfInitimationToCompany ' 
		END 

		IF @inp_sSortField = 'tra_grd_16009' -- 
		BEGIN 
			SELECT @inp_sSortField = 'CModeOfAcq.CodeName ' 
		END 

		IF @inp_sSortField = 'tra_grd_16010' -- 
		BEGIN 
			SELECT @inp_sSortField = 'TD.PerOfSharesPostTransaction ' 
		END 

		IF @inp_sSortField = 'tra_grd_16011' -- 
		BEGIN 
			SELECT @inp_sSortField = 'DD.TMID ' 
		END 

		IF @inp_sSortField = 'tra_grd_16012' -- 
		BEGIN 
			SELECT @inp_sSortField = 'CExchange.CodeName ' 
		END 

		IF @inp_sSortField = 'tra_grd_16013' -- 
		BEGIN 
			SELECT @inp_sSortField = 'CTransactionType.CodeName ' 
		END 

		IF @inp_sSortField = 'tra_grd_16014' -- 
		BEGIN 
			SELECT @inp_sSortField = 'TD.Quantity ' 
		END 

		IF @inp_sSortField = 'tra_grd_16015' -- 
		BEGIN 
			SELECT @inp_sSortField = 'TD.Value ' 
		END 
		
		IF @inp_sSortField = 'tra_grd_16429' -- 
		BEGIN 
			SELECT @inp_sSortField = 'TD.SecurityTypeCodeId ' 
		END 

		--print @sSQL
		SELECT @sSQL = @sSQL + ' SELECT DISTINCT DENSE_RANK() OVER(Order BY ' + @inp_sSortField + ' ' + @inp_sSortOrder +',TD.TransactionDetailsId),TD.TransactionDetailsId '
		SELECT @sSQL = @sSQL + ' FROM tra_TransactionDetails TD JOIN tra_TransactionMaster TM ON TD.TransactionMasterId = TM.TransactionMasterId '
		SELECT @sSQL = @sSQL + ' JOIN #tmpTransactions tTrans ON TM.TransactionMasterId = tTrans.TransactionMasterId '
		SELECT @sSQL = @sSQL + ' JOIN usr_UserInfo UF ON TD.ForUserInfoId = UF.UserInfoId '
		SELECT @sSQL = @sSQL + ' JOIN usr_DMATDetails DD ON TD.DMATDetailsID = DD.DMATDetailsID '
		SELECT @sSQL = @sSQL + ' JOIN com_Code CModeOfAcq ON TD.ModeOfAcquisitionCodeId = CModeOfAcq.CodeID '
		SELECT @sSQL = @sSQL + ' JOIN com_Code CExchange ON TD.ExchangeCodeId = CExchange.CodeID '
		SELECT @sSQL = @sSQL + ' JOIN com_Code CTransactionType ON TD.TransactionTypeCodeId = CTransactionType.CodeID '
		SELECT @sSQL = @sSQL + ' LEFT JOIN com_Code CCountry ON UF.CountryId = CCountry.CodeID '
		SELECT @sSQL = @sSQL + ' LEFT JOIN usr_UserRelation UR ON TM.UserInfoId = UR.UserInfoId AND TD.ForUserInfoId = UR.UserInfoIdRelative '
		SELECT @sSQL = @sSQL + ' LEFT JOIN com_Code CRelation ON UR.RelationTypeCodeId = CRelation.CodeID '
		--SELECT @sSQL = @sSQL + ' WHERE TD.TransactionMasterId = ' + CAST(@inp_iTransactionMasterId AS VARCHAR(15))
		SELECT @sSQL = @sSQL + ' WHERE 1 = 1 '
		IF (@inp_nSecurityTypeCodeId IS NOT NULL)
		BEGIN
			SELECT @sSQL = @sSQL + ' AND TD.SecurityTypeCodeId = ' + CAST(@inp_nSecurityTypeCodeId AS VARCHAR(15)) + ' '
		END
		
		PRINT(@sSQL)
		EXEC(@sSQL)

		
		CREATE TABLE #tmpEvaluatePercentagePrePostTransaction 
							(TransactionDetailsId BIGINT NOT NULL, SecuritiesPriorToAcquisition DECIMAL(20,0) NOT NULL,
							PerOfSharesPreTransaction DECIMAL(20,2) NOT NULL, PerOfSharesPostTransaction DECIMAL(20,2) NOT NULL,
							SecuritiesPostToAcquisition DECIMAL(20,0) NOT NULL)

		-- in case of continuous disclosure which is not submitted, get securities prior and post to acquisition and percent of share pre and post transcation
		-- and calculation for pre/post sequrity and precent is auto in trading policy
		SELECT @nTradingPolicy = tm.TradingPolicyId  FROM tra_TransactionMaster tm 
		WHERE tm.TransactionMasterId = @inp_iTransactionMasterId AND tm.DisclosureTypeCodeId = @nDisclosureType_Continuous 
		AND tm.TransactionStatusCodeId in (@nTranStatus_NotConfirm, @nTranStatus_DocUpload)
		
		IF EXISTS (SELECT TradingPolicyId FROM rul_TradingPolicy tp WHERE tp.TradingPolicyId = @nTradingPolicy 
						AND tp.GenSecuritiesPriortoAcquisitionManualInputorAutoCalculate = 0)
		BEGIN
	
			EXECUTE st_tra_EvaluatePercentagePrePostTransactionSecuritiesPriorToAcquisition 
						@inp_iTransactionMasterId,
						@out_nReturnValue OUTPUT,
						@out_nSQLErrCode OUTPUT,
						@out_sSQLErrMessage OUTPUT

			--SELECT 
			--	@nSecuritiesPriorToAcquisition = tmp.SecuritiesPriorToAcquisition,
			--	@nSecuritiesPostToAcquisition = tmp.SecuritiesPostToAcquisition,
			--	@nPerOfSharesPreTransaction = tmp.PerOfSharesPreTransaction,
			--	@nPerOfSharesPostTransaction = tmp.PerOfSharesPostTransaction
			--FROM #tmpEvaluatePercentagePrePostTransaction tmp
		END

		SELECT	TD.TransactionDetailsId,
				CASE WHEN UF.UserTypeCodeId = @nUserType_Corporate THEN ISNULL(CO.CompanyName,' ') ELSE ISNULL(UF.FirstName,'') + ' ' + ISNULL(UF.LastName, '')  END + ', ' + ISNULL(UF.AddressLine1,'') + ' ' + ISNULL(', ' + UF.PinCode,'') + CASE WHEN ISNULL(CCountry.DisplayCode,'') = '' THEN ISNULL(', ' + CCountry.CodeName,'') ELSE ISNULL(', ' + CCountry.DisplayCode,'') END +  ISNULL(', ' + UF.MobileNumber,'') AS tra_grd_16001,
				UF.PAN tra_grd_16002,
				CASE WHEN TM.UserInfoId = TD.ForUserInfoId THEN 'Self' ELSE CRelation.CodeName END AS tra_grd_16003,
				DD.DEMATAccountNumber AS tra_grd_16004,
				CASE 
					WHEN DisclosureTypeCodeId = @nDisclosureType_Initial THEN '-' 
					ELSE 
						CASE 
							WHEN tmp.SecuritiesPriorToAcquisition IS NULL THEN CONVERT(VARCHAR(MAX),TD.SecuritiesPriorToAcquisition)  
							ELSE  CONVERT(VARCHAR(MAX), tmp.SecuritiesPriorToAcquisition) 
						END
				END  AS tra_grd_16005,
				CASE 
					WHEN (TD.SecurityTypeCodeID = @SECURITY_TYPE_FUTURECONTRACTS OR TD.SecurityTypeCodeID = @SECURITY_TYPE_OPTIONCONTRACTS OR TD.SecurityTypeCodeId = @SECURITY_TYPE_WARRANTS OR TD.SecurityTypeCodeId = @SECURITY_TYPE_CONVERTABLEDEBENTURES) THEN '-' 
					ELSE 
						CASE 
							WHEN tmp.PerOfSharesPreTransaction IS NULL THEN CONVERT(VARCHAR(MAX),TD.PerOfSharesPreTransaction)
							ELSE CONVERT(VARCHAR(MAX), tmp.PerOfSharesPreTransaction)
						END
				END  AS tra_grd_16006,
				TD.DateOfAcquisition AS tra_grd_16007,	
			
			 CASE WHEN TD.DateOfInitimationToCompany IS NULL THEN GETDATE()
			 ELSE
			 CASE WHEN @inp_iIsForLetter = 1 THEN GETDATE()		  			     
				ELSE
			           TD.DateOfInitimationToCompany 	
			    END         		       				       		  
			 END AS tra_grd_16008,		
				
				CModeOfAcq.CodeName AS tra_grd_16009,
				CASE 
					WHEN (TD.SecurityTypeCodeID = @SECURITY_TYPE_FUTURECONTRACTS OR TD.SecurityTypeCodeID = @SECURITY_TYPE_OPTIONCONTRACTS OR TD.SecurityTypeCodeId = @SECURITY_TYPE_WARRANTS OR TD.SecurityTypeCodeId = @SECURITY_TYPE_CONVERTABLEDEBENTURES) THEN '-' 
					ELSE 
						CASE 
							WHEN  tmp.PerOfSharesPostTransaction IS NULL THEN CONVERT(VARCHAR(MAX),TD.PerOfSharesPostTransaction)  
							ELSE CONVERT(VARCHAR(MAX),tmp.PerOfSharesPostTransaction) 
						END

				END AS tra_grd_16010,
				DD.TMID AS tra_grd_16011,
				CExchange.CodeName AS tra_grd_16012,
				CASE WHEN DisclosureTypeCodeId = @nDisclosureType_Initial THEN '-' ELSE CTransactionType.CodeName END AS tra_grd_16013,
				TD.Quantity AS tra_grd_16014,
				TD.Value AS tra_grd_16015,
				TM.TransactionMasterId,
				TM.DisclosureTypeCodeId,
				TM.TransactionStatusCodeId,
				CSecurityType.CodeName AS tra_grd_16429,
				CASE 
					WHEN @nDisclosureTypeCodeId = @nDisclosureType_PeriodEnd THEN -- current disclosure is period end
						CASE 
							WHEN TM.DisclosureTypeCodeId = @nDisclosureType_PeriodEnd THEN -- details is for period end records
								CASE 
									WHEN TM.TransactionStatusCodeId IN (@nTranStatus_NotConfirm, @nTranStatus_DocUpload) THEN 2 
								ELSE 1 END
							ELSE 0 END -- details is for intial, continuous records
					ELSE -- current disclsosure is intital or continuous
						CASE 
							WHEN TM.TransactionStatusCodeId IN (@nTranStatus_NotConfirm, @nTranStatus_DocUpload) THEN 2 
							ELSE 1 END
					END as IsAllowEdit -- 0: do not show any link, 1: show view link, 2: show edit link
		FROM	#tmpList T INNER JOIN tra_TransactionDetails TD ON T.EntityID = TD.TransactionDetailsId
				LEFT JOIN #tmpEvaluatePercentagePrePostTransaction tmp ON TD.TransactionDetailsId=tmp.TransactionDetailsId
				JOIN tra_TransactionMaster TM ON TD.TransactionMasterId = TM.TransactionMasterId
				JOIN usr_UserInfo UF ON TD.ForUserInfoId = UF.UserInfoId
				JOIN usr_DMATDetails DD ON TD.DMATDetailsID = DD.DMATDetailsID
				JOIN com_Code CModeOfAcq ON TD.ModeOfAcquisitionCodeId = CModeOfAcq.CodeID
				JOIN com_Code CExchange ON TD.ExchangeCodeId = CExchange.CodeID
				JOIN com_Code CTransactionType ON TD.TransactionTypeCodeId = CTransactionType.CodeID
				JOIN com_Code CSecurityType ON TD.SecurityTypeCodeId = CSecurityType.CodeID
				LEFT JOIN com_Code CCountry ON UF.CountryId = CCountry.CodeID
				LEFT JOIN usr_UserRelation UR ON TM.UserInfoId = UR.UserInfoId AND TD.ForUserInfoId = UR.UserInfoIdRelative
				LEFT JOIN com_Code CRelation ON UR.RelationTypeCodeId = CRelation.CodeID
				LEFT JOIN mst_Company CO ON CO.CompanyId = UF.CompanyId
		WHERE	TD.TransactionDetailsId IS NOT NULL AND ((@inp_iPageSize = 0) OR (T.RowNumber BETWEEN ((@inp_iPageNo - 1) * @inp_iPageSize + 1) AND (@inp_iPageNo * @inp_iPageSize)))
		ORDER BY TD.SecurityTypeCodeId,TD.TransactionDetailsId, TD.SecuritiesPriorToAcquisition,T.RowNumber

		RETURN 0
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue	=  @ERR_TRANSACTIONDETAILS_LIST
	END CATCH
END

