IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_com_MassUploadGetAllMassUploads')
DROP PROCEDURE [dbo].[st_com_MassUploadGetAllMassUploads]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
Description:	This will return all the Mass Upload Types

Returns:		0, if Success.
				
Created by:		Raghvendra Wagholikar
Created on:		13-Oct-2015

Modification History:
Modified By		Modified On	Description
Raghvendra		4-Dec-2015	Moved the IF EXIST block above Comments
Raghvendra		25-Dec-2015	Added a parameter for accepting the Mass Upload Id for which to fetch the details for.
Raghvendra		13-Sep-2016	Added condition to return the sheet name when fetching the details for a single Mass upload excel

Usage:
EXEC st_com_MassUploadGetAllMassUploads 
-------------------------------------------------------------------------------------------------*/


CREATE PROCEDURE [dbo].[st_com_MassUploadGetAllMassUploads]
	@inp_nMassUploadId					INT = 0,					--The Mass Upload for which to fetch the details
	@out_nReturnValue					INT = 0 OUTPUT,
	@out_nSQLErrCode					INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage					NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
	
AS
BEGIN
	DECLARE @ERR_DURING_MASSUPLOADCODES INT
	
	BEGIN TRY
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;
		SELECT @ERR_DURING_MASSUPLOADCODES = 0
		
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0

		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0

		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''
		
		IF ISNULL(@inp_nMassUploadId,0) = 0
		BEGIN
			SELECT * FROM com_MassUploadExcel ORDER BY MassUploadExcelId
		END
		ELSE
		BEGIN
			SELECT top 1 ME.*,MS.SheetName AS SheetName FROM com_MassUploadExcel ME 
			JOIN com_MassUploadExcelSheets MS ON ME.MassUploadExcelId = MS.MassUploadExcelId
			WHERE ME.MassUploadExcelId = @inp_nMassUploadId
		END
			
		SET @out_nReturnValue = 0
		RETURN @out_nReturnValue
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()
		
		-- Return common error if required, otherwise specific error.		
		SET @out_nReturnValue  = dbo.uf_com_GetErrorCode(@ERR_DURING_MASSUPLOADCODES, ERROR_NUMBER())
		RETURN @out_nReturnValue		
	END CATCH
END

