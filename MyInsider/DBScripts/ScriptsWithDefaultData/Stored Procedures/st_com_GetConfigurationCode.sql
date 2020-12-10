IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_com_GetConfigurationCode')
DROP PROCEDURE [dbo].[st_com_GetConfigurationCode]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/******************************************************************************************************************
Description:	Procedure to get configuration code for given code id

Returns:		Return 0, if success.
				
Created by:		Parag
Created on:		27-May-2015

Modification History:
Modified By		Modified On		Description


******************************************************************************************************************

Usage:

******************************************************************************************************************/

CREATE PROCEDURE [dbo].[st_com_GetConfigurationCode]
	@inp_nCodeId			INT,
	@inp_iReturnSelect		INT = 1,
	@out_nCodeName			INT OUTPUT,
	@out_nReturnValue		INT = 0 OUTPUT,
	@out_nSQLErrCode		INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage		VARCHAR(500) = '' OUTPUT  -- Output SQL Error Message, if error occurred.	
	
AS
BEGIN
	DECLARE @ERR_CONFIGURATIONCODE_NOTFOUND		INT = 14026  -- Error occurred while fetching configuration code.
	
	BEGIN TRY
		SET NOCOUNT ON;
		
		-- Declare variables
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''
		
		SELECT @out_nCodeName = CodeName FROM com_Code WHERE CodeGroupId = 128 AND CodeID = @inp_nCodeId
		
		--check to select value or not
		IF @inp_iReturnSelect = 1 
		BEGIN 
			SELECT 1 -- set this for petapoco lib 
		END 
		
		RETURN 0
			
	END TRY

	BEGIN CATCH
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue	=  @ERR_CONFIGURATIONCODE_NOTFOUND
	END CATCH
END
