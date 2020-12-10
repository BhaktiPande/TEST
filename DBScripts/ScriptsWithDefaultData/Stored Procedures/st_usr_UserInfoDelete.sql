IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_usr_UserInfoDelete')
DROP PROCEDURE [dbo].[st_usr_UserInfoDelete]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
Description:	Deletes the UserInfo (Makes the user inactive)

Returns:		0, if Success.
				
Created by:		Swapnil
Created on:		09-Feb-2015

Modification History:
Modified By		Modified On	Description
Arundhati		12-Feb-2015	Delete the user if dependent info does not exist
Arundhati		23-Feb-2015	Delete data from userRelation table, if user is of type relative
Arundhati		15-Apr-2015	Delete UserRole association before deleting User.
Raghvendra		07-Sep-2016	Changed the GETDATE() call with function dbo.uf_com_GetServerDate(). This function will return the date to be used as server date.
Usage:
DECLARE @RC int
EXEC st_usr_UserInfoDelete 1
-------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[st_usr_UserInfoDelete]
	-- Add the parameters for the stored procedure here
	@inp_iUserInfoId		INT,						-- Id of the UserInfo to be deleted
	@inp_nUserId			INt ,						-- Id Used while updating audit table befoe deleting.	
	@out_nReturnValue		INT = 0 OUTPUT,		
	@out_nSQLErrCode		INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage		NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
	
AS
BEGIN
	DECLARE	@ERR_USERINFO_DELETE INT,
			@ERR_USERINFO_NOTFOUND INT,
			@ERR_DEPENDENTINFOEXISTS INT = 11045 -- Cannot delete this user, as some dependent information is dependent on this user.

	DECLARE @nUserTypeCode_Relative INT = 101007
	DECLARE @nInitialDisclosureEventCodeId INT =153007    --This code indicates Initial Disclosure details entered.
	DECLARE @nPolicyDocumentAggreedEventCodeId INT =153028  --This code indicates Policy Document Aggreed.

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
		SELECT	@ERR_USERINFO_NOTFOUND = 11025, -- User does not exist
				@ERR_USERINFO_DELETE = 11033 -- Error occurred while deleting user
	
		--Check if the UserInfo being deleted exists
		IF (NOT EXISTS(SELECT UserInfoId FROM usr_UserInfo WHERE UserInfoId = @inp_iUserInfoId))
		BEGIN
			SET @out_nReturnValue = @ERR_USERINFO_NOTFOUND
			RETURN (@out_nReturnValue)
		END
		
		IF EXISTS (SELECT * FROM usr_UserInfo WHERE UserInfoId = @inp_iUserInfoId AND UserTypeCodeId <> @nUserTypeCode_Relative)
		BEGIN
			DELETE FROM usr_Authentication WHERE UserInfoID = @inp_iUserInfoId
		END
		ELSE
		BEGIN
			DELETE FROM usr_UserRelation WHERE UserInfoIdRelative = @inp_iUserInfoId
		END
		
		DELETE FROM usr_UserRole WHERE UserInfoID = @inp_iUserInfoId
		IF NOT EXISTS (select * from eve_EventLog WHERE UserInfoId=@inp_iUserInfoId AND EventCodeId IN (@nInitialDisclosureEventCodeId,@nPolicyDocumentAggreedEventCodeId))
		BEGIN
				DELETE FROM eve_EventLog WHERE UserInfoId = @inp_iUserInfoId    --cannot delete entry having EventCodeId as 153007			
			 IF EXISTS (select * FROM usr_DMATDetails WHERE UserInfoID=@inp_iUserInfoId)
			    DELETE FROM usr_DMATDetails WHERE UserInfoId = @inp_iUserInfoId
			 IF EXISTS (select * FROM usr_UserRelation WHERE UserInfoID=@inp_iUserInfoId)
			    DELETE FROM usr_UserRelation WHERE UserInfoId = @inp_iUserInfoId
			 IF EXISTS (select * FROM rul_ApplicabilityDetails where UserId=@inp_iUserInfoId)
			    DELETE FROM rul_ApplicabilityDetails WHERE UserId = @inp_iUserInfoId
		END 	
		
		DELETE FROM usr_UserInfo WHERE UserInfoId = @inp_iUserInfoId
			
		--UPDATE usr_UserInfo
		--	SET StatusCodeId = 102002,
		--	ModifiedBy = @inp_nUserId,
		--	ModifiedOn = dbo.uf_com_GetServerDate()
		--WHERE UserInfoId = @inp_iUserInfoId


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
			SET @out_nReturnValue = dbo.uf_com_GetErrorCode(@ERR_USERINFO_DELETE, ERROR_NUMBER())
		RETURN @out_nReturnValue
	END CATCH
END

