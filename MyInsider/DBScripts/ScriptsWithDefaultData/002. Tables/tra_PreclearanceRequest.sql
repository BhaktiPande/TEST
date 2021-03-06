/****** Object:  Table [dbo].[tra_PreclearanceRequest]    Script Date: 06/07/2016 12:05:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tra_PreclearanceRequest]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tra_PreclearanceRequest](
	[PreclearanceRequestId] [bigint] IDENTITY(1,1) NOT NULL,
	[PreclearanceRequestForCodeId] [int] NOT NULL,
	[UserInfoId] [int] NOT NULL,
	[UserInfoIdRelative] [int] NULL,
	[TransactionTypeCodeId] [int] NOT NULL,
	[SecurityTypeCodeId] [int] NOT NULL,
	[SecuritiesToBeTradedQty] [decimal](15, 4) NOT NULL,
	[SecuritiesToBeTradedValue] [decimal](20, 4) NOT NULL,
	[PreclearanceStatusCodeId] [int] NOT NULL,
	[CompanyId] [int] NOT NULL,
	[ProposedTradeRateRangeFrom] [decimal](15, 4) NOT NULL,
	[ProposedTradeRateRangeTo] [decimal](15, 4) NOT NULL,
	[DMATDetailsID] [int] NOT NULL,
	[ReasonForNotTradingCodeId] [int] NULL,
	[ReasonForNotTradingText] [varchar](30) NULL,
	[ReasonForRejection] [nvarchar](200) NULL,
	[IsPartiallyTraded] [int] NOT NULL,
	[ShowAddButton] [int] NOT NULL,
	[IsAutoApproved] [bit] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[ModifiedBy] [int] NOT NULL,
	[ModifiedOn] [datetime] NOT NULL,
	[ESOPExcerciseOptionQtyFlag] [bit] NOT NULL,
	[OtherESOPExcerciseOptionQtyFlag] [bit] NOT NULL,
	[ESOPExcerciseOptionQty] [decimal](15, 4) NOT NULL,
	[OtherExcerciseOptionQty] [decimal](15, 4) NOT NULL,
 CONSTRAINT [PK_tra_PreclearanceRequest] PRIMARY KEY CLUSTERED 
(
	[PreclearanceRequestId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'tra_PreclearanceRequest', N'COLUMN',N'PreclearanceRequestForCodeId'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Refers com_Code, CodeGroupId = 142
142001: Self
142002: Relative' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tra_PreclearanceRequest', @level2type=N'COLUMN',@level2name=N'PreclearanceRequestForCodeId'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'tra_PreclearanceRequest', N'COLUMN',N'UserInfoId'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Refers usr_UserInfo. Id of the user for whom, or whose relative, the request is to be made.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tra_PreclearanceRequest', @level2type=N'COLUMN',@level2name=N'UserInfoId'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'tra_PreclearanceRequest', N'COLUMN',N'TransactionTypeCodeId'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Refers com_Code, CodeGroupId = 143
143001: Buy
143002: Sell' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tra_PreclearanceRequest', @level2type=N'COLUMN',@level2name=N'TransactionTypeCodeId'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'tra_PreclearanceRequest', N'COLUMN',N'SecurityTypeCodeId'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Refers com_Code, CodeGroupId = 144
144001: Confirmed
144002: Approved
144003: Rejected' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tra_PreclearanceRequest', @level2type=N'COLUMN',@level2name=N'SecurityTypeCodeId'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'tra_PreclearanceRequest', N'COLUMN',N'PreclearanceStatusCodeId'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Refers com_Code, CodeGroupId = 146
146001: Equity
146002: Derivative' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tra_PreclearanceRequest', @level2type=N'COLUMN',@level2name=N'PreclearanceStatusCodeId'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'tra_PreclearanceRequest', N'COLUMN',N'ReasonForNotTradingCodeId'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Refers com_Code, CodeGroupId = 145' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tra_PreclearanceRequest', @level2type=N'COLUMN',@level2name=N'ReasonForNotTradingCodeId'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'tra_PreclearanceRequest', N'COLUMN',N'ReasonForRejection'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'When preclearance request is rejected, user will give rejection reason.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tra_PreclearanceRequest', @level2type=N'COLUMN',@level2name=N'ReasonForRejection'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'tra_PreclearanceRequest', N'COLUMN',N'IsPartiallyTraded'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'1: Partially Traded (Total Qty < PCL Qty),
0:Traded fully or excess (Total Qty >= PCLQty)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tra_PreclearanceRequest', @level2type=N'COLUMN',@level2name=N'IsPartiallyTraded'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'tra_PreclearanceRequest', N'COLUMN',N'ShowAddButton'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0:Do not Show Add button (If atleast one transaction not submitted or TotalQty >= PCL)
1: Show Add button (All transactions are submitted and TotalQty < PCLQty)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tra_PreclearanceRequest', @level2type=N'COLUMN',@level2name=N'ShowAddButton'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'tra_PreclearanceRequest', N'COLUMN',N'IsAutoApproved'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'To indicate if preclearance is auto approved. 0=not auto approved, 1=auto approved.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tra_PreclearanceRequest', @level2type=N'COLUMN',@level2name=N'IsAutoApproved'
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tra_PreclearanceRequest_com_Code_PreclearanceRequestFor]') AND parent_object_id = OBJECT_ID(N'[dbo].[tra_PreclearanceRequest]'))
ALTER TABLE [dbo].[tra_PreclearanceRequest]  WITH CHECK ADD  CONSTRAINT [FK_tra_PreclearanceRequest_com_Code_PreclearanceRequestFor] FOREIGN KEY([PreclearanceRequestForCodeId])
REFERENCES [dbo].[com_Code] ([CodeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tra_PreclearanceRequest_com_Code_PreclearanceRequestFor]') AND parent_object_id = OBJECT_ID(N'[dbo].[tra_PreclearanceRequest]'))
ALTER TABLE [dbo].[tra_PreclearanceRequest] CHECK CONSTRAINT [FK_tra_PreclearanceRequest_com_Code_PreclearanceRequestFor]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tra_PreclearanceRequest_com_Code_PreclearanceStatusCode]') AND parent_object_id = OBJECT_ID(N'[dbo].[tra_PreclearanceRequest]'))
ALTER TABLE [dbo].[tra_PreclearanceRequest]  WITH CHECK ADD  CONSTRAINT [FK_tra_PreclearanceRequest_com_Code_PreclearanceStatusCode] FOREIGN KEY([PreclearanceStatusCodeId])
REFERENCES [dbo].[com_Code] ([CodeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tra_PreclearanceRequest_com_Code_PreclearanceStatusCode]') AND parent_object_id = OBJECT_ID(N'[dbo].[tra_PreclearanceRequest]'))
ALTER TABLE [dbo].[tra_PreclearanceRequest] CHECK CONSTRAINT [FK_tra_PreclearanceRequest_com_Code_PreclearanceStatusCode]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tra_PreclearanceRequest_com_Code_ReasonForNotTrading]') AND parent_object_id = OBJECT_ID(N'[dbo].[tra_PreclearanceRequest]'))
ALTER TABLE [dbo].[tra_PreclearanceRequest]  WITH CHECK ADD  CONSTRAINT [FK_tra_PreclearanceRequest_com_Code_ReasonForNotTrading] FOREIGN KEY([ReasonForNotTradingCodeId])
REFERENCES [dbo].[com_Code] ([CodeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tra_PreclearanceRequest_com_Code_ReasonForNotTrading]') AND parent_object_id = OBJECT_ID(N'[dbo].[tra_PreclearanceRequest]'))
ALTER TABLE [dbo].[tra_PreclearanceRequest] CHECK CONSTRAINT [FK_tra_PreclearanceRequest_com_Code_ReasonForNotTrading]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tra_PreclearanceRequest_com_Code_SecurityTypeCode]') AND parent_object_id = OBJECT_ID(N'[dbo].[tra_PreclearanceRequest]'))
ALTER TABLE [dbo].[tra_PreclearanceRequest]  WITH CHECK ADD  CONSTRAINT [FK_tra_PreclearanceRequest_com_Code_SecurityTypeCode] FOREIGN KEY([SecurityTypeCodeId])
REFERENCES [dbo].[com_Code] ([CodeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tra_PreclearanceRequest_com_Code_SecurityTypeCode]') AND parent_object_id = OBJECT_ID(N'[dbo].[tra_PreclearanceRequest]'))
ALTER TABLE [dbo].[tra_PreclearanceRequest] CHECK CONSTRAINT [FK_tra_PreclearanceRequest_com_Code_SecurityTypeCode]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tra_PreclearanceRequest_com_Code_TransactionTypeCode]') AND parent_object_id = OBJECT_ID(N'[dbo].[tra_PreclearanceRequest]'))
ALTER TABLE [dbo].[tra_PreclearanceRequest]  WITH CHECK ADD  CONSTRAINT [FK_tra_PreclearanceRequest_com_Code_TransactionTypeCode] FOREIGN KEY([TransactionTypeCodeId])
REFERENCES [dbo].[com_Code] ([CodeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tra_PreclearanceRequest_com_Code_TransactionTypeCode]') AND parent_object_id = OBJECT_ID(N'[dbo].[tra_PreclearanceRequest]'))
ALTER TABLE [dbo].[tra_PreclearanceRequest] CHECK CONSTRAINT [FK_tra_PreclearanceRequest_com_Code_TransactionTypeCode]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tra_PreclearanceRequest_mst_Company_CompanyId]') AND parent_object_id = OBJECT_ID(N'[dbo].[tra_PreclearanceRequest]'))
ALTER TABLE [dbo].[tra_PreclearanceRequest]  WITH CHECK ADD  CONSTRAINT [FK_tra_PreclearanceRequest_mst_Company_CompanyId] FOREIGN KEY([CompanyId])
REFERENCES [dbo].[mst_Company] ([CompanyId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tra_PreclearanceRequest_mst_Company_CompanyId]') AND parent_object_id = OBJECT_ID(N'[dbo].[tra_PreclearanceRequest]'))
ALTER TABLE [dbo].[tra_PreclearanceRequest] CHECK CONSTRAINT [FK_tra_PreclearanceRequest_mst_Company_CompanyId]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tra_PreclearanceRequest_usr_DMATDetails_DmatDetailsId]') AND parent_object_id = OBJECT_ID(N'[dbo].[tra_PreclearanceRequest]'))
ALTER TABLE [dbo].[tra_PreclearanceRequest]  WITH CHECK ADD  CONSTRAINT [FK_tra_PreclearanceRequest_usr_DMATDetails_DmatDetailsId] FOREIGN KEY([DMATDetailsID])
REFERENCES [dbo].[usr_DMATDetails] ([DMATDetailsID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tra_PreclearanceRequest_usr_DMATDetails_DmatDetailsId]') AND parent_object_id = OBJECT_ID(N'[dbo].[tra_PreclearanceRequest]'))
ALTER TABLE [dbo].[tra_PreclearanceRequest] CHECK CONSTRAINT [FK_tra_PreclearanceRequest_usr_DMATDetails_DmatDetailsId]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tra_PreclearanceRequest_usr_UserInfo_CreatedBy]') AND parent_object_id = OBJECT_ID(N'[dbo].[tra_PreclearanceRequest]'))
ALTER TABLE [dbo].[tra_PreclearanceRequest]  WITH CHECK ADD  CONSTRAINT [FK_tra_PreclearanceRequest_usr_UserInfo_CreatedBy] FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[usr_UserInfo] ([UserInfoId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tra_PreclearanceRequest_usr_UserInfo_CreatedBy]') AND parent_object_id = OBJECT_ID(N'[dbo].[tra_PreclearanceRequest]'))
ALTER TABLE [dbo].[tra_PreclearanceRequest] CHECK CONSTRAINT [FK_tra_PreclearanceRequest_usr_UserInfo_CreatedBy]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tra_PreclearanceRequest_usr_UserInfo_ModifiedBy]') AND parent_object_id = OBJECT_ID(N'[dbo].[tra_PreclearanceRequest]'))
ALTER TABLE [dbo].[tra_PreclearanceRequest]  WITH CHECK ADD  CONSTRAINT [FK_tra_PreclearanceRequest_usr_UserInfo_ModifiedBy] FOREIGN KEY([ModifiedBy])
REFERENCES [dbo].[usr_UserInfo] ([UserInfoId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tra_PreclearanceRequest_usr_UserInfo_ModifiedBy]') AND parent_object_id = OBJECT_ID(N'[dbo].[tra_PreclearanceRequest]'))
ALTER TABLE [dbo].[tra_PreclearanceRequest] CHECK CONSTRAINT [FK_tra_PreclearanceRequest_usr_UserInfo_ModifiedBy]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tra_PreclearanceRequest_usr_UserInfo_UserInfoId]') AND parent_object_id = OBJECT_ID(N'[dbo].[tra_PreclearanceRequest]'))
ALTER TABLE [dbo].[tra_PreclearanceRequest]  WITH CHECK ADD  CONSTRAINT [FK_tra_PreclearanceRequest_usr_UserInfo_UserInfoId] FOREIGN KEY([UserInfoId])
REFERENCES [dbo].[usr_UserInfo] ([UserInfoId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tra_PreclearanceRequest_usr_UserInfo_UserInfoId]') AND parent_object_id = OBJECT_ID(N'[dbo].[tra_PreclearanceRequest]'))
ALTER TABLE [dbo].[tra_PreclearanceRequest] CHECK CONSTRAINT [FK_tra_PreclearanceRequest_usr_UserInfo_UserInfoId]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tra_PreclearanceRequest_usr_UserInfo_UserInfoIdRelative]') AND parent_object_id = OBJECT_ID(N'[dbo].[tra_PreclearanceRequest]'))
ALTER TABLE [dbo].[tra_PreclearanceRequest]  WITH CHECK ADD  CONSTRAINT [FK_tra_PreclearanceRequest_usr_UserInfo_UserInfoIdRelative] FOREIGN KEY([UserInfoIdRelative])
REFERENCES [dbo].[usr_UserInfo] ([UserInfoId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tra_PreclearanceRequest_usr_UserInfo_UserInfoIdRelative]') AND parent_object_id = OBJECT_ID(N'[dbo].[tra_PreclearanceRequest]'))
ALTER TABLE [dbo].[tra_PreclearanceRequest] CHECK CONSTRAINT [FK_tra_PreclearanceRequest_usr_UserInfo_UserInfoIdRelative]
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tra_PreclearanceRequest_SecuritiesToBeTradedValue]') AND parent_object_id = OBJECT_ID(N'[dbo].[tra_PreclearanceRequest]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tra_PreclearanceRequest_SecuritiesToBeTradedValue]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tra_PreclearanceRequest] ADD  CONSTRAINT [DF_tra_PreclearanceRequest_SecuritiesToBeTradedValue]  DEFAULT ((0)) FOR [SecuritiesToBeTradedValue]
END


End
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tra_PreclearanceRequest_IsPartiallyTraded]') AND parent_object_id = OBJECT_ID(N'[dbo].[tra_PreclearanceRequest]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tra_PreclearanceRequest_IsPartiallyTraded]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tra_PreclearanceRequest] ADD  CONSTRAINT [DF_tra_PreclearanceRequest_IsPartiallyTraded]  DEFAULT ((1)) FOR [IsPartiallyTraded]
END


End
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tra_PreclearanceRequest_ShowAddButton]') AND parent_object_id = OBJECT_ID(N'[dbo].[tra_PreclearanceRequest]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tra_PreclearanceRequest_ShowAddButton]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tra_PreclearanceRequest] ADD  CONSTRAINT [DF_tra_PreclearanceRequest_ShowAddButton]  DEFAULT ((0)) FOR [ShowAddButton]
END


End
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tra_PreclearanceRequest_IsAutoApproved]') AND parent_object_id = OBJECT_ID(N'[dbo].[tra_PreclearanceRequest]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tra_PreclearanceRequest_IsAutoApproved]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tra_PreclearanceRequest] ADD  CONSTRAINT [DF_tra_PreclearanceRequest_IsAutoApproved]  DEFAULT ((0)) FOR [IsAutoApproved]
END


End
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tra_PreclearanceRequest_EsopQtyFlg]') AND parent_object_id = OBJECT_ID(N'[dbo].[tra_PreclearanceRequest]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tra_PreclearanceRequest_EsopQtyFlg]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tra_PreclearanceRequest] ADD  CONSTRAINT [DF_tra_PreclearanceRequest_EsopQtyFlg]  DEFAULT ((0)) FOR [ESOPExcerciseOptionQtyFlag]
END


End
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tra_PreclearanceRequest_OtherQtyFlg]') AND parent_object_id = OBJECT_ID(N'[dbo].[tra_PreclearanceRequest]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tra_PreclearanceRequest_OtherQtyFlg]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tra_PreclearanceRequest] ADD  CONSTRAINT [DF_tra_PreclearanceRequest_OtherQtyFlg]  DEFAULT ((0)) FOR [OtherESOPExcerciseOptionQtyFlag]
END


End
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tra_PreclearanceRequest_EsopQty]') AND parent_object_id = OBJECT_ID(N'[dbo].[tra_PreclearanceRequest]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tra_PreclearanceRequest_EsopQty]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tra_PreclearanceRequest] ADD  CONSTRAINT [DF_tra_PreclearanceRequest_EsopQty]  DEFAULT ((0)) FOR [ESOPExcerciseOptionQty]
END


End
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tra_PreclearanceRequest_OtherQty]') AND parent_object_id = OBJECT_ID(N'[dbo].[tra_PreclearanceRequest]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tra_PreclearanceRequest_OtherQty]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tra_PreclearanceRequest] ADD  CONSTRAINT [DF_tra_PreclearanceRequest_OtherQty]  DEFAULT ((0)) FOR [OtherExcerciseOptionQty]
END


End
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ReasonForApproval' AND OBJECT_ID = OBJECT_ID(N'[tra_PreclearanceRequest]'))
BEGIN
	ALTER TABLE tra_PreclearanceRequest ADD ReasonForApproval NVARCHAR(200)
END 
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ReasonForApprovalCodeId' AND OBJECT_ID = OBJECT_ID(N'[tra_PreclearanceRequest]'))
BEGIN
	ALTER TABLE tra_PreclearanceRequest ADD ReasonForApprovalCodeId INT
END
GO