/****** Object:  Table [dbo].[com_CodeGroup]    Script Date: 06/07/2016 12:05:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[com_CodeGroup]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[com_CodeGroup](
	[CodeGroupID] [int] NOT NULL,
	[COdeGroupName] [nvarchar](512) NOT NULL,
	[Description] [nvarchar](1024) NULL,
	[IsVisible] [bit] NOT NULL,
	[IsEditable] [bit] NOT NULL,
	[ParentCodeGroupId] [int] NULL,
 CONSTRAINT [PK_com_CodeGroup] PRIMARY KEY CLUSTERED 
(
	[CodeGroupID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_com_CodeGroup_com_CodeGroup_ParentCodeGroupId]') AND parent_object_id = OBJECT_ID(N'[dbo].[com_CodeGroup]'))
ALTER TABLE [dbo].[com_CodeGroup]  WITH CHECK ADD  CONSTRAINT [FK_com_CodeGroup_com_CodeGroup_ParentCodeGroupId] FOREIGN KEY([ParentCodeGroupId])
REFERENCES [dbo].[com_CodeGroup] ([CodeGroupID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_com_CodeGroup_com_CodeGroup_ParentCodeGroupId]') AND parent_object_id = OBJECT_ID(N'[dbo].[com_CodeGroup]'))
ALTER TABLE [dbo].[com_CodeGroup] CHECK CONSTRAINT [FK_com_CodeGroup_com_CodeGroup_ParentCodeGroupId]
GO
