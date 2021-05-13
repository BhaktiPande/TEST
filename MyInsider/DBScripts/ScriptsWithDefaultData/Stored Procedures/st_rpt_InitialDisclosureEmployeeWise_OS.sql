IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_rpt_InitialDisclosureEmployeeWise_OS')
DROP PROCEDURE dbo.st_rpt_InitialDisclosureEmployeeWise_OS
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[st_rpt_InitialDisclosureEmployeeWise_OS] 
	 @inp_sEmployeeID					NVARCHAR(50) = ''
	,@inp_sInsiderName					NVARCHAR(100) = ''
	,@inp_sPan							NVARCHAR(100) = ''
	,@inp_sCompanyName					NVARCHAR(200) = ''
	,@EnableDisableQuantityValue        INT = 400001
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
	InsiderName nvarchar(100),
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

INSERT INTO #tmpResult
SELECT UF.UserInfoId, TM.TransactionMasterId,
CASE WHEN UF.EmployeeId IS NULL THEN UIR.EmployeeId ELSE UF.EmployeeId END AS EmployeeId,
CASE WHEN UIR.UserInfoId IS NULL THEN UF.FirstName +' '+UF.LastName ELSE UIR.FirstName +' '+UIR.LastName END AS InsiderName,
CASE WHEN UIR.UserInfoId IS NULL THEN UF.DateOfBecomingInsider ELSE UIR.DateOfBecomingInsider END,
 UF.DateOfSeparation, 
 CStatus.CodeName,
CASE WHEN UIR.UserInfoId IS NULL THEN UF.DIN ELSE UIR.DIN END,
 CASE WHEN UIR.UserInfoId IS NULL THEN UF.DesignationId ELSE UIR.DesignationId END,
 CASE WHEN UIR.UserInfoId IS NULL THEN UF.GradeId ELSE UIR.GradeId END,
CASE WHEN UIR.UserInfoId IS NULL THEN UF.Location ELSE UIR.Location END,
CASE WHEN UIR.UserInfoId IS NULL THEN UF.DepartmentId ELSE UIR.DepartmentId END,
CASE WHEN UIR.UserInfoId IS NULL THEN UF.Category ELSE UIR.Category END, 
CASE WHEN UIR.UserInfoId IS NULL THEN UF.SubCategory ELSE UIR.SubCategory END , 
CM.CompanyName,
CUserType.CodeName,
CASE WHEN UIR.UserInfoId IS NULL THEN 

			CASE WHEN UF.DateOfBecomingInsider IS NULL THEN
									CASE WHEN UF.DateOfJoining <= TP.DiscloInitDateLimit  THEN DiscloInitDateLimit 
										ELSE DATEADD(D, DiscloInitLimit, UF.DateOfJoining) END
			ELSE CASE WHEN UF.DateOfBecomingInsider <= TP.DiscloInitDateLimit  THEN DiscloInitDateLimit 
										ELSE DATEADD(D, DiscloInitLimit, UF.DateOfBecomingInsider) END END 
ELSE 
			CASE WHEN UIR.DateOfBecomingInsider IS NULL THEN
									CASE WHEN UIR.DateOfJoining <= TP.DiscloInitDateLimit  THEN DiscloInitDateLimit 
										ELSE DATEADD(D, DiscloInitLimit, UIR.DateOfJoining) END
			ELSE CASE WHEN UIR.DateOfBecomingInsider <= TP.DiscloInitDateLimit  THEN DiscloInitDateLimit 
										ELSE DATEADD(D, DiscloInitLimit, UIR.DateOfBecomingInsider) END END
END,			
vwIn.DetailsSubmitDate,
vwIn.ScpSubmitDate,
vwIn.HcpSubmitDate, 
SoftCopySubmissionDisplayText = CASE WHEN vwIn.ScpSubmitStatus = 0 AND vwIn.DetailsSubmitStatus = 1 AND vwIn.SoftCopyReq = 1 THEN 'Pending' 
									 WHEN vwIn.ScpSubmitStatus = 0 AND vwIn.DetailsSubmitStatus = 1 AND vwIn.SoftCopyReq = 0 THEN 'Not Required'
									 WHEN vwIn.ScpSubmitStatus = 1 THEN CONVERT(VARCHAR(max), UPPER(REPLACE(CONVERT(NVARCHAR, vwIn.ScpSubmitDate, 106),' ','/'))) ELSE '-' END,
HardCopySubmissionDisplayText = CASE WHEN vwIn.HcpSubmitStatus = 0 AND vwIn.ScpSubmitStatus = 1 AND vwIn.HardCopyReq = 1 THEN 'Pending' 
									 WHEN vwIn.HcpSubmitStatus = 0 AND vwIn.ScpSubmitStatus = 1 AND vwIn.HardCopyReq = 0 THEN 'Not Required'
									 WHEN vwIn.HcpSubmitStatus = 0 AND vwIn.DetailsSubmitStatus = 1 AND vwIn.ScpSubmitStatus = 0 AND vwIn.SoftCopyReq = 0 THEN 'Not Required'
									 WHEN vwIn.HcpSubmitStatus = 1 THEN CONVERT(VARCHAR(max), UPPER(REPLACE(CONVERT(NVARCHAR, vwIn.HcpSubmitDate, 106),' ','/'))) ELSE '-' END, 							 
null,DD.DEMATAccountNumber,
UIF.FirstName +' '+ UIF.LastName,
CASE WHEN UF.UserTypeCodeId=101007 THEN CRelation.CodeName ELSE 'Self' END,
UF.PAN,
CM.ISINCode,
CSecurity.CodeName,
TD.Quantity from tra_TransactionDetails_OS TD INNER JOIN tra_TransactionMaster_OS TM ON TD.TransactionMasterId = TM.TransactionMasterId AND DisclosureTypeCodeId = 147001 
LEFT JOIN usr_UserRelation UR ON UR.UserInfoIdRelative = TD.ForUserInfoId
LEFT JOIN usr_UserInfo UF ON UF.UserInfoId = TD.ForUserInfoId
LEFT JOIN usr_UserInfo UF1 ON UF1.UserInfoId = TM.UserInfoId 
LEFT JOIN usr_UserInfo UIR ON UIR.UserInfoId = UR.UserInfoId 
JOIN rul_TradingPolicy_OS TP ON TM.TradingPolicyId = TP.TradingPolicyId 
LEFT JOIN usr_DMATDetails DD ON DD.DMATDetailsID = TD.DMATDetailsID 
LEFT JOIN vw_InitialDisclosureStatus_OS vwIn ON (UF.UserInfoId = vwIn.UserInfoId OR UIR.UserInfoId = vwIn.UserInfoId) AND vwIn.TransactionMasterId = TD.TransactionMasterId 
LEFT JOIN rl_CompanyMasterList CM ON CM.RlCompanyId = TD.CompanyId 
LEFT JOIN com_Code CStatus ON CStatus.CodeID = UF.StatusCodeId 
LEFT JOIN com_Code CUserType ON UF.UserTypeCodeId = CUserType.CodeID 
LEFT JOIN com_Code CUserTypeRel ON UIR.UserTypeCodeId = CUserTypeRel.CodeID 
LEFT JOIN com_Code CSecurity ON CSecurity.CodeID = TD.SecurityTypeCodeId 
LEFT JOIN com_Code CRelation ON UR.RelationTypeCodeId = CRelation.CodeID 
LEFT JOIN usr_DMATDetails DDS ON DDS.DMATDetailsID = TD.DMATDetailsID 
LEFT JOIN usr_UserInfo UIF ON UIF.UserInfoId = DDs.UserInfoID 
WHERE 1 = 1 
			
UNION 

SELECT UF.UserInfoId, NULL,
UF.EmployeeId ,UF.FirstName +' '+ UF.LastName AS InsiderName,UF.DateOfBecomingInsider,UF.DateOfSeparation, CStatus.CodeName,UF.DIN,
UF.DesignationId,UF.GradeId,UF.Location,UF.DepartmentId,UF.Category, UF.SubCategory, NULL,CUserType.CodeName,NULL,NULL,NULL,NULL, NULL,NULL,		 
null,DD.DEMATAccountNumber,UIF.FirstName +' '+ UIF.LastName,CASE WHEN UIF.UserTypeCodeId=101007 THEN CRelation.CodeName ELSE 'Self' END,
UIF.PAN,
NULL,
NULL,
NULL 
from usr_UserInfo UF 
LEFT JOIN usr_UserRelation UR ON UF.UserInfoId = UR.UserInfoId
LEFT JOIN usr_UserInfo UIF ON UIF.UserInfoId = UR.UserInfoIdRelative
LEFT JOIN usr_DMATDetails DD ON UIF.UserInfoId = DD.UserInfoID 
LEFT JOIN com_Code CStatus ON CStatus.CodeID = UF.StatusCodeId 
LEFT JOIN com_Code CUserType ON UIF.UserTypeCodeId = CUserType.CodeID 
LEFT JOIN com_Code CRelation ON UR.RelationTypeCodeId = CRelation.CodeID 
WHERE
DD.DMATDetailsID NOT IN (SELECT DMATDetailsID from tra_TransactionDetails_OS where ForUserInfoId = UIF.UserInfoId)

UNION 

SELECT UF.UserInfoId, NULL,
UF.EmployeeId AS EmployeeId,UF.FirstName +' '+ UF.LastName AS InsiderName,UF.DateOfBecomingInsider,UF.DateOfSeparation, CStatus.CodeName,UF.DIN,
UF.DesignationId,UF.GradeId,UF.Location,UF.DepartmentId,UF.Category, UF.SubCategory, NULL,CUserType.CodeName,NULL,NULL,NULL,NULL, NULL,NULL,		 
null,DD.DEMATAccountNumber,UF.FirstName +' '+UF.LastName, 'Self',
UF.PAN,
NULL,
NULL,
NULL 
from usr_UserInfo UF 
LEFT JOIN usr_DMATDetails DD ON UF.UserInfoId = DD.UserInfoID 
LEFT JOIN com_Code CStatus ON CStatus.CodeID = UF.StatusCodeId 
LEFT JOIN com_Code CUserType ON UF.UserTypeCodeId = CUserType.CodeID 
WHERE 
DD.DMATDetailsID NOT IN (SELECT DMATDetailsID from tra_TransactionDetails_OS where ForUserInfoId = UF.UserInfoId)

UPDATE tmpTrans
		SET CommentId = 
						CASE WHEN InsiderFrom <= ISNULL(TP.DiscloInitDateLimit,InsiderFrom) THEN   
								CASE WHEN Holding IS NULL THEN @iCommentsId_NotSubmitted
									WHEN Holding <= DATEADD(D, 1, TP.DiscloInitDateLimit) THEN @iCommentsId_Ok 
									ELSE @iCommentsId_NotSubmittedInTime 
								END
							 WHEN InsiderFrom > TP.DiscloInitDateLimit  THEN 
								CASE WHEN Holding IS NULL THEN @iCommentsId_NotSubmitted
									WHEN Holding <= DATEADD(D, DiscloInitLimit, InsiderFrom) THEN @iCommentsId_Ok 
									ELSE @iCommentsId_NotSubmittedInTime 
								END
						END
		FROM #tmpResult tmpTrans 
		JOIN tra_TransactionMaster_OS TM ON TM.TransactionMasterId = tmpTrans.TransactionMasterId
		JOIN rul_TradingPolicy_OS TP ON TM.TradingPolicyId = TP.TradingPolicyId
	
UPDATE tmpTrans
		SET CommentId =@iCommentsId_NotSubmitted FROM #tmpResult tmpTrans WHERE Holding IS NULL

IF(@EnableDisableQuantityValue = 400003)
 BEGIN
 	  SELECT @sSQL = 'SELECT EmployeeId AS [Employee Id] , InsiderName AS [Insider Name],  dbo.uf_rpt_FormatDateValue(InsiderFrom,0) AS [Insider From] , dbo.uf_rpt_FormatDateValue(DateOfSeparation,0)  AS [Date Of Separation] , Status AS [Status],
 	CINDINNUMBER AS [CIN/DIN Number] , CDesignation.CodeName AS [Designation]  ,CGrade.CodeName AS [Grade] , LOCATION AS [Location],
 	CDepartment.CodeName AS [Department] , CCategory.CodeName AS [Category] , CSubCategory.CodeName AS [SubCategory],TypeOfInsider AS [Type Of Insider],
 	dbo.uf_rpt_FormatDateValue(LastSubmissionDate,0) AS [Last Submission Date],
 	CASE WHEN dbo.uf_rpt_FormatDateValue(Holding,1)  IS NULL THEN ''Not Required'' ELSE dbo.uf_rpt_FormatDateValue(Holding,1) END AS [Holdings],
 	dbo.uf_rpt_FormatValue(dbo.uf_rpt_ReplaceSpecialChar(SoftCopySubmissionDisplayText),1) AS [SoftCopy],
 	dbo.uf_rpt_FormatValue(dbo.uf_rpt_ReplaceSpecialChar(HardCopySubmissionDisplayText),1) AS [HardCopy],
 	RComment.ResourceValue AS [Comments],dbo.uf_rpt_FormatValue(DMATEAccount,1) AS [DMATE Account Number],AccHolderName AS [Account Holder Name] ,
 	Relationwithinsider AS [Relation with insider],PAN,dbo.uf_rpt_FormatValue(ISIN,1) AS [ISIN],dbo.uf_rpt_FormatValue(SecurityType,1) AS [Security Type] ,
 	dbo.uf_rpt_FormatValue(TradingCompanyName,1) AS [Trading Company Name]'
 	SELECT @sSQL = @sSQL + 'from #tmpResult tmpTrans JOIN com_Code CComment ON tmpTrans.CommentId = CComment.CodeID '
 	SELECT @sSQL = @sSQL + 'JOIN mst_Resource RComment ON CComment.CodeName = RComment.ResourceKey '
 	SELECT @sSQL = @sSQL + 'LEFT JOIN com_Code CDesignation ON tmpTrans.Designation = CDesignation.CodeID '
 	SELECT @sSQL = @sSQL + 'LEFT JOIN com_Code CGrade ON tmpTrans.Grade = CGrade.CodeID '
 	SELECT @sSQL = @sSQL + 'LEFT JOIN com_Code CDepartment ON tmpTrans.Department = CDepartment.CodeID '
 	SELECT @sSQL = @sSQL + 'LEFT JOIN com_Code CCategory ON  tmpTrans.Category= CCategory.CodeID '
 	SELECT @sSQL = @sSQL + 'LEFT JOIN com_Code CSubCategory ON  tmpTrans.SubCategory= CSubCategory.CodeID '
 	SELECT @sSQL = @sSQL + 'WHERE 1 = 1 '
 	IF (@inp_sEmployeeID IS NOT NULL AND @inp_sEmployeeID <> '')
 		BEGIN
 			print '@inp_sEmployeeID'
 			SELECT @sSQL = @sSQL + ' AND tmpTrans.EmployeeId like ''%'+@inp_sEmployeeID+'%'' '	
 		END
 				
 	IF (@inp_sInsiderName IS NOT NULL AND @inp_sInsiderName <> '')
 		BEGIN
 			print '@inp_sInsiderName'
 			SELECT @sSQL = @sSQL + ' AND tmpTrans.InsiderName like ''%' + @inp_sInsiderName + '%'' '
 		END
 	IF (@inp_sPan IS NOT NULL AND @inp_sPan <> '')
 		BEGIN
 			print '@inp_sPan'
 			SELECT @sSQL = @sSQL + ' AND tmpTrans.PAN like ''%' + @inp_sPan + '%'' '
 		END
 	IF (@inp_sCompanyName IS NOT NULL AND @inp_sCompanyName <> '')
 		BEGIN
 			print '@inp_sCompanyName' 
 			SELECT @sSQL = @sSQL + ' AND tmpTrans.TradingCompanyName like ''%' + @inp_sCompanyName + '%'' '
 		END
 	SELECT @sSQL = @sSQL + 'order by EmployeeId ASC, TypeOfInsider ASC'
 END
ELSE
 BEGIN
	SELECT @sSQL = 'SELECT EmployeeId AS [Employee Id] , InsiderName AS [Insider Name],  dbo.uf_rpt_FormatDateValue(InsiderFrom,0) AS [Insider From] , dbo.uf_rpt_FormatDateValue(DateOfSeparation,0)  AS [Date Of Separation] , Status AS [Status],
	CINDINNUMBER AS [CIN/DIN Number] , CDesignation.CodeName AS [Designation]  ,CGrade.CodeName AS [Grade] , LOCATION AS [Location],
	CDepartment.CodeName AS [Department] , CCategory.CodeName AS [Category] , CSubCategory.CodeName AS [SubCategory],TypeOfInsider AS [Type Of Insider],
	dbo.uf_rpt_FormatDateValue(LastSubmissionDate,0) AS [Last Submission Date],
	CASE WHEN dbo.uf_rpt_FormatDateValue(Holding,1)  IS NULL THEN ''Not Required'' ELSE dbo.uf_rpt_FormatDateValue(Holding,1) END AS [Holdings],
	dbo.uf_rpt_FormatValue(dbo.uf_rpt_ReplaceSpecialChar(SoftCopySubmissionDisplayText),1) AS [SoftCopy],
	dbo.uf_rpt_FormatValue(dbo.uf_rpt_ReplaceSpecialChar(HardCopySubmissionDisplayText),1) AS [HardCopy],
	RComment.ResourceValue AS [Comments],dbo.uf_rpt_FormatValue(DMATEAccount,1) AS [DMATE Account Number],AccHolderName AS [Account Holder Name] ,
	Relationwithinsider AS [Relation with insider],PAN,dbo.uf_rpt_FormatValue(ISIN,1) AS [ISIN],dbo.uf_rpt_FormatValue(SecurityType,1) AS [Security Type] ,
	dbo.uf_rpt_FormatValue(TradingCompanyName,1) AS [Trading Company Name], dbo.uf_rpt_FormatValue(HoldingAMT,1) AS [Holding Qty]'
	SELECT @sSQL = @sSQL + 'from #tmpResult tmpTrans JOIN com_Code CComment ON tmpTrans.CommentId = CComment.CodeID '
	SELECT @sSQL = @sSQL + 'JOIN mst_Resource RComment ON CComment.CodeName = RComment.ResourceKey '
	SELECT @sSQL = @sSQL + 'LEFT JOIN com_Code CDesignation ON tmpTrans.Designation = CDesignation.CodeID '
	SELECT @sSQL = @sSQL + 'LEFT JOIN com_Code CGrade ON tmpTrans.Grade = CGrade.CodeID '
	SELECT @sSQL = @sSQL + 'LEFT JOIN com_Code CDepartment ON tmpTrans.Department = CDepartment.CodeID '
	SELECT @sSQL = @sSQL + 'LEFT JOIN com_Code CCategory ON  tmpTrans.Category= CCategory.CodeID '
	SELECT @sSQL = @sSQL + 'LEFT JOIN com_Code CSubCategory ON  tmpTrans.SubCategory= CSubCategory.CodeID '
	SELECT @sSQL = @sSQL + 'WHERE 1 = 1 '
	IF (@inp_sEmployeeID IS NOT NULL AND @inp_sEmployeeID <> '')
		BEGIN
			print '@inp_sEmployeeID'
			SELECT @sSQL = @sSQL + ' AND tmpTrans.EmployeeId like ''%'+@inp_sEmployeeID+'%'' '	
		END
				
	IF (@inp_sInsiderName IS NOT NULL AND @inp_sInsiderName <> '')
		BEGIN
			print '@inp_sInsiderName'
			SELECT @sSQL = @sSQL + ' AND tmpTrans.InsiderName like ''%' + @inp_sInsiderName + '%'' '
		END
	IF (@inp_sPan IS NOT NULL AND @inp_sPan <> '')
		BEGIN
			print '@inp_sPan'
			SELECT @sSQL = @sSQL + ' AND tmpTrans.PAN like ''%' + @inp_sPan + '%'' '
		END
	IF (@inp_sCompanyName IS NOT NULL AND @inp_sCompanyName <> '')
		BEGIN
			print '@inp_sCompanyName' 
			SELECT @sSQL = @sSQL + ' AND tmpTrans.TradingCompanyName like ''%' + @inp_sCompanyName + '%'' '
		END
	SELECT @sSQL = @sSQL + 'order by EmployeeId ASC, TypeOfInsider ASC'
 END
EXEC (@sSQL)
drop table #tmpResult
RETURN 0
END
	
