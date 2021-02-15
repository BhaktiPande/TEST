
IF EXISTS (SELECT NAME FROM SYS.types WHERE NAME = 'InitialDisListType')
BEGIN
	IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_tra_SaveInitialDisclosureList')
		DROP PROCEDURE st_tra_SaveInitialDisclosureList
		
	DROP TYPE InitialDisListType
END
GO


CREATE TYPE [InitialDisListType] AS TABLE(
[TransactionMasterId] [INT]  NULL,
[SecurityTypeCodeId] [INT]  NULL,
[UserInfoId] [INT]  NULL,
[DMATDetailsID] [INT]  NULL,
[CompanyId] [INT]  NULL,
[ModeOfAcquisitionCodeId] [INT] NULL,
[ExchangeCodeId] [INT]  NULL,
[TransactionTypeCodeId] [INT]  NULL,
[SecuritiesToBeTradedQty]	[decimal](15, 4)  NULL,
[ESOPQty] [decimal](15, 4) NULL,
[OtherthanESOPQty] [decimal](15, 4)  NULL,
[SecuritiesToBeTradedValue]	[decimal](20, 4)  NULL,
[LotSize] [INT]  NULL,
[ContractSpecification]	VARCHAR(200) NULL
)


