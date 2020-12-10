CREATE TABLE [dbo].[tra_HistoricPreclearanceRequest](
	[PreclearanceRequestId] [bigint] IDENTITY(1,1) NOT NULL,	--Primarykey
	[PreclearanceRequestForCodeId] [int] NOT NULL,				--Self or Relative
	[UserInfoId] [int] NOT NULL,								--UserId of the insider
	[UserInfoIdRelative] [int] NULL,							--Relative userid if preclearance is for relative
	[TransactionTypeCodeId] [int] NOT NULL,						--Transaction type
	[SecurityTypeCodeId] [int] NOT NULL,						--Security type
	CompanyId			[int] NOT NULL,							--Company Id
	[SecuritiesToBeTradedQty] [decimal](15, 4) NOT NULL,		--Security quantity
	[SecuritiesToBeTradedValue] [decimal](20, 4) NOT NULL,		--Security value
	[PreclearanceStatusCodeId] [int] NOT NULL,					--PreclearanceStatus
	[ProposedTradeRateRangeFrom] [decimal](15, 4) NOT NULL,		--Range from for the preclearance
	[ProposedTradeRateRangeTo] [decimal](15, 4) NOT NULL,		--Range to for the preclearance
	[DMATDetailsID] [int] NOT NULL,								--Demat account used for preclearance
	DateApplyingForPreClearance DATETIME,						--Date applying for preclearance
	DateForApprovalRejection	DATETIME						--Date of Approval or rejection
 CONSTRAINT [PK_tra_HistoricPreclearanceRequest] PRIMARY KEY CLUSTERED 
(
	[PreclearanceRequestId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
--------------------------------------------------------------------------------------------------------
CREATE TABLE [dbo].[tra_HistoricTransactionMaster](
	[TransactionMasterId] [bigint] IDENTITY(1,1) NOT NULL,
	[PreclearanceRequestId] [bigint] NULL,
	[UserInfoId] [int] NOT NULL,
	[DisclosureTypeCodeId] [int] NOT NULL,
	[NoHoldingFlag] [bit] NOT NULL,
	[SecurityTypeCodeId] [int] NULL,
 CONSTRAINT [PK_tra_HistoricTransactionMaster] PRIMARY KEY CLUSTERED 
(
	[TransactionMasterId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [dbo].[tra_HistoricTransactionMaster]  WITH CHECK ADD  CONSTRAINT [FK_tra_HistoricPreclearanceRequest_tra_HistoricTransactionMaster_PreclearanceRequestId] FOREIGN KEY([PreclearanceRequestId])
REFERENCES [dbo].[tra_HistoricPreclearanceRequest] ([PreclearanceRequestId])
GO

ALTER TABLE [dbo].[tra_HistoricTransactionMaster] CHECK CONSTRAINT [FK_tra_HistoricPreclearanceRequest_tra_HistoricTransactionMaster_PreclearanceRequestId]
GO

-----------------------------------------------------------------------------------------------------------
CREATE TABLE [dbo].[tra_HistoricTransactionDetails](
	[TransactionDetailsId] [bigint] IDENTITY(1,1) NOT NULL,
	[TransactionMasterId] [bigint] NOT NULL,
	[SecurityTypeCodeId] [int] NOT NULL,
	[ForUserInfoId] [int] NOT NULL,
	[DMATDetailsID] [int] NOT NULL,
	[CompanyId] [int] NOT NULL,
	[SecuritiesPriorToAcquisition] [decimal](10, 0) NOT NULL,
	[PerOfSharesPreTransaction] [decimal](5, 2) NOT NULL,
	[DateOfAcquisition] [datetime] NOT NULL,
	[DateOfInitimationToCompany] [datetime] NOT NULL,
	[ModeOfAcquisitionCodeId] [int] NOT NULL,
	[PerOfSharesPostTransaction] [decimal](5, 2) NOT NULL,
	[ExchangeCodeId] [int] NOT NULL,
	[TransactionTypeCodeId] [int] NOT NULL,
	[Quantity] [decimal](10, 0) NOT NULL,
	[Value] [decimal](10, 0) NOT NULL,
	[Quantity2] [decimal](10, 0) NOT NULL,
	[Value2] [decimal](10, 0) NOT NULL,
	[LotSize] [int] NOT NULL,
	[IsPLCReq] [int] NOT NULL,
	[ContractSpecification] [varchar](50) NULL,
 CONSTRAINT [PK_tra_HistoricTransactionDetails] PRIMARY KEY CLUSTERED 
(
	[TransactionDetailsId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[tra_HistoricTransactionDetails]  WITH CHECK ADD  CONSTRAINT [FK_tra_HistoricTransactionMaster_tra_HistoricTransactionDetails_TransactionMasterId] FOREIGN KEY([TransactionMasterId])
REFERENCES [dbo].[tra_HistoricTransactionMaster] ([TransactionMasterId])
GO

ALTER TABLE [dbo].[tra_HistoricTransactionDetails] CHECK CONSTRAINT [FK_tra_HistoricTransactionMaster_tra_HistoricTransactionDetails_TransactionMasterId]
GO

------------------------------------------------------------------------------------------------------------------------

INSERT INTO DBUpdateStatus (ScriptNumber, ScriptFileName, Description, CreatedBy)
VALUES (218, '218 tra_HistoricDataTables_Create', 'create HistoricTransaction tables', 'Raghvendra')
