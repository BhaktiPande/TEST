/*
	Created By  :	AKHILESH KAMATE
	Created On 	:	04-FEB-2016
	Description :	This stored Procedure is used to get MappingTableDetails from du_MappingTables table
	
	EXEC st_du_GetMappingFieldsDetails 0,0,''
*/


IF EXISTS (SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_du_GetMappingFieldsDetails')
	DROP PROCEDURE st_du_GetMappingFieldsDetails
GO

CREATE PROCEDURE st_du_GetMappingFieldsDetails
	@out_nReturnValue		INT = 0 OUTPUT,
	@out_nSQLErrCode		INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage		NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
AS	
BEGIN
	SET NOCOUNT ON;
	
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''

		SELECT MT.MappingTableID, MT.ExcelSheetDetailsID, MUES.MassUploadExcelId, MUES.MassUploadExcelSheetId, MT.DisplayName, (MT.FilePath + MT.[FileName]) AS FilePath, MT.ActualTableName, MF.ActualFieldName, MF.ActualFieldDataType, MF.ActualFieldIsRequired, MF.DisplayFieldName, MV.ActualValueName, MV.DisplayValueName, MES.IsPrimarySheet FROM du_MappingTables MT
		INNER JOIN du_MappingExcelSheetDetails MES ON MES.ExcelSheetDetailsID = MT.ExcelSheetDetailsID
		INNER JOIN com_MassUploadExcelSheets MUES ON MES.MassUploadExcelSheetId = MUES.MassUploadExcelSheetId
		INNER JOIN du_MappingFields MF ON MT.MappingTableID = MF.MappingTableID
		LEFT OUTER JOIN du_MappingValues MV ON MF.MappingFieldID = MV.MappingFieldID
		WHERE MT.IsActive = 1
		ORDER BY MT.Sequence
		
	SET NOCOUNT OFF;
END