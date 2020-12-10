IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_com_GetDBServerDate')
DROP PROCEDURE [dbo].[st_com_GetDBServerDate]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
Description:	Get the database server date with timespamp or without timestamp

Returns:		0, if Success.
				
Created by:		Ashashree
Created on:		01-Apr-2015

Modification History:
Modified By		Modified On	Description
Raghvendra		07-Sep-2016	Changed the GETDATE() call with function dbo.uf_com_GetServerDate(). This function will return the date to be used as server date.

Usage:
EXEC st_com_GetDBServerDate 1 (to get date with timestamp) / EXEC st_com_GetDBServerDate 0(to get only date without timestamp)
-------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[st_com_GetDBServerDate]
	@inp_iGetDateWithTimestamp	BIT = 0,						-- If timestamp is required then set this as 1. If set as 0 then only date will be returned.
	@out_dtCurrentDate			DATETIME OUTPUT,
	@out_nReturnValue			INT = 0 OUTPUT,
	@out_nSQLErrCode			INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage			NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
	
AS
BEGIN
	DECLARE @ERR_GET_DBSERVERDATE	INT
	DECLARE @dtCurrentDate			DATETIME
	
	BEGIN TRY
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;
		SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''
		
		SELECT	@ERR_GET_DBSERVERDATE = 14020
		
		SELECT @dtCurrentDate = dbo.uf_com_GetServerDate()
		
		IF(@inp_iGetDateWithTimestamp = 0)	
		BEGIN
			SELECT @dtCurrentDate = CAST( CAST(@dtCurrentDate AS VARCHAR(11)) AS DATETIME )
		END
		
		--Return the current date as datetime
		SELECT @dtCurrentDate AS DBCurrentDate
		
		SET @out_dtCurrentDate = @dtCurrentDate
				
		RETURN @out_nReturnValue
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()
		
		-- Return common error if required, otherwise specific error.		
		SET @out_nReturnValue  = dbo.uf_com_GetErrorCode(@ERR_GET_DBSERVERDATE, ERROR_NUMBER())
		RETURN @out_nReturnValue		
	END CATCH
END