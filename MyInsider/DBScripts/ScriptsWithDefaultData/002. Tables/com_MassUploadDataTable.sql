/****** Object:  Table [dbo].[com_MassUploadDataTable]    Script Date: 06/07/2016 12:05:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[com_MassUploadDataTable]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[com_MassUploadDataTable](
	[MassUploadDataTableId] [int] NOT NULL,
	[MassUploadDataTableName] [varchar](200) NOT NULL,
 CONSTRAINT [PK_com_MassUploadDataTable] PRIMARY KEY CLUSTERED 
(
	[MassUploadDataTableId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'com_MassUploadDataTable', NULL,NULL))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'This will have the different DataTables used in the Mass Upload' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'com_MassUploadDataTable'
GO
