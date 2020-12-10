IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_usr_ValidateUser')
DROP PROCEDURE [dbo].[st_usr_ValidateUser]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
Description:	Validates user

Returns:		0, if Success.
				
Created by:		Arundhati
Created on:		16-Feb-2015

Modification History:
Modified By		Modified On		Description
Swapnil M		17-Mar-2015		Added method to handle error if login id an password are wrong.
Arundhati		18-MAr-2015		Error code added
Raghvendra		10-Jul-2015		Changed the message code to be send when username password are invalid 

Usage:
DECLARE @RC int
EXEC st_usr_DocumentDetailsDelete 1, 1
-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_usr_ValidateUser] 
	-- Add the parameters for the stored procedure here
	@inp_sLoginId varchar(100),
	@inp_sPassword varchar(200),
	@out_nReturnValue		INT = 0 OUTPUT,		
	@out_nSQLErrCode		INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage		NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @nUserId INT
	SET @nUserId = 0
	DECLARE @ERR_INCORRECTDATA INT = 11272
	
	SELECT @nUserId = UserInfoID FROM usr_Authentication where LoginID = @inp_sLoginId AND Password = @inp_sPassword
	
    IF @nUserId IS NOT NULL AND @nUserId <> 0
	BEGIN
		
		SELECT * FROM usr_UserInfo WHERE UserInfoId = @nUserId 
	END
	ELSE
	BEGIN
		SET @out_nReturnValue = @ERR_INCORRECTDATA
		RETURN @out_nReturnValue 
	END
	
	SET @out_nReturnValue = 0
	RETURN @out_nReturnValue 
END
