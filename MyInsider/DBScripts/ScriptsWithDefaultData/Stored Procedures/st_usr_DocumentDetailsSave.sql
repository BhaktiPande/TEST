IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_usr_DocumentDetailsSave')
DROP PROCEDURE [dbo].[st_usr_DocumentDetailsSave]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Saves demat details for Employee / Non-Employee type user.

Returns:		0, if Success.
				
Created by:		Swapnil M
Created on:		06-Aug-2010

Modification History:
Modified By		Modified On		Description
Raghvendra		07-Sep-2016		Changed the GETDATE() call with function dbo.uf_com_GetServerDate(). This function will return the date to be used as server date.

Usage:
EXEC st_usr_DMATDetailsSave 1, 
-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_usr_DocumentDetailsSave]
	@inp_iUserInfoId				INT
	,@inp_iDocumentDetailsID		INT OUTPUT
	,@inp_sGUID						NVARCHAR(100)	
	,@inp_sDocumentName				NVARCHAR(200)
	,@inp_sDescription				NVARCHAR(512)	
	,@inp_sDocumentPath				VARCHAR(512)
	,@inp_iFileSize					BIGINT
	,@inp_sFileType					NVARCHAR(50)
    ,@inp_iLoggedInUserId			INT
	,@out_nReturnValue				INT = 0 OUTPUT
	,@out_nSQLErrCode				INT = 0 OUTPUT				-- Output SQL Error Number, if error occurred.
	,@out_sSQLErrMessage			VARCHAR(500) = '' OUTPUT  -- Output SQL Error Message, if error occurred.	
AS
BEGIN
	DECLARE @sSQL NVARCHAR(MAX)
	DECLARE @ERR_DOCUMENT_SAVE INT = 11044 -- Error occurred while saving document details
	DECLARE @ERR_DOCUMENT_NOTFOUND INT = 11043 -- Demat details does not exist.
	DECLARE @ERR_USERNOTVALIDFORDOCUMENT INT = 11041 -- Cannot save Document details. To save Document details, user should be of type employee or non-employee.
	
	DECLARE --@nUserType_CO INT = 101002,
			@nUserType_Employee INT = 101003,
			--@nUserType_CorporateUser INT = 101004,
			@nUserType_NonEmployee INT = 101006,
			@nUserType_Relative INT = 101007

	BEGIN TRY
		
		SET NOCOUNT ON;
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''
		
		IF NOT EXISTS(SELECT USER FROM usr_UserInfo 
					WHERE UserInfoId = @inp_iUserInfoId 
						AND UserTypeCodeId IN (@nUserType_Employee, @nUserType_NonEmployee, @nUserType_Relative))
		BEGIN
			SET @out_nReturnValue = @ERR_USERNOTVALIDFORDOCUMENT
			RETURN @out_nReturnValue
		END
		
		IF @inp_iDocumentDetailsID = 0
		BEGIN
			-- Insert new record
			INSERT INTO usr_DocumentDetails
				(UserInfoID, DocumentName, DocumentPath, FileSize, FileType, GUID, Description, 
				CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
			VALUES
				(@inp_iUserInfoId, @inp_sDocumentName, @inp_sDocumentPath, @inp_iFileSize, @inp_sFileType, @inp_sGUID, @inp_sDescription,
				@inp_iLoggedInUserId, dbo.uf_com_GetServerDate(), @inp_iLoggedInUserId, dbo.uf_com_GetServerDate())			
			
			SET @inp_iDocumentDetailsID = SCOPE_IDENTITY()
		END
		ELSE
		BEGIN
			--Check if the UserInfo whose details are being updated exists
			IF (NOT EXISTS(SELECT DocumentDetailsID FROM usr_DocumentDetails WHERE DocumentDetailsID = @inp_iDocumentDetailsID))
			BEGIN		
				SET @out_nReturnValue = @ERR_DOCUMENT_NOTFOUND
				RETURN (@out_nReturnValue)
			END

			-- Update existing details
			UPDATE usr_DocumentDetails
			SET DocumentName = @inp_sDocumentName,
				DocumentPath = @inp_sDocumentPath,
				FileSize = @inp_iFileSize,
				FileType = @inp_sFileType,
				GUID = @inp_sGUID,
				Description = @inp_sDescription,
				ModifiedBy = @inp_iLoggedInUserId,
				ModifiedOn = dbo.uf_com_GetServerDate()
			WHERE DocumentDetailsID = @inp_iDocumentDetailsID
		END

		RETURN 0
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()
		SET @out_nReturnValue = dbo.uf_com_GetErrorCode(@ERR_DOCUMENT_SAVE,ERROR_NUMBER())
		RETURN @out_nReturnValue
	END CATCH
END
