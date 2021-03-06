/****** Object:  Table [dbo].[du_MappingValues]    Script Date: 06/07/2016 12:05:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[du_MappingValues]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[du_MappingValues](
	[MappingValueID] [int] IDENTITY(1,1) NOT NULL,
	[MappingFieldID] [int] NOT NULL,
	[ActualValueName] [varchar](50) NOT NULL,
	[DisplayValueName] [varchar](50) NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[ModifiedBy] [int] NOT NULL,
	[ModifiedOn] [datetime] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[MappingValueID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_du_MappingValues_du_MappingFields]') AND parent_object_id = OBJECT_ID(N'[dbo].[du_MappingValues]'))
ALTER TABLE [dbo].[du_MappingValues]  WITH CHECK ADD  CONSTRAINT [FK_du_MappingValues_du_MappingFields] FOREIGN KEY([MappingFieldID])
REFERENCES [dbo].[du_MappingFields] ([MappingFieldID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_du_MappingValues_du_MappingFields]') AND parent_object_id = OBJECT_ID(N'[dbo].[du_MappingValues]'))
ALTER TABLE [dbo].[du_MappingValues] CHECK CONSTRAINT [FK_du_MappingValues_du_MappingFields]
GO
