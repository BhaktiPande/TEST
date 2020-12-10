IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_com_CompanyComplianceOfficerDelete')
DROP PROCEDURE [dbo].[st_com_CompanyComplianceOfficerDelete]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
Description:	Deletes the compliance officer for a company

Returns:		0, if Success.
				
Created by:		Arundhati
Created on:		25-Feb-2015

Modification History:
Modified By		Modified On	Description


Usage:
DECLARE @RC int
EXEC st_com_CompanyFaceValueDelete 1
-------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[st_com_CompanyComplianceOfficerDelete]
	-- Add the parameters for the stored procedure here
	@inp_iCompanyComplianceOfficerId INT,	-- Id of the complince officwer to be deleted
	@out_nReturnValue		INT = 0 OUTPUT,		
	@out_nSQLErrCode		INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage		NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
	
AS
BEGIN
	DECLARE	@ERR_COMPLIANCEOFFICER_DELETE INT = 13044, -- Error occurred while deleting compliance officer for a company
			@ERR_COMPLIANCEOFFICER_NOTFOUND INT = 13043, -- Compliance officer for a company does not exist.
			@ERR_DEPENDENTINFOEXISTS INT = 13045 -- Cannot delete compliance officer for a company, as some dependent information exists for this compliance officer

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
	
		--Check if the CompanyFaceValue being deleted exists
		IF (NOT EXISTS(SELECT CompanyComplianceOfficerId FROM com_CompanyComplianceOfficer WHERE CompanyComplianceOfficerId = @inp_iCompanyComplianceOfficerId))
		BEGIN
			SET @out_nReturnValue = @ERR_COMPLIANCEOFFICER_NOTFOUND
			RETURN (@out_nReturnValue)
		END
		
		DELETE FROM com_CompanyComplianceOfficer
		WHERE CompanyComplianceOfficerId = @inp_iCompanyComplianceOfficerId


		SET @out_nReturnValue = 0
		RETURN @out_nReturnValue
		
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()
		
		-- Return common error if required, otherwise specific error.		
		IF ERROR_NUMBER() = 547 -- Dependent info exists
			SET @out_nReturnValue = @ERR_DEPENDENTINFOEXISTS
		ELSE
			SET @out_nReturnValue = dbo.uf_com_GetErrorCode(@ERR_COMPLIANCEOFFICER_DELETE, ERROR_NUMBER())
		
		RETURN @out_nReturnValue
	END CATCH
END

