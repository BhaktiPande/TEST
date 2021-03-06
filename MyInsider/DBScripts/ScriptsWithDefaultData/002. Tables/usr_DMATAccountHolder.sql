/****** Object:  Table [dbo].[usr_DMATAccountHolder]    Script Date: 06/07/2016 12:05:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usr_DMATAccountHolder]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[usr_DMATAccountHolder](
	[DMATAccountHolderId] [int] IDENTITY(1,1) NOT NULL,
	[DMATDetailsID] [int] NOT NULL,
	[AccountHolderName] [nvarchar](100) NOT NULL,
	[PAN] [nvarchar](50) NOT NULL,
	[RelationTypeCodeId] [int] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[ModifiedBy] [int] NOT NULL,
	[ModifiedOn] [datetime] NOT NULL,
 CONSTRAINT [PK_usr_DMATAccountHolder] PRIMARY KEY CLUSTERED 
(
	[DMATAccountHolderId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_usr_DMATAccountHolder_com_Code_RelationTypeCodeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[usr_DMATAccountHolder]'))
ALTER TABLE [dbo].[usr_DMATAccountHolder]  WITH CHECK ADD  CONSTRAINT [FK_usr_DMATAccountHolder_com_Code_RelationTypeCodeId] FOREIGN KEY([RelationTypeCodeId])
REFERENCES [dbo].[com_Code] ([CodeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_usr_DMATAccountHolder_com_Code_RelationTypeCodeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[usr_DMATAccountHolder]'))
ALTER TABLE [dbo].[usr_DMATAccountHolder] CHECK CONSTRAINT [FK_usr_DMATAccountHolder_com_Code_RelationTypeCodeId]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_usr_DMATAccountHolder_usr_DMATDetails_DMATDetailsId]') AND parent_object_id = OBJECT_ID(N'[dbo].[usr_DMATAccountHolder]'))
ALTER TABLE [dbo].[usr_DMATAccountHolder]  WITH CHECK ADD  CONSTRAINT [FK_usr_DMATAccountHolder_usr_DMATDetails_DMATDetailsId] FOREIGN KEY([DMATDetailsID])
REFERENCES [dbo].[usr_DMATDetails] ([DMATDetailsID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_usr_DMATAccountHolder_usr_DMATDetails_DMATDetailsId]') AND parent_object_id = OBJECT_ID(N'[dbo].[usr_DMATAccountHolder]'))
ALTER TABLE [dbo].[usr_DMATAccountHolder] CHECK CONSTRAINT [FK_usr_DMATAccountHolder_usr_DMATDetails_DMATDetailsId]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_usr_DMATAccountHolder_usr_UserInfo_CreatedBy]') AND parent_object_id = OBJECT_ID(N'[dbo].[usr_DMATAccountHolder]'))
ALTER TABLE [dbo].[usr_DMATAccountHolder]  WITH CHECK ADD  CONSTRAINT [FK_usr_DMATAccountHolder_usr_UserInfo_CreatedBy] FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[usr_UserInfo] ([UserInfoId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_usr_DMATAccountHolder_usr_UserInfo_CreatedBy]') AND parent_object_id = OBJECT_ID(N'[dbo].[usr_DMATAccountHolder]'))
ALTER TABLE [dbo].[usr_DMATAccountHolder] CHECK CONSTRAINT [FK_usr_DMATAccountHolder_usr_UserInfo_CreatedBy]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_usr_DMATAccountHolder_usr_UserInfo_ModifiedBy]') AND parent_object_id = OBJECT_ID(N'[dbo].[usr_DMATAccountHolder]'))
ALTER TABLE [dbo].[usr_DMATAccountHolder]  WITH CHECK ADD  CONSTRAINT [FK_usr_DMATAccountHolder_usr_UserInfo_ModifiedBy] FOREIGN KEY([ModifiedBy])
REFERENCES [dbo].[usr_UserInfo] ([UserInfoId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_usr_DMATAccountHolder_usr_UserInfo_ModifiedBy]') AND parent_object_id = OBJECT_ID(N'[dbo].[usr_DMATAccountHolder]'))
ALTER TABLE [dbo].[usr_DMATAccountHolder] CHECK CONSTRAINT [FK_usr_DMATAccountHolder_usr_UserInfo_ModifiedBy]
GO
