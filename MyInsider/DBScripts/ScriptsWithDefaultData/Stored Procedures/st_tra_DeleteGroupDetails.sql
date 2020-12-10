IF OBJECT_ID ('dbo.st_tra_DeleteGroupDetails') IS NOT NULL
	DROP PROCEDURE dbo.st_tra_DeleteGroupDetails
GO

CREATE PROCEDURE [dbo].[st_tra_DeleteGroupDetails]   
	@i_TransactionMasterId INT,   						
	@inp_iUserId			INt ,						-- Id Used while updating audit table befoe deleting.  
	@out_nReturnValue		INT = 0 OUTPUT,		
	@out_nSQLErrCode		INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage		NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.	
AS
BEGIN
	DECLARE	@ERR_DocumentINFO_DELETE INT = 11062, -- Error occurred while deleting Document details.
			@ERR_DocumentINFO_NOTFOUND INT = 11063, -- Document info not found
			@ERR_DEPENDENTINFOEXISTS INT = 11064 -- Cannot delete this Document details, as some dependent information is dependent on this it.
			
			DECLARE @NSEGroupDetailsId INT
			DECLARE	@DocumentObjectMapId INT
			DECLARE	@DocumentId INT
			DECLARE @iMapToTypeCodeId INT
			DECLARE @iMapToId INT
			DECLARE @iPurposeCodeId INT

	BEGIN TRY
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;		
		--Get Document Id
		SELECT @NSEGroupDetailsId=tra_NSEGroupDetails.NSEGroupDetailsId,	   
		@DocumentId=com_DocumentObjectMapping.DocumentId,
		@iMapToTypeCodeId=com_DocumentObjectMapping.MapToTypeCodeId,
		@iMapToId=com_DocumentObjectMapping.MapToId,
		@iPurposeCodeId=com_DocumentObjectMapping.PurposeCodeId
		FROM tra_NSEDocumentDetails JOIN tra_NSEGroupDetails
		ON tra_NSEDocumentDetails.NSEGroupDetailsId=tra_NSEGroupDetails.NSEGroupDetailsId
		JOIN com_DocumentObjectMapping ON tra_NSEDocumentDetails.DocumentObjectMapId=com_DocumentObjectMapping.DocumentObjectMapId
		WHERE tra_NSEGroupDetails.TransactionMasterId=@i_TransactionMasterId
		
		--Delete Group Details	   	
	   	DELETE FROM tra_NSEDocumentDetails
	  	WHERE tra_NSEDocumentDetails.NSEGroupDetailsId=@NSEGroupDetailsId	   	
		
		--Delete Group Document Id	  	
	  	DELETE FROM tra_NSEGroupDetails
		WHERE tra_NSEGroupDetails.NSEGroupDetailsId=@NSEGroupDetailsId		

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
			SET @out_nReturnValue = dbo.uf_com_GetErrorCode(@ERR_DocumentINFO_DELETE, ERROR_NUMBER())			
		RETURN @out_nReturnValue
	END CATCH
END
GO

