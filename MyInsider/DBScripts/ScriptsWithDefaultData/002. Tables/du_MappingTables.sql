/****** Object:  Table [dbo].[du_MappingTables]    Script Date: 06/07/2016 12:05:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[du_MappingTables]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[du_MappingTables](
	[MappingTableID] [int] IDENTITY(1,1) NOT NULL,
	[ExcelSheetDetailsID] [int] NOT NULL,
	[ActualTableName] [varchar](50) NOT NULL,
	[DisplayName] [varchar](50) NOT NULL,
	[FilePath] [varchar](500) NULL,
	[FileName] [varchar](250) NULL,
	[ExcelSheetName] [varchar](250) NULL,
	[UploadMode] [varchar](100) NULL,
	[Query] [text] NULL,
	[ConnectionString] [varchar](max) NULL,
	[IsSFTPEnable] [bit] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[ModifiedBy] [int] NOT NULL,
	[ModifiedOn] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[MappingTableID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_du_MappingTables_du_MappingExcelSheetDetails]') AND parent_object_id = OBJECT_ID(N'[dbo].[du_MappingTables]'))
ALTER TABLE [dbo].[du_MappingTables]  WITH CHECK ADD  CONSTRAINT [FK_du_MappingTables_du_MappingExcelSheetDetails] FOREIGN KEY([ExcelSheetDetailsID])
REFERENCES [dbo].[du_MappingExcelSheetDetails] ([ExcelSheetDetailsID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_du_MappingTables_du_MappingExcelSheetDetails]') AND parent_object_id = OBJECT_ID(N'[dbo].[du_MappingTables]'))
ALTER TABLE [dbo].[du_MappingTables] CHECK CONSTRAINT [FK_du_MappingTables_du_MappingExcelSheetDetails]
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF__du_Mappin__IsSFT__7E5885DE]') AND parent_object_id = OBJECT_ID(N'[dbo].[du_MappingTables]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__du_Mappin__IsSFT__7E5885DE]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[du_MappingTables] ADD  DEFAULT ((0)) FOR [IsSFTPEnable]
END


End
GO
