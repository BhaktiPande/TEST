/****** Object:  Table [dbo].[tra_HistoricPreclearanceRequest]    Script Date: 06/07/2016 12:05:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tra_HistoricPreclearanceRequest]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tra_HistoricPreclearanceRequest](
	[PreclearanceRequestId] [bigint] IDENTITY(1,1) NOT NULL,
	[PreclearanceRequestForCodeId] [int] NOT NULL,
	[UserInfoId] [int] NOT NULL,
	[UserInfoIdRelative] [int] NULL,
	[TransactionTypeCodeId] [int] NOT NULL,
	[SecurityTypeCodeId] [int] NOT NULL,
	[CompanyId] [int] NOT NULL,
	[SecuritiesToBeTradedQty] [decimal](15, 4) NOT NULL,
	[SecuritiesToBeTradedValue] [decimal](20, 4) NOT NULL,
	[PreclearanceStatusCodeId] [int] NOT NULL,
	[ProposedTradeRateRangeFrom] [decimal](15, 4) NOT NULL,
	[ProposedTradeRateRangeTo] [decimal](15, 4) NOT NULL,
	[DMATDetailsID] [int] NOT NULL,
	[DateApplyingForPreClearance] [datetime] NULL,
	[DateForApprovalRejection] [datetime] NULL,
 CONSTRAINT [PK_tra_HistoricPreclearanceRequest] PRIMARY KEY CLUSTERED 
(
	[PreclearanceRequestId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
