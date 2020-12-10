IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_mst_CompanySave')
DROP PROCEDURE [dbo].[st_mst_CompanySave]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
Description:	Saves the Company details

Returns:		0, if Success.
				
Created by:		Tushar Tekawade
Created on:		17-Feb-2015
Modification History:
Modified By		Modified On		Description
Tushar			26-May-2015		Add New Column ISINNumber
Tushar			06-Jul-2015		Company Name & Email ID Unique check add
Raghvendra		07-Sep-2016		Changed the GETDATE() call with function dbo.uf_com_GetServerDate(). This function will return the date to be used as server date.
AniketS			24-Oct-2017		Update SFTP details in Company master.(Vigilante_Master)

Usage:
DECLARE @RC int
EXEC st_mst_CompanySave ,1
-------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[st_mst_CompanySave] 
	@inp_iCompanyId				INT,						--Company Id
	@inp_sCompanyName			NVARCHAR(400),				--Company Name
	@inp_sAddress				NVARCHAR(2048),				--Company Address
	@inp_sWebsite				NVARCHAR(1024),				--Company Website	
	@inp_sEmailId				NVARCHAR(250),				--Company Email Id
	@inp_sISINNumber			NVARCHAR(50),
	@inp_iLoggedInUserId		INT	=	NULL,
	@SmtpServer					VARCHAR(50) = NULL,
	@SmtpPortNumber				VARCHAR(50) = NULL,
	@SmtpUserName				VARCHAR(50) = NULL,
	@SmtpPassword				VARCHAR(50) = NULL,		
	@out_nReturnValue			INT = 0 OUTPUT,
	@out_nSQLErrCode			INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage			NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
AS
BEGIN

	DECLARE @ERR_COMPANY_SAVE INT
	DECLARE @ERR_COMPANY_NOTFOUND INT
	DECLARE @ERR_COMPANYNAMEXISTS INT
	DECLARE @ERR_EMAILIDEXISTS	INT
	
	DECLARE @CompanyID INT

	BEGIN TRY
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;

		--Initialize variables
		SELECT	@ERR_COMPANY_NOTFOUND = 13009,
				@ERR_COMPANY_SAVE = 13008,@ERR_COMPANYNAMEXISTS = 13120,@ERR_EMAILIDEXISTS=13121
		
		
		IF ((@inp_iCompanyId = 0 AND EXISTS(SELECT CompanyId FROM mst_Company WHERE CompanyName = @inp_sCompanyName))
			OR @inp_iCompanyId > 0 AND EXISTS(SELECT CompanyId FROM mst_Company WHERE CompanyName = @inp_sCompanyName AND CompanyId <> @inp_iCompanyId))
		BEGIN
			SET @out_nReturnValue = @ERR_COMPANYNAMEXISTS
			RETURN @out_nReturnValue
		END		
		
		
		IF ((@inp_iCompanyId = 0 AND EXISTS(SELECT CompanyId FROM mst_Company WHERE EmailId = @inp_sEmailId))
			OR @inp_iCompanyId > 0 AND EXISTS(SELECT CompanyId FROM mst_Company WHERE EmailId = @inp_sEmailId AND CompanyId <> @inp_iCompanyId))
		BEGIN
			SET @out_nReturnValue = @ERR_EMAILIDEXISTS
			RETURN @out_nReturnValue
		END	
		
		--Save the Company details
		IF @inp_iCompanyId = 0
		BEGIN
			INSERT INTO mst_Company(CompanyName,Address,Website,EmailId,IsImplementing,ISINNumber,CreatedBy,CreatedOn,
					ModifiedBy,ModifiedOn )
			VALUES (@inp_sCompanyName,@inp_sAddress,@inp_sWebsite,@inp_sEmailId,0,@inp_sISINNumber,@inp_iLoggedInUserId,dbo.uf_com_GetServerDate(),
					@inp_iLoggedInUserId, dbo.uf_com_GetServerDate() )
					
			SET @inp_iCompanyId = SCOPE_IDENTITY()
		END
		ELSE
		BEGIN
			--Check if the Company whose details are being updated exists
			IF (NOT EXISTS(SELECT CompanyId FROM mst_Company WHERE CompanyId = @inp_iCompanyId))
			BEGIN			
				SET @out_nReturnValue = @ERR_COMPANY_NOTFOUND
				RETURN (@out_nReturnValue)
			END
			
			UPDATE mst_Company
			SET    CompanyName = @inp_sCompanyName,
					Address = @inp_sAddress,
					Website = @inp_sWebsite,
					EmailId = @inp_sEmailId,
					ISINNumber = @inp_sISINNumber,
					ModifiedBy	= @inp_iLoggedInUserId,
					ModifiedOn = dbo.uf_com_GetServerDate()
			WHERE CompanyId = @inp_iCompanyId
			
			SET @CompanyID = (SELECT CompanyId FROM Vigilante_Master..Companies WHERE ConnectionDatabaseName = DB_NAME())
			UPDATE Vigilante_Master..Companies SET SmtpServer = @SmtpServer, SmtpPortNumber = @SmtpPortNumber, SmtpUserName = @SmtpUserName, SmtpPassword = @SmtpPassword			
			WHERE CompanyId = @CompanyID			
		END
		
		-- in case required to return for partial save case.
		SELECT CompanyId, CompanyName, Address, Website,EmailId 
		FROM mst_Company
		WHERE CompanyId = @inp_iCompanyId
	
		SET @out_nReturnValue = 0
		RETURN @out_nReturnValue
		
	END	 TRY
	
	BEGIN CATCH	
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()	
		
		-- Return common error if required, otherwise specific error.		
		SET @out_nReturnValue =  dbo.uf_com_GetErrorCode(@ERR_COMPANY_SAVE, ERROR_NUMBER())
		RETURN @out_nReturnValue
	END CATCH
END