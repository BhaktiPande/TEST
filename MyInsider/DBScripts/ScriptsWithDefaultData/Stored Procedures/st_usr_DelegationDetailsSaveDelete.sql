IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_usr_DelegationDetailsSaveDelete')
DROP PROCEDURE [dbo].[st_usr_DelegationDetailsSaveDelete]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Save and delete the Records for Delegation detail.

Returns:		0, if Success.
				
Created by:		Amar
Created on:		12-Mar-2015
Modification History:
Modified By		Modified On	Description

Usage:
DECLARE @RC int
EXEC st_usr_DelegationDetailsSaveDelate ,1
-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_usr_DelegationDetailsSaveDelete] 
	@inp_tblDelegationDetailsType RoleActivityType READONLY,
	@inp_iLoggedInUserId	INT,						-- Id of the user inserting/updating the RoleMaster
	@out_nReturnValue		INT = 0 OUTPUT,
	@out_nSQLErrCode		INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage		NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
AS
BEGIN
	SELECT 1
	DECLARE @ERR_DelegationDetails_SAVE INT = -1 -- Error occurred while saving activities for role.
	DECLARE @ERR_DelegationDetails_NOTFOUND INT = -1 -- Role does not exist.
	
	DECLARE @nDelegationMasterId INT
	BEGIN TRY
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;

		--Initialize variables
				
		SELECT TOP 1 @nDelegationMasterId = RoleId
		FROM @inp_tblDelegationDetailsType
		
		--Check if the RoleMaster whose details are being updated exists				
		IF (NOT EXISTS(SELECT DelegationId FROM usr_DelegationMaster WHERE DelegationId = @nDelegationMasterId))	
		BEGIN		
			SET @out_nReturnValue = @ERR_DelegationDetails_NOTFOUND
			RETURN (@out_nReturnValue)
		END

		--Save the RoleMaster details
		DELETE DD FROM usr_DelegationDetails DD
		LEFT JOIN @inp_tblDelegationDetailsType DDT ON DDT.RoleId = DD.DelegationId AND DDT.ActivityId = DD.ActivityId
		WHERE DD.DelegationId = @nDelegationMasterId AND DDT.RoleId IS NULL

		INSERT INTO usr_DelegationDetails
		(
			ActivityID,
			DelegationId
		)	
		SELECT DDT.ActivityId, DDT.RoleId FROM usr_DelegationDetails DD
		RIGHT JOIN @inp_tblDelegationDetailsType DDT ON DDT.RoleId = DD.DelegationId AND DDT.ActivityId = DD.ActivityID
		WHERE  DD.DelegationId IS NULL	
		

		SET @out_nReturnValue = 0
		select 1
		RETURN @out_nReturnValue
	END	 TRY
	
	BEGIN CATCH	
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()	
		
		-- Return common error if required, otherwise specific error.		
		SET @out_nReturnValue =  dbo.uf_com_GetErrorCode(@ERR_DelegationDetails_SAVE, ERROR_NUMBER())
		RETURN @out_nReturnValue
	END CATCH

END