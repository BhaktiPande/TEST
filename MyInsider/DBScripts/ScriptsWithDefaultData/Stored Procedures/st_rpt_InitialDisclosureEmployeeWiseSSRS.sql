IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_rpt_InitialDisclosureEmployeeWiseSSRS')
DROP PROCEDURE [dbo].[st_rpt_InitialDisclosureEmployeeWiseSSRS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
Description:	Procedure to List data for Initial Disclosure wise report

Returns:		0, if Success.
				
Created by:		Tushar Wakchaure, Sanjay Patle
Created on:		19-Feb-2018
Usage:
EXEC 
-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_rpt_InitialDisclosureEmployeeWiseSSRS]
	 @inp_iPageSize						INT = 10
	,@inp_iPageNo						INT = 1
	,@inp_sSortField					VARCHAR(255)
	,@inp_sSortOrder					VARCHAR(5)
	,@inp_iUserInfoId					VARCHAR(MAX)
	,@inp_sEmployeeID					NVARCHAR(50)-- = 'GS1234'
	,@inp_sInsiderName					NVARCHAR(200) --= 's'
	,@inp_dtSubmissionDateFrom			DATETIME --= '2015-05-15'
	,@inp_dtSubmissionDateTo			DATETIME --= '2015-05-19'
	,@inp_sCommentsId					NVARCHAR(200) --= 162002,162001
	,@inp_sUserPAN                      NVARCHAR(MAX)
	,@inp_sCategory                     NVARCHAR(MAX)
	,@inp_sEmpStatus                    NVARCHAR(MAX)
	,@inp_sEmpSepOrLive                 NVARCHAR(MAX)
	,@out_nReturnValue					INT = 0 OUTPUT
	,@out_nSQLErrCode					INT = 0 OUTPUT				-- Output SQL Error Number, if error occurred.
	,@out_sSQLErrMessage				VARCHAR(500) = '' OUTPUT  -- Output SQL Error Message, if error occurred.	
---------------------------------------------------------------------------
AS
BEGIN
	DECLARE @ERR_IDEMPLOYEEWISE INT = -1
	
	DECLARE @sSQL                           NVARCHAR(MAX)
	DECLARE @dtImplementation               DATETIME = '2015-01-01'
	DECLARE @iCommentsId_Ok					INT = 162001
	DECLARE @iCommentsId_NotSubmittedInTime INT = 162002
	DECLARE @iCommentsId_NotSubmitted		INT = 162003
	DECLARE @iIsTransCriteria				INT = 0
	DECLARE @nInsiderFlag_Insider			INT = 173001
	DECLARE @nInsiderFlag_NonInsider		INT = 173002
	DECLARE @sInsider                       VARCHAR(20)= ' Insider'
	
	
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
			
			
	CREATE TABLE #tmpInitialDisclosure(UserInfoId INT, EmployeeId NVARCHAR(50), InsiderName  NVARCHAR(100), UserPAN NVARCHAR(MAX),SeperationDate DATETIME,
	JoiningDate DATETIME, CINNumber NVARCHAR(100), Designation NVARCHAR(100), Grade NVARCHAR(100), Location NVARCHAR(50),
	Department NVARCHAR(100), CompanyName NVARCHAR(200), TypeOfInsider NVARCHAR(50), SubmissionDate DATETIME, LastSubmissionDate DATETIME,
	SoftCopySubmissionDate DATETIME, HardCopySubmissionDate DATETIME, CommentId INT DEFAULT 162003, TransactionMasterId INT,
	DateOfInactivation DATETIME, Category VARCHAR(MAX), SubCategory  VARCHAR(500), CodeName VARCHAR(MAX), LiveSeperated VARCHAR(MAX),
	SoftCopySubmissionDisplayText NVARCHAR(500),HardCopySubmissionDisplayText NVARCHAR(500))

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
		ELSE IF @inp_sSortField = 'UserPANNumber'
		BEGIN
			SET @inp_sSortField = 'UserPAN'
		END	
		ELSE IF @inp_sSortField = 'Category'
		BEGIN
			SET @inp_sSortField = 'Category'
		END
		ELSE IF @inp_sSortField = 'CodeName'
		BEGIN
			SET @inp_sSortField = 'CodeName'
		END	
		ELSE IF @inp_sSortField = 'LiveOrSeperated'
		BEGIN
			SET @inp_sSortField = 'LiveSeperated'
		END			
		ELSE IF @inp_sSortField = 'rpt_grd_19014'
		BEGIN
			SET @inp_sSortField = 'SubmissionDate'
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
		SELECT @sSQL = @sSQL + 'LEFT JOIN com_Code CCategory ON CCategory.CodeID = UF.Category '
		SELECT @sSQL = @sSQL + 'LEFT JOIN com_Code CCode ON CCode.CodeID = UF.StatusCodeId '
		SELECT @sSQL = @sSQL + 'LEFT JOIN com_Code CDepartment ON UF.DepartmentId = CDepartment.CodeID '
		SELECT @sSQL = @sSQL + 'WHERE 1 = 1 '
		--SELECT @sSQL = @sSQL + 'AND DateOfBecomingInsider <= dbo.uf_com_GetServerDate() AND (DateOfSeparation IS NULL OR dbo.uf_com_GetServerDate() <= DateOfSeparation) '
		SELECT @sSQL = @sSQL + 'AND (((DateOfBecomingInsider IS NULL OR DateOfBecomingInsider > dbo.uf_com_GetServerDate()) AND UserTypeCodeId = 101003) OR (DateOfBecomingInsider <= dbo.uf_com_GetServerDate() )) '
				
		IF ((@inp_iUserInfoId IS NOT NULL AND @inp_iUserInfoId <> '0')
		  OR (@inp_sEmployeeID IS NOT NULL AND @inp_sEmployeeID <> '')
		  OR (@inp_sInsiderName IS NOT NULL AND @inp_sInsiderName <> '')  
		  OR (@inp_sUserPAN IS NOT NULL AND @inp_sUserPAN <> '')	  
		  OR (@inp_sCategory IS NOT NULL AND @inp_sCategory <> '')
		  OR (@inp_sEmpStatus IS NOT NULL AND @inp_sEmpStatus <> '0'))
		BEGIN
			IF (@inp_iUserInfoId IS NOT NULL AND @inp_iUserInfoId <> '0')
			BEGIN
				SELECT @sSQL = @sSQL + ' AND UserInfoId IN (SELECT [PARAM] FROM FN_VIGILANTE_SPLIT(''' + @inp_iUserInfoId + ''', '',''))'
			END
			IF (@inp_sEmployeeID IS NOT NULL AND @inp_sEmployeeID <> '')
			BEGIN
				SELECT @sSQL = @sSQL + ' AND EmployeeId like ''%' + @inp_sEmployeeID + '%'''
			END
  			IF (@inp_sInsiderName IS NOT NULL AND @inp_sInsiderName <> '')
			BEGIN
				SELECT @sSQL = @sSQL + ' AND CASE WHEN UserTypeCodeId = 101004 THEN C.CompanyName ELSE ISNULL(FirstName, '''') + '' '' + ISNULL(LastName, '''') END like ''%' + @inp_sInsiderName + '%'''
			END			
			IF (@inp_sUserPAN IS NOT NULL AND @inp_sUserPAN <> '')
			BEGIN
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
			
		END

		print 'Query1 = ' + @sSQL

		INSERT INTO #tmpInitialDisclosure(UserInfoId)
		EXEC (@sSQL)
			
		SELECT @sSQL = 'SELECT TransactionMasterId, UserInfoId FROM vw_InitialDisclosureStatus WHERE 1 = 1 '

		IF ((@inp_dtSubmissionDateFrom IS NOT NULL AND @inp_dtSubmissionDateFrom <> '')
			AND (@inp_dtSubmissionDateTo IS NOT NULL AND @inp_dtSubmissionDateTo <> ''))
		BEGIN
		    SET @iIsTransCriteria = 1
		    SELECT @sSQL = @sSQL + 'AND DetailsSubmitDate BETWEEN CONVERT(DATETIME, ''' + CONVERT(VARCHAR(11), @inp_dtSubmissionDateFrom) + ''') AND CONVERT(DATETIME, ''' + CONVERT(VARCHAR(11), @inp_dtSubmissionDateTo) + ''') '
		END

		print 'Query2 = ' + @sSQL

		INSERT INTO @tmpTransactionIds(TransactionMasterId, UserInfoId)
		EXEC (@sSQL)
				
		IF @iIsTransCriteria = 1
		BEGIN
			DELETE tmpDisc
			FROM #tmpInitialDisclosure tmpDisc LEFT JOIN @tmpTransactionIds tmpTrans ON tmpDisc.UserInfoId = tmpTrans.UserInfoId
			WHERE tmpTrans.UserInfoId IS NULL
		END

		UPDATE tmpDisc 
			SET
			EmployeeId = UF.EmployeeId,
			InsiderName = CASE WHEN UserTypeCodeId = 101004 THEN C.CompanyName ELSE ISNULL(FirstName, '') + ' ' + ISNULL(LastName, '') END,
			UserPAN = UF.pan,
			SeperationDate = UF.DateOfSeparation,
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
			Category =ISNULL(CCategory.DisplayCode,CCategory.CodeName),
			SubCategory = CSubCategory.CodeName,
			CodeName = CCode.CodeName,
			LiveSeperated =  CASE WHEN UF.StatusCodeId = @nEmployeeActive AND UF.DateOfSeparation IS NULL THEN @nEmployeeStatusLive
				        WHEN UF.StatusCodeId = @nEmployeeActive AND UF.DateOfSeparation IS NOT NULL  THEN @nEmployeeStatusSeparated
				        WHEN UF.StatusCodeId = @nEmployeeInActive THEN @nEmployeeStatusSeparated
				        END,
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
	
		SELECT @sSQL = 'INSERT INTO #tmpList(RowNumber, EntityID) '
		SELECT @sSQL = @sSQL + 'SELECT DISTINCT DENSE_RANK() OVER(Order BY ' + @inp_sSortField + ' ' + @inp_sSortOrder +',UserInfoId),UserInfoId ' 
		SELECT @sSQL = @sSQL + 'FROM #tmpInitialDisclosure ID '
		SELECT @sSQL = @sSQL + 'JOIN com_Code CComment ON ID.CommentId = CComment.CodeID '
		SELECT @sSQL = @sSQL + 'JOIN mst_Resource RComment ON CComment.CodeName = RComment.ResourceKey '
		
		print @sSQL
		EXEC (@sSQL)
	
		SELECT @sSQL = 'SELECT '
		SELECT @sSQL = @sSQL + 'ISNULL(EmployeeId,''-'') AS rpt_grd_19004, '
		SELECT @sSQL = @sSQL + 'dbo.uf_rpt_ReplaceSpecialChar(InsiderName) AS rpt_grd_19005, '
		SELECT @sSQL = @sSQL + 'dbo.uf_rpt_FormatValue(CONVERT(VARCHAR(max),UserPAN),1) AS UserPANNumber, '	
		SELECT @sSQL = @sSQL + 'dbo.uf_rpt_FormatDateValue(SeperationDate,0) AS DateOfSeperation, '
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
		
		--SELECT @sSQL = @sSQL + 'dbo.uf_rpt_FormatDateValue(SoftCopySubmissionDate,1) AS rpt_grd_19015, '--'SoftCopySubmissionDate AS rpt_grd_19015, '
		--SELECT @sSQL = @sSQL + 'dbo.uf_rpt_FormatDateValue(HardCopySubmissionDate,1) AS rpt_grd_19016, '--'HardCopySubmissionDate AS rpt_grd_19016, '
		
		SELECT @sSQL = @sSQL + ' dbo.uf_rpt_ReplaceSpecialChar(SoftCopySubmissionDisplayText) AS rpt_grd_19015, '
		SELECT @sSQL = @sSQL + ' dbo.uf_rpt_ReplaceSpecialChar(HardCopySubmissionDisplayText) AS rpt_grd_19016, '
		
		SELECT @sSQL = @sSQL + 'dbo.uf_rpt_ReplaceSpecialChar(RComment.ResourceValue) AS rpt_grd_19017, '
		SELECT @sSQL = @sSQL + 'ID.UserInfoID As UserInfoID , ''151001'' AS LetterForCodeId,ID.TransactionMasterId AS TransactionMasterId, ID.UserInfoID AS EmployeeId,''0'' AS TransactionLetterId,''147001'' AS DisclosureTypeCodeId,''166'' AS Acid, dbo.uf_rpt_FormatDateValue(ID.DateOfInactivation,0) AS DateOfInactivation , dbo.uf_rpt_ReplaceSpecialChar(ID.Category) as Category  , dbo.uf_rpt_ReplaceSpecialChar(ID.SubCategory) As SubCategory , dbo.uf_rpt_ReplaceSpecialChar(ID.CodeName) As CodeName, '	
		SELECT @sSQL = @sSQL + 'dbo.uf_rpt_ReplaceSpecialChar(LiveSeperated) AS LiveOrSeperated '		
				
		SELECT @sSQL = @sSQL + 'FROM #tmpList t JOIN #tmpInitialDisclosure ID ON t.EntityID = ID.UserInfoId '
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


		SELECT @sSQL = @sSQL + 'AND ((' + CONVERT(VARCHAR(10), @inp_iPageSize) + ' = 0) '
		SELECT @sSQL = @sSQL + 'OR (T.RowNumber BETWEEN ((' + CONVERT(VARCHAR(10), @inp_iPageNo) + ' - 1) * ' + CONVERT(VARCHAR(10), @inp_iPageSize) + ' + 1) '
		SELECT @sSQL = @sSQL + 'AND (' + CONVERT(VARCHAR(10), @inp_iPageNo) +  ' * ' + CONVERT(VARCHAR(10), @inp_iPageSize) + '))) '
		SELECT @sSQL = @sSQL + 'ORDER BY T.RowNumber '
		
		--print @sSQL


		CREATE TABLE ##TempMaster (	rpt_grd_19004 NVARCHAR(200),rpt_grd_19005 NVARCHAR(200), UserPANNumber NVARCHAR(MAX),DateOfSeperation VARCHAR(200),rpt_grd_19006 NVARCHAR(200),rpt_grd_19007 NVARCHAR(200),
		rpt_grd_19008 NVARCHAR(200),rpt_grd_19009 NVARCHAR(200),rpt_grd_19010 NVARCHAR(200),rpt_grd_19011 NVARCHAR(200),rpt_grd_19012 NVARCHAR(200),
		rpt_grd_19013 NVARCHAR(200),rpt_grd_19072 NVARCHAR(200),rpt_grd_19073 NVARCHAR(200),rpt_grd_19015  NVARCHAR(200),rpt_grd_19016  NVARCHAR(200),rpt_grd_19017  NVARCHAR(200),
		UserInfoID INT,LetterForCodeId NVARCHAR(100),TransactionMasterId NVARCHAR(100),EmployeeId  NVARCHAR(100),TransactionLetterId NVARCHAR(100),	DisclosureTypeCodeId NVARCHAR(100),	Acid int,	DateOfInactivation	 NVARCHAR(200),	Category NVARCHAR(MAX),	SubCategory NVARCHAR(500),CodeName NVARCHAR(MAX),LiveOrSeperated NVARCHAR(MAX),
		)
		INSERT INTO ##TempMaster
		(
		rpt_grd_19004,rpt_grd_19005,UserPANNumber,DateOfSeperation,rpt_grd_19006 ,rpt_grd_19007 ,
		rpt_grd_19008 ,rpt_grd_19009 ,rpt_grd_19010 ,rpt_grd_19011 ,rpt_grd_19012 ,
		rpt_grd_19013,rpt_grd_19072 ,rpt_grd_19073 ,rpt_grd_19015,rpt_grd_19016,rpt_grd_19017,
		UserInfoID,LetterForCodeId,TransactionMasterId,EmployeeId,TransactionLetterId,DisclosureTypeCodeId,Acid,DateOfInactivation,Category,SubCategory,CodeName,LiveOrSeperated
		)
		EXEC (@sSQL)
	
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


