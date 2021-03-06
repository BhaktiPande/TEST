/****** Object:  Table [dbo].[tra_TransactionMaster]    Script Date: 06/07/2016 12:05:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tra_TransactionMaster]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tra_TransactionMaster](
	[TransactionMasterId] [bigint] IDENTITY(1,1) NOT NULL,
	[ParentTransactionMasterId] [bigint] NULL,
	[PreclearanceRequestId] [bigint] NULL,
	[UserInfoId] [int] NOT NULL,
	[DisclosureTypeCodeId] [int] NOT NULL,
	[TransactionStatusCodeId] [int] NOT NULL,
	[NoHoldingFlag] [bit] NOT NULL,
	[TradingPolicyId] [int] NOT NULL,
	[PeriodEndDate] [datetime] NULL,
	[PartiallyTradedFlag] [bit] NOT NULL,
	[SoftCopyReq] [bit] NOT NULL,
	[HardCopyReq] [bit] NOT NULL,
	[SecurityTypeCodeId] [int] NULL,
	[HardCopyByCOSubmissionDate] [datetime] NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[ModifiedBy] [int] NOT NULL,
	[ModifiedOn] [datetime] NOT NULL,
 CONSTRAINT [PK_tra_TransactionMaster] PRIMARY KEY CLUSTERED 
(
	[TransactionMasterId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'tra_TransactionMaster', N'COLUMN',N'DisclosureTypeCodeId'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Refers com_Code, CodeGroupId = 147
147001: Initial
147002: Continuous
147003: PeriodEnd' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tra_TransactionMaster', @level2type=N'COLUMN',@level2name=N'DisclosureTypeCodeId'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'tra_TransactionMaster', N'COLUMN',N'TransactionStatusCodeId'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Refers com_Code, CodeGroupId = 148
148001: Document Uploaded
148002: Not Confirmed
148003: Confirmed' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tra_TransactionMaster', @level2type=N'COLUMN',@level2name=N'TransactionStatusCodeId'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'tra_TransactionMaster', N'COLUMN',N'NoHoldingFlag'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'1: No Holding, 0: Details are given' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tra_TransactionMaster', @level2type=N'COLUMN',@level2name=N'NoHoldingFlag'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'tra_TransactionMaster', N'COLUMN',N'PeriodEndDate'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'If DisclosureTypeCodeId = Period End, then this will store PeriodEndDate' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tra_TransactionMaster', @level2type=N'COLUMN',@level2name=N'PeriodEndDate'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'tra_TransactionMaster', N'COLUMN',N'PartiallyTradedFlag'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'In case of preclearance, if no of shares specified in preclearance is greater than the total in transaction details, then this flag becomes 1' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tra_TransactionMaster', @level2type=N'COLUMN',@level2name=N'PartiallyTradedFlag'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'tra_TransactionMaster', N'COLUMN',N'SoftCopyReq'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'In case of rule set for multiple transaction, it will be calculated at the time of submission, which will be useful for generating status table for continuous.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tra_TransactionMaster', @level2type=N'COLUMN',@level2name=N'SoftCopyReq'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'tra_TransactionMaster', N'COLUMN',N'SecurityTypeCodeId'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'in case of Initial / Period End disclosure, this field will be null. In case of Continuous, it will not be null. It refers CodeGroupId = 139' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tra_TransactionMaster', @level2type=N'COLUMN',@level2name=N'SecurityTypeCodeId'
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tra_TransactionMaster_com_Code_DisclosureType]') AND parent_object_id = OBJECT_ID(N'[dbo].[tra_TransactionMaster]'))
ALTER TABLE [dbo].[tra_TransactionMaster]  WITH CHECK ADD  CONSTRAINT [FK_tra_TransactionMaster_com_Code_DisclosureType] FOREIGN KEY([DisclosureTypeCodeId])
REFERENCES [dbo].[com_Code] ([CodeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tra_TransactionMaster_com_Code_DisclosureType]') AND parent_object_id = OBJECT_ID(N'[dbo].[tra_TransactionMaster]'))
ALTER TABLE [dbo].[tra_TransactionMaster] CHECK CONSTRAINT [FK_tra_TransactionMaster_com_Code_DisclosureType]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tra_TransactionMaster_com_Code_SecurityTypeCodeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[tra_TransactionMaster]'))
ALTER TABLE [dbo].[tra_TransactionMaster]  WITH CHECK ADD  CONSTRAINT [FK_tra_TransactionMaster_com_Code_SecurityTypeCodeId] FOREIGN KEY([SecurityTypeCodeId])
REFERENCES [dbo].[com_Code] ([CodeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tra_TransactionMaster_com_Code_SecurityTypeCodeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[tra_TransactionMaster]'))
ALTER TABLE [dbo].[tra_TransactionMaster] CHECK CONSTRAINT [FK_tra_TransactionMaster_com_Code_SecurityTypeCodeId]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tra_TransactionMaster_com_Code_TransactionStatus]') AND parent_object_id = OBJECT_ID(N'[dbo].[tra_TransactionMaster]'))
ALTER TABLE [dbo].[tra_TransactionMaster]  WITH CHECK ADD  CONSTRAINT [FK_tra_TransactionMaster_com_Code_TransactionStatus] FOREIGN KEY([TransactionStatusCodeId])
REFERENCES [dbo].[com_Code] ([CodeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tra_TransactionMaster_com_Code_TransactionStatus]') AND parent_object_id = OBJECT_ID(N'[dbo].[tra_TransactionMaster]'))
ALTER TABLE [dbo].[tra_TransactionMaster] CHECK CONSTRAINT [FK_tra_TransactionMaster_com_Code_TransactionStatus]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tra_TransactionMaster_rul_TradingPolicy_TradingPolicyId]') AND parent_object_id = OBJECT_ID(N'[dbo].[tra_TransactionMaster]'))
ALTER TABLE [dbo].[tra_TransactionMaster]  WITH CHECK ADD  CONSTRAINT [FK_tra_TransactionMaster_rul_TradingPolicy_TradingPolicyId] FOREIGN KEY([TradingPolicyId])
REFERENCES [dbo].[rul_TradingPolicy] ([TradingPolicyId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tra_TransactionMaster_rul_TradingPolicy_TradingPolicyId]') AND parent_object_id = OBJECT_ID(N'[dbo].[tra_TransactionMaster]'))
ALTER TABLE [dbo].[tra_TransactionMaster] CHECK CONSTRAINT [FK_tra_TransactionMaster_rul_TradingPolicy_TradingPolicyId]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tra_TransactionMaster_tra_PreclearanceRequest_PreclearanceRequestId]') AND parent_object_id = OBJECT_ID(N'[dbo].[tra_TransactionMaster]'))
ALTER TABLE [dbo].[tra_TransactionMaster]  WITH CHECK ADD  CONSTRAINT [FK_tra_TransactionMaster_tra_PreclearanceRequest_PreclearanceRequestId] FOREIGN KEY([PreclearanceRequestId])
REFERENCES [dbo].[tra_PreclearanceRequest] ([PreclearanceRequestId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tra_TransactionMaster_tra_PreclearanceRequest_PreclearanceRequestId]') AND parent_object_id = OBJECT_ID(N'[dbo].[tra_TransactionMaster]'))
ALTER TABLE [dbo].[tra_TransactionMaster] CHECK CONSTRAINT [FK_tra_TransactionMaster_tra_PreclearanceRequest_PreclearanceRequestId]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tra_TransactionMaster_tra_TransactionMaster_ParentTransactionMasterId]') AND parent_object_id = OBJECT_ID(N'[dbo].[tra_TransactionMaster]'))
ALTER TABLE [dbo].[tra_TransactionMaster]  WITH CHECK ADD  CONSTRAINT [FK_tra_TransactionMaster_tra_TransactionMaster_ParentTransactionMasterId] FOREIGN KEY([ParentTransactionMasterId])
REFERENCES [dbo].[tra_TransactionMaster] ([TransactionMasterId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tra_TransactionMaster_tra_TransactionMaster_ParentTransactionMasterId]') AND parent_object_id = OBJECT_ID(N'[dbo].[tra_TransactionMaster]'))
ALTER TABLE [dbo].[tra_TransactionMaster] CHECK CONSTRAINT [FK_tra_TransactionMaster_tra_TransactionMaster_ParentTransactionMasterId]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tra_TransactionMaster_usr_UserInfo_CreatedBy]') AND parent_object_id = OBJECT_ID(N'[dbo].[tra_TransactionMaster]'))
ALTER TABLE [dbo].[tra_TransactionMaster]  WITH CHECK ADD  CONSTRAINT [FK_tra_TransactionMaster_usr_UserInfo_CreatedBy] FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[usr_UserInfo] ([UserInfoId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tra_TransactionMaster_usr_UserInfo_CreatedBy]') AND parent_object_id = OBJECT_ID(N'[dbo].[tra_TransactionMaster]'))
ALTER TABLE [dbo].[tra_TransactionMaster] CHECK CONSTRAINT [FK_tra_TransactionMaster_usr_UserInfo_CreatedBy]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tra_TransactionMaster_usr_UserInfo_ModifiedBy]') AND parent_object_id = OBJECT_ID(N'[dbo].[tra_TransactionMaster]'))
ALTER TABLE [dbo].[tra_TransactionMaster]  WITH CHECK ADD  CONSTRAINT [FK_tra_TransactionMaster_usr_UserInfo_ModifiedBy] FOREIGN KEY([ModifiedBy])
REFERENCES [dbo].[usr_UserInfo] ([UserInfoId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tra_TransactionMaster_usr_UserInfo_ModifiedBy]') AND parent_object_id = OBJECT_ID(N'[dbo].[tra_TransactionMaster]'))
ALTER TABLE [dbo].[tra_TransactionMaster] CHECK CONSTRAINT [FK_tra_TransactionMaster_usr_UserInfo_ModifiedBy]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tra_TransactionMaster_usr_UserInfo_UserInfoId]') AND parent_object_id = OBJECT_ID(N'[dbo].[tra_TransactionMaster]'))
ALTER TABLE [dbo].[tra_TransactionMaster]  WITH CHECK ADD  CONSTRAINT [FK_tra_TransactionMaster_usr_UserInfo_UserInfoId] FOREIGN KEY([UserInfoId])
REFERENCES [dbo].[usr_UserInfo] ([UserInfoId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tra_TransactionMaster_usr_UserInfo_UserInfoId]') AND parent_object_id = OBJECT_ID(N'[dbo].[tra_TransactionMaster]'))
ALTER TABLE [dbo].[tra_TransactionMaster] CHECK CONSTRAINT [FK_tra_TransactionMaster_usr_UserInfo_UserInfoId]
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tra_TransactionMaster_NoHoldingFlag]') AND parent_object_id = OBJECT_ID(N'[dbo].[tra_TransactionMaster]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tra_TransactionMaster_NoHoldingFlag]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tra_TransactionMaster] ADD  CONSTRAINT [DF_tra_TransactionMaster_NoHoldingFlag]  DEFAULT ((0)) FOR [NoHoldingFlag]
END


End
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tra_TransactionMaster_PartiallyTradedFlag]') AND parent_object_id = OBJECT_ID(N'[dbo].[tra_TransactionMaster]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tra_TransactionMaster_PartiallyTradedFlag]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tra_TransactionMaster] ADD  CONSTRAINT [DF_tra_TransactionMaster_PartiallyTradedFlag]  DEFAULT ((0)) FOR [PartiallyTradedFlag]
END


End
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tra_TransactionMaster_SoftCopyReq]') AND parent_object_id = OBJECT_ID(N'[dbo].[tra_TransactionMaster]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tra_TransactionMaster_SoftCopyReq]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tra_TransactionMaster] ADD  CONSTRAINT [DF_tra_TransactionMaster_SoftCopyReq]  DEFAULT ((0)) FOR [SoftCopyReq]
END


End
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tra_TransactionMaster_HardCopyReq]') AND parent_object_id = OBJECT_ID(N'[dbo].[tra_TransactionMaster]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tra_TransactionMaster_HardCopyReq]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tra_TransactionMaster] ADD  CONSTRAINT [DF_tra_TransactionMaster_HardCopyReq]  DEFAULT ((0)) FOR [HardCopyReq]
END


End
GO
