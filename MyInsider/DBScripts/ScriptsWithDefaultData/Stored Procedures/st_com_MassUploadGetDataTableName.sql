IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_com_MassUploadGetDataTableName')
DROP PROCEDURE [dbo].[st_com_MassUploadGetDataTableName]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
Description:	Get the massupload datatable name for the given mass upload data table id .
It gets the data from following tables,
1) com_MassUploadDataTable

Returns:		0, if Success.
				
Created by:		Raghvendra Wagholikar
Created on:		06-May-2015

Modification History:
Modified By		Modified On	Description
Raghvendra		4-Dec-2015	Moved the IF EXIST block above Comments
Usage:
EXEC st_com_MassUploadGetDataTableName 1
-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_com_MassUploadGetDataTableName]
	@inp_iMassUploadDataTableId					INT,							-- MassUploadId for which mass upload is to be performed.
	@out_sDatatableName					VARCHAR(200) OUTPUT,					-- Mass upload DataTable name 
	@out_nReturnValue					INT = 0 OUTPUT,
	@out_nSQLErrCode					INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage					NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
	
AS
BEGIN
	DECLARE @ERR_DURING_FETCH_MASSUPLOAD_DATATABLENAME INT
	
	BEGIN TRY
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;
		SELECT @ERR_DURING_FETCH_MASSUPLOAD_DATATABLENAME = 0
		
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0

		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0

		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''

		SELECT @out_sDatatableName = MassUploadDataTableName FROM com_MassUploadDataTable WHERE MassUploadDataTableId = @inp_iMassUploadDataTableId

		SET @out_nReturnValue = 0
		RETURN @out_nReturnValue
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()
		
		-- Return common error if required, otherwise specific error.		
		SET @out_nReturnValue  = dbo.uf_com_GetErrorCode(@ERR_DURING_FETCH_MASSUPLOAD_DATATABLENAME, ERROR_NUMBER())
		RETURN @out_nReturnValue		
	END CATCH
END

