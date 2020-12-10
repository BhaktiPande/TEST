IF EXISTS (SELECT NAME FROM SYS.types WHERE NAME = 'TransactionDetailsIdPCLReqType')
BEGIN
	DROP TYPE TransactionDetailsIdPCLReqType
END
GO

CREATE TYPE [dbo].[TransactionDetailsIdPCLReqType] AS TABLE(
	[TransactionDetailsId] [BIGINT],
	[IsPCLReq] [int]
)
GO