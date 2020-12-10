IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_LoginSSODetails')
	DROP PROCEDURE [dbo].[st_LoginSSODetails]
GO

-- ======================================================================================================
-- Author      : Gaurav Ugale																			=
-- CREATED DATE: 27-JUN-2016                                                 							=
-- Description : THIS PROCEDURE IS USED TO PROVIDE DETAILS FOR SSO LOGIN								=
-- EXEC st_LoginSSODetails	0																			=
-- ======================================================================================================


CREATE PROCEDURE st_LoginSSODetails
(
	@inp_EmployeeId				NVARCHAR(100) = NULL,
	@inp_EmailId				NVARCHAR(500) = NULL,
	@out_nReturnValue			INT = 0 OUTPUT,
	@out_nSQLErrCode			INT = 0 OUTPUT,			  -- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage			VARCHAR(500) = '' OUTPUT  -- Output SQL Error Message, if error occurred.	
)
AS 
BEGIN
	BEGIN TRY
		DECLARE @LoginID NVARCHAR(500)
		DECLARE @Password NVARCHAR(MAX)
		DECLARE @ERR_INCORRECTDATA INT = 11272
			
		IF (@inp_EmployeeId IS NOT NULL AND @inp_EmployeeId <> '')
		BEGIN
			SELECT @LoginID = UA.LoginID, @Password = UA.[Password] FROM usr_UserInfo UF
			INNER JOIN usr_Authentication UA ON UF.UserInfoId = UA.UserInfoID
			WHERE UF.EmployeeId = @inp_EmployeeId
			
			IF(@LoginID IS NOT NULL)
			BEGIN 
				SELECT LoginID,[Password] FROM usr_Authentication WHERE LoginID = @LoginID
				SELECT 1 
				SET @out_nReturnValue = 0
				RETURN @out_nReturnValue		
			END
			ELSE
			BEGIN
				SET @out_nReturnValue = @ERR_INCORRECTDATA
				RETURN @out_nReturnValue 
			END
			
		END
		ELSE
		BEGIN
			SELECT @LoginID = UA.LoginID, @Password = UA.[Password] FROM usr_UserInfo UF
			INNER JOIN usr_Authentication UA ON UF.UserInfoId = UA.UserInfoID
			WHERE UF.EmailId = @inp_EmailId
			
			IF(@LoginID IS NOT NULL)
			BEGIN 
				SELECT LoginID,[Password] FROM usr_Authentication WHERE LoginID = @LoginID
				SELECT 1 
				SET @out_nReturnValue = 0
				RETURN @out_nReturnValue		
			END
			ELSE
			BEGIN
				SELECT NULL LoginID,NULL [Password] 
				SELECT 1 

				SET @out_nReturnValue = 0
				RETURN @out_nReturnValue 
			END		
		END
	END TRY
		
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
	END CATCH
	
END





