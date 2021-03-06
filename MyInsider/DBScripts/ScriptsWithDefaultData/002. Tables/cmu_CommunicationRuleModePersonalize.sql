/****** Object:  Table [dbo].[cmu_CommunicationRuleModePersonalize]    Script Date: 06/07/2016 12:05:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[cmu_CommunicationRuleModePersonalize]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[cmu_CommunicationRuleModePersonalize](
	[RuleModePersonalizeId] [bigint] IDENTITY(1,1) NOT NULL,
	[RuleModeId] [int] NOT NULL,
	[UserId] [int] NOT NULL,
	[Subject] [nvarchar](150) NULL,
	[Contents] [nvarchar](4000) NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[ModifiedBy] [int] NOT NULL,
	[ModifiedOn] [datetime] NOT NULL,
 CONSTRAINT [PK_cmu_CommunicationRuleModePersonalize] PRIMARY KEY CLUSTERED 
(
	[RuleModePersonalizeId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'cmu_CommunicationRuleModePersonalize', N'COLUMN',N'RuleModeId'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Refers: cmu_CommunicationRuleModeMaster' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'cmu_CommunicationRuleModePersonalize', @level2type=N'COLUMN',@level2name=N'RuleModeId'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'cmu_CommunicationRuleModePersonalize', N'COLUMN',N'UserId'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Refers: usr_UserInfo' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'cmu_CommunicationRuleModePersonalize', @level2type=N'COLUMN',@level2name=N'UserId'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'cmu_CommunicationRuleModePersonalize', N'COLUMN',N'CreatedBy'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Refers: usr_UserInfo' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'cmu_CommunicationRuleModePersonalize', @level2type=N'COLUMN',@level2name=N'CreatedBy'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'cmu_CommunicationRuleModePersonalize', N'COLUMN',N'ModifiedBy'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Refers: usr_UserInfo' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'cmu_CommunicationRuleModePersonalize', @level2type=N'COLUMN',@level2name=N'ModifiedBy'
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_cmu_CommunicationRuleModePersonalize_cmu_CommunicationRuleModeMaster_RuleModeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[cmu_CommunicationRuleModePersonalize]'))
ALTER TABLE [dbo].[cmu_CommunicationRuleModePersonalize]  WITH CHECK ADD  CONSTRAINT [FK_cmu_CommunicationRuleModePersonalize_cmu_CommunicationRuleModeMaster_RuleModeId] FOREIGN KEY([RuleModeId])
REFERENCES [dbo].[cmu_CommunicationRuleModeMaster] ([RuleModeId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_cmu_CommunicationRuleModePersonalize_cmu_CommunicationRuleModeMaster_RuleModeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[cmu_CommunicationRuleModePersonalize]'))
ALTER TABLE [dbo].[cmu_CommunicationRuleModePersonalize] CHECK CONSTRAINT [FK_cmu_CommunicationRuleModePersonalize_cmu_CommunicationRuleModeMaster_RuleModeId]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_cmu_CommunicationRuleModePersonalize_usr_UserInfo_CreatedBy]') AND parent_object_id = OBJECT_ID(N'[dbo].[cmu_CommunicationRuleModePersonalize]'))
ALTER TABLE [dbo].[cmu_CommunicationRuleModePersonalize]  WITH CHECK ADD  CONSTRAINT [FK_cmu_CommunicationRuleModePersonalize_usr_UserInfo_CreatedBy] FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[usr_UserInfo] ([UserInfoId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_cmu_CommunicationRuleModePersonalize_usr_UserInfo_CreatedBy]') AND parent_object_id = OBJECT_ID(N'[dbo].[cmu_CommunicationRuleModePersonalize]'))
ALTER TABLE [dbo].[cmu_CommunicationRuleModePersonalize] CHECK CONSTRAINT [FK_cmu_CommunicationRuleModePersonalize_usr_UserInfo_CreatedBy]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_cmu_CommunicationRuleModePersonalize_usr_UserInfo_ModifiedBy]') AND parent_object_id = OBJECT_ID(N'[dbo].[cmu_CommunicationRuleModePersonalize]'))
ALTER TABLE [dbo].[cmu_CommunicationRuleModePersonalize]  WITH CHECK ADD  CONSTRAINT [FK_cmu_CommunicationRuleModePersonalize_usr_UserInfo_ModifiedBy] FOREIGN KEY([ModifiedBy])
REFERENCES [dbo].[usr_UserInfo] ([UserInfoId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_cmu_CommunicationRuleModePersonalize_usr_UserInfo_ModifiedBy]') AND parent_object_id = OBJECT_ID(N'[dbo].[cmu_CommunicationRuleModePersonalize]'))
ALTER TABLE [dbo].[cmu_CommunicationRuleModePersonalize] CHECK CONSTRAINT [FK_cmu_CommunicationRuleModePersonalize_usr_UserInfo_ModifiedBy]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_cmu_CommunicationRuleModePersonalize_usr_UserInfo_UserId]') AND parent_object_id = OBJECT_ID(N'[dbo].[cmu_CommunicationRuleModePersonalize]'))
ALTER TABLE [dbo].[cmu_CommunicationRuleModePersonalize]  WITH CHECK ADD  CONSTRAINT [FK_cmu_CommunicationRuleModePersonalize_usr_UserInfo_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[usr_UserInfo] ([UserInfoId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_cmu_CommunicationRuleModePersonalize_usr_UserInfo_UserId]') AND parent_object_id = OBJECT_ID(N'[dbo].[cmu_CommunicationRuleModePersonalize]'))
ALTER TABLE [dbo].[cmu_CommunicationRuleModePersonalize] CHECK CONSTRAINT [FK_cmu_CommunicationRuleModePersonalize_usr_UserInfo_UserId]
GO
