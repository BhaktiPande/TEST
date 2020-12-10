/*
	Created By  :	Shubhangi Gurude
	Created On  :   09-Mar-2017
	Description :	This stored Procedure is used to get NSE Document details
*/

IF EXISTS (SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_tra_GetNSEDocumentDetails')
	DROP PROCEDURE st_tra_GetNSEDocumentDetails
GO

CREATE PROCEDURE [dbo].[st_tra_GetNSEDocumentDetails] 	
	 @inp_iGroupID			INT	
	,@inp_UserInfoCheck		INT						
	,@out_nReturnValue		INT = 0 OUTPUT
	,@out_nSQLErrCode		INT = 0 OUTPUT				-- Output SQL Error Number, if error occurred.
	,@out_sSQLErrMessage		NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
	
AS
BEGIN
	DECLARE @ERR_GROUPVALUES_GETDETAILS INT = 50440 -- Error occurred while fetching code details.
	DECLARE @ERR_GROUPVALUES_NOTFOUND INT = 50435 -- Group details does not exist
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
			
	  DECLARE @Whereclause VARCHAR(max)
	  DECLARE @Whereclause1 VARCHAR(max)
	  
	  SET @Whereclause1='where tra_NSEGroupDetails.GroupId='+convert(VARCHAR(10),@inp_iGroupID) +'' 
	  
	  IF(@inp_UserInfoCheck=1)
	  BEGIN
	  SET @Whereclause='AND tra_NSEGroupDetails.UserInfoId IS NOT NULL'	
	  
	  END 
	  ELSE
	  BEGIN
	  SET @Whereclause='AND tra_NSEGroupDetails.UserInfoId IS NULL'	  
	  END  
	  		
		
	  EXEC('SELECT 
		com_Document.DocumentName AS DocumentName, tra_NSEGroup.DownloadedDate,
		com_DocumentObjectMapping.MapToTypeCodeId,com_DocumentObjectMapping.MapToId,
		com_Document.GUID 
		FROM com_Document
		JOIN com_DocumentObjectMapping 
		ON com_Document.DocumentId=com_DocumentObjectMapping.DocumentId
		JOIN tra_NSEDocumentDetails 
		ON com_DocumentObjectMapping.DocumentObjectMapId=tra_NSEDocumentDetails.DocumentObjectMapId
		JOIN tra_NSEGroupDetails 
		ON tra_NSEDocumentDetails.NSEGroupDetailsId=tra_NSEGroupDetails.NSEGroupDetailsId
		JOIN tra_NSEGroup 
		ON tra_NSEGroupDetails.GroupId=tra_NSEGroup.GroupId
		 '+ @Whereclause1 +  @Whereclause +' ') 		

	END TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()
		
		-- Return common error if required, otherwise specific error.		
		SET @out_nReturnValue  = dbo.uf_com_GetErrorCode(@ERR_GROUPVALUES_GETDETAILS, ERROR_NUMBER())
		RETURN @out_nReturnValue		
	END CATCH
END
GO

