IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_usr_RoleActivitySaveDelete')
DROP PROCEDURE [dbo].[st_usr_RoleActivitySaveDelete]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
Description:	Save and delete the Records for Role Activity.

Returns:		0, if Success.
				
Created by:		Gaurishankar
Created on:		27-Feb-2015
Modification History:
Modified By		Modified On		Description
Arundhati		16-Mar-2015		Activities delegated, should not be deleted from role.
Gaurishankar	17-Jul-2015		Change for delete All activity ids for that role and no other activty to insert 
								(When all activity Ids is deleted then the param @inp_tblRoleActivityType have the ActivityId = 0)
Raghvendra		1-Apr-2016		Fix for returning single value when error code is returned from the procedure.
Raghvendra		07-Sep-2016		Changed the GETDATE() call with function dbo.uf_com_GetServerDate(). This function will return the date to be used as server date.

Usage:
DECLARE @RC int
EXEC st_usr_RoleActivitySaveDelate ,1
-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_usr_RoleActivitySaveDelete] 
	@inp_tblRoleActivityType RoleActivityType READONLY,
	@inp_iLoggedInUserId	INT,						-- Id of the user inserting/updating the RoleMaster
	@out_nReturnValue		INT = 0 OUTPUT,
	@out_nSQLErrCode		INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage		NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
AS
BEGIN
	DECLARE @ERR_ROLEMASTER_SAVE INT = 12016 -- Error occurred while saving activities for role.
	DECLARE @ERR_ROLEMASTER_NOTFOUND INT = 12002 -- Role does not exist.
	DECLARE @ERR_ACTIVITIESDELEGATED INT = 12043 -- 
	DECLARE @tmpActivitiesUnselected TABLE(ActivityId INT)
	
	DECLARE @nRoleId INT
	BEGIN TRY
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;

		--Initialize variables
				
		SELECT TOP 1 @nRoleId = RoleId
		FROM @inp_tblRoleActivityType
		
		--Check if the RoleMaster whose details are being updated exists				
		IF (NOT EXISTS(SELECT RoleId FROM usr_RoleMaster WHERE RoleId = @nRoleId))	
		BEGIN		
			SET @out_nReturnValue = @ERR_ROLEMASTER_NOTFOUND
			SELECT 0
			RETURN (@out_nReturnValue)
		END
		
		-- List all activities which are deselected for while editing role-activity association
		INSERT INTO @tmpActivitiesUnselected(ActivityId)
		SELECT RA.ActivityID
		FROM usr_RoleActivity RA
		LEFT JOIN @inp_tblRoleActivityType RAT ON RAT.RoleId = RA.RoleID AND RAT.ActivityId > 0 AND RAT.ActivityId = RA.ActivityID
		WHERE RA.RoleID = @nRoleId AND RAT.RoleId IS NULL
		
		-- Check that the activities deselected, are not delegated for future.
		IF EXISTS(
			SELECT RA.ActivityID FROM usr_UserRole UR
				JOIN usr_RoleActivity RA ON UR.RoleID = RA.RoleID
				JOIN usr_DelegationMaster DM ON DM.UserInfoIdFrom = UR.UserInfoID
				JOIN usr_DelegationDetails DD ON DM.DelegationId = DD.DelegationId AND DD.ActivityId = RA.ActivityID
				JOIN @tmpActivitiesUnselected tmpDelete ON RA.ActivityID = tmpDelete.ActivityId
			WHERE UR.RoleID = @nRoleId
				AND DM.DelegationFrom >= CONVERT(DATETIME, CONVERT(VARCHAR(11), dbo.uf_com_GetServerDate()))
			)
		BEGIN
			SET @out_nReturnValue = @ERR_ACTIVITIESDELEGATED
			SELECT 0
			RETURN (@out_nReturnValue)
		END
		-- The ActivityId > 0 check is to delete All activity for that role 		
		DELETE RA FROM usr_RoleActivity RA
		LEFT JOIN @inp_tblRoleActivityType RAT ON RAT.RoleId = RA.RoleID AND RAT.ActivityId > 0 AND RAT.ActivityId = RA.ActivityID
		WHERE RA.RoleID = @nRoleId AND RAT.RoleId IS NULL
		
		--Save the RoleActivity details
		-- The ActivityId > 0 check is to delete All activity for that role and no other activty to insert 
		--(When all activity Ids is deleted then the param @inp_tblRoleActivityType have the ActivityId = 0)
		INSERT INTO usr_RoleActivity
		(
			[ActivityID]
			,[RoleID]
			,[CreatedBy]
			,[CreatedOn]
			,[ModifiedBy]
			,[ModifiedOn]
		)	
		SELECT RAT.ActivityId, RAT.RoleId, @inp_iLoggedInUserId,dbo.uf_com_GetServerDate(),@inp_iLoggedInUserId,dbo.uf_com_GetServerDate() FROM usr_RoleActivity RA
		RIGHT JOIN @inp_tblRoleActivityType RAT ON RAT.RoleId = RA.RoleID AND RAT.ActivityId > 0 AND RAT.ActivityId = RA.ActivityID 
		WHERE  RA.RoleId IS NULL 	AND RAT.ActivityId > 0 
		
		SELECT TOP 1 ActivityId FROM usr_RoleActivity WHERE RoleID = @nRoleId 
		SET @out_nReturnValue = 0
		RETURN @out_nReturnValue
	END	 TRY
	
	BEGIN CATCH	
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()	
		
		-- Return common error if required, otherwise specific error.		
		SET @out_nReturnValue =  dbo.uf_com_GetErrorCode(@ERR_ROLEMASTER_SAVE, ERROR_NUMBER())
		SELECT 0
		RETURN @out_nReturnValue
	END CATCH

END