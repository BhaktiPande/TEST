IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_tra_TransactionDetailsListRelative_OS')
DROP PROCEDURE [dbo].[st_tra_TransactionDetailsListRelative_OS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Procedure to list transaction data of self.

Returns:		0, if Success.
				
Created by:		Priyanka
Created on:		16-Mar-2019
-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_tra_TransactionDetailsListRelative_OS]
	@inp_iPageSize				INT = 10
	,@inp_iPageNo				INT = 1
	,@inp_sSortField			VARCHAR(255)
	,@inp_sSortOrder			VARCHAR(5)
	,@inp_iTransactionMasterId	INT
	,@inp_nSecurityTypeCodeId	INT
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

	DECLARE @nTradingPolicy INT
	DECLARE @nDisclosureType_Continuous INT = 147002

	BEGIN TRY
		
		SET NOCOUNT ON;
		-- Declare variables
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''

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
		
		--print @sSQL
		SELECT @sSQL = @sSQL + ' SELECT DISTINCT DENSE_RANK() OVER(Order BY ' + @inp_sSortField + ' ' + @inp_sSortOrder +',TD.TransactionDetailsId),TD.TransactionDetailsId '
		SELECT @sSQL = @sSQL + ' FROM tra_TransactionDetails_OS TD JOIN tra_TransactionMaster_OS TM ON TD.TransactionMasterId = TM.TransactionMasterId '
		SELECT @sSQL = @sSQL + ' JOIN usr_UserInfo UF ON TD.ForUserInfoId = UF.UserInfoId '
		SELECT @sSQL = @sSQL + ' JOIN usr_DMATDetails DD ON TD.DMATDetailsID = DD.DMATDetailsID '
		SELECT @sSQL = @sSQL + ' JOIN com_Code CModeOfAcq ON TD.ModeOfAcquisitionCodeId = CModeOfAcq.CodeID '
		SELECT @sSQL = @sSQL + ' JOIN com_Code CExchange ON TD.ExchangeCodeId = CExchange.CodeID '
		SELECT @sSQL = @sSQL + ' JOIN com_Code CTransactionType ON TD.TransactionTypeCodeId = CTransactionType.CodeID '
		SELECT @sSQL = @sSQL + ' LEFT JOIN com_Code CCountry ON UF.CountryId = CCountry.CodeID '
		SELECT @sSQL = @sSQL + ' LEFT JOIN usr_UserRelation UR ON TM.UserInfoId = UR.UserInfoId AND TD.ForUserInfoId = UR.UserInfoIdRelative '
		SELECT @sSQL = @sSQL + ' LEFT JOIN com_Code CRelation ON UR.RelationTypeCodeId = CRelation.CodeID '
		SELECT @sSQL = @sSQL + ' WHERE 1 = 1 '
		SELECT @sSQL = @sSQL + ' AND UF.UserTypeCodeId=101007 AND TD.TransactionMasterId = ' + CAST(@inp_iTransactionMasterId AS VARCHAR(15))+' '
		IF (@inp_nSecurityTypeCodeId IS NOT NULL)
		BEGIN
			SELECT @sSQL = @sSQL + ' AND TD.SecurityTypeCodeId = ' + CAST(@inp_nSecurityTypeCodeId AS VARCHAR(15)) + ' '
		END
		
		PRINT(@sSQL)
		EXEC(@sSQL)

		-- in case of continuous disclosure which is not submitted, get securities prior and post to acquisition and percent of share pre and post transcation
		-- and calculation for pre/post sequrity and precent is auto in trading policy
		SELECT @nTradingPolicy = tm.TradingPolicyId  FROM tra_TransactionMaster_OS tm 
		WHERE tm.TransactionMasterId = @inp_iTransactionMasterId AND tm.DisclosureTypeCodeId = @nDisclosureType_Continuous 
		AND tm.TransactionStatusCodeId in (@nTranStatus_NotConfirm, @nTranStatus_DocUpload)
		
		SELECT	TD.TransactionDetailsId,
				CASE WHEN UF.UserTypeCodeId = @nUserType_Corporate THEN ISNULL(CO.CompanyName,' ') ELSE ISNULL(UF.FirstName,'') + ' ' + ISNULL(UF.LastName, '')  END + ', ' + ISNULL(UF.AddressLine1,'') + ' ' + ISNULL(', ' + UF.PinCode,'') + CASE WHEN ISNULL(CCountry.DisplayCode,'') = '' THEN ISNULL(', ' + CCountry.CodeName,'') ELSE ISNULL(', ' + CCountry.DisplayCode,'') END +  ISNULL(', ' + UF.MobileNumber,'') AS tra_grd_53073,
				UF.PAN tra_grd_53074,
				CASE WHEN TM.UserInfoId = TD.ForUserInfoId THEN 'Self' ELSE CRelation.CodeName END AS tra_grd_53075,
				DD.DEMATAccountNumber AS tra_grd_53076,
				comp.CompanyName AS tra_grd_53077,
				TD.CompanyID AS CompanyID,
				TD.DateOfAcquisition AS tra_grd_53080,	
				CASE WHEN TD.DateOfInitimationToCompany IS NULL THEN GETDATE() ELSE TD.DateOfInitimationToCompany END AS tra_grd_53081,	
				CModeOfAcq.CodeName AS tra_grd_53082,
				CExchange.CodeName AS tra_grd_53083,
				CASE WHEN DisclosureTypeCodeId = @nDisclosureType_Initial THEN '-' ELSE CTransactionType.CodeName END AS tra_grd_53084,
				CSecurityType.CodeName AS tra_grd_53090,
				TD.Quantity AS tra_grd_53085,
				TD.Value AS tra_grd_53086,
				TD.LotSize AS tra_grd_53087,
				TD.ContractSpecification AS tra_grd_53088,
				TM.TransactionMasterId,
				TM.DisclosureTypeCodeId,
				TM.TransactionStatusCodeId,
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
					END as IsAllowEdit, -- 0: do not show any link, 1: show view link, 2: show edit link
				UF.UserTypeCodeId AS UserType,
				UF.UserInfoId AS UserInfoId,
				TM.UserInfoId AS ParentUserInfoId
		FROM	#tmpList T INNER JOIN tra_TransactionDetails_OS TD ON T.EntityID = TD.TransactionDetailsId
				JOIN tra_TransactionMaster_OS TM ON TD.TransactionMasterId = TM.TransactionMasterId
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
				LEFT JOIN rl_CompanyMasterList comp ON comp.RlCompanyId = TD.CompanyId
		WHERE	TD.TransactionDetailsId IS NOT NULL AND ((@inp_iPageSize = 0) OR (T.RowNumber BETWEEN ((@inp_iPageNo - 1) * @inp_iPageSize + 1) AND (@inp_iPageNo * @inp_iPageSize)))
		ORDER BY TD.SecurityTypeCodeId,TD.TransactionDetailsId,T.RowNumber

		RETURN 0
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue	=  @ERR_TRANSACTIONDETAILS_LIST
	END CATCH
END

