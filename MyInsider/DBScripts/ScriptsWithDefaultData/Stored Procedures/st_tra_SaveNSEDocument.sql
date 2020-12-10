
-- ======================================================================================================
-- Author      : Shubhangi Gurude,Tushar Wakchaure												=
-- CREATED DATE: 04-Feb-2017                                                 							=
-- Description : SCRIPT Used to save Groupwise document    												=
-- ======================================================================================================

IF OBJECT_ID ('dbo.st_tra_SaveNSEDocument') IS NOT NULL
	DROP PROCEDURE dbo.st_tra_SaveNSEDocument
GO

CREATE PROCEDURE st_tra_SaveNSEDocument
(


	 @NSEGroupDetailsId INT	
	,@inp_iDocumentDetailsID		INT 
	,@inp_iDocumentObjctMapId  INT
	,@inp_sGUID					NVARCHAR(100)	
    ,@inp_iLoggedInUserId			INT
	,@out_nReturnValue				INT = 0 OUTPUT
	,@out_nSQLErrCode				INT = 0 OUTPUT				-- Output SQL Error Number, if error occurred.
	,@out_sSQLErrMessage			VARCHAR(500) = '' OUTPUT
)
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
	BEGIN TRY
		
		SET NOCOUNT ON;
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''
	   
		BEGIN
				
				
				INSERT INTO tra_NSEDocumentDetails
				(NSEGroupDetailsId,DocumentObjectMapId, CreatedBy, CreatedOn,ModifiedBy,ModifiedOn)
			VALUES
				(@NSEGroupDetailsId,(SELECT com_DocumentObjectMapping.DocumentObjectMapId FROM com_Document
				JOIN com_DocumentObjectMapping ON com_Document.DocumentId=com_DocumentObjectMapping.DocumentId
				WHERE  com_Document.GUID=@inp_sGUID),@inp_iLoggedInUserId,getdate(),@inp_iLoggedInUserId,getdate())
				
			
			SET @inp_iDocumentDetailsID = SCOPE_IDENTITY()			
		 
		END
	   
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()
		SET @out_nReturnValue = dbo.uf_com_GetErrorCode(@ERR_DOCUMENT_SAVE,ERROR_NUMBER())
		RETURN @out_nReturnValue
	END CATCH
END

--SELECT com_DocumentObjectMapping.DocumentObjectMapId FROM com_Document
--JOIN com_DocumentObjectMapping ON com_Document.DocumentId=com_DocumentObjectMapping.DocumentId
--WHERE  com_Document.GUID='9efb9475-5349-405f-9e38-a6862f6040c6.pdf'

GO

