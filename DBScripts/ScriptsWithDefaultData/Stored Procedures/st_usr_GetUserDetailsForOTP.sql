
/*---------------------------------------------------------
Created by:		Hemant Kawade
Created on:		26-OCT-2020
Description:	Get user details for OTP authentication	
------------------------------------------------------------*/

IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_usr_GetUserDetailsForOTP')
DROP PROCEDURE [dbo].[st_usr_GetUserDetailsForOTP]
GO

CREATE PROCEDURE [dbo].[st_usr_GetUserDetailsForOTP] 
	@inp_LoggedUserId		VARCHAR(100),	
	@out_nReturnValue		INT = 0 OUTPUT,		
	@out_nSQLErrCode		INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage		NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
AS
BEGIN
	BEGIN TRY
	SET NOCOUNT ON;

		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''

		
		IF(@inp_LoggedUserId IS NOT NULL OR @inp_LoggedUserId <> '')
		BEGIN
		
			SELECT  ISNULL(UF.UserInfoId,0) AS UserInfoId, ISNULL(UF.EmailId, '') AS EmailId, 
					CASE WHEN UF.UserTypeCodeId = 101004 THEN A.LoginID
					ELSE ISNULL(UF.FirstName, '') +' ' + ISNULL(UF.LastName, '') END AS FullName
			FROM usr_Authentication A JOIN usr_UserInfo UF ON A.UserInfoID = UF.UserInfoId , mst_Company c
			WHERE LoginID = @inp_LoggedUserId and c.IsImplementing = 1
			
		END
		ELSE
		BEGIN
			SELECT 0
		END
		
	SET NOCOUNT OFF;
	SET @out_nReturnValue = 0
	RETURN @out_nReturnValue

	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue	=  'Error while returning user Login details'
	END CATCH
END
GO
