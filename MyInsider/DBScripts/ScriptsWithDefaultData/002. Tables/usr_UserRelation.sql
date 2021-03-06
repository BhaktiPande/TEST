/****** Object:  Table [dbo].[usr_UserRelation]    Script Date: 06/07/2016 12:05:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usr_UserRelation]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[usr_UserRelation](
	[UserRelationId] [bigint] IDENTITY(1,1) NOT NULL,
	[UserInfoId] [int] NOT NULL,
	[UserInfoIdRelative] [int] NOT NULL,
	[RelationTypeCodeId] [int] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[ModifiedBy] [int] NOT NULL,
	[ModifiedOn] [datetime] NOT NULL,
 CONSTRAINT [PK_usr_UserRelation] PRIMARY KEY CLUSTERED 
(
	[UserRelationId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'usr_UserRelation', N'COLUMN',N'UserInfoId'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Id of the employee for which relative''s information is to be added.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'usr_UserRelation', @level2type=N'COLUMN',@level2name=N'UserInfoId'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'usr_UserRelation', N'COLUMN',N'UserInfoIdRelative'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Id of the relative to be associated with UserInfoId with relationship set in RelationTypeCodeId' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'usr_UserRelation', @level2type=N'COLUMN',@level2name=N'UserInfoIdRelative'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'usr_UserRelation', N'COLUMN',N'RelationTypeCodeId'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Refers codegroupId = 100' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'usr_UserRelation', @level2type=N'COLUMN',@level2name=N'RelationTypeCodeId'
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_usr_UserRelation_com_Code_relationTypeCodeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[usr_UserRelation]'))
ALTER TABLE [dbo].[usr_UserRelation]  WITH CHECK ADD  CONSTRAINT [FK_usr_UserRelation_com_Code_relationTypeCodeId] FOREIGN KEY([RelationTypeCodeId])
REFERENCES [dbo].[com_Code] ([CodeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_usr_UserRelation_com_Code_relationTypeCodeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[usr_UserRelation]'))
ALTER TABLE [dbo].[usr_UserRelation] CHECK CONSTRAINT [FK_usr_UserRelation_com_Code_relationTypeCodeId]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_usr_UserRelation_usr_UserInfo_CreatedBy]') AND parent_object_id = OBJECT_ID(N'[dbo].[usr_UserRelation]'))
ALTER TABLE [dbo].[usr_UserRelation]  WITH CHECK ADD  CONSTRAINT [FK_usr_UserRelation_usr_UserInfo_CreatedBy] FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[usr_UserInfo] ([UserInfoId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_usr_UserRelation_usr_UserInfo_CreatedBy]') AND parent_object_id = OBJECT_ID(N'[dbo].[usr_UserRelation]'))
ALTER TABLE [dbo].[usr_UserRelation] CHECK CONSTRAINT [FK_usr_UserRelation_usr_UserInfo_CreatedBy]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_usr_UserRelation_usr_UserInfo_ModifiedBy]') AND parent_object_id = OBJECT_ID(N'[dbo].[usr_UserRelation]'))
ALTER TABLE [dbo].[usr_UserRelation]  WITH CHECK ADD  CONSTRAINT [FK_usr_UserRelation_usr_UserInfo_ModifiedBy] FOREIGN KEY([ModifiedBy])
REFERENCES [dbo].[usr_UserInfo] ([UserInfoId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_usr_UserRelation_usr_UserInfo_ModifiedBy]') AND parent_object_id = OBJECT_ID(N'[dbo].[usr_UserRelation]'))
ALTER TABLE [dbo].[usr_UserRelation] CHECK CONSTRAINT [FK_usr_UserRelation_usr_UserInfo_ModifiedBy]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_usr_UserRelation_usr_UserInfo_UserInfoId]') AND parent_object_id = OBJECT_ID(N'[dbo].[usr_UserRelation]'))
ALTER TABLE [dbo].[usr_UserRelation]  WITH CHECK ADD  CONSTRAINT [FK_usr_UserRelation_usr_UserInfo_UserInfoId] FOREIGN KEY([UserInfoId])
REFERENCES [dbo].[usr_UserInfo] ([UserInfoId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_usr_UserRelation_usr_UserInfo_UserInfoId]') AND parent_object_id = OBJECT_ID(N'[dbo].[usr_UserRelation]'))
ALTER TABLE [dbo].[usr_UserRelation] CHECK CONSTRAINT [FK_usr_UserRelation_usr_UserInfo_UserInfoId]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_usr_UserRelation_usr_UserInfo_UserInfoIdRelative]') AND parent_object_id = OBJECT_ID(N'[dbo].[usr_UserRelation]'))
ALTER TABLE [dbo].[usr_UserRelation]  WITH CHECK ADD  CONSTRAINT [FK_usr_UserRelation_usr_UserInfo_UserInfoIdRelative] FOREIGN KEY([UserInfoIdRelative])
REFERENCES [dbo].[usr_UserInfo] ([UserInfoId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_usr_UserRelation_usr_UserInfo_UserInfoIdRelative]') AND parent_object_id = OBJECT_ID(N'[dbo].[usr_UserRelation]'))
ALTER TABLE [dbo].[usr_UserRelation] CHECK CONSTRAINT [FK_usr_UserRelation_usr_UserInfo_UserInfoIdRelative]
GO
