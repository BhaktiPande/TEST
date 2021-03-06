IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_com_MassUploadGetAllComCodes')
DROP PROCEDURE [dbo].[st_com_MassUploadGetAllComCodes]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
Description:	Get all the records from com_Code to be used for MAss Upload to get the code id for given code name,

Returns:		0, if Success.
				
Created by:		Raghvendra Wagholikar
Created on:		28-Jun-2015

Modification History:
Modified By		Modified On	Description
Raghvendra		08-Oct-2015	Added entry for Self relation
Raghvendra		4-Dec-2015	Moved the IF EXIST block above Comments
Raghvendra		07-Sep-2016	Changed the GETDATE() call with function dbo.uf_com_GetServerDate(). This function will return the date to be used as server date.
Usage:
EXEC st_com_MassUploadGetconfiguration 1
-------------------------------------------------------------------------------------------------*/


CREATE PROCEDURE [dbo].[st_com_MassUploadGetAllComCodes]
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

		SELECT * FROM com_Code WHERE CodeGroupid <> 151
		UNION
		SELECT 100000,'Self',100,'Self',1,1,0,NULL,NULL,1,dbo.uf_com_GetServerDate()			--Add entry for Self relation type which is not present and handled at code level
		UNION
		SELECT 139000,'No Holdings',139,'No Holdings',1,1,0,NULL,NULL,1,dbo.uf_com_GetServerDate()	--Add entry for No Holding type security which is handled at code
		
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

