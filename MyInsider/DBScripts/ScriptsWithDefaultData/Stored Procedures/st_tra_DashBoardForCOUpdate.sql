IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_tra_DashBoardForCOUpdate')
DROP PROCEDURE [dbo].[st_tra_DashBoardForCOUpdate]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Update Dashboard Count Status details

Returns:		0, if Success.
				
Created by:		Gaurishankar
Created on:		11-Sept-2015
Modification History:
Modified By		Modified On			Description
Raghvendra		07-Sep-2016		Changed the GETDATE() call with function dbo.uf_com_GetServerDate(). This function will return the date to be used as server date.

Usage:
DECLARE @RC int
EXEC st_tra_DashBoardForCOUpdate 1,1
-------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[st_tra_DashBoardForCOUpdate] 
	@inp_nDashboardCountId			INT,
	@inp_nLoggedInUserId			INT	=	NULL,	
	@out_nReturnValue				INT = 0				OUTPUT,
	@out_nSQLErrCode				INT = 0				OUTPUT,	-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage				NVARCHAR(500) = ''	OUTPUT	-- Output SQL Error Message, if error occurred.
AS
BEGIN

	DECLARE @ERR_DASHBOARD_SAVE INT

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
		SET @ERR_DASHBOARD_SAVE = -1
		
		UPDATE tra_CoDashboardCount
		SET [Status] = 1
		,ModifiedBy = @inp_nLoggedInUserId
		,ModifiedOn = dbo.uf_com_GetServerDate()
		WHERE DashboardCountId = @inp_nDashboardCountId
		
		
		SELECT 1
		SET @out_nReturnValue = 0
		RETURN @out_nReturnValue
	END	 TRY
	
	BEGIN CATCH	
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()	
		
		-- Return common error if required, otherwise specific error.		
		SET @out_nReturnValue =  dbo.uf_com_GetErrorCode(@ERR_DASHBOARD_SAVE, ERROR_NUMBER())
		RETURN @out_nReturnValue
	END CATCH
END