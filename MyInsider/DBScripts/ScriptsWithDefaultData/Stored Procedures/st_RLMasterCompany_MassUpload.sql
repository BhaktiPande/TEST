IF EXISTS (SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_RLMasterCompany_MassUpload')
	DROP PROCEDURE st_RLMasterCompany_MassUpload
GO
-- ======================================================================================================
-- Author      : GAURAV UGALE																			=
-- CREATED DATE: 02-AUG-2016                                                 							=
-- Description : THIS PROCEDURE USED FOR RESTRICTED LIST MASTER COMPANY MASS-UPLOAD						=
-- ======================================================================================================
/*
Modified By	Modified OIn	Description
Raghvendra	07-Sep-2016	Changed the GETDATE() call with function dbo.uf_com_GetServerDate(). This function will return the date to be used as server date.
*/
CREATE PROCEDURE st_RLMasterCompany_MassUpload
(
	@inp_CompanyName			VARCHAR(200),
	@inp_BSECode				VARCHAR(50)	= NULL,	
	@inp_NSECode				VARCHAR(50)	= NULL,
	@inp_ISIN					VARCHAR(50),		
	@out_nReturnValue			INT = 0 OUTPUT,
	@out_nSQLErrCode			INT = 0 OUTPUT,			  -- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage			VARCHAR(500) = '' OUTPUT  -- Output SQL Error Message, if error occurred.
)
AS
BEGIN
	DECLARE @ModuleCodeID INT = 103301
	DECLARE @StatusCodeId INT = 105001
	
	BEGIN TRY
	
		SET NOCOUNT ON;
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''	
			print @inp_ISIN
		
		IF NOT EXISTS(SELECT RlCompanyId FROM rl_CompanyMasterList WHERE CompanyName = @inp_CompanyName AND BSECode = @inp_BSECode AND NSECode = @inp_NSECode AND ISINCode = @inp_ISIN)	
		BEGIN
			IF NOT EXISTS(SELECT RlCompanyId FROM rl_CompanyMasterList WHERE ISINCode = @inp_ISIN)	
			BEGIN
				INSERT INTO rl_CompanyMasterList (CompanyName, BSECode, NSECode, ISINCode, ModuleCodeId, StatusCodeId, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
				VALUES (@inp_CompanyName, @inp_BSECode, @inp_NSECode, @inp_ISIN, @ModuleCodeID, @StatusCodeId, 1, dbo.uf_com_GetServerDate(), 1, dbo.uf_com_GetServerDate())
			
				SELECT 1 
				SET @out_nReturnValue = 0
				RETURN @out_nReturnValue
			END
			ELSE
			BEGIN
				UPDATE rl_CompanyMasterList SET
				CompanyName = @inp_CompanyName,
				NSECode = @inp_NSECode,
				BSECode = @inp_BSECode
				WHERE ISINCode = @inp_ISIN	
			
				SELECT 1 
				SET @out_nReturnValue = 0
				RETURN @out_nReturnValue		
			END	
		END	
		ELSE
		BEGIN 
				SET @out_nReturnValue = 13120
		END
					
	END TRY
	BEGIN CATCH
		SELECT 1
		SET @out_nReturnValue = ERROR_NUMBER()
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		RETURN @out_sSQLErrMessage
	END CATCH

END