
/*
Modified By	Modified On	Description
Arundhati	13-Jul-2015	Added condition of ApplicableFrom
Raghvendra	07-Sep-2016	Changed the GETDATE() call with function dbo.uf_com_GetServerDate(). This function will return the date to be used as server date.
*/

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vw_ApplicabilityMasterCurrentPolicyDocument]'))
DROP VIEW [dbo].[vw_ApplicabilityMasterCurrentPolicyDocument]
GO

CREATE VIEW [dbo].[vw_ApplicabilityMasterCurrentPolicyDocument]
AS
select PD.PolicyDocumentId, MAX(ApplicabilityId) AS ApplicabilityId
from rul_PolicyDocument PD JOIN rul_ApplicabilityMaster AM ON AM.MapToId = PD.PolicyDocumentId AND AM.MapToTypeCodeId = 132001
WHERE PD.WindowStatusCodeId = 131002
AND (PD.ApplicableTo IS NULL OR PD.ApplicableTo >= CONVERT(DATETIME, CONVERT(VARCHAR(11), dbo.uf_com_GetServerDate())))
AND PD.ApplicableFrom <= dbo.uf_com_GetServerDate()
GROUP BY PolicyDocumentId
