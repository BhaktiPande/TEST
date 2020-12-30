IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_rpt_PeriodEndDisclosureEmployeeWiseSSRS')
DROP PROCEDURE [dbo].[st_rpt_PeriodEndDisclosureEmployeeWiseSSRS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Procedure to List data for Period End Disclosure wise report

Returns:		0, if Success.
				
Created by:		Tushar Wakchaure
Created on:		05-March-2018
Usage:
EXEC  
-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_rpt_PeriodEndDisclosureEmployeeWiseSSRS]
	@inp_iPageSize				INT = 10
	,@inp_iPageNo				INT = 1
	,@inp_sSortField			VARCHAR(255)
	,@inp_sSortOrder			VARCHAR(5)
	,@inp_iYearCodeId			INT = NULL
	,@inp_iPeriodCodeId			INT = NULL
	,@inp_iUserInfoId 			NVARCHAR(MAX)
	,@inp_sEmployeeID NVARCHAR(50)-- = 'GS1234'
	,@inp_sInsiderName NVARCHAR(100) --= 's'
	,@inp_dtSubmissionDateFrom DATETIME --= '2015-05-15'
	,@inp_dtSubmissionDateTo DATETIME --= '2015-05-19'
	,@inp_sCommentsId NVARCHAR(200) --= 162002,162001
	,@inp_sIsInsiderFlag				NVARCHAR(200) -- 173001 : Insider, 173002 : Non Insider
	,@inp_sUserPAN                      NVARCHAR(MAX)
	,@inp_sCategory                     NVARCHAR(MAX)
	,@inp_sEmpStatus                    NVARCHAR(MAX)
	,@inp_sEmpSepOrLive                 NVARCHAR(MAX)
	,@out_nReturnValue		            INT = 0 OUTPUT
	,@out_nSQLErrCode			        INT = 0 OUTPUT				-- Output SQL Error Number, if error occurred.
	,@out_sSQLErrMessage		        VARCHAR(500) = '' OUTPUT  -- Output SQL Error Message, if error occurred.	
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
	
	DECLARE @nEmployeeStatusLive            VARCHAR(100),
			@nEmployeeStatusSeparated       VARCHAR(100),
			@nEmployeeStatusInactive        VARCHAR(100),
			@nEmpStatusLiveCode             INT = 510001,
			@nEmpStatusSeparatedCode        INT = 510002,
			@nEmpStatusInactiveCode         INT = 510003,
			@nEmployeeActive                INT = 102001,
			@nEmployeeInActive              INT = 102002,
			@nEmpActive                     VARCHAR(100),
			@nEmpInActive                   VARCHAR(100)
			
	SELECT @nEmployeeStatusLive = CodeName FROM com_Code WHERE CodeID = @nEmpStatusLiveCode
			
	SELECT @nEmployeeStatusSeparated = CodeName FROM com_Code WHERE CodeID = @nEmpStatusSeparatedCode
			
	SELECT @nEmployeeStatusInactive = CodeName FROM com_Code WHERE CodeID = @nEmpStatusInactiveCode
			
	SELECT @nEmpActive = CodeName FROM com_Code WHERE CodeID = @nEmployeeActive
			
	SELECT @nEmpInActive = CodeName FROM com_Code WHERE CodeID = @nEmployeeInActive 
	
	CREATE TABLE #tmpPEDisclosure(UserInfoId INT, EmployeeId NVARCHAR(50), InsiderName NVARCHAR(200), UserPAN NVARCHAR(MAX),SeperationDate DATETIME, LiveSeperated VARCHAR(MAX),
	JoiningDate DATETIME, DateOfInactivation DATETIME, CINNumber NVARCHAR(100), Designation NVARCHAR(512), Grade NVARCHAR(512), Location NVARCHAR(512),
	Department NVARCHAR(512), Category VARCHAR(512), SubCategory VARCHAR(512), StatusCodeId VARCHAR(50), CompanyName NVARCHAR(200),ISINNumber NVARCHAR(200), TypeOfInsider NVARCHAR(50), SubmissionDate DATETIME,
	SoftCopySubmissionDate VARCHAR(512), HardCopySubmissionDate VARCHAR(512), CommentId INT DEFAULT 162003, TransactionMasterId INT, 
	LastSubmissionDate DATETIME, PEndDate DATETIME, YearCodeId INT, PeriodCodeId INT,PeriodTypeId INT,PeriodType varchar(50),softCopyReq INT,HardCopyReq INT)

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
		SELECT @sSQL = @sSQL + 'LEFT JOIN com_Code CCategory ON CCategory.CodeID = UF.Category '
		
		
		SELECT @sSQL = @sSQL + 'LEFT JOIN com_Code CDepartment ON UF.DepartmentId = CDepartment.CodeID '
		SELECT @sSQL = @sSQL + 'WHERE 1 = 1 '
		
		--SELECT @sSQL = @sSQL + 'AND DateOfBecomingInsider <= ''' + CONVERT(VARCHAR(11), @dtPEEnd) + ''' '
		--SELECT @sSQL = @sSQL + 'AND (DateOfSeparation IS NULL OR ''' + CONVERT(VARCHAR(11), @dtPEStart) + '''  <= DateOfSeparation) '
		--SELECT @sSQL = @sSQL + ' AND (DateOfInactivation IS NULL OR dbo.uf_com_GetServerDate() < DateOfInactivation) '

		IF ((@inp_iUserInfoId IS NOT NULL AND @inp_iUserInfoId <> '0')
		  OR (@inp_sEmployeeID IS NOT NULL AND @inp_sEmployeeID <> '')
		  OR (@inp_sInsiderName IS NOT NULL AND @inp_sInsiderName <> '')
		  OR (@inp_sUserPAN IS NOT NULL AND @inp_sUserPAN <> '')
		  OR (@inp_sCategory IS NOT NULL AND @inp_sCategory <> '')
		  OR (@inp_sEmpStatus IS NOT NULL AND @inp_sEmpStatus <> '0')
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
				SELECT @sSQL = @sSQL + ' AND CASE WHEN UserTypeCodeId = 101004 THEN C.CompanyName ELSE ISNULL(FirstName, '''') + '' '' + ISNULL(LastName, '''') END like ''%' + @inp_sInsiderName + '%'''
			
			END
			IF (@inp_sUserPAN IS NOT NULL AND @inp_sUserPAN <> '')
			BEGIN
				print '@inp_sUserPAN'
				SELECT @sSQL = @sSQL + ' AND UF.pan IN (SELECT [PARAM] FROM FN_VIGILANTE_SPLIT(''' + @inp_sUserPAN + ''', '',''))'
			END
			IF (@inp_sCategory IS NOT NULL AND @inp_sCategory <> '')
			BEGIN
			    SELECT @sSQL = @sSQL + ' AND CASE WHEN UF.UserTypeCodeId = 101003 THEN ISNULL(CCategory.DisplayCode,CCategory.CodeName) ELSE UF.CategoryText END IN (SELECT [PARAM] FROM FN_VIGILANTE_SPLIT(''' + @inp_sCategory + ''', '',''))'
			END
			IF (@inp_sEmpStatus IS NOT NULL AND @inp_sEmpStatus <> '0')
			BEGIN
			    print 'In Code Name'
				SELECT @sSQL = @sSQL + ' AND UF.StatusCodeId IN (SELECT [PARAM] FROM FN_VIGILANTE_SPLIT(''' + @inp_sEmpStatus + ''', '',''))'
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
			AND (@inp_dtSubmissionDateTo IS NOT NULL AND @inp_dtSubmissionDateTo <> ''))
		BEGIN
		    print 'In date'
		    SET @iIsTransCriteria = 1
		    SELECT @sSQL = @sSQL + 'AND DetailsSubmitDate BETWEEN CONVERT(DATETIME, ''' + CONVERT(VARCHAR(11), @inp_dtSubmissionDateFrom) + ''') AND CONVERT(DATETIME, ''' + CONVERT(VARCHAR(11), @inp_dtSubmissionDateTo) + ''') '
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
			UserPAN = UF.pan,
			SeperationDate = UF.DateOfSeparation,
			JoiningDate = DateOfBecomingInsider,
			DateOfInactivation = UF.DateOfInactivation,
			Category = ISNULL(CCategory.DisplayCode,CCategory.CodeName), 
			SubCategory = CSubCategory.CodeName,
			StatusCodeId = CStatusCodeId.CodeName,
			CINNumber = CASE WHEN UserTypeCodeId = 101004 THEN CIN ELSE DIN END,
			Designation = CASE WHEN UserTypeCodeId = 101003 THEN CDesignation.CodeName ELSE DesignationText END,
			Grade = CASE WHEN UserTypeCodeId = 101003 THEN CGrade.CodeName ELSE GradeText END,
			Location = UF.Location,
			Department = CASE WHEN UserTypeCodeId = 101003 THEN CDepartment.CodeName ELSE DepartmentText END,
			CompanyName = C.CompanyName,
			ISINNumber =c.ISINNumber,
			TypeOfInsider = CUserType.CodeName + CASE WHEN DateOfBecomingInsider IS NOT NULL THEN @sInsider ELSE '' END,
			SubmissionDate = vwIn.DetailsSubmitDate,
			SoftCopySubmissionDate = 
			CASE 
				WHEN vwIn.SoftCopyReq = 1 AND vwIn.DetailsSubmitStatus = 1 THEN -- if soft copy is required 
					(CASE 
						WHEN vwIn.ScpSubmitStatus = 0 THEN 'Pending'
						WHEN vwIn.ScpSubmitStatus = 1 THEN CONVERT(VARCHAR(max), UPPER(REPLACE(CONVERT(NVARCHAR, vwIn.ScpSubmitDate, 106),' ','/')))
						ELSE '-' END)
				WHEN vwIn.SoftCopyReq = 0 AND vwIn.DetailsSubmitStatus = 1 THEN 'Not Required'  -- if soft copy is NOT required
				ELSE '-' 
			END,
			HardCopySubmissionDate = 
			CASE 
				WHEN vwIn.HardCopyReq = 1 AND vwIn.DetailsSubmitStatus = 1 THEN -- if hard copy is required 
					(CASE 
						WHEN vwIn.SoftCopyReq = 1 THEN   -- if soft copy is required 
							(CASE 
								WHEN vwIn.ScpSubmitStatus = 0 THEN  ''
								WHEN vwIn.ScpSubmitStatus = 1 AND vwIn.HcpSubmitStatus = 0 THEN  'Pending'
								WHEN vwIn.ScpSubmitStatus = 1 AND vwIn.HcpSubmitStatus = 1 THEN  CONVERT(VARCHAR(max), UPPER(REPLACE(CONVERT(NVARCHAR, vwIn.HcpSubmitDate, 106),' ','/')))
								ELSE '-' END)
						ELSE    -- if soft copy is NOT required
							(CASE 
								WHEN vwIn.HcpSubmitStatus = 0 THEN 'Pending' 
								WHEN vwIn.HcpSubmitStatus = 1 THEN CONVERT(VARCHAR(max), UPPER(REPLACE(CONVERT(NVARCHAR, vwIn.HcpSubmitDate, 106),' ','/'))) 
								ELSE '-' END)
						END) 
				WHEN vwIn.HardCopyReq = 0 AND vwIn.DetailsSubmitStatus = 1 THEN		-- if hard copy is NOT required
					(CASE
						WHEN vwIn.SoftCopyReq = 1 AND vwIn.ScpSubmitStatus = 1 THEN 'Not Required'	-- if soft copy is required
						WHEN vwIn.SoftCopyReq = 0 THEN 'Not Required'  -- if soft copy is NOT required
						ELSE '-' END)
				ELSE '-' 
			END,
			TransactionMasterId = vwIn.TransactionMasterId,		
			LastSubmissionDate = CONVERT(date, dbo.uf_tra_GetNextTradingDateOrNoOfDays(TM.PeriodEndDate, DiscloPeriodEndToCOByInsdrLimit, NULL, 0, 1, 0, @nExchangeTypeCodeId_NSE)), -- DATEADD(D, DiscloPeriodEndToCOByInsdrLimit, TM.PeriodEndDate),
			YearCodeId = UPEMap.YearCodeId, 
			PeriodCodeId = UPEMap.PeriodCodeId,
			LiveSeperated =  CASE WHEN UF.StatusCodeId = @nEmployeeActive AND UF.DateOfSeparation IS NULL THEN @nEmployeeStatusLive
				        WHEN UF.StatusCodeId = @nEmployeeActive AND UF.DateOfSeparation IS NOT NULL  THEN @nEmployeeStatusSeparated
				        WHEN UF.StatusCodeId = @nEmployeeInActive THEN @nEmployeeStatusSeparated
				        END,	
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
						END,
			softCopyReq =vwIn.SoftCopyReq,
			HardCopyReq =vwIn.HardCopyReq
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
		SELECT @sSQL = @sSQL + 'dbo.uf_rpt_ReplaceSpecialChar(InsiderName) AS rpt_grd_19040, '
		SELECT @sSQL = @sSQL + 'dbo.uf_rpt_ReplaceSpecialChar(UserPAN) AS UserPANNumber, '
		SELECT @sSQL = @sSQL + 'dbo.uf_rpt_FormatDateValue(SeperationDate,0) AS DateOfSeperation, '
		SELECT @sSQL = @sSQL + 'dbo.uf_rpt_ReplaceSpecialChar(LiveSeperated) AS LiveOrSeperated, '
		SELECT @sSQL = @sSQL + 'dbo.uf_rpt_ReplaceSpecialChar(dbo.uf_rpt_FormatDateValue(JoiningDate,0)) AS rpt_grd_19041, '
		SELECT @sSQL = @sSQL + 'dbo.uf_rpt_ReplaceSpecialChar(DateOfInactivation) AS DateOfInactivation, '		
		SELECT @sSQL = @sSQL + 'dbo.uf_rpt_ReplaceSpecialChar(dbo.uf_rpt_FormatValue(CONVERT(VARCHAR,CINNumber),1)) AS rpt_grd_19042, '
		SELECT @sSQL = @sSQL + 'dbo.uf_rpt_ReplaceSpecialChar(dbo.uf_rpt_FormatValue(CONVERT(VARCHAR,Designation),1)) AS rpt_grd_19043, '
		SELECT @sSQL = @sSQL + 'dbo.uf_rpt_ReplaceSpecialChar(dbo.uf_rpt_FormatValue(CONVERT(VARCHAR,Grade),1)) AS rpt_grd_19044, '
		SELECT @sSQL = @sSQL + 'dbo.uf_rpt_ReplaceSpecialChar(dbo.uf_rpt_FormatValue(CONVERT(VARCHAR,Location),1)) AS rpt_grd_19045, '
		SELECT @sSQL = @sSQL + 'dbo.uf_rpt_ReplaceSpecialChar(dbo.uf_rpt_FormatValue(CONVERT(VARCHAR,Department),1)) AS rpt_grd_19046, '
		SELECT @sSQL = @sSQL + 'dbo.uf_rpt_ReplaceSpecialChar(Category) AS Category, '
		SELECT @sSQL = @sSQL + 'dbo.uf_rpt_ReplaceSpecialChar(SubCategory) AS SubCategory, '
		SELECT @sSQL = @sSQL + 'dbo.uf_rpt_ReplaceSpecialChar(StatusCodeId) AS StatusCodeId, '		
		SELECT @sSQL = @sSQL + 'dbo.uf_rpt_ReplaceSpecialChar(CompanyName) AS rpt_grd_19047, '
		SELECT @sSQL = @sSQL + 'dbo.uf_rpt_ReplaceSpecialChar(ISINNumber) AS ISINNumber, '
		SELECT @sSQL = @sSQL + 'dbo.uf_rpt_ReplaceSpecialChar(TypeOfInsider) AS rpt_grd_19048, '
		SELECT @sSQL = @sSQL + 'dbo.uf_rpt_ReplaceSpecialChar(dbo.uf_rpt_FormatDateValue(LastSubmissionDate,0)) AS rpt_grd_19049, '
		SELECT @sSQL = @sSQL + 'dbo.uf_rpt_ReplaceSpecialChar(dbo.uf_rpt_FormatDateValue(SubmissionDate,1)) AS rpt_grd_19073, '
		SELECT @sSQL = @sSQL + 'dbo.uf_rpt_ReplaceSpecialChar(SoftCopySubmissionDate) AS rpt_grd_19051, '
		SELECT @sSQL = @sSQL + 'dbo.uf_rpt_ReplaceSpecialChar(HardCopySubmissionDate) AS rpt_grd_19052, '
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
	
		IF (@inp_sEmpSepOrLive IS NOT NULL AND @inp_sEmpSepOrLive <> '0' AND @inp_sEmpSepOrLive <> 'Null') 
			BEGIN
				print @inp_sEmpSepOrLive
				SELECT @sSQL = @sSQL + 'AND dbo.uf_rpt_ReplaceSpecialChar(LiveSeperated) IN (SELECT [PARAM] FROM FN_VIGILANTE_SPLIT(''' + @inp_sEmpSepOrLive + ''', '',''))'
				--select * from ##TempMaster where LiveOrSeperated in(SELECT [PARAM] FROM FN_VIGILANTE_SPLIT( @inp_sEmpSepOrLive ,','))
			END			
		SELECT @sSQL = @sSQL + 'ORDER BY T.RowNumber '
				
		print @sSQL
		
		CREATE TABLE #TempMaster (	rpt_grd_19039 NVARCHAR(100), rpt_grd_19040 NVARCHAR(50), UserPANNumber  NVARCHAR(100), DateOfSeperation NVARCHAR(100), LiveOrSeperated NVARCHAR(50), 
	    rpt_grd_19041 NVARCHAR(100), DateOfInactivation NVARCHAR(100), rpt_grd_19042 NVARCHAR(100), rpt_grd_19043 NVARCHAR(100), rpt_grd_19044 NVARCHAR(100), rpt_grd_19045 NVARCHAR(50),
	    rpt_grd_19046 NVARCHAR(100), Category VARCHAR(50), SubCategory VARCHAR(50), StatusCodeId VARCHAR(50), rpt_grd_19047 NVARCHAR(200),ISINNumber NVARCHAR(100), rpt_grd_19048 NVARCHAR(50), rpt_grd_19049 NVARCHAR(100),
	    rpt_grd_19073 NVARCHAR(100), rpt_grd_19051 NVARCHAR(100), rpt_grd_19052 NVARCHAR(100),rpt_grd_19053 NVARCHAR(100), YearCodeId INT,PeriodCodeId INT,UserInfoID INT,TransactionMasterId INT,PeriodTypeId INT,PeriodType VARCHAR(50)
		)
		INSERT INTO #TempMaster
		(
		rpt_grd_19039, rpt_grd_19040, UserPANNumber, DateOfSeperation, LiveOrSeperated, 
	    rpt_grd_19041, DateOfInactivation, rpt_grd_19042, rpt_grd_19043, rpt_grd_19044, rpt_grd_19045,
	    rpt_grd_19046, Category, SubCategory, StatusCodeId, rpt_grd_19047,ISINNumber, rpt_grd_19048, rpt_grd_19049,
	    rpt_grd_19073, rpt_grd_19051, rpt_grd_19052,rpt_grd_19053, YearCodeId,PeriodCodeId,UserInfoID,TransactionMasterId,PeriodTypeId,PeriodType
		)
		
		EXEC (@sSQL)
		
		

		CREATE TABLE #tmpUserTable
			(
			Id INT IDENTITY(1,1), UserInfoId INT, UserInfoIdRelative INT, SecurityTypeCodeId INT, DMATDetailsID INT, Relation VARCHAR(100), Holdings Decimal(20), Value Decimal(25,4),UserName Nvarchar(1000),DEMATAccountNumber Nvarchar(300),PanNumber varchar(50),SecurityName varchar(100),yearcodeid varchar(15),periodcodeid varchar(15)
			)			 
				DECLARE @tmpDMATIds TABLE(DMATDetailsID INT,DEMATAccountNumber nvarchar(300))
				DECLARE @tmpSecurities TABLE(SecurityTypeCodeId INT)
				DECLARE @tmpRelatives TABLE(RelativeTypeCodeId INT)
              
         

			INSERT INTO @tmpDMATIds
			SELECT DMATDetailsID,DD.DEMATAccountNumber
			FROM usr_UserInfo UF JOIN usr_DMATDetails DD ON UF.UserInfoId = DD.UserInfoID
			
			UNION
			SELECT DMATDetailsID,DD.DEMATAccountNumber
			FROM usr_UserInfo UF
				JOIN usr_UserRelation UR ON UR.UserInfoId = UF.UserInfoId			
				JOIN usr_DMATDetails DD ON UR.UserInfoIdRelative = DD.UserInfoID			

			INSERT INTO @tmpSecurities
			SELECT CodeID
			FROM com_Code CSecurity 
			WHERE CSecurity.CodeGroupId = 139

			INSERT INTO @tmpRelatives
			SELECT 0
			UNION
			SELECT CodeID
			FROM com_Code CSecurity 
			WHERE CSecurity.CodeGroupId = 100
			
			
			INSERT INTO #tmpUserTable(UserInfoId, UserInfoIdRelative, SecurityTypeCodeId, DMATDetailsID, Relation,UserName,DEMATAccountNumber,PanNumber,SecurityName,yearcodeid,periodcodeid)
				SELECT UF.UserInfoId UserInfoID, UF.UserInfoId UserInfoIdRelative, CodeID SecurityTypeCodeId, DD.DMATDetailsID DMATDetailsID, 'Self',
				CASE WHEN UF.UserTypeCodeId = 101004 THEN C.CompanyName ELSE ISNULL(UF.FirstName, '') + ' ' + ISNULL(UF.LastName, '') END
				AS UserName,DD.DEMATAccountNumber,UF.PAN,CSecurity.CodeName,tmp.yearcodeid,tmp.periodcodeid
				FROM usr_UserInfo UF 
					--JOIN com_Code CSecurity ON CSecurity.CodeGroupId = 139
					--JOIN usr_DMATDetails DD ON UF.UserInfoId = DD.UserInfoID
					--JOIN mst_Company C ON UF.CompanyId = C.CompanyId
					--JOIN @tmpDMATIds tmpDD ON DD.DMATDetailsID = tmpDD.DMATDetailsID
					--JOIN @tmpSecurities tmpSecurity ON tmpSecurity.SecurityTypeCodeId = CSecurity.CodeID
					--JOIN @tmpRelatives tRelative ON tRelative.RelativeTypeCodeId = 0
					--join #TempMaster tmp on tmp.userinfoid=UF.UserInfoId
					left JOIN com_Code CSecurity ON CSecurity.CodeGroupId = 139
					left JOIN usr_DMATDetails DD ON UF.UserInfoId = DD.UserInfoID
					JOIN mst_Company C ON UF.CompanyId = C.CompanyId
					left JOIN @tmpDMATIds tmpDD ON DD.DMATDetailsID = tmpDD.DMATDetailsID 
					LEFT JOIN @tmpSecurities tmpSecurity ON tmpSecurity.SecurityTypeCodeId = CSecurity.CodeID
					JOIN @tmpRelatives tRelative ON tRelative.RelativeTypeCodeId = 0
					join #TempMaster tmp on tmp.userinfoid=UF.UserInfoId
				WHERE 
				--UF.UserInfoId =4335					
				--	AND 
				(null IS NULL OR 
				(CASE WHEN UF.UserTypeCodeId = 101004 THEN C.CompanyName ELSE ISNULL(UF.FirstName, '') + ' ' + ISNULL(UF.LastName, '') END) like '%' + null + '%')
				UNION
				SELECT UF.UserInfoId, UR.UserInfoIdRelative, CSecurity.CodeID, DD.DMATDetailsID, CRelation.CodeName,
				CASE WHEN UF.UserTypeCodeId = 101004 THEN C.CompanyName ELSE ISNULL(UFRelative.FirstName, '') + ' ' + ISNULL(UFRelative.LastName, '') END
				AS UserName,DD.DEMATAccountNumber,UFRelative.PAN,CSecurity.CodeName,tmp.yearcodeid,tmp.periodcodeid
				FROM usr_UserInfo UF
					JOIN usr_UserRelation UR ON UR.UserInfoId = UF.UserInfoId
					LEFT JOIN com_Code CSecurity ON CSecurity.CodeGroupId = 139 
					LEFT JOIN com_Code CRelation ON UR.RelationTypeCodeId = CRelation.CodeID
					JOIN usr_DMATDetails DD ON UR.UserInfoIdRelative = DD.UserInfoID
					JOIN mst_Company C ON UF.CompanyId = C.CompanyId
					JOIN usr_UserInfo UFRelative ON UR.UserInfoIdRelative = UFRelative.UserInfoId
					LEFT JOIN @tmpDMATIds tmpDD ON tmpDD.DMATDetailsID = DD.DMATDetailsID
					LEFT JOIN @tmpSecurities tmpSecurity ON tmpSecurity.SecurityTypeCodeId = CSecurity.CodeID								
					JOIN @tmpRelatives tRelative ON tRelative.RelativeTypeCodeId = CRelation.CodeID
					join #TempMaster tmp on tmp.userinfoid=UF.UserInfoId
				WHERE 
				(null IS NULL OR 
				(CASE WHEN UF.UserTypeCodeId = 101004 THEN C.CompanyName ELSE ISNULL(UFRelative.FirstName, '') + ' ' + ISNULL(UFRelative.LastName, '') END) like '%' + null + '%')
				ORDER BY UserInfoID, UserInfoIdRelative, DMATDetailsID, SecurityTypeCodeId
							 
				
			CREATE TABLE ##TempMasterWithDetails (rpt_grd_19039 NVARCHAR(100), rpt_grd_19040 NVARCHAR(50), 
			UserPANNumber  NVARCHAR(100), DateOfSeperation NVARCHAR(100), 
			LiveOrSeperated NVARCHAR(50), rpt_grd_19041 NVARCHAR(100),
			DateOfInactivation NVARCHAR(100), 
			rpt_grd_19042 NVARCHAR(100), rpt_grd_19043 NVARCHAR(100), 
			rpt_grd_19044 NVARCHAR(100), rpt_grd_19045 NVARCHAR(50),
			rpt_grd_19046 NVARCHAR(100), Category VARCHAR(50), SubCategory VARCHAR(50), StatusCodeId VARCHAR(50),
			rpt_grd_19047 NVARCHAR(200), rpt_grd_19048 NVARCHAR(50), rpt_grd_19049 NVARCHAR(100),
			rpt_grd_19073 NVARCHAR(100), rpt_grd_19051 NVARCHAR(100), rpt_grd_19052 NVARCHAR(100),rpt_grd_19053 NVARCHAR(100),
			rpt_grd_19054 NVARCHAR(200),rpt_grd_19055 NVARCHAR(200),rpt_grd_19056 NVARCHAR(200),rpt_grd_19057 NVARCHAR(200),
			rpt_grd_19058 NVARCHAR(200),rpt_grd_19059  NVARCHAR(200),rpt_grd_19060 NVARCHAR(200),rpt_grd_19061 NVARCHAR(200),
			UserInfoID INT,
			UserInfoIdRelative NVARCHAR(200),SecurityTypeCodeId NVARCHAR(200)
			)	

		INSERT INTO  ##TempMasterWithDetails
			
		SELECT ISNULL(rpt_grd_19039,'-') AS rpt_grd_19039,tempDetails.UserName AS rpt_grd_19040,
		tempDetails.PanNumber as UserPANNumber,	DateOfSeperation, LiveOrSeperated,
		rpt_grd_19041, DateOfInactivation,
		ISNULL(rpt_grd_19042,'-') AS rpt_grd_19042,
		ISNULL(rpt_grd_19043,'-') AS rpt_grd_19043, ISNULL(rpt_grd_19044,'-') AS rpt_grd_19044, ISNULL(rpt_grd_19045,'-') AS rpt_grd_19045,
		ISNULL(rpt_grd_19046,'-') AS rpt_grd_19046,
		ISNULL(Category,'-') AS Category, 	 ISNULL(SubCategory,'-') AS SubCategory,  StatusCodeId,
		rpt_grd_19047, rpt_grd_19048, rpt_grd_19049,
		rpt_grd_19073,		
		rpt_grd_19051, rpt_grd_19052,rpt_grd_19053,
		ISNULL(tempDetails.UserName,'-') AS rpt_grd_19054,
		ISNULL(tempDetails.Relation,'-') as rpt_grd_19055,
		ISNULL(tempDetails.DEMATAccountNumber,'-') as rpt_grd_19056,
		rpt_grd_19047 as rpt_grd_19057,
		ISNULL(ISINNumber,'-') AS rpt_grd_19058,
		ISNULL(SecurityName,'-') as rpt_grd_19059,
		ISNULL(tmpSummary.ClosingBalance,0) AS rpt_grd_19060,
		ISNULL(tmpSummary.Value,0) AS rpt_grd_19061,
		tempMaster.UserInfoID AS UserInfoID,
		tempDetails.UserInfoIdRelative,tempDetails.SecurityTypeCodeId
		FROM #TempMaster tempMaster join #tmpUserTable tempDetails
			ON tempMaster.UserInfoId=tempDetails.UserInfoId
			left join tra_TransactionSummaryDMATWise tmpSummary on tmpSummary.DMATDetailsID=tempDetails.DMATDetailsID and tmpSummary.SecurityTypeCodeId=tempDetails.SecurityTypeCodeId
				 and tmpSummary.PeriodCodeId=tempDetails.periodcodeid and tmpSummary.YearCodeId=tempDetails.yearcodeid
					
			DROP TABLE #TempMaster
			DROP TABLE #tmpUserTable

			
			


		DROP TABLE #tmpPEDisclosure

		RETURN 0
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue	=  @ERR_IDEMPLOYEEWISE
	END CATCH
END
