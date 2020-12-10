IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_usr_AuthenticationDetails')
DROP PROCEDURE [dbo].[st_usr_AuthenticationDetails]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Get the UserInfo details

Returns:		0, if Success.
				
Created by:		Arundhati
Created on:		11-Feb-2015

Modification History:
Modified By		Modified On		Description
Arundhati		12-Feb-2015		password is also included in the output
Arundhati		04-May-2015		Added UserTypeCodeId in output
Swapnil			30-May-2015		Added property to get company logo URL
Raghvendra		03-July-2015	Added property LastLogin time for user in the select.
Raghvendra		07-Sep-2016		Changed the GETDATE() call with function dbo.uf_com_GetServerDate(). This function will return the date to be used as server date.
Usage:
EXEC st_usr_AuthenticationDetails 'Login1'
-------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[st_usr_AuthenticationDetails]
	@inp_sLoginId			VARCHAR(100),						-- Id of the UserInfo whose details are to be fetched.
	@out_nReturnValue		INT = 0 OUTPUT,
	@out_nSQLErrCode		INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage		NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
	
AS
BEGIN
	DECLARE @ERR_AUTHENTICATION_GETDETAILS INT
	DECLARE @ERR_USERINFO_NOTFOUND INT

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
		SELECT	@ERR_USERINFO_NOTFOUND = 11025, -- User does not exist.
				@ERR_AUTHENTICATION_GETDETAILS = 11035

		--Check if the UserInfo whose details are being fetched exists
		IF (NOT EXISTS(SELECT UserInfoID FROM usr_Authentication WHERE LoginID = @inp_sLoginId))
		BEGIN
				SET @out_nReturnValue = @ERR_USERINFO_NOTFOUND
				RETURN (@out_nReturnValue)
		END

		SELECT A.UserInfoID, LoginID, Password, UserTypeCodeId,c.CompanyLogoURL as CompanyLogoURL, ISNULL(A.LastLoginTime, dbo.uf_com_GetServerDate()) AS LastLoginTime,
		UF.DateOfBecomingInsider AS DateOfBecomingInsider, ISNULL(UF.FirstName, '') AS FirstName, ISNULL(UF.LastName, '') AS LastName
		FROM usr_Authentication A JOIN usr_UserInfo UF ON A.UserInfoID = UF.UserInfoId , mst_Company c
		WHERE LoginID = @inp_sLoginId and c.IsImplementing = 1


		SET @out_nReturnValue = 0
		RETURN @out_nReturnValue
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()
		
		-- Return common error if required, otherwise specific error.		
		SET @out_nReturnValue  = dbo.uf_com_GetErrorCode(@ERR_AUTHENTICATION_GETDETAILS, ERROR_NUMBER())
		RETURN @out_nReturnValue		
	END CATCH
END

