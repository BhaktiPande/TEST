/*
	Created By  :	AKHILESH KAMATE
	Created On 	:	29-Mar-2016
	Description :	This stored Procedure is used to get Employee Details based on settings
	
	EXEC st_du_OnGoingContDiscData_Esop 0,0,''
*/


IF EXISTS (SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_du_OnGoingContDiscData_Esop')
	DROP PROCEDURE st_du_OnGoingContDiscData_Esop
GO

CREATE PROCEDURE st_du_OnGoingContDiscData_Esop
	@OnGoingContDiscData_Esop du_type_OnGoingContDiscData_Esop READONLY
AS	
BEGIN
	SET NOCOUNT ON;	
		SELECT [Employee ID],[Employee Name],[Options Exercised],[Exercise Date],
			[Amount Paid],[Allotment Date],[FMV], [Payment Mode],[Vesting Date],[PAN], CONVERT(VARCHAR(600), [Client ID]) + '|' + ISNULL([Depository ID],'') AS [Client ID]
		INTO #OnGoingContDiscData_Esop FROM @OnGoingContDiscData_Esop
		
		DECLARE @PAID_UP_SHARES DECIMAL
		SET @PAID_UP_SHARES = (SELECT TOP 1 PaidUpShare FROM com_CompanyPaidUpAndSubscribedShareCapital ORDER BY CompanyPaidUpAndSubscribedShareCapitalID DESC)
		
		/* Created temp data to get SecurityHeldPriorToAcquisition */
		CREATE TABLE #TEMP_DATA
		(
			EmployeeId VARCHAR(200) , DisclosureTypeCodeId VARCHAR(50), Quantity  VARCHAR(50), PAN VARCHAR(15)		
		)
		
		INSERT INTO #TEMP_DATA (EmployeeId, DisclosureTypeCodeId, Quantity, PAN)
		
		SELECT  UF.EmployeeId, TRM.DisclosureTypeCodeId, CASE WHEN (DisclosureTypeCodeId = '147001') THEN AVG(TRD.Quantity) ELSE MAX(TRD.SecuritiesPriorToAcquisition + TRD.Quantity) END AS Quantity, PAN FROM tra_TransactionMaster AS TRM
					INNER JOIN tra_TransactionDetails TRD ON TRD.TransactionMasterId = TRM.TransactionMasterId 
					INNER JOIN usr_UserInfo UF ON UF.UserInfoId = TRM.UserInfoId
					WHERE (TRM.DisclosureTypeCodeId IN (147001, 147002))  AND (TRD.SecurityTypeCodeId = 139001)
					GROUP BY UF.EmployeeId, TRM.DisclosureTypeCodeId, TRD.SecurityTypeCodeId, PAN
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
				DELETE FROM #TEMP_DATA WHERE EmployeeId = (SELECT EmployeeId FROM #TEMP_DATA WHERE DisclosureTypeCodeId = 147002 AND ROWID = @MIN) and DisclosureTypeCodeId = 147001
			END
			SET @MIN = @MIN + 1
		END
		
		SELECT * INTO #Temp_OnGngData FROM
		(
			SELECT [Employee ID], FirstNameLastName, LoginID, SUM([Options Exercised]) AS [Options Exercised], [Exercise Date], SUM([Amount Paid]) AS [Amount Paid], [Allotment Date],
				[FMV], [Payment Mode], DEMATAccountNo, TransactionTypeCodeId,ModeOfAcquisitionCodeId, Relation, ExchangeCodeId,SecurityTypeCodeId,SecuritiesHeldPriorToAcquisition,[PAN],[Category]
				FROM
				(
					SELECT [Employee ID], (ISNULL(USI.FirstName, '') + ISNULL(USI.LastName, '')) AS FirstNameLastName, USA.LoginID, [Options Exercised], [Exercise Date],[Amount Paid], [Allotment Date],
						   [FMV], [Payment Mode], CONVERT(VARCHAR(500), [Client ID]) AS DEMATAccountNo,
						   'ESOP' AS TransactionTypeCodeId, 'ESOP' AS ModeOfAcquisitionCodeId,
						    (CASE WHEN UR.UserInfoIdRelative != NULL OR UR.UserInfoIdRelative != '' AND [Client ID] NOT IN (SELECT   CONVERT(VARCHAR(600), DEMATAccountNumber) + '|' + ISNULL(DPID,'') DEMATAccountNumber FROM usr_DMATDetails WHERE UserInfoID = USI.UserInfoId)  THEN COM.CodeName ELSE 'Self' END) AS Relation,
							'National Stock Exchange of India Limited' AS ExchangeCodeId, 'Shares' AS SecurityTypeCodeId,
						   (CASE WHEN DisclosureTypeCodeId = 147001 THEN Quantity ELSE (Quantity) END) AS SecuritiesHeldPriorToAcquisition,OGCD.[PAN],
						   COM1.CodeName AS Category
					FROM #OnGoingContDiscData_Esop OGCD
					LEFT OUTER JOIN #TEMP_DATA AS TD ON CONVERT(VARCHAR(200),OGCD.[PAN]) = TD.PAN
					LEFT OUTER JOIN usr_UserInfo AS USI ON CONVERT(VARCHAR(200),OGCD.[PAN]) = USI.PAN
					LEFT OUTER JOIN usr_Authentication AS USA ON USI.UserInfoId = USA.UserInfoID
					LEFT OUTER JOIN usr_UserRelation AS UR ON USI.UserInfoId = UR.UserInfoIdRelative
					LEFT OUTER JOIN usr_DMATDetails AS UD ON USI.UserInfoId = UD.UserInfoID AND (CONVERT(VARCHAR(600), UD.DEMATAccountNumber) + '|' + ISNULL(UD.DPID,'')) = OGCD.[Client ID]
					LEFT OUTER JOIN com_Code AS COM ON UR.RelationTypeCodeId = COM.CodeID
					LEFT OUTER JOIN com_Code AS COM1 ON USI.Category=COM1.CodeID
					WHERE USA.LoginID IS NOT NULL
				)#TEMP_TABLE
				GROUP BY [Employee ID], FirstNameLastName, LoginID, [Exercise Date],[Allotment Date], DEMATAccountNo,
				[FMV], [Payment Mode], TransactionTypeCodeId, ModeOfAcquisitionCodeId, Relation, ExchangeCodeId, SecurityTypeCodeId, SecuritiesHeldPriorToAcquisition,[PAN],Category
			
		) AS Temp_OnGngData
		
		UPDATE du_MappingTables SET Is_UploadDematFromFile = 1 WHERE DisplayName = 'ESOPDIRECTFEED'

		SELECT ROW_NUMBER() OVER (ORDER BY [Employee ID]) AS [Sr No], [Employee ID], FirstNameLastName, LoginID,  [Options Exercised] AS OptionsExercised, [Exercise Date], [Amount Paid] AS AmountPaid, [Allotment Date] AS DateOfAllotment,
				   [FMV], [Payment Mode],  DEMATAccountNo,
				   TransactionTypeCodeId, ModeOfAcquisitionCodeId, Relation, DEMATAccountNo, ExchangeCodeId, SecurityTypeCodeId,SecuritiesHeldPriorToAcquisition,
				   CONVERT(DECIMAL(18,4),((SecuritiesHeldPriorToAcquisition/@PAID_UP_SHARES)*100)) AS PerOfSharesPreTransaction, CONVERT(DECIMAL(18,4),(((CONVERT(DECIMAL(18,4),SecuritiesHeldPriorToAcquisition) - [Options Exercised])/@PAID_UP_SHARES)*100)) AS PerOfSharesPostTransaction, convert(date, GETDATE()) AS DateOfIntimationToCompany, 0 AS LotSize,Category as CategoryName
				   FROM #Temp_OnGngData				   

	SET NOCOUNT OFF;
END