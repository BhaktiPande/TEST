
GO

/****** Object:  Table [dbo].[tra_TransactionDetails_OS]    Script Date: 02/08/2019 20:37:31 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tra_TransactionDetails_OS](
	[TransactionDetailsId] [bigint] IDENTITY(1,1) NOT NULL,
	[TransactionMasterId] [bigint] NULL,
	[ForUserInfoId] [int] NOT NULL,
	[SecurityTypeCodeId] [int] NULL,
	[ModeOfAcquisitionCodeId] [int] NULL,
	[DMATDetailsID] [int] NULL,
	[CompanyId] [int] NULL,
	[ExchangeCodeId] [int] NULL,
	[TransactionTypeCodeId] [int] NOT NULL,
	[Quantity] [decimal](10, 0) NULL,
	[Value] [decimal](10, 0) NULL,
	[DateOfAcquisition] [datetime] NOT NULL,
	[DateOfInitimationToCompany] [datetime] NOT NULL,
	[LotSize] [int] NOT NULL,
	[ContractSpecification] [varchar](50) NULL,
	[CreatedBy] [int] NULL,
	[CreatedOn] [datetime] NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedOn] [datetime] NULL,
 CONSTRAINT [PK_tra_TransactionDetails_OS] PRIMARY KEY CLUSTERED 
(
	[TransactionDetailsId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

/****** Object:  ForeignKey [FK_tra_TransactionDetails_OS_com_Code_ExchangeCodeId]    Script Date: 02/06/2019 19:41:41 ******/
ALTER TABLE [dbo].[tra_TransactionDetails_OS]  WITH CHECK ADD  CONSTRAINT [FK_tra_TransactionDetails_OS_com_Code_ExchangeCodeId] FOREIGN KEY([ExchangeCodeId])
REFERENCES [dbo].[com_Code] ([CodeID])
GO
ALTER TABLE [dbo].[tra_TransactionDetails_OS] CHECK CONSTRAINT [FK_tra_TransactionDetails_OS_com_Code_ExchangeCodeId]
GO

/****** Object:  ForeignKey [FK_tra_TransactionDetails_OS_com_Code_ModeOfAcquisitionCodeId]    Script Date: 02/06/2019 19:41:41 ******/
ALTER TABLE [dbo].[tra_TransactionDetails_OS]  WITH CHECK ADD  CONSTRAINT [FK_tra_TransactionDetails_OS_com_Code_ModeOfAcquisitionCodeId] FOREIGN KEY([ModeOfAcquisitionCodeId])
REFERENCES [dbo].[com_Code] ([CodeID])
GO
ALTER TABLE [dbo].[tra_TransactionDetails_OS] CHECK CONSTRAINT [FK_tra_TransactionDetails_OS_com_Code_ModeOfAcquisitionCodeId]
GO

/****** Object:  ForeignKey [FK_tra_TransactionDetails_OS_com_Code_SecurityTypeCodeId]    Script Date: 02/06/2019 19:41:41 ******/
ALTER TABLE [dbo].[tra_TransactionDetails_OS]  WITH CHECK ADD  CONSTRAINT [FK_tra_TransactionDetails_OS_com_Code_SecurityTypeCodeId] FOREIGN KEY([SecurityTypeCodeId])
REFERENCES [dbo].[com_Code] ([CodeID])
GO
ALTER TABLE [dbo].[tra_TransactionDetails_OS] CHECK CONSTRAINT [FK_tra_TransactionDetails_OS_com_Code_SecurityTypeCodeId]
GO

/****** Object:  ForeignKey [FK_tra_TransactionDetails_OS_CompanyId_rl_CompanyMasterList_RlCompanyId]    Script Date: 02/06/2019 19:41:41 ******/
ALTER TABLE [dbo].[tra_TransactionDetails_OS]  WITH CHECK ADD  CONSTRAINT [FK_tra_TransactionDetails_OS_CompanyId_rl_CompanyMasterList_RlCompanyId] FOREIGN KEY([CompanyId])
REFERENCES [dbo].[rl_CompanyMasterList] ([RlCompanyId])
GO
ALTER TABLE [dbo].[tra_TransactionDetails_OS] CHECK CONSTRAINT [FK_tra_TransactionDetails_OS_CompanyId_rl_CompanyMasterList_RlCompanyId]
GO

/****** Object:  ForeignKey [FK_tra_TransactionDetails_OS_TransactionMasterId_tra_TransactionMaster_OS_TransactionMasterId]    Script Date: 02/06/2019 19:41:41 ******/
ALTER TABLE [dbo].[tra_TransactionDetails_OS]  WITH CHECK ADD  CONSTRAINT [FK_tra_TransactionDetails_OS_tra_TransactionMaster_OS] FOREIGN KEY([TransactionMasterId])
REFERENCES [dbo].[tra_TransactionMaster_OS] ([TransactionMasterId])
GO
ALTER TABLE [dbo].[tra_TransactionDetails_OS] CHECK CONSTRAINT [FK_tra_TransactionDetails_OS_tra_TransactionMaster_OS]
GO

/****** Object:  ForeignKey [FK_tra_TransactionDetails_OS_usr_DMATDetails_DMATDetailsID]    Script Date: 02/06/2019 19:41:41 ******/
ALTER TABLE [dbo].[tra_TransactionDetails_OS]  WITH CHECK ADD  CONSTRAINT [FK_tra_TransactionDetails_OS_usr_DMATDetails_DMATDetailsID] FOREIGN KEY([DMATDetailsID])
REFERENCES [dbo].[usr_DMATDetails] ([DMATDetailsID])
GO
ALTER TABLE [dbo].[tra_TransactionDetails_OS] CHECK CONSTRAINT [FK_tra_TransactionDetails_OS_usr_DMATDetails_DMATDetailsID]
GO

/****** Object:  ForeignKey [FK_tra_TransactionDetails_OS_usr_UserInfo_CreatedBy]    Script Date: 02/06/2019 19:41:41 ******/
ALTER TABLE [dbo].[tra_TransactionDetails_OS]  WITH CHECK ADD  CONSTRAINT [FK_tra_TransactionDetails_OS_usr_UserInfo_CreatedBy] FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[usr_UserInfo] ([UserInfoId])
GO
ALTER TABLE [dbo].[tra_TransactionDetails_OS] CHECK CONSTRAINT [FK_tra_TransactionDetails_OS_usr_UserInfo_CreatedBy]
GO

/****** Object:  ForeignKey [FK_tra_TransactionDetails_OS_usr_UserInfo_UserInfoId]    Script Date: 02/06/2019 19:41:41 ******/
ALTER TABLE [dbo].[tra_TransactionDetails_OS]  WITH CHECK ADD  CONSTRAINT [FK_tra_TransactionDetails_OS_usr_UserInfo_ForUserInfoId] FOREIGN KEY([ForUserInfoId])
REFERENCES [dbo].[usr_UserInfo] ([UserInfoId])
GO
ALTER TABLE [dbo].[tra_TransactionDetails_OS] CHECK CONSTRAINT [FK_tra_TransactionDetails_OS_usr_UserInfo_ForUserInfoId]
GO

/****** Object:  ForeignKey [FK_tra_TransactionDetails_OS_usr_UserInfo_ModifiedBy]    Script Date: 02/06/2019 19:41:41 ******/
ALTER TABLE [dbo].[tra_TransactionDetails_OS]  WITH CHECK ADD  CONSTRAINT [FK_tra_TransactionDetails_OS_usr_UserInfo_ModifiedBy] FOREIGN KEY([ModifiedBy])
REFERENCES [dbo].[usr_UserInfo] ([UserInfoId])
GO
ALTER TABLE [dbo].[tra_TransactionDetails_OS] CHECK CONSTRAINT [FK_tra_TransactionDetails_OS_usr_UserInfo_ModifiedBy]
GO


