IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_usr_DelegationActivityDetails')
DROP PROCEDURE [dbo].[st_usr_DelegationActivityDetails]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Get the DelegationActivity details

Returns:		0, if Success.
				
Created by:		Amar
Created on:		09-Mar-2015

Modification History:
Modified By		Modified On	Description
Arundhati		16-Mar-2015	Instead of INNER JOIN, it should be LEFT JOIN for user role for the To user. Distinct records are fetched.
Amar			08-May-2015 Added From and To user id in case delegation id set to zero. This was added in case where delegation master details
							are not saved and where there is a need to display activity list associated to from and to user.
Arundhati		25-Jun-2015	Multiple entries for same activity was shown. The query is changed now.
Usage:
EXEC st_usr_DelegationActivityDetails null
-------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[st_usr_DelegationActivityDetails]
	@inp_nDelegationMasterID			INT,			-- Id of the Delegation master whose details are to be fetched.
	@inp_nUserInfoIdFrom			INT,
	@inp_nUserInfoIdTo				INT,
	@out_nReturnValue		INT = 0 OUTPUT,
	@out_nSQLErrCode		INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage		NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
	
AS
BEGIN
	DECLARE @ERR_ROLEACTIVITY_GETDETAILS INT
	DECLARE @ERR_ROLE_NOTFOUND INT
	DECLARE @ACTIVITY_STATUS_ACTIVE INT
	DECLARE @sSQL NVARCHAR(MAX) = ''
	BEGIN TRY
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;

		--Initialize variables
		SELECT	@ERR_ROLEACTIVITY_GETDETAILS = 12010, -- Error occurred while fetching list activities for a role.
				@ACTIVITY_STATUS_ACTIVE = 105001

		CREATE TABLE #tmpFrom(ActivityId INT)
		CREATE TABLE #tmpTo(ActivityId INT)

		IF @inp_nDelegationMasterID <> 0
		BEGIN
			SELECT @inp_nUserInfoIdFrom = DM.UserInfoIdFrom, @inp_nUserInfoIdTo = DM.UserInfoIdTo
			FROM usr_DelegationMaster DM
			WHERE DelegationId = @inp_nDelegationMasterID
		END
		
		-- Find the activities associated with FromUser
		INSERT INTO #tmpFrom(ActivityId)
		SELECT DISTINCT ActivityID From usr_UserRole URFrom JOIN usr_RoleActivity RAFrom ON URFrom.RoleID = RAFrom.RoleID
		WHERE URFrom.UserInfoID = @inp_nUserInfoIdFrom

		-- Find the activities associated with ToUser
		INSERT INTO #tmpTo(ActivityId)
		SELECT DISTINCT ActivityID  From usr_UserRole URTo JOIN usr_RoleActivity RATo ON URTo.RoleID = RATo.RoleID
		WHERE URTo.UserInfoID = @inp_nUserInfoIdTo

		IF @inp_nDelegationMasterID = 0
		BEGIN
			SELECT RAFrom.ActivityID AS ActivityID, ScreenName,ActivityName,C.CodeName AS Module,ControlName,A.Description,C1.CodeName AS Status , 
			CASE WHEN RATo.ActivityID IS NULL THEN 0 ELSE 2 END AS IsSelected, 0 AS FlagDlg
			FROM #tmpFrom RAFrom
			JOIN usr_Activity A ON RAFrom.ActivityID = A.ActivityID JOIN com_Code C ON A.ModuleCodeID = C.CodeID 
			JOIN com_Code C1 ON A.StatusCodeID = C1.CodeID 
			LEFT JOIN #tmpTo RATo ON RAFrom.ActivityId = RATo.ActivityId		
		END
		ELSE
		BEGIN
			-- When DelegationId != 0
			SELECT DISTINCT RAFrom.ActivityID AS ActivityID, ScreenName,ActivityName,C.CodeName AS Module,ControlName,A.Description,C1.CodeName AS Status , 
			CASE WHEN RATo.ActivityID IS NULL THEN Case WHEN DD.ActivityID IS NULL THEN 0 ELSE 1 END ELSE 2 END AS IsSelected,
			CASE WHEN DD.ActivityID IS NULL THEN 0 ELSE 1 END AS FlagDlg 
			FROM #tmpFrom RAFrom
			JOIN usr_DelegationMaster URDM On URDM.DelegationId = @inp_nDelegationMasterID AND URDM.UserInfoIdFrom = @inp_nUserInfoIdFrom
			JOIN usr_Activity A ON RAFrom.ActivityID = A.ActivityID JOIN com_Code C ON A.ModuleCodeID = C.CodeID 
			JOIN com_Code C1 ON A.StatusCodeID = C1.CodeID LEFT JOIN usr_UserRole URTo ON URTo.UserInfoID = URDM.UserInfoIdTo  
			LEFT JOIN #tmpTo RATo ON RAFrom.ActivityId = RATo.ActivityId
			LEFT JOIN usr_DelegationDetails DD ON DD.DelegationId = @inp_nDelegationMasterID AND DD.ActivityId = RAFrom.ActivityID 		
		END

		DROP TABLE #tmpFrom
		DROP TABLE #tmpTo
	

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

