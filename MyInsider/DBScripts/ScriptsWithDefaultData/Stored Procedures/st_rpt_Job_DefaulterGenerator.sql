IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_rpt_Job_DefaulterGenerator')
DROP PROCEDURE [dbo].[st_rpt_Job_DefaulterGenerator]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
Description:	Procedure to Invoke individual procedures to populate defaulters' data in the table

Returns:		0, if Success.
				
Created by:		Arundhati
Created on:		22-Sep-2015

Modification History:
Modified By		Modified On		Description

Usage:
EXEC 
-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_rpt_Job_DefaulterGenerator]
---------------------------------------------------------------------------
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
		-- Declare variables
		
		EXEC @RC = st_tra_Generate_PE @nReturnValue OUTPUT, @nSQLErrCode OUTPUT, @sSQLErrMessage OUTPUT
		
		EXEC @RC = st_rpt_DefaulterGenerate @nReturnValue OUTPUT, @nSQLErrCode OUTPUT, @sSQLErrMessage OUTPUT

		RETURN 0
	END	 TRY
	
	BEGIN CATCH		
		print 'into final catch block'
		print 'Error code: ' + CAST(ERROR_NUMBER() AS VARCHAR) + ' -- Error message : ' + ERROR_MESSAGE() 
	END CATCH
END
