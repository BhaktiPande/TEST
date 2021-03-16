IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_rpt_Job_DefaulterGenerator_OS')
DROP PROCEDURE [dbo].[st_rpt_Job_DefaulterGenerator_OS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
Description:	Procedure to Invoke individual procedures to populate defaulters' data in the table

Returns:		0, if Success.
				
Created by:		Priyanka Bhangale
Created on:		30-July-2019
-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_rpt_Job_DefaulterGenerator_OS]
AS
BEGIN
	DECLARE @ERR_IDEMPLOYEEWISE INT = -1
	DECLARE @dtLastRunDate DATETIME
	
	DECLARE	@nReturnValue INT
	DECLARE	@nSQLErrCode INT
	DECLARE	@sSQLErrMessage VARCHAR(500)
	DECLARE @RC INT
	
	BEGIN TRY
		
		SET NOCOUNT ON;
		
		EXEC @RC = st_tra_Generate_PeriodEnd_OS @nReturnValue OUTPUT, @nSQLErrCode OUTPUT, @sSQLErrMessage OUTPUT
		
		EXEC @RC = st_rpt_DefaulterGenerate_OS @nReturnValue OUTPUT, @nSQLErrCode OUTPUT, @sSQLErrMessage OUTPUT

		RETURN 0
	END	 TRY
	
	BEGIN CATCH		
		print 'into final catch block'
		print 'Error code: ' + CAST(ERROR_NUMBER() AS VARCHAR) + ' -- Error message : ' + ERROR_MESSAGE() 
	END CATCH
END
