/****** Object:  Table [dbo].[tra_CoDashboardCount]    Script Date: 06/07/2016 12:05:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tra_CoDashboardCount]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tra_CoDashboardCount](
	[DashboardCountId] [int] NOT NULL,
	[ResourceKey] [varchar](15) NOT NULL,
	[FieldName] [nvarchar](500) NOT NULL,
	[Count] [int] NOT NULL,
	[Status] [bit] NOT NULL,
	[ModifiedBy] [int] NOT NULL,
	[ModifiedOn] [datetime] NOT NULL,
 CONSTRAINT [PK_tra_CoDashboardCount] PRIMARY KEY CLUSTERED 
(
	[DashboardCountId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'tra_CoDashboardCount', N'COLUMN',N'Status'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'1: Seen
0: Unseen' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tra_CoDashboardCount', @level2type=N'COLUMN',@level2name=N'Status'
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tra_CoDashboardCount_mst_Resource_ModifiedBy]') AND parent_object_id = OBJECT_ID(N'[dbo].[tra_CoDashboardCount]'))
ALTER TABLE [dbo].[tra_CoDashboardCount]  WITH CHECK ADD  CONSTRAINT [FK_tra_CoDashboardCount_mst_Resource_ModifiedBy] FOREIGN KEY([ModifiedBy])
REFERENCES [dbo].[usr_UserInfo] ([UserInfoId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tra_CoDashboardCount_mst_Resource_ModifiedBy]') AND parent_object_id = OBJECT_ID(N'[dbo].[tra_CoDashboardCount]'))
ALTER TABLE [dbo].[tra_CoDashboardCount] CHECK CONSTRAINT [FK_tra_CoDashboardCount_mst_Resource_ModifiedBy]
GO
