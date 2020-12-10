IF EXISTS (SELECT NAME FROM SYS.types WHERE NAME = 'InitialDisListType_OS')
BEGIN
	DROP TYPE InitialDisListType_OS
END
GO

CREATE TYPE [InitialDisListType_OS] AS TABLE(
[TransactionMasterId] [INT]  NULL,
[SecurityTypeCodeId] [INT]  NULL,
[UserInfoId] [INT]  NULL,
[DMATDetailsID] [INT]  NULL,
[CompanyId] [INT]  NULL,
[ModeOfAcquisitionCodeId] [INT] NULL,
[ExchangeCodeId] [INT]  NULL,
[TransactionTypeCodeId] [INT]  NULL,
[SecuritiesToBeTradedQty]	[decimal](15, 4)  NULL,
[SecuritiesToBeTradedValue]	[decimal](20, 4)  NULL,
[LotSize] [INT]  NULL,
[ContractSpecification]	VARCHAR(200) NULL
)


