
/*-------------------------------------------------------------------------------------------------
Description:	Get the  details of trading window calender rule activity

Created by:		Hemant Kawade
Created on:		07-July-2020

-------------------------------------------------------------------------------------------------*/

IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_usr_CalenderRuleDetails')
	DROP PROCEDURE [dbo].[st_usr_CalenderRuleDetails]
GO

CREATE PROCEDURE [dbo].[st_usr_CalenderRuleDetails]
	@inp_userInfoID			INT,						-- Id of the Role whose details are to be fetched.
	@out_nReturnValue		INT = 0 OUTPUT,
	@out_nSQLErrCode		INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage		NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
	
AS
BEGIN
	DECLARE @ERR_ROLE_NOTFOUND INT
	DECLARE @tmpActNotToBeDeleted TABLE (ActivityId INT)
	
	BEGIN TRY
		
		SET NOCOUNT ON;
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''

		--Initialize variables
		SELECT	@ERR_ROLE_NOTFOUND = 12002 -- Role does not exist.

		DECLARE @roleId INT

		SELECT DISTINCT @roleId = RA.RoleID
		FROM  usr_UserRole UR
		INNER JOIN usr_RoleActivity RA ON RA.RoleID = UR.RoleID
		WHERE UR.UserInfoID = @inp_userInfoID

		INSERT INTO @tmpActNotToBeDeleted
		SELECT RA.ActivityID FROM usr_UserRole UR
			JOIN usr_RoleActivity RA ON UR.RoleID = RA.RoleID
			JOIN usr_DelegationMaster DM ON DM.UserInfoIdFrom = UR.UserInfoID
			JOIN usr_DelegationDetails DD ON DM.DelegationId = DD.DelegationId AND RA.ActivityID = DD.ActivityId
		WHERE UR.RoleID = @roleId
			AND DM.DelegationFrom >= CONVERT(DATETIME, CONVERT(VARCHAR(11), dbo.uf_com_GetServerDate()))

		--Check if the Role for which activities are being fetched exists
		IF (NOT EXISTS(SELECT RoleID FROM usr_RoleMaster WHERE RoleID = @roleId))
		BEGIN
			SET @out_nReturnValue = @ERR_ROLE_NOTFOUND
			RETURN (@out_nReturnValue)
		END
		
		--Fetch the RoleActivity details
		SELECT ISNULL(
		(SELECT CASE WHEN ActNoToDelete.ActivityId IS NULL 
				THEN CASE WHEN RA.ActivityID IS NULL THEN 0 ELSE 1 END
				ELSE 2 END as IsActivated
		FROM  usr_RoleActivity RA 
		LEFT JOIN @tmpActNotToBeDeleted ActNoToDelete ON RA.ActivityID = ActNoToDelete.ActivityId
		WHERE RA.ActivityID = 215 AND RA.RoleID = @roleId),0) AS IsActivated
		
		SET @out_nReturnValue = 0
		RETURN @out_nReturnValue
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()		
		SET @out_nReturnValue  = 'Error while returning get trading calender rule details'
		RETURN @out_nReturnValue		
	END CATCH
END
GO