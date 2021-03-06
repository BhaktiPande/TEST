IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_com_MassUploadGetAllCompanies')
DROP PROCEDURE [dbo].[st_com_MassUploadGetAllCompanies]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Get all the records from mst_Company for to be used to get the companyid based on the company name provided,

Returns:		0, if Success.
				
Created by:		Raghvendra Wagholikar
Created on:		28-Jun-2015

Modification History:
Modified By		Modified On	Description
Raghvendra		4-Dec-2015	Moved the IF EXIST block above Comments

Usage:
EXEC st_com_MassUploadGetAllCompanies 1
-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_com_MassUploadGetAllCompanies]
	@out_nReturnValue					INT = 0 OUTPUT,
	@out_nSQLErrCode					INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage					NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
	
AS
BEGIN
	DECLARE @ERR_DURING_MASSUPLOADCOMPANYNAMES INT
	
	BEGIN TRY
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;
		SELECT @ERR_DURING_MASSUPLOADCOMPANYNAMES = 0
		
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0

		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0

		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''

		SELECT * FROM mst_Company

		SET @out_nReturnValue = 0
		RETURN @out_nReturnValue
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()
		
		-- Return common error if required, otherwise specific error.		
		SET @out_nReturnValue  = dbo.uf_com_GetErrorCode(@ERR_DURING_MASSUPLOADCOMPANYNAMES, ERROR_NUMBER())
		RETURN @out_nReturnValue		
	END CATCH
END

