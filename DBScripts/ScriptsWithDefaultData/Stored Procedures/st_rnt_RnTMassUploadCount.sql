IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_rnt_RnTMassUploadCount')
	DROP PROCEDURE st_rnt_RnTMassUploadCount
GO

-- ======================================================================================================
-- Author      : Gaurav Ugale																			=
-- CREATED DATE: 19-NOV-2015                                                 							=
-- Description : THIS PROCEDURE IS USED FOR R & T Massupload Same Day Count								=
-- EXEC st_rnt_RnTMassUploadCount	0																	=
-- ======================================================================================================
/*
Modified By	Modified On	Description
Raghvendra	07-Sep-2016	Changed the GETDATE() call with function dbo.uf_com_GetServerDate(). This function will return the date to be used as server date.

*/

CREATE PROCEDURE [dbo].[st_rnt_RnTMassUploadCount]
(
	@out_sMassUploadCount				INT OUTPUT,					
	@out_nReturnValue					INT = 0 OUTPUT,
	@out_nSQLErrCode					INT = 0 OUTPUT,	
	@out_sSQLErrMessage					NVARCHAR(500) = '' OUTPUT	
)	
AS
BEGIN
	DECLARE @ERR_DURING_FETCH_MASSUPLOAD_COUNT INT
	
	BEGIN TRY
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;
		SELECT @ERR_DURING_FETCH_MASSUPLOAD_COUNT = 0
		
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0

		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0

		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''

		SELECT @out_sMassUploadCount = COUNT(RntInfoId)FROM rnt_MassUploadDetails WHERE CONVERT(DATE,CreatedOn) = CONVERT(DATE,dbo.uf_com_GetServerDate())

		SET @out_nReturnValue = 0
		RETURN @out_nReturnValue
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()
		
		-- Return common error if required, otherwise specific error.		
		SET @out_nReturnValue  = dbo.uf_com_GetErrorCode(@ERR_DURING_FETCH_MASSUPLOAD_COUNT, ERROR_NUMBER())
		RETURN @out_nReturnValue		
	END CATCH
END
GO