
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vw_ApplicabilityMasterCurrentRL]'))
DROP VIEW [dbo].[vw_ApplicabilityMasterCurrentRL]
GO


CREATE VIEW [dbo].[vw_ApplicabilityMasterCurrentRL]
AS
WITH tblRestrictedList
AS
(
 SELECT  RlMasterId, RlCompanyId,ApplicableFromDate,ApplicableToDate 
 FROM (

       select RL.RlMasterId,RL.RlCompanyId, ApplicableFromDate,ApplicableToDate from rl_RistrictedMasterList RL
	   where StatusCodeId=105001 and
	   RL.ApplicableFromDate <= dbo.uf_com_GetServerDate() AND RL.ApplicableToDate >= dbo.uf_com_GetServerDate()    
	  ) TblResult --GROUP BY RlCompanyId 
)
SELECT AM.ApplicabilityId, RlMasterId, AM.MapToId, RlCompanyId, UserId, ApplicableFromDate, ApplicableToDate FROM rul_ApplicabilityMaster AM JOIN
(SELECT MapToId, MAX(ApplicabilityId) AS ApplicabilityId, tblTP.RlMasterId, tblTP.RlCompanyId, Ad.UserId, tblTP.ApplicableFromDate, tblTP.ApplicableToDate
FROM rul_ApplicabilityMaster AM JOIN rul_ApplicabilityDetails AD ON MapToTypeCodeId = 132012 AND AM.ApplicabilityId = AD.ApplicabilityMstId
INNER JOIN tblRestrictedList tblTP ON AM.MapToId = tblTP.RlMasterId
GROUP BY  MapToId,ApplicableFromDate,ApplicableToDate,RlMasterId,UserId,RlCompanyId) AS AMCurrent
ON AM.ApplicabilityId = AMCurrent.ApplicabilityId

--select * from [dbo].[vw_ApplicabilityMasterCurrentRL]

--SELECT distinct  MAX(AD.ApplicabilityMstId) ApplicabilityMstId, UF.UserInfoId, 0, vwAppMaster.MapToId
--FROM rul_ApplicabilityDetails AD JOIN usr_UserInfo UF ON /*UF.IsInsider = 1 AND */ UF.DateOfBecomingInsider IS NOT NULL AND UF.DateOfBecomingInsider <= dbo.uf_com_GetServerDate() AND UF.UserTypeCodeId = AD.InsiderTypeCodeId
--JOIN vw_ApplicabilityMasterCurrentRL vwAppMaster ON vwAppMaster.ApplicabilityId = AD.ApplicabilityMstId
--where uf.UserInfoId=186
--GROUP BY UF.UserInfoId, MapToId

--select * from rul_ApplicabilityDetails


GO


