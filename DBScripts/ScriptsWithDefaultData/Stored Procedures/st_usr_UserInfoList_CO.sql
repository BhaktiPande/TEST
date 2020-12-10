IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_usr_UserInfoList_CO')
DROP PROCEDURE [dbo].[st_usr_UserInfoList_CO]
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
Arundhati		10-Feb-2015		Variable is initialized, Column UserInfoID added in the output								
Arundhati		11-Feb-2015		Error code is corrected for user list
Arundhati		12-Feb-2015		Last name is added in search
Arundhati		26-Feb-2015		Sorting for some columns was not working
Usage:
EXEC st_role_RoleAssignmentList 2
-------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[st_usr_UserInfoList_CO]
	@inp_iPageSize					INT = 10
	,@inp_iPageNo					INT = 1
	,@inp_sSortField				VARCHAR(255)
	,@inp_sSortOrder				VARCHAR(5)
    ,@inp_sEmailId					NVARCHAR(250) = null
    ,@inp_sFirstName				NVARCHAR(50) = null
 --   ,@inp_sMiddleName				NVARCHAR(50) = null
    ,@inp_sLastName					NVARCHAR(50) = null
    ,@inp_sEmployeeId				NVARCHAR(50) = null
 --   ,@inp_sMobileNumber				NVARCHAR(15) = null
	,@inp_iCompanyId				INT	
	,@inp_iStatusCodeId				INT
    ,@inp_sLoginID					VARCHAR(100) = null
	,@inp_nRoleId					INT
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
			@nUserType_Relative INT = 101007


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
			SELECT @inp_sSortField = 'UF.FirstName ' + @inp_sSortOrder + ', UF.LastName '
		END 

		IF @inp_sSortField = 'usr_grd_11065'
		BEGIN 
			SELECT @inp_sSortField = 'UF.FirstName ' + @inp_sSortOrder + ', UF.LastName '
		END 

		IF @inp_sSortField = 'usr_grd_11066'
		BEGIN 
			SELECT @inp_sSortField = 'UF.EmployeeId '
		END 

		IF @inp_sSortField = 'usr_grd_11067'
		BEGIN 
			SELECT @inp_sSortField = 'A.LoginID '
		END 

		IF @inp_sSortField = 'usr_grd_11068'
		BEGIN 
			SELECT @inp_sSortField = 'CM.CompanyName '
		END 

		IF @inp_sSortField = 'usr_grd_11069'
		BEGIN 
			SELECT @inp_sSortField = 'UF.MobileNumber '
		END 
		
		IF @inp_sSortField = 'usr_grd_11070'
		BEGIN 
			SELECT @inp_sSortField = 'UF.EmailId '
		END 

		IF @inp_sSortField = 'usr_grd_11071'
		BEGIN 
			SELECT @inp_sSortField = 'UR.RoleName '
		END 

		--here though the sortField is usr_grd_11073 column is Action it will consider sortField as CodeName
		IF @inp_sSortField = 'usr_grd_11072' OR @inp_sSortField = 'usr_grd_11073'
		BEGIN 
			SELECT @inp_sSortField = 'C.CodeName '
		END 
		
		--print @sSQL
		SELECT @sSQL = @sSQL + ' SELECT DISTINCT DENSE_RANK() OVER(Order BY ' + @inp_sSortField + ' ' + @inp_sSortOrder +',UF.UserInfoId),UF.UserInfoId '				
		SELECT @sSQL = @sSQL + ' FROM usr_UserInfo UF '				
		SELECT @sSQL = @sSQL + ' INNER JOIN usr_Authentication A ON UF.UserInfoId = A.UserInfoID '
		SELECT @sSQL = @sSQL + ' INNER JOIN com_Code C ON UF.StatusCodeId = C.CodeID '
		SELECT @sSQL = @sSQL + ' LEFT JOIN vw_UserRoleNames UR ON UF.UserInfoId = UR.UserInfoID '
		SELECT @sSQL = @sSQL + ' LEFT JOIN mst_Company CM ON UF.CompanyId = CM.CompanyId '
		--SELECT @sSQL = @sSQL + ' LEFT JOIN usr_RoleMaster RM ON UR.RoleID = RM.RoleId '
		SELECT @sSQL = @sSQL + ' WHERE 1 = 1 AND UF.UserTypeCodeId = 101002 '
       				
		IF (@inp_sEmailId IS NOT NULL AND @inp_sEmailId <> '')	
		BEGIN
			SELECT @sSQL = @sSQL + ' AND UF.EmailId LIKE N''%'+ @inp_sEmailId +'%'' '
		END
		
		IF (@inp_sFirstName IS NOT NULL AND @inp_sFirstName <> '')	
		BEGIN
			SELECT @sSQL = @sSQL + ' AND UF.FirstName LIKE N''%'+ @inp_sFirstName +'%'' '
		END
		
		IF (@inp_sLastName IS NOT NULL AND @inp_sLastName <> '')	
		BEGIN
			SELECT @sSQL = @sSQL + ' AND UF.LastName LIKE N''%'+ @inp_sLastName +'%'' '
		END
		
		IF (@inp_sEmployeeId IS NOT NULL AND @inp_sEmployeeId <> '')	
		BEGIN
			SELECT @sSQL = @sSQL + ' AND UF.EmployeeId LIKE N''%'+ @inp_sEmployeeId +'%'' '
		END
		
		IF (@inp_iCompanyId IS NOT NULL AND @inp_iCompanyId <> 0)	
		BEGIN
			SELECT @sSQL = @sSQL + ' AND UF.CompanyId = '+ CAST(@inp_iCompanyId AS VARCHAR(10)) + ' '
		END

		IF (@inp_iStatusCodeId IS NOT NULL AND @inp_iStatusCodeId <> 0 )	
		BEGIN
			SELECT @sSQL = @sSQL + ' AND UF.StatusCodeId = '  + CAST(@inp_iStatusCodeId AS VARCHAR(10)) 
		END

		IF (@inp_sLoginID IS NOT NULL AND @inp_sLoginID <> '')	
		BEGIN
			SELECT @sSQL = @sSQL + ' AND A.LoginID LIKE N''%'+ @inp_sLoginID +'%'' '
		END

		IF (@inp_nRoleId IS NOT NULL AND @inp_nRoleId <> 0 )	
		BEGIN
			SELECT @sSQL = @sSQL + ' AND UR.RoleIDs like ''%,'  + CAST(@inp_nRoleId AS VARCHAR(10)) + ',%'' '
		END
		
		--IF (@inp_sCompanyName IS NOT NULL AND @inp_sCompanyName <> '')	
		--BEGIN
		--		SELECT @sSQL = @sSQL + ' AND UF.CompanyName LIKE ''%'+ @inp_sCompanyName +'%'' '
		--END
				
		--PRINT(@sSQL)
		EXEC(@sSQL)

		SELECT	UF.UserInfoID AS UserInfoID,
				UF.FirstName + ' ' + UF.LastName AS usr_grd_11065, --_FirstName,
				UF.EmployeeId AS usr_grd_11066, --_EmployeeId,
				A.LoginID AS usr_grd_11067, --_UserName,
				CM.CompanyName AS usr_grd_11068, --_CompanyName,
				UF.MobileNumber AS usr_grd_11069, --_MobileNumber,
				UF.EmailId AS usr_grd_11070, --_EmailId,
				UR.RoleName AS usr_grd_11071, --_RoleName,
				C.CodeName AS usr_grd_11072 --_UserStatusCode
		FROM	 #tmpList T INNER JOIN
				 usr_UserInfo UF ON UF.UserInfoId = T.EntityID
				 INNER JOIN usr_Authentication A ON UF.UserInfoId = A.UserInfoID				 
				 INNER JOIN com_Code C ON UF.StatusCodeId = C.CodeID
				 LEFT JOIN mst_Company CM ON UF.CompanyId = CM.CompanyId
				 LEFT JOIN vw_UserRoleNames UR ON UF.UserInfoId = UR.UserInfoID
				 --LEFT JOIN usr_RoleMaster RM ON UR.RoleID = RM.RoleId
		WHERE   UF.UserInfoId IS NOT NULL AND ((@inp_iPageSize = 0) OR (T.RowNumber BETWEEN ((@inp_iPageNo - 1) * @inp_iPageSize + 1) AND (@inp_iPageNo * @inp_iPageSize)))
		ORDER BY T.RowNumber
	

		RETURN 0
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue	=  @ERR_USER_LIST	
	END CATCH
END
