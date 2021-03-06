/****** Object:  Table [dbo].[usr_Activity]    Script Date: 06/07/2016 12:05:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usr_Activity]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[usr_Activity](
	[ActivityID] [int] NOT NULL,
	[ScreenName] [nvarchar](100) NOT NULL,
	[ActivityName] [nvarchar](100) NOT NULL,
	[ModuleCodeID] [int] NOT NULL,
	[ControlName] [nvarchar](100) NULL,
	[Description] [nvarchar](512) NULL,
	[StatusCodeID] [int] NOT NULL,
	[DisplayOrder] [varchar](9) NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[ModifiedBy] [int] NOT NULL,
	[ModifiedOn] [datetime] NOT NULL,
 CONSTRAINT [PK_usr_Activity] PRIMARY KEY CLUSTERED 
(
	[ActivityID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'usr_Activity', N'COLUMN',N'DisplayOrder'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Display order used while assigning activities against role or delegation. First 3 characters for Module, next 3 for Screen, next 3 for activity' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'usr_Activity', @level2type=N'COLUMN',@level2name=N'DisplayOrder'
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_usr_Activity_com_Code_ObjectType]') AND parent_object_id = OBJECT_ID(N'[dbo].[usr_Activity]'))
ALTER TABLE [dbo].[usr_Activity]  WITH CHECK ADD  CONSTRAINT [FK_usr_Activity_com_Code_ObjectType] FOREIGN KEY([ModuleCodeID])
REFERENCES [dbo].[com_Code] ([CodeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_usr_Activity_com_Code_ObjectType]') AND parent_object_id = OBJECT_ID(N'[dbo].[usr_Activity]'))
ALTER TABLE [dbo].[usr_Activity] CHECK CONSTRAINT [FK_usr_Activity_com_Code_ObjectType]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_usr_Activity_com_Code_Status]') AND parent_object_id = OBJECT_ID(N'[dbo].[usr_Activity]'))
ALTER TABLE [dbo].[usr_Activity]  WITH CHECK ADD  CONSTRAINT [FK_usr_Activity_com_Code_Status] FOREIGN KEY([StatusCodeID])
REFERENCES [dbo].[com_Code] ([CodeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_usr_Activity_com_Code_Status]') AND parent_object_id = OBJECT_ID(N'[dbo].[usr_Activity]'))
ALTER TABLE [dbo].[usr_Activity] CHECK CONSTRAINT [FK_usr_Activity_com_Code_Status]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_usr_Activity_usr_UserInfo_CreatedBy]') AND parent_object_id = OBJECT_ID(N'[dbo].[usr_Activity]'))
ALTER TABLE [dbo].[usr_Activity]  WITH CHECK ADD  CONSTRAINT [FK_usr_Activity_usr_UserInfo_CreatedBy] FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[usr_UserInfo] ([UserInfoId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_usr_Activity_usr_UserInfo_CreatedBy]') AND parent_object_id = OBJECT_ID(N'[dbo].[usr_Activity]'))
ALTER TABLE [dbo].[usr_Activity] CHECK CONSTRAINT [FK_usr_Activity_usr_UserInfo_CreatedBy]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_usr_Activity_usr_UserInfo_ModifiedBy]') AND parent_object_id = OBJECT_ID(N'[dbo].[usr_Activity]'))
ALTER TABLE [dbo].[usr_Activity]  WITH CHECK ADD  CONSTRAINT [FK_usr_Activity_usr_UserInfo_ModifiedBy] FOREIGN KEY([ModifiedBy])
REFERENCES [dbo].[usr_UserInfo] ([UserInfoId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_usr_Activity_usr_UserInfo_ModifiedBy]') AND parent_object_id = OBJECT_ID(N'[dbo].[usr_Activity]'))
ALTER TABLE [dbo].[usr_Activity] CHECK CONSTRAINT [FK_usr_Activity_usr_UserInfo_ModifiedBy]
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_usr_Activity_DisplayOrder]') AND parent_object_id = OBJECT_ID(N'[dbo].[usr_Activity]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_usr_Activity_DisplayOrder]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[usr_Activity] ADD  CONSTRAINT [DF_usr_Activity_DisplayOrder]  DEFAULT ('') FOR [DisplayOrder]
END


End
GO
