IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_tra_GetGeneratedFormDetails')
DROP PROCEDURE [dbo].[st_tra_GetGeneratedFormDetails]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	This procedure used for getting details for FORM E for that preclerance

Returns:		0, if Success.
				
Created by:		Tushar
Created on:		12-Sep-2016
Modification History:
Modified By		Modified On	Description

Usage:
DECLARE @RC int
EXEC st_tra_GetGeneratedFormDetails 132004,45
-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_tra_GetGeneratedFormDetails]
	@inp_iMapToTypeCodeId		INT,
	@inp_iMapToId				INT,
	@out_nReturnValue			INT = 0 OUTPUT,
	@out_nSQLErrCode			INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage			NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
AS
BEGIN

	DECLARE @ERR_DOCUMENTDETAILS_NOTFOUND INT = 17457 -- Document details does not exist.
	DECLARE @ERR_GetGeneratedFormDetails INT = 17456 -- Error occurred while fetching document details.
	DECLARE @nRetValue INT

	BEGIN TRY
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;

		--Initialize variables
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''
		

		--Check if the DMAT whose details are being fetched exists
		IF (NOT EXISTS(select GeneratedFormDetailsId from tra_GeneratedFormDetails WHERE MapToTypeCodeId = @inp_iMapToTypeCodeId AND MapToId = @inp_iMapToId))
		BEGIN
				SET @out_nReturnValue = @ERR_DOCUMENTDETAILS_NOTFOUND
				RETURN (@out_nReturnValue)
		END
		
	
		
		SELECT * 
		FROM tra_GeneratedFormDetails GFD
		WHERE MapToTypeCodeId = @inp_iMapToTypeCodeId AND MapToId = @inp_iMapToId

		SET @out_nReturnValue = 0
		RETURN @out_nReturnValue
		
	END	 TRY
	
	BEGIN CATCH	
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()	
		
		-- Return common error if required, otherwise specific error.		
		SET @out_nReturnValue =  dbo.uf_com_GetErrorCode(@ERR_GetGeneratedFormDetails, ERROR_NUMBER())
		RETURN @out_nReturnValue
	END CATCH
END