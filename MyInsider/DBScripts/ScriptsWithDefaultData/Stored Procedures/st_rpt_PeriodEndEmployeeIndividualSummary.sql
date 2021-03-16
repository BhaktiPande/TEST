IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_rpt_PeriodEndEmployeeIndividualSummary')
DROP PROCEDURE [dbo].[st_rpt_PeriodEndEmployeeIndividualSummary]
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
Raghvendra		14-Jul-2015		Corrected the column resource for Script name seen in the datatable call.
Raghvendra		18-Jul-2015		Added a field for TransactionMasterId for SoftCopy and HardCopy submission dates. This is for adding a view link to the corresponding letter screen
Arundahti		23-Jul-2015		Added filters for mulitiselect of Security, Transaction, DMAT
Raghvendra		29-Oct-2015		Change to call the date formatting using a DB scalar function
Parag			02-Nov-2015		Made change to user TP from UserPeriodEndMapping table which applicable for that period 
Raghvendra		6-Nov-2015		Changes for showing NA for the fields specified in excel sheet provided by ED team in Mantis bug no 7889
Parag			01-Dec-2015		Made change to handle condition when period end disclosure is not applicable for user
Parag			06-Dec-2015		Made change to fix issue of records not shown for period end disclosure
ED				4-Jan-2016		Code integration done on 4-Jan-2016
Parag			22-Jan-2016		Made change to use function for getting calender date or trading date as per configuration
Parag			05-Feb-2016		Made change to fix issue of wrong opening balance is shown in report

Usage:
EXEC 
-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_rpt_PeriodEndEmployeeIndividualSummary]
	@inp_iPageSize				INT = 10
	,@inp_iPageNo				INT = 1
	,@inp_sSortField			VARCHAR(255)
	,@inp_sSortOrder			VARCHAR(5)
	,@inp_iOutputSeq			INT -- 1: User details, 2: Transaction status details, 3: Transaction Details
	,@inp_iYearCodeId			INT
	,@inp_iPeriodCodeId			INT
	,@inp_iUserInfoId			VARCHAR(MAX)
	,@inp_sDMATDetailsId		VARCHAR(200) -- Comma separated list of DMAT ids
	,@inp_sAcHolderName			VARCHAR(100)
	,@inp_sRelationTypeCodeId	VARCHAR(200) -- Null: No filter applied, 0: Self, NonZero: RelationId from com_Code -- Comma separated list
	,@inp_sSecurityTypeCodeId	VARCHAR(200) -- '139001, 139002' comma separated list of securitytypes
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
	DECLARE @dtScpSubmitDate VARCHAR(512)
	DECLARE @dtHcpSubmitDate VARCHAR(512)
	DECLARE @sStatusOfSubmission VARCHAR(100)

	DECLARE @nDataType_String INT = 1
	DECLARE @nDataType_Int INT = 2
	DECLARE @nDataType_Date INT = 3

	DECLARE @RC INT
	DECLARE @dtPEStart DATETIME
	DECLARE @dtPEEnd DATETIME
	
	DECLARE @tmpUserDetails TABLE(Id INT IDENTITY(1,1), RKey VARCHAR(20), Value VARCHAR(50), DataType INT, TransactionMasterId INT DEFAULT 0, DisclosureTypeCodeId INT DEFAULT 0, LetterForCodeId INT DEFAULT 0, Acid INT DEFAULT 0, LetterType char DEFAULT '')
	DECLARE @tmpUserTable TABLE(Id INT IDENTITY(1,1), UserInfoId INT, UserInfoIdRelative INT, SecurityTypeCodeId INT, DMATDetailsID INT, Relation VARCHAR(100), Holdings Decimal(20), Value Decimal(25,4))
	DECLARE @tmpDMATIds TABLE(DMATDetailsID INT)
	DECLARE @tmpSecurities TABLE(SecurityTypeCodeId INT)
	DECLARE @tmpRelatives TABLE(RelativeTypeCodeId INT)
	
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

		print 'st_rpt_PeriodEndEmployeeIndividualSummary'
		--IF @inp_iDMATDetailsId = 0
		--	SET @inp_iDMATDetailsId = NULL
		--IF @inp_iSecurityTypeCodeId = 0
		--	SET @inp_iSecurityTypeCodeId = NULL
		IF @inp_sDMATDEtailsId IS NOT NULL AND @inp_sDMATDEtailsId <> ''
		BEGIN
			INSERT INTO @tmpDMATIds SELECT * FROM uf_com_Split(@inp_sDMATDEtailsId)
		END
		ELSE
		BEGIN
			INSERT INTO @tmpDMATIds
			SELECT DMATDetailsID
			FROM usr_UserInfo UF JOIN usr_DMATDetails DD ON UF.UserInfoId = DD.UserInfoID
			WHERE UF.UserInfoId IN (SELECT * FROM FN_VIGILANTE_SPLIT (@inp_iUserInfoId, ','))
			UNION
			SELECT DMATDetailsID
			FROM usr_UserInfo UF
				JOIN usr_UserRelation UR ON UR.UserInfoId = UF.UserInfoId
				--JOIN com_Code CSecurity ON CSecurity.CodeGroupId = 139
				--JOIN com_Code CRelation ON UR.RelationTypeCodeId = CRelation.CodeID
				JOIN usr_DMATDetails DD ON UR.UserInfoIdRelative = DD.UserInfoID
			WHERE UF.UserInfoId IN (SELECT * FROM FN_VIGILANTE_SPLIT (@inp_iUserInfoId, ','))
		END
		
		IF @inp_sSecurityTypeCodeID IS NOT NULL AND @inp_sSecurityTypeCodeID <> ''
		BEGIN
			INSERT INTO @tmpSecurities SELECT * FROM uf_com_Split(@inp_sSecurityTypeCodeID)
		END
		ELSE
		BEGIN
			INSERT INTO @tmpSecurities
			SELECT CodeID
			FROM com_Code CSecurity 
			WHERE CSecurity.CodeGroupId = 139
		END
		
		IF @inp_sRelationTypeCodeId IS NOT NULL AND @inp_sRelationTypeCodeId <> ''
		BEGIN
			INSERT INTO @tmpRelatives SELECT * FROM uf_com_Split(@inp_sRelationTypeCodeId)
		END
		ELSE
		BEGIN
			INSERT INTO @tmpRelatives
			SELECT 0
			UNION
			SELECT CodeID
			FROM com_Code CSecurity 
			WHERE CSecurity.CodeGroupId = 100
		END
				
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
			WHERE UF.UserInfoId IN (SELECT * FROM FN_VIGILANTE_SPLIT (@inp_iUserInfoId, ','))
			
			INSERT INTO @tmpUserDetails(RKey, Value, DataType)
			VALUES ('rpt_lbl_19135', @sEmployeeID, @nDataType_String),
				('rpt_lbl_19136', dbo.uf_rpt_ReplaceSpecialChar(dbo.uf_rpt_FormatValue(CONVERT(VARCHAR(max), @sInsiderName),1)), @nDataType_String),
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
			WHERE UserInfoId IN (SELECT * FROM FN_VIGILANTE_SPLIT (@inp_iUserInfoId, ','))
				AND PeriodEndDate = @dtPEEnd

			SELECT @iCommentId = CASE WHEN vwPE.DetailsSubmitDate IS NULL THEN @iCommentsId_NotSubmitted
									WHEN vwPE.DetailsSubmitDate < CONVERT(date, dbo.uf_tra_GetNextTradingDateOrNoOfDays(@dtPEEnd, DiscloPeriodEndToCOByInsdrLimit, NULL, 0, 1, 0, @nExchangeTypeCodeId_NSE)) THEN @iCommentsId_Ok -- DATEADD(D, DiscloPeriodEndToCOByInsdrLimit, @dtPEEnd)
									ELSE @iCommentsId_NotSubmittedInTime 
								 END,
					@dtDetailsSubmitLastDate = CONVERT(date, dbo.uf_tra_GetNextTradingDateOrNoOfDays(@dtPEEnd, DiscloPeriodEndToCOByInsdrLimit, NULL, 0, 1, 0, @nExchangeTypeCodeId_NSE)) --DATEADD(D, DiscloPeriodEndToCOByInsdrLimit, @dtPEEnd)
			FROM usr_UserInfo UF JOIN vw_PeriodEndDisclosureStatus vwPE ON UF.UserInfoId = vwPE.UserInfoId
			JOIN tra_TransactionMaster TM ON TM.TransactionMasterId = vwPE.TransactionMasterId
			JOIN tra_UserPeriodEndMapping UPEMap ON UPEMap.PEEndDate IS NOT NULL AND UPEMap.PEEndDate = TM.PeriodEndDate AND UPEMap.UserInfoId = TM.UserInfoId
			JOIN rul_TradingPolicy TP ON UPEMap.TradingPolicyId = TP.TradingPolicyId
			WHERE UF.UserInfoId IN (SELECT * FROM FN_VIGILANTE_SPLIT (@inp_iUserInfoId, ','))
			
			SELECT @sComment = R.resourcevalue
			FROM com_Code C JOIN mst_Resource R ON C.CodeName = R.ResourceKey
			WHERE C.CodeID = @iCommentId

			IF @dtDetailsSubmitLastDate IS NULL
			BEGIN
				SELECT @dtDetailsSubmitLastDate = CONVERT(date, dbo.uf_tra_GetNextTradingDateOrNoOfDays(@dtPEEnd, DiscloPeriodEndToCOByInsdrLimit, NULL, 0, 1, 0, @nExchangeTypeCodeId_NSE)) -- DATEADD(D, DiscloPeriodEndToCOByInsdrLimit, @dtPEEnd)
				FROM usr_UserInfo UF JOIN vw_ApplicableTradingPolicyForUser AppTP ON UF.UserInfoId = AppTP.UserInfoId
					JOIN rul_TradingPolicy TP ON TP.TradingPolicyId = AppTP.MapToId
				WHERE UF.UserInfoId IN (SELECT * FROM FN_VIGILANTE_SPLIT (@inp_iUserInfoId, ','))
			END
			
			IF @inp_iOutputSeq = 2 
			BEGIN
				-- Output #2 : Transaction status details

				SELECT @dtDateOfBecomingInsider = UF.DateOfBecomingInsider,
					@dtScpSubmitDate = 
					--vwPE.ScpSubmitDate,
					CASE 
							WHEN vwPE.SoftCopyReq = 1 AND vwPE.DetailsSubmitStatus = 1 THEN -- if soft copy is required 
								(CASE 
									WHEN vwPE.ScpSubmitStatus = 0 THEN 'Pending'
									WHEN vwPE.ScpSubmitStatus = 1 THEN CONVERT(VARCHAR(max), UPPER(REPLACE(CONVERT(NVARCHAR, vwPE.ScpSubmitDate, 106),' ','/')))
									ELSE '-' END)
							WHEN vwPE.SoftCopyReq = 0 AND vwPE.DetailsSubmitStatus = 1 THEN 'Not Required'  -- if soft copy is NOT required
							ELSE '-' 
					END,

					@dtHcpSubmitDate = 
					--vwPE.HcpSubmitDate,
					CASE 
						WHEN vwPE.HardCopyReq = 1 AND vwPE.DetailsSubmitStatus = 1 THEN -- if hard copy is required 
							(CASE 
								WHEN vwPE.SoftCopyReq = 1 THEN   -- if soft copy is required 
									(CASE 
										WHEN vwPE.ScpSubmitStatus = 0 THEN  ''
										WHEN vwPE.ScpSubmitStatus = 1 AND vwPE.HcpSubmitStatus = 0 THEN  'Pending'
										WHEN vwPE.ScpSubmitStatus = 1 AND vwPE.HcpSubmitStatus = 1 THEN  CONVERT(VARCHAR(max), UPPER(REPLACE(CONVERT(NVARCHAR, vwPE.HcpSubmitDate, 106),' ','/')))
										ELSE '-' END)
								ELSE    -- if soft copy is NOT required
									(CASE 
										WHEN vwPE.HcpSubmitStatus = 0 THEN 'Pending' 
										WHEN vwPE.HcpSubmitStatus = 1 THEN CONVERT(VARCHAR(max), UPPER(REPLACE(CONVERT(NVARCHAR, vwPE.HcpSubmitDate, 106),' ','/'))) 
										ELSE '-' END)
								END) 
							WHEN vwPE.HardCopyReq = 0 AND vwPE.DetailsSubmitStatus = 1 THEN		-- if hard copy is NOT required
								(CASE
									WHEN vwPE.SoftCopyReq = 1 AND vwPE.ScpSubmitStatus = 1 THEN 'Not Required'	-- if soft copy is required
									WHEN vwPE.SoftCopyReq = 0 THEN 'Not Required'  -- if soft copy is NOT required
									ELSE '-' END)
							ELSE '-' 
					END,

					@sStatusOfSubmission = @sComment
				FROM usr_UserInfo UF LEFT JOIN vw_PeriodEndDisclosureStatus vwPE ON UF.UserInfoId = vwPE.UserInfoId AND PeriodEndDate = @dtPEEnd
				WHERE UF.UserInfoId IN (SELECT * FROM FN_VIGILANTE_SPLIT (@inp_iUserInfoId, ','))
				--SELECT @sSQL = @sSQL + 'dbo.uf_rpt_ReplaceSpecialChar(SoftCopySubmissionDate) AS rpt_grd_19051,'
				INSERT INTO @tmpUserDetails(RKey, Value, DataType, TransactionMasterId , DisclosureTypeCodeId , LetterForCodeId, Acid, LetterType)
				VALUES 	('rpt_lbl_19148', dbo.uf_rpt_FormatDateValue(@dtPEStart,0), @nDataType_String,0,0,0,0,''),
						('rpt_lbl_19160', dbo.uf_rpt_FormatDateValue(@dtPEEnd,0), @nDataType_String,0,0,0,0,''),
						('rpt_lbl_19149', dbo.uf_rpt_ReplaceSpecialChar(@dtScpSubmitDate), @nDataType_String,@nTransactionMasterId,147003,151001,170,'S'),
						('rpt_lbl_19150', dbo.uf_rpt_ReplaceSpecialChar(@dtHcpSubmitDate), @nDataType_String,@nTransactionMasterId,147003,151001,170,'H'),
						('rpt_lbl_19151', @sStatusOfSubmission, @nDataType_String,0,0,0,0,''),
						('rpt_lbl_19152', dbo.uf_rpt_FormatDateValue(@dtDetailsSubmitLastDate,0), @nDataType_String,0,0,0,0,'')

				INSERT INTO #tmpList(RowNumber, EntityID)
				VALUES (1,1)

				SELECT * FROM @tmpUserDetails ORDER BY ID
			END
			ELSE IF @inp_iOutputSeq = 3
			BEGIN
				INSERT INTO @tmpUserTable(UserInfoId, UserInfoIdRelative, SecurityTypeCodeId, DMATDetailsID, Relation)
				SELECT UF.UserInfoId UserInfoID, UF.UserInfoId UserInfoIdRelative, CodeID SecurityTypeCodeId, DD.DMATDetailsID DMATDetailsID, 'Self'
				FROM usr_UserInfo UF 
					JOIN com_Code CSecurity ON CSecurity.CodeGroupId = 139
					JOIN usr_DMATDetails DD ON UF.UserInfoId = DD.UserInfoID
					JOIN mst_Company C ON UF.CompanyId = C.CompanyId
					JOIN @tmpDMATIds tmpDD ON DD.DMATDetailsID = tmpDD.DMATDetailsID
					JOIN @tmpSecurities tmpSecurity ON tmpSecurity.SecurityTypeCodeId = CSecurity.CodeID
					JOIN @tmpRelatives tRelative ON tRelative.RelativeTypeCodeId = 0
				WHERE UF.UserInfoId IN (SELECT * FROM FN_VIGILANTE_SPLIT (@inp_iUserInfoId, ','))
					--AND (@inp_iDMATDetailsId IS NULL OR DD.DMATDetailsID = @inp_iDMATDetailsId)
					--AND (ISNULL(@inp_iRelationTypeCodeId, 0) = 0)
					--AND (@inp_iSecurityTypeCodeId IS NULL OR CSecurity.CodeID = @inp_iSecurityTypeCodeId)
					AND (@inp_sAcHolderName IS NULL OR 
							(CASE WHEN UF.UserTypeCodeId = 101004 THEN C.CompanyName ELSE ISNULL(UF.FirstName, '') + ' ' + ISNULL(UF.LastName, '') END) like '%' + @inp_sAcHolderName + '%')
				UNION
				SELECT UF.UserInfoId, UR.UserInfoIdRelative, CSecurity.CodeID, DD.DMATDetailsID, CRelation.CodeName
				FROM usr_UserInfo UF
					JOIN usr_UserRelation UR ON UR.UserInfoId = UF.UserInfoId
					JOIN com_Code CSecurity ON CSecurity.CodeGroupId = 139
					JOIN com_Code CRelation ON UR.RelationTypeCodeId = CRelation.CodeID
					JOIN usr_DMATDetails DD ON UR.UserInfoIdRelative = DD.UserInfoID
					JOIN mst_Company C ON UF.CompanyId = C.CompanyId
					JOIN usr_UserInfo UFRelative ON UR.UserInfoIdRelative = UFRelative.UserInfoId
					JOIN @tmpDMATIds tmpDD ON tmpDD.DMATDetailsID = DD.DMATDetailsID
					JOIN @tmpSecurities tmpSecurity ON tmpSecurity.SecurityTypeCodeId = CSecurity.CodeID					
					JOIN @tmpRelatives tRelative ON tRelative.RelativeTypeCodeId = CRelation.CodeID
				WHERE UF.UserInfoId IN (SELECT * FROM FN_VIGILANTE_SPLIT (@inp_iUserInfoId, ','))
					--AND (@inp_iDMATDetailsId IS NULL OR DMATDetailsID = @inp_iDMATDetailsId)
					--AND (@inp_iRelationTypeCodeId IS NULL OR RelationTypeCodeId = @inp_iRelationTypeCodeId)
					--AND (@inp_iSecurityTypeCodeId IS NULL OR CSecurity.CodeID = @inp_iSecurityTypeCodeId)
					AND (@inp_sAcHolderName IS NULL OR 
							(CASE WHEN UF.UserTypeCodeId = 101004 THEN C.CompanyName ELSE ISNULL(UFRelative.FirstName, '') + ' ' + ISNULL(UFRelative.LastName, '') END) like '%' + @inp_sAcHolderName + '%')
				ORDER BY UserInfoID, UserInfoIdRelative, DMATDetailsID, SecurityTypeCodeId

				INSERT INTO #tmpList(RowNumber, EntityID)
				SELECT ID, ID FROM @tmpUserTable

				UPDATE t
				SET Holdings = ISNULL(tSummary.ClosingBalance, 0),
					Value = ISNULL(tSummary.Value, 0)
				FROM @tmpUserTable t LEFT JOIN
					(SELECT UserInfoId, UserInfoIdRelative, SecurityTypeCodeId, DMATDetailsID, MAX(TransactionSummaryDMATWiseId) TransactionSummaryDMATWiseId
						FROM tra_TransactionSummaryDMATWise
						WHERE UserInfoId IN (SELECT * FROM FN_VIGILANTE_SPLIT (@inp_iUserInfoId, ','))
						AND ((YearCodeId = @inp_iYearCodeId AND PeriodCodeId <= @inp_iPeriodCodeId
										AND PeriodCodeId in (SELECT CodeID FROM com_Code WHERE CodeGroupId = 124 AND ParentCodeId = @nPeriodTypeCodeId))
							OR (YearCodeId < @inp_iYearCodeId))
						GROUP BY UserInfoId, UserInfoIdRelative, SecurityTypeCodeId, DMATDetailsID) tmpSummary 
						ON t.UserInfoId = tmpSummary.UserInfoId AND t.UserInfoIdRelative = tmpSummary.UserInfoIdRelative
							AND t.SecurityTypeCodeId = tmpSummary.SecurityTypeCodeId AND t.DMATDetailsID = tmpSummary.DMATDetailsID						
					LEFT JOIN tra_TransactionSummaryDMATWise tSummary ON tmpSummary.TransactionSummaryDMATWiseId = tSummary.TransactionSummaryDMATWiseId
				
				SELECT 
					CASE WHEN UF.UserTypeCodeId = 101004 THEN C.CompanyName ELSE ISNULL(UFRelative.FirstName, '') + ' ' + ISNULL(UFRelative.LastName, '') END AS rpt_grd_19054,
					Relation AS rpt_grd_19055,
					DMat.DEMATAccountNumber AS rpt_grd_19056, 
					C.CompanyName AS rpt_grd_19057,
					C.ISINNumber AS rpt_grd_19058,
					CSecurityType.CodeName  AS rpt_grd_19059,
					Holdings AS rpt_grd_19060,
					Value AS rpt_grd_19061,
					UF.UserInfoId AS UserInfoID,
					UFRelative.UserInfoId AS UserInfoIdRelative,
					CSecurityType.CodeID AS SecurityTypeCodeId,
					DMat.DMATDetailsID,
					@inp_iYearCodeId AS YearCodeId,
					@inp_iPeriodCodeId AS PeriodCodeId	
				FROM @tmpUserTable tmpUser 
					JOIN usr_UserInfo UF ON tmpUser.UserInfoId = UF.UserInfoId
					JOIN mst_Company C ON UF.CompanyId = C.CompanyId
					JOIN usr_UserInfo UFRelative ON tmpUser.UserInfoIdRelative = UFRelative.UserInfoId
					--JOIN usr_UserRelation UR ON UR.UserInfoId = UF.UserInfoId AND UR.UserInfoIdRelative = UFRelative.UserInfoId
					JOIN com_Code CSecurityType ON tmpUser.SecurityTypeCodeId = CSecurityType.CodeID
					LEFT JOIN usr_DMATDetails DMat ON tmpUser.DMATDetailsID = DMat.DMATDetailsID

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
