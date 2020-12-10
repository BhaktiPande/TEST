IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_mst_CompanyDetails')
DROP PROCEDURE [dbo].[st_mst_CompanyDetails]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Get the Company details

Returns:		0, if Success.
				
Created by:		Tushar Tekawade
Created on:		17-Feb-2015

Modification History:
Modified By		Modified On		Description
Tushar			26-May-2015		Add New Column ISINNumber
Tushar			03-Mar-2016		Add New Column ContraTradeOption
								use column for Selection of QTY Yes/No configuration. 
								ESOPs and other than ESOPs should fields are displayed on: Initial Disclosure form, Transaction Details page and 
								Pre-clearance form. We need to hide these fields. (Based on contra trade functionality)
Tushar			03-Mar-2016		Return New Column AutoSubmitTransaction
AniketS			24-Oct-2017		Return SFTP details from Company master.(Vigilante_Master)

Usage:
EXEC st_mst_CompanyDetails 1
-------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[st_mst_CompanyDetails]
	@inp_iCompanyId			INT,						-- Id of the Company whose details are to be fetched.
	@inp_iGetImplementing	INT,						-- If 1: Ignores the value of @inp_iCompanyId, and fteches details of implementing company.
														-- If 0: Get detaiils of CompanyId = @inp_iCompanyId
	@out_nReturnValue		INT = 0 OUTPUT,
	@out_nSQLErrCode		INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage		NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
	
AS
BEGIN
	DECLARE @ERR_COMPANY_GETDETAILS INT = 13082 -- Error occurred while fetching details for a company.
	DECLARE @ERR_COMPANY_NOTFOUND INT = 13009 -- Company does not exist.
	
	DECLARE @CompanyID INT

	BEGIN TRY
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;

		--Initialize variables

		--Check if the Company whose details are being fetched exists
		IF (NOT EXISTS(SELECT CompanyId FROM mst_Company 
						WHERE ((@inp_iGetImplementing <> 1 AND CompanyId = @inp_iCompanyId)
						OR (@inp_iGetImplementing = 1 AND IsImplementing = 1))))
		BEGIN
				SET @out_nReturnValue = @ERR_COMPANY_NOTFOUND
				RETURN (@out_nReturnValue)
		END

		--Fetch the Company details
		SET @CompanyID = (SELECT CompanyId FROM Vigilante_Master..Companies WHERE ConnectionDatabaseName = DB_NAME())
		SELECT MC.CompanyId, MC.CompanyName, MC.Address, MC.Website,MC.EmailId,MC.IsImplementing,MC.ISINNumber,MC.ContraTradeOption,MC.AutoSubmitTransaction,
		CM.SmtpServer, CM.SmtpPortNumber, CM.SmtpUserName, CM.SmtpPassword,MC.IsMCQRequired, MC.IsPreClearanceEditable
		FROM mst_Company MC
		INNER JOIN Vigilante_Master..Companies  CM ON CM.CompanyId = @CompanyID				
		
		WHERE ((@inp_iGetImplementing <> 1 AND MC.CompanyId = @inp_iCompanyId)
						OR (@inp_iGetImplementing = 1 AND MC.IsImplementing = 1))												

		SET @out_nReturnValue = 0
		RETURN @out_nReturnValue
		
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()
		
		-- Return common error if required, otherwise specific error.		
		SET @out_nReturnValue  = dbo.uf_com_GetErrorCode(@ERR_COMPANY_GETDETAILS, ERROR_NUMBER())
		RETURN @out_nReturnValue		
	END CATCH
END

