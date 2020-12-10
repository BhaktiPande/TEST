/*
	Created By  :	AKHILESH KAMATE
	Created On 	:	04-FEB-2016
	Description :	This stored Procedure is used to get MappingTableDetails from du_MappingTables table
	
	EXEC st_du_GetMappingTableDetails 0,0,''
*/


IF EXISTS (SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_du_GetMappingTableDetails')
	DROP PROCEDURE st_du_GetMappingTableDetails
GO

CREATE PROCEDURE st_du_GetMappingTableDetails
	@out_nReturnValue		INT = 0 OUTPUT,
	@out_nSQLErrCode		INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage		NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
AS
BEGIN
	SET NOCOUNT ON;
		BEGIN TRY
			IF @out_nReturnValue IS NULL
				SET @out_nReturnValue = 0
			IF @out_nSQLErrCode IS NULL
				SET @out_nSQLErrCode = 0
			IF @out_sSQLErrMessage IS NULL
				SET @out_sSQLErrMessage = ''
			
			SELECT MT.MappingTableID , ExcelSheetDetailsID, ActualTableName, DisplayName, FilePath, [FileName], ExcelSheetName, UploadMode, Query, ConnectionString, 
				   MT.IsSFTPEnable, SD.HostName, SD.UserName, SD.[Password], SD.PortNumber, SD.SshHostKeyFingerprint, SD.SourceFilePath FROM du_MappingTables MT
			LEFT OUTER JOIN du_SFTPFileDetails SD ON SD.MappingTableID = MT.MappingTableID
			WHERE MT.IsActive = 1
			ORDER BY MT.Sequence
			
		END	 TRY
		
		BEGIN CATCH	
			SET @out_nSQLErrCode    =  ERROR_NUMBER()
			SET @out_sSQLErrMessage =   ERROR_MESSAGE()	
			
			 --Return common error if required, otherwise specific error.		
			SET @out_nReturnValue =  dbo.uf_com_GetErrorCode(-1 , ERROR_NUMBER())
			RETURN @out_nReturnValue
		END CATCH
	SET NOCOUNT OFF;
END