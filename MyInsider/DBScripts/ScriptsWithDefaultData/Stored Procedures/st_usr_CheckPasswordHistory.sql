IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[st_usr_CheckPasswordHistory]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[st_usr_CheckPasswordHistory]
GO
/*******************************************************************************************************************
Description	: Check password history

Returns		: 0, if Success.
				
Created by	: Priyanka Wani.
Created on	: 25-Jul-2017																
*******************************************************************************************************************/
CREATE PROCEDURE [dbo].[st_usr_CheckPasswordHistory]
	--@inp_iPassword  VARCHAR(200),
	@inp_iUserInfoId INT,
	@out_nReturnValue		INT = 0 OUTPUT,  
	@out_nSQLErrCode		INT = 0 OUTPUT,			  -- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage		VARCHAR(500) = '' OUTPUT  -- Output SQL Error Message, if error occurred.
	
AS
BEGIN
	DECLARE @nCountOfPassHistory INT
	BEGIN try 
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;	
		SELECT @nCountOfPassHistory=CountOfPassHistory FROM usr_PasswordConfig
		
		SELECT TOP (@nCountOfPassHistory) [Password] as PasswordValue,SaltValue FROM usr_PasswordHistory WHERE UserId=@inp_iUserInfoId 
			AND @nCountOfPassHistory<>0 ORDER BY ID DESC
			
		RETURN @out_nReturnValue
	END try 
	BEGIN catch
		-- Return common error if required, otherwise specific error.	
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()	
		SET @out_nReturnValue  = @out_nReturnValue
		RETURN @out_nReturnValue
	END catch
END
