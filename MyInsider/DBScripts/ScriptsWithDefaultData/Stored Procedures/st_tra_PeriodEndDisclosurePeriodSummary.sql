IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_tra_PeriodEndDisclosurePeriodSummary')
DROP PROCEDURE [dbo].[st_tra_PeriodEndDisclosurePeriodSummary]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/******************************************************************************************************************
Description:	Procedure to get summary details for period end disclosure 

Returns:		Return 0, if success.
				
Created by:		Parag
Created on:		06-May-2015

Modification History:
Modified By		Modified On		Description
Parag			19-May-2015		Made change to check user type and for corporate user show company name as insider name
Parag			26-Oct-2015		Made change to fetch correct summary after making change to store summary for all period type
Parag			11-Jan-2016		Made change to fix issue of next period summay is not shown properly ie opening and closing balance 
									if no transcation is done previous period 

******************************************************************************************************************

Usage:

******************************************************************************************************************/

CREATE PROCEDURE [dbo].[st_tra_PeriodEndDisclosurePeriodSummary]
	@inp_iUserInfoId 	 	INT,
	@inp_iYearCodeId 		INT,
	@inp_iPeriodCodeID 		INT,
	@out_nReturnValue 		INT = 0 OUTPUT,
	@out_nSQLErrCode 		INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage 	VARCHAR(500) = '' OUTPUT  -- Output SQL Error Message, if error occurred.	
	
AS
BEGIN
	DECLARE @ERR_PERIODENDDISCLOSURE_SUMMARYDETAILS	INT = 17041 -- Error occurred while fetching list of period end disclosure summary details.
	DECLARE @sCompany NVARCHAR(200)
	DECLARE @nSecurityType INT
	DECLARE @nPeriodType INT

	BEGIN TRY
		SET NOCOUNT ON;
		
		-- Declare variables
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''
		
		SELECT @sCompany = CompanyName FROM mst_Company WHERE IsImplementing = 1
		SELECT TOP(1) @nSecurityType = CodeId FROM com_Code WHERE CodeGroupId = 139 ORDER BY CodeID ASC
		
		SELECT @nPeriodType = ParentCodeId FROM com_Code WHERE CodeID = @inp_iPeriodCodeID
		
		-- Define temporary table and add user details for summary 
		CREATE TABLE #tmpPeriodEndDisclosureSummary (Id INT IDENTITY(1,1), CompanyName NVARCHAR(200) DEFAULT '',
			UserId INT, Name NVARCHAR(500), UserRelativeCode INT, Relation VARCHAR(500), SecurityTypeCode INT, SecurityType VARCHAR(500), 
			OpeningStock INT, Bought INT, Sold INT, PeriodEndHolding INT)
		
		
		-- Insert user details for each security type
		INSERT INTO #tmpPeriodEndDisclosureSummary (UserId, Name, UserRelativeCode, Relation, SecurityTypeCode, SecurityType)
		SELECT 
			UI.UserInfoId as UserId,
			CASE WHEN UI.UserTypeCodeId = 101004 THEN Com.CompanyName ELSE UI.FirstName + ISNULL(' ' + UI.LastName, '') END as Name, 
			NULL as UserRelativeCode, 
			CASE WHEN UI.UserTypeCodeId = 101004 THEN NULL ELSE 'Self' END as Relation, 
			CDSecurity.CodeID as SecurityTypeCode, 
			CASE WHEN CDSecurity.DisplayCode IS NULL OR CDSecurity.DisplayCode = '' THEN CDSecurity.CodeName ELSE CDSecurity.DisplayCode END as SecurityType
		FROM 
			usr_UserInfo UI 
			RIGHT OUTER JOIN com_Code CDSecurity on CDSecurity.CodeGroupId=139
			LEFT JOIN mst_Company Com ON UI.CompanyId = Com.CompanyId
		WHERE
			UI.UserInfoId = @inp_iUserInfoId 
			
		-- Insert user's all relative details for each security type
		INSERT INTO #tmpPeriodEndDisclosureSummary (UserId, Name, UserRelativeCode, Relation, SecurityTypeCode, SecurityType)
		SELECT 
			UI.UserInfoId as UserId, UI.FirstName + ISNULL(' ' + UI.LastName, '') as Name, CDURelation.CodeID as UserRelativeCode, 
			CDURelation.CodeName as Relation, CDSecurity.CodeID as SecurityTypeCode, 
			CASE WHEN CDSecurity.DisplayCode IS NULL OR CDSecurity.DisplayCode = '' THEN CDSecurity.CodeName ELSE CDSecurity.DisplayCode END as SecurityType
		FROM 
			usr_UserInfo UI JOIN usr_UserRelation UR ON UI.UserInfoId = UR.UserInfoIdRelative
			LEFT JOIN com_Code CDURelation ON UR.RelationTypeCodeId = CDURelation.CodeID
			RIGHT OUTER JOIN com_Code CDSecurity on CDSecurity.CodeGroupId=139
		WHERE
			UR.UserInfoId = @inp_iUserInfoId 
		
		--update temp table with transcation summary details
		UPDATE #tmpPeriodEndDisclosureSummary SET 
			OpeningStock = TranSummary.OpeningBalance, 
			Bought = TranSummary.BuyQuantity, 
			Sold = TranSummary.SellQuantity,
			PeriodEndHolding = TranSummary.ClosingBalance
		FROM 
			#tmpPeriodEndDisclosureSummary tmpSummary INNER JOIN tra_TransactionSummary TranSummary ON 
			tmpSummary.UserId = TranSummary.UserInfoIdRelative AND 
			tmpSummary.SecurityTypeCode = TranSummary.SecurityTypeCodeId AND
			TranSummary.YearCodeId = @inp_iYearCodeId AND
			TranSummary.PeriodCodeId = @inp_iPeriodCodeID

		-- made change to show last period closing balance as this period opening balance
		UPDATE  TmpTS
		SET 
			OpeningStock =CASE WHEN(YearCodeId = @inp_iYearCodeId AND PeriodCodeId=@inp_iPeriodCodeID)THEN TranSummary.OpeningBalance ELSE ISNULL(TranSummary.ClosingBalance, 0)END,
			Bought = CASE WHEN (YearCodeId = @inp_iYearCodeId AND PeriodCodeId=@inp_iPeriodCodeID) THEN TranSummary.BuyQuantity ELSE 0 END,
			Sold = CASE WHEN (YearCodeId = @inp_iYearCodeId AND PeriodCodeId=@inp_iPeriodCodeID) THEN TranSummarY.SellQuantity ELSE 0 END,
			PeriodEndHolding = ISNULL(TranSummary.ClosingBalance, 0)
		FROM #tmpPeriodEndDisclosureSummary TmpTS
		LEFT JOIN 
		(SELECT t.UserId, t.SecurityTypeCode, OpeningBalance, BuyQuantity, SellQuantity, ClosingBalance,YearCodeId,PeriodCodeId
			 FROM tra_TransactionSummary TS JOIN
			(
				SELECT t.UserId, t.SecurityTypeCode, MAX(TS.TransactionSummaryId)TransactionSummaryId
				FROM #tmpPeriodEndDisclosureSummary t LEFT JOIN tra_TransactionSummary TS 
					ON TS.UserInfoIdRelative = t.UserId AND t.SecurityTypeCode = TS.SecurityTypeCodeId 
						AND ((TS.YearCodeId = @inp_iYearCodeId AND PeriodCodeId<@inp_iPeriodCodeID
										AND PeriodCodeId in (SELECT CodeID FROM com_Code WHERE CodeGroupId = 124 AND ParentCodeId = @nPeriodType))
							OR(TS.YearCodeId < @inp_iYearCodeId AND PeriodCodeId in (SELECT CodeID FROM com_Code WHERE CodeGroupId = 124 AND ParentCodeId = @nPeriodType)))
				WHERE t.OpeningStock IS NULL
				GROUP BY t.UserId, t.SecurityTypeCode
			) t ON t.TransactionSummaryId = TS.TransactionSummaryId
		) TranSummary ON TmpTS.UserId = TranSummary.UserId AND TmpTS.SecurityTypeCode = TranSummary.SecurityTypeCode
		WHERE TmpTS.OpeningStock IS NULL

		INSERT INTO #tmpList(RowNumber, EntityID)
		SELECT Id, Id FROM #tmpPeriodEndDisclosureSummary
		
		
		/***************** Update Company Name for the first row only *****************************************/
		UPDATE #tmpPeriodEndDisclosureSummary
		SET CompanyName = @sCompany
		WHERE Id = 1
		/***************** Make the columns UserName, Relation Name blank for the repeat rows *****************/
		UPDATE #tmpPeriodEndDisclosureSummary
		SET Name = '',
			Relation = ''
		WHERE SecurityTypeCode <> @nSecurityType
		
		
		SELECT 
			CompanyName AS dis_grd_17033,
			T.Name AS dis_grd_17034,
			T.Relation AS dis_grd_17035,
			T.SecurityType AS dis_grd_17036,
			T.OpeningStock AS dis_grd_17037,
			T.Bought AS dis_grd_17038,
			T.Sold AS dis_grd_17039,
			T.PeriodEndHolding AS dis_grd_17040,
			T.SecurityTypeCode,
			T.UserId,
			T.UserRelativeCode
		FROM #tmpPeriodEndDisclosureSummary T
		
		
		-- Delete temporary table
		DROP TABLE #tmpPeriodEndDisclosureSummary
			
		RETURN 0
			
	END TRY

	BEGIN CATCH
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue	=  @ERR_PERIODENDDISCLOSURE_SUMMARYDETAILS
	END CATCH
END
