CREATE TYPE TradingPolicyForTransactionSecurityMap AS TABLE 
(
	MapToTypeCodeID INT,
	TransactionModeCodeId INT,
	SecurityTypeCodeId INT
)
----------------------------------------------------------------------------------------------------------------
INSERT INTO DBUpdateStatus (ScriptNumber, ScriptFileName, Description, CreatedBy)
VALUES (167, '167 Create_TableType_TradingPolicyForTransactionSecurityMap', 'Create TableType TradingPolicyForTransactionSecurityMap', 'Ashashree')


