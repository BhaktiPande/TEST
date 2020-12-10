IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_mst_CompanyDelete')
DROP PROCEDURE [dbo].[st_mst_CompanyDelete]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Deletes the Company

Returns:		0, if Success.
				
Created by:		Tushar Tekawade
Created on:		17-Feb-2015

Modification History:
Modified By		Modified On	Description


Usage:
DECLARE @RC int
EXEC st_mst_CompanyDelete 1
-------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[st_mst_CompanyDelete]
	-- Add the parameters for the stored procedure here
	@inp_iCompanyId					INT,							-- Id of the Company to be deleted
	@inp_iLoggedInUserId			INT ,						-- Id Used while updating audit table befoe deleting.	
	@out_nReturnValue				INT = 0 OUTPUT,		
	@out_nSQLErrCode				INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage				NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
	
AS
BEGIN
	DECLARE	@ERR_COMPANY_DELETE INT = 13010,
			@ERR_COMPANY_NOTFOUND INT = 13009,
			@ERR_DEPENDENTINFOEXISTS INT = 13007 -- Cannot delete this company, as some dependent information exists for this company.

	BEGIN TRY

		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;

		--Initialize variables
	
		--Check if the Company being deleted exists
		IF (NOT EXISTS(SELECT CompanyId FROM mst_Company WHERE CompanyId = @inp_iCompanyId))
		BEGIN
			SET @out_nReturnValue = @ERR_COMPANY_NOTFOUND
			RETURN (@out_nReturnValue)
		END
		
		DELETE FROM mst_Company
		WHERE CompanyId = @inp_iCompanyId AND IsImplementing = 0

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
			SET @out_nReturnValue = dbo.uf_com_GetErrorCode(@ERR_COMPANY_DELETE, ERROR_NUMBER())
		
		RETURN @out_nReturnValue
		
	END CATCH
END
