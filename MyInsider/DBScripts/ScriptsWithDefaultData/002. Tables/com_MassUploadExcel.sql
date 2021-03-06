
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[com_MassUploadExcel]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[com_MassUploadExcel](
	[MassUploadExcelId] [int] NOT NULL,
	[MassUploadName] [varchar](100) NOT NULL,
	[HasMultipleSheets] [bit] NOT NULL,
	[TemplateFileName] [varchar](200) NOT NULL DEFAULT ('')
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'com_MassUploadExcel', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Will contain the list of mass uploads which can be performed and also the excel file to be used for performing the Mass upload' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'com_MassUploadExcel'
GO

