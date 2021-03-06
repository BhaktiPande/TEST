/****** Object:  Table [dbo].[usr_DMATDetails]    Script Date: 06/07/2016 12:05:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usr_DMATDetails]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[usr_DMATDetails](
	[DMATDetailsID] [int] IDENTITY(1,1) NOT NULL,
	[UserInfoID] [int] NOT NULL,
	[DEMATAccountNumber] [nvarchar](50) NOT NULL,
	[DPBank] [nvarchar](200) NOT NULL,
	[DPID] [varchar](50) NOT NULL,
	[TMID] [varchar](50) NOT NULL,
	[Description] [nvarchar](200) NOT NULL,
	[AccountTypeCodeId] [int] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[ModifiedBy] [int] NOT NULL,
	[ModifiedOn] [datetime] NOT NULL,
 CONSTRAINT [PK_usr_DMATDetails] PRIMARY KEY CLUSTERED 
(
	[DMATDetailsID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'usr_DMATDetails', N'COLUMN',N'AccountTypeCodeId'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Refers code table 121001: Single, 121002: Joint' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'usr_DMATDetails', @level2type=N'COLUMN',@level2name=N'AccountTypeCodeId'
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_usr_DMATDetails_com_Code_AccountTypeCodeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[usr_DMATDetails]'))
ALTER TABLE [dbo].[usr_DMATDetails]  WITH CHECK ADD  CONSTRAINT [FK_usr_DMATDetails_com_Code_AccountTypeCodeId] FOREIGN KEY([AccountTypeCodeId])
REFERENCES [dbo].[com_Code] ([CodeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_usr_DMATDetails_com_Code_AccountTypeCodeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[usr_DMATDetails]'))
ALTER TABLE [dbo].[usr_DMATDetails] CHECK CONSTRAINT [FK_usr_DMATDetails_com_Code_AccountTypeCodeId]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_usr_DMATDetails_usr_UserInfo_CreatedBy]') AND parent_object_id = OBJECT_ID(N'[dbo].[usr_DMATDetails]'))
ALTER TABLE [dbo].[usr_DMATDetails]  WITH CHECK ADD  CONSTRAINT [FK_usr_DMATDetails_usr_UserInfo_CreatedBy] FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[usr_UserInfo] ([UserInfoId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_usr_DMATDetails_usr_UserInfo_CreatedBy]') AND parent_object_id = OBJECT_ID(N'[dbo].[usr_DMATDetails]'))
ALTER TABLE [dbo].[usr_DMATDetails] CHECK CONSTRAINT [FK_usr_DMATDetails_usr_UserInfo_CreatedBy]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_usr_DMATDetails_usr_UserInfo_ModifiedBy]') AND parent_object_id = OBJECT_ID(N'[dbo].[usr_DMATDetails]'))
ALTER TABLE [dbo].[usr_DMATDetails]  WITH CHECK ADD  CONSTRAINT [FK_usr_DMATDetails_usr_UserInfo_ModifiedBy] FOREIGN KEY([ModifiedBy])
REFERENCES [dbo].[usr_UserInfo] ([UserInfoId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_usr_DMATDetails_usr_UserInfo_ModifiedBy]') AND parent_object_id = OBJECT_ID(N'[dbo].[usr_DMATDetails]'))
ALTER TABLE [dbo].[usr_DMATDetails] CHECK CONSTRAINT [FK_usr_DMATDetails_usr_UserInfo_ModifiedBy]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_usr_DMATDetails_usr_UserInfo_UserInfoID]') AND parent_object_id = OBJECT_ID(N'[dbo].[usr_DMATDetails]'))
ALTER TABLE [dbo].[usr_DMATDetails]  WITH CHECK ADD  CONSTRAINT [FK_usr_DMATDetails_usr_UserInfo_UserInfoID] FOREIGN KEY([UserInfoID])
REFERENCES [dbo].[usr_UserInfo] ([UserInfoId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_usr_DMATDetails_usr_UserInfo_UserInfoID]') AND parent_object_id = OBJECT_ID(N'[dbo].[usr_DMATDetails]'))
ALTER TABLE [dbo].[usr_DMATDetails] CHECK CONSTRAINT [FK_usr_DMATDetails_usr_UserInfo_UserInfoID]
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_usr_DMATDetails_AccountTypeCodeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[usr_DMATDetails]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_usr_DMATDetails_AccountTypeCodeId]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[usr_DMATDetails] ADD  CONSTRAINT [DF_usr_DMATDetails_AccountTypeCodeId]  DEFAULT ((121001)) FOR [AccountTypeCodeId]
END


End
GO
