IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_usr_ActivityList')
DROP PROCEDURE [dbo].[st_usr_ActivityList]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Get the List of activities applicable to the user.

Returns:		0, if Success.
				
Created by:		Arundhati
Created on:		03-Feb-2015

Modification History:
Modified By		Modified On		Description
Arundhati		13-Mar-2015		Add activities got through delegation
Parag			11-Feb-2016		Made change get activity-url mapping 
Parag			19-Feb-2016		Made change add activity id "0" to redirect to dashboard when user login
Raghvendra		07-Sep-2016		Changed the GETDATE() call with function dbo.uf_com_GetServerDate(). This function will return the date to be used as server date.

Usage:
EXEC st_mst_MenuMasterList 2
-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_usr_ActivityList]
	
	@inp_iPageSize INT = 10,
	@inp_iPageNo INT = 1,
	@inp_sSortField VARCHAR(255),
	@inp_sSortOrder	VARCHAR(5),	
	@inp_sUserInfoId int, -- Id of the logged in user
	@out_nReturnValue	INT = 0 OUTPUT,
	@out_nSQLErrCode			INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage			VARCHAR(500) = '' OUTPUT  -- Output SQL Error Message, if error occurred.
	
AS
BEGIN
	DECLARE @sSQL NVARCHAR(MAX)
	DECLARE @ERR_ACTIVITY_LIST INT = 10001
	DECLARE @dtToday DATETIME = CONVERT(DATETIME, CONVERT(VARCHAR(11), dbo.uf_com_GetServerDate())) 
	
	IF @out_nReturnValue IS NULL
		SET @out_nReturnValue = 0
	IF @out_nSQLErrCode IS NULL
		SET @out_nSQLErrCode = 0
	IF @out_sSQLErrMessage IS NULL
		SET @out_sSQLErrMessage = ''

	BEGIN TRY
		
		SET NOCOUNT ON;
		-- Declare variables
		DECLARE @USER_STATUS_ACTIVE INT,
				@APPROVER_ROLE_ID INT,
				@ACTIVE_ROLE_ID INT 

		SELECT	@sSQL = ''
			
		CREATE TABLE #tmpActivityList (ActivityId INT)
		
		INSERT INTO #tmpActivityList(ActivityId)
		SELECT DISTINCT ActivityID
		FROM usr_UserRole UR JOIN usr_RoleActivity RA ON UR.RoleID = RA.RoleID
		WHERE Userinfoid = @inp_sUserInfoId
		UNION
		-- Activities got through delegation
		SELECT DD.ActivityId 
		FROM usr_DelegationMaster DM JOIN usr_DelegationDetails DD ON DM.DelegationId = DD.DelegationId
		WHERE UserInfoIdTo = @inp_sUserInfoId
		AND DelegationFrom <= @dtToday AND DelegationTo >= @dtToday

		
		-- Based on search parameters, insert only the Primary Index Field in the temporary table.
		SELECT @sSQL = @sSQL + 'INSERT INTO #tmpList (RowNumber, EntityID)'
		
		-- if Called From CreateUser
		SELECT @inp_sSortField = 'ActivityID',
				@inp_sSortOrder = 'ASC'


		SELECT @sSQL = @sSQL + ' SELECT DISTINCT DENSE_RANK() OVER(Order BY ' + @inp_sSortField + ' ' + @inp_sSortOrder +',A.ActivityID),A.ActivityID '
		SELECT @sSQL = @sSQL + ' FROM #tmpActivityList A'
		SELECT @sSQL = @sSQL + ' WHERE 1 = 1' 
		
		PRINT(@sSQL)
		EXEC(@sSQL)
		
		
		SELECT 
			A.ActivityID, A.ScreenName, A.ActivityName, A.ModuleCodeID, A.ControlName, A.Description, A.StatusCodeID, 
			AUM.ControllerName, AUM.ActionName, AUM.ActionButtonName
		FROM #tmpActivityList t 
		JOIN usr_Activity A ON t.ActivityId = A.ActivityID
		LEFT JOIN usr_ActivityURLMapping AUM ON t.ActivityId = AUM.ActivityID
		UNION
		-- Add Activity id 0 mannually to redirect user to dashboard
		SELECT 0, '','Dashboard', 103001, NULL, '', 105001, 'Home', 'Index', NULL 
	
		DROP TABLE #tmpActivityList
		RETURN 0
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue	=  @ERR_ACTIVITY_LIST
	END CATCH
END
