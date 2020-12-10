IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_usr_UserInfoList_Employee')
DROP PROCEDURE [dbo].[st_usr_UserInfoList_Employee]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Procedure to save user info.

Returns:		0, if Success.
				
Created by:		Arundhati
Created on:		09-Feb-2015

Modification History:
Modified By		Modified On		Description
Arundhati		11-Feb-2015		Error code is corrected for user list
Arundhati		23-Feb-2015		Code needed for sorting is added.
								UserTypeCodeId is added in the output
Arundhati		24-Feb-2015		Sorting was not working.
Arundhati		05-Mar-2015		Added columns DateOfSeparation, ReasonForSeparation
Arundhati		16-Mar-2015		For Non-Employee and Corporate users, designation is stored as text. So corresponding changes in list.
Arundhati		28-Apr-2015		Employee list based on UserTypeCodeId
Arundhati		08-May-2015		Join on rolemaster is removed to avoid duplicate records
Arundhati		07-Jul-2015		Show "Contact Person Name" & "Landline1" in the columns "Name" & "Mobile No." respectively
Parag			14-Jul-2015		Made change to add filter for first and last name 
								because on screen both are shown combine however filter is applied for first name only
Parag			10-Aug-2015		Made change to add parameter - grid type - and check if grid type is upload sepration then use resouces for 
								upload separation grid also added condition for sort for upload sepration column as well 
Gaurishankar	12-Oct-2015		Added fields for User Separation
Gaurishankar	20-Oct-2015		Added fields for Sorting related to User Separation
Gaurishankar	02-Nov-2015		Employee/Insider List should not display seprated users and added search parameters for User Separation.
Gaurishankar	04-Dec-2015		Change for Regarding update separation - After separated date user should be listed in Separated List till then it should show in normal employee list
Arundhati		09-Dec-2015		Changes for showing Employee Insider as separate type
Raghvendra		25-Feb-2016		Fix for employees record not seen correctly because of the condition for separation date
Raghvendra		07-Sep-2016		Changed the GETDATE() call with function dbo.uf_com_GetServerDate(). This function will return the date to be used as server date.
Harish	        22-Feb-2018		As of now Corporate User will be searched from user list on ContactType Column .
Usage:
EXEC st_role_RoleAssignmentList 2
-------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[st_usr_UserInfoList_Employee]
	@inp_iPageSize					INT = 10
	,@inp_iPageNo					INT = 1
	,@inp_sSortField				VARCHAR(255)
	,@inp_sSortOrder				VARCHAR(5)
	
    ,@inp_sEmailId					NVARCHAR(250) = null
    ,@inp_sFirstName				NVARCHAR(50) = null
 --   ,@inp_sMiddleName				NVARCHAR(50) = null
 --   ,@inp_sLastName					NVARCHAR(50) = null
    ,@inp_sEmployeeId				NVARCHAR(50) = null
    ,@inp_sMobileNumber				NVARCHAR(15) = null
	,@inp_iCompanyId				INT	
    ,@inp_sPAN						NVARCHAR(50) = null
    ,@inp_iCategory					INT = null
 --   ,@inp_iSubCategory				INT = null
    ,@inp_iGradeId					INT = null
    --,@inp_iDesignationId			INT = null
    ,@inp_sDesignationText			NVARCHAR(100)
    ,@inp_sLocation					NVARCHAR(50) = null
    ,@inp_iDepartmentId				INT = null
	,@inp_iStatusCodeId				INT
    ,@inp_iLoggedInUserId			INT = null
    ,@inp_sLoginID					VARCHAR(100) = null
    ,@inp_iIsInsider				INT
	,@inp_nRoleId					INT
	,@inp_nUserTypeCodeId			INT
	,@inp_dtFromDateOfSeparation	DATETIME
	,@inp_dtToDateOfSeparation		DATETIME
	,@inp_dtFromDateOfInactivation	DATETIME
	,@inp_dtToDateOfInactivation	DATETIME
	,@inp_iGridType					INT = null
	,@inp_iIsInsiderFlag			INT = null -- 173001 : Insider, 173002 : Non Insider
	,@out_nReturnValue				INT = 0 OUTPUT
	,@out_nSQLErrCode				INT = 0 OUTPUT				-- Output SQL Error Number, if error occurred.
	,@out_sSQLErrMessage			VARCHAR(500) = '' OUTPUT  -- Output SQL Error Message, if error occurred.	
AS
BEGIN
	DECLARE @sSQL NVARCHAR(MAX) = ''
	DECLARE @ERR_USER_LIST INT = 11039 -- Error occurred while fetching list of users.
	DECLARE @nUserType_CO INT = 101002,
			@nUserType_Employee INT = 101003,
			@nUserType_CorporateUser INT = 101004,
			@nUserType_NonEmployee INT = 101006,
			@nUserType_Relative INT = 101007,
			@nInsiderFlag_Insider INT = 173001,
			@sInsider VARCHAR(20) = ' Insider'


	BEGIN TRY
		
		SET NOCOUNT ON;
		-- Declare variables
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''

			-- Based on search parameters, insert only the Primary Index Field in the temporary table.
		SELECT @sSQL = @sSQL + 'INSERT INTO #tmpList (RowNumber, EntityID)'
		
		-- if Called From CreateUser
	
		IF @inp_sSortOrder IS NULL OR @inp_sSortOrder = ''
		BEGIN 
				SELECT @inp_sSortOrder = 'ASC'
		END
		
		IF @inp_sSortField IS NULL OR @inp_sSortField = ''
		BEGIN 
			SELECT @inp_sSortField = 'UF.FirstName ' + @inp_sSortOrder + ', UF.LastName ' + @inp_sSortOrder + ', ContactPerson '
		END 

		IF @inp_sSortField = 'usr_grd_11074' OR @inp_sSortField = 'usr_grd_11402' -- UF.FirstName + ' ' + UF.LastName
		BEGIN 
			SELECT @inp_sSortField = 'UF.FirstName ' + @inp_sSortOrder + ', UF.LastName ' + @inp_sSortOrder + ', ContactPerson '
		END 

		IF @inp_sSortField = 'usr_grd_11075' OR @inp_sSortField = 'usr_grd_11403' --	UF.EmployeeId

		BEGIN 
			SELECT @inp_sSortField = 'UF.EmployeeId '
		END 
				
		IF @inp_sSortField = 'usr_grd_11080' OR @inp_sSortField = 'usr_grd_11408' -- EmployeeType
		BEGIN 
			--SELECT @inp_sSortField = 'CUSerType.CodeName '
			SELECT @inp_sSortField = 'CUSerType.CodeName + CASE WHEN UF.DateOfBecomingInsider IS NOT NULL THEN ''' + @sInsider + ''' ELSE '''' END '
		END 
				
		IF @inp_sSortField = 'usr_grd_11076' OR @inp_sSortField = 'usr_grd_11404' --  CompanyName,
		BEGIN 
			SELECT @inp_sSortField = 'CM.CompanyName '
		END 
				
		IF @inp_sSortField = 'usr_grd_11081' OR @inp_sSortField = 'usr_grd_11409' -- Grade,
		BEGIN 
			SELECT @inp_sSortField = 'CGrade.CodeName '
		END 
				
		IF @inp_sSortField = 'usr_grd_11082' OR @inp_sSortField = 'usr_grd_11410' -- Designation,
		BEGIN 
			--SELECT @inp_sSortField = 'CDesignation.CodeName '
			SELECT @inp_sSortField = 'ISNULL(CDesignation.CodeName, '''') + ISNULL(UF.DesignationText, '''') '
		END 
				
		IF @inp_sSortField = 'usr_grd_11083' OR @inp_sSortField = 'usr_grd_11411' --  Location,
		BEGIN 
			SELECT @inp_sSortField = 'UF.Location '
		END 
				
		IF @inp_sSortField = 'usr_grd_11084' OR @inp_sSortField = 'usr_grd_11412' --  Department,
		BEGIN 
			SELECT @inp_sSortField = 'CDepartment.CodeName '
		END 
				
		IF @inp_sSortField = 'usr_grd_11077' OR @inp_sSortField = 'usr_grd_11405' -- MobileNumber,
		BEGIN 
			SELECT @inp_sSortField = 'ISNULL(UF.MobileNumber, '''') + ISNULL(LandLine1, '''') '
		END 
				
		IF @inp_sSortField = 'usr_grd_11078' OR @inp_sSortField = 'usr_grd_11406' -- EmailId,
		BEGIN 
			SELECT @inp_sSortField = 'UF.EmailId '
		END 
				
		IF @inp_sSortField = 'usr_grd_11079' OR @inp_sSortField = 'usr_grd_11407' --  UserStatusCode
		BEGIN 
			SELECT @inp_sSortField = 'CUserStatus.CodeName '
		END 
				
		IF @inp_sSortField = 'usr_grd_11229'--  DateofSeparation
		BEGIN 
			SELECT @inp_sSortField = 'UF.DateOfSeparation '
		END 
				
		IF @inp_sSortField = 'usr_grd_11230'--  ReasonForSeparation
		BEGIN 
			SELECT @inp_sSortField = 'UF.ReasonForSeparation '
		END 
		IF @inp_sSortField = 'usr_grd_11424'--  NoOfDaysToBeActive
		BEGIN 
			SELECT @inp_sSortField = 'UF.NoOfDaysToBeActive '
		END
		IF @inp_sSortField = 'usr_grd_11425'--  DateOfInactivation
		BEGIN 
			SELECT @inp_sSortField = 'UF.DateOfInactivation '
		END		
		--print @sSQL
		SELECT @sSQL = @sSQL + ' SELECT DISTINCT DENSE_RANK() OVER(Order BY ' + @inp_sSortField + ' ' + @inp_sSortOrder +',UF.UserInfoId),UF.UserInfoId '				
		SELECT @sSQL = @sSQL + ' FROM usr_UserInfo UF '				
		SELECT @sSQL = @sSQL + ' INNER JOIN usr_Authentication A ON UF.UserInfoId = A.UserInfoID '
							 + ' INNER JOIN com_Code CUserStatus ON UF.StatusCodeId = CUserStatus.CodeID '
							 + ' JOIN com_Code CUSerType ON UF.UserTypeCodeId = CUSerType.CodeID '
							 + ' LEFT JOIN usr_UserRole UR ON UF.UserInfoId = UR.UserInfoID '
							 + ' LEFT JOIN mst_Company CM ON UF.CompanyId = CM.CompanyId '
							 + ' LEFT JOIN com_Code CGrade ON UF.GradeId = CGrade.CodeID '
							 + ' LEFT JOIN com_Code CDesignation ON UF.DesignationId = CDesignation.CodeID '
							 + ' LEFT JOIN com_Code CDepartment ON UF.DepartmentId = CDepartment.CodeID '

		SELECT @sSQL = @sSQL + ' WHERE 1 = 1 '
		
		IF (@inp_iGridType IS NOT NULL AND @inp_iGridType <> 114019)
		BEGIN 
			SELECT @sSQL = @sSQL + ' AND (UF.DateOfSeparation IS NULL OR UF.DateOfSeparation > dbo.uf_com_GetServerDate()) '
		END
		
		SELECT @sSQL = @sSQL + ' AND UserTypeCodeId IN '

		IF @inp_nUserTypeCodeId IS NULL
		BEGIN
			SELECT @sSQL = @sSQL + '(' + CAST(@nUserType_Employee AS VARCHAR(10)) -- 101003
								 + ',' + CAST(@nUserType_CorporateUser AS VARCHAR(10)) -- 101004
								 + ', ' + CAST(@nUserType_NonEmployee AS VARCHAR(10)) + ') ' -- 101006
		END
		ELSE
		BEGIN
			SELECT @sSQL = @sSQL + '(' + CAST(@inp_nUserTypeCodeId AS VARCHAR(10)) + ') ' -- 101006
		END
					
		IF (@inp_sEmailId IS NOT NULL AND @inp_sEmailId <> '')	
		BEGIN
				SELECT @sSQL = @sSQL + ' AND UF.EmailId LIKE N''%'+ @inp_sEmailId +'%'' '
		END
		
		IF (@inp_sFirstName IS NOT NULL AND @inp_sFirstName <> '')	
		BEGIN
				SELECT @sSQL = @sSQL + ' AND (UF.FirstName LIKE N''%'+ @inp_sFirstName +'%'' '
				SELECT @sSQL = @sSQL + ' OR UF.LastName LIKE N''%'+ @inp_sFirstName +'%'' ' 
				SELECT @sSQL = @sSQL + ' OR UF.ContactPerson LIKE N''%'+ @inp_sFirstName +'%'') ' 
		END
		
		IF (@inp_sEmployeeId IS NOT NULL AND @inp_sEmployeeId <> '')	
		BEGIN
				SELECT @sSQL = @sSQL + ' AND UF.EmployeeId LIKE N''%'+ @inp_sEmployeeId +'%'' '
		END
		
		IF (@inp_sMobileNumber IS NOT NULL AND @inp_sMobileNumber <> '')	
		BEGIN
				SELECT @sSQL = @sSQL + ' AND UF.MobileNumber LIKE N''%'+ @inp_sMobileNumber +'%'' '
		END

		IF (@inp_iCompanyId IS NOT NULL AND @inp_iCompanyId <> 0)	
		BEGIN
				SELECT @sSQL = @sSQL + ' AND UF.@inp_iCompanyId = '+ CAST(@inp_iCompanyId AS VARCHAR(10)) + ' '
		END

		IF (@inp_sPAN IS NOT NULL AND @inp_sPAN <> '')	
		BEGIN
				SELECT @sSQL = @sSQL + ' AND UF.PAN LIKE N''%'+ @inp_sPAN +'%'' '
		END

		IF (@inp_iCategory IS NOT NULL AND @inp_iCategory <> 0 )	
		BEGIN
				SELECT @sSQL = @sSQL + ' AND UF.Category = '  + CAST(@inp_iCategory AS VARCHAR(10)) 
		END

		IF (@inp_iGradeId IS NOT NULL AND @inp_iGradeId <> 0 )	
		BEGIN
				SELECT @sSQL = @sSQL + ' AND UF.GradeId = '  + CAST(@inp_iGradeId AS VARCHAR(10)) 
		END
		
		IF (@inp_sDesignationText IS NOT NULL AND @inp_sDesignationText <> 0 )	
		BEGIN
				--SELECT @sSQL = @sSQL + ' AND (CDesignation.CodeName LIKE N''%'  + @inp_sDesignationText + '%'' ' 
				--SELECT @sSQL = @sSQL + ' OR UF.DesignationText LIKE N''%'  + @inp_sDesignationText + '%'') ' 
				SELECT @sSQL = @sSQL + ' AND UF.DesignationId = '  + @inp_sDesignationText
		END
		
		IF (@inp_sLocation IS NOT NULL AND @inp_sLocation <> '')	
		BEGIN
				SELECT @sSQL = @sSQL + ' AND UF.Location LIKE N''%'+ @inp_sLocation +'%'' '
		END
		
		IF (@inp_iDepartmentId IS NOT NULL AND @inp_iDepartmentId <> 0 )	
		BEGIN
				SELECT @sSQL = @sSQL + ' AND UF.DepartmentId = '  + CAST(@inp_iDepartmentId AS VARCHAR(10)) 
		END
		
		IF (@inp_iStatusCodeId IS NOT NULL AND @inp_iStatusCodeId <> 0 )	
		BEGIN
				SELECT @sSQL = @sSQL + ' AND UF.StatusCodeId = '  + CAST(@inp_iStatusCodeId AS VARCHAR(10)) 
		END

		IF (@inp_sLoginID IS NOT NULL AND @inp_sLoginID <> '')	
		BEGIN
				SELECT @sSQL = @sSQL + ' AND A.LoginID LIKE N''%'+ @inp_sLoginID +'%'' '
		END

		IF (@inp_iIsInsider IS NOT NULL AND @inp_iIsInsider <> 0 )	
		BEGIN
				SELECT @sSQL = @sSQL + ' AND UF.IsInsider = '  + CAST(@inp_iIsInsider AS VARCHAR(10)) 
		END
		
		IF (@inp_nRoleId IS NOT NULL AND @inp_nRoleId <> 0 )	
		BEGIN
				SELECT @sSQL = @sSQL + ' AND UR.RoleID = '  + CAST(@inp_nRoleId AS VARCHAR(10)) 
		END
		
		IF (@inp_dtFromDateOfSeparation IS NOT NULL AND @inp_dtFromDateOfSeparation != '')
		BEGIN
			SELECT @sSQL = @sSQL + ' AND UF.DateOfSeparation >= '''  + CAST(@inp_dtFromDateOfSeparation AS VARCHAR(11)) + ''''
		END
		
		IF (@inp_dtToDateOfSeparation IS NOT NULL AND @inp_dtToDateOfSeparation != '')
		BEGIN
			SELECT @sSQL = @sSQL + ' AND CAST(UF.DateOfSeparation AS date) <= '''  + CAST(@inp_dtToDateOfSeparation AS VARCHAR(11)) + ''''
		END
		
		IF (@inp_dtFromDateOfInactivation IS NOT NULL AND @inp_dtFromDateOfInactivation != '')
		BEGIN
			SELECT @sSQL = @sSQL + ' AND UF.DateOfInactivation >= '''  + CAST(@inp_dtFromDateOfInactivation AS VARCHAR(11)) + ''''
		END
		
		IF (@inp_dtToDateOfInactivation IS NOT NULL AND @inp_dtToDateOfInactivation != '')
		BEGIN
			SELECT @sSQL = @sSQL + ' AND CAST(UF.DateOfInactivation AS date) <= '''  + CAST(@inp_dtToDateOfInactivation AS VARCHAR(11)) + ''''
		END
		
		IF (@inp_iIsInsiderFlag IS NOT NULL)
		BEGIN
			SELECT @sSQL = @sSQL + ' AND UF.DateOfBecomingInsider IS '
			IF @inp_iIsInsiderFlag = @nInsiderFlag_Insider
			BEGIN
				-- When the flag is one, records with date of becoming insider not null to be taken
				SELECT @sSQL = @sSQL + ' NOT'			
			END
			SELECT @sSQL = @sSQL + ' NULL'
		END
		--PRINT(@sSQL)
		EXEC(@sSQL)
		
		IF (@inp_iGridType IS NOT NULL AND @inp_iGridType = 114019)
		BEGIN 
			SELECT	UF.UserInfoID AS UserInfoID,
					CASE WHEN UserTypeCodeId = 101004 THEN ContactPerson ELSE ISNULL(UF.FirstName, '') + ' ' + ISNULL(UF.LastName, '') END AS usr_grd_11402,--_FirstName,
					UF.EmployeeId AS usr_grd_11403,--_EmployeeId,
					CUSerType.CodeName + CASE WHEN UF.DateOfBecomingInsider IS NOT NULL THEN @sInsider ELSE '' END AS usr_grd_11408,--_EmployeeType,
					--A.LoginID AS UserName,
					CM.CompanyName AS usr_grd_11404,--_CompanyName,
					CGrade.CodeName AS usr_grd_11409,--_Grade,
					ISNULL(CDesignation.CodeName, '') + ISNULL(UF.DesignationText, '') AS usr_grd_11410,--_Designation,
					UF.Location AS usr_grd_11411,--_Location,
					CDepartment.CodeName AS usr_grd_11412,--_Department,				
					CASE WHEN UserTypeCodeId = 101004 THEN LandLine1 ELSE UF.MobileNumber END AS usr_grd_11405,--_MobileNumber,
					UF.EmailId AS usr_grd_11406,--_EmailId,
					--RM.RoleName AS RoleName,
					CUserStatus.CodeName AS usr_grd_11407, --UserStatusCode
					UF.UserTypeCodeId AS UserTypeCodeId,
					UF.DateOfSeparation AS usr_grd_11229,
					UF.ReasonForSeparation AS usr_grd_11230,
					UF.NoOfDaysToBeActive AS usr_grd_11424,
					UF.DateOfInactivation AS usr_grd_11425,
					CCatagary.CodeName AS usr_grd_54060
			FROM	 #tmpList T INNER JOIN
					 usr_UserInfo UF ON UF.UserInfoId = T.EntityID
					 INNER JOIN usr_Authentication A ON UF.UserInfoId = A.UserInfoID				 
					 INNER JOIN com_Code CUserStatus ON UF.StatusCodeId = CUserStatus.CodeID
					 JOIN com_Code CUSerType ON UF.UserTypeCodeId = CUSerType.CodeID
					 LEFT JOIN mst_Company CM ON UF.CompanyId = CM.CompanyId
					 --LEFT JOIN usr_UserRole UR ON UF.UserInfoId = UR.UserInfoID
					 --LEFT JOIN usr_RoleMaster RM ON UR.RoleID = RM.RoleId
					 LEFT JOIN com_Code CGrade ON UF.GradeId = CGrade.CodeID
					 LEFT JOIN com_Code CDesignation ON UF.DesignationId = CDesignation.CodeID
					 LEFT JOIN com_Code CDepartment ON UF.DepartmentId = CDepartment.CodeID
					LEFT JOIN com_Code CCatagary on UF.Category=CCatagary.CodeID
			WHERE   UF.UserInfoId IS NOT NULL AND ((@inp_iPageSize = 0) OR (T.RowNumber BETWEEN ((@inp_iPageNo - 1) * @inp_iPageSize + 1) AND (@inp_iPageNo * @inp_iPageSize)))
					--AND UF.DateOfSeparation IS NOT NULL
			ORDER BY T.RowNumber
			
			--DELETE T 
			--FROM #tmpList T 
			--INNER JOIN usr_UserInfo UF ON UF.UserInfoId = T.EntityID
			--WHERE UF.DateOfSeparation IS NULL
		END
		ELSE
		BEGIN 
			SELECT	UF.UserInfoID AS UserInfoID,
					CASE WHEN UserTypeCodeId = 101004 THEN ContactPerson ELSE ISNULL(UF.FirstName, '') + ' ' + ISNULL(UF.LastName, '') END AS usr_grd_11074,--_FirstName,
					UF.EmployeeId AS usr_grd_11075,--_EmployeeId,
					CUSerType.CodeName + CASE WHEN UF.DateOfBecomingInsider IS NOT NULL THEN @sInsider ELSE '' END AS usr_grd_11080,--_EmployeeType,
					--A.LoginID AS UserName,
					CM.CompanyName AS usr_grd_11076,--_CompanyName,
					CGrade.CodeName AS usr_grd_11081,--_Grade,
					ISNULL(CDesignation.CodeName, '') + ISNULL(UF.DesignationText, '') AS usr_grd_11082,--_Designation,
					UF.Location AS usr_grd_11083,--_Location,
					CDepartment.CodeName AS usr_grd_11084,--_Department,				
					CASE WHEN UserTypeCodeId = 101004 THEN LandLine1 ELSE UF.MobileNumber END AS usr_grd_11077,--_MobileNumber,
					UF.EmailId AS usr_grd_11078,--_EmailId,
					--RM.RoleName AS RoleName,
					CUserStatus.CodeName AS usr_grd_11079, --UserStatusCode
					UF.UserTypeCodeId AS UserTypeCodeId,
					UF.DateOfSeparation AS usr_grd_11229,
					UF.ReasonForSeparation AS usr_grd_11230,
					CCatagary.CodeName AS dis_grd_54060,
					ISNULL( UF.IsBlocked,0) as IsBlocked,
					Rtrim( Ltrim( Blocked_UnBlock_Reason)) as Blocked_UnBlock_Reason
			FROM	 #tmpList T INNER JOIN
					 usr_UserInfo UF ON UF.UserInfoId = T.EntityID
					 INNER JOIN usr_Authentication A ON UF.UserInfoId = A.UserInfoID				 
					 INNER JOIN com_Code CUserStatus ON UF.StatusCodeId = CUserStatus.CodeID
					 JOIN com_Code CUSerType ON UF.UserTypeCodeId = CUSerType.CodeID
					 LEFT JOIN mst_Company CM ON UF.CompanyId = CM.CompanyId
					 --LEFT JOIN usr_UserRole UR ON UF.UserInfoId = UR.UserInfoID
					 --LEFT JOIN usr_RoleMaster RM ON UR.RoleID = RM.RoleId
					 LEFT JOIN com_Code CGrade ON UF.GradeId = CGrade.CodeID
					 LEFT JOIN com_Code CDesignation ON UF.DesignationId = CDesignation.CodeID
					 LEFT JOIN com_Code CDepartment ON UF.DepartmentId = CDepartment.CodeID
					LEFT JOIN com_Code CCatagary on UF.Category=CCatagary.CodeID
			WHERE   UF.UserInfoId IS NOT NULL AND ((@inp_iPageSize = 0) OR (T.RowNumber BETWEEN ((@inp_iPageNo - 1) * @inp_iPageSize + 1) AND (@inp_iPageNo * @inp_iPageSize)))
					--AND (UF.DateOfSeparation IS NULL OR UF.DateOfSeparation > dbo.uf_com_GetServerDate())
			ORDER BY T.RowNumber
			
			DELETE T 
			FROM #tmpList T 
			INNER JOIN usr_UserInfo UF ON UF.UserInfoId = T.EntityID
			WHERE UF.DateOfSeparation IS NOT NULL
		END

		RETURN 0
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue	=  @ERR_USER_LIST
	END CATCH
END
