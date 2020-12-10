/*
	Created By  :	AKHILESH KAMATE
	Created On 	:	29-Mar-2016
	Description :	This stored Procedure is used to get Employee Details based on settings
	
	EXEC st_du_OnGoingContDiscData 0,0,''
*/


IF EXISTS (SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_du_OnGoingContDiscData')
	DROP PROCEDURE st_du_OnGoingContDiscData
GO

CREATE PROCEDURE st_du_OnGoingContDiscData
	@OnGoingContDiscData du_type_OnGoingContDiscData READONLY
AS	
BEGIN
	SET NOCOUNT ON;
		
		DECLARE @PAID_UP_SHARES DECIMAL
		SET @PAID_UP_SHARES = (SELECT TOP 1 PaidUpShare FROM com_CompanyPaidUpAndSubscribedShareCapital ORDER BY CompanyPaidUpAndSubscribedShareCapitalID DESC)
		
		/* Created temp data to get SecurityHeldPriorToAcquisition */
		CREATE TABLE #TEMP_DATA
		(
			EmployeeId VARCHAR(200) , DisclosureTypeCodeId VARCHAR(50), Quantity  DECIMAL(30,2), PAN VARCHAR(15)		
		)
		
		INSERT INTO #TEMP_DATA (EmployeeId, DisclosureTypeCodeId, Quantity, PAN)
		
		SELECT  UF.EmployeeId, TRM.DisclosureTypeCodeId, CASE WHEN (DisclosureTypeCodeId = '147001') THEN AVG(TRD.Quantity) ELSE MAX(TRD.SecuritiesPriorToAcquisition + TRD.Quantity) END AS Quantity, PAN FROM tra_TransactionMaster AS TRM
					INNER JOIN tra_TransactionDetails TRD ON TRD.TransactionMasterId = TRM.TransactionMasterId 
					INNER JOIN usr_UserInfo UF ON UF.UserInfoId = TRM.UserInfoId
					WHERE (TRM.DisclosureTypeCodeId IN (147001, 147002))  AND (TRD.SecurityTypeCodeId = 139001)
					GROUP BY UF.EmployeeId, TRM.DisclosureTypeCodeId, TRD.SecurityTypeCodeId, UF.PAN 
					ORDER BY DisclosureTypeCodeId DESC
		
		
		ALTER TABLE #TEMP_DATA ADD ROWID INT IDENTITY(1,1)
		
		DECLARE @MIN INT, @MAX INT
		
		SELECT @MIN = MIN(ROWID), @MAX = MAX(ROWID) FROM #TEMP_DATA
		
		/* Inserted temp data to get %Share PreTransaction and %Share Post Transaction */
		PRINT @MIN
		PRINT @MAX
		WHILE(@MIN <= @MAX)
		BEGIN
			IF EXISTS ( SELECT EmployeeId FROM #TEMP_DATA WHERE DisclosureTypeCodeId = 147002 AND ROWID = @MIN)
			BEGIN
				DELETE FROM #TEMP_DATA WHERE PAN = (SELECT PAN FROM #TEMP_DATA WHERE DisclosureTypeCodeId = 147002 AND ROWID = @MIN) and DisclosureTypeCodeId = 147001
			END
			SET @MIN = @MIN + 1
		END

		--select * from #TEMP_DATA
		--drop table #TEMP_DATA
		
		/* Prapare records for upload data */
		
		SELECT * INTO #TEMP FROM
		(
			SELECT EMP_NO,TRD_DT, UserInfoId, LoginID, FirstNameLastName, ENTITY_ID, ENT_FULL_NAME, ENTITY_DP_AC_NO,  SMST_ISIN_CODE, SMST_SECURITY_NAME, TRD_SEM_ID, TRD_BUY_SELL_FLG, SUM(TRD_QTY) AS TRD_QTY, SUM(TRD_PRICE) AS TRD_PRICE, SUM(TRD_QTY * TRD_PRICE) AS Value, ModeOfAcquisition, DateOfInitimationToCompany, ExchangeCodeId, SecurityTypeCodeId, Relation, Quantity, DisclosureTypeCodeId, DEMATAccountNo,Category
			FROM
			(
				SELECT 
					EMP_NO, TRD_DT, USI.UserInfoId, USA.LoginID,COM1.CodeName AS Category,(ISNULL(USI.FirstName, '') + ISNULL(USI.LastName, '')) AS FirstNameLastName,
					ENTITY_ID, ENT_FULL_NAME, ENTITY_DP_AC_NO,  SMST_ISIN_CODE, SMST_SECURITY_NAME, TRD_SEM_ID, 
					CASE WHEN TRD_BUY_SELL_FLG = 'B' THEN 'Buy' WHEN TRD_BUY_SELL_FLG = 'S' THEN 'Sell' ELSE 'Buy' END AS TRD_BUY_SELL_FLG, 
					TRD_QTY, TRD_PRICE,
					CASE WHEN TRD_BUY_SELL_FLG = 'B' THEN 'Market Purchase' WHEN TRD_BUY_SELL_FLG = 'S' THEN 'Market Sale' ELSE '' END AS ModeOfAcquisition, CONVERT(DATE,GETDATE()) as DateOfInitimationToCompany, 'National Stock Exchange of India Limited' AS ExchangeCodeId, 'Shares' AS SecurityTypeCodeId,
					(CASE WHEN UR.UserInfoIdRelative != NULL OR UR.UserInfoIdRelative != '' AND ENTITY_DP_AC_NO NOT IN (SELECT DEMATAccountNumber FROM usr_DMATDetails WHERE UserInfoID = USI.UserInfoId)  THEN COM.CodeName ELSE 'Self' END) AS Relation, TD.Quantity , TD.DisclosureTypeCodeId, 
					ENTITY_DP_AC_NO AS DEMATAccountNo
				FROM @OnGoingContDiscData AS OGCD
				LEFT OUTER JOIN #TEMP_DATA AS TD ON OGCD.ENTITY_PAN = TD.PAN
				INNER JOIN usr_UserInfo AS USI ON OGCD.ENTITY_PAN = USI.PAN
				INNER JOIN usr_Authentication AS USA ON USI.UserInfoId = USA.UserInfoID
				LEFT OUTER JOIN usr_UserRelation AS UR ON USI.UserInfoId = UR.UserInfoIdRelative
				LEFT OUTER JOIN usr_DMATDetails AS UD ON USI.UserInfoId = UD.UserInfoID AND UD.DEMATAccountNumber = ENTITY_DP_AC_NO
				LEFT OUTER JOIN com_Code AS COM ON UR.RelationTypeCodeId = COM.CodeID
				LEFT OUTER JOIN com_Code AS COM1 ON USI.Category=COM1.CodeID
			)#TEMP
			GROUP BY
			EMP_NO, TRD_DT, UserInfoId, LoginID, FirstNameLastName, ENTITY_ID, ENT_FULL_NAME, ENTITY_DP_AC_NO, SMST_ISIN_CODE, SMST_SECURITY_NAME, TRD_SEM_ID, TRD_BUY_SELL_FLG, ModeOfAcquisition, DateOfInitimationToCompany, ExchangeCodeId, SecurityTypeCodeId, Relation, Quantity, DisclosureTypeCodeId, DEMATAccountNo,Category
			
		) AS X
		
		SELECT * INTO #T2 FROM
		(
			SELECT EMP_NO, TRD_DT, UserInfoId, LoginID, FirstNameLastName, ENTITY_ID, ENT_FULL_NAME, ENTITY_DP_AC_NO, SMST_ISIN_CODE, SMST_SECURITY_NAME, TRD_SEM_ID, TRD_BUY_SELL_FLG, ModeOfAcquisition, DateOfInitimationToCompany, ExchangeCodeId, SecurityTypeCodeId, Relation, (CASE WHEN DisclosureTypeCodeId = 147001 THEN Quantity ELSE (Quantity) END) AS SecuritiesHeldPriorToAcquisition, TRD_QTY, TRD_PRICE, Value,  DEMATAccountNo,Category
			FROM #TEMP temp
		)AS T2
		
		SELECT EMP_NO AS [Sr No], EMP_NO, TRD_DT, TRD_QTY, TRD_PRICE, UserInfoId, LoginID, FirstNameLastName, ENTITY_ID, ENT_FULL_NAME, ENTITY_DP_AC_NO, SMST_ISIN_CODE, SMST_SECURITY_NAME, TRD_SEM_ID, TRD_BUY_SELL_FLG, ModeOfAcquisition AS ModeOfAcquisitionCodeId, DateOfInitimationToCompany, ExchangeCodeId, SecurityTypeCodeId, Relation, SecuritiesHeldPriorToAcquisition,
			   '0.00' AS PerOfSharesPreTransaction, '0.00' AS PerOfSharesPostTransaction, DEMATAccountNo, Value, '0' AS LotSize,Category as CategoryName
		FROM #T2
		
		DROP TABLE #TEMP_DATA
		
		UPDATE du_MappingTables SET Is_UploadDematFromFile = 1 WHERE DisplayName = 'AXISDIRECTFEED'
		
	SET NOCOUNT OFF;
END