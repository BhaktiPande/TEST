IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_tra_PeriodEndDisclosureTransactionDetailsFormG_OS')
DROP PROCEDURE [dbo].[st_tra_PeriodEndDisclosureTransactionDetailsFormG_OS]
GO
/*-------------------------------------------------------------------------------------------------
Description:	Procedure to list for Period End Disclosure form G transaction details for other security

Returns:		0, if Success.
				
Created by:		Priyanka Bhangale
Created on:		08-Aug-2019

Usage:
EXEC st_tra_PeriodEndDisclosureTransactionDetailsFormG_OS 446,125006,124002
-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_tra_PeriodEndDisclosureTransactionDetailsFormG_OS]
	@inp_iUserInfoId 	 	    NVARCHAR(1000)
	,@inp_iYearCodeId 		    NVARCHAR(1000)
	,@inp_iPeriodCodeID 		NVARCHAR(1000)
	,@out_nReturnValue			INT = 0 OUTPUT
	,@out_nSQLErrCode			INT = 0 OUTPUT				-- Output SQL Error Number, if error occurred.
	,@out_sSQLErrMessage		VARCHAR(500) = '' OUTPUT  -- Output SQL Error Message, if error occurred.	
AS
BEGIN
	DECLARE @ERR_PeriodEndFormGGeneration INT = 53134

	DECLARE @nPeriodType INT
	DECLARE @CountryCodeGroupID INT = 107

	BEGIN TRY
		SET NOCOUNT ON;
		
	-- Declare variables
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''

		SELECT @nPeriodType = ParentCodeId FROM com_Code WHERE CodeID = @inp_iPeriodCodeID
		
		-- Define temporary table and add user details for summary 
		DECLARE @tmpPeriodEndDisclosureSummary AS TABLE(Id INT IDENTITY(1,1),UserId INT, Name NVARCHAR(500), PAN NVARCHAR(50), CIN NVARCHAR(50), DIN NVARCHAR(50), Address NVARCHAR(500), Pincode NVARCHAR(50), Country NVARCHAR(20),
		MobileNo NVARCHAR(50),EmployeeID NVARCHAR(50), Department NVARCHAR(100), Designation NVARCHAR(100), Relation VARCHAR(500),DmatNo INT,DematAccountNo nvarchar(50), DP_ID VARCHAR(50), CompanyID INT, CompanyName NVARCHAR(200),
		SecurityTypeCode INT, SecurityType VARCHAR(500), OpeningStock varchar(max), Bought INT, Sold INT,
		PeriodEndHolding varchar(max),TotalPledge INT,Pledge INT,Unpledge INT)
		
		-- Insert User details for each security type
		INSERT INTO @tmpPeriodEndDisclosureSummary (UserId, Name, PAN, CIN, DIN, Address,Pincode, Country, MobileNo, EmployeeID, 
		Department, Designation, Relation, DmatNo, DematAccountNo, DP_ID, CompanyID, CompanyName,  SecurityTypeCode, SecurityType)
		SELECT UI.UserInfoId as UserId, 
		ISNULL(UI.FirstName+' ',' ') + ISNULL(UI.MiddleName+ ' ',' ') + ISNULL(UI.LastName,' ') AS Name,
		UI.PAN AS PAN,
		UI.CIN AS CIN,
		UI.DIN AS DIN,
		UI.AddressLine1 AS Address,
		UI.PinCode AS Pincode, 
		CASE WHEN ISNULL(CCountry.DisplayCode,'') = '' THEN CCountry.CodeName ELSE CCountry.DisplayCode END AS Country, 
		UI.MobileNumber as MobileNo,
		UI.EmployeeId AS EmployeeID,
		CDeprt.CodeName AS Department,
		CDesign.CodeName AS Designation,
		CASE WHEN UI.SubCategory IS NOT NULL THEN (SELECT code.CodeName FROM com_Code code WHERE CodeID=UI.SubCategory)ELSE '' END as Relation,
		D.DMATDetailsID AS DmatNo,
		D.DEMATAccountNumber AS DematAccountNo,
		D.DPID AS DP_ID,
		tranSummery.CompanyId AS CompanyID,
		company.CompanyName AS CompanyName,
		tranSummery.SecurityTypeCodeId AS SecurityTypeCode,
		CASE WHEN CDSecurity.DisplayCode IS NULL OR CDSecurity.DisplayCode = '' THEN CDSecurity.CodeName ELSE CDSecurity.DisplayCode END as SecurityType
		FROM usr_UserInfo UI
		JOIN tra_TransactionSummaryDMATWise_OS tranSummery ON tranSummery.UserInfoIdRelative = UI.UserInfoId AND tranSummery.YearCodeId=@inp_iYearCodeId AND tranSummery.PeriodCodeId=124001
		LEFT JOIN usr_DMATDetails D ON D.DMATDetailsID = tranSummery.DMATDetailsID
		LEFT JOIN rl_CompanyMasterList company ON company.RlCompanyId = tranSummery.CompanyId
		LEFT JOIN com_Code CCountry ON CCountry.CodeGroupId = UI.CountryId AND CCountry.CodeGroupId = @CountryCodeGroupID
		JOIN com_Code CDSecurity ON CDSecurity.CodeID=tranSummery.SecurityTypeCodeId
		JOIN com_Code CDeprt ON CDeprt.CodeID = UI.DepartmentId
		JOIN com_Code CDesign ON CDesign.CodeID = UI.DesignationId
		WHERE UI.UserInfoId = @inp_iUserInfoId
		
		-- Insert user's all relative details for each security type
		INSERT INTO @tmpPeriodEndDisclosureSummary (UserId, Name, PAN, CIN, DIN, Address, Pincode, Country, MobileNo, EmployeeID, 
		Department, Designation, Relation, DmatNo, DematAccountNo, DP_ID, CompanyID, CompanyName, SecurityTypeCode, SecurityType)
		SELECT UI.UserInfoId as UserId, 
		ISNULL(UI.FirstName+' ',' ') + ISNULL(UI.MiddleName+ ' ',' ') + ISNULL(UI.LastName,' ') AS Name,
		UI.PAN AS PAN,
		UI.CIN AS CIN,
		UI.DIN AS DIN,
		UI.AddressLine1 AS Address,
		UI.PinCode AS Pincode, 
		CASE WHEN ISNULL(CCountry.DisplayCode,'') = '' THEN CCountry.CodeName ELSE CCountry.DisplayCode END AS Country, 
		UI.MobileNumber as MobileNo,
		UI.EmployeeId AS EmployeeID,
		UI.DepartmentId AS Department,
		UI.DesignationId AS Designation,
		'Immediate Relative' AS Relation,
		D.DMATDetailsID AS DmatNo,
		D.DEMATAccountNumber AS DematAccountNo,
		D.DPID AS DP_ID,
		tranSummery.CompanyId AS CompanyID,
		company.CompanyName AS CompanyName,
		tranSummery.SecurityTypeCodeId AS SecurityTypeCode,
		CASE WHEN CDSecurity.DisplayCode IS NULL OR CDSecurity.DisplayCode = '' THEN CDSecurity.CodeName ELSE CDSecurity.DisplayCode END as SecurityType
		FROM usr_UserInfo UI 
		JOIN usr_UserRelation UR ON UI.UserInfoId = UR.UserInfoIdRelative
		JOIN tra_TransactionSummaryDMATWise_OS tranSummery ON tranSummery.UserInfoIdRelative = UI.UserInfoId AND tranSummery.YearCodeId=@inp_iYearCodeId AND tranSummery.PeriodCodeId=124001
		LEFT JOIN usr_DMATDetails D ON D.DMATDetailsID = tranSummery.DMATDetailsID
		LEFT JOIN rl_CompanyMasterList company ON company.RlCompanyId = tranSummery.CompanyId
		JOIN com_Code CDSecurity on CDSecurity.CodeID=tranSummery.SecurityTypeCodeId
		LEFT JOIN com_Code CCountry ON CCountry.CodeGroupId = UI.CountryId and CCountry.CodeGroupId = @CountryCodeGroupID
		WHERE UR.UserInfoId = @inp_iUserInfoId
		
		--update temp table with transcation summary details
		UPDATE @tmpPeriodEndDisclosureSummary SET 
			OpeningStock = TranSummary.OpeningBalance, 
			Bought = TranSummary.BuyQuantity, 
			Sold = TranSummary.SellQuantity,
			PeriodEndHolding = TranSummary.ClosingBalance,
			TotalPledge = TranSummary.PledgeBuyQuantity,
			Pledge = TranSummary.PledgeClosingBalance,
			UnPledge = TranSummary.PledgeSellQuantity
		FROM 
			@tmpPeriodEndDisclosureSummary tmpSummary 
			INNER JOIN tra_TransactionSummaryDMATWise_OS TranSummary ON 
			tmpSummary.UserId = TranSummary.UserInfoIdRelative AND 
			tmpSummary.SecurityTypeCode = TranSummary.SecurityTypeCodeId AND
			tmpSummary.CompanyID = TranSummary.CompanyId AND
			TranSummary.YearCodeId = @inp_iYearCodeId AND
			TranSummary.PeriodCodeId = @inp_iPeriodCodeID

		-- made change to show last period closing balance as this period opening balance
		UPDATE  TmpTS
		SET 
			OpeningStock =CASE WHEN(YearCodeId = @inp_iYearCodeId AND PeriodCodeId=@inp_iPeriodCodeID)THEN TranSummary.OpeningBalance ELSE ISNULL(TranSummary.ClosingBalance, 0)END,
			Bought = CASE WHEN (YearCodeId = @inp_iYearCodeId AND PeriodCodeId=@inp_iPeriodCodeID) THEN TranSummary.BuyQuantity ELSE 0 END,
			Sold = CASE WHEN (YearCodeId = @inp_iYearCodeId AND PeriodCodeId=@inp_iPeriodCodeID) THEN TranSummarY.SellQuantity ELSE 0 END,
			PeriodEndHolding = ISNULL(TranSummary.ClosingBalance, 0)
		FROM @tmpPeriodEndDisclosureSummary TmpTS
		LEFT JOIN 
		(SELECT t.UserId, t.SecurityTypeCode, t.CompanyID, OpeningBalance, BuyQuantity, SellQuantity, ClosingBalance,YearCodeId,PeriodCodeId
			 FROM tra_TransactionSummaryDMATWise_OS TS JOIN
			(
				SELECT t.UserId, t.SecurityTypeCode, t.CompanyID, MAX(TS.TransactionSummaryDMATWiseId)TransactionSummaryId
				FROM @tmpPeriodEndDisclosureSummary t LEFT JOIN tra_TransactionSummaryDMATWise_OS TS 
					ON TS.UserInfoIdRelative = t.UserId AND t.SecurityTypeCode = TS.SecurityTypeCodeId AND t.CompanyID = TS.CompanyId
						AND ((TS.YearCodeId = @inp_iYearCodeId AND PeriodCodeId<@inp_iPeriodCodeID
										AND PeriodCodeId in (SELECT CodeID FROM com_Code WHERE CodeGroupId = 124 AND ParentCodeId = @nPeriodType))
							OR(TS.YearCodeId < @inp_iYearCodeId AND PeriodCodeId in (SELECT CodeID FROM com_Code WHERE CodeGroupId = 124 AND ParentCodeId = @nPeriodType)))
				WHERE t.OpeningStock IS NULL
				GROUP BY t.UserId, t.SecurityTypeCode, t.CompanyID
			) t ON t.TransactionSummaryId = TS.TransactionSummaryDMATWiseId
		) TranSummary ON TmpTS.UserId = TranSummary.UserId AND TmpTS.SecurityTypeCode = TranSummary.SecurityTypeCode AND TmpTS.CompanyID = TranSummary.CompanyID
		WHERE TmpTS.OpeningStock IS NULL

		SELECT UserId, [Name], PAN, CIN, DIN, [Address], Pincode, Country, MobileNo, EmployeeID, Department, Designation,
		Relation, DematAccountNo,DP_ID, CompanyName, SecurityType, OpeningStock, Bought, Sold, PeriodEndHolding,TotalPledge, Pledge, UnPledge 
		FROM @tmpPeriodEndDisclosureSummary

	END TRY
	BEGIN CATCH
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue	=  @ERR_PeriodEndFormGGeneration
	END CATCH
END