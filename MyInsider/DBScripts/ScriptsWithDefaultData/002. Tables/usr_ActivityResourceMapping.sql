/****** Object:  Table [dbo].[usr_ActivityResourceMapping]    Script Date: 06/07/2016 12:05:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usr_ActivityResourceMapping]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[usr_ActivityResourceMapping](
	[ActivityId] [int] NOT NULL,
	[ResourceKey] [varchar](15) NOT NULL,
	[ColumnName] [varchar](100) NOT NULL,
 CONSTRAINT [PK_usr_ActivityResourceMapping] PRIMARY KEY CLUSTERED 
(
	[ActivityId] ASC,
	[ResourceKey] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_usr_ActivityResourceMapping_usr_Activity_ActivityId]') AND parent_object_id = OBJECT_ID(N'[dbo].[usr_ActivityResourceMapping]'))
ALTER TABLE [dbo].[usr_ActivityResourceMapping]  WITH CHECK ADD  CONSTRAINT [FK_usr_ActivityResourceMapping_usr_Activity_ActivityId] FOREIGN KEY([ActivityId])
REFERENCES [dbo].[usr_Activity] ([ActivityID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_usr_ActivityResourceMapping_usr_Activity_ActivityId]') AND parent_object_id = OBJECT_ID(N'[dbo].[usr_ActivityResourceMapping]'))
ALTER TABLE [dbo].[usr_ActivityResourceMapping] CHECK CONSTRAINT [FK_usr_ActivityResourceMapping_usr_Activity_ActivityId]
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_usr_ActivityResourceMapping_ColumnName]') AND parent_object_id = OBJECT_ID(N'[dbo].[usr_ActivityResourceMapping]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_usr_ActivityResourceMapping_ColumnName]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[usr_ActivityResourceMapping] ADD  CONSTRAINT [DF_usr_ActivityResourceMapping_ColumnName]  DEFAULT ('') FOR [ColumnName]
END


End
GO
