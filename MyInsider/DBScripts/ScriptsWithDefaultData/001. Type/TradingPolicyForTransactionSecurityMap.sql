IF EXISTS (SELECT NAME FROM SYS.types WHERE NAME = 'TradingPolicyForTransactionSecurityMap')
BEGIN
	DROP TYPE TradingPolicyForTransactionSecurityMap
END
GO

CREATE TYPE TradingPolicyForTransactionSecurityMap AS TABLE 
(
	MapToTypeCodeID INT,
	TransactionModeCodeId INT,
	SecurityTypeCodeId INT
)
