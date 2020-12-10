IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_com_GetDematAccountList')
DROP PROCEDURE st_com_GetDematAccountList
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
Description:	Get demat account list applicable to user

Returns:		0, if Success.
				
Created by:		Parag
Created on:		06-Sept-2016

Modification History:
Modified By		Modified On	Description
Raghvendra		19-Sep-2016	Changes done to give a call to function uf_com_GetApplicableDEMATList. 
							The logic initially used for finding the DEMAT list has been moved in the said 
							function. To keep the logic at single place corresponding function will be called 
							in this procedure.
Usage:

-------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE st_com_GetDematAccountList
	@inp_nForUserInfoId			INT,
	@inp_nActionTypeId			INT = NULL,	-- refer to code group 183
	@inp_bIsWithRelative		BIT = 0,
	@out_nReturnValue			INT = 0 OUTPUT,
	@out_nSQLErrCode			INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage			NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
	
AS
BEGIN
	DECLARE @ERR_GET_DEMATACCOUNTLIST	INT = 0000
	
	BEGIN TRY
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;
		SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''
		
		SELECT DEMATID AS ID, Value AS Value, Width AS Width FROM dbo.uf_com_GetApplicableDEMATList(@inp_nForUserInfoId, @inp_nActionTypeId, @inp_bIsWithRelative)
				
		RETURN @out_nReturnValue
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()
		
		-- Return common error if required, otherwise specific error.		
		SET @out_nReturnValue  = dbo.uf_com_GetErrorCode(@ERR_GET_DEMATACCOUNTLIST, ERROR_NUMBER())
		RETURN @out_nReturnValue		
	END CATCH
END