IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_usr_GetPasswordConfig')
DROP PROCEDURE [dbo].[st_usr_GetPasswordConfig]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
Description:	Get LoginAttempt count from usr_PasswordConfig

Returns:		0, if Success.
				
Created by:		Priyanka
Created on:		23-Mar-2017

Modification History:
Modified By		Modified On		Description

Usage:
DECLARE @RC int
EXEC st_usr_GetPasswordConfig
-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_usr_GetPasswordConfig] 
	-- Add the parameters for the stored procedure here
	@out_nReturnValue		INT = 0 OUTPUT,		
	@out_nSQLErrCode		INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage		NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
AS
BEGIN
	SET NOCOUNT ON;
	
	SELECT * FROM usr_PasswordConfig
	
	SET @out_nReturnValue = 0
	RETURN @out_nReturnValue 
END
