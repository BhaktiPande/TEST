/****** Object:  Table [dbo].[usr_RoleMaster]    Script Date: 06/07/2016 12:05:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usr_RoleMaster]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[usr_RoleMaster](
	[RoleId] [int] IDENTITY(1,1) NOT NULL,
	[RoleName] [nvarchar](100) NOT NULL,
	[Description] [nvarchar](255) NULL,
	[StatusCodeId] [int] NOT NULL,
	[LandingPageURL] [nvarchar](255) NULL,
	[UserTypeCodeId] [int] NOT NULL,
	[IsDefault] [int] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[ModifiedBy] [int] NOT NULL,
	[ModifiedOn] [datetime] NOT NULL,
 CONSTRAINT [PK_usr_RoleMaster] PRIMARY KEY CLUSTERED 
(
	[RoleId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_usr_RoleMaster_com_Code_Status]') AND parent_object_id = OBJECT_ID(N'[dbo].[usr_RoleMaster]'))
ALTER TABLE [dbo].[usr_RoleMaster]  WITH CHECK ADD  CONSTRAINT [FK_usr_RoleMaster_com_Code_Status] FOREIGN KEY([StatusCodeId])
REFERENCES [dbo].[com_Code] ([CodeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_usr_RoleMaster_com_Code_Status]') AND parent_object_id = OBJECT_ID(N'[dbo].[usr_RoleMaster]'))
ALTER TABLE [dbo].[usr_RoleMaster] CHECK CONSTRAINT [FK_usr_RoleMaster_com_Code_Status]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_usr_RoleMaster_com_Code_UserTypeCodeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[usr_RoleMaster]'))
ALTER TABLE [dbo].[usr_RoleMaster]  WITH CHECK ADD  CONSTRAINT [FK_usr_RoleMaster_com_Code_UserTypeCodeId] FOREIGN KEY([UserTypeCodeId])
REFERENCES [dbo].[com_Code] ([CodeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_usr_RoleMaster_com_Code_UserTypeCodeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[usr_RoleMaster]'))
ALTER TABLE [dbo].[usr_RoleMaster] CHECK CONSTRAINT [FK_usr_RoleMaster_com_Code_UserTypeCodeId]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_usr_RoleMaster_usr_UserInfo_Createdy]') AND parent_object_id = OBJECT_ID(N'[dbo].[usr_RoleMaster]'))
ALTER TABLE [dbo].[usr_RoleMaster]  WITH CHECK ADD  CONSTRAINT [FK_usr_RoleMaster_usr_UserInfo_Createdy] FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[usr_UserInfo] ([UserInfoId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_usr_RoleMaster_usr_UserInfo_Createdy]') AND parent_object_id = OBJECT_ID(N'[dbo].[usr_RoleMaster]'))
ALTER TABLE [dbo].[usr_RoleMaster] CHECK CONSTRAINT [FK_usr_RoleMaster_usr_UserInfo_Createdy]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_usr_RoleMaster_usr_UserInfo_ModifiedBy]') AND parent_object_id = OBJECT_ID(N'[dbo].[usr_RoleMaster]'))
ALTER TABLE [dbo].[usr_RoleMaster]  WITH CHECK ADD  CONSTRAINT [FK_usr_RoleMaster_usr_UserInfo_ModifiedBy] FOREIGN KEY([ModifiedBy])
REFERENCES [dbo].[usr_UserInfo] ([UserInfoId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_usr_RoleMaster_usr_UserInfo_ModifiedBy]') AND parent_object_id = OBJECT_ID(N'[dbo].[usr_RoleMaster]'))
ALTER TABLE [dbo].[usr_RoleMaster] CHECK CONSTRAINT [FK_usr_RoleMaster_usr_UserInfo_ModifiedBy]
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_usr_RoleMaster_UserTypeCodeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[usr_RoleMaster]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_usr_RoleMaster_UserTypeCodeId]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[usr_RoleMaster] ADD  CONSTRAINT [DF_usr_RoleMaster_UserTypeCodeId]  DEFAULT ((101001)) FOR [UserTypeCodeId]
END


End
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_usr_RoleMaster_IsDefault]') AND parent_object_id = OBJECT_ID(N'[dbo].[usr_RoleMaster]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_usr_RoleMaster_IsDefault]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[usr_RoleMaster] ADD  CONSTRAINT [DF_usr_RoleMaster_IsDefault]  DEFAULT ((0)) FOR [IsDefault]
END


End
GO
