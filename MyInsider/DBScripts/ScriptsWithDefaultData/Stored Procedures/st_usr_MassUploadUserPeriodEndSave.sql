IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_usr_MassUploadUserPeriodEndSave')
DROP PROCEDURE [dbo].[st_usr_MassUploadUserPeriodEndSave]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Procedure to save if user has performed the Period End disclosure or not before the 
				system go live has been done. 
				This procedure will check if the Initial disclosure is performed by the user then 
				changing of the option for Period End performed will not be allowed.
				Also this procedure will perform the validations like if the LoginUerId provided is 
				for valid user availalble in the database.


Returns:		0, if Success.
				
Created by:		Raghvendra
Created on:		11-Sep-2016

Modification History:
Modified By		Modified On		Description


Usage:
DECLARE @out_nReturnValue				INT = 0 
	,@out_nSQLErrCode				INT = 0 
	,@out_sSQLErrMessage			VARCHAR(500) = '' 
EXEC st_usr_MassUploadUserPeriosEndSave 2,'LoginId',186001,@out_nReturnValue OUT, @out_nSQLErrCode OUT, @out_sSQLErrMessage OUT
-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_usr_MassUploadUserPeriodEndSave]
	@inp_iUserInfoId				INT
    ,@inp_sLoginID					VARCHAR(100) = null
	,@inp_iPeriodEndPerformed		INT	
	,@inp_sEmployeeName				VARCHAR(100) = null
	,@out_nReturnValue				INT = 0 OUTPUT
	,@out_nSQLErrCode				INT = 0 OUTPUT
	,@out_sSQLErrMessage			VARCHAR(500) = '' OUTPUT  -- Output SQL Error Message, if error occurred.	
AS
BEGIN
	DECLARE @sSQL NVARCHAR(MAX)
	DECLARE @ERR_SAVE_RECORD INT = 11029	--Add new resource
	DECLARE @ERR_USER_DOESNOT_EXIST INT = 11025
	DECLARE @ERR_PRECLEARANCE_CREATED INT = 11441	--Add new resource
	DECLARE @nTmpRetVal INT = 0
	DECLARE @nUserInfoId INT = 0

	BEGIN TRY
		
		SET NOCOUNT ON;
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''
		
		/*Check if user existis for the provided Login ID*/
		IF NOT EXISTS(SELECT * FROM usr_Authentication WHERE LoginID = @inp_sLoginID)
		BEGIN
			SELECT @out_nReturnValue = @ERR_USER_DOESNOT_EXIST
			RETURN @out_nReturnValue
		END		
		
		SELECT @nUserInfoId = UserInfoId FROM usr_Authentication WHERE LoginID = @inp_sLoginID

		/*Check if the there are no pre clearances created by the user for changing the Period End flag against the emaployee*/

		IF EXISTS(SELECT * FROM tra_PreclearanceRequest WHERE UserInfoId = @nUserInfoId)
		BEGIN
			SELECT @out_nReturnValue = @ERR_PRECLEARANCE_CREATED 
			RETURN @out_nReturnValue
		END


		/*
		If the user is valid and User has not created any Preclearance yet then update the value for PeriodEndPerformed
		for the corresponding user
		*/
		UPDATE usr_UserInfo SET PeriodEndDisclosureUploaded = @inp_iPeriodEndPerformed WHERE UserInfoId = @nUserInfoId

		SELECT @nUserInfoId

		RETURN 0
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()
		SET @out_nReturnValue = @ERR_SAVE_RECORD
		RETURN @out_nReturnValue
	END CATCH
END
