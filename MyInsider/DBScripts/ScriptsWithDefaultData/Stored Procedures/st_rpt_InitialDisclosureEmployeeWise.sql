IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_rpt_InitialDisclosureEmployeeWise')
DROP PROCEDURE [dbo].[st_rpt_InitialDisclosureEmployeeWise]
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
Arundhati		23-Jun-2015		Bug 0007600 is resolved. Details submission date and Last submission date are same but the comment was shown as "Not submitted in stip time"
Raghvendra		23-Jun-2015		Bug of Submission date not seen in the datatable view. The column name for Submission date was set to the parent column which should have been 
								the child column columns.
Arundhati		30-Jun-2015		Bug: Last submission date was not shown where trading details does not exist, is fixed
Raghvendra		21-Jul-2015		Change to add support for multiple element search for dropdown fields
Raghvendra		29-Oct-2015		Fix for Mantix bug 8160. Fix for returning the dates in required format so that it can be seen correctly in Excel download.
Raghvendra		29-Oct-2015		Change to call the date formatting using a DB scalar function
Raghvendra		05-Nov-2015		Changes for showing NA for the fields specified in excel sheet provided by ED team in Mantis bug no 7889
ED				04-Jan-2016		Code integration done on 4-Jan-2016
ED				08-Jan-2016		Code integration done on 8-Jan-2016
Tushar			12-Jan-2016		1. Add User Type for Non Insider employee search and grid.
								2. Change Initial Disclosure: "Pending" state is displayed wrongly for "Softcopy & Hardcopy" even when those are "Not Required"
								3. Employee(Non Insider) is displayed in "Report".
Gaurishankar	14-Jan-2016		Changes for Mantis Bug id=8475 : 	The user who is updated as Separated but is active as per settings made in "Update Separation" details, is not displayed under any report.
								The user who is seperated but as per "DateOfInactivation" still active in application, should be displayed in all the reports.
Tushar			28-Jan-2016		1. Employee(Non Insider) is displayed in "Report".
								2. set last submission date if user created before Initial Disclosure before go live then
										SET last submission date = Initial Disclosure before go live
									if user created after Initial Disclosure before go live then add days for 
									    Last Submission date  = created date + add days(Initial Disclosure within days of joining/being 
																				categorised as insider)	
Tushar			02-Feb-2016		1. set last submission date if user created before Initial Disclosure before go live then
										SET last submission date = Initial Disclosure before go live
									if user created after Initial Disclosure before go live then add days for 
									    Last Submission date  = created date + add days(Initial Disclosure within days of joining/being categorised as insider)
ED				01-Mar-2016		Code merging done on 01-Mar-2016
Tushar			10-Mar-2016		Change Logic for Set Last Submission Date & evaluating Comment on the basis of Last Submission Date		
								1. If User Is Employee (Non Insider)
									If DateOfJoining <= Initial Disclosure before go live Date
									  Then Last Submssion Date =  Initial Disclosure before go live Date
									Else 
										Last Submssion Date = DateOfJoining + add days(Initial Disclosure within days of joining/being 
																				categorised as insider)	
								2. If User Is Employee (Insider)
									If DateOfBecomingInsider <= Initial Disclosure before go live Date
									  Then Last Submssion Date =  Initial Disclosure before go live Date
									Else 
										Last Submssion Date = DateOfBecomingInsider + add days(Initial Disclosure within days of joining/being 
																				categorised as insider)		    							    
Raghvendra		24-Mar-2016		Change to return TransactionMasterId in response to be used for showing the View link on the Report for users for whom the Soft Copy/Hard Copy 
								is submitted.	
Raghvendra		1-Apr-2016		Fix for mantis issue no 8475 i.e. Sapreated users which are inactive should not be seen in any of the reports.																																																							
Raghvendra		07-Sep-2016		Changed the GETDATE() call with function dbo.uf_com_GetServerDate(). This function will return the date to be used as server date.

Usage:
EXEC 
-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_rpt_InitialDisclosureEmployeeWise]
	@inp_iPageSize						INT = 10
	,@inp_iPageNo						INT = 1
	,@inp_sSortField					VARCHAR(255)
	,@inp_sSortOrder					VARCHAR(5)
	,@inp_iUserInfoId					VARCHAR(MAX)
	,@inp_sEmployeeID					NVARCHAR(50)-- = 'GS1234'
	,@inp_sInsiderName					NVARCHAR(100) --= 's'
	,@inp_sDesignation					NVARCHAR(100) --= 's'
	,@inp_sGrade						NVARCHAR(100) --= 'a'
	,@inp_sLocation						NVARCHAR(50) --= 'pune'
	,@inp_sDepartment					NVARCHAR(100) --= 'a'
	,@inp_sCompanyName					NVARCHAR(200) --= 'k'
	,@inp_sTypeOfInsider				NVARCHAR(200) --= 101003,101002
	,@inp_dtSubmissionDateFrom			DATETIME --= '2015-05-15'
	,@inp_dtSubmissionDateTo			DATETIME --= '2015-05-19'
	,@inp_dtSoftCopySubmissionDateFrom	DATETIME --= '2015-05-14'
	,@inp_dtSoftCopySubmissionDateTo	DATETIME --= '2015-05-15'
	,@inp_dtHardCopySubmissionDateFrom	DATETIME
	,@inp_dtHardCopySubmissionDateTo	DATETIME
	,@inp_dtLastSubmissionDateFrom		DATETIME --= '2015-05-15'
	,@inp_dtLastSubmissionDateTo		DATETIME --= '2015-05-19'
	,@inp_sCommentsId					NVARCHAR(200) --= 162002,162001
	,@inp_sIsInsiderFlag				NVARCHAR(200) -- 173001 : Insider, 173002 : Non Insider
	,@out_nReturnValue					INT = 0 OUTPUT
	,@out_nSQLErrCode					INT = 0 OUTPUT				-- Output SQL Error Number, if error occurred.
	,@out_sSQLErrMessage				VARCHAR(500) = '' OUTPUT  -- Output SQL Error Message, if error occurred.	
---------------------------------------------------------------------------
AS
BEGIN
	DECLARE @ERR_IDEMPLOYEEWISE INT = -1
	
	DECLARE @sSQL NVARCHAR(MAX)
	DECLARE @dtImplementation DATETIME = '2015-01-01'
	DECLARE @iCommentsId_Ok					INT = 162001
	DECLARE @iCommentsId_NotSubmittedInTime INT = 162002
	DECLARE @iCommentsId_NotSubmitted		INT = 162003
	DECLARE @iIsTransCriteria				INT = 0
	DECLARE @nInsiderFlag_Insider			INT = 173001
	DECLARE @nInsiderFlag_NonInsider		INT = 173002
	DECLARE @sInsider VARCHAR(20)					= ' Insider'

	CREATE TABLE #tmpInitialDisclosure(UserInfoId INT, EmployeeId NVARCHAR(50), InsiderName  NVARCHAR(100),
	JoiningDate DATETIME, CINNumber NVARCHAR(100), Designation NVARCHAR(100), Grade NVARCHAR(100), Location NVARCHAR(50),
	Department NVARCHAR(100), CompanyName NVARCHAR(200), TypeOfInsider NVARCHAR(50), SubmissionDate DATETIME, LastSubmissionDate DATETIME,
	SoftCopySubmissionDate DATETIME, HardCopySubmissionDate DATETIME, CommentId INT DEFAULT 162003, TransactionMasterId INT,
	DateOfInactivation DATETIME, Category VARCHAR(500), SubCategory  VARCHAR(500), CodeName VARCHAR(500),
	SoftCopySubmissionDisplayText NVARCHAR(500),HardCopySubmissionDisplayText NVARCHAR(500), EmailId NVARCHAR(200), PAN NVARCHAR(50))

	DECLARE @tmpTransactionIds TABLE (TransactionMasterId INT, UserInfoId INT)

	DECLARE @tmpComments TABLE (CodeId INT, DisplayText VARCHAR(100))
	SET @inp_dtSubmissionDateTo = @inp_dtSubmissionDateTo + '23:59:00'
	SET @inp_dtSoftCopySubmissionDateTo = @inp_dtSoftCopySubmissionDateTo +'23:59:00'
	SET @inp_dtHardCopySubmissionDateTo = @inp_dtHardCopySubmissionDateTo +'23:59:00'
	SET @inp_dtLastSubmissionDateTo = @inp_dtLastSubmissionDateTo +'23:59:00'
	BEGIN TRY
		
		SET NOCOUNT ON;
		-- Declare variables
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''

		print 'st_rpt_InitialDisclosureEmployeeWise'
		IF @inp_sSortField IS NULL OR @inp_sSortField = ''
		BEGIN
			SET @inp_sSortField = 'rpt_grd_19004'
		END
		
		IF @inp_sSortOrder IS NULL OR @inp_sSortOrder = ''
		BEGIN
			SET @inp_sSortOrder = 'ASC'
		END
		
		IF @inp_sSortField = 'rpt_grd_19004'
		BEGIN
			SET @inp_sSortField = 'EmployeeId'
		END
		ELSE IF @inp_sSortField = 'rpt_grd_19005'
		BEGIN
			SET @inp_sSortField = 'InsiderName'
		END
		ELSE IF @inp_sSortField = 'rpt_grd_19006'
		BEGIN
			SET @inp_sSortField = 'JoiningDate'
		END
		ELSE IF @inp_sSortField = 'rpt_grd_19007'
		BEGIN
			SET @inp_sSortField = 'CINNumber'
		END
		ELSE IF @inp_sSortField = 'rpt_grd_19008'
		BEGIN
			SET @inp_sSortField = 'Designation'
		END
		ELSE IF @inp_sSortField = 'rpt_grd_19009'
		BEGIN
			SET @inp_sSortField = 'Grade'
		END
		ELSE IF @inp_sSortField = 'rpt_grd_19010'
		BEGIN
			SET @inp_sSortField = 'Location'
		END
		ELSE IF @inp_sSortField = 'rpt_grd_19011'
		BEGIN
			SET @inp_sSortField = 'Department'
		END
		ELSE IF @inp_sSortField = 'rpt_grd_19012'
		BEGIN
			SET @inp_sSortField = 'CompanyName'
		END
		ELSE IF @inp_sSortField = 'rpt_grd_19013'
		BEGIN
			SET @inp_sSortField = 'TypeOfInsider'
		END
		ELSE IF @inp_sSortField = 'rpt_grd_19072'
		BEGIN
			SET @inp_sSortField = 'LastSubmissionDate'
		END
		ELSE IF @inp_sSortField = 'rpt_grd_19014'
		BEGIN
			SET @inp_sSortField = 'SubmissionDate'
		END
		ELSE IF @inp_sSortField = 'rpt_grd_19015'
		BEGIN
			SET @inp_sSortField = 'SoftCopySubmissionDate'
		END
		ELSE IF @inp_sSortField = 'rpt_grd_19016'
		BEGIN
			SET @inp_sSortField = 'HardCopySubmissionDate'
		END
		ELSE IF @inp_sSortField = 'rpt_grd_19017'
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

		SELECT @sSQL = 'SELECT UserInfoId FROM usr_UserInfo UF JOIN mst_Company C ON UF.CompanyId = C.CompanyId '
		SELECT @sSQL = @sSQL + 'LEFT JOIN com_Code CDesignation ON UF.DesignationId = CDesignation.CodeID '
		SELECT @sSQL = @sSQL + 'LEFT JOIN com_Code CSubDesignation ON UF.SubDesignationId = CSubDesignation.CodeID '
		SELECT @sSQL = @sSQL + 'LEFT JOIN com_Code CGrade ON UF.GradeId = CGrade.CodeID '
		SELECT @sSQL = @sSQL + 'LEFT JOIN com_Code CDepartment ON UF.DepartmentId = CDepartment.CodeID '
		SELECT @sSQL = @sSQL + 'WHERE 1 = 1 '
		--SELECT @sSQL = @sSQL + 'AND DateOfBecomingInsider <= dbo.uf_com_GetServerDate() AND (DateOfSeparation IS NULL OR dbo.uf_com_GetServerDate() <= DateOfSeparation) '
		SELECT @sSQL = @sSQL + 'AND (((DateOfBecomingInsider IS NULL OR DateOfBecomingInsider > dbo.uf_com_GetServerDate()) AND UserTypeCodeId = 101003) OR (DateOfBecomingInsider <= dbo.uf_com_GetServerDate() )) '
		
		
		
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
				SELECT @sSQL = @sSQL + ' AND UserInfoId IN (SELECT [PARAM] FROM FN_VIGILANTE_SPLIT(''' + @inp_iUserInfoId + ''', '',''))'
			END
			IF (@inp_sEmployeeID IS NOT NULL AND @inp_sEmployeeID <> '')
			BEGIN
				print '@inp_sEmployeeID'
				SELECT @sSQL = @sSQL + ' AND EmployeeId like ''%' + @inp_sEmployeeID + '%'''
			END
  			IF (@inp_sInsiderName IS NOT NULL AND @inp_sInsiderName <> '')
			BEGIN
				print '@inp_sInsiderName'
				SELECT @sSQL = @sSQL + ' AND CASE WHEN UserTypeCodeId = 101004 THEN C.CompanyName ELSE ISNULL(FirstName, '''') + '' '' + ISNULL(LastName, '''') END like ''%' + @inp_sInsiderName + '%'''
			
			END
  			IF (@inp_sDesignation IS NOT NULL AND @inp_sDesignation <> '')
			BEGIN
				print '@inp_sDesignation'
				SELECT @sSQL = @sSQL + ' AND (CDesignation.CodeName like ''%' + @inp_sDesignation + '%'' OR DesignationText like ''%' + @inp_sDesignation + '%'')'
			
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
				SELECT @sSQL = @sSQL + ' AND C.CompanyName like ''%' + @inp_sCompanyName + '%'''
			
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

		INSERT INTO #tmpInitialDisclosure(UserInfoId)
		EXEC (@sSQL)
		
		--select * from #tmpInitialDisclosure where UserInfoId = 609 
		
		SELECT @sSQL = 'SELECT TransactionMasterId, UserInfoId FROM vw_InitialDisclosureStatus WHERE 1 = 1 '

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
				SELECT @sSQL = @sSQL + 'AND CONVERT(DATETIME, ''' + CONVERT(VARCHAR(23), @inp_dtSubmissionDateTo) + ''') >= CONVERT(VARCHAR(23), DetailsSubmitDate) '
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
				SELECT @sSQL = @sSQL + 'AND CONVERT(DATETIME, ''' + CONVERT(VARCHAR(23), @inp_dtSoftCopySubmissionDateTo) + ''') >= CONVERT(DATETIME,ScpSubmitDate) '
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
				SELECT @sSQL = @sSQL + 'AND CONVERT(DATETIME, ''' + CONVERT(VARCHAR(23), @inp_dtHardCopySubmissionDateTo) + ''') >= CONVERT(DATETIME,HcpSubmitDate) '
			END
		END
		print 'Query2 = ' + @sSQL

		INSERT INTO @tmpTransactionIds(TransactionMasterId, UserInfoId)
		EXEC (@sSQL)
		
		--select * from @tmpTransactionIds where UserInfoId =609
		
		IF @iIsTransCriteria = 1
		BEGIN
			DELETE tmpDisc
			FROM #tmpInitialDisclosure tmpDisc LEFT JOIN @tmpTransactionIds tmpTrans ON tmpDisc.UserInfoId = tmpTrans.UserInfoId
			WHERE tmpTrans.UserInfoId IS NULL
		END

		UPDATE tmpDisc 
			SET
			EmployeeId = UF.EmployeeId,
			EmailId = UF.EmailId, 
			PAN = UF.PAN, 
			InsiderName = CASE WHEN UserTypeCodeId = 101004 THEN C.CompanyName ELSE ISNULL(FirstName, '') + ' ' + ISNULL(LastName, '') END,
			JoiningDate = DateOfBecomingInsider,
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
			DateOfInactivation = UF.DateOfInactivation,
			Category = CCategory.CodeName,
			SubCategory = CSubCategory.CodeName,
			CodeName = CCode.CodeName,
			SoftCopySubmissionDisplayText = CASE WHEN vwIn.ScpSubmitStatus = 0 AND vwIn.DetailsSubmitStatus = 1 AND vwIn.SoftCopyReq = 1 THEN 'Pending' 
												 WHEN vwIn.ScpSubmitStatus = 0 AND vwIn.DetailsSubmitStatus = 1 AND vwIn.SoftCopyReq = 0 THEN 'Not Required'
												 WHEN vwIn.ScpSubmitStatus = 1 THEN CONVERT(VARCHAR(max), UPPER(REPLACE(CONVERT(NVARCHAR, vwIn.ScpSubmitDate, 106),' ','/'))) ELSE '-' END,
			HardCopySubmissionDisplayText = CASE WHEN vwIn.HcpSubmitStatus = 0 AND vwIn.ScpSubmitStatus = 1 AND vwIn.HardCopyReq = 1 THEN 'Pending' 
												 WHEN vwIn.HcpSubmitStatus = 0 AND vwIn.ScpSubmitStatus = 1 AND vwIn.HardCopyReq = 0 THEN 'Not Required'
												 WHEN vwIn.HcpSubmitStatus = 0 AND vwIn.DetailsSubmitStatus = 1 AND vwIn.ScpSubmitStatus = 0 AND vwIn.SoftCopyReq = 0 THEN 'Not Required'
												 WHEN vwIn.HcpSubmitStatus = 1 THEN CONVERT(VARCHAR(max), UPPER(REPLACE(CONVERT(NVARCHAR, vwIn.HcpSubmitDate, 106),' ','/'))) ELSE '-' END								
		FROM #tmpInitialDisclosure tmpDisc JOIN usr_UserInfo UF ON tmpDisc.UserInfoId = UF.UserInfoId
		JOIN mst_Company C ON UF.CompanyId = C.CompanyId
		JOIN com_Code CUserType ON UF.UserTypeCodeId = CUserType.CodeID
		LEFT JOIN vw_InitialDisclosureStatus vwIn ON tmpDisc.UserInfoId = vwIn.UserInfoId
		LEFT JOIN com_Code CDesignation ON UF.DesignationId = CDesignation.CodeID 
		LEFT JOIN com_Code CGrade ON UF.GradeId = CGrade.CodeID
		LEFT JOIN com_Code CDepartment ON UF.DepartmentId = CDepartment.CodeID
		LEFT JOIN com_Code CCategory ON CCategory.CodeID = UF.Category
		LEFT JOIN com_Code CSubCategory ON CSubCategory.CodeID = UF.SubCategory
		LEFT JOIN com_Code CCode ON CCode.CodeID = UF.StatusCodeId
		
		--DiscloInitLimit
		--DiscloInitDateLimit
		UPDATE tmpTrans
		SET CommentId = 
		CASE WHEN UF.DateOfBecomingInsider IS NULL THEN
						 CASE WHEN UF.DateOfJoining <= TP.DiscloInitDateLimit THEN 
								CASE WHEN SubmissionDate IS NULL THEN @iCommentsId_NotSubmitted
									WHEN SubmissionDate <= DATEADD(D, 1, TP.DiscloInitDateLimit) THEN @iCommentsId_Ok 
									ELSE @iCommentsId_NotSubmittedInTime 
								END
							 WHEN UF.DateOfJoining > TP.DiscloInitDateLimit  THEN 
								CASE WHEN SubmissionDate IS NULL THEN @iCommentsId_NotSubmitted
									WHEN SubmissionDate <= DATEADD(D, DiscloInitLimit, UF.DateOfJoining) THEN @iCommentsId_Ok 
									ELSE @iCommentsId_NotSubmittedInTime 
								END
						END
			ELSE  CASE WHEN UF.DateOfBecomingInsider <= ISNULL(TP.DiscloInitDateLimit,UF.DateOfBecomingInsider) THEN   
								CASE WHEN SubmissionDate IS NULL THEN @iCommentsId_NotSubmitted
									WHEN SubmissionDate <= DATEADD(D, 1, TP.DiscloInitDateLimit) THEN @iCommentsId_Ok 
									ELSE @iCommentsId_NotSubmittedInTime 
								END
							 WHEN UF.DateOfBecomingInsider > TP.DiscloInitDateLimit  THEN 
								CASE WHEN SubmissionDate IS NULL THEN @iCommentsId_NotSubmitted
									WHEN SubmissionDate <= DATEADD(D, DiscloInitLimit, UF.DateOfBecomingInsider) THEN @iCommentsId_Ok 
									ELSE @iCommentsId_NotSubmittedInTime 
								END
						END END,
			LastSubmissionDate = 
			CASE WHEN UF.DateOfBecomingInsider IS NULL THEN
									CASE WHEN UF.DateOfJoining <= TP.DiscloInitDateLimit  THEN DiscloInitDateLimit 
										ELSE DATEADD(D, DiscloInitLimit, UF.DateOfJoining) END
			ELSE CASE WHEN UF.DateOfBecomingInsider <= TP.DiscloInitDateLimit  THEN DiscloInitDateLimit 
										ELSE DATEADD(D, DiscloInitLimit, UF.DateOfBecomingInsider) END END
		FROM #tmpInitialDisclosure tmpTrans 
		JOIN usr_UserInfo UF ON tmpTrans.UserInfoId = UF.UserInfoId
		JOIN tra_TransactionMaster TM ON TM.TransactionMasterId = tmpTrans.TransactionMasterId
		JOIN rul_TradingPolicy TP ON TM.TradingPolicyId = TP.TradingPolicyId
		
	--	select tmpTrans.UserInfoId,TM.TradingPolicyId,TP.DiscloInitDateLimit,SubmissionDate,JoiningDate,@dtImplementation,
		--CASE WHEN UF.CreatedOn < TP.DiscloInitDateLimit THEN 
		--						CASE WHEN SubmissionDate IS NULL THEN @iCommentsId_NotSubmitted
		--							WHEN SubmissionDate < DATEADD(D, 1, DiscloInitDateLimit) THEN @iCommentsId_Ok 
		--							ELSE @iCommentsId_NotSubmittedInTime 
		--						END
		--					 WHEN UF.CreatedOn >= TP.DiscloInitDateLimit THEN 
		--						CASE WHEN SubmissionDate IS NULL THEN @iCommentsId_NotSubmitted
		--							WHEN SubmissionDate < DATEADD(D, DiscloInitLimit, UF.CreatedOn) THEN @iCommentsId_Ok 
		--							ELSE @iCommentsId_NotSubmittedInTime 
		--						END
		--				END,
		--	LastSubmissionDate = CASE WHEN UF.CreatedOn < TP.DiscloInitDateLimit THEN DiscloInitDateLimit 
		--								ELSE DATEADD(D, DiscloInitLimit, UF.CreatedOn) END
		--FROM #tmpInitialDisclosure tmpTrans 
		--JOIN usr_UserInfo UF ON tmpTrans.UserInfoId = UF.UserInfoId
		--JOIN tra_TransactionMaster TM ON TM.TransactionMasterId = tmpTrans.TransactionMasterId
		--JOIN rul_TradingPolicy TP ON TM.TradingPolicyId = TP.TradingPolicyId
		--where tmpTrans.UserInfoId = 609
		
		UPDATE tmpTrans
		SET LastSubmissionDate = CASE WHEN UF.DateOfBecomingInsider IS NULL THEN
									CASE WHEN UF.DateOfJoining <= TP.DiscloInitDateLimit  THEN DiscloInitDateLimit 
										ELSE DATEADD(D, DiscloInitLimit, UF.DateOfJoining) END
							ELSE 
							CASE WHEN UF.DateOfBecomingInsider <= TP.DiscloInitDateLimit  THEN DiscloInitDateLimit 
										ELSE DATEADD(D, DiscloInitLimit, UF.DateOfBecomingInsider) END END
		FROM #tmpInitialDisclosure tmpTrans 
		JOIN usr_UserInfo UF ON tmpTrans.UserInfoId = UF.UserInfoId
		JOIN 
			(SELECT UserInfoId, MAX(MapToId) MapToId FROM vw_ApplicableTradingPolicyForUser GROUP BY UserInfoId) vwTP ON tmpTrans.UserInfoId = vwTP.UserInfoId
			JOIN rul_TradingPolicy TP ON vwTP.MapToId = TP.TradingPolicyId
		WHERE LastSubmissionDate IS NULL

		IF @inp_sCommentsId IS NOT NULL AND @inp_sCommentsId <> ''
		BEGIN
			print '@inp_sCommentsId'
			EXEC ('DELETE FROM #tmpInitialDisclosure WHERE CommentId NOT IN(' + @inp_sCommentsId + ')')
		END

		IF @inp_dtLastSubmissionDateFrom IS NOT NULL OR @inp_dtLastSubmissionDateTo IS NOT NULL
		BEGIN
			IF @inp_dtLastSubmissionDateFrom IS NOT NULL
			BEGIN
				DELETE FROM #tmpInitialDisclosure
				WHERE LastSubmissionDate IS NULL OR LastSubmissionDate < @inp_dtLastSubmissionDateFrom
			END
			IF @inp_dtLastSubmissionDateTo IS NOT NULL
			BEGIN
				DELETE FROM #tmpInitialDisclosure
				WHERE LastSubmissionDate IS NULL OR LastSubmissionDate > @inp_dtLastSubmissionDateTo			
			END
		END
		
		--select * from #tmpInitialDisclosure where UserInfoId = 609
		
		SELECT @sSQL = 'INSERT INTO #tmpList(RowNumber, EntityID) '
		SELECT @sSQL = @sSQL + 'SELECT DISTINCT DENSE_RANK() OVER(Order BY ' + @inp_sSortField + ' ' + @inp_sSortOrder +',UserInfoId),UserInfoId ' 
		SELECT @sSQL = @sSQL + 'FROM #tmpInitialDisclosure ID '
		SELECT @sSQL = @sSQL + 'JOIN com_Code CComment ON ID.CommentId = CComment.CodeID '
		SELECT @sSQL = @sSQL + 'JOIN mst_Resource RComment ON CComment.CodeName = RComment.ResourceKey '
		
		print @sSQL
		EXEC (@sSQL)

		
		SELECT @sSQL = 'SELECT '
		SELECT @sSQL = @sSQL + 'EmployeeId AS rpt_grd_19004, '
		SELECT @sSQL = @sSQL + 'dbo.uf_rpt_ReplaceSpecialChar(InsiderName) AS rpt_grd_19005, '
		SELECT @sSQL = @sSQL + 'dbo.uf_rpt_FormatDateValue(JoiningDate,0) AS rpt_grd_19006, '
		SELECT @sSQL = @sSQL + 'dbo.uf_rpt_FormatValue(CONVERT(VARCHAR(max),CINNumber),1) AS rpt_grd_19007, '
		SELECT @sSQL = @sSQL + ' dbo.uf_rpt_ReplaceSpecialChar(dbo.uf_rpt_FormatValue(CONVERT(VARCHAR(max),Designation),1)) AS rpt_grd_19008, '
		SELECT @sSQL = @sSQL + ' dbo.uf_rpt_ReplaceSpecialChar(dbo.uf_rpt_FormatValue(CONVERT(VARCHAR(max),Grade),1)) AS rpt_grd_19009, '
		SELECT @sSQL = @sSQL + ' dbo.uf_rpt_ReplaceSpecialChar(dbo.uf_rpt_FormatValue(CONVERT(VARCHAR(max),Location),1)) AS rpt_grd_19010, '
		SELECT @sSQL = @sSQL + ' dbo.uf_rpt_ReplaceSpecialChar(dbo.uf_rpt_FormatValue(CONVERT(VARCHAR(max),Department),1)) AS rpt_grd_19011, '
		SELECT @sSQL = @sSQL + 'dbo.uf_rpt_ReplaceSpecialChar(CompanyName) AS rpt_grd_19012, '
		SELECT @sSQL = @sSQL + 'dbo.uf_rpt_ReplaceSpecialChar(TypeOfInsider) AS rpt_grd_19013, '
		SELECT @sSQL = @sSQL + 'dbo.uf_rpt_FormatDateValue(LastSubmissionDate,0) AS rpt_grd_19072, '--'LastSubmissionDate AS rpt_grd_19072, '
		SELECT @sSQL = @sSQL + 'dbo.uf_rpt_FormatDateValue(SubmissionDate,1) AS rpt_grd_19073, '--'SubmissionDate AS rpt_grd_19073, '
		SELECT @sSQL = @sSQL + 'EmailId AS rpt_grd_81001, ' --'add email id AS rpt_grd_81001'
		SELECT @sSQL = @sSQL + 'PAN AS rpt_grd_81001, ' --'add pan AS rpt_grd_81002'
		
		--SELECT @sSQL = @sSQL + 'dbo.uf_rpt_FormatDateValue(SoftCopySubmissionDate,1) AS rpt_grd_19015, '--'SoftCopySubmissionDate AS rpt_grd_19015, '
		--SELECT @sSQL = @sSQL + 'dbo.uf_rpt_FormatDateValue(HardCopySubmissionDate,1) AS rpt_grd_19016, '--'HardCopySubmissionDate AS rpt_grd_19016, '
		
		SELECT @sSQL = @sSQL + ' dbo.uf_rpt_ReplaceSpecialChar(SoftCopySubmissionDisplayText) AS rpt_grd_19015, '
		SELECT @sSQL = @sSQL + ' dbo.uf_rpt_ReplaceSpecialChar(HardCopySubmissionDisplayText) AS rpt_grd_19016, '
		
		SELECT @sSQL = @sSQL + 'dbo.uf_rpt_ReplaceSpecialChar(RComment.ResourceValue) AS rpt_grd_19017, '
		SELECT @sSQL = @sSQL + 'ID.UserInfoID As UserInfoID , ''151001'' AS LetterForCodeId,ID.TransactionMasterId AS TransactionMasterId, ID.UserInfoID AS EmployeeId,''0'' AS TransactionLetterId,''147001'' AS DisclosureTypeCodeId,''166'' AS Acid, dbo.uf_rpt_FormatDateValue(ID.DateOfInactivation,0) AS DateOfInactivation , dbo.uf_rpt_ReplaceSpecialChar(ID.Category) as Category  , dbo.uf_rpt_ReplaceSpecialChar(ID.SubCategory) As SubCategory , dbo.uf_rpt_ReplaceSpecialChar(ID.CodeName) As CodeName '
		
				
				
		SELECT @sSQL = @sSQL + 'FROM #tmpList t JOIN #tmpInitialDisclosure ID ON t.EntityID = ID.UserInfoId '
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
		
		--SELECT 'debug1', * FROM #tmpInitialDisclosure ID JOIN com_Code CComment ON ID.CommentId = CComment.CodeID
		--JOIN mst_Resource RComment ON CComment.CodeName = RComment.ResourceKey
		
		--SELECT ID.CompanyName AS rpt_grd_20001
		--FROM #tmpInitialDisclosure ID
		DROP TABLE #tmpInitialDisclosure
		RETURN 0
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue	=  @ERR_IDEMPLOYEEWISE
	END CATCH
END
GO
