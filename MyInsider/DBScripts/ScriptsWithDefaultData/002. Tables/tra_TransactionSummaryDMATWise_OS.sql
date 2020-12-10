/****** Object:  Table [dbo].[tra_TransactionSummaryDMATWise_OS]    Script Date: 06/07/2016 12:05:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tra_TransactionSummaryDMATWise_OS]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tra_TransactionSummaryDMATWise_OS](
	[TransactionSummaryDMATWiseId] [bigint] IDENTITY(1,1) NOT NULL,
	[YearCodeId] [int] NOT NULL,
	[PeriodCodeId] [int] NOT NULL,
	[UserInfoId] [int] NOT NULL,
	[UserInfoIdRelative] [int] NULL,
	[SecurityTypeCodeId] [int] NOT NULL,
	[DMATDetailsID] [int] NOT NULL,
	[CompanyId][int] NOT NULL,
	[OpeningBalance] [decimal](10, 0) NOT NULL,
	[SellQuantity] [decimal](10, 0) NOT NULL,
	[BuyQuantity] [decimal](10, 0) NOT NULL,
	[ClosingBalance] [decimal](10, 0) NOT NULL,
	[Value] [decimal](25, 4) NULL,
	[PledgeBuyQuantity] [decimal](10, 0) NOT NULL DEFAULT ((0)),
	[PledgeSellQuantity] [decimal](10, 0) NOT NULL DEFAULT ((0)),
	[PledgeClosingBalance] [decimal](10, 0) NOT NULL DEFAULT ((0)),
 CONSTRAINT [PK_tra_TransactionSummaryDMATWise_OS] PRIMARY KEY CLUSTERED 
(
	[TransactionSummaryDMATWiseId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tra_TransactionSummaryDMATWise_OS_com_Code_PeriodCodeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[tra_TransactionSummaryDMATWise_OS]'))
ALTER TABLE [dbo].[tra_TransactionSummaryDMATWise_OS]  WITH CHECK ADD  CONSTRAINT [FK_tra_TransactionSummaryDMATWise_OS_com_Code_PeriodCodeId] FOREIGN KEY([PeriodCodeId])
REFERENCES [dbo].[com_Code] ([CodeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tra_TransactionSummaryDMATWise_OS_com_Code_PeriodCodeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[tra_TransactionSummaryDMATWise_OS]'))
ALTER TABLE [dbo].[tra_TransactionSummaryDMATWise_OS] CHECK CONSTRAINT [FK_tra_TransactionSummaryDMATWise_OS_com_Code_PeriodCodeId]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tra_TransactionSummaryDMATWise_OS_com_Code_SecurityTypeCodeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[tra_TransactionSummaryDMATWise_OS]'))
ALTER TABLE [dbo].[tra_TransactionSummaryDMATWise_OS]  WITH CHECK ADD  CONSTRAINT [FK_tra_TransactionSummaryDMATWise_OS_com_Code_SecurityTypeCodeId] FOREIGN KEY([SecurityTypeCodeId])
REFERENCES [dbo].[com_Code] ([CodeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tra_TransactionSummaryDMATWise_OS_com_Code_SecurityTypeCodeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[tra_TransactionSummaryDMATWise_OS]'))
ALTER TABLE [dbo].[tra_TransactionSummaryDMATWise_OS] CHECK CONSTRAINT [FK_tra_TransactionSummaryDMATWise_OS_com_Code_SecurityTypeCodeId]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tra_TransactionSummaryDMATWise_OS_com_Code_YearCode]') AND parent_object_id = OBJECT_ID(N'[dbo].[tra_TransactionSummaryDMATWise_OS]'))
ALTER TABLE [dbo].[tra_TransactionSummaryDMATWise_OS]  WITH CHECK ADD  CONSTRAINT [FK_tra_TransactionSummaryDMATWise_OS_com_Code_YearCode] FOREIGN KEY([YearCodeId])
REFERENCES [dbo].[com_Code] ([CodeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tra_TransactionSummaryDMATWise_OS_com_Code_YearCode]') AND parent_object_id = OBJECT_ID(N'[dbo].[tra_TransactionSummaryDMATWise_OS]'))
ALTER TABLE [dbo].[tra_TransactionSummaryDMATWise_OS] CHECK CONSTRAINT [FK_tra_TransactionSummaryDMATWise_OS_com_Code_YearCode]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tra_TransactionSummaryDMATWise_OS_usr_DMATDetails_DMATDetailsID]') AND parent_object_id = OBJECT_ID(N'[dbo].[tra_TransactionSummaryDMATWise_OS]'))
ALTER TABLE [dbo].[tra_TransactionSummaryDMATWise_OS]  WITH CHECK ADD  CONSTRAINT [FK_tra_TransactionSummaryDMATWise_OS_usr_DMATDetails_DMATDetailsID] FOREIGN KEY([DMATDetailsID])
REFERENCES [dbo].[usr_DMATDetails] ([DMATDetailsID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tra_TransactionSummaryDMATWise_OS_usr_DMATDetails_DMATDetailsID]') AND parent_object_id = OBJECT_ID(N'[dbo].[tra_TransactionSummaryDMATWise_OS]'))
ALTER TABLE [dbo].[tra_TransactionSummaryDMATWise_OS] CHECK CONSTRAINT [FK_tra_TransactionSummaryDMATWise_OS_usr_DMATDetails_DMATDetailsID]
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tra_TransactionSummaryDMATWise_OS_CompanyId_rl_CompanyMasterList_RlCompanyId]') AND parent_object_id = OBJECT_ID(N'[dbo].[tra_TransactionSummaryDMATWise_OS]'))
ALTER TABLE [dbo].[tra_TransactionSummaryDMATWise_OS]  WITH CHECK ADD  CONSTRAINT [FK_tra_TransactionSummaryDMATWise_OS_CompanyId_rl_CompanyMasterList_RlCompanyId] FOREIGN KEY([CompanyId])
REFERENCES [dbo].[rl_CompanyMasterList] ([RlCompanyId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tra_TransactionSummaryDMATWise_OS_CompanyId_rl_CompanyMasterList_RlCompanyId]') AND parent_object_id = OBJECT_ID(N'[dbo].[tra_TransactionSummaryDMATWise_OS]'))
ALTER TABLE [dbo].[tra_TransactionSummaryDMATWise_OS] CHECK CONSTRAINT [FK_tra_TransactionSummaryDMATWise_OS_CompanyId_rl_CompanyMasterList_RlCompanyId]
GO

IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tra_TransactionSummaryDMATWise_OS_usr_UserInfo_UserInfoId]') AND parent_object_id = OBJECT_ID(N'[dbo].[tra_TransactionSummaryDMATWise_OS]'))
ALTER TABLE [dbo].[tra_TransactionSummaryDMATWise_OS]  WITH CHECK ADD  CONSTRAINT [FK_tra_TransactionSummaryDMATWise_OS_usr_UserInfo_UserInfoId] FOREIGN KEY([UserInfoId])
REFERENCES [dbo].[usr_UserInfo] ([UserInfoId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tra_TransactionSummaryDMATWise_OS_usr_UserInfo_UserInfoId]') AND parent_object_id = OBJECT_ID(N'[dbo].[tra_TransactionSummaryDMATWise_OS]'))
ALTER TABLE [dbo].[tra_TransactionSummaryDMATWise_OS] CHECK CONSTRAINT [FK_tra_TransactionSummaryDMATWise_OS_usr_UserInfo_UserInfoId]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tra_TransactionSummaryDMATWise_OS_usr_UserInfo_UserInfoIdRelative]') AND parent_object_id = OBJECT_ID(N'[dbo].[tra_TransactionSummaryDMATWise_OS]'))
ALTER TABLE [dbo].[tra_TransactionSummaryDMATWise_OS]  WITH CHECK ADD  CONSTRAINT [FK_tra_TransactionSummaryDMATWise_OS_usr_UserInfo_UserInfoIdRelative] FOREIGN KEY([UserInfoIdRelative])
REFERENCES [dbo].[usr_UserInfo] ([UserInfoId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tra_TransactionSummaryDMATWise_OS_usr_UserInfo_UserInfoIdRelative]') AND parent_object_id = OBJECT_ID(N'[dbo].[tra_TransactionSummaryDMATWise_OS]'))
ALTER TABLE [dbo].[tra_TransactionSummaryDMATWise_OS] CHECK CONSTRAINT [FK_tra_TransactionSummaryDMATWise_OS_usr_UserInfo_UserInfoIdRelative]
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tra_TransactionSummaryDMATWise_OS_OpeningBalance]') AND parent_object_id = OBJECT_ID(N'[dbo].[tra_TransactionSummaryDMATWise_OS]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tra_TransactionSummaryDMATWise_OS_OpeningBalance]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tra_TransactionSummaryDMATWise_OS] ADD  CONSTRAINT [DF_tra_TransactionSummaryDMATWise_OS_OpeningBalance]  DEFAULT ((0)) FOR [OpeningBalance]
END


End
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tra_TransactionSummaryDMATWise_OS_SellQuantity]') AND parent_object_id = OBJECT_ID(N'[dbo].[tra_TransactionSummaryDMATWise_OS]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tra_TransactionSummaryDMATWise_OS_SellQuantity]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tra_TransactionSummaryDMATWise_OS] ADD  CONSTRAINT [DF_tra_TransactionSummaryDMATWise_OS_SellQuantity]  DEFAULT ((0)) FOR [SellQuantity]
END


End
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tra_TransactionSummaryDMATWise_OS_BuyQuantity]') AND parent_object_id = OBJECT_ID(N'[dbo].[tra_TransactionSummaryDMATWise_OS]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tra_TransactionSummaryDMATWise_OS_BuyQuantity]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tra_TransactionSummaryDMATWise_OS] ADD  CONSTRAINT [DF_tra_TransactionSummaryDMATWise_OS_BuyQuantity]  DEFAULT ((0)) FOR [BuyQuantity]
END

End
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tra_TransactionSummaryDMATWise_OS_ClosingBalance]') AND parent_object_id = OBJECT_ID(N'[dbo].[tra_TransactionSummaryDMATWise_OS]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tra_TransactionSummaryDMATWise_OS_ClosingBalance]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tra_TransactionSummaryDMATWise_OS] ADD  CONSTRAINT [DF_tra_TransactionSummaryDMATWise_OS_ClosingBalance]  DEFAULT ((0)) FOR [ClosingBalance]
END

End
GO
--IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tra_TransactionSummaryDMATWise_OS_Value]') AND parent_object_id = OBJECT_ID(N'[dbo].[tra_TransactionSummaryDMATWise_OS]'))
--Begin
--IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tra_TransactionSummaryDMATWise_OS_Value]') AND type = 'D')
--BEGIN
--ALTER TABLE [dbo].[tra_TransactionSummaryDMATWise_OS] ADD  CONSTRAINT [DF_tra_TransactionSummaryDMATWise_OS_Value]  DEFAULT ((0)) FOR [Value]
--END

--End
GO
