/****** Object:  Table [dbo].[tra_ContinuousDisc]    Script Date: 08/17/2018 14:46:46 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tra_ContinuousDisc]') AND type in (N'U'))
BEGIN
	CREATE TABLE [dbo].[tra_ContinuousDisc](
		
		[ID] [int] IDENTITY(1,1) not NULL,		
		[TransactionMasterId] BIGINT  NULL,
		[PreclearanceRequestId] BIGINT NULL,		
		[TradingPolicyId] BIGINT NULL,				
		[Pre_Clearance_ID] VARCHAR(50) NULL,		
		[Pre_Clearance_Request_Date] DATETIME NULL,
		[PreClearance_Status] BIGINT NULL,		
		[PreclearanceValidTill] DATETIME null,		
		[Securities] VARCHAR(50) NULL,		
		[Transaction_Type] VARCHAR(50) NULL,			
		[Trading_Details_Submission] bigint NULL,		
		[SubmmisonWithin] VARCHAR(50) NULL,				
		[ContinuousDisclosureSubmitWithinText] VARCHAR(50) NULL,		
		[Disclosure_Details_Softcopy] BIGINT NULL,		
		[Disclosure_Details_Hardcopy] BIGINT NULL,				
		[HardcopySubmissionButtonText] VARCHAR(50) NULL,		
		[ContinuousDisclosureSubmissionDate] DATETIME NULL,				
		[SoftcopySubmissionButtonText] VARCHAR(50) NULL,
		[PreClearanceStatusButtonText] VARCHAR(50) NULL,		
		[TradingDetailsStatusButtonText] VARCHAR(50) NULL,				
		[HardcopySubmissionwithin] VARCHAR(50) NULL,
		[HardcopySubmissionwithinText] VARCHAR(50) NULL,				
		[SoftcopySubmissionDate] DATETIME NULL,
		[HardcopySubmissionDate] DATETIME NULL,		
		[Submission_to_Stock_Exchange] BIGINT NULL,		
		[HardCopySubmitCOToExchangeDate] DATETIME NULL,		
		[HardCopySubmitCOToExchangeButtonText] VARCHAR(50) NULL,		
		[HardCopySubmitCOToExchangeWithin] VARCHAR(50) NULL,
		[HardCopySubmitCOToExchangeWithinText] VARCHAR(50) NULL,		
		[EmployeeID] VARCHAR(50) NULL,		
		[PAN] VARCHAR(50) NULL,
		[EmployeeStatus] VARCHAR(50) NULL,
		[EmployeeStatusCodeID] BIGINT NULL,
		[DateOfSeparation] VARCHAR(50)NULL,
		[DesignationText] VARCHAR(50) NULL,				
		[InsiderName] [nvarchar] (500) NULL,				
		[PreClearance_Qty] DECIMAL(15,4) NULL,		
		[IsAddButtonRow] VARCHAR(50) NULL,
		[UserInfoID] INT  NULL,		
		[IsPartiallyTraded] INT NULL,				
		[ShowAddButton] INT NULL,		
		[ReasonForNotTradingCodeId] VARCHAR(500) NULL,				
		[Trade_Qty] VARCHAR(500) NULL,		
		[NotTradedStatus1] VARCHAR(50) NULL,				
		[IsAutoApproved] INT NULL,
		[IsAutoApprovedText] VARCHAR(50) NULL,				
		[Total_Traded_Value] VARCHAR(50) NULL,		
		[IsPreclearanceFormForImplementingCompany] INT NULL,		
		[IsFORMEGenrated] INT NULL,		
		[IsEnterAndUploadEvent] INT NULL,
		[Name] VARCHAR(500) NULL,
		[Individual_Traded_Value] VARCHAR(50) NULL
		
		
	CONSTRAINT [PK_tra_ContinuousDisc] PRIMARY KEY CLUSTERED 
	(
		[ID] ASC
	)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
	) ON [PRIMARY]
END
GO

SET ANSI_PADDING OFF
GO
