/*

Created By :- Tushar
Created On - 23 Mar 2016
Description :-  Create Table rul_TradingPolicyForSecurityMode

*/
----------------------------------------------------------------------------------------------------------------

SET NOCOUNT ON;
IF EXISTS (SELECT NAME FROM SYS.tables WHERE NAME = 'rul_TradingPolicyForSecurityMode')
BEGIN
	DROP TABLE rul_TradingPolicyForSecurityMode
END
GO

Create Table rul_TradingPolicyForSecurityMode
(
	TradingPolicyId INT NOT NULL, 
	MapToTypeCodeID INT NOT NULL, 
	SecurityTypeCodeID INT NOT NULL, 
)
-- add foreign key on activity id field
ALTER TABLE rul_TradingPolicyForSecurityMode ADD CONSTRAINT 
	FK_rul_TradingPolicyForSecurityMode_rul_TradingPolicy_TradingPolicyId  FOREIGN KEY(TradingPolicyId) REFERENCES rul_TradingPolicy (TradingPolicyId)
	

CREATE TABLE #TEMP
(
	SR_NO INT IDENTITY(1,1) PRIMARY KEY,
	TradingPolicyStatusCodeId INT,
	TradingPolicyId INT
)

INSERT INTO #TEMP
SELECT TradingPolicyStatusCodeId,TradingPolicyId FROM rul_TradingPolicy WHERE TradingPolicyStatusCodeId = 141002		


DECLARE @MAX_IDT INT,
		@MIN_IDT INT		
		
SELECT @MAX_IDT = MAX(SR_NO), @MIN_IDT = MIN(SR_NO) FROM #TEMP	


WHILE @MIN_IDT <= @MAX_IDT
BEGIN
	
	DECLARE @TradingPolicyId INT
	SET @TradingPolicyId = (SELECT TradingPolicyId FROM #TEMP WHERE SR_NO = @MIN_IDT)
	
	IF NOT EXISTS (SELECT TradingPolicyId FROM rul_TradingPolicyForSecurityMode WHERE TradingPolicyId = @TradingPolicyId)
	BEGIN	
		INSERT INTO rul_TradingPolicyForSecurityMode(TradingPolicyId, MapToTypeCodeID, SecurityTypeCodeID)
		VALUES ((SELECT TradingPolicyId FROM #TEMP WHERE SR_NO = @MIN_IDT), 132013, 139001)
			
		SET @MIN_IDT = @MIN_IDT + 1	
	END 
END

DROP TABLE #TEMP
SET NOCOUNT OFF;
GO
