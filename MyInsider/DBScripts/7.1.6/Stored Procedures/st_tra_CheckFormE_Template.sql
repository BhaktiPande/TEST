-- ======================================================================================================
-- Author      : Tushar Wakchaure												
-- CREATED DATE: 13-Sept-2017                                                 							
-- Description : Script for check Form E template availability												
-- ======================================================================================================
IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_tra_CheckFormE_Template')
DROP PROCEDURE [dbo].[st_tra_CheckFormE_Template]
GO

CREATE PROCEDURE [dbo].[st_tra_CheckFormE_Template] 

	@out_nReturnValue				INT = 0 OUTPUT,
	@out_nSQLErrCode				INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage			    VARCHAR(500) = '' OUTPUT  -- Output SQL Error Message, if error occurred. 
		
AS
BEGIN

	DECLARE @ERR_FORME_TEMPLATE_AVAILABLE INT
	DECLARE @ERR_FORME_TEMPLATE_NOTFOUND INT

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
		SELECT	@ERR_FORME_TEMPLATE_NOTFOUND = 50588, -- Form E Template is not available. Please contact Administrator.
				@ERR_FORME_TEMPLATE_AVAILABLE = 50589 -- Error occurred while fetching FORM E Template.
			
			SELECT TemplateMasterId FROM tra_TemplateMaster WHERE TemplateName LIKE 'Form E%' AND IsActive = 1 
			
		SET @out_nReturnValue = 0
		RETURN @out_nReturnValue
	END	 TRY

	BEGIN CATCH	
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()	
		
		-- Return common error if required, otherwise specific error.		
		SET @out_nReturnValue =  dbo.uf_com_GetErrorCode(@ERR_FORME_TEMPLATE_AVAILABLE, ERROR_NUMBER())
		RETURN @out_nReturnValue
END CATCH
END
GO
