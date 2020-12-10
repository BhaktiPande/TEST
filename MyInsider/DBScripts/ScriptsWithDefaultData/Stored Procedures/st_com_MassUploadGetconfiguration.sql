IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_com_MassUploadGetconfiguration')
DROP PROCEDURE [dbo].[st_com_MassUploadGetconfiguration]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
Description:	Get the configuration data to be used for Mass upload ID. This procedure will return 
the data from following tables,
1) com_MassUploadExcel
2) com_MassUploadExcelSheets
3) com_MassUploadExcelDataTableColumnMapping

Returns:		0, if Success.
				
Created by:		Raghvendra Wagholikar
Created on:		17-Mar-2015

Modification History:
Modified By		Modified On	Description
Raghvendra		01-Oct-2015	Added columns for DependentColumn and DependentColumn error number in the select query.
Raghvendra		09-Oct-2015	Added columns for Dependent Column Value condition
Raghvendra		28-Oct-2015	Added column for DefaultValue to be added when data is empty
Raghvendra		4-Dec-2015	Moved the IF EXIST block above Comments
Usage:
EXEC st_com_MassUploadGetconfiguration 1
-------------------------------------------------------------------------------------------------*/


CREATE PROCEDURE [dbo].[st_com_MassUploadGetconfiguration]
	@inp_iMassUploadId					INT,							-- MassUploadId for which mass upload is to be performed.
	@out_nReturnValue					INT = 0 OUTPUT,
	@out_nSQLErrCode					INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage					NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
	
AS
BEGIN
	DECLARE @ERR_DURING_MASSUPLOAD INT
	
	BEGIN TRY
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;
		SELECT @ERR_DURING_MASSUPLOAD = 0
		
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0

		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0

		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''

		SELECT ME.MassUploadExcelId,ME.MassUploadName,ME.HasMultipleSheets,
		MES.MassUploadExcelSheetId, MES.SheetName,MES.IsPrimarySheet,MES.ProcedureUsed,MES.ParentSheetName,
		MDT.MassUploadExcelDataTableColumnMappingId, MDT.ExcelColumnNo, DT.MassUploadDataTableId,DT.MassUploadDataTableName,
		MDT.MassUploadDataTablePropertyNo,MDT.MassUploadDataTablePropertyName,MDT.MassUploadDataTablePropertyDataType,
		MDT.MassUploadDataTablePropertyDataSize, MDT.RelatedMassUploadRelatedSheetId, MDT.RelatedMassUploadExcelSheetColumnNo,
		MDT.ApplicableDataCodeGroupId , MES.ColumnCount,MDT.IsRequiredField,MDT.ValidationRegularExpression,MDT.MaxLength,
		MDT.MinLength,MDT.IsRequiredErrorCode,MDT.ValidationRegExpressionErrorCode,MDT.MaxLengthErrorCode, MDT.MinLengthErrorCode,
		MDT.DependentColumnNo, MDT.DependentColumnErrorCode, MDT.DependentValueColumnNumber,MDT.DependentValueColumnValue,
		MDT.DependentValueColumnErrorCode,MDT.DefaultValue
		FROM com_MassUploadExcelDataTableColumnMapping MDT
		JOIN com_MassUploadExcelSheets MES ON MES.MassUploadExcelSheetId = MDT.MassUploadExcelSheetId
		JOIN com_MassUploadExcel ME ON ME.MassUploadExcelId = MES.MassUploadExcelId
		JOIN com_MassUploadDataTable DT ON DT.MassUploadDataTableId = MDT.MassUploadDataTableId
		WHERE MES.MassUploadExcelId = @inp_iMassUploadId order by MES.MassUploadExcelSheetId,MDT.ExcelColumnNo

		SET @out_nReturnValue = 0
		RETURN @out_nReturnValue
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()
		
		-- Return common error if required, otherwise specific error.		
		SET @out_nReturnValue  = dbo.uf_com_GetErrorCode(@ERR_DURING_MASSUPLOAD, ERROR_NUMBER())
		RETURN @out_nReturnValue		
	END CATCH
END

