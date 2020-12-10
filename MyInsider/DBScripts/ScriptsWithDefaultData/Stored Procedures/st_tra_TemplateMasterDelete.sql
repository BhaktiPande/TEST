IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_tra_TemplateMasterDelete')
DROP PROCEDURE [dbo].[st_tra_TemplateMasterDelete]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Deletes the TemplateMaster

Returns:		0, if Success.
				
Created by:		Gaurishankar
Created on:		09-May-2015

Modification History:
Modified By		Modified On		Description
Raghvendra		13-Oct-2016		Adding the check for Form E template usage in table tra_GeneratedFormDetails


Usage:
DECLARE @RC int
EXEC st_tra_TemplateMasterDelete 1
-------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[st_tra_TemplateMasterDelete]
	-- Add the parameters for the stored procedure here
	@inp_iTemplateMasterId	INT,						-- Id of the TemplateMaster to be deleted
	@inp_nUserId			INT ,						-- Id Used while updating audit table befoe deleting.	
	@out_nReturnValue		INT = 0 OUTPUT,		
	@out_nSQLErrCode		INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage		NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
	
AS
BEGIN
	DECLARE	@ERR_TEMPLATEMASTER_DELETE INT,
			@ERR_TEMPLATEMASTER_NOTFOUND INT,
			@ERR_TEMPLATEMASTER_DEPENDANCYFOUND INT

	BEGIN TRY

		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;

		--Initialize variables
		SELECT	@ERR_TEMPLATEMASTER_NOTFOUND = 16075, -- Template does not exist.
				@ERR_TEMPLATEMASTER_DELETE = 16076, -- Error occurred while deleting template.
				@ERR_TEMPLATEMASTER_DEPENDANCYFOUND = 16078 -- Cannot delete template because it is used in communication rule.
	
		--Check if the TemplateMaster being deleted exists
		IF (NOT EXISTS(SELECT TemplateMasterId FROM tra_TemplateMaster WHERE TemplateMasterId = @inp_iTemplateMasterId))
		BEGIN	
			SET @out_nReturnValue = @ERR_TEMPLATEMASTER_NOTFOUND
			RETURN (@out_nReturnValue)
		END

		IF (EXISTS(SELECT TemplateId FROM cmu_CommunicationRuleModeMaster WHERE TemplateId = @inp_iTemplateMasterId))
		BEGIN	
			SET @out_nReturnValue = @ERR_TEMPLATEMASTER_DEPENDANCYFOUND
			RETURN (@out_nReturnValue)
		END
		--Check for form E template usage
		IF (EXISTS(SELECT TemplateMasterId FROM tra_GeneratedFormDetails WHERE TemplateMasterId = @inp_iTemplateMasterId))
		BEGIN	
			SET @out_nReturnValue = @ERR_TEMPLATEMASTER_DEPENDANCYFOUND
			RETURN (@out_nReturnValue)
		END
		
		DELETE FROM tra_TemplateMaster
		WHERE TemplateMasterId = @inp_iTemplateMasterId


		SET @out_nReturnValue = 0
		RETURN @out_nReturnValue
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()
		
		-- Return common error if required, otherwise specific error.		
		SET @out_nReturnValue = dbo.uf_com_GetErrorCode(@ERR_TEMPLATEMASTER_DELETE, ERROR_NUMBER())
		RETURN @out_nReturnValue
	END CATCH
END
