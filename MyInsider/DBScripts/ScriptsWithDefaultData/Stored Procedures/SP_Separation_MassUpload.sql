IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'SP_Separation_MassUpload')
	DROP PROCEDURE SP_Separation_MassUpload
GO

-- ======================================================================================================
-- Author      : Gaurav Ugale																			=
-- CREATED DATE: 05-APR-2016                                                 							=
-- Description : THIS TABLE TYPE IS USED FOR USER SEPARATION Mass-Upload								=
-- ======================================================================================================


CREATE PROCEDURE SP_Separation_MassUpload
(
	@LoginId				NVARCHAR(200),
	@EmployeeId				NVARCHAR(200),
	@PAN					NVARCHAR(200),
	@DateOfSeparation		DATETIME,
	@ReasonForSeparation	NVARCHAR(200),
	@NoOfDaysToBeActive		INT,
	@out_nReturnValue		INT = 0 OUTPUT,
	@out_nSQLErrCode		INT = 0 OUTPUT,			  -- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage		VARCHAR(500) = '' OUTPUT  -- Output SQL Error Message, if error occurred.
)
AS 
BEGIN
	BEGIN TRY
		
		DECLARE @USERINFO_ID INT 
		IF EXISTS (SELECT LoginID FROM usr_Authentication WHERE LoginID = @LoginId)
		BEGIN
			SELECT @USERINFO_ID = (SELECT UserInfoID FROM usr_Authentication WHERE LoginID = @LoginId)
			
			UPDATE usr_UserInfo
			SET DateOfSeparation = @DateOfSeparation,
				ReasonForSeparation = @ReasonForSeparation,
				NoOfDaysToBeActive = @NoOfDaysToBeActive,
				DateOfInactivation = DATEADD(DAY,@NoOfDaysToBeActive,@DateOfSeparation)
			WHERE usr_UserInfo.UserInfoId = @USERINFO_ID
		
			--SELECT 1 
			SET @out_nReturnValue = 0
			RETURN @out_nReturnValue		
		END	
		ELSE 
		BEGIN
			--SELECT 1
			SET @out_nReturnValue = 50056
			SET @out_nSQLErrCode    =  1
			SET @out_sSQLErrMessage =  'Invalid value provided for LoginId'
			RETURN (@out_nReturnValue)
		END		
	END TRY
	BEGIN CATCH
		SET @out_nReturnValue = ERROR_NUMBER()		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue = @out_nSQLErrCode
		RETURN @out_nReturnValue
	END CATCH
END