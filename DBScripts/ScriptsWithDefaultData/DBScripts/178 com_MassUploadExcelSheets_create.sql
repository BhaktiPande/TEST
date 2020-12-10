/****** Object:  Table [dbo].[com_MassUploadExcelSheets]    Script Date: 09/30/2015 13:06:55 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[com_MassUploadExcelSheets](
	[MassUploadExcelSheetId] [int] NOT NULL,
	[MassUploadExcelId] [int] NOT NULL,
	[SheetName] [varchar](200) NOT NULL,
	[IsPrimarySheet] [bit] NOT NULL,
	[ParentSheetName] [varchar](200) NULL,
	[ProcedureUsed] [varchar](200) NULL,
	[ColumnCount] [int] NOT NULL,
 CONSTRAINT [PK_com_MassUploadExcelSheets] PRIMARY KEY CLUSTERED 
(
	[MassUploadExcelSheetId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'This will have mapping of the sheets to the excel file used for mass upload' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'com_MassUploadExcelSheets'
GO

ALTER TABLE [dbo].[com_MassUploadExcelSheets] ADD  DEFAULT ((0)) FOR [ColumnCount]
GO

----------------------------------------------------------------------------------------------------------------
INSERT INTO DBUpdateStatus (ScriptNumber, ScriptFileName, Description, CreatedBy)
VALUES (178, '178 com_MassUploadExcelSheets_create', 'Create com_MassUploadExcelSheets', 'Raghvendra')
