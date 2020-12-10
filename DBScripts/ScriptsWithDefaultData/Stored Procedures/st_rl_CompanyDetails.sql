IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_rl_CompanyDetails')
	DROP PROCEDURE st_rl_CompanyDetails
GO
-- ======================================================================================
-- Author      : Gaurav Ugale															=
-- CREATED DATE: 10-SEP-2015                                                 			=
-- Description : THIS PROCEDURE FETCH THE COMPANY LIST DETAILS							=
--																						=		
--				 EXEC st_rl_CompanyDetails												=
-- ======================================================================================


CREATE PROCEDURE [dbo].[st_rl_CompanyDetails]
(
	@out_nReturnValue		INT = 0 OUTPUT,
	@out_nSQLErrCode		INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage		VARCHAR(500) = '' OUTPUT    -- Output SQL Error Message, if error occurred.	
)
AS
BEGIN
	DECLARE @ERR_NOTIFICATIONQUEUE_GETDETAILS INT
	BEGIN TRY
		SELECT RlCompanyId, 
				CompanyName, BSECode, (CASE NSECode WHEN '' THEN 'Not Available' ELSE NSECode END) AS NSECode,ISINCode
		FROM rl_CompanyMasterList 
		Where StatusCodeId = 105001
	END TRY
	BEGIN CATCH
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()
		
		-- Return common error if required, otherwise specific error.		
		SET @out_nReturnValue  = dbo.uf_com_GetErrorCode(@ERR_NOTIFICATIONQUEUE_GETDETAILS, ERROR_NUMBER())
		RETURN @out_nReturnValue		
	END CATCH
	
END