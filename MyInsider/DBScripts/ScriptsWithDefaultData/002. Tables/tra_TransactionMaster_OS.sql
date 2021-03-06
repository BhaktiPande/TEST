
GO
/****** Object:  Table [dbo].[tra_TransactionMaster_OS]    Script Date: 02/06/2019 19:41:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tra_TransactionMaster_OS](
	[TransactionMasterId] [bigint] IDENTITY(1,1) NOT NULL,
	[ParentTransactionMasterId] [bigint] NULL,
	[PreclearanceRequestId] [bigint] NULL,
	[UserInfoId] [int] NOT NULL,
	[DisclosureTypeCodeId] [int] NOT NULL,
	[TransactionStatusCodeId] [int] NOT NULL,	
	[TradingPolicyId] [int] NOT NULL,
	[PeriodEndDate] [datetime] NULL,
	[NoHoldingFlag] [bit] NOT NULL,
	[PartiallyTradedFlag] [bit] NOT NULL,
	[SoftCopyReq] [bit] NOT NULL,
	[HardCopyReq] [bit] NOT NULL,
	[DisplayRollingNumber] [bigint] NULL,
	[CDDuringPE] [bit] NULL,
	[InsiderIDFlag] [bit] NULL,
	[CreatedBy] [int] NULL,
	[CreatedOn] [datetime] NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedOn] [datetime] NULL,
 CONSTRAINT [PK_tra_TransactionMaster_OS] PRIMARY KEY CLUSTERED 
(
	[TransactionMasterId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  ForeignKey [FK_tra_TransactionMaster_OS_com_Code_DisclosureTypeCodeId]    Script Date: 02/06/2019 19:41:41 ******/
ALTER TABLE [dbo].[tra_TransactionMaster_OS]  WITH CHECK ADD  CONSTRAINT [FK_tra_TransactionMaster_OS_com_Code_DisclosureTypeCodeId] FOREIGN KEY([DisclosureTypeCodeId])
REFERENCES [dbo].[com_Code] ([CodeID])
GO
ALTER TABLE [dbo].[tra_TransactionMaster_OS] CHECK CONSTRAINT [FK_tra_TransactionMaster_OS_com_Code_DisclosureTypeCodeId]
GO
/****** Object:  ForeignKey [FK_tra_TransactionMaster_OS_com_Code_TransactionStatusCodeId]    Script Date: 02/06/2019 19:41:41 ******/
ALTER TABLE [dbo].[tra_TransactionMaster_OS]  WITH CHECK ADD  CONSTRAINT [FK_tra_TransactionMaster_OS_com_Code_TransactionStatusCodeId] FOREIGN KEY([TransactionStatusCodeId])
REFERENCES [dbo].[com_Code] ([CodeID])
GO
ALTER TABLE [dbo].[tra_TransactionMaster_OS] CHECK CONSTRAINT [FK_tra_TransactionMaster_OS_com_Code_TransactionStatusCodeId]
GO
/****** Object:  ForeignKey [FK_tra_TransactionMaster_OS_rul_TradingPolicy_TradingPolicyId]    Script Date: 02/06/2019 19:41:41 ******/
ALTER TABLE [dbo].[tra_TransactionMaster_OS]  WITH CHECK ADD  CONSTRAINT [FK_tra_TransactionMaster_OS_rul_TradingPolicy_OS_TradingPolicyId] FOREIGN KEY([TradingPolicyId])
REFERENCES [dbo].[rul_TradingPolicy_OS] ([TradingPolicyId])
GO
ALTER TABLE [dbo].[tra_TransactionMaster_OS] CHECK CONSTRAINT [FK_tra_TransactionMaster_OS_rul_TradingPolicy_OS_TradingPolicyId]
GO
/****** Object:  ForeignKey [FK_tra_TransactionMaster_OS_tra_TransactionMaster_OS_ParentTransactionMasterId]    Script Date: 02/06/2019 19:41:41 ******/
ALTER TABLE [dbo].[tra_TransactionMaster_OS]  WITH CHECK ADD  CONSTRAINT [FK_tra_TransactionMaster_OS_tra_TransactionMaster_OS_ParentTransactionMasterId] FOREIGN KEY([ParentTransactionMasterId])
REFERENCES [dbo].[tra_TransactionMaster_OS] ([TransactionMasterId])
GO
ALTER TABLE [dbo].[tra_TransactionMaster_OS] CHECK CONSTRAINT [FK_tra_TransactionMaster_OS_tra_TransactionMaster_OS_ParentTransactionMasterId]
GO
/****** Object:  ForeignKey [FK_tra_TransactionMaster_OS_tra_PreclearanceRequest_NonImplementationCompany_PreclearanceRequestId]    Script Date: 02/06/2019 19:41:41 ******/
ALTER TABLE [dbo].[tra_TransactionMaster_OS]  WITH CHECK ADD  CONSTRAINT [FK_tra_TransactionMaster_OS_tra_PreclearanceRequest_NonImplementationCompany_PreclearanceRequestId] FOREIGN KEY([PreclearanceRequestId])
REFERENCES [dbo].[tra_PreclearanceRequest_NonImplementationCompany] ([PreclearanceRequestId])
GO
ALTER TABLE [dbo].[tra_TransactionMaster_OS] CHECK CONSTRAINT [FK_tra_TransactionMaster_OS_tra_PreclearanceRequest_NonImplementationCompany_PreclearanceRequestId]
GO
/****** Object:  ForeignKey [FK_tra_TransactionMaster_OS_usr_UserInfo_CreatedBy]    Script Date: 02/06/2019 19:41:41 ******/
ALTER TABLE [dbo].[tra_TransactionMaster_OS]  WITH CHECK ADD  CONSTRAINT [FK_tra_TransactionMaster_OS_usr_UserInfo_CreatedBy] FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[usr_UserInfo] ([UserInfoId])
GO
ALTER TABLE [dbo].[tra_TransactionMaster_OS] CHECK CONSTRAINT [FK_tra_TransactionMaster_OS_usr_UserInfo_CreatedBy]
GO
/****** Object:  ForeignKey [FK_tra_TransactionMaster_OS_usr_UserInfo_ModifiedBy]    Script Date: 02/06/2019 19:41:41 ******/
ALTER TABLE [dbo].[tra_TransactionMaster_OS]  WITH CHECK ADD  CONSTRAINT [FK_tra_TransactionMaster_OS_usr_UserInfo_ModifiedBy] FOREIGN KEY([ModifiedBy])
REFERENCES [dbo].[usr_UserInfo] ([UserInfoId])
GO
ALTER TABLE [dbo].[tra_TransactionMaster_OS] CHECK CONSTRAINT [FK_tra_TransactionMaster_OS_usr_UserInfo_ModifiedBy]
GO
/****** Object:  ForeignKey [FK_tra_TransactionMaster_OS_usr_UserInfo_UserInfoId]    Script Date: 02/06/2019 19:41:41 ******/
ALTER TABLE [dbo].[tra_TransactionMaster_OS]  WITH CHECK ADD  CONSTRAINT [FK_tra_TransactionMaster_OS_usr_UserInfo_UserInfoId] FOREIGN KEY([UserInfoId])
REFERENCES [dbo].[usr_UserInfo] ([UserInfoId])
GO
ALTER TABLE [dbo].[tra_TransactionMaster_OS] CHECK CONSTRAINT [FK_tra_TransactionMaster_OS_usr_UserInfo_UserInfoId]
GO

ALTER TABLE [dbo].[tra_TransactionMaster_OS] ADD  CONSTRAINT [DF_tra_TransactionMaster_OS_NoHoldingFlag]  DEFAULT ((0)) FOR [NoHoldingFlag]
GO

ALTER TABLE [dbo].[tra_TransactionMaster_OS] ADD  CONSTRAINT [DF_tra_TransactionMaster_OS_PartiallyTradedFlag]  DEFAULT ((0)) FOR [PartiallyTradedFlag]
GO

ALTER TABLE [dbo].[tra_TransactionMaster_OS] ADD  CONSTRAINT [DF_tra_TransactionMaster_OS_SoftCopyReq]  DEFAULT ((0)) FOR [SoftCopyReq]
GO

ALTER TABLE [dbo].[tra_TransactionMaster_OS] ADD  CONSTRAINT [DF_tra_TransactionMaster_OS_HardCopyReq]  DEFAULT ((0)) FOR [HardCopyReq]
GO

ALTER TABLE [dbo].[tra_TransactionMaster_OS] ADD  DEFAULT ((0)) FOR [CDDuringPE]
GO

ALTER TABLE [dbo].[tra_TransactionMaster_OS] ADD  DEFAULT ((0)) FOR [InsiderIDFlag]
GO
