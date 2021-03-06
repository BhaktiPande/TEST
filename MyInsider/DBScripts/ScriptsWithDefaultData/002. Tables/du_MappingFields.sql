/****** Object:  Table [dbo].[du_MappingFields]    Script Date: 06/07/2016 12:05:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[du_MappingFields]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[du_MappingFields](
	[MappingFieldID] [int] IDENTITY(1,1) NOT NULL,
	[MappingTableID] [int] NOT NULL,
	[ActualFieldName] [varchar](50) NOT NULL,
	[ActualFieldIsRequired] [bit] NOT NULL,
	[ActualFieldDataType] [varchar](50) NOT NULL,
	[DisplayFieldName] [varchar](50) NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[ModifiedBy] [int] NOT NULL,
	[ModifiedOn] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[MappingFieldID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_du_MappingFields_du_MappingTables]') AND parent_object_id = OBJECT_ID(N'[dbo].[du_MappingFields]'))
ALTER TABLE [dbo].[du_MappingFields]  WITH CHECK ADD  CONSTRAINT [FK_du_MappingFields_du_MappingTables] FOREIGN KEY([MappingTableID])
REFERENCES [dbo].[du_MappingTables] ([MappingTableID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_du_MappingFields_du_MappingTables]') AND parent_object_id = OBJECT_ID(N'[dbo].[du_MappingFields]'))
ALTER TABLE [dbo].[du_MappingFields] CHECK CONSTRAINT [FK_du_MappingFields_du_MappingTables]
GO
