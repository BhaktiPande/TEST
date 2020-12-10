IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_usr_GetPasswordPolicy')
DROP PROCEDURE [dbo].[st_usr_GetPasswordPolicy]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Fetch the password policy for the company

Returns:		0, if Success.
				
Created by:		Raghvendra
Created on:		7-Apr-2016

Modification History:
Modified By		Modified On		Description
Raghvendra		7-Apr-2016		Changed the max character limit for password validation from 30 to 20 as same is mentioned on the screen
Usage:
DECLARE @RC int
EXEC st_usr_GetPasswordPolicy
-------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[st_usr_GetPasswordPolicy] 
	@out_nReturnValue		INT = 0 OUTPUT,
	@out_nSQLErrCode		INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage		NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
AS
BEGIN
	
	DECLARE @nUserInfoId INT
	DECLARE @nERRORCODE_PASSWORD_POLICY_NOT_DEFINED INT = 0
	BEGIN TRY
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;

		
		SELECT 20 AS MaxLength, 8 AS MinLength, 1 AS MinNoOfAlphabets, 1 AS MinNoOfNumbers, 1 AS MinSpecialCharacters, 1 AS MinUpperCaseLetters
			   
		SET @out_nReturnValue = 0
		RETURN @out_nReturnValue
	END	 TRY
	
	BEGIN CATCH	
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()	
		
		-- Return common error if required, otherwise specific error.		
		SET @out_nReturnValue =  @nERRORCODE_PASSWORD_POLICY_NOT_DEFINED
		RETURN @out_nReturnValue
	END CATCH
END
