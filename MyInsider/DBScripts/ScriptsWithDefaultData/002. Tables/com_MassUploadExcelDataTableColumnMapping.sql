/****** Object:  Table [dbo].[com_MassUploadExcelDataTableColumnMapping]    Script Date: 06/07/2016 12:05:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[com_MassUploadExcelDataTableColumnMapping]') AND type in (N'U'))
BEGIN
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
	[ValidationRegularExpression] [varchar](2000) NULL,
	[MaxLength] [int] NULL,
	[MinLength] [int] NULL,
	[IsRequiredErrorCode] [varchar](20) NULL,
	[ValidationRegExpressionErrorCode] [varchar](20) NULL,
	[MaxLengthErrorCode] [varchar](20) NULL,
	[MinLengthErrorCode] [varchar](20) NULL,
	[DependentColumnNo] [int] NULL,
	[DependentColumnErrorCode] [varchar](20) NULL,
	[DependentValueColumnNumber] [int] NULL,
	[DependentValueColumnValue] [varchar](4000) NULL,
	[DependentValueColumnErrorCode] [varchar](20) NULL,
	[DefaultValue] [varchar](100) NULL,
 CONSTRAINT [PK_com_MassUploadExcelDataTableColumnMapping] PRIMARY KEY CLUSTERED 
(
	[MassUploadExcelDataTableColumnMappingId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'com_MassUploadExcelDataTableColumnMapping', N'COLUMN',N'ApplicableDataCodeGroupId'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'This column will have code group id for columns which require code from com_Code to be added' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'com_MassUploadExcelDataTableColumnMapping', @level2type=N'COLUMN',@level2name=N'ApplicableDataCodeGroupId'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'com_MassUploadExcelDataTableColumnMapping', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'This will have mapping for the Excel columns with the properties for the Datatable used for the correspoding excel sheet import' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'com_MassUploadExcelDataTableColumnMapping'
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF__com_MassU__Relat__3EA8151D]') AND parent_object_id = OBJECT_ID(N'[dbo].[com_MassUploadExcelDataTableColumnMapping]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__com_MassU__Relat__3EA8151D]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[com_MassUploadExcelDataTableColumnMapping] ADD  CONSTRAINT [DF__com_MassU__Relat__3EA8151D]  DEFAULT ((0)) FOR [RelatedMassUploadRelatedSheetId]
END


End
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_com_MassUploadExcelDataTableColumnMapping_RelatedMassUploadExcelSheetColumnNo]') AND parent_object_id = OBJECT_ID(N'[dbo].[com_MassUploadExcelDataTableColumnMapping]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_com_MassUploadExcelDataTableColumnMapping_RelatedMassUploadExcelSheetColumnNo]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[com_MassUploadExcelDataTableColumnMapping] ADD  CONSTRAINT [DF_com_MassUploadExcelDataTableColumnMapping_RelatedMassUploadExcelSheetColumnNo]  DEFAULT ((0)) FOR [RelatedMassUploadExcelSheetColumnNo]
END


End
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_com_MassUploadExcelDataTableColumnMapping_IsRequiredField]') AND parent_object_id = OBJECT_ID(N'[dbo].[com_MassUploadExcelDataTableColumnMapping]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_com_MassUploadExcelDataTableColumnMapping_IsRequiredField]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[com_MassUploadExcelDataTableColumnMapping] ADD  CONSTRAINT [DF_com_MassUploadExcelDataTableColumnMapping_IsRequiredField]  DEFAULT ((0)) FOR [IsRequiredField]
END


End
GO
