IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[com_MassUploadExcelSheets]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[com_MassUploadExcelSheets](
	[MassUploadExcelSheetId] [int] NOT NULL,
	[MassUploadExcelId] [int] NOT NULL,
	[SheetName] [varchar](200) NOT NULL,
	[IsPrimarySheet] [bit] NOT NULL,
	[ParentSheetName] [varchar](200) NULL,
	[ProcedureUsed] [varchar](200) NULL,
	[ColumnCount] [int] NOT NULL DEFAULT ((0)),
 CONSTRAINT [PK_com_MassUploadExcelSheets] PRIMARY KEY CLUSTERED 
(
	[MassUploadExcelSheetId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'com_MassUploadExcelSheets', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'This will have mapping of the sheets to the excel file used for mass upload' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'com_MassUploadExcelSheets'
GO
