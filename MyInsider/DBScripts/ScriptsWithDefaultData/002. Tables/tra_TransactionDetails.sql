/****** Object:  Table [dbo].[tra_TransactionDetails]    Script Date: 06/07/2016 12:05:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tra_TransactionDetails]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tra_TransactionDetails](
	[TransactionDetailsId] [bigint] IDENTITY(1,1) NOT NULL,
	[TransactionMasterId] [bigint] NOT NULL,
	[SecurityTypeCodeId] [int] NOT NULL,
	[ForUserInfoId] [int] NOT NULL,
	[DMATDetailsID] [int] NOT NULL,
	[CompanyId] [int] NOT NULL,
	[SecuritiesPriorToAcquisition] [decimal](10, 0) NOT NULL,
	[PerOfSharesPreTransaction] [decimal](5, 2) NOT NULL,
	[DateOfAcquisition] [datetime] NOT NULL,
	[DateOfInitimationToCompany] [datetime] NULL,
	[ModeOfAcquisitionCodeId] [int] NOT NULL,
	[PerOfSharesPostTransaction] [decimal](5, 2) NOT NULL,
	[ExchangeCodeId] [int] NOT NULL,
	[TransactionTypeCodeId] [int] NOT NULL,
	[Quantity] [decimal](10, 0) NOT NULL,
	[Value] [decimal](10, 0) NOT NULL,
	[Quantity2] [decimal](10, 0) NOT NULL,
	[Value2] [decimal](10, 0) NOT NULL,
	[TransactionLetterId] [bigint] NULL,
	[LotSize] [int] NOT NULL,
	[IsPLCReq] [int] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[ModifiedBy] [int] NOT NULL,
	[ModifiedOn] [datetime] NOT NULL,
	[SegregateESOPAndOtherExcerciseOptionQtyFalg] [bit] NOT NULL,
	[ESOPExcerciseOptionQty] [decimal](10, 0) NOT NULL,
	[OtherExcerciseOptionQty] [decimal](10, 0) NOT NULL,
	[ESOPExcerseOptionQtyFlag] [int] NOT NULL,
	[OtherESOPExcerseOptionFlag] [int] NOT NULL,
	[ContractSpecification] [varchar](50) NULL,
 CONSTRAINT [PK_tra_TransactionDetails] PRIMARY KEY CLUSTERED 
(
	[TransactionDetailsId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'tra_TransactionDetails', N'COLUMN',N'SecurityTypeCodeId'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Refers com_Code, CodegRoupId = 146
146001: Equity
146002: Derivative' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tra_TransactionDetails', @level2type=N'COLUMN',@level2name=N'SecurityTypeCodeId'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'tra_TransactionDetails', N'COLUMN',N'ModeOfAcquisitionCodeId'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Refers com_Code, CodeGroupId = 149
149001: Market Purchase
149002: Public
149003: Right preferential
149004: Offer' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tra_TransactionDetails', @level2type=N'COLUMN',@level2name=N'ModeOfAcquisitionCodeId'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'tra_TransactionDetails', N'COLUMN',N'ExchangeCodeId'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'referes com_Code.
CodeGroupId = 116' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tra_TransactionDetails', @level2type=N'COLUMN',@level2name=N'ExchangeCodeId'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'tra_TransactionDetails', N'COLUMN',N'TransactionTypeCodeId'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Refers com_Code, CodeGroupId = 143
143001: Buy
143002: Sell' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tra_TransactionDetails', @level2type=N'COLUMN',@level2name=N'TransactionTypeCodeId'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'tra_TransactionDetails', N'COLUMN',N'IsPLCReq'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0: Preclearance not req
1: Preclearance req' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tra_TransactionDetails', @level2type=N'COLUMN',@level2name=N'IsPLCReq'
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tra_TransactionDetails_com_Code_ExchangeCodeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[tra_TransactionDetails]'))
ALTER TABLE [dbo].[tra_TransactionDetails]  WITH CHECK ADD  CONSTRAINT [FK_tra_TransactionDetails_com_Code_ExchangeCodeId] FOREIGN KEY([ExchangeCodeId])
REFERENCES [dbo].[com_Code] ([CodeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tra_TransactionDetails_com_Code_ExchangeCodeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[tra_TransactionDetails]'))
ALTER TABLE [dbo].[tra_TransactionDetails] CHECK CONSTRAINT [FK_tra_TransactionDetails_com_Code_ExchangeCodeId]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tra_TransactionDetails_com_Code_ModeOfAcquitionCodeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[tra_TransactionDetails]'))
ALTER TABLE [dbo].[tra_TransactionDetails]  WITH CHECK ADD  CONSTRAINT [FK_tra_TransactionDetails_com_Code_ModeOfAcquitionCodeId] FOREIGN KEY([ModeOfAcquisitionCodeId])
REFERENCES [dbo].[com_Code] ([CodeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tra_TransactionDetails_com_Code_ModeOfAcquitionCodeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[tra_TransactionDetails]'))
ALTER TABLE [dbo].[tra_TransactionDetails] CHECK CONSTRAINT [FK_tra_TransactionDetails_com_Code_ModeOfAcquitionCodeId]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tra_TransactionDetails_com_Code_SecurityTypeCodeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[tra_TransactionDetails]'))
ALTER TABLE [dbo].[tra_TransactionDetails]  WITH CHECK ADD  CONSTRAINT [FK_tra_TransactionDetails_com_Code_SecurityTypeCodeId] FOREIGN KEY([SecurityTypeCodeId])
REFERENCES [dbo].[com_Code] ([CodeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tra_TransactionDetails_com_Code_SecurityTypeCodeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[tra_TransactionDetails]'))
ALTER TABLE [dbo].[tra_TransactionDetails] CHECK CONSTRAINT [FK_tra_TransactionDetails_com_Code_SecurityTypeCodeId]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tra_TransactionDetails_com_Code_TransactionTypeCodeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[tra_TransactionDetails]'))
ALTER TABLE [dbo].[tra_TransactionDetails]  WITH CHECK ADD  CONSTRAINT [FK_tra_TransactionDetails_com_Code_TransactionTypeCodeId] FOREIGN KEY([TransactionTypeCodeId])
REFERENCES [dbo].[com_Code] ([CodeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tra_TransactionDetails_com_Code_TransactionTypeCodeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[tra_TransactionDetails]'))
ALTER TABLE [dbo].[tra_TransactionDetails] CHECK CONSTRAINT [FK_tra_TransactionDetails_com_Code_TransactionTypeCodeId]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tra_TransactionDetails_mst_Company_CompanyId]') AND parent_object_id = OBJECT_ID(N'[dbo].[tra_TransactionDetails]'))
ALTER TABLE [dbo].[tra_TransactionDetails]  WITH CHECK ADD  CONSTRAINT [FK_tra_TransactionDetails_mst_Company_CompanyId] FOREIGN KEY([CompanyId])
REFERENCES [dbo].[mst_Company] ([CompanyId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tra_TransactionDetails_mst_Company_CompanyId]') AND parent_object_id = OBJECT_ID(N'[dbo].[tra_TransactionDetails]'))
ALTER TABLE [dbo].[tra_TransactionDetails] CHECK CONSTRAINT [FK_tra_TransactionDetails_mst_Company_CompanyId]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tra_TransactionDetails_tra_TransactionLetter_TransctionLetterId]') AND parent_object_id = OBJECT_ID(N'[dbo].[tra_TransactionDetails]'))
ALTER TABLE [dbo].[tra_TransactionDetails]  WITH CHECK ADD  CONSTRAINT [FK_tra_TransactionDetails_tra_TransactionLetter_TransctionLetterId] FOREIGN KEY([TransactionLetterId])
REFERENCES [dbo].[tra_TransactionLetter] ([TransactionLetterId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tra_TransactionDetails_tra_TransactionLetter_TransctionLetterId]') AND parent_object_id = OBJECT_ID(N'[dbo].[tra_TransactionDetails]'))
ALTER TABLE [dbo].[tra_TransactionDetails] CHECK CONSTRAINT [FK_tra_TransactionDetails_tra_TransactionLetter_TransctionLetterId]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tra_TransactionDetails_tra_TransactionMaster_TransactionMasterId]') AND parent_object_id = OBJECT_ID(N'[dbo].[tra_TransactionDetails]'))
ALTER TABLE [dbo].[tra_TransactionDetails]  WITH CHECK ADD  CONSTRAINT [FK_tra_TransactionDetails_tra_TransactionMaster_TransactionMasterId] FOREIGN KEY([TransactionMasterId])
REFERENCES [dbo].[tra_TransactionMaster] ([TransactionMasterId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tra_TransactionDetails_tra_TransactionMaster_TransactionMasterId]') AND parent_object_id = OBJECT_ID(N'[dbo].[tra_TransactionDetails]'))
ALTER TABLE [dbo].[tra_TransactionDetails] CHECK CONSTRAINT [FK_tra_TransactionDetails_tra_TransactionMaster_TransactionMasterId]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tra_TransactionDetails_usr_DMATDetails_DMATDetailsID]') AND parent_object_id = OBJECT_ID(N'[dbo].[tra_TransactionDetails]'))
ALTER TABLE [dbo].[tra_TransactionDetails]  WITH CHECK ADD  CONSTRAINT [FK_tra_TransactionDetails_usr_DMATDetails_DMATDetailsID] FOREIGN KEY([DMATDetailsID])
REFERENCES [dbo].[usr_DMATDetails] ([DMATDetailsID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tra_TransactionDetails_usr_DMATDetails_DMATDetailsID]') AND parent_object_id = OBJECT_ID(N'[dbo].[tra_TransactionDetails]'))
ALTER TABLE [dbo].[tra_TransactionDetails] CHECK CONSTRAINT [FK_tra_TransactionDetails_usr_DMATDetails_DMATDetailsID]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tra_TransactionDetails_usr_UserInfo_CreatedBy]') AND parent_object_id = OBJECT_ID(N'[dbo].[tra_TransactionDetails]'))
ALTER TABLE [dbo].[tra_TransactionDetails]  WITH CHECK ADD  CONSTRAINT [FK_tra_TransactionDetails_usr_UserInfo_CreatedBy] FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[usr_UserInfo] ([UserInfoId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tra_TransactionDetails_usr_UserInfo_CreatedBy]') AND parent_object_id = OBJECT_ID(N'[dbo].[tra_TransactionDetails]'))
ALTER TABLE [dbo].[tra_TransactionDetails] CHECK CONSTRAINT [FK_tra_TransactionDetails_usr_UserInfo_CreatedBy]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tra_TransactionDetails_usr_UserInfo_ForUserId]') AND parent_object_id = OBJECT_ID(N'[dbo].[tra_TransactionDetails]'))
ALTER TABLE [dbo].[tra_TransactionDetails]  WITH CHECK ADD  CONSTRAINT [FK_tra_TransactionDetails_usr_UserInfo_ForUserId] FOREIGN KEY([ForUserInfoId])
REFERENCES [dbo].[usr_UserInfo] ([UserInfoId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tra_TransactionDetails_usr_UserInfo_ForUserId]') AND parent_object_id = OBJECT_ID(N'[dbo].[tra_TransactionDetails]'))
ALTER TABLE [dbo].[tra_TransactionDetails] CHECK CONSTRAINT [FK_tra_TransactionDetails_usr_UserInfo_ForUserId]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tra_TransactionDetails_usr_UserInfo_ModifiedBy]') AND parent_object_id = OBJECT_ID(N'[dbo].[tra_TransactionDetails]'))
ALTER TABLE [dbo].[tra_TransactionDetails]  WITH CHECK ADD  CONSTRAINT [FK_tra_TransactionDetails_usr_UserInfo_ModifiedBy] FOREIGN KEY([ModifiedBy])
REFERENCES [dbo].[usr_UserInfo] ([UserInfoId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tra_TransactionDetails_usr_UserInfo_ModifiedBy]') AND parent_object_id = OBJECT_ID(N'[dbo].[tra_TransactionDetails]'))
ALTER TABLE [dbo].[tra_TransactionDetails] CHECK CONSTRAINT [FK_tra_TransactionDetails_usr_UserInfo_ModifiedBy]
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tra_TransactionDetails_SellQuantity]') AND parent_object_id = OBJECT_ID(N'[dbo].[tra_TransactionDetails]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tra_TransactionDetails_SellQuantity]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tra_TransactionDetails] ADD  CONSTRAINT [DF_tra_TransactionDetails_SellQuantity]  DEFAULT ((0)) FOR [Quantity2]
END


End
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tra_TransactionDetails_SellValue]') AND parent_object_id = OBJECT_ID(N'[dbo].[tra_TransactionDetails]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tra_TransactionDetails_SellValue]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tra_TransactionDetails] ADD  CONSTRAINT [DF_tra_TransactionDetails_SellValue]  DEFAULT ((0)) FOR [Value2]
END


End
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tra_TransactionDetails_LotSize]') AND parent_object_id = OBJECT_ID(N'[dbo].[tra_TransactionDetails]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tra_TransactionDetails_LotSize]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tra_TransactionDetails] ADD  CONSTRAINT [DF_tra_TransactionDetails_LotSize]  DEFAULT ((0)) FOR [LotSize]
END


End
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tra_TransactionDetails_IsPLCReq]') AND parent_object_id = OBJECT_ID(N'[dbo].[tra_TransactionDetails]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tra_TransactionDetails_IsPLCReq]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tra_TransactionDetails] ADD  CONSTRAINT [DF_tra_TransactionDetails_IsPLCReq]  DEFAULT ((0)) FOR [IsPLCReq]
END


End
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tra_TransactionDetails_SegEsopOtherFlag]') AND parent_object_id = OBJECT_ID(N'[dbo].[tra_TransactionDetails]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tra_TransactionDetails_SegEsopOtherFlag]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tra_TransactionDetails] ADD  CONSTRAINT [DF_tra_TransactionDetails_SegEsopOtherFlag]  DEFAULT ((0)) FOR [SegregateESOPAndOtherExcerciseOptionQtyFalg]
END


End
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tra_TransactionDetails_EsopQty]') AND parent_object_id = OBJECT_ID(N'[dbo].[tra_TransactionDetails]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tra_TransactionDetails_EsopQty]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tra_TransactionDetails] ADD  CONSTRAINT [DF_tra_TransactionDetails_EsopQty]  DEFAULT ((0)) FOR [ESOPExcerciseOptionQty]
END


End
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tra_TransactionDetails_OtherQty]') AND parent_object_id = OBJECT_ID(N'[dbo].[tra_TransactionDetails]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tra_TransactionDetails_OtherQty]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tra_TransactionDetails] ADD  CONSTRAINT [DF_tra_TransactionDetails_OtherQty]  DEFAULT ((0)) FOR [OtherExcerciseOptionQty]
END


End
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tra_TransactionDetails_EsopQtyFlg]') AND parent_object_id = OBJECT_ID(N'[dbo].[tra_TransactionDetails]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tra_TransactionDetails_EsopQtyFlg]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tra_TransactionDetails] ADD  CONSTRAINT [DF_tra_TransactionDetails_EsopQtyFlg]  DEFAULT ((0)) FOR [ESOPExcerseOptionQtyFlag]
END


End
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tra_TransactionDetails_OtherQtyFlg]') AND parent_object_id = OBJECT_ID(N'[dbo].[tra_TransactionDetails]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tra_TransactionDetails_OtherQtyFlg]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tra_TransactionDetails] ADD  CONSTRAINT [DF_tra_TransactionDetails_OtherQtyFlg]  DEFAULT ((0)) FOR [OtherESOPExcerseOptionFlag]
END


End
GO
