/****** Object:  Table [dbo].[du_MappingExcelSheetDetails]    Script Date: 06/07/2016 12:05:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[du_MappingExcelSheetDetails]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[du_MappingExcelSheetDetails](
	[ExcelSheetDetailsID] [int] IDENTITY(1,1) NOT NULL,
	[MassUploadExcelSheetId] [int] NOT NULL,
	[UploadFileName] [varchar](50) NOT NULL,
	[IsPrimarySheet] [bit] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[ModifiedBy] [int] NOT NULL,
	[ModifiedOn] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ExcelSheetDetailsID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_du_MappingExcelSheetDetails_com_MassUploadExcelSheets]') AND parent_object_id = OBJECT_ID(N'[dbo].[du_MappingExcelSheetDetails]'))
ALTER TABLE [dbo].[du_MappingExcelSheetDetails]  WITH CHECK ADD  CONSTRAINT [FK_du_MappingExcelSheetDetails_com_MassUploadExcelSheets] FOREIGN KEY([MassUploadExcelSheetId])
REFERENCES [dbo].[com_MassUploadExcelSheets] ([MassUploadExcelSheetId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_du_MappingExcelSheetDetails_com_MassUploadExcelSheets]') AND parent_object_id = OBJECT_ID(N'[dbo].[du_MappingExcelSheetDetails]'))
ALTER TABLE [dbo].[du_MappingExcelSheetDetails] CHECK CONSTRAINT [FK_du_MappingExcelSheetDetails_com_MassUploadExcelSheets]
GO
