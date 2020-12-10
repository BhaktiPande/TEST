IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vw_ApplicabilityMasterTradingWindowEventOther]'))
DROP VIEW [dbo].[vw_ApplicabilityMasterTradingWindowEventOther]
GO

CREATE VIEW [dbo].[vw_ApplicabilityMasterTradingWindowEventOther]
AS
select TWE.TradingWindowEventId, MAX(ApplicabilityId) AS ApplicabilityId
from rul_TradingWindowEvent TWE JOIN rul_ApplicabilityMaster AM ON AM.MapToId = TWE.TradingWindowEventId AND AM.MapToTypeCodeId = 132009
WHERE TWE.TradingWindowStatusCodeId = 131002
GROUP BY TradingWindowEventId
