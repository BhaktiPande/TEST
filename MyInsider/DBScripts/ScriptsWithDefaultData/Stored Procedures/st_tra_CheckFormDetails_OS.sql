IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_tra_CheckFormDetails_OS')
DROP PROCEDURE [dbo].[st_tra_CheckFormDetails_OS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	This procedure used for getting details for FORM B for  OS

Returns:		0, if Success.
				
Created by:		
Created on:		

Usage:
EXEC [st_tra_CheckFormDetails_OS] 132020,6
-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_tra_CheckFormDetails_OS]
	
	@inp_iMapToTypeCodeId		INT,
	@inp_iMapToId				INT,
	@out_nReturnValue			INT = 0 OUTPUT,
	@out_nSQLErrCode			INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage			NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
AS
BEGIN

	DECLARE @ERR_DOCUMENTDETAILS_NOTFOUND INT = 54059 -- Document details does not exist.
	DECLARE @ERR_GetGeneratedFormDetails INT = 54059 -- Error occurred while fetching document details. -- Code need to change
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

		
		SELECT * 
		FROM tra_GeneratedFormDetails GFD
		WHERE MapToTypeCodeId = @inp_iMapToTypeCodeId AND MapToId = @inp_iMapToId 
		--SET @out_nReturnValue = 0
		--RETURN @out_nReturnValue
		
	END	 TRY
	
	BEGIN CATCH	
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()	
		
		-- Return common error if required, otherwise specific error.		
		SET @out_nReturnValue =  dbo.uf_com_GetErrorCode(@ERR_GetGeneratedFormDetails, ERROR_NUMBER())
		RETURN @out_nReturnValue
	END CATCH
END