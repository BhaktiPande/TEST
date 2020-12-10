/*

Created By :- Shubhangi Gurude
Created On - 07 Nov 2018
Description :-  Create Table rul_TradingPolicyForProhibitSecurityTypes to save prohibit preclearence security types

*/
----------------------------------------------------------------------------------------------------------------

SET NOCOUNT ON;
IF EXISTS (SELECT NAME FROM SYS.tables WHERE NAME = 'rul_TradingPolicyForProhibitSecurityTypes')
BEGIN
	DROP TABLE rul_TradingPolicyForProhibitSecurityTypese
END
GO

Create Table rul_TradingPolicyForProhibitSecurityTypes
(
	TradingPolicyId INT NOT NULL,	
	SecurityTypeCodeID INT NOT NULL, 
)
-- add foreign key on activity id field
ALTER TABLE rul_TradingPolicyForProhibitSecurityTypes ADD CONSTRAINT 
	FK_rul_TradingPolicyForProhibitSecurityTypes_rul_TradingPolicy_TradingPolicyId  FOREIGN KEY(TradingPolicyId) REFERENCES rul_TradingPolicy (TradingPolicyId)
	
SET NOCOUNT OFF;
GO
