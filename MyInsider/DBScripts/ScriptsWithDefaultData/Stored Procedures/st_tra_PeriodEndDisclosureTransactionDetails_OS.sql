IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_tra_PeriodEndDisclosureTransactionDetails_OS')
DROP PROCEDURE [dbo].[st_tra_PeriodEndDisclosureTransactionDetails_OS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/******************************************************************************************************************
Description:	Procedure to get transaction details for period end disclosure other securities

Returns:		Return 0, if success.
				
Created by:		Priyanka Bhangale
Created on:		1-Aug-2019
******************************************************************************************************************/

CREATE PROCEDURE [dbo].[st_tra_PeriodEndDisclosureTransactionDetails_OS]
	@inp_iTransactionMasterId INT,
	@inp_iUserInfoId        INT,
	@out_nReturnValue 		INT = 0 OUTPUT,
	@out_nSQLErrCode 		INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage 	VARCHAR(500) = '' OUTPUT  -- Output SQL Error Message, if error occurred.	
	
AS
BEGIN
	DECLARE @ERR_PERIODENDDISCLOSURE_TRANSACTIONDETAILS	INT = 53133 -- Error occurred while fetching list of period end disclosure summary details.
	DECLARE @dtPeriodEndDate DATE
	DECLARE @nDisclosureTypeCodeId INT
	DECLARE @nDisclosureType_PeriodEnd INT = 147003
	DECLARE @nEventCodeID_InitDetailsSubmitted INT = 153052
	DECLARE @nEventCodeID_ContiDetailsSubmitted INT = 153057
	DECLARE @EnableDisableQuantity int; 

	DECLARE @tmpTransactions AS TABLE (TransactionMasterId INT)

	BEGIN TRY
		SET NOCOUNT ON;
		
		-- Declare variables
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''

		SELECT @EnableDisableQuantity = EnableDisableQuantityValue FROM mst_Company where IsImplementing=1
				
		SELECT @dtPeriodEndDate = TM.PeriodEndDate, 
				@nDisclosureTypeCodeId = TM.DisclosureTypeCodeId
			FROM tra_TransactionMaster_OS TM WHERE TransactionMasterId = @inp_iTransactionMasterId

		IF (@nDisclosureTypeCodeId = @nDisclosureType_PeriodEnd)
		BEGIN		
				--Get transaction masterid of user and its relative		
				INSERT INTO @tmpTransactions(TransactionMasterId)
				SELECT DISTINCT TM.TransactionMasterId FROM tra_TransactionMaster_OS TM 
				JOIN eve_EventLog EL ON 
					EL.EventCodeId IN (@nEventCodeID_InitDetailsSubmitted, @nEventCodeID_ContiDetailsSubmitted) 
					AND EL.MapToId = TM.TransactionMasterId
				JOIN tra_TransactionDetails_OS TD on TM.TransactionMasterId=TD.TransactionMasterId 
				WHERE TM.PeriodEndDate <= @dtPeriodEndDate
				AND	TM.UserInfoId = @inp_iUserInfoId

				--Get transaction masterid of User relative who is added after initial disclousre of user is submitted
				INSERT INTO @tmpTransactions(TransactionMasterId)
				SELECT TM.TransactionMasterId FROM tra_TransactionMaster_OS TM 
				JOIN usr_UserRelation UR ON UR.UserInfoIdRelative = TM.UserInfoId 
				JOIN eve_EventLog EL ON 
							EL.EventCodeId IN (@nEventCodeID_InitDetailsSubmitted) 
							AND EL.MapToId = TM.TransactionMasterId
				WHERE UR.UserInfoId = @inp_iUserInfoId
				AND TM.PeriodEndDate <= @dtPeriodEndDate
				
		END
		
		IF(@EnableDisableQuantity <> 400003)
		BEGIN
			SELECT ISNULL(UF.FirstName,'') + ' ' + ISNULL(UF.LastName, '') + ', ' + ISNULL(UF.AddressLine1,'') + ' ' + ISNULL(', ' + UF.PinCode,'') + CASE WHEN ISNULL(CCountry.DisplayCode,'') = '' THEN ISNULL(', ' + CCountry.CodeName,'') ELSE ISNULL(', ' + CCountry.DisplayCode,'') END +  ISNULL(', ' + UF.MobileNumber,'') AS 'Name Of Insider',
			CASE WHEN UR.UserInfoId IS NULL  THEN 'Self' ELSE CRelation.CodeName END AS 'Relation',
			DD.DEMATAccountNumber AS 'Demat Account Number', 
			CSecurityType.CodeName AS 'Security Type', 
			company.CompanyName + ' - ' + company.ISINCode AS 'Security Name',
			CTransactionType.CodeName AS 'Transaction Type',
			CASE WHEN TM.DisclosureTypeCodeId=147001 THEN (select CodeName from com_Code where CodeID=152001) ELSE CModeOfAcq.CodeName END AS 'Mode of Acquisition',
			CExchange.CodeName AS 'Stock Exchange Name',
			CONVERT(VARCHAR(20), TD.DateOfAcquisition, 103) AS 'Date of Transaction',
			CONVERT(VARCHAR(20), TD.DateOfInitimationToCompany, 103) AS 'Date of intimation to Company',
			TD.Quantity AS 'Quantity of Securities',
			TD.Value AS 'Value',
			TD.LotSize AS 'Lot Size',
			TD.ContractSpecification AS 'Contract Specification'
			FROM  @tmpTransactions tTrans 
			JOIN tra_TransactionMaster_OS TM ON tTrans.TransactionMasterId = TM.TransactionMasterId  
			JOIN tra_TransactionDetails_OS TD ON TD.TransactionMasterId = TM.TransactionMasterId  
			JOIN usr_UserInfo UF ON TD.ForUserInfoId = UF.UserInfoId  
			JOIN usr_DMATDetails DD ON TD.DMATDetailsID = DD.DMATDetailsID  
			JOIN com_Code CModeOfAcq ON TD.ModeOfAcquisitionCodeId = CModeOfAcq.CodeID  
			JOIN com_Code CExchange ON TD.ExchangeCodeId = CExchange.CodeID  
			JOIN com_Code CTransactionType ON TD.TransactionTypeCodeId = CTransactionType.CodeID
			JOIN com_Code CSecurityType ON TD.SecurityTypeCodeId = CSecurityType.CodeID 
			JOIN rl_CompanyMasterList company ON TD.CompanyId = company.RlCompanyId 
			LEFT JOIN com_Code CCountry ON UF.CountryId = CCountry.CodeID  
			LEFT JOIN usr_UserRelation UR ON TD.ForUserInfoId = UR.UserInfoIdRelative  
			LEFT JOIN com_Code CRelation ON UR.RelationTypeCodeId = CRelation.CodeID  
			WHERE TD.TransactionDetailsId IS NOT NULL
			ORDER BY TD.SecurityTypeCodeId,TD.TransactionDetailsId
		END
		ELSE
		BEGIN
			SELECT ISNULL(UF.FirstName,'') + ' ' + ISNULL(UF.LastName, '') + ', ' + ISNULL(UF.AddressLine1,'') + ' ' + ISNULL(', ' + UF.PinCode,'') + CASE WHEN ISNULL(CCountry.DisplayCode,'') = '' THEN ISNULL(', ' + CCountry.CodeName,'') ELSE ISNULL(', ' + CCountry.DisplayCode,'') END +  ISNULL(', ' + UF.MobileNumber,'') AS 'Name Of Insider',
			CASE WHEN UR.UserInfoId IS NULL  THEN 'Self' ELSE CRelation.CodeName END AS 'Relation',
			DD.DEMATAccountNumber AS 'Demat Account Number', 
			CSecurityType.CodeName AS 'Security Type', 
			company.CompanyName + ' - ' + company.ISINCode AS 'Security Name',
			CTransactionType.CodeName AS 'Transaction Type',
			CASE WHEN TM.DisclosureTypeCodeId=147001 THEN (select CodeName from com_Code where CodeID=152001) ELSE CModeOfAcq.CodeName END AS 'Mode of Acquisition',
			CExchange.CodeName AS 'Stock Exchange Name',
			CONVERT(VARCHAR(20), TD.DateOfAcquisition, 103) AS 'Date of Transaction',
			CONVERT(VARCHAR(20), TD.DateOfInitimationToCompany, 103) AS 'Date of intimation to Company'
			--TD.Quantity AS 'Quantity of Securities',
			--TD.Value AS 'Value',
			--TD.LotSize AS 'Lot Size',
			--TD.ContractSpecification AS 'Contract Specification'
			FROM  @tmpTransactions tTrans 
			JOIN tra_TransactionMaster_OS TM ON tTrans.TransactionMasterId = TM.TransactionMasterId  
			JOIN tra_TransactionDetails_OS TD ON TD.TransactionMasterId = TM.TransactionMasterId  
			JOIN usr_UserInfo UF ON TD.ForUserInfoId = UF.UserInfoId  
			JOIN usr_DMATDetails DD ON TD.DMATDetailsID = DD.DMATDetailsID  
			JOIN com_Code CModeOfAcq ON TD.ModeOfAcquisitionCodeId = CModeOfAcq.CodeID  
			JOIN com_Code CExchange ON TD.ExchangeCodeId = CExchange.CodeID  
			JOIN com_Code CTransactionType ON TD.TransactionTypeCodeId = CTransactionType.CodeID
			JOIN com_Code CSecurityType ON TD.SecurityTypeCodeId = CSecurityType.CodeID 
			JOIN rl_CompanyMasterList company ON TD.CompanyId = company.RlCompanyId 
			LEFT JOIN com_Code CCountry ON UF.CountryId = CCountry.CodeID  
			LEFT JOIN usr_UserRelation UR ON TD.ForUserInfoId = UR.UserInfoIdRelative  
			LEFT JOIN com_Code CRelation ON UR.RelationTypeCodeId = CRelation.CodeID 
			LEFT JOIN tra_SellAllValues_OS SOS ON SOS.TransactionMasterId = TM.TransactionMasterId
			WHERE TD.TransactionDetailsId IS NOT NULL --AND SOS.SellAllFlag <> 0
			ORDER BY TD.SecurityTypeCodeId,TD.TransactionDetailsId
		END
		RETURN 0
			
	END TRY

	BEGIN CATCH
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue	=  @ERR_PERIODENDDISCLOSURE_TRANSACTIONDETAILS
	END CATCH
END
