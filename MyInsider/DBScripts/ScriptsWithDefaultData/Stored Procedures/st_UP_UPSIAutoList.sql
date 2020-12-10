IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_UP_UPSIAutoList')
	DROP PROCEDURE st_UP_UPSIAutoList
GO
-- ======================================================================================
-- Author      : Arvind Deshmukh															=
-- CREATED DATE: 25-April-2019                                                 			=
-- Description : THIS PROCEDURE FETCH THE Upsi COMPANY Name And Address LIST DETAILS				=
--																						=		
--				 EXEC st_UP_UPSIAutoList 'A','A'								=
-- ======================================================================================



CREATE PROCEDURE [dbo].[st_UP_UPSIAutoList]
(
	@inp_sAction				VARCHAR(50),
	@inp_sCompanyName			VARCHAR(300) = '' ,
	@inp_sCompanyAddress		VARCHAR(300) = '' ,
	@out_nReturnValue			INT = 0 OUTPUT,
	@out_nSQLErrCode			INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage			VARCHAR(500) = '' OUTPUT    -- Output SQL Error Message, if error occurred.	
)
AS
BEGIN
	
	DECLARE @ERR_NOTIFICATIONQUEUE_GETDETAILS INT

	IF @out_nReturnValue IS NULL
		SET @out_nReturnValue = 0

	IF @out_nSQLErrCode IS NULL
		SET @out_nSQLErrCode = 0

	IF @out_sSQLErrMessage IS NULL
		SET @out_sSQLErrMessage = ''
		
	
	IF(@inp_sAction = 'AUTOCOMPLETE')
	BEGIN
		print (@inp_sAction)
		IF(LEN(@inp_sCompanyName) = 0)
			SET @inp_sCompanyName = NULL
		ELSE 
			SET @inp_sCompanyName = @inp_sCompanyName + '%'
			
		IF(LEN(@inp_sCompanyAddress) = 0)
			SET @inp_sCompanyAddress = NULL
		ELSE 
			SET @inp_sCompanyAddress = @inp_sCompanyAddress + '%'
			
	
		BEGIN TRY	
		
			SELECT DISTINCT UPSI.CompanyName,UPSI.CompanyAddress
			FROM usr_UPSIDocumentDetail UPSI
			
			WHERE (UPSI.CompanyName LIKE @inp_sCompanyName OR UPSI.CompanyAddress LIKE @inp_sCompanyAddress)
			
			
			print (@out_nReturnValue)
		END TRY
		BEGIN CATCH
			SET @out_nSQLErrCode    =  ERROR_NUMBER()
			SET @out_sSQLErrMessage =   ERROR_MESSAGE()
			SET @out_nReturnValue  = dbo.uf_com_GetErrorCode(@ERR_NOTIFICATIONQUEUE_GETDETAILS, ERROR_NUMBER())
			
			RETURN @out_nReturnValue		
		END CATCH
	END
	
	
END
