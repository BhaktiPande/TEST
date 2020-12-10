IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_usr_RoleList')
DROP PROCEDURE [dbo].[st_usr_RoleList]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
Description:	Procedure to list roles

Returns:		0, if Success.
				
Created by:		Arundhati
Created on:		18-Feb-2015

Modification History:
Modified By		Modified On		Description
Gaurishankar	18-Jul-2015		Change for bug id 7458, Roles with no activities defined will have the activities action icon  displayed in red.

Usage:
EXEC st_role_RoleAssignmentList 2
-------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[st_usr_RoleList]
	@inp_iPageSize					INT = 10
	,@inp_iPageNo					INT = 1
	,@inp_sSortField				VARCHAR(255)
	,@inp_sSortOrder				VARCHAR(5)
    ,@inp_sRoleName					NVARCHAR(100)
    ,@inp_sDescription				NVARCHAR(255)
    ,@inp_iStatusCodeId				INT
    ,@inp_iUserTypeCodeId			INT
    ,@inp_iIsDefault				INT
	,@out_nReturnValue				INT = 0 OUTPUT
	,@out_nSQLErrCode				INT = 0 OUTPUT				-- Output SQL Error Number, if error occurred.
	,@out_sSQLErrMessage			VARCHAR(500) = '' OUTPUT  -- Output SQL Error Message, if error occurred.	
AS
BEGIN
	DECLARE @sSQL NVARCHAR(MAX) = ''
	DECLARE @ERR_ROLE_LIST INT = 12003 -- Error occurred while fetching list of users.


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
			SELECT @inp_sSortField = 'RM.RoleName '
		END 

		IF @inp_sSortField = 'usr_grd_12004'
		BEGIN 
			SELECT @inp_sSortField = 'RM.RoleName '
		END 

		IF @inp_sSortField = 'usr_grd_12005'
		BEGIN 
			SELECT @inp_sSortField = 'RM.Description '
		END

		IF @inp_sSortField = 'usr_grd_12006'
		BEGIN 
			SELECT @inp_sSortField = 'CStatus.CodeName '
		END

		IF @inp_sSortField = 'usr_grd_12007'
		BEGIN 
			SELECT @inp_sSortField = 'CUserType.CodeName '
		END
		
		IF @inp_sSortField = 'usr_grd_12025'
		BEGIN 
			SELECT @inp_sSortField = 'RM.IsDefault '
		END
		
		--print @sSQL
		SELECT @sSQL = @sSQL + ' SELECT DISTINCT DENSE_RANK() OVER(Order BY ' + @inp_sSortField + ' ' + @inp_sSortOrder +',RM.RoleId),RM.RoleId '				
		SELECT @sSQL = @sSQL + ' FROM usr_RoleMaster RM '				
		SELECT @sSQL = @sSQL + ' JOIN com_Code CUserType ON RM.UserTypeCodeId = CUserType.CodeID 
								 JOIN com_Code CStatus ON RM.StatusCodeId = CStatus.CodeID '
		SELECT @sSQL = @sSQL + ' WHERE 1 = 1 AND RoleID <> 1 '

   				
		IF (@inp_sRoleName IS NOT NULL AND @inp_sRoleName <> '')	
		BEGIN
			SELECT @sSQL = @sSQL + ' AND RM.RoleName LIKE N''%'+ @inp_sRoleName +'%'' '
		END
		
		IF (@inp_sDescription IS NOT NULL AND @inp_sDescription <> '')	
		BEGIN
			SELECT @sSQL = @sSQL + ' AND RM.Description LIKE N''%'+ @inp_sDescription +'%'' '
		END
		
		IF (@inp_iStatusCodeId IS NOT NULL AND @inp_iStatusCodeId <> 0)	
		BEGIN
			SELECT @sSQL = @sSQL + ' AND RM.StatusCodeId = '+ CAST(@inp_iStatusCodeId AS VARCHAR(10)) + ' '
		END

		IF (@inp_iUserTypeCodeId IS NOT NULL AND @inp_iUserTypeCodeId <> 0)	
		BEGIN
			SELECT @sSQL = @sSQL + ' AND RM.UserTypeCodeId = '+ CAST(@inp_iUserTypeCodeId AS VARCHAR(10)) + ' '
		END
				
		IF (@inp_iIsDefault IS NOT NULL AND @inp_iIsDefault <> 0)	
		BEGIN
			SELECT @sSQL = @sSQL + ' AND RM.IsDefault = '+ CAST(@inp_iIsDefault AS VARCHAR(10)) + ' '
		END
				
		--PRINT(@sSQL)
		EXEC(@sSQL)

		SELECT	RM.RoleId AS RoleId,
				RM.RoleName AS usr_grd_12004,
				RM.Description AS usr_grd_12005,
				CUserType.CodeName AS usr_grd_12007,
				CStatus.CodeName AS usr_grd_12006,
				RM.IsDefault AS usr_grd_12025,
				(SELECT COUNT(RA.ActivityID) FROM usr_RoleActivity RA WHERE RA.RoleID = RM.RoleId) AS RoleActivityCount
		FROM	 #tmpList T INNER JOIN
				 usr_RoleMaster RM ON RM.RoleId = T.EntityID
				 JOIN com_Code CUserType ON RM.UserTypeCodeId = CUserType.CodeID
				 JOIN com_Code CStatus ON RM.StatusCodeId = CStatus.CodeID
		WHERE   RM.RoleId IS NOT NULL AND ((@inp_iPageSize = 0) OR (T.RowNumber BETWEEN ((@inp_iPageNo - 1) * @inp_iPageSize + 1) AND (@inp_iPageNo * @inp_iPageSize)))
		ORDER BY T.RowNumber
	

		RETURN 0
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue	=  @ERR_ROLE_LIST
	END CATCH
END
