CREATE TYPE [dbo].[TransactionDetailsIdPCLReqType] AS TABLE(
	[TransactionDetailsId] [BIGINT],
	[IsPCLReq] [int]
)
GO



INSERT INTO DBUpdateStatus (ScriptNumber, ScriptFileName, Description, CreatedBy)
VALUES (190, '190 TransactionDetailsIdPCLReqType_Create', 'Create type TransactionDetailsIdPCLReqType', 'Arundahti')
