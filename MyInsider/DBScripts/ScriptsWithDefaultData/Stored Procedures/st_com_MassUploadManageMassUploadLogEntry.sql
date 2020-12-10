IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_com_MassUploadManageMassUploadLogEntry')
DROP PROCEDURE [dbo].[st_com_MassUploadManageMassUploadLogEntry]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
Description:	This procedure is used for adding a log entry for the mass upload.
				In this procedure if the @inp_iMassUploadLogId and @inp_iUploadedDocumentId are not null and not 0 then 
				value for @inp_iUploadedDocumentId is updated. This is used when we want to update the documentid after the document is added.

Returns:		0, if Success.
				
Created by:		Raghvendra Wagholikar
Created on:		29-Sep-2015

Modification History:
Modified By		Modified On	Description
Raghvendra		07-Oct-2015	Added a column Documentid to be saved in the log table to track the file uploaded for the mass upload and the error file
							associated with it.
Raghvendra		4-Dec-2015	Moved the IF EXIST block above Comments		
Raghvendra		07-Sep-2016	Changed the GETDATE() call with function dbo.uf_com_GetServerDate(). This function will return the date to be used as server date.					
Usage:
EXEC st_MassUploadCommonProcedureExecution 1
-------------------------------------------------------------------------------------------------*/


CREATE PROCEDURE [dbo].[st_com_MassUploadManageMassUploadLogEntry]
	@inp_iMassUploadLogId INT
	,@inp_iMassUploadTypeId INT
	,@inp_iStatusCodeId INT
	,@inp_iUploadedDocumentId INT 
	,@inp_sErrorReportFileName VARCHAR(100)
	,@inp_sErrorMessage VARCHAR(1000)
	,@inp_iLoginUserId INT
	,@inp_iNewCreatedMassUploadLogId INT OUTPUT
	,@out_nReturnValue				INT = 0 OUTPUT
	,@out_nSQLErrCode				INT = 0 OUTPUT				-- Output SQL Error Number, if error occurred.
	,@out_sSQLErrMessage			VARCHAR(500) = '' OUTPUT  -- Output SQL Error Message, if error occurred.	
AS
BEGIN

BEGIN TRY
	IF @out_nReturnValue IS NULL
		SET @out_nReturnValue = 0
	IF @out_nSQLErrCode IS NULL
		SET @out_nSQLErrCode = 0
	IF @out_sSQLErrMessage IS NULL
		SET @out_sSQLErrMessage = ''''
	
	IF @inp_iMassUploadLogId = 0
	BEGIN
		--Insert the record
		INSERT INTO [com_tbl_MassUploadLog] ([MassUploadTypeId] ,[CreatedBy] ,[CreatedOn] ,[Status] ,UploadedDocumentId,[ErrorReportFileName], ErrorMessage)
		VALUES
        (@inp_iMassUploadTypeId ,@inp_iLoginUserId,dbo.uf_com_GetServerDate() ,@inp_iStatusCodeId ,@inp_iUploadedDocumentId,@inp_sErrorReportFileName, @inp_sErrorMessage)
        SELECT @inp_iNewCreatedMassUploadLogId = SCOPE_IDENTITY()
	END
	ELSE
	BEGIN
		IF @inp_iUploadedDocumentId IS NOT NULL AND @inp_iUploadedDocumentId <> 0
		BEGIN
			UPDATE [com_tbl_MassUploadLog] 
				SET UploadedDocumentId = @inp_iUploadedDocumentId 
			WHERE MassUploadLogId = @inp_iMassUploadLogId
		END
		
		UPDATE [com_tbl_MassUploadLog] 
			SET [ErrorReportFileName] = @inp_sErrorReportFileName , 
				Status = @inp_iStatusCodeId,
				ErrorMessage = @inp_sErrorMessage
		WHERE MassUploadLogId = @inp_iMassUploadLogId
		SELECT @inp_iNewCreatedMassUploadLogId = @inp_iMassUploadLogId
	--Update the values
	END
		
	SELECT 1
	RETURN 0
	
END TRY

BEGIN CATCH
	SET @out_nSQLErrCode    =  ERROR_NUMBER()
	SET @out_sSQLErrMessage =   ERROR_MESSAGE()
	SET @out_nReturnValue = @out_nSQLErrCode
	RETURN @out_nReturnValue
END CATCH

END
