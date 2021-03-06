/****** Object:  Table [dbo].[com_CompanyListingDetails]    Script Date: 06/07/2016 12:05:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[com_CompanyListingDetails]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[com_CompanyListingDetails](
	[CompanyListingDetailsID] [int] IDENTITY(1,1) NOT NULL,
	[StockExchangeID] [int] NOT NULL,
	[DateOfListingFrom] [datetime] NOT NULL,
	[DateOfListingTo] [datetime] NULL,
	[CompanyID] [int] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[ModifiedBy] [int] NOT NULL,
	[ModifiedOn] [datetime] NOT NULL,
 CONSTRAINT [PK_com_CompanyListingDetails] PRIMARY KEY CLUSTERED 
(
	[CompanyListingDetailsID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_com_CompanyListingDetails_com_Code_StockExchangeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[com_CompanyListingDetails]'))
ALTER TABLE [dbo].[com_CompanyListingDetails]  WITH CHECK ADD  CONSTRAINT [FK_com_CompanyListingDetails_com_Code_StockExchangeId] FOREIGN KEY([StockExchangeID])
REFERENCES [dbo].[com_Code] ([CodeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_com_CompanyListingDetails_com_Code_StockExchangeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[com_CompanyListingDetails]'))
ALTER TABLE [dbo].[com_CompanyListingDetails] CHECK CONSTRAINT [FK_com_CompanyListingDetails_com_Code_StockExchangeId]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_com_CompanyListingDetails_mst_Company_CompanyId]') AND parent_object_id = OBJECT_ID(N'[dbo].[com_CompanyListingDetails]'))
ALTER TABLE [dbo].[com_CompanyListingDetails]  WITH CHECK ADD  CONSTRAINT [FK_com_CompanyListingDetails_mst_Company_CompanyId] FOREIGN KEY([CompanyID])
REFERENCES [dbo].[mst_Company] ([CompanyId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_com_CompanyListingDetails_mst_Company_CompanyId]') AND parent_object_id = OBJECT_ID(N'[dbo].[com_CompanyListingDetails]'))
ALTER TABLE [dbo].[com_CompanyListingDetails] CHECK CONSTRAINT [FK_com_CompanyListingDetails_mst_Company_CompanyId]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_com_CompanyListingDetails_usr_UserInfo_CreatedBy]') AND parent_object_id = OBJECT_ID(N'[dbo].[com_CompanyListingDetails]'))
ALTER TABLE [dbo].[com_CompanyListingDetails]  WITH CHECK ADD  CONSTRAINT [FK_com_CompanyListingDetails_usr_UserInfo_CreatedBy] FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[usr_UserInfo] ([UserInfoId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_com_CompanyListingDetails_usr_UserInfo_CreatedBy]') AND parent_object_id = OBJECT_ID(N'[dbo].[com_CompanyListingDetails]'))
ALTER TABLE [dbo].[com_CompanyListingDetails] CHECK CONSTRAINT [FK_com_CompanyListingDetails_usr_UserInfo_CreatedBy]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_com_CompanyListingDetails_usr_UserInfo_ModifiedBy]') AND parent_object_id = OBJECT_ID(N'[dbo].[com_CompanyListingDetails]'))
ALTER TABLE [dbo].[com_CompanyListingDetails]  WITH CHECK ADD  CONSTRAINT [FK_com_CompanyListingDetails_usr_UserInfo_ModifiedBy] FOREIGN KEY([ModifiedBy])
REFERENCES [dbo].[usr_UserInfo] ([UserInfoId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_com_CompanyListingDetails_usr_UserInfo_ModifiedBy]') AND parent_object_id = OBJECT_ID(N'[dbo].[com_CompanyListingDetails]'))
ALTER TABLE [dbo].[com_CompanyListingDetails] CHECK CONSTRAINT [FK_com_CompanyListingDetails_usr_UserInfo_ModifiedBy]
GO
