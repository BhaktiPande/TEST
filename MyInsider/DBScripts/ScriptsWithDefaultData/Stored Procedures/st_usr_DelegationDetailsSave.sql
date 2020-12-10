IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_usr_DelegationDetailsSave')
DROP PROCEDURE [dbo].[st_usr_DelegationDetailsSave]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Save and delete the Records for Role Activity.

Returns:		0, if Success.
				
Created by:		Arundhati
Created on:		03-Mar-2015

Modification History:
Modified By		Modified On	Description
Raghvendra		07-Sep-2016	Changed the GETDATE() call with function dbo.uf_com_GetServerDate(). This function will return the date to be used as server date.

Usage:
DECLARE @RC int
EXEC st_usr_RoleActivitySaveDelate ,1
-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_usr_DelegationDetailsSave] 
	@inp_tblDelegationActivityType RoleActivityType READONLY,
	@inp_iLoggedInUserId	INT,						-- Id of the user inserting/updating the RoleMaster
	@out_nReturnValue		INT = 0 OUTPUT,
	@out_nSQLErrCode		INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage		NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
AS
BEGIN
	SELECT 1
	DECLARE @ERR_DELEGATIONDETAILS_SAVE INT = 12024 --Error occurred while assigning activities to delegation.'
	DECLARE @ERR_DELEGATION_NOTFOUND INT = 12018 -- Delegation does not exist.
	DECLARE @ERR_CANNOTDELETEDEGATION INT = 12023 -- Cannot delete or change delegation. To delete delegation record, Start date must be greater than today

	DECLARE @dtToday DATETIME = CONVERT(DATETIME, CONVERT(VARCHAR(11), dbo.uf_com_GetServerDate()))
	
	DECLARE @nDelegationId INT
	BEGIN TRY
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;

		--Initialize variables
				
		SELECT TOP 1 @nDelegationId = RoleId
		FROM @inp_tblDelegationActivityType
		
		--Check if the RoleMaster whose details are being updated exists				
		IF (NOT EXISTS(SELECT DelegationId FROM usr_DelegationMaster WHERE DelegationId = @nDelegationId))	
		BEGIN		
			SET @out_nReturnValue = @ERR_DELEGATION_NOTFOUND
			RETURN (@out_nReturnValue)
		END

		-- Check that the start date is greater than today
		IF (EXISTS(SELECT DelegationId FROM usr_DelegationMaster WHERE DelegationId = @nDelegationId AND DelegationFrom <= @dtToday))
		BEGIN		
			SET @out_nReturnValue = @ERR_CANNOTDELETEDEGATION
			RETURN (@out_nReturnValue)
		END

		--Save the Delegation details
		DELETE DD FROM usr_DelegationDetails DD
		LEFT JOIN @inp_tblDelegationActivityType DAT ON DAT.RoleId = DD.DelegationId AND DAT.ActivityId = DD.ActivityID
		WHERE DD.DelegationId = @nDelegationId AND DAT.RoleId IS NULL

		INSERT INTO usr_DelegationDetails
		(
			DelegationId,
			ActivityId
		)	
		SELECT DAT.RoleId, DAT.ActivityId
		FROM usr_DelegationDetails DD
		RIGHT JOIN @inp_tblDelegationActivityType DAT ON DAT.RoleId = DD.DelegationId AND DAT.ActivityId = DD.ActivityID
		WHERE  DD.DelegationId IS NULL
		
		SET @out_nReturnValue = 0
		RETURN @out_nReturnValue
		
	END	 TRY
	
	BEGIN CATCH	
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()	
		
		-- Return common error if required, otherwise specific error.		
		SET @out_nReturnValue =  dbo.uf_com_GetErrorCode(@ERR_DELEGATIONDETAILS_SAVE, ERROR_NUMBER())
		RETURN @out_nReturnValue
	END CATCH

END