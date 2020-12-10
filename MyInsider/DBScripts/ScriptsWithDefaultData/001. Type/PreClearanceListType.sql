IF EXISTS (SELECT NAME FROM SYS.types WHERE NAME = 'PreClearanceListType')
BEGIN
	DROP TYPE PreClearanceListType
END
GO

CREATE TYPE [PreClearanceListType] AS TABLE(
	[PreclearanceRequestId]			[INT] NULL,	
	[RlSearchAuditId][INT] NOT NULL,
	[PreclearanceRequestForCodeId]	[INT] NOT NULL,	
	[UserInfoId]	[INT] NOT NULL,
	[UserInfoIdRelative]	[INT] NULL,
	[TransactionTypeCodeId]	[INT] NOT NULL,
	[SecurityTypeCodeId]	[INT] NOT NULL,
	[SecuritiesToBeTradedQty]	[decimal](15, 4) NOT NULL,
	[SecuritiesToBeTradedValue]	[decimal](20, 4) NOT NULL,
	[ModeOfAcquisitionCodeId]	[INT] NOT NULL,
	[DMATDetailsID]	[INT] NOT NULL,
	[PreclearanceStatusCodeId]	[INT] NOT NULL,
	[CompanyId]	[INT] NOT NULL,
	[ApprovedBy] [INT] NOT NULL
)