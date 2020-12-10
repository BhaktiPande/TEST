
CREATE TABLE [dbo].[com_MassUploadExcelDataTableColumnMapping](
	[MassUploadExcelDataTableColumnMappingId] [int] NOT NULL,
	[MassUploadExcelSheetId] [int] NOT NULL,
	[ExcelColumnNo] [int] NOT NULL,
	[MassUploadDataTableId] [int] NOT NULL,
	[MassUploadDataTablePropertyNo] [int] NOT NULL,
	[MassUploadDataTablePropertyName] [varchar](200) NOT NULL,
	[MassUploadDataTablePropertyDataType] [varchar](100) NOT NULL,
	[MassUploadDataTablePropertyDataSize] [varchar](20) NOT NULL,
	[RelatedMassUploadRelatedSheetId] [int] NOT NULL,
	[RelatedMassUploadExcelSheetColumnNo] [int] NOT NULL,
	[ApplicableDataCodeGroupId] [int] NULL,
	[IsRequiredField] [bit] NOT NULL,
	[ValidationRegularExpression] [nvarchar](1000) NULL,
	[MaxLength] [int] NULL,
	[MinLength] [int] NULL,
	[IsRequiredErrorCode] [varchar](20) NULL,
	[ValidationRegExpressionErrorCode] [varchar](20) NULL,
	[MaxLengthErrorCode] [varchar](20) NULL,
	[MinLengthErrorCode] [varchar](20) NULL,
 CONSTRAINT [PK_com_MassUploadExcelDataTableColumnMapping] PRIMARY KEY CLUSTERED 
(
	[MassUploadExcelDataTableColumnMappingId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'This column will have code group id for columns which require code from com_Code to be added' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'com_MassUploadExcelDataTableColumnMapping', @level2type=N'COLUMN',@level2name=N'ApplicableDataCodeGroupId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'This will have mapping for the Excel columns with the properties for the Datatable used for the correspoding excel sheet import' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'com_MassUploadExcelDataTableColumnMapping'
GO

ALTER TABLE [dbo].[com_MassUploadExcelDataTableColumnMapping] ADD  CONSTRAINT [DF__com_MassU__Relat__3EA8151D]  DEFAULT ((0)) FOR [RelatedMassUploadRelatedSheetId]
GO

ALTER TABLE [dbo].[com_MassUploadExcelDataTableColumnMapping] ADD  CONSTRAINT [DF_com_MassUploadExcelDataTableColumnMapping_RelatedMassUploadExcelSheetColumnNo]  DEFAULT ((0)) FOR [RelatedMassUploadExcelSheetColumnNo]
GO

ALTER TABLE [dbo].[com_MassUploadExcelDataTableColumnMapping] ADD  CONSTRAINT [DF_com_MassUploadExcelDataTableColumnMapping_IsRequiredField]  DEFAULT ((0)) FOR [IsRequiredField]
GO

----------------------------------------------------------------------------------------------------------------
INSERT INTO DBUpdateStatus (ScriptNumber, ScriptFileName, Description, CreatedBy)
VALUES (180, '180 com_MassUploadExcelDataTableColumnMapping_create', 'Create com_MassUploadExcelDataTableColumnMapping', 'Raghvendra')
