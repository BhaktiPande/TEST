IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_tra_DepartmentwiseRestricedListDetails')
DROP PROCEDURE [dbo].[st_tra_DepartmentwiseRestricedListDetails]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ======================================================================================================
-- Author			: Aniket Shingate																	=
-- Created date		: 22-JAN-2018                                                 						=
-- Description		: THIS PROCEDURE USED FOR SAVE SECURITY QUESTIONS									=

-- Modified By	  Modified On		Description

--EXEC st_tra_DepartmentwiseRestricedListDetails
-- ======================================================================================================
CREATE PROCEDURE [dbo].[st_tra_DepartmentwiseRestricedListDetails]
	@out_nReturnValue		INT = 0 OUTPUT,
	@out_nSQLErrCode		INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage		NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
AS
BEGIN
	DECLARE @RestrictedListType INT = 132012	

	BEGIN TRY
	
	SET NOCOUNT ON;
		
		CREATE TABLE #tempVersionNo
        (
        ID INT identity(1,1),
        CompId INT,
        versionNo INT,
        RlMasterId INT,
        MapToId INT,
        statusCodeID INT,
        )
        INSERT INTO #tempVersionNo (CompId,versionNo,RlMasterId,MapToId,statusCodeID)
        select RlCompanyId,MAX(VersionNumber) VersionNo,RlMasterId,MapToId,StatusCodeId FROM rul_ApplicabilityMaster RM
        JOIN  RL_RISTRICTEDMASTERLIST RL
        ON RM.MapToId=RL.RlMasterId
        GROUP BY RlCompanyId,RlMasterId,MapToId,StatusCodeId 

		TRUNCATE TABLE rpt_RestrictedListDetails
		
		INSERT INTO rpt_RestrictedListDetails		

        SELECT DISTINCT RCL.CompanyName,CCDEP.CodeName AS Department, RCL.BSECode, RCL.NSECode, RCL.ISINCode,
        CONVERT(VARCHAR(50), RML.ApplicableFromDate, 106) AS 'Applicable From Date', CONVERT(VARCHAR(50), RML.ApplicableToDate, 106) AS 'Applicable To Date'        
        FROM  #tempVersionNo tmp  

        LEFT JOIN rul_ApplicabilityMaster rAM on tmp.RlMasterId = rAM.MapToId and rAM.VersionNumber=tmp.versionNo
        LEFT JOIN rul_ApplicabilityDetails rAD on rAD.ApplicabilityMstId = rAM.ApplicabilityId        
        left JOIN usr_UserInfo UM ON UM.UserInfoId = rAD.UserId
        LEFT JOIN rl_CompanyMasterList RCL ON RCL.RlCompanyId = tmp.CompId
        LEFT JOIN rl_RistrictedMasterList RML ON RML.RlMasterId = tmp.RlMasterId
        LEFT JOIN com_Code CCDEP ON CCDEP.CodeID = rAD.DepartmentCodeId
        WHERE rAD.IncludeExcludeCodeId =150001 AND tmp.statusCodeID=105001 
        AND rAM.MapToTypeCodeId = 132012 AND rAD.DepartmentCodeId IS NOT NULL    

        --SELECT * FROM #tempVersionNo
       DROP TABLE #tempVersionNo
		
	
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue	=  0
	END CATCH
END