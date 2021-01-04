IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_rpt_PeriodEndEmployeeIndividualDetails')
DROP PROCEDURE [dbo].[st_rpt_PeriodEndEmployeeIndividualDetails]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
Description:	Procedure to List data for ID employee individual

Returns:		0, if Success.
				
Created by:		Arundhati
Created on:		09-Jun-2015

Modification History:
Modified By		Modified On		Description
Arundhati		01-Jul-2015		For Cahsless transactions Value is always considered as Value1 + Value2.
Arundhati		10-Jul-2015		Previous holding is initialised to 0 if record not found. Also parameter order for SecurityType and DMAT are swapped, since 
Arundhati		13-Jul-2015		Should show blank against transaction details in column for Prevois and Current period holding value
								Scrip Name & ISIN should be shown in the row of Previous holding
								Add row for Total
Raghvendra		29-Oct-2015		Change to call the date formatting using a DB scalar function
Parag			02-Nov-2015		Made change to user TP from UserPeriodEndMapping table which applicable for that period 
Raghvendra		6-Nov-2015		Changes for showing NA for the fields specified in excel sheet provided by ED team in Mantis bug no 7889
Parag			01-Dec-2015		Made change to handle condition when period end disclosure is not applicable for user
Parag			06-Dec-2015		Made change to fix issue of records not shown for period end disclosure
Parag			22-Jan-2016		Made change to use function for getting calender date or trading date as per configuration
Parag			05-Feb-2016		Made change to fix issue of wrong opening balance is shown in report

Usage:
EXEC 
-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_rpt_PeriodEndEmployeeIndividualDetails]
	@inp_iPageSize				INT = 10
	,@inp_iPageNo				INT = 1
	,@inp_sSortField			VARCHAR(255)
	,@inp_sSortOrder			VARCHAR(5)
	,@inp_iOutputSeq			INT -- 1: User details, 2: Transaction status details, 3: Transaction Details
	,@inp_iYearCodeId			INT
	,@inp_iPeriodCodeId			INT
	,@inp_iUserInfoId			INT
	,@inp_iUserInfoIdRelative	INT -- Null should be considered as  @inp_iUserInfoId
	,@inp_iSecurityTypeCodeId	INT
	,@inp_iDMATDetailsId		INT
	,@out_nReturnValue			INT = 0 OUTPUT
	,@out_nSQLErrCode			INT = 0 OUTPUT				-- Output SQL Error Number, if error occurred.
	,@out_sSQLErrMessage		VARCHAR(500) = '' OUTPUT  -- Output SQL Error Message, if error occurred.	
---------------------------------------------------------------------------
AS
BEGIN
	DECLARE @ERR_IDEMPLOYEEINDIV INT = -1

	DECLARE @sSQL NVARCHAR(MAX)
	DECLARE @dtImplementation DATETIME = '2015-01-01'

	DECLARE @nTransactionMasterId INT = 0
	DECLARE @iCommentId INT = 162003
	DECLARE @sComment VARCHAR(100)
	DECLARE @iCommentsId_Ok INT = 162001
	DECLARE @iCommentsId_NotSubmittedInTime INT = 162002
	DECLARE @iCommentsId_NotSubmitted INT = 162003

	DECLARE @sEmployeeID NVARCHAR(50)
	DECLARE @sInsiderName NVARCHAR(100)
	DECLARE @sDesignation NVARCHAR(100)
	DECLARE @sCINDIN NVARCHAR(100)
	DECLARE @sGrade NVARCHAR(100)
	DECLARE @sLocation NVARCHAR(100)
	DECLARE @sDepartment NVARCHAR(100)
	DECLARE @sCompanyName NVARCHAR(100)
	DECLARE @sTypeOfInsider NVARCHAR(100)
	
	DECLARE @dtDateOfBecomingInsider DATETIME
	DECLARE @dtDetailsSubmitLastDate DATETIME
	DECLARE @dtScpSubmitDate DATETIME
	DECLARE @dtHcpSubmitDate DATETIME
	DECLARE @sStatusOfSubmission VARCHAR(100)

	DECLARE @nDataType_String INT = 1
	DECLARE @nDataType_Int INT = 2
	DECLARE @nDataType_Date INT = 3

	DECLARE @RC INT
	DECLARE @dtPEStart DATETIME
	DECLARE @dtPEEnd DATETIME
	
	DECLARE @nPreviousPeriodHolding INT
	DECLARE @nCurrentPeriodHolding INT
	DECLARE @nCurrency NVARCHAR(50)
	
	DECLARE @nPreviousPeriodValue DECIMAL(25,4)
	DECLARE @nCurrentPeriodValue DECIMAL(25,4)
	
	DECLARE @sScriptName NVARCHAR(100)
	DECLARE @sISIN VARCHAR(100)
	DECLARE @sPreviousHolding VARCHAR(100) -- 'rpt_lbl_19236', 'Previous Holdings'
	DECLARE @sCurrentHolding VARCHAR(100) -- 'rpt_lbl_19237', 'Current Holdings'
	
	DECLARE @nTransactionType_Buy INT = 143001
	DECLARE @nTransactionType_Sell INT = 143002
	DECLARE @nTransactionType_CashExercise INT = 143003
	DECLARE @nTransactionType_CashlessAll INT = 143004
	DECLARE @nTransactionType_CashlessPartial INT = 143005
	
	DECLARE @tmpUserDetails TABLE(Id INT IDENTITY(1,1), RKey VARCHAR(20), Value NVARCHAR(max), DataType INT)
	DECLARE @tmpUserTable TABLE(Id INT IDENTITY(1,1), UserInfoId INT, UserInfoIdRelative INT, SecurityTypeCodeId INT, DMATDetailsID INT, Relation VARCHAR(100), Holdings Decimal(20), Value Decimal(25,4))
	DECLARE @tmpFinal TABLE(Id INT IDENTITY(1,1), ScriptName NVARCHAR(200), ISIN VARCHAR(100), SecurityType VARCHAR(100), TransactionType VARCHAR(100),
							PreviousHoldings INT, BuyQuantity INT, SellQuantity INT, Value DECIMAL(25,4), DateOfAcquisition DATETIME, Currency NVARCHAR(50) )
	
	DECLARE @nPeriodTypeCodeId INT
	
	DECLARE @nExchangeTypeCodeId_NSE INT = 116001
	
	BEGIN TRY
		
		SET NOCOUNT ON;
		-- Declare variables
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''

		print 'st_rpt_PeriodEndEmployeeIndividualDetails'
		
		SELECT @nPeriodTypeCodeId = ParentCodeId FROM com_Code where CodeID = @inp_iPeriodCodeId
		
		-- Find out Period Start and End date for the selected year / period code id
		EXECUTE @RC = [st_tra_PeriodEndDisclosureStartEndDate2] 
		   @inp_iYearCodeId OUTPUT
		  ,@inp_iPeriodCodeId OUTPUT
		  ,null
		  ,@nPeriodTypeCodeId
		  ,0
		  ,@dtPEStart OUTPUT
		  ,@dtPEEnd OUTPUT
		  ,@out_nReturnValue OUTPUT
		  ,@out_nSQLErrCode OUTPUT
		  ,@out_sSQLErrMessage OUTPUT
		
		SELECT @sPreviousHolding = ResourceValue FROM mst_Resource where ResourceKey = 'rpt_lbl_19236'
		SELECT @sCurrentHolding = ResourceValue FROM mst_Resource where ResourceKey = 'rpt_lbl_19237'
		/*
		IF @inp_sSortField IS NULL OR @inp_sSortField = ''
		BEGIN
			SET @inp_sSortField = ''
		END
		
		IF @inp_sSortOrder IS NULL OR @inp_sSortOrder = ''
		BEGIN
			SET @inp_sSortOrder = 'ASC'
		END
		*/
		
		IF EXISTS(SELECT CodeName FROM com_Code WHERE CodeId = 128003)
		BEGIN
			SELECT @dtImplementation = CodeName FROM com_Code WHERE CodeId = 128003
		END

		SELECT @sScriptName = CompanyName, @sISIN = ISINNumber FROM mst_Company WHERE IsImplementing = 1
		
		IF @inp_iOutputSeq = 1
		BEGIN
		
			-- Output #1 : USer details
			SELECT @sEmployeeID = EmployeeId, 
					@sInsiderName = CASE WHEN UserTypeCodeId = 101004 THEN C.CompanyName ELSE ISNULL(FirstName, '') + ' ' + ISNULL(LastName, '') END,
					@sDesignation = CASE WHEN UserTypeCodeId = 101003 THEN CDesignation.CodeName ELSE DesignationText END,
					@sGrade = CASE WHEN UserTypeCodeId = 101003 THEN CGrade.CodeName ELSE GradeText END,
					@sLocation = UF.Location,
					@sDepartment = CASE WHEN UserTypeCodeId = 101003 THEN CDepartment.CodeName ELSE DepartmentText END,
					@sCompanyName = C.CompanyName,
					@sTypeOfInsider = CUserType.CodeName,
					@sCINDIN = CASE WHEN UserTypeCodeId = 101004 THEN CIN ELSE DIN END
			FROM usr_UserInfo UF JOIN mst_Company C ON UF.CompanyId = C.CompanyId
			JOIN com_Code CUserType ON UF.UserTypeCodeId = CUserType.CodeID
			LEFT JOIN com_Code CDesignation ON UF.DesignationId = CDesignation.CodeID 
			LEFT JOIN com_Code CGrade ON UF.GradeId = CGrade.CodeID
			LEFT JOIN com_Code CDepartment ON UF.DepartmentId = CDepartment.CodeID
			WHERE UserInfoId = @inp_iUserInfoId
			
			INSERT INTO @tmpUserDetails(RKey, Value, DataType)
			VALUES ('rpt_lbl_19135', @sEmployeeID, @nDataType_String),
				('rpt_lbl_19136',  CONVERT(NVARCHAR(max), @sInsiderName) , @nDataType_String),
				('rpt_lbl_19137', dbo.uf_rpt_ReplaceSpecialChar(dbo.uf_rpt_FormatValue(CONVERT(VARCHAR(max), @sDesignation),1)), @nDataType_String),
				('rpt_lbl_19147', ISNULL(@sCINDIN, ''), @nDataType_String),
				('rpt_lbl_19138', dbo.uf_rpt_ReplaceSpecialChar(dbo.uf_rpt_FormatValue(CONVERT(VARCHAR(max), @sGrade),1)), @nDataType_String),
				('rpt_lbl_19139', dbo.uf_rpt_ReplaceSpecialChar(dbo.uf_rpt_FormatValue(CONVERT(VARCHAR(max), @sLocation),1)), @nDataType_String),
				('rpt_lbl_19140', dbo.uf_rpt_ReplaceSpecialChar(dbo.uf_rpt_FormatValue(CONVERT(VARCHAR(max), @sDepartment),1)), @nDataType_String),
				('rpt_lbl_19141', @sCompanyName, @nDataType_String),
				('rpt_lbl_19142', @sTypeOfInsider, @nDataType_String)
				
			INSERT INTO #tmpList(RowNumber, EntityID)
			VALUES (1,1)
				
			SELECT * FROM @tmpUserDetails ORDER BY ID
		END
		ELSE
		BEGIN
		
			SELECT @nTransactionMasterId = TransactionMasterId
			FROM vw_PeriodEndDisclosureStatus
			WHERE UserInfoId = @inp_iUserInfoId
				AND PeriodEndDate = @dtPEEnd

			SELECT @iCommentId = CASE WHEN vwPE.DetailsSubmitDate IS NULL THEN @iCommentsId_NotSubmitted
									WHEN vwPE.DetailsSubmitDate < CONVERT(date, dbo.uf_tra_GetNextTradingDateOrNoOfDays(@dtPEEnd, DiscloPeriodEndToCOByInsdrLimit, NULL, 0, 1, 0, @nExchangeTypeCodeId_NSE)) THEN @iCommentsId_Ok --DATEADD(D, DiscloPeriodEndToCOByInsdrLimit, @dtPEEnd)
									ELSE @iCommentsId_NotSubmittedInTime 
								 END,
					@dtDetailsSubmitLastDate = CONVERT(date, dbo.uf_tra_GetNextTradingDateOrNoOfDays(@dtPEEnd, DiscloPeriodEndToCOByInsdrLimit, NULL, 0, 1, 0, @nExchangeTypeCodeId_NSE)) -- DATEADD(D, DiscloPeriodEndToCOByInsdrLimit, @dtPEEnd)
			FROM usr_UserInfo UF JOIN vw_PeriodEndDisclosureStatus vwPE ON UF.UserInfoId = vwPE.UserInfoId
			JOIN tra_TransactionMaster TM ON TM.TransactionMasterId = vwPE.TransactionMasterId
			JOIN tra_UserPeriodEndMapping UPEMap ON UPEMap.PEEndDate IS NOT NULL AND UPEMap.PEEndDate = TM.PeriodEndDate AND UPEMap.UserInfoId = TM.UserInfoId
			JOIN rul_TradingPolicy TP ON UPEMap.TradingPolicyId = TP.TradingPolicyId
			WHERE UF.UserInfoId = @inp_iUserInfoId
			
			SELECT @sComment = R.resourcevalue
			FROM com_Code C JOIN mst_Resource R ON C.CodeName = R.ResourceKey
			WHERE C.CodeID = @iCommentId

			IF @dtDetailsSubmitLastDate IS NULL
			BEGIN
				SELECT @dtDetailsSubmitLastDate = CONVERT(date, dbo.uf_tra_GetNextTradingDateOrNoOfDays(@dtPEEnd, DiscloPeriodEndToCOByInsdrLimit, NULL, 0, 1, 0, @nExchangeTypeCodeId_NSE)) -- DATEADD(D, DiscloPeriodEndToCOByInsdrLimit, @dtPEEnd)
				FROM usr_UserInfo UF JOIN vw_ApplicableTradingPolicyForUser AppTP ON UF.UserInfoId = AppTP.UserInfoId
					JOIN rul_TradingPolicy TP ON TP.TradingPolicyId = AppTP.MapToId
				WHERE UF.UserInfoId = @inp_iUserInfoId
			END
			
			IF @inp_iOutputSeq = 2 
			BEGIN
				-- Output #2 : Transaction status details

				SELECT @dtDateOfBecomingInsider = UF.DateOfBecomingInsider,
					@dtScpSubmitDate = vwPE.ScpSubmitDate, @dtHcpSubmitDate = vwPE.HcpSubmitDate, @sStatusOfSubmission = @sComment
				FROM usr_UserInfo UF LEFT JOIN vw_PeriodEndDisclosureStatus vwPE ON UF.UserInfoId = vwPE.UserInfoId
				WHERE UF.UserInfoId = @inp_iUserInfoId
				
				INSERT INTO @tmpUserDetails(RKey, Value, DataType)
				VALUES ('rpt_lbl_19148', dbo.uf_rpt_FormatDateValue(@dtPEStart,0), @nDataType_String),
						('rpt_lbl_19160', dbo.uf_rpt_FormatDateValue(@dtPEEnd,0), @nDataType_String),
						('rpt_lbl_19149', dbo.uf_rpt_FormatDateValue(@dtScpSubmitDate,0), @nDataType_String),
						('rpt_lbl_19150', dbo.uf_rpt_FormatDateValue(@dtHcpSubmitDate,0), @nDataType_String),
						('rpt_lbl_19151', @sStatusOfSubmission, @nDataType_String),
						('rpt_lbl_19152', dbo.uf_rpt_FormatDateValue(@dtDetailsSubmitLastDate,0), @nDataType_String)

				INSERT INTO #tmpList(RowNumber, EntityID)
				VALUES (1,1)

				SELECT * FROM @tmpUserDetails ORDER BY ID
			END
			ELSE IF @inp_iOutputSeq = 3
			BEGIN
				SELECT top(1) @nPreviousPeriodHolding = ClosingBalance, @nPreviousPeriodValue = Value
				FROM tra_TransactionSummaryDMATWise
				WHERE UserInfoId = @inp_iUserInfoId
					AND UserInfoIdRelative = ISNULL(@inp_iUserInfoIdRelative, @inp_iUserInfoId)
					AND SecurityTypeCodeId = @inp_iSecurityTypeCodeId
					AND DMATDetailsID = @inp_iDMATDetailsId
					AND ((YearCodeId = @inp_iYearCodeId AND PeriodCodeId < @inp_iPeriodCodeId
									AND PeriodCodeId in (SELECT CodeID FROM com_Code WHERE CodeGroupId = 124 AND ParentCodeId = @nPeriodTypeCodeId))
							OR (YearCodeId < @inp_iYearCodeId))
				ORDER BY TransactionSummaryDMATWiseId DESC

				IF @nPreviousPeriodHolding IS NULL
				BEGIN
					SELECT @nPreviousPeriodHolding = 0, @nPreviousPeriodValue = 0
				END
				
				SELECT top(1) @nCurrentPeriodHolding = ClosingBalance, @nCurrentPeriodValue = Value, @nCurrency=currency.DisplayCode
				FROM tra_TransactionSummaryDMATWise
					LEFT JOIN com_Code currency ON currency.CodeID = CurrencyID
				WHERE UserInfoId = @inp_iUserInfoId
					AND UserInfoIdRelative = ISNULL(@inp_iUserInfoIdRelative, @inp_iUserInfoId)
					AND SecurityTypeCodeId = @inp_iSecurityTypeCodeId
					AND DMATDetailsID = @inp_iDMATDetailsId
					AND ((YearCodeId = @inp_iYearCodeId AND PeriodCodeId <= @inp_iPeriodCodeId
									AND PeriodCodeId in (SELECT CodeID FROM com_Code WHERE CodeGroupId = 124 AND ParentCodeId = @nPeriodTypeCodeId))
							OR (YearCodeId < @inp_iYearCodeId))
				ORDER BY TransactionSummaryDMATWiseId DESC

				IF @nCurrentPeriodHolding IS NULL
				BEGIN
					SELECT @nCurrentPeriodHolding = 0, @nCurrentPeriodValue = 0
				END

				--INSERT INTO @tmpFinal (ScriptName, ISIN) VALUES (@sScriptName, @sISIN)

				INSERT INTO @tmpFinal (ScriptName, ISIN, TransactionType, PreviousHoldings, Value, Currency ) VALUES (@sScriptName, @sISIN, @sPreviousHolding, @nPreviousPeriodHolding, @nPreviousPeriodValue, @nCurrency)

				INSERT INTO @tmpFinal (SecurityType, TransactionType,
							PreviousHoldings, BuyQuantity, SellQuantity, Value, DateOfAcquisition,Currency)			
				SELECT CSecurity.CodeName SecurityType, CTransactionType.CodeName AS TransactionType, NULL,
					CASE WHEN TD.TransactionTypeCodeId = @nTransactionType_Buy OR TD.TransactionTypeCodeId = @nTransactionType_CashExercise THEN TD.Quantity 
						WHEN TD.TransactionTypeCodeId = @nTransactionType_Sell THEN 0
						WHEN TD.TransactionTypeCodeId = @nTransactionType_CashlessAll THEN TD.Quantity
						WHEN TD.TransactionTypeCodeId = @nTransactionType_CashlessPartial THEN TD.Quantity
						ELSE 0 END AS Buy,
					CASE WHEN TD.TransactionTypeCodeId = @nTransactionType_Buy OR TD.TransactionTypeCodeId = @nTransactionType_CashExercise THEN 0
						WHEN TD.TransactionTypeCodeId = @nTransactionType_Sell THEN TD.Quantity
						WHEN TD.TransactionTypeCodeId = @nTransactionType_CashlessAll THEN TD.Quantity
						WHEN TD.TransactionTypeCodeId = @nTransactionType_CashlessPartial THEN TD.Quantity2
						ELSE 0 END AS Sell,
					CASE WHEN TD.TransactionTypeCodeId = @nTransactionType_Buy OR TD.TransactionTypeCodeId = @nTransactionType_CashExercise THEN TD.Value 
						WHEN TD.TransactionTypeCodeId = @nTransactionType_Sell THEN TD.Value
						WHEN TD.TransactionTypeCodeId = @nTransactionType_CashlessAll THEN TD.Value + TD.Value2
						WHEN TD.TransactionTypeCodeId = @nTransactionType_CashlessPartial THEN TD.Value + TD.Value2
						ELSE 0 END AS Value,
						TD.DateOfAcquisition,
						currency.DisplayCode as Currency
					--,TD.* 
				From tra_TransactionDetails TD JOIN tra_TransactionMaster TM ON TM.TransactionMasterId = TD.TransactionMasterId
					JOIN com_Code CSecurity ON TD.SecurityTypeCodeId = CSecurity.CodeID
					JOIN com_Code CTransactionType ON TransactionTypeCodeId = CTransactionType.CodeID
					LEFT JOIN com_Code currency ON currency.CodeID = TD.CurrencyID
				WHERE UserInfoId = @inp_iUserInfoId
					AND TD.ForUserInfoId = ISNULL(@inp_iUserInfoIdRelative, @inp_iUserInfoId)
					AND TD.SecurityTypeCodeId = @inp_iSecurityTypeCodeId
					AND TD.DMATDetailsID = @inp_iDMATDetailsId
					AND TM.PeriodEndDate = @dtPEEnd

				IF EXISTS (SELECT Id FROM @tmpFinal WHERE Id > 1)
				BEGIN
					INSERT INTO @tmpFinal (BuyQuantity, SellQuantity)
					SELECT SUM(BuyQuantity), SUM(SellQuantity) FROM @tmpFinal
				END
				
				INSERT INTO @tmpFinal (TransactionType, PreviousHoldings, Value, Currency) VALUES (@sCurrentHolding, @nCurrentPeriodHolding, @nCurrentPeriodValue, @nCurrency) 

				SELECT ScriptName AS rpt_grd_19062,
					 ISIN AS rpt_grd_19063,
					 SecurityType AS rpt_grd_19064,
					 TransactionType AS rpt_grd_19065,
					 PreviousHoldings AS rpt_grd_19066,
					 BuyQuantity AS rpt_grd_19068,
					 SellQuantity AS rpt_grd_19069,
					 Value AS rpt_grd_19070,
					 dbo.uf_rpt_FormatDateValue(DateOfAcquisition,0) AS rpt_grd_19071,
					 Currency as rpt_grd_54229
				FROM @tmpFinal t
				ORDER BY t.Id
			END
		END

		RETURN 0
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue	=  @ERR_IDEMPLOYEEINDIV
	END CATCH
END
