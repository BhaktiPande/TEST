/****** Object:  Table [dbo].[usr_DelegationMaster]    Script Date: 06/07/2016 12:05:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usr_DelegationMaster]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[usr_DelegationMaster](
	[DelegationId] [bigint] IDENTITY(1,1) NOT NULL,
	[DelegationFrom] [datetime] NOT NULL,
	[DelegationTo] [datetime] NOT NULL,
	[UserInfoIdFrom] [int] NOT NULL,
	[UserInfoIdTo] [int] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[ModifiedBy] [int] NOT NULL,
	[ModifiedOn] [datetime] NOT NULL,
 CONSTRAINT [PK_usr_DelegationMaster] PRIMARY KEY CLUSTERED 
(
	[DelegationId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_usr_DelegationMaster_usr_UserInfo_CreatedBy]') AND parent_object_id = OBJECT_ID(N'[dbo].[usr_DelegationMaster]'))
ALTER TABLE [dbo].[usr_DelegationMaster]  WITH CHECK ADD  CONSTRAINT [FK_usr_DelegationMaster_usr_UserInfo_CreatedBy] FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[usr_UserInfo] ([UserInfoId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_usr_DelegationMaster_usr_UserInfo_CreatedBy]') AND parent_object_id = OBJECT_ID(N'[dbo].[usr_DelegationMaster]'))
ALTER TABLE [dbo].[usr_DelegationMaster] CHECK CONSTRAINT [FK_usr_DelegationMaster_usr_UserInfo_CreatedBy]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_usr_DelegationMaster_usr_UserInfo_ModifiedBy]') AND parent_object_id = OBJECT_ID(N'[dbo].[usr_DelegationMaster]'))
ALTER TABLE [dbo].[usr_DelegationMaster]  WITH CHECK ADD  CONSTRAINT [FK_usr_DelegationMaster_usr_UserInfo_ModifiedBy] FOREIGN KEY([ModifiedBy])
REFERENCES [dbo].[usr_UserInfo] ([UserInfoId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_usr_DelegationMaster_usr_UserInfo_ModifiedBy]') AND parent_object_id = OBJECT_ID(N'[dbo].[usr_DelegationMaster]'))
ALTER TABLE [dbo].[usr_DelegationMaster] CHECK CONSTRAINT [FK_usr_DelegationMaster_usr_UserInfo_ModifiedBy]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_usr_DelegationMaster_usr_UserInfo_UserInfoIdFrom]') AND parent_object_id = OBJECT_ID(N'[dbo].[usr_DelegationMaster]'))
ALTER TABLE [dbo].[usr_DelegationMaster]  WITH CHECK ADD  CONSTRAINT [FK_usr_DelegationMaster_usr_UserInfo_UserInfoIdFrom] FOREIGN KEY([UserInfoIdFrom])
REFERENCES [dbo].[usr_UserInfo] ([UserInfoId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_usr_DelegationMaster_usr_UserInfo_UserInfoIdFrom]') AND parent_object_id = OBJECT_ID(N'[dbo].[usr_DelegationMaster]'))
ALTER TABLE [dbo].[usr_DelegationMaster] CHECK CONSTRAINT [FK_usr_DelegationMaster_usr_UserInfo_UserInfoIdFrom]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_usr_DelegationMaster_usr_UserInfo_UserInfoIdTo]') AND parent_object_id = OBJECT_ID(N'[dbo].[usr_DelegationMaster]'))
ALTER TABLE [dbo].[usr_DelegationMaster]  WITH CHECK ADD  CONSTRAINT [FK_usr_DelegationMaster_usr_UserInfo_UserInfoIdTo] FOREIGN KEY([UserInfoIdTo])
REFERENCES [dbo].[usr_UserInfo] ([UserInfoId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_usr_DelegationMaster_usr_UserInfo_UserInfoIdTo]') AND parent_object_id = OBJECT_ID(N'[dbo].[usr_DelegationMaster]'))
ALTER TABLE [dbo].[usr_DelegationMaster] CHECK CONSTRAINT [FK_usr_DelegationMaster_usr_UserInfo_UserInfoIdTo]
GO
