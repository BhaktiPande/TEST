IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_rpt_InitialDisclosureEmployeeWiseSummary_OS')
DROP PROCEDURE dbo.st_rpt_InitialDisclosureEmployeeWiseSummary_OS
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[st_rpt_InitialDisclosureEmployeeWiseSummary_OS] 
	 @inp_sEmployeeID					NVARCHAR(50) = ''
	,@inp_sInsiderName					NVARCHAR(100) = ''
	,@inp_sPan							NVARCHAR(100) = ''
	,@inp_sCompanyName					NVARCHAR(200) = ''
	,@out_nReturnValue					INT = 0 OUTPUT
	,@out_nSQLErrCode					INT = 0 OUTPUT				-- Output SQL Error Number, if error occurred.
	,@out_sSQLErrMessage				VARCHAR(500) = '' OUTPUT  -- Output SQL Error Message, if error occurred.	
---------------------------------------------------------------------------
AS
BEGIN
	DECLARE @sSQL NVARCHAR(MAX)
	DECLARE @iCommentsId_Ok					INT = 162001
	DECLARE @iCommentsId_NotSubmittedInTime INT = 162002
	DECLARE @iCommentsId_NotSubmitted		INT = 162003
	DECLARE @sInsider						VARCHAR(20)	= ' Insider'
	DECLARE @tmpUserInfoId					INT = NULL

	SET NOCOUNT ON;
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''

DECLARE @tmpSecurities TABLE(SecurityTypeCodeId INT)

INSERT INTO @tmpSecurities
		SELECT CodeID
		FROM com_Code CSecurity 
		WHERE CSecurity.CodeGroupId = 139
			
	create table #tmpResult
	(
	ID INT IDENTITY (1,1),
	UserInfoId INT,
	TransactionMasterId INT,
	EmployeeId nvarchar(50),
	InsiderName nvarchar(50),
	InsiderFrom DATETIME,
	DateOfSeparation DATETIME,
	Status VARCHAR(50),
	CINDINNUMBER NVARCHAR(50),
	Designation NVARCHAR(500),
	Grade NVARCHAR(500),
	LOCATION NVARCHAR(500),
	Department NVARCHAR(500),
	Category NVARCHAR(500),
	SubCategory NVARCHAR(500),
	TradingCompanyName NVARCHAR(500),
	TypeOfInsider NVARCHAR(50),
	LastSubmissionDate datetime,
	Holding datetime,
	SoftCopy datetime,
	HardCopy datetime,
	SoftCopySubmissionDisplayText NVARCHAR(500),
	HardCopySubmissionDisplayText NVARCHAR(500),
	CommentId INT,
	DMATEAccount NVARCHAR(50),
	AccHolderName NVARCHAR(500),
	Relationwithinsider NVARCHAR(50),
	PAN NVARCHAR(50),
	ISIN NVARCHAR(50),
	SecurityType NVARCHAR(50),
	HoldingAMT NVARCHAR(500)
	)

	create table #tmpResultuser
	(
		ID INT IDENTITY (1,1),
		UserInfoId INT,
	)

SELECT @sSQL = 'SELECT UF.UserInfoId, TM.TransactionMasterId,
CASE WHEN UIR.UserInfoId IS NULL THEN UF.EmployeeId ELSE UF.EmployeeId END AS EmployeeId ,
UF.FirstName +'' ''+UF.LastName AS InsiderName ,
UF.DateOfBecomingInsider AS InsiderFrom ,
 UF.DateOfSeparation AS DateOfSeparation , 
 CStatus.CodeName AS Status,
CASE WHEN UF.UserTypeCodeId = 101004 THEN UF.CIN ELSE UF.DIN END AS CINDINNUMBER,
 CDesignation.CodeName AS Designation , CGrade.CodeName AS Grade , UF.Location AS LOCATION,
CDepartment.CodeName AS Department , CCategory.CodeName AS Category , CSubCategory.CodeName AS SubCategory, CM.CompanyName AS TradingCompanyName,
--CASE WHEN UIR.UserInfoId IS NULL THEN CUserType.CodeName ELSE CUserTypeRel.CodeName END AS TypeOfInsider,
CUserType.CodeName AS TypeOfInsider,
LastSubmissionDate = 
			CASE WHEN UF.DateOfBecomingInsider IS NULL THEN
									CASE WHEN UF.DateOfJoining <= TP.DiscloInitDateLimit  THEN DiscloInitDateLimit 
										ELSE DATEADD(D, DiscloInitLimit, UF.DateOfJoining) END
			ELSE CASE WHEN UF.DateOfBecomingInsider <= TP.DiscloInitDateLimit  THEN DiscloInitDateLimit 
										ELSE DATEADD(D, DiscloInitLimit, UF.DateOfBecomingInsider) END END,
vwIn.DetailsSubmitDate AS Holding ,
vwIn.ScpSubmitDate AS SoftCopy,
vwIn.HcpSubmitDate AS HardCopy, 
SoftCopySubmissionDisplayText = CASE WHEN vwIn.ScpSubmitStatus = 0 AND vwIn.DetailsSubmitStatus = 1 AND vwIn.SoftCopyReq = 1 THEN ''Pending'' 
									 WHEN vwIn.ScpSubmitStatus = 0 AND vwIn.DetailsSubmitStatus = 1 AND vwIn.SoftCopyReq = 0 THEN ''Not Required''
									 WHEN vwIn.ScpSubmitStatus = 1 THEN CONVERT(VARCHAR(max), UPPER(REPLACE(CONVERT(NVARCHAR, vwIn.ScpSubmitDate, 106),'' '',''/''))) ELSE ''-'' END,
HardCopySubmissionDisplayText = CASE WHEN vwIn.HcpSubmitStatus = 0 AND vwIn.ScpSubmitStatus = 1 AND vwIn.HardCopyReq = 1 THEN ''Pending'' 
									 WHEN vwIn.HcpSubmitStatus = 0 AND vwIn.ScpSubmitStatus = 1 AND vwIn.HardCopyReq = 0 THEN ''Not Required''
									 WHEN vwIn.HcpSubmitStatus = 0 AND vwIn.DetailsSubmitStatus = 1 AND vwIn.ScpSubmitStatus = 0 AND vwIn.SoftCopyReq = 0 THEN ''Not Required''
									 WHEN vwIn.HcpSubmitStatus = 1 THEN CONVERT(VARCHAR(max), UPPER(REPLACE(CONVERT(NVARCHAR, vwIn.HcpSubmitDate, 106),'' '',''/''))) ELSE ''-'' END,	'								 

SELECT @sSQL = @sSQL + 'null,DD.DEMATAccountNumber AS DMATEAccount,
UIF.FirstName + UIF.LastName AS AccHolderName ,
CASE WHEN UIF.UserTypeCodeId=101007 THEN CRelation.CodeName ELSE ''Self'' END AS Relationwithinsider,
CASE WHEN UIR.PAN IS NULL THEN UF.PAN ELSE UIR.PAN END AS PAN,
CM.ISINCode AS ISIN,
CSecurity.CodeName AS SecurityType,
TD.Quantity AS HoldingAMT from tra_TransactionDetails_OS TD INNER JOIN tra_TransactionMaster_OS TM ON TD.TransactionMasterId = TM.TransactionMasterId AND DisclosureTypeCodeId = 147001 '

SELECT @sSQL = @sSQL + 'JOIN usr_UserInfo UF ON UF.UserInfoId = TM.UserInfoId '
SELECT @sSQL = @sSQL + 'LEFT JOIN usr_UserRelation UR ON UR.UserInfoIdRelative = TD.ForUserInfoId '
SELECT @sSQL = @sSQL + 'LEFT JOIN usr_UserInfo UIR ON UIR.UserInfoId = UR.UserInfoIdRelative '
SELECT @sSQL = @sSQL + 'JOIN rul_TradingPolicy_OS TP ON TM.TradingPolicyId = TP.TradingPolicyId '
SELECT @sSQL = @sSQL + 'LEFT JOIN vw_InitialDisclosureStatus_OS vwIn ON UF.UserInfoId = vwIn.UserInfoId AND vwIn.TransactionMasterId = TD.TransactionMasterId '
SELECT @sSQL = @sSQL + 'LEFT JOIN usr_DMATDetails DD ON DD.DMATDetailsID = TD.DMATDetailsID '
SELECT @sSQL = @sSQL + 'LEFT JOIN rl_CompanyMasterList CM ON CM.RlCompanyId = TD.CompanyId '
SELECT @sSQL = @sSQL + 'LEFT JOIN com_Code CStatus ON CStatus.CodeID = UF.StatusCodeId '
SELECT @sSQL = @sSQL + 'LEFT JOIN com_Code CDesignation ON UF.DesignationId = CDesignation.CodeID '
SELECT @sSQL = @sSQL + 'LEFT JOIN com_Code CGrade ON UF.GradeId = CGrade.CodeID '
SELECT @sSQL = @sSQL + 'LEFT JOIN com_Code CDepartment ON UF.DepartmentId = CDepartment.CodeID '
SELECT @sSQL = @sSQL + 'LEFT JOIN com_Code CCategory ON CCategory.CodeID = UF.Category '
SELECT @sSQL = @sSQL + 'LEFT JOIN com_Code CSubCategory ON CSubCategory.CodeID = UF.SubCategory '
SELECT @sSQL = @sSQL + 'LEFT JOIN com_Code CUserType ON UF.UserTypeCodeId = CUserType.CodeID '
SELECT @sSQL = @sSQL + 'LEFT JOIN com_Code CUserTypeRel ON UIR.UserTypeCodeId = CUserTypeRel.CodeID '
SELECT @sSQL = @sSQL + 'LEFT JOIN com_Code CSecurity ON CSecurity.CodeID = TD.SecurityTypeCodeId '
SELECT @sSQL = @sSQL + 'LEFT JOIN com_Code CRelation ON UR.RelationTypeCodeId = CRelation.CodeID '
SELECT @sSQL = @sSQL + 'LEFT JOIN usr_DMATDetails DDS ON DDS.DMATDetailsID = TD.DMATDetailsID '
SELECT @sSQL = @sSQL + 'LEFT JOIN usr_UserInfo UIF ON UIF.UserInfoId = DDs.UserInfoID '
SELECT @sSQL = @sSQL + 'WHERE 1 = 1 '

IF (@inp_sEmployeeID IS NOT NULL AND @inp_sEmployeeID <> '')
			BEGIN
				print '@inp_sEmployeeID'
				SELECT @sSQL = @sSQL + ' AND UF.EmployeeId like  ''%' + @inp_sEmployeeID + '%'' '
			END
			IF (@inp_sInsiderName IS NOT NULL AND @inp_sInsiderName <> '')
			BEGIN
				print '@inp_sInsiderName'
				SELECT @sSQL = @sSQL + ' AND CASE WHEN UF.UserTypeCodeId = 101004 THEN CM.CompanyName ELSE ISNULL(UF.FirstName, '''') + '' '' + ISNULL(UF.LastName, '''') END like ''%' + @inp_sInsiderName + '%'''
			END
			IF (@inp_sPan IS NOT NULL AND @inp_sPan <> '')
			BEGIN
				print '@inp_sPan'
				--SELECT @sSQL = @sSQL + ' AND UF.PAN IN (' + @inp_sPan + ') '
				SELECT @sSQL = @sSQL + ' AND UF.PAN like ''%' + @inp_sPan + '%'' '
				
			END
			IF (@inp_sCompanyName IS NOT NULL AND @inp_sCompanyName <> '')
			BEGIN
				print '@inp_sCompanyName'
				SELECT @sSQL = @sSQL + ' AND CM.CompanyName like ''%' + @inp_sCompanyName + '%'''
			
			END

print(@sSQL)
insert into #tmpResult
EXEC (@sSQL)

UPDATE tmpTrans
		SET CommentId = 
		CASE WHEN UF.DateOfBecomingInsider IS NULL THEN
						 CASE WHEN UF.DateOfJoining <= TP.DiscloInitDateLimit THEN 
								CASE WHEN Holding IS NULL THEN @iCommentsId_NotSubmitted
									WHEN Holding <= DATEADD(D, 1, TP.DiscloInitDateLimit) THEN @iCommentsId_Ok 
									ELSE @iCommentsId_NotSubmittedInTime 
								END
							 WHEN UF.DateOfJoining > TP.DiscloInitDateLimit  THEN 
								CASE WHEN Holding IS NULL THEN @iCommentsId_NotSubmitted
									WHEN Holding <= DATEADD(D, DiscloInitLimit, UF.DateOfJoining) THEN @iCommentsId_Ok 
									ELSE @iCommentsId_NotSubmittedInTime 
								END
						END
			ELSE  CASE WHEN UF.DateOfBecomingInsider <= ISNULL(TP.DiscloInitDateLimit,UF.DateOfBecomingInsider) THEN   
								CASE WHEN Holding IS NULL THEN @iCommentsId_NotSubmitted
									WHEN Holding <= DATEADD(D, 1, TP.DiscloInitDateLimit) THEN @iCommentsId_Ok 
									ELSE @iCommentsId_NotSubmittedInTime 
								END
							 WHEN UF.DateOfBecomingInsider > TP.DiscloInitDateLimit  THEN 
								CASE WHEN Holding IS NULL THEN @iCommentsId_NotSubmitted
									WHEN Holding <= DATEADD(D, DiscloInitLimit, UF.DateOfBecomingInsider) THEN @iCommentsId_Ok 
									ELSE @iCommentsId_NotSubmittedInTime 
								END
						END END,
			LastSubmissionDate = 
			CASE WHEN UF.DateOfBecomingInsider IS NULL THEN
									CASE WHEN UF.DateOfJoining <= TP.DiscloInitDateLimit  THEN DiscloInitDateLimit 
										ELSE DATEADD(D, DiscloInitLimit, UF.DateOfJoining) END
			ELSE CASE WHEN UF.DateOfBecomingInsider <= TP.DiscloInitDateLimit  THEN DiscloInitDateLimit 
										ELSE DATEADD(D, DiscloInitLimit, UF.DateOfBecomingInsider) END END
		FROM #tmpResult tmpTrans 
		JOIN usr_UserInfo UF ON tmpTrans.UserInfoId = UF.UserInfoId
		JOIN tra_TransactionMaster_OS TM ON TM.TransactionMasterId = tmpTrans.TransactionMasterId
		JOIN rul_TradingPolicy_OS TP ON TM.TradingPolicyId = TP.TradingPolicyId

select distinct EmployeeId , dbo.uf_rpt_FormatDateValue(InsiderFrom,0) AS 'Insider From' , Status AS 'Status',TypeOfInsider AS 'Type Of Insider'
,dbo.uf_rpt_FormatDateValue(LastSubmissionDate,0) AS 'Last Submission Date',
CASE WHEN dbo.uf_rpt_FormatDateValue(Holding,1)  IS NULL THEN 'Not Required' ELSE dbo.uf_rpt_FormatDateValue(Holding,1) END AS Holdings,
dbo.uf_rpt_ReplaceSpecialChar(SoftCopySubmissionDisplayText) AS SoftCopy,
dbo.uf_rpt_ReplaceSpecialChar(HardCopySubmissionDisplayText)AS HardCopy,PAN,RComment.ResourceValue AS Comments
from #tmpResult tmpTrans JOIN com_Code CComment ON tmpTrans.CommentId = CComment.CodeID 
JOIN mst_Resource RComment ON CComment.CodeName = RComment.ResourceKey
where Relationwithinsider= 'self'
group by EmployeeId,InsiderFrom,Status,TypeOfInsider,LastSubmissionDate,Holding,SoftCopySubmissionDisplayText,HardCopySubmissionDisplayText,RComment.ResourceValue
,PAN
order by EmployeeId ASC
drop table #tmpResult

RETURN 0
END
	
	

