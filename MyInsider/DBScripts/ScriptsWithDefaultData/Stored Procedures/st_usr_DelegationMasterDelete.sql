IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_usr_DelegationMasterDelete')
DROP PROCEDURE [dbo].[st_usr_DelegationMasterDelete]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Procedure to delete delegations.

Returns:		0, if Success.
				
Created by:		Arundhati
Created on:		03-Mar-2015

Modification History:
Modified By		Modified On		Description
Raghvendra		07-Sep-2016		Changed the GETDATE() call with function dbo.uf_com_GetServerDate(). This function will return the date to be used as server date.

Usage:
EXEC st_usr_DelegationMasterSave
-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_usr_DelegationMasterDelete]
	@inp_nDelegationId				INT
	,@inp_nLoggedInUserId			INT
	,@out_nReturnValue				INT = 0 OUTPUT
	,@out_nSQLErrCode				INT = 0 OUTPUT				-- Output SQL Error Number, if error occurred.
	,@out_sSQLErrMessage			VARCHAR(500) = '' OUTPUT  -- Output SQL Error Message, if error occurred.	
AS
BEGIN
	DECLARE @ERR_DELEGATION_DELETE INT = 12022 -- Error occurred while deleting delegations.
	DECLARE @ERR_DELEGATION_NOTFOUND INT = 12018 -- Delegation does not exist.
	DECLARE @ERR_CANNOTDELETEDEGATION INT = 12023 -- Cannot delete delegation. To delete delegation record, Start date must be greater than today

	DECLARE @dtToday DATETIME = CONVERT(DATETIME, CONVERT(VARCHAR(11), dbo.uf_com_GetServerDate()))
	
	BEGIN TRY
		
		SET NOCOUNT ON;
		-- Declare variables
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''

		--Check if the DelegationId being updated exists
		IF (NOT EXISTS(SELECT DelegationId FROM usr_DelegationMaster WHERE DelegationId = @inp_nDelegationId))
		BEGIN		
			SET @out_nReturnValue = @ERR_DELEGATION_NOTFOUND
			RETURN (@out_nReturnValue)
		END
		
		IF (EXISTS(SELECT DelegationId FROM usr_DelegationMaster WHERE DelegationId = @inp_nDelegationId AND DelegationFrom <= @dtToday))
		BEGIN		
			SET @out_nReturnValue = @ERR_CANNOTDELETEDEGATION
			RETURN (@out_nReturnValue)
		END
		
		DELETE FROM usr_DelegationDetails WHERE DelegationId = @inp_nDelegationId
		DELETE FROM usr_DelegationMaster WHERE DelegationId = @inp_nDelegationId
		
		RETURN 0
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue	=  @ERR_DELEGATION_DELETE
	END CATCH
END
