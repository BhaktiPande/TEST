/****** Object:  Table [dbo].[com_CompanyPaidUpAndSubscribedShareCapital]    Script Date: 06/07/2016 12:05:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[com_CompanyPaidUpAndSubscribedShareCapital]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[com_CompanyPaidUpAndSubscribedShareCapital](
	[CompanyPaidUpAndSubscribedShareCapitalID] [int] IDENTITY(1,1) NOT NULL,
	[PaidUpAndSubscribedShareCapitalDate] [datetime] NOT NULL,
	[PaidUpShare] [decimal](20, 5) NOT NULL,
	[CompanyID] [int] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[ModifiedBy] [int] NOT NULL,
	[ModifiedOn] [datetime] NOT NULL,
 CONSTRAINT [PK_com_CompanyPaidUpAndSubscribedShareCapital] PRIMARY KEY CLUSTERED 
(
	[CompanyPaidUpAndSubscribedShareCapitalID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_com_CompanyPaidUpAndSubscribedShareCapital_mst_Company_CompanyId]') AND parent_object_id = OBJECT_ID(N'[dbo].[com_CompanyPaidUpAndSubscribedShareCapital]'))
ALTER TABLE [dbo].[com_CompanyPaidUpAndSubscribedShareCapital]  WITH CHECK ADD  CONSTRAINT [FK_com_CompanyPaidUpAndSubscribedShareCapital_mst_Company_CompanyId] FOREIGN KEY([CompanyID])
REFERENCES [dbo].[mst_Company] ([CompanyId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_com_CompanyPaidUpAndSubscribedShareCapital_mst_Company_CompanyId]') AND parent_object_id = OBJECT_ID(N'[dbo].[com_CompanyPaidUpAndSubscribedShareCapital]'))
ALTER TABLE [dbo].[com_CompanyPaidUpAndSubscribedShareCapital] CHECK CONSTRAINT [FK_com_CompanyPaidUpAndSubscribedShareCapital_mst_Company_CompanyId]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_com_CompanyPaidUpAndSubscribedShareCapital_usr_UserInfo_CreatedBy]') AND parent_object_id = OBJECT_ID(N'[dbo].[com_CompanyPaidUpAndSubscribedShareCapital]'))
ALTER TABLE [dbo].[com_CompanyPaidUpAndSubscribedShareCapital]  WITH CHECK ADD  CONSTRAINT [FK_com_CompanyPaidUpAndSubscribedShareCapital_usr_UserInfo_CreatedBy] FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[usr_UserInfo] ([UserInfoId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_com_CompanyPaidUpAndSubscribedShareCapital_usr_UserInfo_CreatedBy]') AND parent_object_id = OBJECT_ID(N'[dbo].[com_CompanyPaidUpAndSubscribedShareCapital]'))
ALTER TABLE [dbo].[com_CompanyPaidUpAndSubscribedShareCapital] CHECK CONSTRAINT [FK_com_CompanyPaidUpAndSubscribedShareCapital_usr_UserInfo_CreatedBy]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_com_CompanyPaidUpAndSubscribedShareCapital_usr_UserInfo_ModifiedBy]') AND parent_object_id = OBJECT_ID(N'[dbo].[com_CompanyPaidUpAndSubscribedShareCapital]'))
ALTER TABLE [dbo].[com_CompanyPaidUpAndSubscribedShareCapital]  WITH CHECK ADD  CONSTRAINT [FK_com_CompanyPaidUpAndSubscribedShareCapital_usr_UserInfo_ModifiedBy] FOREIGN KEY([ModifiedBy])
REFERENCES [dbo].[usr_UserInfo] ([UserInfoId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_com_CompanyPaidUpAndSubscribedShareCapital_usr_UserInfo_ModifiedBy]') AND parent_object_id = OBJECT_ID(N'[dbo].[com_CompanyPaidUpAndSubscribedShareCapital]'))
ALTER TABLE [dbo].[com_CompanyPaidUpAndSubscribedShareCapital] CHECK CONSTRAINT [FK_com_CompanyPaidUpAndSubscribedShareCapital_usr_UserInfo_ModifiedBy]
GO
