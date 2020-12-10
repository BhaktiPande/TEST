IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vw_ApplicabilityMasterCurrentCommunicationRule]'))
DROP VIEW [dbo].[vw_ApplicabilityMasterCurrentCommunicationRule]
GO

CREATE VIEW [dbo].[vw_ApplicabilityMasterCurrentCommunicationRule]
AS
SELECT  CRM.RuleId AS RuleId, MAX(AM.ApplicabilityId) AS ApplicabilityId
FROM cmu_CommunicationRuleMaster CRM INNER JOIN rul_ApplicabilityMaster AM
ON CRM.RuleId = AM.MapToId AND AM.MapToTypeCodeId = 132006
GROUP BY CRM.RuleId
