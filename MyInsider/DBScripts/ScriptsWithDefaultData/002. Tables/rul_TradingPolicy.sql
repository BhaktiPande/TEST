IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[rul_TradingPolicy]') AND type in (N'U'))
BEGIN
	CREATE TABLE [dbo].[rul_TradingPolicy]
	(
		[TradingPolicyId] [int] IDENTITY(1,1) NOT NULL,
		[TradingPolicyParentId] [int] NULL,
		[CurrentHistoryCodeId] [int] NULL,
		[TradingPolicyForCodeId] [int] NULL,
		[TradingPolicyName] [nvarchar](100) NOT NULL,
		[TradingPolicyDescription] [nvarchar](1024) NULL,
		[ApplicableFromDate] [datetime] NULL,
		[ApplicableToDate] [datetime] NULL,
		[PreClrTradesApprovalReqFlag] [bit] NOT NULL,
		[PreClrTradesAutoApprovalReqFlag] [bit] NULL,
		[PreClrSingMultiPreClrFlagCodeId] [int] NULL,
		[PreClrSingleTransTradeNoShares] [int] NULL,
		[PreClrSingleTransTradePercPaidSubscribedCap] [decimal](15, 4) NULL,
		[PreClrProhibitNonTradePeriodFlag] [bit] NOT NULL,
		[PreClrCOApprovalLimit] [int] NULL,
		[PreClrApprovalValidityLimit] [int] NULL,
		[PreClrSeekDeclarationForUPSIFlag] [bit] NOT NULL,
		[PreClrUPSIDeclaration] [nvarchar](500) NULL,
		[PreClrReasonForNonTradeReqFlag] [bit] NOT NULL,
		[PreClrCompleteTradeNotDoneFlag] [bit] NOT NULL,
		[PreClrPartialTradeNotDoneFlag] [bit] NOT NULL,
		[PreClrTradeDiscloLimit] [int] NULL,
		[PreClrTradeDiscloShareholdLimit] [int] NULL,
		[PreClrForAllSecuritiesFlag] [bit] NOT NULL,
		[PreClrAllowNewForOpenPreclearFlag] [bit] NOT NULL,
		[PreClrMultipleAboveInCodeId] [int] NULL,
		[PreClrApprovalPreclearORPreclearTradeFlag] [int] NOT NULL,
		[StExSubmitTradeDiscloAllTradeFlag] [bit] NOT NULL,
		[StExSingMultiTransTradeFlagCodeId] [int] NULL,
		[StExMultiTradeFreq] [int] NULL,
		[StExMultiTradeCalFinYear] [int] NULL,
		[StExTransTradeNoShares] [int] NULL,
		[StExTransTradePercPaidSubscribedCap] [decimal](15, 4) NULL,
		[StExTransTradeShareValue] [int] NULL,
		[StExTradeDiscloSubmitLimit] [int] NULL,
		[DiscloInitReqFlag] [bit] NOT NULL,
		[DiscloInitLimit] [int] NULL,
		[DiscloInitDateLimit] [datetime] NULL,
		[DiscloPeriodEndReqFlag] [bit] NOT NULL,
		[DiscloPeriodEndFreq] [int] NULL,
		[GenSecurityType] [varchar](1024) NULL,
		[GenTradingPlanTransFlag] [bit] NOT NULL,
		[GenMinHoldingLimit] [int] NULL,
		[GenContraTradeNotAllowedLimit] [int] NULL,
		[GenExceptionFor] [varchar](1024) NULL,
		[TradingPolicyStatusCodeId] [int] NULL,
		[DiscloInitSubmitToStExByCOFlag] [bit] NULL,
		[StExSubmitDiscloToStExByCOFlag] [bit] NULL,
		[DiscloPeriodEndToCOByInsdrLimit] [int] NULL,
		[DiscloPeriodEndSubmitToStExByCOFlag] [bit] NULL,
		[DiscloPeriodEndSubmitToStExByCOLimit] [int] NULL,
		[DiscloInitReqSoftcopyFlag] [bit] NULL,
		[DiscloInitReqHardcopyFlag] [bit] NULL,
		[DiscloInitSubmitToStExByCOSoftcopyFlag] [bit] NULL,
		[DiscloInitSubmitToStExByCOHardcopyFlag] [bit] NULL,
		[StExTradePerformDtlsSubmitToCOByInsdrLimit] [int] NULL,
		[StExSubmitDiscloToStExByCOSoftcopyFlag] [bit] NULL,
		[StExSubmitDiscloToStExByCOHardcopyFlag] [bit] NULL,
		[DiscloPeriodEndReqSoftcopyFlag] [bit] NULL,
		[DiscloPeriodEndReqHardcopyFlag] [bit] NULL,
		[DiscloPeriodEndSubmitToStExByCOSoftcopyFlag] [bit] NULL,
		[DiscloPeriodEndSubmitToStExByCOHardcopyFlag] [bit] NULL,
		[StExSubmitDiscloToCOByInsdrFlag] [bit] NULL,
		[StExSubmitDiscloToCOByInsdrSoftcopyFlag] [bit] NULL,
		[StExSubmitDiscloToCOByInsdrHardcopyFlag] [bit] NULL,
		[StExForAllSecuritiesFlag] [bit] NOT NULL,
		[IsDeletedFlag] [bit] NOT NULL,
		[CreatedBy] [int] NULL,
		[CreatedOn] [datetime] NULL,
		[ModifiedBy] [int] NULL,
		[ModifiedOn] [datetime] NULL,
		[GenCashAndCashlessPartialExciseOptionForContraTrade] [int] NOT NULL DEFAULT 172001,
		[GenSecuritiesPriortoAcquisitionManualInputorAutoCalculate] [bit] NOT NULL DEFAULT 0,
		[TradingThresholdLimtResetFlag] [bit] NULL,
		[ContraTradeBasedOn] [int] NOT NULL DEFAULT 177001 ,
		CONSTRAINT [PK_rul_TradingPolicy] PRIMARY KEY CLUSTERED 
		(
			[TradingPolicyId] ASC
		)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'rul_TradingPolicy', N'COLUMN',N'TradingPolicyParentId'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Will contain Id of record for which this is the edited record. Parent record will be the history record. First record will contain its own Id as ParentId.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_TradingPolicy', @level2type=N'COLUMN',@level2name=N'TradingPolicyParentId'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'rul_TradingPolicy', N'COLUMN',N'CurrentHistoryCodeId'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Refers: com_Code, XXX001: Current, XXX002: History
This will be identifier to know whether record is current / history record.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_TradingPolicy', @level2type=N'COLUMN',@level2name=N'CurrentHistoryCodeId'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'rul_TradingPolicy', N'COLUMN',N'TradingPolicyForCodeId'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Refers: com_Code - XXX001: Employee (Non Insider), XXX002: Employee Insider, XXX003: NonEmployee Insider, XXX004: Corporate Insider' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_TradingPolicy', @level2type=N'COLUMN',@level2name=N'TradingPolicyForCodeId'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'rul_TradingPolicy', N'COLUMN',N'PreClrTradesApprovalReqFlag'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0:No, 1:Yes, Default : 0 (Preclearance Approval Required for all trades)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_TradingPolicy', @level2type=N'COLUMN',@level2name=N'PreClrTradesApprovalReqFlag'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'rul_TradingPolicy', N'COLUMN',N'PreClrTradesAutoApprovalReqFlag'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0:No, 1:Yes, Default : NULL (Preclearance Auto Approval Required). This will be set to 0 or 1 only when PreClrTradesApprovalReqFlag is set to No' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_TradingPolicy', @level2type=N'COLUMN',@level2name=N'PreClrTradesAutoApprovalReqFlag'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'rul_TradingPolicy', N'COLUMN',N'PreClrSingMultiPreClrFlagCodeId'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Refers: com_Code - 136001: Single , 136002: Multiple : Single pre-clearance Request, Multiple Pre-clearance request. This will be set only when PreClrTradesApprovalReqFlag is set to No' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_TradingPolicy', @level2type=N'COLUMN',@level2name=N'PreClrSingMultiPreClrFlagCodeId'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'rul_TradingPolicy', N'COLUMN',N'PreClrSingleTransTradeNoShares'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Preclearance Approval required for single trade transaction above number of shares' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_TradingPolicy', @level2type=N'COLUMN',@level2name=N'PreClrSingleTransTradeNoShares'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'rul_TradingPolicy', N'COLUMN',N'PreClrSingleTransTradePercPaidSubscribedCap'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Preclearance Approval required for single trade transaction above percentage of paid up and subscribed capital' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_TradingPolicy', @level2type=N'COLUMN',@level2name=N'PreClrSingleTransTradePercPaidSubscribedCap'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'rul_TradingPolicy', N'COLUMN',N'PreClrProhibitNonTradePeriodFlag'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0:No, 1:Yes, Default : 1 (as per SRS) (Prohibit pre-clearance during non-trading period)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_TradingPolicy', @level2type=N'COLUMN',@level2name=N'PreClrProhibitNonTradePeriodFlag'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'rul_TradingPolicy', N'COLUMN',N'PreClrCOApprovalLimit'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Preclearance approval to be given within X days by Complaince Officer' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_TradingPolicy', @level2type=N'COLUMN',@level2name=N'PreClrCOApprovalLimit'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'rul_TradingPolicy', N'COLUMN',N'PreClrApprovalValidityLimit'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Preclearance approval validity X days (after approval is given and excluding approval day)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_TradingPolicy', @level2type=N'COLUMN',@level2name=N'PreClrApprovalValidityLimit'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'rul_TradingPolicy', N'COLUMN',N'PreClrSeekDeclarationForUPSIFlag'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0:No, 1:Yes, Default : 0 (Seek declaration from employee regarding possession of UPSI' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_TradingPolicy', @level2type=N'COLUMN',@level2name=N'PreClrSeekDeclarationForUPSIFlag'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'rul_TradingPolicy', N'COLUMN',N'PreClrUPSIDeclaration'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Declaration sought from the insider at the time of preclearance' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_TradingPolicy', @level2type=N'COLUMN',@level2name=N'PreClrUPSIDeclaration'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'rul_TradingPolicy', N'COLUMN',N'PreClrReasonForNonTradeReqFlag'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0:No, 1:Yes, Default : 0 (Preclearance - Reason for non-trade to be provided)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_TradingPolicy', @level2type=N'COLUMN',@level2name=N'PreClrReasonForNonTradeReqFlag'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'rul_TradingPolicy', N'COLUMN',N'PreClrCompleteTradeNotDoneFlag'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0:No, 1:Yes, Default : 0 (Complete trade not done for pre-clearance taken)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_TradingPolicy', @level2type=N'COLUMN',@level2name=N'PreClrCompleteTradeNotDoneFlag'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'rul_TradingPolicy', N'COLUMN',N'PreClrPartialTradeNotDoneFlag'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0:No, 1:Yes, Default : 0 (Partial trade not done for pre-clearance taken)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_TradingPolicy', @level2type=N'COLUMN',@level2name=N'PreClrPartialTradeNotDoneFlag'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'rul_TradingPolicy', N'COLUMN',N'PreClrTradeDiscloLimit'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Trade disclosure for preclearance approval transactions within X days' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_TradingPolicy', @level2type=N'COLUMN',@level2name=N'PreClrTradeDiscloLimit'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'rul_TradingPolicy', N'COLUMN',N'PreClrTradeDiscloShareholdLimit'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Preclearance Trade disclosure within X days of change in share holdings (more than 5%)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_TradingPolicy', @level2type=N'COLUMN',@level2name=N'PreClrTradeDiscloShareholdLimit'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'rul_TradingPolicy', N'COLUMN',N'PreClrForAllSecuritiesFlag'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Flag for preclearance, 1: For all securities, 0: For selected Securities' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_TradingPolicy', @level2type=N'COLUMN',@level2name=N'PreClrForAllSecuritiesFlag'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'rul_TradingPolicy', N'COLUMN',N'PreClrAllowNewForOpenPreclearFlag'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Allow new preclearance to be created when earlier preclearance is open 0=No, 1=Yes' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_TradingPolicy', @level2type=N'COLUMN',@level2name=N'PreClrAllowNewForOpenPreclearFlag'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'rul_TradingPolicy', N'COLUMN',N'PreClrMultipleAboveInCodeId'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Multiple preclearance above in a Monthly / Quarterly / Yearly etc' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_TradingPolicy', @level2type=N'COLUMN',@level2name=N'PreClrMultipleAboveInCodeId'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'rul_TradingPolicy', N'COLUMN',N'PreClrApprovalPreclearORPreclearTradeFlag'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Preclearance approval based on Preclearance details or Preclearance and Trade details. 0=Preclearance details, 1=Preclearance and Trade details' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_TradingPolicy', @level2type=N'COLUMN',@level2name=N'PreClrApprovalPreclearORPreclearTradeFlag'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'rul_TradingPolicy', N'COLUMN',N'StExSubmitTradeDiscloAllTradeFlag'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0:No, 1:Yes, Default : 0 (Trade disclosures to be submitted to stock exchanges for all trades)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_TradingPolicy', @level2type=N'COLUMN',@level2name=N'StExSubmitTradeDiscloAllTradeFlag'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'rul_TradingPolicy', N'COLUMN',N'StExSingMultiTransTradeFlagCodeId'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Refers: com_Code - XXX001: Single Transaction Trade, XXX002: Multiple Transaction Trade(Stock exchange disclosure related Single or Multiple Transaction trade above)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_TradingPolicy', @level2type=N'COLUMN',@level2name=N'StExSingMultiTransTradeFlagCodeId'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'rul_TradingPolicy', N'COLUMN',N'StExMultiTradeFreq'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Refers: com_Code - XXX001: Year, XXX002: Quarter, XXX003: Month, XXX004:Week(Stock exchange disclosure related Multiple transaction trade above in week, month etc)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_TradingPolicy', @level2type=N'COLUMN',@level2name=N'StExMultiTradeFreq'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'rul_TradingPolicy', N'COLUMN',N'StExMultiTradeCalFinYear'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Refers: com_Code - XXX001:Calendar Year, XXX002: Finanacial Year(Stock exchange disclosure related Multiple transaction trade for calendar or financial year)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_TradingPolicy', @level2type=N'COLUMN',@level2name=N'StExMultiTradeCalFinYear'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'rul_TradingPolicy', N'COLUMN',N'StExTransTradeNoShares'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Stock exchange disclosure related Single or Multiple Transaction trade above number of shares' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_TradingPolicy', @level2type=N'COLUMN',@level2name=N'StExTransTradeNoShares'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'rul_TradingPolicy', N'COLUMN',N'StExTransTradePercPaidSubscribedCap'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Stock exchange disclosure related Single or Multiple Transaction trade above % of paid up and subscribed capital' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_TradingPolicy', @level2type=N'COLUMN',@level2name=N'StExTransTradePercPaidSubscribedCap'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'rul_TradingPolicy', N'COLUMN',N'StExTransTradeShareValue'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Stock exchange disclosure related Single or Multiple Transaction trade above value of shares' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_TradingPolicy', @level2type=N'COLUMN',@level2name=N'StExTransTradeShareValue'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'rul_TradingPolicy', N'COLUMN',N'StExTradeDiscloSubmitLimit'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Stock exchange disclosure related trade disclosure within X days of submision by insider/employee' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_TradingPolicy', @level2type=N'COLUMN',@level2name=N'StExTradeDiscloSubmitLimit'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'rul_TradingPolicy', N'COLUMN',N'DiscloInitReqFlag'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0:No, 1:Yes, Default : 0 (Initial disclosures required / not required)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_TradingPolicy', @level2type=N'COLUMN',@level2name=N'DiscloInitReqFlag'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'rul_TradingPolicy', N'COLUMN',N'DiscloInitLimit'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Initial disclosure within X days of joining / being categorized as insider' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_TradingPolicy', @level2type=N'COLUMN',@level2name=N'DiscloInitLimit'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'rul_TradingPolicy', N'COLUMN',N'DiscloInitDateLimit'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Initial disclosure before X date of application go live' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_TradingPolicy', @level2type=N'COLUMN',@level2name=N'DiscloInitDateLimit'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'rul_TradingPolicy', N'COLUMN',N'DiscloPeriodEndReqFlag'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0:No, 1:Yes, Default : 0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_TradingPolicy', @level2type=N'COLUMN',@level2name=N'DiscloPeriodEndReqFlag'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'rul_TradingPolicy', N'COLUMN',N'DiscloPeriodEndFreq'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Refers: com_Code, XXX001: Year, XXX002: Quarter, XXX003: Month, XXX004:Week' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_TradingPolicy', @level2type=N'COLUMN',@level2name=N'DiscloPeriodEndFreq'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'rul_TradingPolicy', N'COLUMN',N'GenSecurityType'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Refers: com_Code, comma separated list of id from com_Code, XXX001:Equity, XXX002: Derivatives' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_TradingPolicy', @level2type=N'COLUMN',@level2name=N'GenSecurityType'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'rul_TradingPolicy', N'COLUMN',N'GenTradingPlanTransFlag'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0:No, 1:Yes, Default : 0 (Trading policy applies or does not apply to transaction under trading plan)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_TradingPolicy', @level2type=N'COLUMN',@level2name=N'GenTradingPlanTransFlag'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'rul_TradingPolicy', N'COLUMN',N'GenMinHoldingLimit'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Minimum holding period X days' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_TradingPolicy', @level2type=N'COLUMN',@level2name=N'GenMinHoldingLimit'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'rul_TradingPolicy', N'COLUMN',N'GenContraTradeNotAllowedLimit'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Contra trade not allowed for X days from opposite transaction' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_TradingPolicy', @level2type=N'COLUMN',@level2name=N'GenContraTradeNotAllowedLimit'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'rul_TradingPolicy', N'COLUMN',N'GenExceptionFor'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Refers: com_Code - comma separated list of id from com_Code XXX001: Exercise of Options ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_TradingPolicy', @level2type=N'COLUMN',@level2name=N'GenExceptionFor'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'rul_TradingPolicy', N'COLUMN',N'TradingPolicyStatusCodeId'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Refers: com_Code - XXX001: Incomplete, XXX002: Active, XXX003: Inactive' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_TradingPolicy', @level2type=N'COLUMN',@level2name=N'TradingPolicyStatusCodeId'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'rul_TradingPolicy', N'COLUMN',N'DiscloInitSubmitToStExByCOFlag'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0:No, 1:Yes, Default : 0 Intitial disclosure to be submitted to stock exchange by CO' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_TradingPolicy', @level2type=N'COLUMN',@level2name=N'DiscloInitSubmitToStExByCOFlag'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'rul_TradingPolicy', N'COLUMN',N'StExSubmitDiscloToStExByCOFlag'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0:No, 1:Yes, Default : 0  Trade (continuous) disclosures to be submitted to stock exchange by CO' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_TradingPolicy', @level2type=N'COLUMN',@level2name=N'StExSubmitDiscloToStExByCOFlag'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'rul_TradingPolicy', N'COLUMN',N'DiscloPeriodEndToCOByInsdrLimit'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Period end disclosure to be submitted to CO by Insider within X days after period end' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_TradingPolicy', @level2type=N'COLUMN',@level2name=N'DiscloPeriodEndToCOByInsdrLimit'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'rul_TradingPolicy', N'COLUMN',N'DiscloPeriodEndSubmitToStExByCOFlag'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0:No, 1:Yes, Default : 0  Period end disclosure to be submitted to stock exchange by CO' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_TradingPolicy', @level2type=N'COLUMN',@level2name=N'DiscloPeriodEndSubmitToStExByCOFlag'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'rul_TradingPolicy', N'COLUMN',N'DiscloPeriodEndSubmitToStExByCOLimit'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Period end disclosure to be submitted to stock exchange by CO within X days after Insider last day submission' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_TradingPolicy', @level2type=N'COLUMN',@level2name=N'DiscloPeriodEndSubmitToStExByCOLimit'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'rul_TradingPolicy', N'COLUMN',N'DiscloInitReqSoftcopyFlag'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0:No, 1:Yes, Default : 0   If DiscloInitReqFlag = 1 then this can be 1, else this will be 0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_TradingPolicy', @level2type=N'COLUMN',@level2name=N'DiscloInitReqSoftcopyFlag'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'rul_TradingPolicy', N'COLUMN',N'DiscloInitReqHardcopyFlag'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0:No, 1:Yes, Default : 0   If DiscloInitReqFlag = 1 then this can be 1, else this will be 0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_TradingPolicy', @level2type=N'COLUMN',@level2name=N'DiscloInitReqHardcopyFlag'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'rul_TradingPolicy', N'COLUMN',N'DiscloInitSubmitToStExByCOSoftcopyFlag'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0:No, 1:Yes, Default : 0  If DiscloInitSubmitToStExByCOFlag = 1 then this can be 1, else this will be 0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_TradingPolicy', @level2type=N'COLUMN',@level2name=N'DiscloInitSubmitToStExByCOSoftcopyFlag'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'rul_TradingPolicy', N'COLUMN',N'DiscloInitSubmitToStExByCOHardcopyFlag'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0:No, 1:Yes, Default : 0  If DiscloInitSubmitToStExByCOFlag = 1 then this can be 1, else this will be 0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_TradingPolicy', @level2type=N'COLUMN',@level2name=N'DiscloInitSubmitToStExByCOHardcopyFlag'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'rul_TradingPolicy', N'COLUMN',N'StExTradePerformDtlsSubmitToCOByInsdrLimit'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Trade details to be submitted by insider/employee to CO within X days after trade is performed' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_TradingPolicy', @level2type=N'COLUMN',@level2name=N'StExTradePerformDtlsSubmitToCOByInsdrLimit'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'rul_TradingPolicy', N'COLUMN',N'StExSubmitDiscloToStExByCOSoftcopyFlag'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0:No, 1:Yes, Default : 0  If StExSubmitDiscloToStExByCOFlag = 1 then this can be 1, else this will be 0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_TradingPolicy', @level2type=N'COLUMN',@level2name=N'StExSubmitDiscloToStExByCOSoftcopyFlag'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'rul_TradingPolicy', N'COLUMN',N'StExSubmitDiscloToStExByCOHardcopyFlag'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0:No, 1:Yes, Default : 0  If StExSubmitDiscloToStExByCOFlag = 1 then this can be 1, else this will be 0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_TradingPolicy', @level2type=N'COLUMN',@level2name=N'StExSubmitDiscloToStExByCOHardcopyFlag'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'rul_TradingPolicy', N'COLUMN',N'DiscloPeriodEndReqSoftcopyFlag'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0:No, 1:Yes, Default : 0  If DiscloPeriodEndReqFlag = 1 then this can be 1, else this will be 0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_TradingPolicy', @level2type=N'COLUMN',@level2name=N'DiscloPeriodEndReqSoftcopyFlag'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'rul_TradingPolicy', N'COLUMN',N'DiscloPeriodEndReqHardcopyFlag'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0:No, 1:Yes, Default : 0  If DiscloPeriodEndReqFlag = 1 then this can be 1, else this will be 0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_TradingPolicy', @level2type=N'COLUMN',@level2name=N'DiscloPeriodEndReqHardcopyFlag'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'rul_TradingPolicy', N'COLUMN',N'DiscloPeriodEndSubmitToStExByCOSoftcopyFlag'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0:No, 1:Yes, Default : 0  If DiscloPeriodEndSubmitToStExByCOFlag = 1 then this can be 1, else this will be 0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_TradingPolicy', @level2type=N'COLUMN',@level2name=N'DiscloPeriodEndSubmitToStExByCOSoftcopyFlag'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'rul_TradingPolicy', N'COLUMN',N'DiscloPeriodEndSubmitToStExByCOHardcopyFlag'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0:No, 1:Yes, Default : 0  If DiscloPeriodEndSubmitToStExByCOFlag = 1 then this can be 1, else this will be 0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_TradingPolicy', @level2type=N'COLUMN',@level2name=N'DiscloPeriodEndSubmitToStExByCOHardcopyFlag'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'rul_TradingPolicy', N'COLUMN',N'StExSubmitDiscloToCOByInsdrFlag'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Trade (Continuous) Disclosures to be submitted by Insider/Employee to Company' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_TradingPolicy', @level2type=N'COLUMN',@level2name=N'StExSubmitDiscloToCOByInsdrFlag'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'rul_TradingPolicy', N'COLUMN',N'StExSubmitDiscloToCOByInsdrSoftcopyFlag'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0:No, 1:Yes, Default : 0  If StExSubmitDiscloToCOByInsdrFlag = 1 then this can be 1, else this will be 0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_TradingPolicy', @level2type=N'COLUMN',@level2name=N'StExSubmitDiscloToCOByInsdrSoftcopyFlag'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'rul_TradingPolicy', N'COLUMN',N'StExSubmitDiscloToCOByInsdrHardcopyFlag'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0:No, 1:Yes, Default : 0  If StExSubmitDiscloToCOByInsdrFlag = 1 then this can be 1, else this will be 0' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_TradingPolicy', @level2type=N'COLUMN',@level2name=N'StExSubmitDiscloToCOByInsdrHardcopyFlag'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'rul_TradingPolicy', N'COLUMN',N'StExForAllSecuritiesFlag'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Flag for continuous, 1: For all securities, 0: For selected Securities' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_TradingPolicy', @level2type=N'COLUMN',@level2name=N'StExForAllSecuritiesFlag'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'rul_TradingPolicy', N'COLUMN',N'IsDeletedFlag'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0:No, 1:Yes, Default : 0  Flag to indicate whether record is deleted' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_TradingPolicy', @level2type=N'COLUMN',@level2name=N'IsDeletedFlag'
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_rul_TradingPolicy_com_Code_CurrentHistoryCodeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[rul_TradingPolicy]'))
ALTER TABLE [dbo].[rul_TradingPolicy]  WITH CHECK ADD  CONSTRAINT [FK_rul_TradingPolicy_com_Code_CurrentHistoryCodeId] FOREIGN KEY([CurrentHistoryCodeId])
REFERENCES [dbo].[com_Code] ([CodeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_rul_TradingPolicy_com_Code_CurrentHistoryCodeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[rul_TradingPolicy]'))
ALTER TABLE [dbo].[rul_TradingPolicy] CHECK CONSTRAINT [FK_rul_TradingPolicy_com_Code_CurrentHistoryCodeId]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_rul_TradingPolicy_com_Code_DiscloPeriodEndFreq]') AND parent_object_id = OBJECT_ID(N'[dbo].[rul_TradingPolicy]'))
ALTER TABLE [dbo].[rul_TradingPolicy]  WITH CHECK ADD  CONSTRAINT [FK_rul_TradingPolicy_com_Code_DiscloPeriodEndFreq] FOREIGN KEY([DiscloPeriodEndFreq])
REFERENCES [dbo].[com_Code] ([CodeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_rul_TradingPolicy_com_Code_DiscloPeriodEndFreq]') AND parent_object_id = OBJECT_ID(N'[dbo].[rul_TradingPolicy]'))
ALTER TABLE [dbo].[rul_TradingPolicy] CHECK CONSTRAINT [FK_rul_TradingPolicy_com_Code_DiscloPeriodEndFreq]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_rul_TradingPolicy_com_Code_PreClrSingMultiPreClrFlagCodeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[rul_TradingPolicy]'))
ALTER TABLE [dbo].[rul_TradingPolicy]  WITH CHECK ADD  CONSTRAINT [FK_rul_TradingPolicy_com_Code_PreClrSingMultiPreClrFlagCodeId] FOREIGN KEY([PreClrSingMultiPreClrFlagCodeId])
REFERENCES [dbo].[com_Code] ([CodeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_rul_TradingPolicy_com_Code_PreClrSingMultiPreClrFlagCodeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[rul_TradingPolicy]'))
ALTER TABLE [dbo].[rul_TradingPolicy] CHECK CONSTRAINT [FK_rul_TradingPolicy_com_Code_PreClrSingMultiPreClrFlagCodeId]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_rul_TradingPolicy_com_Code_StExMultiTradeCalFinYear]') AND parent_object_id = OBJECT_ID(N'[dbo].[rul_TradingPolicy]'))
ALTER TABLE [dbo].[rul_TradingPolicy]  WITH CHECK ADD  CONSTRAINT [FK_rul_TradingPolicy_com_Code_StExMultiTradeCalFinYear] FOREIGN KEY([StExMultiTradeCalFinYear])
REFERENCES [dbo].[com_Code] ([CodeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_rul_TradingPolicy_com_Code_StExMultiTradeCalFinYear]') AND parent_object_id = OBJECT_ID(N'[dbo].[rul_TradingPolicy]'))
ALTER TABLE [dbo].[rul_TradingPolicy] CHECK CONSTRAINT [FK_rul_TradingPolicy_com_Code_StExMultiTradeCalFinYear]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_rul_TradingPolicy_com_Code_StExMultiTradeFreq]') AND parent_object_id = OBJECT_ID(N'[dbo].[rul_TradingPolicy]'))
ALTER TABLE [dbo].[rul_TradingPolicy]  WITH CHECK ADD  CONSTRAINT [FK_rul_TradingPolicy_com_Code_StExMultiTradeFreq] FOREIGN KEY([StExMultiTradeFreq])
REFERENCES [dbo].[com_Code] ([CodeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_rul_TradingPolicy_com_Code_StExMultiTradeFreq]') AND parent_object_id = OBJECT_ID(N'[dbo].[rul_TradingPolicy]'))
ALTER TABLE [dbo].[rul_TradingPolicy] CHECK CONSTRAINT [FK_rul_TradingPolicy_com_Code_StExMultiTradeFreq]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_rul_TradingPolicy_com_Code_StExSingMultiTransTradeFlagCodeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[rul_TradingPolicy]'))
ALTER TABLE [dbo].[rul_TradingPolicy]  WITH CHECK ADD  CONSTRAINT [FK_rul_TradingPolicy_com_Code_StExSingMultiTransTradeFlagCodeId] FOREIGN KEY([StExSingMultiTransTradeFlagCodeId])
REFERENCES [dbo].[com_Code] ([CodeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_rul_TradingPolicy_com_Code_StExSingMultiTransTradeFlagCodeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[rul_TradingPolicy]'))
ALTER TABLE [dbo].[rul_TradingPolicy] CHECK CONSTRAINT [FK_rul_TradingPolicy_com_Code_StExSingMultiTransTradeFlagCodeId]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_rul_TradingPolicy_com_Code_TradingPolicyForCodeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[rul_TradingPolicy]'))
ALTER TABLE [dbo].[rul_TradingPolicy]  WITH CHECK ADD  CONSTRAINT [FK_rul_TradingPolicy_com_Code_TradingPolicyForCodeId] FOREIGN KEY([TradingPolicyForCodeId])
REFERENCES [dbo].[com_Code] ([CodeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_rul_TradingPolicy_com_Code_TradingPolicyForCodeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[rul_TradingPolicy]'))
ALTER TABLE [dbo].[rul_TradingPolicy] CHECK CONSTRAINT [FK_rul_TradingPolicy_com_Code_TradingPolicyForCodeId]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_rul_TradingPolicy_com_Code_TradingPolicyStatusCodeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[rul_TradingPolicy]'))
ALTER TABLE [dbo].[rul_TradingPolicy]  WITH CHECK ADD  CONSTRAINT [FK_rul_TradingPolicy_com_Code_TradingPolicyStatusCodeId] FOREIGN KEY([TradingPolicyStatusCodeId])
REFERENCES [dbo].[com_Code] ([CodeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_rul_TradingPolicy_com_Code_TradingPolicyStatusCodeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[rul_TradingPolicy]'))
ALTER TABLE [dbo].[rul_TradingPolicy] CHECK CONSTRAINT [FK_rul_TradingPolicy_com_Code_TradingPolicyStatusCodeId]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_rul_TradingPolicy_rul_TradingPolicy]') AND parent_object_id = OBJECT_ID(N'[dbo].[rul_TradingPolicy]'))
ALTER TABLE [dbo].[rul_TradingPolicy]  WITH CHECK ADD  CONSTRAINT [FK_rul_TradingPolicy_rul_TradingPolicy] FOREIGN KEY([TradingPolicyParentId])
REFERENCES [dbo].[rul_TradingPolicy] ([TradingPolicyId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_rul_TradingPolicy_rul_TradingPolicy]') AND parent_object_id = OBJECT_ID(N'[dbo].[rul_TradingPolicy]'))
ALTER TABLE [dbo].[rul_TradingPolicy] CHECK CONSTRAINT [FK_rul_TradingPolicy_rul_TradingPolicy]
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_rul_TradingPolicy_PreClrTradesApprovalReqFlag]') AND parent_object_id = OBJECT_ID(N'[dbo].[rul_TradingPolicy]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_rul_TradingPolicy_PreClrTradesApprovalReqFlag]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[rul_TradingPolicy] ADD  CONSTRAINT [DF_rul_TradingPolicy_PreClrTradesApprovalReqFlag]  DEFAULT ((0)) FOR [PreClrTradesApprovalReqFlag]
END


End
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_rul_TradingPolicy_PreClrProhibitNonTradePeriodFlag]') AND parent_object_id = OBJECT_ID(N'[dbo].[rul_TradingPolicy]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_rul_TradingPolicy_PreClrProhibitNonTradePeriodFlag]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[rul_TradingPolicy] ADD  CONSTRAINT [DF_rul_TradingPolicy_PreClrProhibitNonTradePeriodFlag]  DEFAULT ((1)) FOR [PreClrProhibitNonTradePeriodFlag]
END


End
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_rul_TradingPolicy_PreClrSeekDeclarationForUPSIFlag]') AND parent_object_id = OBJECT_ID(N'[dbo].[rul_TradingPolicy]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_rul_TradingPolicy_PreClrSeekDeclarationForUPSIFlag]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[rul_TradingPolicy] ADD  CONSTRAINT [DF_rul_TradingPolicy_PreClrSeekDeclarationForUPSIFlag]  DEFAULT ((0)) FOR [PreClrSeekDeclarationForUPSIFlag]
END


End
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_rul_TradingPolicy_PreClrReasonForNonTradeReqFlag]') AND parent_object_id = OBJECT_ID(N'[dbo].[rul_TradingPolicy]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_rul_TradingPolicy_PreClrReasonForNonTradeReqFlag]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[rul_TradingPolicy] ADD  CONSTRAINT [DF_rul_TradingPolicy_PreClrReasonForNonTradeReqFlag]  DEFAULT ((0)) FOR [PreClrReasonForNonTradeReqFlag]
END


End
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_rul_TradingPolicy_PreClrCompleteTradeNotDoneFlag]') AND parent_object_id = OBJECT_ID(N'[dbo].[rul_TradingPolicy]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_rul_TradingPolicy_PreClrCompleteTradeNotDoneFlag]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[rul_TradingPolicy] ADD  CONSTRAINT [DF_rul_TradingPolicy_PreClrCompleteTradeNotDoneFlag]  DEFAULT ((0)) FOR [PreClrCompleteTradeNotDoneFlag]
END


End
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_rul_TradingPolicy_PreClrPartialTradeNotDoneFlag]') AND parent_object_id = OBJECT_ID(N'[dbo].[rul_TradingPolicy]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_rul_TradingPolicy_PreClrPartialTradeNotDoneFlag]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[rul_TradingPolicy] ADD  CONSTRAINT [DF_rul_TradingPolicy_PreClrPartialTradeNotDoneFlag]  DEFAULT ((0)) FOR [PreClrPartialTradeNotDoneFlag]
END


End
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_rul_TradingPolicy_PreClrForAllSecuritiesFlag]') AND parent_object_id = OBJECT_ID(N'[dbo].[rul_TradingPolicy]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_rul_TradingPolicy_PreClrForAllSecuritiesFlag]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[rul_TradingPolicy] ADD  CONSTRAINT [DF_rul_TradingPolicy_PreClrForAllSecuritiesFlag]  DEFAULT ((0)) FOR [PreClrForAllSecuritiesFlag]
END


End
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_rul_TradingPolicy_PreClrAllowNewForOpenPreclearFlag]') AND parent_object_id = OBJECT_ID(N'[dbo].[rul_TradingPolicy]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_rul_TradingPolicy_PreClrAllowNewForOpenPreclearFlag]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[rul_TradingPolicy] ADD  CONSTRAINT [DF_rul_TradingPolicy_PreClrAllowNewForOpenPreclearFlag]  DEFAULT ((0)) FOR [PreClrAllowNewForOpenPreclearFlag]
END


End
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_rul_TradingPolicy_PreClrApprovalPreclearORPreclearTradeFlag]') AND parent_object_id = OBJECT_ID(N'[dbo].[rul_TradingPolicy]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_rul_TradingPolicy_PreClrApprovalPreclearORPreclearTradeFlag]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[rul_TradingPolicy] ADD  CONSTRAINT [DF_rul_TradingPolicy_PreClrApprovalPreclearORPreclearTradeFlag]  DEFAULT ((0)) FOR [PreClrApprovalPreclearORPreclearTradeFlag]
END


End
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_rul_TradingPolicy_StExSubmitTradeDiscloAllTradeFlag]') AND parent_object_id = OBJECT_ID(N'[dbo].[rul_TradingPolicy]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_rul_TradingPolicy_StExSubmitTradeDiscloAllTradeFlag]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[rul_TradingPolicy] ADD  CONSTRAINT [DF_rul_TradingPolicy_StExSubmitTradeDiscloAllTradeFlag]  DEFAULT ((0)) FOR [StExSubmitTradeDiscloAllTradeFlag]
END


End
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_rul_TradingPolicy_DiscloInitReqFlag]') AND parent_object_id = OBJECT_ID(N'[dbo].[rul_TradingPolicy]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_rul_TradingPolicy_DiscloInitReqFlag]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[rul_TradingPolicy] ADD  CONSTRAINT [DF_rul_TradingPolicy_DiscloInitReqFlag]  DEFAULT ((0)) FOR [DiscloInitReqFlag]
END


End
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_rul_TradingPolicy_DiscloPeriodEndReqFlag]') AND parent_object_id = OBJECT_ID(N'[dbo].[rul_TradingPolicy]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_rul_TradingPolicy_DiscloPeriodEndReqFlag]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[rul_TradingPolicy] ADD  CONSTRAINT [DF_rul_TradingPolicy_DiscloPeriodEndReqFlag]  DEFAULT ((0)) FOR [DiscloPeriodEndReqFlag]
END


End
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_rul_TradingPolicy_GenTradingPlanTransFlag]') AND parent_object_id = OBJECT_ID(N'[dbo].[rul_TradingPolicy]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_rul_TradingPolicy_GenTradingPlanTransFlag]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[rul_TradingPolicy] ADD  CONSTRAINT [DF_rul_TradingPolicy_GenTradingPlanTransFlag]  DEFAULT ((0)) FOR [GenTradingPlanTransFlag]
END


End
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_rul_TradingPolicy_DiscloInitSubmitToStExByCOFlag]') AND parent_object_id = OBJECT_ID(N'[dbo].[rul_TradingPolicy]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_rul_TradingPolicy_DiscloInitSubmitToStExByCOFlag]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[rul_TradingPolicy] ADD  CONSTRAINT [DF_rul_TradingPolicy_DiscloInitSubmitToStExByCOFlag]  DEFAULT ((0)) FOR [DiscloInitSubmitToStExByCOFlag]
END


End
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_rul_TradingPolicy_StExSubmitDiscloToStExByCOFlag]') AND parent_object_id = OBJECT_ID(N'[dbo].[rul_TradingPolicy]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_rul_TradingPolicy_StExSubmitDiscloToStExByCOFlag]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[rul_TradingPolicy] ADD  CONSTRAINT [DF_rul_TradingPolicy_StExSubmitDiscloToStExByCOFlag]  DEFAULT ((0)) FOR [StExSubmitDiscloToStExByCOFlag]
END


End
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_rul_TradingPolicy_DiscloPeriodEndSubmitToStExByCOFlag]') AND parent_object_id = OBJECT_ID(N'[dbo].[rul_TradingPolicy]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_rul_TradingPolicy_DiscloPeriodEndSubmitToStExByCOFlag]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[rul_TradingPolicy] ADD  CONSTRAINT [DF_rul_TradingPolicy_DiscloPeriodEndSubmitToStExByCOFlag]  DEFAULT ((0)) FOR [DiscloPeriodEndSubmitToStExByCOFlag]
END


End
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_rul_TradingPolicy_DiscloInitReqSoftcopyFlag]') AND parent_object_id = OBJECT_ID(N'[dbo].[rul_TradingPolicy]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_rul_TradingPolicy_DiscloInitReqSoftcopyFlag]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[rul_TradingPolicy] ADD  CONSTRAINT [DF_rul_TradingPolicy_DiscloInitReqSoftcopyFlag]  DEFAULT ((0)) FOR [DiscloInitReqSoftcopyFlag]
END


End
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_rul_TradingPolicy_DiscloInitReqHardcopyFlag]') AND parent_object_id = OBJECT_ID(N'[dbo].[rul_TradingPolicy]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_rul_TradingPolicy_DiscloInitReqHardcopyFlag]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[rul_TradingPolicy] ADD  CONSTRAINT [DF_rul_TradingPolicy_DiscloInitReqHardcopyFlag]  DEFAULT ((0)) FOR [DiscloInitReqHardcopyFlag]
END


End
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_rul_TradingPolicy_DiscloInitSubmitToStExByCOSoftcopyFlag]') AND parent_object_id = OBJECT_ID(N'[dbo].[rul_TradingPolicy]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_rul_TradingPolicy_DiscloInitSubmitToStExByCOSoftcopyFlag]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[rul_TradingPolicy] ADD  CONSTRAINT [DF_rul_TradingPolicy_DiscloInitSubmitToStExByCOSoftcopyFlag]  DEFAULT ((0)) FOR [DiscloInitSubmitToStExByCOSoftcopyFlag]
END


End
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_rul_TradingPolicy_DiscloInitSubmitToStExByCOHardcopyFlag]') AND parent_object_id = OBJECT_ID(N'[dbo].[rul_TradingPolicy]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_rul_TradingPolicy_DiscloInitSubmitToStExByCOHardcopyFlag]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[rul_TradingPolicy] ADD  CONSTRAINT [DF_rul_TradingPolicy_DiscloInitSubmitToStExByCOHardcopyFlag]  DEFAULT ((0)) FOR [DiscloInitSubmitToStExByCOHardcopyFlag]
END


End
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_rul_TradingPolicy_StExSubmitDiscloToStExByCOSoftcopyFlag]') AND parent_object_id = OBJECT_ID(N'[dbo].[rul_TradingPolicy]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_rul_TradingPolicy_StExSubmitDiscloToStExByCOSoftcopyFlag]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[rul_TradingPolicy] ADD  CONSTRAINT [DF_rul_TradingPolicy_StExSubmitDiscloToStExByCOSoftcopyFlag]  DEFAULT ((0)) FOR [StExSubmitDiscloToStExByCOSoftcopyFlag]
END


End
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_rul_TradingPolicy_StExSubmitDiscloToStExByCOHardcopyFlag]') AND parent_object_id = OBJECT_ID(N'[dbo].[rul_TradingPolicy]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_rul_TradingPolicy_StExSubmitDiscloToStExByCOHardcopyFlag]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[rul_TradingPolicy] ADD  CONSTRAINT [DF_rul_TradingPolicy_StExSubmitDiscloToStExByCOHardcopyFlag]  DEFAULT ((0)) FOR [StExSubmitDiscloToStExByCOHardcopyFlag]
END


End
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_rul_TradingPolicy_DiscloPeriodEndReqSoftcopyFlag]') AND parent_object_id = OBJECT_ID(N'[dbo].[rul_TradingPolicy]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_rul_TradingPolicy_DiscloPeriodEndReqSoftcopyFlag]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[rul_TradingPolicy] ADD  CONSTRAINT [DF_rul_TradingPolicy_DiscloPeriodEndReqSoftcopyFlag]  DEFAULT ((0)) FOR [DiscloPeriodEndReqSoftcopyFlag]
END


End
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_rul_TradingPolicy_DiscloPeriodEndReqHardcopyFlag]') AND parent_object_id = OBJECT_ID(N'[dbo].[rul_TradingPolicy]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_rul_TradingPolicy_DiscloPeriodEndReqHardcopyFlag]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[rul_TradingPolicy] ADD  CONSTRAINT [DF_rul_TradingPolicy_DiscloPeriodEndReqHardcopyFlag]  DEFAULT ((0)) FOR [DiscloPeriodEndReqHardcopyFlag]
END


End
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_rul_TradingPolicy_DiscloPeriodEndSubmitToStExByCOSoftcopyFlag]') AND parent_object_id = OBJECT_ID(N'[dbo].[rul_TradingPolicy]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_rul_TradingPolicy_DiscloPeriodEndSubmitToStExByCOSoftcopyFlag]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[rul_TradingPolicy] ADD  CONSTRAINT [DF_rul_TradingPolicy_DiscloPeriodEndSubmitToStExByCOSoftcopyFlag]  DEFAULT ((0)) FOR [DiscloPeriodEndSubmitToStExByCOSoftcopyFlag]
END


End
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_rul_TradingPolicy_DiscloPeriodEndSubmitToStExByCOHardcopyFlag]') AND parent_object_id = OBJECT_ID(N'[dbo].[rul_TradingPolicy]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_rul_TradingPolicy_DiscloPeriodEndSubmitToStExByCOHardcopyFlag]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[rul_TradingPolicy] ADD  CONSTRAINT [DF_rul_TradingPolicy_DiscloPeriodEndSubmitToStExByCOHardcopyFlag]  DEFAULT ((0)) FOR [DiscloPeriodEndSubmitToStExByCOHardcopyFlag]
END


End
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_rul_TradingPolicy_StExSubmitDiscloToCOByInsdrFlag]') AND parent_object_id = OBJECT_ID(N'[dbo].[rul_TradingPolicy]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_rul_TradingPolicy_StExSubmitDiscloToCOByInsdrFlag]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[rul_TradingPolicy] ADD  CONSTRAINT [DF_rul_TradingPolicy_StExSubmitDiscloToCOByInsdrFlag]  DEFAULT ((0)) FOR [StExSubmitDiscloToCOByInsdrFlag]
END


End
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_rul_TradingPolicy_StExSubmitDiscloToCOByInsdrSoftcopyFlag]') AND parent_object_id = OBJECT_ID(N'[dbo].[rul_TradingPolicy]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_rul_TradingPolicy_StExSubmitDiscloToCOByInsdrSoftcopyFlag]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[rul_TradingPolicy] ADD  CONSTRAINT [DF_rul_TradingPolicy_StExSubmitDiscloToCOByInsdrSoftcopyFlag]  DEFAULT ((0)) FOR [StExSubmitDiscloToCOByInsdrSoftcopyFlag]
END


End
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_rul_TradingPolicy_StExSubmitDiscloToCOByInsdrHardcopyFlag]') AND parent_object_id = OBJECT_ID(N'[dbo].[rul_TradingPolicy]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_rul_TradingPolicy_StExSubmitDiscloToCOByInsdrHardcopyFlag]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[rul_TradingPolicy] ADD  CONSTRAINT [DF_rul_TradingPolicy_StExSubmitDiscloToCOByInsdrHardcopyFlag]  DEFAULT ((0)) FOR [StExSubmitDiscloToCOByInsdrHardcopyFlag]
END


End
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_rul_TradingPolicy_StExForAllSecuritiesFlag]') AND parent_object_id = OBJECT_ID(N'[dbo].[rul_TradingPolicy]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_rul_TradingPolicy_StExForAllSecuritiesFlag]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[rul_TradingPolicy] ADD  CONSTRAINT [DF_rul_TradingPolicy_StExForAllSecuritiesFlag]  DEFAULT ((0)) FOR [StExForAllSecuritiesFlag]
END


End
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_rul_TradingPolicy_IsDeletedFlag]') AND parent_object_id = OBJECT_ID(N'[dbo].[rul_TradingPolicy]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_rul_TradingPolicy_IsDeletedFlag]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[rul_TradingPolicy] ADD  CONSTRAINT [DF_rul_TradingPolicy_IsDeletedFlag]  DEFAULT ((0)) FOR [IsDeletedFlag]
END


End
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'PreClrApprovalReasonReqFlag' AND OBJECT_ID = OBJECT_ID(N'[rul_TradingPolicy]'))
BEGIN
	ALTER TABLE [dbo].[rul_TradingPolicy] ADD  [PreClrApprovalReasonReqFlag][BIT]
END 
GO