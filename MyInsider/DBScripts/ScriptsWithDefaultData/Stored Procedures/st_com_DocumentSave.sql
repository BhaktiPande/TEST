IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_com_DocumentSave')
DROP PROCEDURE [dbo].[st_com_DocumentSave]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Saves demat details for Employee / Non-Employee type user.

Returns:		0, if Success.
				
Created by:		Arundhati
Created on:		26-Mar-2015

Modification History:
Modified By		Modified On		Description
Arundhati		13-Apr-2015		Document details are returned as dataset
Arundhati		17-Apr-2015		If PurposeCodeId is 0, set it to null
Raghvendra		07-Sep-2016	Changed the GETDATE() call with function dbo.uf_com_GetServerDate(). This function will return the date to be used as server date.
Usage:
EXEC st_usr_DMATDetailsSave 1, 
-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_com_DocumentSave]
	--@inp_iUserInfoId				INT
	@inp_iDocumentDetailsID		INT OUTPUT
	,@inp_sGUID						NVARCHAR(100)	
	,@inp_sDocumentName				NVARCHAR(300)
	,@inp_sDescription				NVARCHAR(512)	
	,@inp_sDocumentPath				VARCHAR(512)
	,@inp_iFileSize					BIGINT
	,@inp_sFileType					NVARCHAR(50)
	,@inp_iMapToTypeCodeId			INT
	,@inp_iMapToId					INT
	,@inp_iPurposeCodeId			INT
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

	DECLARE @MAPTOTYPE_PolicyDocument INT = 132001
	DECLARE @MAPTOTYPE_TradingPolicy INT = 132002
	DECLARE @MAPTOTYPE_User INT = 132003
	DECLARE @nDocumentObjctMapId INT = 0
	DECLARE @nRet INT = 0
	DECLARE @MAPTOTYPE_EULAAcceptance INT = 132021
	DECLARE @PEDocUploaded INT = 132026				--Map To Type - Period End Document Upload
	DECLARE @PeriodEndDiscNotConfirmed INT	= 148002		--Disclosure Status - Not Confirmed
	DECLARE @DiscTypePE INT = 147003	--Disclosure Type - Period End
	DECLARE @DiscStatausCodeConfirmed INT	= 148003		--Disclosure Status - Confirmed
	DECLARE @ChkPEStatus INT = 0

	BEGIN TRY
		
		SET NOCOUNT ON;
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''
		
		IF @inp_iPurposeCodeId = 0
			SET @inp_iPurposeCodeId = NULL
			
		IF (@inp_iMapToTypeCodeId = @MAPTOTYPE_User AND 
			NOT EXISTS (SELECT UserInfoId FROM usr_UserInfo 
					WHERE UserInfoId = @inp_iMapToId 
						AND UserTypeCodeId IN (@nUserType_Employee, @nUserType_NonEmployee, @nUserType_Relative)))
		BEGIN
			SET @out_nReturnValue = @ERR_USERNOTVALIDFORDOCUMENT
			RETURN @out_nReturnValue
		END
		
		IF @inp_iDocumentDetailsID = 0
		BEGIN
			-- Insert new record
			INSERT INTO com_Document
				(DocumentName, DocumentPath, FileSize, FileType, GUID, Description, 
				CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
			VALUES
				(@inp_sDocumentName, @inp_sDocumentPath, @inp_iFileSize, @inp_sFileType, @inp_sGUID, @inp_sDescription,
				@inp_iLoggedInUserId, dbo.uf_com_GetServerDate(), @inp_iLoggedInUserId, dbo.uf_com_GetServerDate())			
			
			SET @inp_iDocumentDetailsID = SCOPE_IDENTITY()
		END
		ELSE
		BEGIN
			--Check if the UserInfo whose details are being updated exists
			IF (NOT EXISTS(SELECT DocumentID FROM com_Document WHERE DocumentId = @inp_iDocumentDetailsID))
			BEGIN		
				SET @out_nReturnValue = @ERR_DOCUMENT_NOTFOUND
				RETURN (@out_nReturnValue)
			END

			-- Update existing details
			UPDATE com_Document
			SET DocumentName = @inp_sDocumentName,
				DocumentPath = @inp_sDocumentPath,
				FileSize = @inp_iFileSize,
				FileType = @inp_sFileType,
				GUID = @inp_sGUID,
				Description = @inp_sDescription,
				ModifiedBy = @inp_iLoggedInUserId,
				ModifiedOn = dbo.uf_com_GetServerDate()
			WHERE DocumentId = @inp_iDocumentDetailsID
		END
		
		SELECT @nDocumentObjctMapId = DocumentObjectMapId
		FROM com_DocumentObjectMapping
		WHERE DocumentId = @inp_iDocumentDetailsID AND MapToTypeCodeId = @inp_iMapToTypeCodeId 
		AND MapToId = @inp_iMapToId AND ISNULL(PurposeCodeId, 0) = ISNULL(@inp_iPurposeCodeId, 0)
		
		IF @nDocumentObjctMapId IS NULL
			SET @nDocumentObjctMapId = 0

		if(@PEDocUploaded = @inp_iMapToTypeCodeId )
		BEGIN
			IF EXISTS (SELECT MIN(TransactionMasterId) FROM tra_TransactionMaster_OS WHERE TransactionMasterId = @inp_iMapToId AND DisclosureTypeCodeId = @DiscTypePE AND TransactionStatusCodeId = @PeriodEndDiscNotConfirmed)
			BEGIN
				SET @inp_iMapToId = (SELECT MIN(TransactionMasterId) FROM tra_TransactionMaster_OS WHERE TransactionMasterId = @inp_iMapToId AND DisclosureTypeCodeId = @DiscTypePE AND TransactionStatusCodeId = @PeriodEndDiscNotConfirmed)
			END
			ELSE
			BEGIN
				SET @inp_iMapToId = (SELECT MAX(TransactionMasterId) FROM tra_TransactionMaster_OS WHERE TransactionMasterId = @inp_iMapToId AND DisclosureTypeCodeId = @DiscTypePE AND TransactionStatusCodeId = @DiscStatausCodeConfirmed)
			END
		END

		EXEC @nRet = st_com_DocumentObjctMapping @nDocumentObjctMapId, @inp_iDocumentDetailsID, @inp_iMapToTypeCodeId, @inp_iMapToId, @inp_iPurposeCodeId,
				@out_nReturnValue OUTPUT, @out_nSQLErrCode OUTPUT, @out_sSQLErrMessage OUTPUT
		
		IF(@inp_iMapToTypeCodeId = @MAPTOTYPE_EULAAcceptance)
			SELECT * FROM com_Document D JOIN com_DocumentObjectMapping DO ON DO.DocumentId = D.DocumentId WHERE D.DocumentId = @inp_iDocumentDetailsID
		ELSE
			SELECT * FROM com_Document WHERE DocumentId = @inp_iDocumentDetailsID
				
		IF @out_nReturnValue <> 0
			RETURN @out_nReturnValue
		
		RETURN 0
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()
		SET @out_nReturnValue = dbo.uf_com_GetErrorCode(@ERR_DOCUMENT_SAVE,ERROR_NUMBER())
		RETURN @out_nReturnValue
	END CATCH
END
