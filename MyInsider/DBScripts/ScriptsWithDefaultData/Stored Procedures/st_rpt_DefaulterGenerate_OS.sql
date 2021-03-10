IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_rpt_DefaulterGenerate_OS')
DROP PROCEDURE [dbo].[st_rpt_DefaulterGenerate_OS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Procedure to Invoke individual procedures to populate defaulters' data in the table

Returns:		0, if Success.
				
Created by:		
Created on:		04-Jan-2021

Modification History:
Modified By		Modified On		Description

Usage:
EXEC 
-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_rpt_DefaulterGenerate_OS]
	@out_nReturnValue		INT = 0 OUTPUT
	,@out_nSQLErrCode			INT = 0 OUTPUT				-- Output SQL Error Number, if error occurred.
	,@out_sSQLErrMessage		VARCHAR(500) = '' OUTPUT  -- Output SQL Error Message, if error occurred.	
---------------------------------------------------------------------------
AS
BEGIN
	DECLARE @ERR_IDEMPLOYEEWISE INT = -1
	DECLARE @dtLastRunDate DATETIME
	BEGIN TRY
		
		SET NOCOUNT ON;
		-- Declare variables
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''

		-- Insert record in rpt_DefaulterReportMaster if does not exist
		IF NOT EXISTS(SELECT * FROM rpt_DefaulterReportMaster_OS)
		BEGIN
			INSERT INTO rpt_DefaulterReportMaster_OS(DefaulterReportMaster, LastRunTime)
			VALUES(1, NULL)
		END
		
		SELECT @dtLastRunDate = MAX(LastRunTime) FROM rpt_DefaulterReportMaster_OS
		
		-- Invoke individual procedures here
		EXEC st_rpt_DefaulterGenerate_Initial_OS @dtLastRunDate, @out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT, @out_sSQLErrMessage OUTPUT
		
		EXEC st_rpt_DefaulterGenerate_PE_OS @dtLastRunDate, @out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT, @out_sSQLErrMessage OUTPUT
		
		EXEC st_rpt_DefaulterGenerate_Preclearance_OS @dtLastRunDate, @out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT, @out_sSQLErrMessage OUTPUT
		
		-- Update record in rpt_DefaulterReportMaster
		UPDATE rpt_DefaulterReportMaster_OS
		SET LastRunTime = dbo.uf_com_GetServerDate()


		RETURN 0
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue	=  @ERR_IDEMPLOYEEWISE
	END CATCH
END
