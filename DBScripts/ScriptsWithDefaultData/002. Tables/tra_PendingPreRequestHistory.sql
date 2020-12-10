
GO

/****** Object:  Table [dbo].[tra_PendingPreRequestHistory]    Script Date: 09/10/2018 15:39:30 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tra_PendingPreRequestHistory]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tra_PendingPreRequestHistory](
	[PreclearanceRequestId] [bigint]  NOT NULL,
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
	[PledgeOptionQty] [decimal](15, 4) NOT NULL,
	[ModeOfAcquisitionCodeId] [int] NOT NULL,
	[PreclearanceApprovedBy] [int] NULL,
	[PreclearanceApprovedOn] [datetime] NULL,
	[ReasonForApproval] [nvarchar](200) NULL,
	[ReasonForApprovalCodeId] [int] NULL,
 CONSTRAINT [PK_tra_PendingPreRequestHistory] PRIMARY KEY CLUSTERED 
(
	[PreclearanceRequestId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO

SET ANSI_PADDING OFF
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Refers com_Code, CodeGroupId = 142
142001: Self
142002: Relative' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tra_PendingPreRequestHistory', @level2type=N'COLUMN',@level2name=N'PreclearanceRequestForCodeId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Refers usr_UserInfo. Id of the user for whom, or whose relative, the request is to be made.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tra_PendingPreRequestHistory', @level2type=N'COLUMN',@level2name=N'UserInfoId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Refers com_Code, CodeGroupId = 143
143001: Buy
143002: Sell' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tra_PendingPreRequestHistory', @level2type=N'COLUMN',@level2name=N'TransactionTypeCodeId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Refers com_Code, CodeGroupId = 144
144001: Confirmed
144002: Approved
144003: Rejected' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tra_PendingPreRequestHistory', @level2type=N'COLUMN',@level2name=N'SecurityTypeCodeId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Refers com_Code, CodeGroupId = 146
146001: Equity
146002: Derivative' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tra_PendingPreRequestHistory', @level2type=N'COLUMN',@level2name=N'PreclearanceStatusCodeId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Refers com_Code, CodeGroupId = 145' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tra_PendingPreRequestHistory', @level2type=N'COLUMN',@level2name=N'ReasonForNotTradingCodeId'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'When preclearance request is rejected, user will give rejection reason.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tra_PendingPreRequestHistory', @level2type=N'COLUMN',@level2name=N'ReasonForRejection'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'1: Partially Traded (Total Qty < PCL Qty),
0:Traded fully or excess (Total Qty >= PCLQty)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tra_PendingPreRequestHistory', @level2type=N'COLUMN',@level2name=N'IsPartiallyTraded'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0:Do not Show Add button (If atleast one transaction not submitted or TotalQty >= PCL)
1: Show Add button (All transactions are submitted and TotalQty < PCLQty)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tra_PendingPreRequestHistory', @level2type=N'COLUMN',@level2name=N'ShowAddButton'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'To indicate if preclearance is auto approved. 0=not auto approved, 1=auto approved.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tra_PendingPreRequestHistory', @level2type=N'COLUMN',@level2name=N'IsAutoApproved'
GO

ALTER TABLE [dbo].[tra_PendingPreRequestHistory]  WITH CHECK ADD  CONSTRAINT [FK_tra_PendingPreRequestHistory_com_Code_PreclearanceRequestFor] FOREIGN KEY([PreclearanceRequestForCodeId])
REFERENCES [dbo].[com_Code] ([CodeID])
GO

ALTER TABLE [dbo].[tra_PendingPreRequestHistory] CHECK CONSTRAINT [FK_tra_PendingPreRequestHistory_com_Code_PreclearanceRequestFor]
GO

ALTER TABLE [dbo].[tra_PendingPreRequestHistory]  WITH CHECK ADD  CONSTRAINT [FK_tra_PendingPreRequestHistory_com_Code_PreclearanceStatusCode] FOREIGN KEY([PreclearanceStatusCodeId])
REFERENCES [dbo].[com_Code] ([CodeID])
GO

ALTER TABLE [dbo].[tra_PendingPreRequestHistory] CHECK CONSTRAINT [FK_tra_PendingPreRequestHistory_com_Code_PreclearanceStatusCode]
GO

ALTER TABLE [dbo].[tra_PendingPreRequestHistory]  WITH CHECK ADD  CONSTRAINT [FK_tra_PendingPreRequestHistory_com_Code_ReasonForNotTrading] FOREIGN KEY([ReasonForNotTradingCodeId])
REFERENCES [dbo].[com_Code] ([CodeID])
GO

ALTER TABLE [dbo].[tra_PendingPreRequestHistory] CHECK CONSTRAINT [FK_tra_PendingPreRequestHistory_com_Code_ReasonForNotTrading]
GO

ALTER TABLE [dbo].[tra_PendingPreRequestHistory]  WITH CHECK ADD  CONSTRAINT [FK_tra_PendingPreRequestHistory_com_Code_SecurityTypeCode] FOREIGN KEY([SecurityTypeCodeId])
REFERENCES [dbo].[com_Code] ([CodeID])
GO

ALTER TABLE [dbo].[tra_PendingPreRequestHistory] CHECK CONSTRAINT [FK_tra_PendingPreRequestHistory_com_Code_SecurityTypeCode]
GO

ALTER TABLE [dbo].[tra_PendingPreRequestHistory]  WITH CHECK ADD  CONSTRAINT [FK_tra_PendingPreRequestHistory_com_Code_TransactionTypeCode] FOREIGN KEY([TransactionTypeCodeId])
REFERENCES [dbo].[com_Code] ([CodeID])
GO

ALTER TABLE [dbo].[tra_PendingPreRequestHistory] CHECK CONSTRAINT [FK_tra_PendingPreRequestHistory_com_Code_TransactionTypeCode]
GO

ALTER TABLE [dbo].[tra_PendingPreRequestHistory]  WITH CHECK ADD  CONSTRAINT [FK_tra_PendingPreRequestHistory_mst_Company_CompanyId] FOREIGN KEY([CompanyId])
REFERENCES [dbo].[mst_Company] ([CompanyId])
GO

ALTER TABLE [dbo].[tra_PendingPreRequestHistory] CHECK CONSTRAINT [FK_tra_PendingPreRequestHistory_mst_Company_CompanyId]
GO

ALTER TABLE [dbo].[tra_PendingPreRequestHistory]  WITH CHECK ADD  CONSTRAINT [FK_tra_PendingPreRequestHistory_PreclearanceApprovedBy_usr_UserInfo_UserInfoId] FOREIGN KEY([PreclearanceApprovedBy])
REFERENCES [dbo].[usr_UserInfo] ([UserInfoId])
GO

ALTER TABLE [dbo].[tra_PendingPreRequestHistory] CHECK CONSTRAINT [FK_tra_PendingPreRequestHistory_PreclearanceApprovedBy_usr_UserInfo_UserInfoId]
GO

ALTER TABLE [dbo].[tra_PendingPreRequestHistory]  WITH CHECK ADD  CONSTRAINT [FK_tra_PendingPreRequestHistory_usr_DMATDetails_DmatDetailsId] FOREIGN KEY([DMATDetailsID])
REFERENCES [dbo].[usr_DMATDetails] ([DMATDetailsID])
GO

ALTER TABLE [dbo].[tra_PendingPreRequestHistory] CHECK CONSTRAINT [FK_tra_PendingPreRequestHistory_usr_DMATDetails_DmatDetailsId]
GO

ALTER TABLE [dbo].[tra_PendingPreRequestHistory]  WITH CHECK ADD  CONSTRAINT [FK_tra_PendingPreRequestHistory_usr_UserInfo_CreatedBy] FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[usr_UserInfo] ([UserInfoId])
GO

ALTER TABLE [dbo].[tra_PendingPreRequestHistory] CHECK CONSTRAINT [FK_tra_PendingPreRequestHistory_usr_UserInfo_CreatedBy]
GO

ALTER TABLE [dbo].[tra_PendingPreRequestHistory]  WITH CHECK ADD  CONSTRAINT [FK_tra_PendingPreRequestHistory_usr_UserInfo_ModifiedBy] FOREIGN KEY([ModifiedBy])
REFERENCES [dbo].[usr_UserInfo] ([UserInfoId])
GO

ALTER TABLE [dbo].[tra_PendingPreRequestHistory] CHECK CONSTRAINT [FK_tra_PendingPreRequestHistory_usr_UserInfo_ModifiedBy]
GO

ALTER TABLE [dbo].[tra_PendingPreRequestHistory]  WITH CHECK ADD  CONSTRAINT [FK_tra_PendingPreRequestHistory_usr_UserInfo_UserInfoId] FOREIGN KEY([UserInfoId])
REFERENCES [dbo].[usr_UserInfo] ([UserInfoId])
GO

ALTER TABLE [dbo].[tra_PendingPreRequestHistory] CHECK CONSTRAINT [FK_tra_PendingPreRequestHistory_usr_UserInfo_UserInfoId]
GO

ALTER TABLE [dbo].[tra_PendingPreRequestHistory]  WITH CHECK ADD  CONSTRAINT [FK_tra_PendingPreRequestHistory_usr_UserInfo_UserInfoIdRelative] FOREIGN KEY([UserInfoIdRelative])
REFERENCES [dbo].[usr_UserInfo] ([UserInfoId])
GO

ALTER TABLE [dbo].[tra_PendingPreRequestHistory] CHECK CONSTRAINT [FK_tra_PendingPreRequestHistory_usr_UserInfo_UserInfoIdRelative]
GO

ALTER TABLE [dbo].[tra_PendingPreRequestHistory] ADD  CONSTRAINT [DF_tra_PendingPreRequestHistory_SecuritiesToBeTradedValue]  DEFAULT ((0)) FOR [SecuritiesToBeTradedValue]
GO

ALTER TABLE [dbo].[tra_PendingPreRequestHistory] ADD  CONSTRAINT [DF_tra_PendingPreRequestHistory_IsPartiallyTraded]  DEFAULT ((1)) FOR [IsPartiallyTraded]
GO

ALTER TABLE [dbo].[tra_PendingPreRequestHistory] ADD  CONSTRAINT [DF_tra_PendingPreRequestHistory_ShowAddButton]  DEFAULT ((0)) FOR [ShowAddButton]
GO

ALTER TABLE [dbo].[tra_PendingPreRequestHistory] ADD  CONSTRAINT [DF_tra_PendingPreRequestHistory_IsAutoApproved]  DEFAULT ((0)) FOR [IsAutoApproved]
GO

ALTER TABLE [dbo].[tra_PendingPreRequestHistory] ADD  CONSTRAINT [DF_tra_PendingPreRequestHistory_EsopQtyFlg]  DEFAULT ((0)) FOR [ESOPExcerciseOptionQtyFlag]
GO

ALTER TABLE [dbo].[tra_PendingPreRequestHistory] ADD  CONSTRAINT [DF_tra_PendingPreRequestHistory_OtherQtyFlg]  DEFAULT ((0)) FOR [OtherESOPExcerciseOptionQtyFlag]
GO

ALTER TABLE [dbo].[tra_PendingPreRequestHistory] ADD  CONSTRAINT [DF_tra_PendingPreRequestHistory_EsopQty]  DEFAULT ((0)) FOR [ESOPExcerciseOptionQty]
GO

ALTER TABLE [dbo].[tra_PendingPreRequestHistory] ADD  CONSTRAINT [DF_tra_PendingPreRequestHistory_OtherQty]  DEFAULT ((0)) FOR [OtherExcerciseOptionQty]
GO

ALTER TABLE [dbo].[tra_PendingPreRequestHistory] ADD  DEFAULT ((0)) FOR [PledgeOptionQty]
GO

ALTER TABLE [dbo].[tra_PendingPreRequestHistory] ADD  DEFAULT ((0)) FOR [ModeOfAcquisitionCodeId]
GO

ALTER TABLE [dbo].[tra_PendingPreRequestHistory] ADD  DEFAULT (NULL) FOR [PreclearanceApprovedBy]
GO

ALTER TABLE [dbo].[tra_PendingPreRequestHistory] ADD  DEFAULT (NULL) FOR [PreclearanceApprovedOn]
GO


