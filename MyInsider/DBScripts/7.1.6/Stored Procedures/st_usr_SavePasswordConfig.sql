IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[st_usr_SavePasswordConfig]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[st_usr_SavePasswordConfig]
GO
/*******************************************************************************************************************
Description	: To save password configuration.

Returns		: 0, if Success.
				
Created by	: Priyanka Wani.
Created on	: 19-Jul-2017																
*******************************************************************************************************************/
CREATE PROCEDURE [dbo].[st_usr_SavePasswordConfig]
	@inp_iPasswordConfigID  INT,
	@inp_iMinLength		INT,
	@inp_iMaxLength		INT,
	@inp_iMinAlphabets	INT , 
	@inp_iMinNumbers	INT,
	@inp_iMinSplChar	INT,
	@inp_iMinUppercaseChar		INT,
	@inp_iCountOfPassHistory		INT,
	@inp_iPassValidity		INT,
	@inp_iExpiryReminder		INT,
	@inp_iLastUpdatedBy		VARCHAR(50),
	@inp_iLoginAttempts		INT,
	@out_nReturnValue		INT = 0 OUTPUT,  
	@out_nSQLErrCode		INT = 0 OUTPUT,			  -- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage		VARCHAR(500) = '' OUTPUT  -- Output SQL Error Message, if error occurred.
	
AS
BEGIN
	BEGIN try 
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;	
		
		UPDATE [usr_PasswordConfig]
			   SET [MinLength] = @inp_iMinLength
				  ,[MaxLength] = @inp_iMaxLength
				  ,[MinAlphabets] = @inp_iMinAlphabets
				  ,[MinNumbers] = @inp_iMinNumbers
				  ,[MinSplChar] = @inp_iMinSplChar
				  ,[MinUppercaseChar] = @inp_iMinUppercaseChar
				  ,[CountOfPassHistory] = @inp_iCountOfPassHistory
				  ,[PassValidity] = @inp_iPassValidity
				  ,[ExpiryReminder] = @inp_iExpiryReminder
				  ,[LastUpdatedOn] = GETDATE()
				  ,[LastUpdatedBy] = @inp_iLastUpdatedBy
				  ,[LoginAttempts] = @inp_iLoginAttempts
			 WHERE PasswordConfigID=@inp_iPasswordConfigID
		
		SET @out_nReturnValue = 0
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
