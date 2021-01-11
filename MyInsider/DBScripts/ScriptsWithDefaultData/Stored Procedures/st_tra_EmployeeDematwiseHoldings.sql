IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_tra_EmployeeDematwiseHoldings')
DROP PROCEDURE [dbo].[st_tra_EmployeeDematwiseHoldings]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*-------------------------------------------------------------------------------------------------
Description:	Procedure to list Employee DematWiseHoldings.

Returns:		0, if Success.
				
Created by:		Harish
Created on:		21/12/2017

Modification History:

Modified By		Modified On		Description

Usage:

EXEC st_tra_EmployeeDematwiseHoldings
----------------------------------------------------------*/
CREATE PROCEDURE [dbo].[st_tra_EmployeeDematwiseHoldings]
	 @out_nReturnValue				INT = 0 OUTPUT
	,@out_nSQLErrCode				INT = 0 OUTPUT				-- Output SQL Error Number, if error occurred.
	,@out_sSQLErrMessage			VARCHAR(500) = '' OUTPUT  -- Output SQL Error Message, if error occurred.	
AS
BEGIN
    Declare @nEmployeeStatusLive VARCHAR(100),
			@nEmployeeStatusSeparated VARCHAR(100),
			@nEmployeeStatusInactive VARCHAR(100),
			@nEmpActive VARCHAR(100),
			@nRelative VARCHAR(100),
			@nSelf VARCHAR(100),
			@nEmpStatusLiveCode INT = 510001,
			@nEmpStatusSeparatedCode INT = 510002,
	 		@nEmpStatusInactiveCode INT = 510003,
	 		@nEmployeeActive INT = 102001,
	 		@nEmployeeInActive INT = 102002,
	 		@PeriodCodeId INT =124001,
	 		@nCorpUser INT =101004,
			@nNonEmployee INT =101006,
			@nAdminUser INT =101001, 
			@nCoUser INT =101002,
			@nRelativeCode INT=142002,
			@nSelfCode INT=142001
	BEGIN TRY
			SET NOCOUNT ON;

		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''
		
		SELECT @nEmployeeStatusLive = CodeName FROM com_Code WHERE CodeID = @nEmpStatusLiveCode
            
		SELECT @nEmployeeStatusSeparated = CodeName FROM com_Code WHERE CodeID = @nEmpStatusSeparatedCode
		
		SELECT @nEmpActive = CodeName FROM com_Code WHERE CodeID = @nEmployeeActive
		
		SELECT @nRelative=CodeName FROM com_Code WHERE CodeID=@nRelativeCode
		
		SELECT @nSelf=CodeName FROM com_Code WHERE CodeID=@nSelfCode
			
		SELECT @nEmployeeStatusInactive = CodeName FROM com_Code WHERE CodeID = @nEmpStatusInactiveCode		
		
		TRUNCATE TABLE rpt_EmpDematwiseDetails
		
		INSERT INTO rpt_EmpDematwiseDetails	
		
		SELECT 
			CASE WHEN a.LoginID IS NULL AND u.UserInfoId=urelative.UserInfoIdRelative THEN (SELECT aa.LoginID FROM usr_Authentication aa WHERE aa.UserInfoID=urelative.UserInfoId)
				 ELSE a.LoginID	END 
			AS [UserName],
			CASE WHEN  u.EmployeeId IS NULL AND u.UserInfoId=urelative.UserInfoIdRelative  THEN (SELECT ua.EmployeeId FROM usr_UserInfo ua WHERE ua.UserInfoID=urelative.UserInfoId)
				 ELSE  COALESCE(u.EmployeeId,'-')  END 
			AS [Employee ID],
			CASE WHEN u.UserInfoId=urelative.UserInfoIdRelative THEN @nRelative 
				 ELSE @nSelf END
			AS [Self/Relative],
			CASE WHEN CRelation.CodeName IS NULL OR LEN(CRelation.CodeName)=0 THEN '-'
				 ELSE  CRelation.CodeName END 
			AS [Relation],
			CASE WHEN u.FirstName IS NULL OR LEN(u.FirstName)=0  THEN '-' 	 
				 ELSE u.FirstName END 
			AS [First Name],
			CASE WHEN u.MiddleName IS NULL OR LEN(u.MiddleName)=0  THEN '-'
				 ELSE u.MiddleName END
			AS [Middle Name],
			CASE WHEN u.LastName IS NULL OR LEN(u.MiddleName)=0  THEN '-'
				 ELSE u.LastName END
			AS [Last Name],
			CASE WHEN u.AddressLine1 IS NULL OR LEN(u.AddressLine1)=0 THEN '-'
				 ELSE u.AddressLine1 END
			AS  [Address],
			CASE WHEN u.PinCode IS NULL OR LEN(u.PinCode)=0 THEN '-'
				 ELSE u.PinCode END
			AS [PinCode],
			CASE WHEN CCountry.CodeName IS NULL OR LEN(CCountry.CodeName)=0  THEN '-'
				ELSE CCountry.CodeName END
			AS [Country],
			CASE WHEN u.EmailId IS NULL OR LEN(u.EmailId)=0  THEN '-'
				 ELSE u.EmailId END
			AS [Email Address],
			CASE WHEN u.MobileNumber IS NULL OR LEN(u.MobileNumber)=0 THEN '-'
				 ELSE u.MobileNumber END
			AS [Mobile Number],
			CASE WHEN u.PAN IS NULL OR LEN(u.PAN)=0 THEN '-'
				 ELSE u.PAN END
			AS [Permanent Account Number],
			CASE WHEN rolemaster.RoleName IS NULL OR LEN(rolemaster.RoleName)=0 THEN '-'
				ELSE rolemaster.RoleName END
			AS [Role],
			CASE WHEN cm.CompanyName IS NULL OR LEN(cm.CompanyName)=0 THEN '-'
				 ELSE cm.CompanyName END
			AS [Company Name],
	COALESCE(CONVERT(VARCHAR(25),u.DateOfBecomingInsider,121) , '-')
			AS [Date Of Becoming Insider],
			CASE WHEN u.StatusCodeId = @nEmployeeActive AND u.DateOfSeparation IS NULL THEN @nEmployeeStatusLive
				 WHEN u.StatusCodeId = @nEmployeeActive AND u.DateOfSeparation IS NOT NULL THEN @nEmployeeStatusSeparated
				 WHEN u.StatusCodeId = @nEmployeeInActive THEN @nEmployeeStatusSeparated END
			AS [Live/ Seperated],
   COALESCE(CONVERT(VARCHAR(25),u.DateOfSeparation ,121) , '-')
			AS [Date of Seperation],
			CASE WHEN u.StatusCodeId = @nEmployeeActive THEN @nEmpActive
				 WHEN u.StatusCodeId = @nEmployeeInActive THEN @nEmployeeStatusInactive END
			AS [Status],
   COALESCE(CONVERT(VARCHAR(25),u.DateOfInactivation,121) , '-')
		   AS [Date of Inactivation],
		   CASE WHEN u.UserTypeCodeId IN (@nCorpUser,@nNonEmployee) THEN COALESCE(u.CategoryText,'-')
				WHEN CCategory.CodeName IS NULL OR LEN(CCategory.CodeName)=0 THEN '-'
				ELSE CCategory.CodeName END
		   AS [Category],
		  CASE WHEN u.UserTypeCodeId IN (@nCorpUser,@nNonEmployee)THEN COALESCE(u.SubCategoryText,'-')
			   WHEN CSubCategory.CodeName IS NULL OR LEN(CSubCategory.CodeName)=0 THEN '-'
			   ELSE CSubCategory.CodeName END
		   AS [SubCategory],
		 CASE WHEN u.UserTypeCodeId IN (@nCorpUser,@nNonEmployee) THEN COALESCE(u.DesignationText,'-')
			 WHEN CDesignation.CodeName IS NULL OR LEN(CDesignation.CodeName)=0 THEN '-'
			 ELSE CDesignation.CodeName END
		  AS [Designation],
		CASE WHEN u.UserTypeCodeId IN (@nCorpUser,@nNonEmployee) THEN COALESCE(u.SubDesignationText,'-')
			 WHEN CSubDesignation.CodeName IS NULL OR LEN(CSubDesignation.CodeName)=0 THEN '-'
			 ELSE CSubDesignation.CodeName END
        AS [Sub-Designation],
		CASE WHEN u.UserTypeCodeId IN(@nCorpUser,@nNonEmployee) THEN COALESCE(u.GradeText,'-')
			 WHEN CGrade.CodeName IS NULL OR LEN(CGrade.CodeName)=0 THEN '-'
			 ELSE CGrade.CodeName END
		AS [Grade],
		CASE WHEN u.Location IS NULL OR LEN(u.Location)=0 THEN '-'
			 ELSE u.Location END
		AS [Location],
		CASE WHEN u.DIN IS NULL OR LEN(u.DIN)=0 THEN '-'
			 ELSE u.DIN END
		AS[DIN],
		CASE WHEN u.UserTypeCodeId IN (@nCorpUser,@nNonEmployee) THEN COALESCE(u.DepartmentText,'-')
			 WHEN CDepartment.CodeName IS NULL OR LEN(CDepartment.CodeName)=0 THEN '-'
			 ELSE CDepartment.CodeName END
		AS [Department],
		CASE WHEN CSecurityType.CodeName IS NULL OR LEN(CSecurityType.CodeName)=0 THEN '-'
			 ELSE CSecurityType.CodeName END
		AS [Security Type],
		CASE WHEN dmat.DEMATAccountNumber IS NULL OR LEN(dmat.DEMATAccountNumber)=0 THEN '-'
			ELSE dmat.DEMATAccountNumber END
		AS [DMAT AccNumber],
		CASE WHEN dmat.DPBank IS NULL OR LEN(dmat.DPBank)=0 THEN '-'
			 ELSE dmat.DPBank END
		AS [Depository Participant Name],
		CASE WHEN dmat.DPID IS NULL OR LEN(dmat.DPID)=0 THEN '-'
			 ELSE dmat.DPID END
		AS [Depository Participant ID],
		CASE WHEN dmat.TMID IS NULL OR LEN(dmat.TMID)=0 THEN '-'
			 ELSE dmat.TMID END
		AS [TMID],
   COALESCE(CAST(transummarydmat.ClosingBalance AS VARCHAR(20)), '-')
        AS [Holdings]
FROM usr_UserInfo u
LEFT JOIN usr_Authentication a ON u.UserInfoId=A.UserInfoID
LEFT JOIN mst_Company cm ON cm.CompanyId=u.CompanyId
LEFT JOIN com_Code C ON u.StatusCodeId = C.CodeID
LEFT JOIN com_Code CDepartment ON u.DepartmentId=CDepartment.CodeID
LEFT JOIN com_Code CGrade ON u.GradeId=CGrade.CodeID
LEFT JOIN com_Code CDesignatiON ON u.DesignationId=CDesignation.CodeID
LEFT JOIN com_Code CCountry ON u.CountryId=CCountry.CodeID
LEFT JOIN com_Code CCategory ON u.Category=CCategory.CodeID
LEFT JOIN com_Code CSubCategory ON u.SubCategory=CSubCategory.CodeID
LEFT JOIN com_Code CSubDesignation ON u.SubDesignationId=CSubDesignation.CodeID
LEFT JOIN usr_UserRelation urelative ON u.UserInfoId=urelative.UserInfoIdRelative
LEFT JOIN com_Code CRelation ON CRelation.CodeID=urelative.RelationTypeCodeId
LEFT JOIN usr_UserRole userrole ON u.UserInfoId=userrole.UserInfoID
LEFT JOIN usr_RoleMaster rolemaster ON userrole.RoleID=rolemaster.RoleId 
LEFT JOIN usr_DMATDetails dmat ON dmat.UserInfoID=u.UserInfoId
LEFT JOIN tra_TransactionSummaryDMATWise transummarydmat ON transummarydmat.UserInfoIdRelative=dmat.UserInfoId AND 
(transummarydmat.UserInfoIdRelative Is NULL  OR transummarydmat.UserInfoIdRelative=u.UserInfoId)
AND
(transummarydmat.PeriodCodeId Is NULL  OR transummarydmat.PeriodCodeId=@PeriodCodeId)
AND  
(transummarydmat.DMATDetailsID IS NULL  OR transummarydmat.DMATDetailsID=dmat.DMATDetailsID) 
AND 
(transummarydmat.YearCodeId IS NULL  OR  transummarydmat.YearCodeId IN 
(SELECT MAX(YearCodeId) FROM tra_TransactionSummaryDMATWise tb  LEFT JOIN com_Code CSecurityType ON CSecurityType.CodeID=transummarydmat.SecurityTypeCodeId
WHERE tb.UserInfoIdRelative=u.UserInfoId and tb.DMATDetailsID=dmat.DMATDetailsID and tb.SecurityTypeCodeId=CSecurityType.CodeID GROUP BY tb.SecurityTypeCodeId))
LEFT JOIN com_Code CSecurityType ON CSecurityType.CodeID=transummarydmat.SecurityTypeCodeId
LEFT JOIN com_Code cLiveActive ON u.StatusCodeId=cLiveActive.CodeID 
WHERE u.UserTypeCodeId NOT IN (@nAdminUser,@nCoUser)
 --and u.UserInfoId in (1736,1767)
ORDER BY CASE WHEN a.LoginID IS NULL AND u.UserInfoId=urelative.UserInfoIdRelative THEN (SELECT aa.LoginID FROM usr_Authentication aa WHERE aa.UserInfoID=urelative.UserInfoId)
				 ELSE a.LoginID	END ,u.UserTypeCodeId, CSecurityType.CodeID


	

	RETURN 0
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue	=  0
	END CATCH

END

