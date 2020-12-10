IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_com_SaveUserEulaAcceptance')
DROP PROCEDURE [dbo].[st_com_SaveUserEulaAcceptance]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Save user EULA acceptance details

Returns:		0, if Success.
				
Created by:		Priyanka Bhangale
Created on:		17-Feb-2015
-------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[st_com_SaveUserEulaAcceptance]
	@inp_iUserId			INT,						
	@inp_iDocumentID    	INT,						
	@inp_iEulaAcceptanceFlag BIT,													
	@out_nReturnValue		INT = 0 OUTPUT,
	@out_nSQLErrCode		INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage		NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
AS
BEGIN
	BEGIN TRY
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;

		INSERT INTO rpt_EULAAcceptanceReport VALUES(@inp_iUserId,@inp_iDocumentID,@inp_iEulaAcceptanceFlag,GETDATE())											

		SELECT 0

		SET @out_nReturnValue = 0
		RETURN @out_nReturnValue
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()
		
		-- Return common error if required, otherwise specific error.		
		SET @out_nReturnValue  = ERROR_NUMBER()
		RETURN @out_nReturnValue		
	END CATCH
END

