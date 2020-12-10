IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_usr_DelegationMasterDetails')
DROP PROCEDURE [dbo].[st_usr_DelegationMasterDetails]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Get Delegate Master Details.

Returns:		0, if Success.
				
Created by:		Amar
Created on:		10-Mar-2015
Modification History:
Modified By		Modified On	Description

Usage:
DECLARE @RC int
EXEC st_usr_DelegationMasterDetails ,1
-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_usr_DelegationMasterDetails]
	@inp_nDelegationMasterDetailsID		INT,
	@out_nReturnValue		INT = 0 OUTPUT,
	@out_nSQLErrCode		INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage		NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
AS
BEGIN

	DECLARE @ERR_DELEGATIONMASTERDETAILS_NOTFOUND INT = 12018 -- Delegation does not exist
	DECLARE @ERR_DELEGATIONMASTERDETAILS_GETDETAILS INT = 12031 -- Error occurred while fetching delegation details.
	
	DECLARE @nRetValue INT

	BEGIN TRY
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;

		--Initialize variables
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''

		--Check if the Delegation master whose details are being fetched exists
		IF (NOT EXISTS(SELECT DelegationId FROM usr_DelegationMaster WHERE DelegationId = @inp_nDelegationMasterDetailsID))
		BEGIN
				SET @out_nReturnValue = @ERR_DELEGATIONMASTERDETAILS_NOTFOUND
				RETURN (@out_nReturnValue)
		END

		--Fetch the delegation master details
		SELECT * 
		FROM usr_DelegationMaster
		WHERE DelegationId = @inp_nDelegationMasterDetailsID

		SET @out_nReturnValue = 0
		RETURN @out_nReturnValue
		
	END	 TRY
	
	BEGIN CATCH	
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()	
		
		-- Return common error if required, otherwise specific error.		
		SET @out_nReturnValue =  dbo.uf_com_GetErrorCode(@ERR_DELEGATIONMASTERDETAILS_GETDETAILS, ERROR_NUMBER())
		RETURN @out_nReturnValue
	END CATCH
END