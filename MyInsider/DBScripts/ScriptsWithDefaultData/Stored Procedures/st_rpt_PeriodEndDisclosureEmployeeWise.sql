IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_rpt_PeriodEndDisclosureEmployeeWise')
DROP PROCEDURE [dbo].[st_rpt_PeriodEndDisclosureEmployeeWise]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Procedure to List data for ID employee wise report

Returns:		0, if Success.
				
Created by:		Arundhati
Created on:		01-Jun-2015

Modification History:
Modified By		Modified On		Description
arundhati		10-Jun-2015		Paging is supported
arundhati		15-Jun-2015		YearCodeId & PeriodCodeId are added in output
Raghvendra		21-Jul-2015		Change to add support for multiple element search for dropdown fields
Parag			20-Oct-2015		Made change to show period end disclouser report related to the period end type define in trading policy 
Raghvendra		29-Oct-2015		Change to call the date formatting using a DB scalar function
Parag			02-Nov-2015		Made change to user TP from UserPeriodEndMapping table which applicable for that period 
Raghvendra		5-Nov-2015		Changes for showing NA for the fields specified in excel sheet provided by ED team in Mantis bug no 7889
Parag			01-Dec-2015		Made change to handle condition when period end disclosure is not applicable for user
Parag			05-Dec-2015		Made change to show period end disclosure record after month end date
Parag			10-Dec-2015		Made change to show last record of each user if year and period code is not provoided
ED				4-Jan-2016		Code integration done on 4-Jan-2016
Tushar			12-Jan-2016		1. Add User Type for Non Insider employee search and grid
Gaurishankar	14-Jan-2016		Changes for Mantis Bug id=8475 : 	The user who is updated as Separated but is active as per settings made in "Update Separation" details, is not displayed under any report.
								The user who is seperated but as per "DateOfInactivation" still active in application, should be displayed in all the reports.
Parag			22-Jan-2016		Made change to use function for getting calender date or trading date as per configuration 
Parag			02-Feb-2016		Made change to fix issue of comment "Not submitted in stipulated time" is shown wrongly
ED			01-Mar-2016		Code merging done on 01-Mar-2016
Raghvendra		1-Apr-2016		Fix for mantis issue no 8475 i.e. Sapreated users which are inactive should not be seen in any of the reports.
Raghvendra		07-Sep-2016		Changed the GETDATE() call with function dbo.uf_com_GetServerDate(). This function will return the date to be used as server date.

Usage:
EXEC 
-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_rpt_PeriodEndDisclosureEmployeeWise]
	@inp_iPageSize				INT = 10
	,@inp_iPageNo				INT = 1
	,@inp_sSortField			VARCHAR(255)
	,@inp_sSortOrder			VARCHAR(5)
	,@inp_iYearCodeId			INT = NULL
	,@inp_iPeriodCodeId			INT = NULL
	,@inp_iUserInfoId 			VARCHAR(MAX)
	,@inp_sEmployeeID NVARCHAR(50)-- = 'GS1234'
	,@inp_sInsiderName NVARCHAR(100) --= 's'
	,@inp_sDesignation NVARCHAR(100) --= 's'
	,@inp_sGrade NVARCHAR(100) --= 'a'
	,@inp_sLocation NVARCHAR(50) --= 'pune'
	,@inp_sDepartment NVARCHAR(100) --= 'a'
	,@inp_sCompanyName NVARCHAR(200) --= 'k'
	,@inp_sTypeOfInsider NVARCHAR(200) --= 101003,101006

	,@inp_dtSubmissionDateFrom DATETIME --= '2015-05-15'
	,@inp_dtSubmissionDateTo DATETIME --= '2015-05-19'
	,@inp_dtSoftCopySubmissionDateFrom DATETIME --= '2015-05-14'
	,@inp_dtSoftCopySubmissionDateTo DATETIME --= '2015-05-15'
	,@inp_dtHardCopySubmissionDateFrom DATETIME
	,@inp_dtHardCopySubmissionDateTo DATETIME

	,@inp_sCommentsId NVARCHAR(200) --= 162002,162001
	,@inp_sIsInsiderFlag				NVARCHAR(200) -- 173001 : Insider, 173002 : Non Insider
	,@out_nReturnValue		INT = 0 OUTPUT
	,@out_nSQLErrCode			INT = 0 OUTPUT				-- Output SQL Error Number, if error occurred.
	,@out_sSQLErrMessage		VARCHAR(500) = '' OUTPUT  -- Output SQL Error Message, if error occurred.	
---------------------------------------------------------------------------
AS
BEGIN
print 'st_rpt_PeriodEndDisclosureEmployeeWise'
	DECLARE @ERR_IDEMPLOYEEWISE INT = -1
	
	DECLARE @sSQL NVARCHAR(MAX)
	DECLARE @dtImplementation DATETIME = '2015-01-01'

	DECLARE @iCommentsId_Ok INT = 162001
	DECLARE @iCommentsId_NotSubmittedInTime INT = 162002
	DECLARE @iCommentsId_NotSubmitted INT = 162003
	DECLARE @iIsTransCriteria INT = 0
	DECLARE @nInsiderFlag_Insider			INT = 173001
	DECLARE @nInsiderFlag_NonInsider		INT = 173002
	DECLARE @sInsider VARCHAR(20)					= ' Insider'

	DECLARE @RC INT
	DECLARE @dtPEStart DATETIME
	DECLARE @dtPEEnd DATETIME
	
	DECLARE @nPeriodType INT
	
	DECLARE @dtCurrentDate DATETIME = CONVERT(date, dbo.uf_com_GetServerDate())
	
	DECLARE @nExchangeTypeCodeId_NSE INT = 116001
	
	
	CREATE TABLE #tmpPEDisclosure(UserInfoId INT, EmployeeId NVARCHAR(50), InsiderName  NVARCHAR(100),
	JoiningDate DATETIME, DateOfInactivation DATETIME, CINNumber NVARCHAR(100), Designation NVARCHAR(100), Grade NVARCHAR(100), Location NVARCHAR(50),
	Department NVARCHAR(100), Category VARCHAR(50), SubCategory VARCHAR(50), StatusCodeId VARCHAR(50), CompanyName NVARCHAR(200), TypeOfInsider NVARCHAR(50), SubmissionDate DATETIME,
	SoftCopySubmissionDate DATETIME, HardCopySubmissionDate DATETIME, CommentId INT DEFAULT 162003, TransactionMasterId INT, 
	LastSubmissionDate DATETIME, PEndDate DATETIME, YearCodeId INT, PeriodCodeId INT,PeriodTypeId INT,PeriodType varchar(50))

	DECLARE @tmpTransactionIds TABLE (TransactionMasterId INT, UserInfoId INT)

	DECLARE @tmpComments TABLE (CodeId INT, DisplayText VARCHAR(100))
	BEGIN TRY
		
		SET NOCOUNT ON;
		-- Declare variables
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''
		
		-- check if period code - if period code is not given then fetch all the last record of user 
		--						and if period code is given then fetch all the record for that period 
		
		IF (@inp_iPeriodCodeId IS NOT NULL AND @inp_iPeriodCodeId <> 0)
		BEGIN
			SELECT @nPeriodType = ParentCodeId FROM com_Code WHERE CodeID = @inp_iPeriodCodeId
			
			-- Find out Period Start and End date for the selected year / period code id
			EXECUTE @RC = [st_tra_PeriodEndDisclosureStartEndDate2] 
			   @inp_iYearCodeId OUTPUT
			  ,@inp_iPeriodCodeId OUTPUT
			  ,null
			  ,@nPeriodType
			  ,0
			  ,@dtPEStart OUTPUT
			  ,@dtPEEnd OUTPUT
			  ,@out_nReturnValue OUTPUT
			  ,@out_nSQLErrCode OUTPUT
			  ,@out_sSQLErrMessage OUTPUT
		END
		
		
		IF @inp_sSortField IS NULL OR @inp_sSortField = ''
		BEGIN
			SET @inp_sSortField = 'rpt_grd_19039'
		END
		
		IF @inp_sSortOrder IS NULL OR @inp_sSortOrder = ''
		BEGIN
			SET @inp_sSortOrder = 'ASC'
		END
		
		IF @inp_sSortField = 'rpt_grd_19039'
		BEGIN
			SET @inp_sSortField = 'EmployeeId'
		END
		ELSE IF @inp_sSortField = 'rpt_grd_19040'
		BEGIN
			SET @inp_sSortField = 'InsiderName'
		END
		ELSE IF @inp_sSortField = 'rpt_grd_19041'
		BEGIN
			SET @inp_sSortField = 'JoiningDate'
		END
		ELSE IF @inp_sSortField = 'rpt_grd_19042'
		BEGIN
			SET @inp_sSortField = 'CINNumber'
		END
		ELSE IF @inp_sSortField = 'rpt_grd_19043'
		BEGIN
			SET @inp_sSortField = 'Designation'
		END
		ELSE IF @inp_sSortField = 'rpt_grd_19044'
		BEGIN
			SET @inp_sSortField = 'Grade'
		END
		ELSE IF @inp_sSortField = 'rpt_grd_19045'
		BEGIN
			SET @inp_sSortField = 'Location'
		END
		ELSE IF @inp_sSortField = 'rpt_grd_19046'
		BEGIN
			SET @inp_sSortField = 'Department'
		END
		ELSE IF @inp_sSortField = 'rpt_grd_19047'
		BEGIN
			SET @inp_sSortField = 'CompanyName'
		END
		ELSE IF @inp_sSortField = 'rpt_grd_19048'
		BEGIN
			SET @inp_sSortField = 'TypeOfInsider'
		END
		ELSE IF @inp_sSortField = 'rpt_grd_19049'
		BEGIN
			SET @inp_sSortField = 'SubmissionDate'
		END
		ELSE IF @inp_sSortField = 'rpt_grd_19073'
		BEGIN
			SET @inp_sSortField = 'LastSubmissionDate'
		END
		ELSE IF @inp_sSortField = 'rpt_grd_19051'
		BEGIN
			SET @inp_sSortField = 'SoftCopySubmissionDate'
		END
		ELSE IF @inp_sSortField = 'rpt_grd_19052'
		BEGIN
			SET @inp_sSortField = 'HardCopySubmissionDate'
		END
		ELSE IF @inp_sSortField = 'rpt_grd_19053'
		BEGIN
			SET @inp_sSortField = 'RComment.ResourceValue'
		END


		IF EXISTS(SELECT CodeName FROM com_Code WHERE CodeId = 128003)
		BEGIN
			SELECT @dtImplementation = CodeName FROM com_Code WHERE CodeId = 128003
		END
		
		INSERT INTO @tmpComments(CodeId, DisplayText)
		SELECT CodeID, ResourceValue FROM com_Code C JOIN mst_Resource R ON CodeName = ResourceKey
		WHERE CodeID BETWEEN 162001 AND 162003

		SELECT @sSQL = 'SELECT UF.UserInfoId, '
		
		-- check if period code id provided to search
		IF (@inp_iPeriodCodeId IS NOT NULL AND @inp_iPeriodCodeId <> 0)
		BEGIN
			SELECT @sSQL = @sSQL + 'TM.PeriodEndDate FROM tra_TransactionMaster TM LEFT JOIN usr_UserInfo UF ON TM.UserInfoId = UF.UserInfoId '
			SELECT @sSQL = @sSQL + 'AND TM.DisclosureTypeCodeId = 147003 '
			SELECT @sSQL = @sSQL + 'AND TM.PeriodEndDate =  ''' + CONVERT(VARCHAR(11), @dtPEEnd) + ''' '		
			SELECT @sSQL = @sSQL + 'AND TM.PeriodEndDate <  ''' + CONVERT(VARCHAR(11), @dtCurrentDate) + ''' '
		END
		ELSE
		BEGIN
			SELECT @sSQL = @sSQL + 'LastPeriodEndUser.PeriodEndDate FROM (SELECT UserInfoId, MAX(PeriodEndDate) as PeriodEndDate FROM tra_TransactionMaster TM '
			SELECT @sSQL = @sSQL + 'WHERE TM.PeriodEndDate IS NOT NULL and TM.DisclosureTypeCodeId = 147003 GROUP BY UserInfoId) '
			SELECT @sSQL = @sSQL + 'AS LastPeriodEndUser LEFT JOIN usr_UserInfo UF ON LastPeriodEndUser.UserInfoId = Uf.UserInfoId '
			SELECT @sSQL = @sSQL + 'AND LastPeriodEndUser.PeriodEndDate <  ''' + CONVERT(VARCHAR(11), @dtCurrentDate) + ''' '
		END
		
		SELECT @sSQL = @sSQL + 'JOIN mst_Company C ON UF.CompanyId = C.CompanyId '
		SELECT @sSQL = @sSQL + 'LEFT JOIN com_Code CDesignation ON UF.DesignationId = CDesignation.CodeID '
		SELECT @sSQL = @sSQL + 'LEFT JOIN com_Code CSubDesignation ON UF.SubDesignationId = CSubDesignation.CodeID '
		SELECT @sSQL = @sSQL + 'LEFT JOIN com_Code CGrade ON UF.GradeId = CGrade.CodeID '
		SELECT @sSQL = @sSQL + 'LEFT JOIN com_Code CDepartment ON UF.DepartmentId = CDepartment.CodeID '
		SELECT @sSQL = @sSQL + 'WHERE 1 = 1 '
		
		--SELECT @sSQL = @sSQL + 'AND DateOfBecomingInsider <= ''' + CONVERT(VARCHAR(11), @dtPEEnd) + ''' '
		--SELECT @sSQL = @sSQL + 'AND (DateOfSeparation IS NULL OR ''' + CONVERT(VARCHAR(11), @dtPEStart) + '''  <= DateOfSeparation) '
		SELECT @sSQL = @sSQL + ' AND (DateOfInactivation IS NULL OR dbo.uf_com_GetServerDate() < DateOfInactivation) '

		IF ((@inp_iUserInfoId IS NOT NULL AND @inp_iUserInfoId <> '0')
		  OR (@inp_sEmployeeID IS NOT NULL AND @inp_sEmployeeID <> '')
		  OR (@inp_sInsiderName IS NOT NULL AND @inp_sInsiderName <> '')
		  OR (@inp_sDesignation IS NOT NULL AND @inp_sDesignation <> '')
		  OR (@inp_sGrade IS NOT NULL AND @inp_sGrade <> '')
		  OR (@inp_sLocation IS NOT NULL AND @inp_sLocation <> '')
		  OR (@inp_sDepartment IS NOT NULL AND @inp_sDepartment <> '')
		  OR (@inp_sCompanyName IS NOT NULL AND @inp_sCompanyName <> '')
		  OR (@inp_sTypeOfInsider IS NOT NULL AND @inp_sTypeOfInsider <> '')
		  OR (@inp_sIsInsiderFlag IS NOT NULL AND @inp_sIsInsiderFlag <> ''))
		BEGIN
			IF (@inp_iUserInfoId IS NOT NULL AND @inp_iUserInfoId <> '0')
			BEGIN
				print '@inp_iUserInfoId'
				SELECT @sSQL = @sSQL + ' AND UF.UserInfoId IN (SELECT [PARAM] FROM FN_VIGILANTE_SPLIT(''' + @inp_iUserInfoId + ''', '',''))'
			END
			IF (@inp_sEmployeeID IS NOT NULL AND @inp_sEmployeeID <> '')
			BEGIN
				print '@inp_sEmployeeID'
				SELECT @sSQL = @sSQL + ' AND EmployeeId like ''%' + @inp_sEmployeeID + '%'''
			END
  			IF (@inp_sInsiderName IS NOT NULL AND @inp_sInsiderName <> '')
			BEGIN
				print '@inp_sInsiderName'
				print @inp_sInsiderName
				SELECT @sSQL = @sSQL + ' AND CASE WHEN UserTypeCodeId = 101004 THEN C.CompanyName ELSE ISNULL(FirstName, N'''') + N'' '' + ISNULL(LastName, N'''') END like N''%' + @inp_sInsiderName + '%'''
			
			END
  			IF (@inp_sDesignation IS NOT NULL AND @inp_sDesignation <> '')
			BEGIN
				print '@inp_sDesignation'
				SELECT @sSQL = @sSQL + ' AND (CDesignation.CodeName like N''%' + @inp_sDesignation + '%'' OR DesignationText like N''%' + @inp_sDesignation + '%'')'
			
			END
  			IF (@inp_sGrade IS NOT NULL AND @inp_sGrade <> '')
			BEGIN
				print '@inp_sGrade'
				SELECT @sSQL = @sSQL + ' AND (CGrade.CodeName like ''%' + @inp_sGrade + '%'' OR GradeText like ''%' + @inp_sGrade + '%'')'
			
			END
  			IF (@inp_sLocation IS NOT NULL AND @inp_sLocation <> '')
			BEGIN
				print '@inp_sLocation'
				SELECT @sSQL = @sSQL + ' AND Location like ''%' + @inp_sLocation + '%'''
			
			END
  			IF (@inp_sDepartment IS NOT NULL AND @inp_sDepartment <> '')
			BEGIN
				print '@inp_sDepartment'
				SELECT @sSQL = @sSQL + ' AND (CDepartment.CodeName like ''%' + @inp_sDepartment + '%'' OR DepartmentText like ''%' + @inp_sDepartment + '%'')'
			END
  			IF (@inp_sCompanyName IS NOT NULL AND @inp_sCompanyName <> '')
			BEGIN
				print '@inp_sCompanyName'
				SELECT @sSQL = @sSQL + ' AND C.CompanyName like N''%' + @inp_sCompanyName + '%'''
			
			END
  			IF (@inp_sTypeOfInsider IS NOT NULL AND @inp_sTypeOfInsider <> '')
			BEGIN
				print '@inp_sTypeOfInsider'
				SELECT @sSQL = @sSQL + ' AND UF.UserTypeCodeId IN (' + @inp_sTypeOfInsider + ') '
			END
				-- Insider Flag
			IF (@inp_sIsInsiderFlag IS NOT NULL AND @inp_sIsInsiderFlag <> '')
			BEGIN
				PRINT @inp_sIsInsiderFlag
				IF CHARINDEX(',',@inp_sIsInsiderFlag) <= 0
				BEGIN
					IF @inp_sIsInsiderFlag = @nInsiderFlag_Insider
					BEGIN
						-- When the flag is one, records with date of becoming insider not null to be taken
						SELECT @sSQL = @sSQL + ' AND UF.DateOfBecomingInsider IS '
						SELECT @sSQL = @sSQL + ' NOT'			
					END
					ELSE IF @inp_sIsInsiderFlag = @nInsiderFlag_NonInsider
					BEGIN
						-- When the flag is one, records with date of becoming insider not null to be taken
						SELECT @sSQL = @sSQL + ' AND UF.DateOfBecomingInsider IS '
						SELECT @sSQL = @sSQL + ''			
					END
					SELECT @sSQL = @sSQL + ' NULL '
				END
			END
		END

		print 'Query1 = ' + @sSQL

		INSERT INTO #tmpPEDisclosure(UserInfoId, PEndDate)
		EXEC (@sSQL)


		SELECT @sSQL = 'SELECT TransactionMasterId, vwPEDS.UserInfoId FROM '
		-- check if period code id provided to search
		IF (@inp_iPeriodCodeId IS NOT NULL AND @inp_iPeriodCodeId <> 0)
		BEGIN
			SELECT @sSQL = @sSQL + 'vw_PeriodEndDisclosureStatus vwPEDS WHERE 1 = 1 '
			SELECT @sSQL = @sSQL + 'AND vwPEDS.PeriodEndDate = ''' + CONVERT(VARCHAR(11), @dtPEEnd) + ''' '
		END
		ELSE
		BEGIN
			SELECT @sSQL = @sSQL + '(SELECT UserInfoId, MAX(PeriodEndDate) as PeriodEndDate FROM vw_PeriodEndDisclosureStatus vwPEDS '
			SELECT @sSQL = @sSQL + 'GROUP BY UserInfoId) AS LastPeriodEndUser LEFT JOIN vw_PeriodEndDisclosureStatus vwPEDS '
			SELECT @sSQL = @sSQL + 'ON LastPeriodEndUser.UserInfoId = vwPEDS.UserInfoId and LastPeriodEndUser.PeriodEndDate = vwPEDS.PeriodEndDate '
			SELECT @sSQL = @sSQL + 'WHERE 1 = 1 '
		END
		
		IF ((@inp_dtSubmissionDateFrom IS NOT NULL AND @inp_dtSubmissionDateFrom <> '')
			OR (@inp_dtSubmissionDateTo IS NOT NULL AND @inp_dtSubmissionDateTo <> ''))
		BEGIN
			SET @iIsTransCriteria = 1
			IF (@inp_dtSubmissionDateFrom IS NOT NULL AND @inp_dtSubmissionDateFrom <> '')
			BEGIN
				SELECT @sSQL = @sSQL + 'AND CONVERT(DATETIME, ''' + CONVERT(VARCHAR(11), @inp_dtSubmissionDateFrom) + ''') <= DetailsSubmitDate '
			END
			
			IF (@inp_dtSubmissionDateTo IS NOT NULL AND @inp_dtSubmissionDateTo <> '')
			BEGIN
				SELECT @sSQL = @sSQL + 'AND CONVERT(DATETIME, ''' + CONVERT(VARCHAR(11), @inp_dtSubmissionDateTo) + ''') >= DetailsSubmitDate '
			END
		END

		IF ((@inp_dtSoftCopySubmissionDateFrom IS NOT NULL AND @inp_dtSoftCopySubmissionDateFrom <> '')
			OR (@inp_dtSoftCopySubmissionDateTo IS NOT NULL AND @inp_dtSoftCopySubmissionDateTo <> ''))
		BEGIN
			SET @iIsTransCriteria = 1
			IF (@inp_dtSoftCopySubmissionDateFrom IS NOT NULL AND @inp_dtSoftCopySubmissionDateFrom <> '')
			BEGIN
				SELECT @sSQL = @sSQL + 'AND CONVERT(DATETIME, ''' + CONVERT(VARCHAR(11), @inp_dtSoftCopySubmissionDateFrom) + ''') <= ScpSubmitDate '
			END
			
			IF (@inp_dtSoftCopySubmissionDateTo IS NOT NULL AND @inp_dtSoftCopySubmissionDateTo <> '')
			BEGIN
				SELECT @sSQL = @sSQL + 'AND CONVERT(DATETIME, ''' + CONVERT(VARCHAR(11), @inp_dtSoftCopySubmissionDateTo) + ''') >= ScpSubmitDate '
			END
		END

		IF ((@inp_dtHardCopySubmissionDateFrom IS NOT NULL AND @inp_dtHardCopySubmissionDateFrom <> '')
			OR (@inp_dtHardCopySubmissionDateTo IS NOT NULL AND @inp_dtHardCopySubmissionDateTo <> ''))
		BEGIN
			SET @iIsTransCriteria = 1
			IF (@inp_dtHardCopySubmissionDateFrom IS NOT NULL AND @inp_dtHardCopySubmissionDateFrom <> '')
			BEGIN
				SELECT @sSQL = @sSQL + 'AND CONVERT(DATETIME, ''' + CONVERT(VARCHAR(11), @inp_dtHardCopySubmissionDateFrom) + ''') <= HcpSubmitDate '
			END
			
			IF (@inp_dtHardCopySubmissionDateTo IS NOT NULL AND @inp_dtHardCopySubmissionDateTo <> '')
			BEGIN
				SELECT @sSQL = @sSQL + 'AND CONVERT(DATETIME, ''' + CONVERT(VARCHAR(11), @inp_dtHardCopySubmissionDateTo) + ''') >= HcpSubmitDate '
			END
		END
		print 'Query2 = ' + @sSQL

		INSERT INTO @tmpTransactionIds(TransactionMasterId, UserInfoId)
		EXEC (@sSQL)

		IF @iIsTransCriteria = 1
		BEGIN
			--print '@iIsTransCriteria '
			DELETE tmpDisc
			FROM #tmpPEDisclosure tmpDisc LEFT JOIN @tmpTransactionIds tmpTrans ON tmpDisc.UserInfoId = tmpTrans.UserInfoId
			WHERE tmpTrans.UserInfoId IS NULL
		END

		UPDATE tmpTD
		SET LastSubmissionDate = CONVERT(date, dbo.uf_tra_GetNextTradingDateOrNoOfDays(TM.PeriodEndDate, DiscloPeriodEndToCOByInsdrLimit, NULL, 0, 1, 0, @nExchangeTypeCodeId_NSE)), -- DATEADD(D, DiscloPeriodEndToCOByInsdrLimit, TM.PeriodEndDate),
			CommentId = @iCommentsId_NotSubmittedInTime
		FROM #tmpPEDisclosure tmpTD JOIN tra_TransactionMaster TM ON tmpTD.TransactionMasterId = TM.TransactionMasterId 
			JOIN tra_UserPeriodEndMapping UPEMap ON UPEMap.PEEndDate IS NOT NULL AND UPEMap.PEEndDate = TM.PeriodEndDate 
					AND UPEMap.UserInfoId = TM.UserInfoId
			JOIN rul_TradingPolicy TP ON UPEMap.TradingPolicyId = TP.TradingPolicyId
		WHERE TM.DisclosureTypeCodeId = 147003

		UPDATE tmpDisc
			SET EmployeeId = UF.EmployeeId,
			InsiderName = CASE WHEN UserTypeCodeId = 101004 THEN C.CompanyName ELSE ISNULL(FirstName, '') + ' ' + ISNULL(LastName, '') END,
			JoiningDate = DateOfBecomingInsider,
			DateOfInactivation = UF.DateOfInactivation,
			Category = CCategory.CodeName,
			SubCategory = CSubCategory.CodeName,
			StatusCodeId = CStatusCodeId.CodeName,
			CINNumber = CASE WHEN UserTypeCodeId = 101004 THEN CIN ELSE DIN END,
			Designation = CASE WHEN UserTypeCodeId = 101003 THEN CDesignation.CodeName ELSE DesignationText END,
			Grade = CASE WHEN UserTypeCodeId = 101003 THEN CGrade.CodeName ELSE GradeText END,
			Location = UF.Location,
			Department = CASE WHEN UserTypeCodeId = 101003 THEN CDepartment.CodeName ELSE DepartmentText END,
			CompanyName = C.CompanyName,
			TypeOfInsider = CUserType.CodeName + CASE WHEN DateOfBecomingInsider IS NOT NULL THEN @sInsider ELSE '' END,
			SubmissionDate = vwIn.DetailsSubmitDate,
			SoftCopySubmissionDate = vwIn.ScpSubmitDate,
			HardCopySubmissionDate = vwIn.HcpSubmitDate,
			TransactionMasterId = vwIn.TransactionMasterId,
			LastSubmissionDate = CONVERT(date, dbo.uf_tra_GetNextTradingDateOrNoOfDays(TM.PeriodEndDate, DiscloPeriodEndToCOByInsdrLimit, NULL, 0, 1, 0, @nExchangeTypeCodeId_NSE)), -- DATEADD(D, DiscloPeriodEndToCOByInsdrLimit, TM.PeriodEndDate),
			YearCodeId = UPEMap.YearCodeId, 
			PeriodCodeId = UPEMap.PeriodCodeId,
			PeriodTypeId=CASE 
							WHEN TP.DiscloPeriodEndFreq = 137001 THEN 123001 -- Yearly
							WHEN TP.DiscloPeriodEndFreq = 137002 THEN 123003 -- Quarterly
							WHEN TP.DiscloPeriodEndFreq = 137003 THEN 123004 -- Monthly
							WHEN TP.DiscloPeriodEndFreq = 137004 THEN 123002 -- half yearly
							ELSE TP.DiscloPeriodEndFreq 
						END,
			PeriodType=CASE 
							WHEN TP.DiscloPeriodEndFreq = 137001 THEN (select CodeName from com_code where codeId='123001') -- Yearly
							WHEN TP.DiscloPeriodEndFreq = 137002 THEN (select CodeName from com_code where codeId='123003') -- Quarterly
							WHEN TP.DiscloPeriodEndFreq = 137003 THEN (select CodeName from com_code where codeId='123004') -- Monthly
							WHEN TP.DiscloPeriodEndFreq = 137004 THEN (select CodeName from com_code where codeId='123002') -- half yearly
							ELSE (select CodeName from com_code where codeId=TP.DiscloPeriodEndFreq) 
						END
		FROM #tmpPEDisclosure tmpDisc JOIN usr_UserInfo UF ON tmpDisc.UserInfoId = UF.UserInfoId
		JOIN mst_Company C ON UF.CompanyId = C.CompanyId
		JOIN com_Code CUserType ON UF.UserTypeCodeId = CUserType.CodeID
		LEFT JOIN vw_PeriodEndDisclosureStatus vwIn ON tmpDisc.UserInfoId = vwIn.UserInfoId AND PeriodEndDate = tmpDisc.PEndDate
		LEFT JOIN com_Code CDesignation ON UF.DesignationId = CDesignation.CodeID 
		LEFT JOIN com_Code CGrade ON UF.GradeId = CGrade.CodeID
		LEFT JOIN com_Code CDepartment ON UF.DepartmentId = CDepartment.CodeID
		LEFT JOIN tra_TransactionMaster TM ON vwIn.TransactionMasterId = TM.TransactionMasterId
		LEFT JOIN tra_UserPeriodEndMapping UPEMap ON UPEMap.PEEndDate IS NOT NULL AND UPEMap.PEEndDate = TM.PeriodEndDate AND UPEMap.UserInfoId = TM.UserInfoId
		LEFT JOIN rul_TradingPolicy TP ON UPEMap.TradingPolicyId = TP.TradingPolicyId
		LEFT join com_Code CCategory on UF.Category = CCategory.CodeID
		LEFT JOIN com_Code CSubCategory ON UF.SubCategory = CSubCategory.CodeID
		LEFT JOIN com_Code CStatusCodeId ON UF.StatusCodeId = CStatusCodeId.CodeID

		--DiscloInitLimit
		--DiscloInitDateLimit
		UPDATE tmpTrans
		SET CommentId = /*CASE WHEN JoiningDate < @dtImplementation THEN 
								CASE WHEN SubmissionDate IS NULL THEN @iCommentsId_NotSubmitted
									WHEN SubmissionDate < DiscloInitDateLimit THEN @iCommentsId_Ok 
									ELSE @iCommentsId_NotSubmittedInTime 
								END
							 WHEN JoiningDate >= @dtImplementation THEN 
								CASE WHEN SubmissionDate IS NULL THEN @iCommentsId_NotSubmitted
									WHEN SubmissionDate < DATEADD(D, DiscloInitLimit, JoiningDate) THEN @iCommentsId_Ok 
									ELSE @iCommentsId_NotSubmittedInTime 
								END
						END*/
						CASE WHEN SubmissionDate IS NULL THEN @iCommentsId_NotSubmitted
							WHEN tmpTrans.SubmissionDate < CONVERT(date, dbo.uf_tra_GetNextTradingDateOrNoOfDays(PEndDate, DiscloPeriodEndToCOByInsdrLimit, NULL, 0, 1, 0, @nExchangeTypeCodeId_NSE)) THEN @iCommentsId_Ok -- DATEADD(D, DiscloPeriodEndToCOByInsdrLimit,@dtPEEnd)
							ELSE @iCommentsId_NotSubmittedInTime END
		FROM #tmpPEDisclosure tmpTrans JOIN tra_TransactionMaster TM ON TM.TransactionMasterId = tmpTrans.TransactionMasterId
		JOIN tra_UserPeriodEndMapping UPEMap ON UPEMap.PEEndDate IS NOT NULL AND UPEMap.PEEndDate = TM.PeriodEndDate AND UPEMap.UserInfoId = TM.UserInfoId
		JOIN rul_TradingPolicy TP ON UPEMap.TradingPolicyId = TP.TradingPolicyId
		
		IF @inp_sCommentsId IS NOT NULL AND @inp_sCommentsId <> ''
		BEGIN
			print '@inp_sCommentsId'
			EXEC ('DELETE FROM #tmpPEDisclosure WHERE CommentId NOT IN (' +  @inp_sCommentsId + ') ')
		END

		SELECT @sSQL = 'INSERT INTO #tmpList(RowNumber, EntityID) '
		SELECT @sSQL = @sSQL + 'SELECT DISTINCT DENSE_RANK() OVER(Order BY ' + @inp_sSortField + ' ' + @inp_sSortOrder +',UserInfoId),UserInfoId ' 
		SELECT @sSQL = @sSQL + 'FROM #tmpPEDisclosure ID '
		SELECT @sSQL = @sSQL + 'JOIN com_Code CComment ON ID.CommentId = CComment.CodeID '
		SELECT @sSQL = @sSQL + 'JOIN mst_Resource RComment ON CComment.CodeName = RComment.ResourceKey '
		
		print @sSQL
		EXEC (@sSQL)
		

		SELECT @sSQL = 'SELECT '
		SELECT @sSQL = @sSQL + 'dbo.uf_rpt_ReplaceSpecialChar(EmployeeId) AS rpt_grd_19039, '
		SELECT @sSQL = @sSQL + 'InsiderName  AS rpt_grd_19040, '
		SELECT @sSQL = @sSQL + 'dbo.uf_rpt_ReplaceSpecialChar(dbo.uf_rpt_FormatDateValue(JoiningDate,0)) AS rpt_grd_19041, '
		SELECT @sSQL = @sSQL + 'dbo.uf_rpt_ReplaceSpecialChar(DateOfInactivation) AS DateOfInactivation, '		
		SELECT @sSQL = @sSQL + 'dbo.uf_rpt_ReplaceSpecialChar(dbo.uf_rpt_FormatValue(CONVERT(VARCHAR,CINNumber),1)) AS rpt_grd_19042, '
		SELECT @sSQL = @sSQL + 'CONVERT(NVARCHAR(max),Designation) AS rpt_grd_19043, '
		SELECT @sSQL = @sSQL + 'dbo.uf_rpt_ReplaceSpecialChar(dbo.uf_rpt_FormatValue(CONVERT(VARCHAR,Grade),1)) AS rpt_grd_19044, '
		SELECT @sSQL = @sSQL + 'dbo.uf_rpt_ReplaceSpecialChar(dbo.uf_rpt_FormatValue(CONVERT(VARCHAR,Location),1)) AS rpt_grd_19045, '
		SELECT @sSQL = @sSQL + 'dbo.uf_rpt_ReplaceSpecialChar(dbo.uf_rpt_FormatValue(CONVERT(VARCHAR,Department),1)) AS rpt_grd_19046, '
		SELECT @sSQL = @sSQL + 'dbo.uf_rpt_ReplaceSpecialChar(Category) AS Category, '
		SELECT @sSQL = @sSQL + 'dbo.uf_rpt_ReplaceSpecialChar(SubCategory) AS SubCategory, '
		SELECT @sSQL = @sSQL + 'dbo.uf_rpt_ReplaceSpecialChar(StatusCodeId) AS StatusCodeId, '		
		SELECT @sSQL = @sSQL + 'CompanyName AS rpt_grd_19047, '
		SELECT @sSQL = @sSQL + 'dbo.uf_rpt_ReplaceSpecialChar(TypeOfInsider) AS rpt_grd_19048, '
		SELECT @sSQL = @sSQL + 'dbo.uf_rpt_ReplaceSpecialChar(dbo.uf_rpt_FormatDateValue(LastSubmissionDate,0)) AS rpt_grd_19049, '
		SELECT @sSQL = @sSQL + 'dbo.uf_rpt_ReplaceSpecialChar(dbo.uf_rpt_FormatDateValue(SubmissionDate,1)) AS rpt_grd_19073, '
		SELECT @sSQL = @sSQL + 'dbo.uf_rpt_ReplaceSpecialChar(dbo.uf_rpt_FormatDateValue(SoftCopySubmissionDate,1)) AS rpt_grd_19051, '
		SELECT @sSQL = @sSQL + 'dbo.uf_rpt_ReplaceSpecialChar(dbo.uf_rpt_FormatDateValue(HardCopySubmissionDate,1)) AS rpt_grd_19052, '
		SELECT @sSQL = @sSQL + 'dbo.uf_rpt_ReplaceSpecialChar(RComment.ResourceValue) AS rpt_grd_19053, '
		SELECT @sSQL = @sSQL + 'dbo.uf_rpt_ReplaceSpecialChar(YearCodeId) AS YearCodeId, '
		SELECT @sSQL = @sSQL + 'dbo.uf_rpt_ReplaceSpecialChar(PeriodCodeId) AS PeriodCodeId, UserInfoID , TransactionMasterId, '
		SELECT @sSQL = @sSQL + 'PeriodTypeId AS PeriodTypeId, '
		SELECT @sSQL = @sSQL + 'PeriodType AS PeriodType '
		SELECT @sSQL = @sSQL + 'FROM #tmpList t JOIN #tmpPEDisclosure ID ON t.EntityID = ID.UserInfoId '
		SELECT @sSQL = @sSQL + 'JOIN com_Code CComment ON ID.CommentId = CComment.CodeID '
		SELECT @sSQL = @sSQL + 'JOIN mst_Resource RComment ON CComment.CodeName = RComment.ResourceKey '
		--SELECT @sSQL = @sSQL + 'ORDER BY ' + @inp_sSortField + ' ' + @inp_sSortOrder
		SELECT @sSQL = @sSQL + 'WHERE ID.UserInfoID IS NOT NULL '
		SELECT @sSQL = @sSQL + 'AND ((' + CONVERT(VARCHAR(10), @inp_iPageSize) + ' = 0) '
		SELECT @sSQL = @sSQL + 'OR (T.RowNumber BETWEEN ((' + CONVERT(VARCHAR(10), @inp_iPageNo) + ' - 1) * ' + CONVERT(VARCHAR(10), @inp_iPageSize) + ' + 1) '
		SELECT @sSQL = @sSQL + 'AND (' + CONVERT(VARCHAR(10), @inp_iPageNo) +  ' * ' + CONVERT(VARCHAR(10), @inp_iPageSize) + '))) '
		SELECT @sSQL = @sSQL + 'ORDER BY T.RowNumber '
				
		print @sSQL
		EXEC (@sSQL)
		
		DROP TABLE #tmpPEDisclosure

		RETURN 0
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue	=  @ERR_IDEMPLOYEEWISE
	END CATCH
END
