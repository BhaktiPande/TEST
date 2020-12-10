

/*
Modified By	Modified On	Description
Raghvendra	07-Sep-2016	Changed the GETDATE() call with function dbo.uf_com_GetServerDate(). This function will return the date to be used as server date.
*/

IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vw_ApplicabilityMasterCurrentPolicyDocument_ForNotification]'))
DROP VIEW [dbo].[vw_ApplicabilityMasterCurrentPolicyDocument_ForNotification]
GO

CREATE VIEW [dbo].[vw_ApplicabilityMasterCurrentPolicyDocument_ForNotification]
AS
select PD.PolicyDocumentId, MAX(ApplicabilityId) AS ApplicabilityId
--,PD.ApplicableFrom, PD.ApplicableTo
from rul_PolicyDocument PD JOIN rul_ApplicabilityMaster AM ON AM.MapToId = PD.PolicyDocumentId AND AM.MapToTypeCodeId = 132001
WHERE PD.WindowStatusCodeId = 131002
AND (PD.ApplicableTo IS NULL OR PD.ApplicableTo >= CONVERT(DATETIME, CONVERT(VARCHAR(11), dbo.uf_com_GetServerDate())))
AND (PD.ApplicableFrom <=  CONVERT(DATETIME, CONVERT(VARCHAR(11), dbo.uf_com_GetServerDate()) ) )
GROUP BY PolicyDocumentId
--,PD.ApplicableFrom, PD.ApplicableTo

