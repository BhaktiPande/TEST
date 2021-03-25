IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_tra_PeriodEndDisclosurePeriodSummaryComapnyWise_OS')
DROP PROCEDURE [dbo].[st_tra_PeriodEndDisclosurePeriodSummaryComapnyWise_OS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/******************************************************************************************************************
Description:	Procedure to get summary details for period end disclosure other securities by dmat and company id

Returns:		Return 0, if success.
				
Created by:		Priyanka Bhangale
Created on:		31-July-2019
******************************************************************************************************************/

CREATE PROCEDURE [dbo].[st_tra_PeriodEndDisclosurePeriodSummaryComapnyWise_OS]
	@inp_iUserInfoId 	 	INT,
	@inp_iYearCodeId 		INT,
	@inp_iPeriodCodeID 		INT,
	@inp_iReportType        INT,
	@out_nReturnValue 		INT = 0 OUTPUT,
	@out_nSQLErrCode 		INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage 	VARCHAR(500) = '' OUTPUT  -- Output SQL Error Message, if error occurred.	
	
AS
BEGIN
	DECLARE @ERR_PERIODENDDISCLOSURE_SUMMARYDETAILS	INT = 53132 -- Error occurred while fetching list of period end disclosure summary details.
	DECLARE @nPeriodType INT
	DECLARE @dtStartDate datetime  
    DECLARE @dtEndDate datetime
	DECLARE @EnableDisableQuantity int; 

	BEGIN TRY
		SET NOCOUNT ON;
		
		-- Declare variables
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''
			SET @inp_iPeriodCodeID=124001
				
		SELECT @nPeriodType = ParentCodeId FROM com_Code WHERE CodeID = @inp_iPeriodCodeID
		SELECT @EnableDisableQuantity = EnableDisableQuantityValue FROM mst_Company where IsImplementing=1

		EXECUTE st_tra_PeriodEndDisclosureStartEndDate2  
            @inp_iYearCodeId OUTPUT, @inp_iPeriodCodeID OUTPUT,null,123004, 0,   
            @dtStartDate OUTPUT, @dtEndDate OUTPUT,   
            @out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT, @out_sSQLErrMessage OUTPUT
		
		-- Define temporary table and add user details for summary 
		DECLARE @tmpPeriodEndDisclosureSummary AS TABLE (Id INT IDENTITY(1,1), UserId INT, Name VARCHAR(500), UserRelativeCode INT, Relation VARCHAR(500), 
		SecurityTypeCode INT, SecurityType VARCHAR(500), DmatNo INT,DematAccountNo nvarchar(50), CompanyID int, CompanyName NVARCHAR(200) DEFAULT '',
			OpeningStock INT, Bought INT, Sold INT, PeriodEndHolding INT)
		
		-- Insert user details for each security type
		INSERT INTO @tmpPeriodEndDisclosureSummary (UserId, Name, UserRelativeCode, Relation, DmatNo, DematAccountNo, CompanyID, CompanyName,SecurityTypeCode, SecurityType)
		SELECT 
			UI.UserInfoId as UserId,
			UI.FirstName + ISNULL(' ' + UI.LastName, '') as Name, 
			NULL as UserRelativeCode, 
			'Self' as Relation,
			UD.DMATDetailsID AS DmatNo,UD.DEMATAccountNumber AS DematAccountNo,
			tranSummery.CompanyId,Company.CompanyName + ' - '+Company.ISINCode,
			CDSecurity.CodeID as SecurityTypeCode,
			CASE WHEN CDSecurity.DisplayCode IS NULL OR CDSecurity.DisplayCode = '' THEN CDSecurity.CodeName ELSE CDSecurity.DisplayCode END as SecurityType
		FROM 
			usr_UserInfo UI 
			JOIN tra_TransactionSummaryDMATWise_OS tranSummery ON tranSummery.UserInfoIdRelative = UI.UserInfoId AND tranSummery.YearCodeId=@inp_iYearCodeId AND tranSummery.PeriodCodeId=124001
			JOIN rl_CompanyMasterList Company ON Company.RlCompanyId = tranSummery.CompanyId
			JOIN usr_DMATDetails UD ON UD.DMATDetailsID = tranSummery.DMATDetailsID
			JOIN com_Code CDSecurity ON CDSecurity.CodeID = tranSummery.SecurityTypeCodeId
		WHERE UI.UserInfoId = @inp_iUserInfoId 
		ORDER BY SecurityTypeCode
			
		-- Insert user's all relative details for each security type
		INSERT INTO @tmpPeriodEndDisclosureSummary (UserId, Name, UserRelativeCode, Relation, DmatNo, DematAccountNo, CompanyID, CompanyName,SecurityTypeCode, SecurityType)
		SELECT 
			UI.UserInfoId as UserId, UI.FirstName + ISNULL(' ' + UI.LastName, '') as Name, CDURelation.CodeID as UserRelativeCode, 
			CDURelation.CodeName as Relation, 
			UD.DMATDetailsID AS DmatNo,UD.DEMATAccountNumber AS DematAccountNo,
			tranSummery.CompanyId,Company.CompanyName + ' - '+Company.ISINCode,
			CDSecurity.CodeID as SecurityTypeCode, 
			CASE WHEN CDSecurity.DisplayCode IS NULL OR CDSecurity.DisplayCode = '' THEN CDSecurity.CodeName ELSE CDSecurity.DisplayCode END as SecurityType
		FROM 
			usr_UserInfo UI JOIN usr_UserRelation UR ON UI.UserInfoId = UR.UserInfoIdRelative 
			LEFT JOIN com_Code CDURelation ON UR.RelationTypeCodeId = CDURelation.CodeID
			JOIN tra_TransactionSummaryDMATWise_OS tranSummery ON tranSummery.UserInfoIdRelative = UI.UserInfoId AND tranSummery.YearCodeId=@inp_iYearCodeId AND tranSummery.PeriodCodeId= 124001
			JOIN rl_CompanyMasterList Company ON Company.RlCompanyId = tranSummery.CompanyId
			JOIN usr_DMATDetails UD ON UD.DMATDetailsID = tranSummery.DMATDetailsID
			JOIN com_Code CDSecurity ON CDSecurity.CodeID = tranSummery.SecurityTypeCodeId
		WHERE UR.UserInfoId = @inp_iUserInfoId and UR.UserInfoIdRelative NOT IN(SELECT UserInfoId FROM usr_UserInfo U where  U.UserInfoId = UR.UserInfoIdRelative AND CreatedOn > @dtEndDate) 
		ORDER BY UserId, SecurityTypeCode
		
		--update temp table with transcation summary details
		UPDATE @tmpPeriodEndDisclosureSummary SET 
			OpeningStock = TranSummary.OpeningBalance, 
			Bought = TranSummary.BuyQuantity, 
			Sold = TranSummary.SellQuantity,
			PeriodEndHolding = TranSummary.ClosingBalance
		FROM 
			@tmpPeriodEndDisclosureSummary tmpSummary INNER JOIN tra_TransactionSummaryDMATWise_OS TranSummary ON 
			tmpSummary.UserId = TranSummary.UserInfoIdRelative AND 
			tmpSummary.SecurityTypeCode = TranSummary.SecurityTypeCodeId AND
			tmpSummary.CompanyID = TranSummary.CompanyId AND
			tmpSummary.DmatNo=TranSummary.DMATDetailsID AND
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

		--select * from @tmpPeriodEndDisclosureSummary
		--RETURN
		IF @inp_iReportType = 1
		BEGIN	
			IF(@EnableDisableQuantity <> 400003)
			BEGIN
				SELECT 
					T.Name AS 'Name of Insider',
					T.Relation AS 'Relation',
					T.SecurityType AS 'SecurityType',
					T.DematAccountNo AS 'Demat Account Number',
					T.CompanyName AS 'Company',
					--T.OpeningStock AS 'Holdings at the beginning of the period',
					T.Bought AS 'Initial Disclosure or Bought during the period',
					T.Sold AS 'Sold during the period',
					T.PeriodEndHolding AS 'Holdings at the end of the period'
				FROM @tmpPeriodEndDisclosureSummary T
			END
			ELSE
			BEGIN
				SELECT 
					T.Name AS 'Name of Insider',
					T.Relation AS 'Relation',
					T.SecurityType AS 'SecurityType',
					T.DematAccountNo AS 'Demat Account Number',
					T.CompanyName AS 'Company'
				FROM @tmpPeriodEndDisclosureSummary T 
				JOIN tra_BalancePool_OS BOS on --PE.UserId = BOS.UserInfoId and
				 T.DmatNo = BOS.DMATDetailsID AND T.CompanyID = BOS.CompanyID
				 WHERE BOS.ActualQuantity <> 0 AND T.PeriodEndHolding <> 0

				--SELECT 
				--	T.Name AS 'Name of Insider',
				--	T.Relation AS 'Relation',
				--	T.SecurityType AS 'SecurityType',
				--	T.DematAccountNo AS 'Demat Account Number',
				--	T.CompanyName AS 'Company'
				--	--T.Bought AS 'Initial Disclosure or Bought during the period',
				--	--T.Sold AS 'Sold during the period',
				--	--T.PeriodEndHolding AS 'Holdings at the end of the period'
				--FROM @tmpPeriodEndDisclosureSummary T --Where T.PeriodEndHolding <> 0
			END
		END
		ELSE IF(@inp_iReportType = 2)
		BEGIN
			IF(@EnableDisableQuantity <> 400003)
			BEGIN
				SELECT COUNT(T.DmatNo) AS [count],T.Name,T.Relation,T.SecurityType,T.DematAccountNo, 
				SUM(T.OpeningStock),
				SUM(T.Bought),SUM(T.Sold),SUM(T.PeriodEndHolding)
				FROM @tmpPeriodEndDisclosureSummary T
				GROUP BY T.Name,T.Relation,T.SecurityType,T.DematAccountNo
			END
			ELSE
			BEGIN
				SELECT COUNT(T.DmatNo) AS [count],T.Name,T.Relation,T.SecurityType,T.DematAccountNo
				FROM @tmpPeriodEndDisclosureSummary T JOIN tra_BalancePool_OS BOS on --PE.UserId = BOS.UserInfoId and
				 T.DmatNo = BOS.DMATDetailsID AND T.CompanyID = BOS.CompanyID
				 WHERE BOS.ActualQuantity <> 0 
				GROUP BY T.Name,T.Relation,T.SecurityType,T.DematAccountNo

				--SELECT COUNT(T.DmatNo) AS [count],T.Name,T.Relation,T.SecurityType,T.DematAccountNo
				--FROM @tmpPeriodEndDisclosureSummary T
				--GROUP BY T.Name,T.Relation,T.SecurityType,T.DematAccountNo
			END
		END
		ELSE
		BEGIN		
			IF(@EnableDisableQuantity <> 400003)
			BEGIN
				SELECT  COUNT(T.DmatNo) AS [count],T.Name,T.Relation,T.SecurityType, 
				SUM(T.OpeningStock),
				SUM(T.Bought),SUM(T.Sold),SUM(T.PeriodEndHolding)
				FROM @tmpPeriodEndDisclosureSummary T
				GROUP BY T.Name,T.Relation,T.SecurityType
			END
			ELSE
			BEGIN
				 SELECT  COUNT(T.DmatNo) AS [count],T.Name,T.Relation,T.SecurityType
				FROM @tmpPeriodEndDisclosureSummary T JOIn tra_BalancePool_OS BOS on --PE.UserId = BOS.UserInfoId and
				 T.DmatNo = BOS.DMATDetailsID AND T.CompanyID = BOS.CompanyID
				 WHERE BOS.ActualQuantity <> 0
				GROUP BY T.Name,T.Relation,T.SecurityType
				
				--SELECT  COUNT(T.DmatNo) AS [count],T.Name,T.Relation,T.SecurityType
				--FROM @tmpPeriodEndDisclosureSummary T
				--GROUP BY T.Name,T.Relation,T.SecurityType
			END
		END
		RETURN 0
			
	END TRY

	BEGIN CATCH
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue	=  @ERR_PERIODENDDISCLOSURE_SUMMARYDETAILS
	END CATCH
END
