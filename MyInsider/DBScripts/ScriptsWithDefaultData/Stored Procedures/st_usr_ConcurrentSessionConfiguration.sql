
/*---------------------------------------------------------
Created by:		Hemant Kawade
Created on:		30-Nov-2020
Description:	Concurrent Session Configuration setting activate or not.	
------------------------------------------------------------*/

IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_usr_ConcurrentSessionConfiguration')
DROP PROCEDURE [dbo].[st_usr_ConcurrentSessionConfiguration]
GO

CREATE PROCEDURE [dbo].[st_usr_ConcurrentSessionConfiguration] 
	@out_nReturnValue		INT = 0 OUTPUT,		
	@out_nSQLErrCode		INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage		NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
AS
BEGIN
	BEGIN TRY
	SET NOCOUNT ON;

		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''

		DECLARE @IsActivatedConcurrentSession INT 	
		
		SELECT TOP 1 @IsActivatedConcurrentSession = IsActivatedConcurrentSession from mst_Company

		IF(@IsActivatedConcurrentSession = 538001)
		BEGIN
			SELECT 1
		END
		ELSE
		BEGIN
			SELECT 0
		END
		
	SET NOCOUNT OFF;
	RETURN 0
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue	=  'Error while returning user Login details'
	END CATCH
END
GO
