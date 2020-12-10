GO
/****** Object:  Table [dbo].[rul_TradingPolicy_OS]    Script Date: 2/6/2019 4:47:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[rul_TradingPolicy_OS](
	[TradingPolicyId] [int] IDENTITY(1,1) NOT NULL,
	[TradingPolicyParentId] [int] NULL,
	[CurrentHistoryCodeId] [int] NULL,
	[TradingPolicyForCodeId] [int] NULL,
	[TradingPolicyName] [nvarchar](100) NOT NULL,
	[TradingPolicyDescription] [nvarchar](1024) NULL,
	[ApplicableFromDate] [datetime] NULL,
	[ApplicableToDate] [datetime] NULL,
	[PreClrTradesApprovalReqFlag] [bit] NOT NULL CONSTRAINT [DF_rul_TradingPolicy_OS_PreClrTradesApprovalReqFlag]  DEFAULT ((0)),
	[PreClrTradesAutoApprovalReqFlag] [bit] NULL,
	[PreClrSingMultiPreClrFlagCodeId] [int] NULL,
	[PreClrSingleTransTradeNoShares] [int] NULL,
	[PreClrSingleTransTradePercPaidSubscribedCap] [decimal](15, 4) NULL,
	[PreClrProhibitNonTradePeriodFlag] [bit] NOT NULL CONSTRAINT [DF_rul_TradingPolicy_OS_PreClrProhibitNonTradePeriodFlag]  DEFAULT ((1)),
	[PreClrCOApprovalLimit] [int] NULL,
	[PreClrApprovalValidityLimit] [int] NULL,
	[PreClrSeekDeclarationForUPSIFlag] [bit] NOT NULL CONSTRAINT [DF_rul_TradingPolicy_OS_PreClrSeekDeclarationForUPSIFlag]  DEFAULT ((0)),
	[PreClrUPSIDeclaration] [varchar](5000) NULL,
	[PreClrReasonForNonTradeReqFlag] [bit] NOT NULL CONSTRAINT [DF_rul_TradingPolicy_OS_PreClrReasonForNonTradeReqFlag]  DEFAULT ((0)),
	[PreClrCompleteTradeNotDoneFlag] [bit] NOT NULL CONSTRAINT [DF_rul_TradingPolicy_OS_PreClrCompleteTradeNotDoneFlag]  DEFAULT ((0)),
	[PreClrPartialTradeNotDoneFlag] [bit] NOT NULL CONSTRAINT [DF_rul_TradingPolicy_OS_PreClrPartialTradeNotDoneFlag]  DEFAULT ((0)),
	[PreClrTradeDiscloLimit] [int] NULL,
	[PreClrTradeDiscloShareholdLimit] [int] NULL,
	[PreClrForAllSecuritiesFlag] [bit] NOT NULL CONSTRAINT [DF_rul_TradingPolicy_OS_PreClrForAllSecuritiesFlag]  DEFAULT ((0)),
	[PreClrAllowNewForOpenPreclearFlag] [bit] NOT NULL CONSTRAINT [DF_rul_TradingPolicy_OS_PreClrAllowNewForOpenPreclearFlag]  DEFAULT ((0)),
	[PreClrMultipleAboveInCodeId] [int] NULL,
	[PreClrApprovalPreclearORPreclearTradeFlag] [int] NOT NULL CONSTRAINT [DF_rul_TradingPolicy_OS_PreClrApprovalPreclearORPreclearTradeFlag]  DEFAULT ((0)),
	[StExSubmitTradeDiscloAllTradeFlag] [bit] NOT NULL CONSTRAINT [DF_rul_TradingPolicy_OS_StExSubmitTradeDiscloAllTradeFlag]  DEFAULT ((0)),
	[StExSingMultiTransTradeFlagCodeId] [int] NULL,
	[StExMultiTradeFreq] [int] NULL,
	[StExMultiTradeCalFinYear] [int] NULL,
	[StExTransTradeNoShares] [int] NULL,
	[StExTransTradePercPaidSubscribedCap] [decimal](15, 4) NULL,
	[StExTransTradeShareValue] [int] NULL,
	[StExTradeDiscloSubmitLimit] [int] NULL,
	[DiscloInitReqFlag] [bit] NOT NULL CONSTRAINT [DF_rul_TradingPolicy_OS_DiscloInitReqFlag]  DEFAULT ((0)),
	[DiscloInitLimit] [int] NULL,
	[DiscloInitDateLimit] [datetime] NULL,
	[DiscloPeriodEndReqFlag] [bit] NOT NULL CONSTRAINT [DF_rul_TradingPolicy_OS_DiscloPeriodEndReqFlag]  DEFAULT ((0)),
	[DiscloPeriodEndFreq] [int] NULL,
	[GenSecurityType] [varchar](1024) NULL,
	[GenTradingPlanTransFlag] [bit] NOT NULL CONSTRAINT [DF_rul_TradingPolicy_OS_GenTradingPlanTransFlag]  DEFAULT ((0)),
	[GenMinHoldingLimit] [int] NULL,
	[GenContraTradeNotAllowedLimit] [int] NULL,
	[GenExceptionFor] [varchar](1024) NULL,
	[TradingPolicyStatusCodeId] [int] NULL,
	[DiscloInitSubmitToStExByCOFlag] [bit] NULL CONSTRAINT [DF_rul_TradingPolicy_OS_DiscloInitSubmitToStExByCOFlag]  DEFAULT ((0)),
	[StExSubmitDiscloToStExByCOFlag] [bit] NULL CONSTRAINT [DF_rul_TradingPolicy_OS_StExSubmitDiscloToStExByCOFlag]  DEFAULT ((0)),
	[DiscloPeriodEndToCOByInsdrLimit] [int] NULL,
	[DiscloPeriodEndSubmitToStExByCOFlag] [bit] NULL CONSTRAINT [DF_rul_TradingPolicy_OS_DiscloPeriodEndSubmitToStExByCOFlag]  DEFAULT ((0)),
	[DiscloPeriodEndSubmitToStExByCOLimit] [int] NULL,
	[DiscloInitReqSoftcopyFlag] [bit] NULL CONSTRAINT [DF_rul_TradingPolicy_OS_DiscloInitReqSoftcopyFlag]  DEFAULT ((0)),
	[DiscloInitReqHardcopyFlag] [bit] NULL CONSTRAINT [DF_rul_TradingPolicy_OS_DiscloInitReqHardcopyFlag]  DEFAULT ((0)),
	[DiscloInitSubmitToStExByCOSoftcopyFlag] [bit] NULL CONSTRAINT [DF_rul_TradingPolicy_OS_DiscloInitSubmitToStExByCOSoftcopyFlag]  DEFAULT ((0)),
	[DiscloInitSubmitToStExByCOHardcopyFlag] [bit] NULL CONSTRAINT [DF_rul_TradingPolicy_OS_DiscloInitSubmitToStExByCOHardcopyFlag]  DEFAULT ((0)),
	[StExTradePerformDtlsSubmitToCOByInsdrLimit] [int] NULL,
	[StExSubmitDiscloToStExByCOSoftcopyFlag] [bit] NULL CONSTRAINT [DF_rul_TradingPolicy_OS_StExSubmitDiscloToStExByCOSoftcopyFlag]  DEFAULT ((0)),
	[StExSubmitDiscloToStExByCOHardcopyFlag] [bit] NULL CONSTRAINT [DF_rul_TradingPolicy_OS_StExSubmitDiscloToStExByCOHardcopyFlag]  DEFAULT ((0)),
	[DiscloPeriodEndReqSoftcopyFlag] [bit] NULL CONSTRAINT [DF_rul_TradingPolicy_OS_DiscloPeriodEndReqSoftcopyFlag]  DEFAULT ((0)),
	[DiscloPeriodEndReqHardcopyFlag] [bit] NULL CONSTRAINT [DF_rul_TradingPolicy_OS_DiscloPeriodEndReqHardcopyFlag]  DEFAULT ((0)),
	[DiscloPeriodEndSubmitToStExByCOSoftcopyFlag] [bit] NULL CONSTRAINT [DF_rul_TradingPolicy_OS_DiscloPeriodEndSubmitToStExByCOSoftcopyFlag]  DEFAULT ((0)),
	[DiscloPeriodEndSubmitToStExByCOHardcopyFlag] [bit] NULL CONSTRAINT [DF_rul_TradingPolicy_OS_DiscloPeriodEndSubmitToStExByCOHardcopyFlag]  DEFAULT ((0)),
	[StExSubmitDiscloToCOByInsdrFlag] [bit] NULL CONSTRAINT [DF_rul_TradingPolicy_OS_StExSubmitDiscloToCOByInsdrFlag]  DEFAULT ((0)),
	[StExSubmitDiscloToCOByInsdrSoftcopyFlag] [bit] NULL CONSTRAINT [DF_rul_TradingPolicy_OS_StExSubmitDiscloToCOByInsdrSoftcopyFlag]  DEFAULT ((0)),
	[StExSubmitDiscloToCOByInsdrHardcopyFlag] [bit] NULL CONSTRAINT [DF_rul_TradingPolicy_OS_StExSubmitDiscloToCOByInsdrHardcopyFlag]  DEFAULT ((0)),
	[StExForAllSecuritiesFlag] [bit] NOT NULL CONSTRAINT [DF_rul_TradingPolicy_OS_StExForAllSecuritiesFlag]  DEFAULT ((0)),
	[IsDeletedFlag] [bit] NOT NULL CONSTRAINT [DF_rul_TradingPolicy_OS_IsDeletedFlag]  DEFAULT ((0)),
	[CreatedBy] [int] NULL,
	[CreatedOn] [datetime] NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedOn] [datetime] NULL,
	[GenCashAndCashlessPartialExciseOptionForContraTrade] [int] NOT NULL DEFAULT ((172001)),
	[GenSecuritiesPriortoAcquisitionManualInputorAutoCalculate] [bit] NOT NULL DEFAULT ((0)),
	[TradingThresholdLimtResetFlag] [bit] NULL,
	[ContraTradeBasedOn] [int] NOT NULL DEFAULT ((177001)),
	[SeekDeclarationFromEmpRegPossessionOfUPSIFlag] [bit] NULL,
	[DeclarationFromInsiderAtTheTimeOfContinuousDisclosures] [varchar](max) NULL,
	[DeclarationToBeMandatoryFlag] [bit] NULL,
	[DisplayDeclarationPostSubmissionOfContinuouseDisclosureFlag] [bit] NULL,
	[IsPreclearanceFormForImplementingCompany] [bit] NOT NULL DEFAULT ((0)),
	[PreclearanceWithoutPeriodEndDisclosure] [int] NOT NULL DEFAULT ((188003)),
	[PreClrApprovalReasonReqFlag] [bit] NULL,
	[IsProhibitPreClrFunctionalityApplicable] [bit] NULL DEFAULT ((0)),
	[ProhibitPreClrPercentageAppFlag] [bit] NULL DEFAULT ((0)),
	[ProhibitPreClrOnPercentage] [decimal](5, 2) NULL,
	[ProhibitPreClrOnQuantityAppFlag] [bit] NULL DEFAULT ((0)),
	[ProhibitPreClrOnQuantity] [decimal](10, 0) NULL,
	[ProhibitPreClrForPeriod] [int] NULL,
	[ProhibitPreClrForAllSecurityType] [bit] NULL DEFAULT ((0)),
 CONSTRAINT [PK_rul_TradingPolicy_OS] PRIMARY KEY CLUSTERED 
(
	[TradingPolicyId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[rul_TradingPolicy_OS]  WITH CHECK ADD  CONSTRAINT [FK_rul_TradingPolicy_OS_com_Code_CurrentHistoryCodeId] FOREIGN KEY([CurrentHistoryCodeId])
REFERENCES [dbo].[com_Code] ([CodeID])
GO
ALTER TABLE [dbo].[rul_TradingPolicy_OS] CHECK CONSTRAINT [FK_rul_TradingPolicy_OS_com_Code_CurrentHistoryCodeId]
GO
ALTER TABLE [dbo].[rul_TradingPolicy_OS]  WITH CHECK ADD  CONSTRAINT [FK_rul_TradingPolicy_OS_com_Code_DiscloPeriodEndFreq] FOREIGN KEY([DiscloPeriodEndFreq])
REFERENCES [dbo].[com_Code] ([CodeID])
GO
ALTER TABLE [dbo].[rul_TradingPolicy_OS] CHECK CONSTRAINT [FK_rul_TradingPolicy_OS_com_Code_DiscloPeriodEndFreq]
GO
ALTER TABLE [dbo].[rul_TradingPolicy_OS]  WITH CHECK ADD  CONSTRAINT [FK_rul_TradingPolicy_OS_com_Code_PreClrSingMultiPreClrFlagCodeId] FOREIGN KEY([PreClrSingMultiPreClrFlagCodeId])
REFERENCES [dbo].[com_Code] ([CodeID])
GO
ALTER TABLE [dbo].[rul_TradingPolicy_OS] CHECK CONSTRAINT [FK_rul_TradingPolicy_OS_com_Code_PreClrSingMultiPreClrFlagCodeId]
GO
ALTER TABLE [dbo].[rul_TradingPolicy_OS]  WITH CHECK ADD  CONSTRAINT [FK_rul_TradingPolicy_OS_com_Code_StExMultiTradeCalFinYear] FOREIGN KEY([StExMultiTradeCalFinYear])
REFERENCES [dbo].[com_Code] ([CodeID])
GO
ALTER TABLE [dbo].[rul_TradingPolicy_OS] CHECK CONSTRAINT [FK_rul_TradingPolicy_OS_com_Code_StExMultiTradeCalFinYear]
GO
ALTER TABLE [dbo].[rul_TradingPolicy_OS]  WITH CHECK ADD  CONSTRAINT [FK_rul_TradingPolicy_OS_com_Code_StExMultiTradeFreq] FOREIGN KEY([StExMultiTradeFreq])
REFERENCES [dbo].[com_Code] ([CodeID])
GO
ALTER TABLE [dbo].[rul_TradingPolicy_OS] CHECK CONSTRAINT [FK_rul_TradingPolicy_OS_com_Code_StExMultiTradeFreq]
GO
ALTER TABLE [dbo].[rul_TradingPolicy_OS]  WITH CHECK ADD  CONSTRAINT [FK_rul_TradingPolicy_OS_com_Code_StExSingMultiTransTradeFlagCodeId] FOREIGN KEY([StExSingMultiTransTradeFlagCodeId])
REFERENCES [dbo].[com_Code] ([CodeID])
GO
ALTER TABLE [dbo].[rul_TradingPolicy_OS] CHECK CONSTRAINT [FK_rul_TradingPolicy_OS_com_Code_StExSingMultiTransTradeFlagCodeId]
GO
ALTER TABLE [dbo].[rul_TradingPolicy_OS]  WITH CHECK ADD  CONSTRAINT [FK_rul_TradingPolicy_OS_com_Code_TradingPolicyForCodeId] FOREIGN KEY([TradingPolicyForCodeId])
REFERENCES [dbo].[com_Code] ([CodeID])
GO
ALTER TABLE [dbo].[rul_TradingPolicy_OS] CHECK CONSTRAINT [FK_rul_TradingPolicy_OS_com_Code_TradingPolicyForCodeId]
GO
ALTER TABLE [dbo].[rul_TradingPolicy_OS]  WITH CHECK ADD  CONSTRAINT [FK_rul_TradingPolicy_OS_com_Code_TradingPolicyStatusCodeId] FOREIGN KEY([TradingPolicyStatusCodeId])
REFERENCES [dbo].[com_Code] ([CodeID])
GO
ALTER TABLE [dbo].[rul_TradingPolicy_OS] CHECK CONSTRAINT [FK_rul_TradingPolicy_OS_com_Code_TradingPolicyStatusCodeId]
GO
ALTER TABLE [dbo].[rul_TradingPolicy_OS]  WITH CHECK ADD  CONSTRAINT [FK_rul_TradingPolicy_OS_PreclearanceWithoutPeriodEndDisclosure_com_Code_CodeID] FOREIGN KEY([PreclearanceWithoutPeriodEndDisclosure])
REFERENCES [dbo].[com_Code] ([CodeID])
GO
ALTER TABLE [dbo].[rul_TradingPolicy_OS] CHECK CONSTRAINT [FK_rul_TradingPolicy_OS_PreclearanceWithoutPeriodEndDisclosure_com_Code_CodeID]
GO
ALTER TABLE [dbo].[rul_TradingPolicy_OS]  WITH CHECK ADD  CONSTRAINT [FK_rul_TradingPolicy_OS_rul_TradingPolicy_OS] FOREIGN KEY([TradingPolicyParentId])
REFERENCES [dbo].[rul_TradingPolicy_OS] ([TradingPolicyId])
GO
ALTER TABLE [dbo].[rul_TradingPolicy_OS] CHECK CONSTRAINT [FK_rul_TradingPolicy_OS_rul_TradingPolicy_OS]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Will contain Id of record for which this is the edited record. Parent record will be the history record. First record will contain its own Id as ParentId.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_TradingPolicy_OS', @level2type=N'COLUMN',@level2name=N'TradingPolicyParentId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Refers: com_Code, XXX001: Current, XXX002: History
This will be identifier to know whether record is current / history record.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_TradingPolicy_OS', @level2type=N'COLUMN',@level2name=N'CurrentHistoryCodeId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Refers: com_Code - XXX001: Employee (Non Insider), XXX002: Employee Insider, XXX003: NonEmployee Insider, XXX004: Corporate Insider' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_TradingPolicy_OS', @level2type=N'COLUMN',@level2name=N'TradingPolicyForCodeId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0:No, 1:Yes, Default : 0 (Preclearance Approval Required for all trades)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_TradingPolicy_OS', @level2type=N'COLUMN',@level2name=N'PreClrTradesApprovalReqFlag'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0:No, 1:Yes, Default : NULL (Preclearance Auto Approval Required). This will be set to 0 or 1 only when PreClrTradesApprovalReqFlag is set to No' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_TradingPolicy_OS', @level2type=N'COLUMN',@level2name=N'PreClrTradesAutoApprovalReqFlag'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Refers: com_Code - 136001: Single , 136002: Multiple : Single pre-clearance Request, Multiple Pre-clearance request. This will be set only when PreClrTradesApprovalReqFlag is set to No' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_TradingPolicy_OS', @level2type=N'COLUMN',@level2name=N'PreClrSingMultiPreClrFlagCodeId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Preclearance Approval required for single trade transaction above number of shares' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_TradingPolicy_OS', @level2type=N'COLUMN',@level2name=N'PreClrSingleTransTradeNoShares'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Preclearance Approval required for single trade transaction above percentage of paid up and subscribed capital' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_TradingPolicy_OS', @level2type=N'COLUMN',@level2name=N'PreClrSingleTransTradePercPaidSubscribedCap'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0:No, 1:Yes, Default : 1 (as per SRS) (Prohibit pre-clearance during non-trading period)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_TradingPolicy_OS', @level2type=N'COLUMN',@level2name=N'PreClrProhibitNonTradePeriodFlag'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Preclearance approval to be given within X days by Complaince Officer' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_TradingPolicy_OS', @level2type=N'COLUMN',@level2name=N'PreClrCOApprovalLimit'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Preclearance approval validity X days (after approval is given and excluding approval day)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_TradingPolicy_OS', @level2type=N'COLUMN',@level2name=N'PreClrApprovalValidityLimit'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0:No, 1:Yes, Default : 0 (Seek declaration from employee regarding possession of UPSI' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_TradingPolicy_OS', @level2type=N'COLUMN',@level2name=N'PreClrSeekDeclarationForUPSIFlag'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Declaration sought from the insider at the time of preclearance' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_TradingPolicy_OS', @level2type=N'COLUMN',@level2name=N'PreClrUPSIDeclaration'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0:No, 1:Yes, Default : 0 (Preclearance - Reason for non-trade to be provided)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_TradingPolicy_OS', @level2type=N'COLUMN',@level2name=N'PreClrReasonForNonTradeReqFlag'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0:No, 1:Yes, Default : 0 (Complete trade not done for pre-clearance taken)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_TradingPolicy_OS', @level2type=N'COLUMN',@level2name=N'PreClrCompleteTradeNotDoneFlag'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0:No, 1:Yes, Default : 0 (Partial trade not done for pre-clearance taken)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_TradingPolicy_OS', @level2type=N'COLUMN',@level2name=N'PreClrPartialTradeNotDoneFlag'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Trade disclosure for preclearance approval transactions within X days' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_TradingPolicy_OS', @level2type=N'COLUMN',@level2name=N'PreClrTradeDiscloLimit'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Preclearance Trade disclosure within X days of change in share holdings (more than 5%)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_TradingPolicy_OS', @level2type=N'COLUMN',@level2name=N'PreClrTradeDiscloShareholdLimit'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Flag for preclearance, 1: For all securities, 0: For selected Securities' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_TradingPolicy_OS', @level2type=N'COLUMN',@level2name=N'PreClrForAllSecuritiesFlag'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Allow new preclearance to be created when earlier preclearance is open 0=No, 1=Yes' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_TradingPolicy_OS', @level2type=N'COLUMN',@level2name=N'PreClrAllowNewForOpenPreclearFlag'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Multiple preclearance above in a Monthly / Quarterly / Yearly etc' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_TradingPolicy_OS', @level2type=N'COLUMN',@level2name=N'PreClrMultipleAboveInCodeId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Preclearance approval based on Preclearance details or Preclearance and Trade details. 0=Preclearance details, 1=Preclearance and Trade details' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_TradingPolicy_OS', @level2type=N'COLUMN',@level2name=N'PreClrApprovalPreclearORPreclearTradeFlag'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0:No, 1:Yes, Default : 0 (Trade disclosures to be submitted to stock exchanges for all trades)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_TradingPolicy_OS', @level2type=N'COLUMN',@level2name=N'StExSubmitTradeDiscloAllTradeFlag'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Refers: com_Code - XXX001: Single Transaction Trade, XXX002: Multiple Transaction Trade(Stock exchange disclosure related Single or Multiple Transaction trade above)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_TradingPolicy_OS', @level2type=N'COLUMN',@level2name=N'StExSingMultiTransTradeFlagCodeId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Refers: com_Code - XXX001: Year, XXX002: Quarter, XXX003: Month, XXX004:Week(Stock exchange disclosure related Multiple transaction trade above in week, month etc)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_TradingPolicy_OS', @level2type=N'COLUMN',@level2name=N'StExMultiTradeFreq'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Refers: com_Code - XXX001:Calendar Year, XXX002: Finanacial Year(Stock exchange disclosure related Multiple transaction trade for calendar or financial year)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_TradingPolicy_OS', @level2type=N'COLUMN',@level2name=N'StExMultiTradeCalFinYear'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Stock exchange disclosure related Single or Multiple Transaction trade above number of shares' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_TradingPolicy_OS', @level2type=N'COLUMN',@level2name=N'StExTransTradeNoShares'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Stock exchange disclosure related Single or Multiple Transaction trade above % of paid up and subscribed capital' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_TradingPolicy_OS', @level2type=N'COLUMN',@level2name=N'StExTransTradePercPaidSubscribedCap'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Stock exchange disclosure related Single or Multiple Transaction trade above value of shares' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_TradingPolicy_OS', @level2type=N'COLUMN',@level2name=N'StExTransTradeShareValue'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Stock exchange disclosure related trade disclosure within X days of submision by insider/employee' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_TradingPolicy_OS', @level2type=N'COLUMN',@level2name=N'StExTradeDiscloSubmitLimit'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0:No, 1:Yes, Default : 0 (Initial disclosures required / not required)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_TradingPolicy_OS', @level2type=N'COLUMN',@level2name=N'DiscloInitReqFlag'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Initial disclosure within X days of joining / being categorized as insider' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_TradingPolicy_OS', @level2type=N'COLUMN',@level2name=N'DiscloInitLimit'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Initial disclosure before X date of application go live' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_TradingPolicy_OS', @level2type=N'COLUMN',@level2name=N'DiscloInitDateLimit'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0:No, 1:Yes, Default : 0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_TradingPolicy_OS', @level2type=N'COLUMN',@level2name=N'DiscloPeriodEndReqFlag'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Refers: com_Code, XXX001: Year, XXX002: Quarter, XXX003: Month, XXX004:Week' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_TradingPolicy_OS', @level2type=N'COLUMN',@level2name=N'DiscloPeriodEndFreq'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Refers: com_Code, comma separated list of id from com_Code, XXX001:Equity, XXX002: Derivatives' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_TradingPolicy_OS', @level2type=N'COLUMN',@level2name=N'GenSecurityType'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0:No, 1:Yes, Default : 0 (Trading policy applies or does not apply to transaction under trading plan)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_TradingPolicy_OS', @level2type=N'COLUMN',@level2name=N'GenTradingPlanTransFlag'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Minimum holding period X days' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_TradingPolicy_OS', @level2type=N'COLUMN',@level2name=N'GenMinHoldingLimit'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Contra trade not allowed for X days from opposite transaction' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_TradingPolicy_OS', @level2type=N'COLUMN',@level2name=N'GenContraTradeNotAllowedLimit'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Refers: com_Code - comma separated list of id from com_Code XXX001: Exercise of Options ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_TradingPolicy_OS', @level2type=N'COLUMN',@level2name=N'GenExceptionFor'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Refers: com_Code - XXX001: Incomplete, XXX002: Active, XXX003: Inactive' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_TradingPolicy_OS', @level2type=N'COLUMN',@level2name=N'TradingPolicyStatusCodeId'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0:No, 1:Yes, Default : 0 Intitial disclosure to be submitted to stock exchange by CO' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_TradingPolicy_OS', @level2type=N'COLUMN',@level2name=N'DiscloInitSubmitToStExByCOFlag'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0:No, 1:Yes, Default : 0  Trade (continuous) disclosures to be submitted to stock exchange by CO' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_TradingPolicy_OS', @level2type=N'COLUMN',@level2name=N'StExSubmitDiscloToStExByCOFlag'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Period end disclosure to be submitted to CO by Insider within X days after period end' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_TradingPolicy_OS', @level2type=N'COLUMN',@level2name=N'DiscloPeriodEndToCOByInsdrLimit'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0:No, 1:Yes, Default : 0  Period end disclosure to be submitted to stock exchange by CO' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_TradingPolicy_OS', @level2type=N'COLUMN',@level2name=N'DiscloPeriodEndSubmitToStExByCOFlag'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Period end disclosure to be submitted to stock exchange by CO within X days after Insider last day submission' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_TradingPolicy_OS', @level2type=N'COLUMN',@level2name=N'DiscloPeriodEndSubmitToStExByCOLimit'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0:No, 1:Yes, Default : 0   If DiscloInitReqFlag = 1 then this can be 1, else this will be 0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_TradingPolicy_OS', @level2type=N'COLUMN',@level2name=N'DiscloInitReqSoftcopyFlag'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0:No, 1:Yes, Default : 0   If DiscloInitReqFlag = 1 then this can be 1, else this will be 0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_TradingPolicy_OS', @level2type=N'COLUMN',@level2name=N'DiscloInitReqHardcopyFlag'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0:No, 1:Yes, Default : 0  If DiscloInitSubmitToStExByCOFlag = 1 then this can be 1, else this will be 0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_TradingPolicy_OS', @level2type=N'COLUMN',@level2name=N'DiscloInitSubmitToStExByCOSoftcopyFlag'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0:No, 1:Yes, Default : 0  If DiscloInitSubmitToStExByCOFlag = 1 then this can be 1, else this will be 0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_TradingPolicy_OS', @level2type=N'COLUMN',@level2name=N'DiscloInitSubmitToStExByCOHardcopyFlag'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Trade details to be submitted by insider/employee to CO within X days after trade is performed' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_TradingPolicy_OS', @level2type=N'COLUMN',@level2name=N'StExTradePerformDtlsSubmitToCOByInsdrLimit'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0:No, 1:Yes, Default : 0  If StExSubmitDiscloToStExByCOFlag = 1 then this can be 1, else this will be 0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_TradingPolicy_OS', @level2type=N'COLUMN',@level2name=N'StExSubmitDiscloToStExByCOSoftcopyFlag'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0:No, 1:Yes, Default : 0  If StExSubmitDiscloToStExByCOFlag = 1 then this can be 1, else this will be 0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_TradingPolicy_OS', @level2type=N'COLUMN',@level2name=N'StExSubmitDiscloToStExByCOHardcopyFlag'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0:No, 1:Yes, Default : 0  If DiscloPeriodEndReqFlag = 1 then this can be 1, else this will be 0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_TradingPolicy_OS', @level2type=N'COLUMN',@level2name=N'DiscloPeriodEndReqSoftcopyFlag'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0:No, 1:Yes, Default : 0  If DiscloPeriodEndReqFlag = 1 then this can be 1, else this will be 0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_TradingPolicy_OS', @level2type=N'COLUMN',@level2name=N'DiscloPeriodEndReqHardcopyFlag'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0:No, 1:Yes, Default : 0  If DiscloPeriodEndSubmitToStExByCOFlag = 1 then this can be 1, else this will be 0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_TradingPolicy_OS', @level2type=N'COLUMN',@level2name=N'DiscloPeriodEndSubmitToStExByCOSoftcopyFlag'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0:No, 1:Yes, Default : 0  If DiscloPeriodEndSubmitToStExByCOFlag = 1 then this can be 1, else this will be 0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_TradingPolicy_OS', @level2type=N'COLUMN',@level2name=N'DiscloPeriodEndSubmitToStExByCOHardcopyFlag'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Trade (Continuous) Disclosures to be submitted by Insider/Employee to Company' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_TradingPolicy_OS', @level2type=N'COLUMN',@level2name=N'StExSubmitDiscloToCOByInsdrFlag'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0:No, 1:Yes, Default : 0  If StExSubmitDiscloToCOByInsdrFlag = 1 then this can be 1, else this will be 0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_TradingPolicy_OS', @level2type=N'COLUMN',@level2name=N'StExSubmitDiscloToCOByInsdrSoftcopyFlag'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0:No, 1:Yes, Default : 0  If StExSubmitDiscloToCOByInsdrFlag = 1 then this can be 1, else this will be 0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_TradingPolicy_OS', @level2type=N'COLUMN',@level2name=N'StExSubmitDiscloToCOByInsdrHardcopyFlag'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Flag for continuous, 1: For all securities, 0: For selected Securities' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_TradingPolicy_OS', @level2type=N'COLUMN',@level2name=N'StExForAllSecuritiesFlag'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0:No, 1:Yes, Default : 0  Flag to indicate whether record is deleted' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_TradingPolicy_OS', @level2type=N'COLUMN',@level2name=N'IsDeletedFlag'
GO
