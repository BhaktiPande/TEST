/*
	Created By  :	Shubhangi Gurude
	Created On  :   06-Mar-2017
	Description :	This stored Procedure is used to get pdf file name to delete pdf file from group	
*/

IF OBJECT_ID ('dbo.st_tra_GetFileDetails') IS NOT NULL
	DROP PROCEDURE dbo.st_tra_GetFileDetails
GO

CREATE PROCEDURE [dbo].[st_tra_GetFileDetails]
	 @i_TransactionMasterId INT							
	,@out_nReturnValue		INT = 0 OUTPUT
	,@out_nSQLErrCode		INT = 0 OUTPUT				-- Output SQL Error Number, if error occurred.
	,@out_sSQLErrMessage		NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.	
AS
BEGIN
	DECLARE @ERR_GROUPVALUES_GETDETAILS INT = 50440 -- Error occurred while fetching code details.
	DECLARE @ERR_GROUPVALUES_NOTFOUND INT = 50435 -- Group details does not exist
	DECLARE @NSEdocumentId INT=132017
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
			
		SELECT 		
		com_DocumentObjectMapping.DocumentId,
		com_Document.DocumentName,
		com_Document.GUID AS [GUID],
		com_DocumentObjectMapping.MapToTypeCodeId,
		com_DocumentObjectMapping.MapToId
		FROM 		
		com_DocumentObjectMapping 
		JOIN com_Document ON com_DocumentObjectMapping.DocumentId=com_Document.DocumentId
		WHERE com_DocumentObjectMapping.MapToId=@i_TransactionMasterId and MapToTypeCodeId=@NSEdocumentId		

		SET @out_nReturnValue = 0
		RETURN @out_nReturnValue
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()		
		-- Return common error if required, otherwise specific error.		
		SET @out_nReturnValue  = dbo.uf_com_GetErrorCode(@ERR_GROUPVALUES_GETDETAILS, ERROR_NUMBER())
		RETURN @out_nReturnValue		
	END CATCH
END
GO
