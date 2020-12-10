IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_usr_RoleActivityDetails')
DROP PROCEDURE [dbo].[st_usr_RoleActivityDetails]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
Description:	Get the RoleActivity details

Returns:		0, if Success.
				
Created by:		Gaurishankar
Created on:		16-Feb-2015

Modification History:
Modified By		Modified On	Description
Gaurishankar	16-Mar-2015	IsSelected = 2 when activity for given role is Delegated.
Raghvendra	07-Sep-2016	Changed the GETDATE() call with function dbo.uf_com_GetServerDate(). This function will return the date to be used as server date.
Usage:
EXEC st_usr_RoleActivityDetails null
-------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[st_usr_RoleActivityDetails]
	@inp_iRoleID			INT,						-- Id of the Role whose details are to be fetched.
	@out_nReturnValue		INT = 0 OUTPUT,
	@out_nSQLErrCode		INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage		NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
	
AS
BEGIN
	DECLARE @ERR_ROLEACTIVITY_GETDETAILS INT
	DECLARE @ERR_ROLE_NOTFOUND INT
	DECLARE @ACTIVITY_STATUS_ACTIVE INT
	DECLARE @tmpActNotToBeDeleted TABLE (ActivityId INT)
	DECLARE @ApplicableFor INT  
	DECLARE @IsMCQRequired INT
	DECLARE @IsPreClearanceEditable INT
	
	BEGIN TRY
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;

		--Initialize variables
		SELECT	@ERR_ROLE_NOTFOUND = 12002, -- Role does not exist.
				@ERR_ROLEACTIVITY_GETDETAILS = 12010, -- Error occurred while fetching list activities for a role.
				@ACTIVITY_STATUS_ACTIVE = 105001
		SELECT @ApplicableFor =RequiredModule from mst_Company where CompanyId = 1

		INSERT INTO @tmpActNotToBeDeleted
		SELECT RA.ActivityID FROM usr_UserRole UR
			JOIN usr_RoleActivity RA ON UR.RoleID = RA.RoleID
			JOIN usr_DelegationMaster DM ON DM.UserInfoIdFrom = UR.UserInfoID
			JOIN usr_DelegationDetails DD ON DM.DelegationId = DD.DelegationId AND RA.ActivityID = DD.ActivityId
		WHERE UR.RoleID = @inp_iRoleID
			AND DM.DelegationFrom >= CONVERT(DATETIME, CONVERT(VARCHAR(11), dbo.uf_com_GetServerDate()))

		--Check if the Role for which activities are being fetched exists
		IF (NOT EXISTS(SELECT RoleID FROM usr_RoleMaster WHERE RoleID = @inp_iRoleID))
		BEGIN
				SET @out_nReturnValue = @ERR_ROLE_NOTFOUND
				RETURN (@out_nReturnValue)
		END
		select @ApplicableFor = RequiredModule, @IsMCQRequired = ISNULL(IsMCQRequired,521002), @IsPreClearanceEditable = ISNULL(IsPreClearanceEditable,524002) from mst_Company where CompanyId = 1
		--Fetch the RoleActivity details
		IF(@ApplicableFor = 513003)
		BEGIN
		SELECT  A.ActivityID
			  ,ScreenName
			  ,ActivityName
			  ,C.CodeName AS Module
			  ,ControlName
			  ,A.Description
			  ,C1.CodeName AS Status
			  --,CASE WHEN RA.ActivityID IS NULL THEN 0 ELSE 1 END as IsSelected
			  ,CASE WHEN ActNoToDelete.ActivityId IS NULL THEN
				  CASE WHEN RA.ActivityID IS NULL THEN 0 ELSE 1 END
			   ELSE 2 END as IsSelected
		FROM usr_RoleMaster RM
			JOIN usr_Activity A ON RM.RoleId = @inp_iRoleID			
			JOIN usr_UserTypeActivity UTA ON RM.UserTypeCodeId = UTA.UserTypeCodeId AND UTA.ActivityId = A.ActivityID
			JOIN com_Code C ON A.ModuleCodeID = C.CodeID
			JOIN com_Code C1 ON A.StatusCodeID = C1.CodeID
			LEFT JOIN usr_RoleActivity RA ON A.ActivityID = RA.ActivityID AND RA.RoleID = RM.RoleId
			LEFT JOIN @tmpActNotToBeDeleted ActNoToDelete ON A.ActivityID = ActNoToDelete.ActivityId
		WHERE A.StatusCodeID = @ACTIVITY_STATUS_ACTIVE 
		AND A.ScreenName NOT IN (CASE WHEN @IsMCQRequired = 521002 THEN 'MCQ Setting' ELSE '0' END) 
        AND A.ActivityID NOT IN (CASE WHEN @IsPreClearanceEditable =524002 THEN '332' ELSE '0' END) 
		AND A.ActivityID NOT IN (CASE WHEN @IsPreClearanceEditable =524002 THEN '333' ELSE '0' END) 
		order by cast(A.DisplayOrder as int) ,ActivityID,ScreenName
		END
		ELSE
		BEGIN
		SELECT DISTINCT A.ActivityID
			  ,ScreenName
			  ,ActivityName
			  ,C.CodeName AS Module
			  ,ControlName
			  ,A.Description
			  ,C1.CodeName AS Status
	
			  --,CASE WHEN RA.ActivityID IS NULL THEN 0 ELSE 1 END as IsSelected
			  ,CASE WHEN ActNoToDelete.ActivityId IS NULL THEN
				  CASE WHEN RA.ActivityID IS NULL THEN 0 ELSE 1 END
			   ELSE 2 END as IsSelected
		FROM usr_RoleMaster RM
			JOIN usr_Activity A ON RM.RoleId = @inp_iRoleID			
			JOIN usr_UserTypeActivity UTA ON RM.UserTypeCodeId = UTA.UserTypeCodeId AND UTA.ActivityId = A.ActivityID
			JOIN com_Code C ON A.ModuleCodeID = C.CodeID
			JOIN com_Code C1 ON A.StatusCodeID = C1.CodeID
			JOIN mst_Company Cmp ON A.ApplicableFor = Cmp.RequiredModule OR A.ApplicableFor = 513003
			LEFT JOIN usr_RoleActivity RA ON A.ActivityID = RA.ActivityID AND RA.RoleID = RM.RoleId
			LEFT JOIN @tmpActNotToBeDeleted ActNoToDelete ON A.ActivityID = ActNoToDelete.ActivityId
		WHERE A.StatusCodeID = @ACTIVITY_STATUS_ACTIVE --order by cast(A.DisplayOrder as int) ,ActivityID,ScreenName
		AND A.ScreenName NOT IN (CASE WHEN @IsMCQRequired =521002 THEN 'MCQ Setting' ELSE '0' END) 
		AND A.ActivityID NOT IN (CASE WHEN @IsPreClearanceEditable =524002 THEN '332' ELSE '0' END) 
		AND A.ActivityID NOT IN (CASE WHEN @IsPreClearanceEditable =524002 THEN '333' ELSE '0' END) 
		END
		SET @out_nReturnValue = 0
		RETURN @out_nReturnValue
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()
		
		-- Return common error if required, otherwise specific error.		
		SET @out_nReturnValue  = dbo.uf_com_GetErrorCode(@ERR_ROLEACTIVITY_GETDETAILS, ERROR_NUMBER())
		RETURN @out_nReturnValue		
	END CATCH
END

