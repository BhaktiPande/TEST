IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_usr_UserRelationSave')
DROP PROCEDURE [dbo].[st_usr_UserRelationSave]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Saves the relationship record for user and relative

Returns:		0, if Success.
				
Created by:		Arundhati
Created on:		20-Feb-2015
Modification History:
Modified By		Modified On	Description
Raghvendra		07-Sep-2016	Changed the GETDATE() call with function dbo.uf_com_GetServerDate(). This function will return the date to be used as server date.

Usage:
DECLARE @RC int
EXEC st_usr_UserInfoSave ,1
-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_usr_UserRelationSave]
	@inp_iUserInfoId		INT,
    @inp_iParentId			INT,
    @inp_iRelationWithEmployee	INT,
	@inp_iLoggedInUserId	INT,						-- Id of the user inserting/updating the UserInfo
	@out_nReturnValue		INT = 0 OUTPUT,
	@out_nSQLErrCode		INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage		NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
AS
BEGIN

	DECLARE @ERR_USERRELATIONINFO_SAVE INT = 11092 -- Error occurred while saving relative's details.
	DECLARE @ERR_USERINFO_NOTFOUND INT = 11025 -- User does not exist.
	DECLARE @ERR_USERISNOTVALIDFORADDINGRELATIVE INT = 11093 -- User must be of type Employee / Non-employee, to add a relative

	DECLARE @nUserTypeCode_Employee INT = 101003
	DECLARE @nUserTypeCode_NonEmployee INT = 101006
	DECLARE @nUserTypeCode_Relative INT = 101007
	DECLARE @nRetValue INT
	DECLARE @iUserRelationId INT

	BEGIN TRY
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;

		--Initialize variables
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''

		print '1'
		--Save the UserInfo details
		-- Check that the user exists for which the relative's record is to be added
		IF ((@inp_iUserInfoId <> 0 AND NOT EXISTS(SELECT UserInfoId FROM usr_UserInfo WHERE UserInfoId = @inp_iUserInfoId))
			OR NOT EXISTS(SELECT UserInfoId FROM usr_UserInfo WHERE UserInfoId = @inp_iParentId))
		BEGIN		
			SET @out_nReturnValue = @ERR_USERINFO_NOTFOUND
			RETURN (@out_nReturnValue)
		END

		print '2'
		-- Check the type of user is Employee or non employee for which the relative's record is being added
		IF (NOT EXISTS(SELECT UserInfoId FROM usr_UserInfo WHERE UserInfoId = @inp_iParentId 
						AND (UserTypeCodeId = @nUserTypeCode_Employee OR UserTypeCodeId = @nUserTypeCode_NonEmployee)))
		BEGIN		
			SET @out_nReturnValue = @ERR_USERISNOTVALIDFORADDINGRELATIVE
			RETURN (@out_nReturnValue)
		END
				
		print '3'
		SELECT @iUserRelationId = UserRelationId 
		FROM usr_UserRelation 
		WHERE UserInfoId = @inp_iParentId AND UserInfoIdRelative = @inp_iUserInfoId
		
		IF @iUserRelationId IS NULL
			SET @iUserRelationId = 0
		
		IF @iUserRelationId = 0
		BEGIN
			INSERT INTO usr_UserRelation(
					UserInfoId,
					UserInfoIdRelative,
					RelationTypeCodeId,
					CreatedBy, CreatedOn, ModifiedBy,ModifiedOn)
			VALUES (
					@inp_iParentId,
					@inp_iUserInfoId,
					@inp_iRelationWithEmployee,
					@inp_iLoggedInUserId, dbo.uf_com_GetServerDate(), @inp_iLoggedInUserId, dbo.uf_com_GetServerDate() )
					
			SET @iUserRelationId = SCOPE_IDENTITY()

		END
		ELSE
		BEGIN
			--Check if the UserInfo whose details are being updated exists
	
			Update usr_UserRelation
			Set 	RelationTypeCodeId = @inp_iRelationWithEmployee,
					ModifiedBy	 = @inp_iLoggedInUserId,
					ModifiedOn	 = dbo.uf_com_GetServerDate()
			Where UserRelationId = @iUserRelationId			
		END
		
		SET @out_nReturnValue = 0
		RETURN @out_nReturnValue
	END	 TRY
	
	BEGIN CATCH	
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()	
		
		-- Return common error if required, otherwise specific error.		
		SET @out_nReturnValue =  dbo.uf_com_GetErrorCode(@ERR_USERRELATIONINFO_SAVE, ERROR_NUMBER())
		RETURN @out_nReturnValue
	END CATCH
END