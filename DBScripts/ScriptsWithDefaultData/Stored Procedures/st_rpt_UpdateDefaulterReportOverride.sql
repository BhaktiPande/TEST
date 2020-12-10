IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_rpt_UpdateDefaulterReportOverride')
DROP PROCEDURE [dbo].[st_rpt_UpdateDefaulterReportOverride]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
Description:	Get the Defaulter Report Details

Returns:		0, if Success.
				
Created by:		Tushar
Created on:		24-Sep-2015

Modification History:
Modified By		Modified On	Description

Usage:
EXEC st_rpt_DefaulterReportOverrideDetails 1
-------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[st_rpt_UpdateDefaulterReportOverride]
	@inp_iDefaulterReportID					INT,	
	@inp_sReason							NVARCHAR(500),
	@inp_iIsRemovedFromNonCompliance		INT,						
	@out_nReturnValue						INT = 0 OUTPUT,
	@out_nSQLErrCode						INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage						NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
	
AS
BEGIN
	DECLARE @ERR_DefaulterReportOverride INT = 19314 -- Error occurred while fetching code details.
	DECLARE @ERR_DefaulterReportOverride_NOTFOUND INT = 19313 -- Code does not exist.

	BEGIN TRY
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;
		
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0

		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0

		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''

		--Initialize variables

		--Check if the Code whose details are being fetched exists
		IF (NOT EXISTS(SELECT DefaulterReportID FROM rpt_DefaulterReport WHERE DefaulterReportID = @inp_iDefaulterReportID))
		BEGIN
				SET @out_nReturnValue = @ERR_DefaulterReportOverride_NOTFOUND
				RETURN (@out_nReturnValue)
		END
				
		IF(EXISTS(SELECT DefaulterReportID FROM rpt_DefaulterReportOverride WHERE DefaulterReportID = @inp_iDefaulterReportID))
		BEGIN
			UPDATE rpt_DefaulterReportOverride
			SET Reason = @inp_sReason,
				IsRemovedFromNonCompliance = @inp_iIsRemovedFromNonCompliance
			WHERE DefaulterReportID = @inp_iDefaulterReportID
		END
		ELSE
		BEGIN
			INSERT INTO rpt_DefaulterReportOverride(DefaulterReportID,Reason,IsRemovedFromNonCompliance)
			VALUES(@inp_iDefaulterReportID,@inp_sReason,@inp_iIsRemovedFromNonCompliance)
		END
		
		
		

		SET @out_nReturnValue = 0
		RETURN @out_nReturnValue
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()
		
		-- Return common error if required, otherwise specific error.		
		SET @out_nReturnValue  = dbo.uf_com_GetErrorCode(@ERR_DefaulterReportOverride, ERROR_NUMBER())
		RETURN @out_nReturnValue		
	END CATCH
END

