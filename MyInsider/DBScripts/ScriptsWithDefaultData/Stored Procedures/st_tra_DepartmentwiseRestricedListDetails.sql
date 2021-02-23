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
		
		TRUNCATE TABLE rpt_RestrictedListDetails
		
		INSERT INTO rpt_RestrictedListDetails
		
		SELECT DISTINCT RCL.CompanyName,CCDEP.CodeName AS Department, RCL.BSECode, RCL.NSECode, RCL.ISINCode,
		CONVERT(VARCHAR(50), RML.ApplicableFromDate, 106) AS 'Applicable From Date', CONVERT(VARCHAR(50), RML.ApplicableToDate, 106) AS 'Applicable To Date'		
		FROM RL_RISTRICTEDMASTERLIST RL
		LEFT JOIN rul_ApplicabilityMaster rAM on RL.RlMasterId = rAM.MapToId 
		LEFT JOIN rul_ApplicabilityDetails rAD on rAD.ApplicabilityMstId = rAM.ApplicabilityId		
		LEFT JOIN usr_UserInfo UM ON UM.UserInfoId = rAD.UserId
		LEFT JOIN rl_CompanyMasterList RCL ON RCL.RlCompanyId = RL.RlCompanyId
		LEFT JOIN rl_RistrictedMasterList RML ON RML.RlMasterId = RL.RlMasterId
		LEFT JOIN com_Code CCDEP ON CCDEP.CodeID = UM.DepartmentId	
		WHERE rAD.IncludeExcludeCodeId =150001 AND RL.StatusCodeId=105001 
		AND rAM.MapToTypeCodeId = @RestrictedListType		
	
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue	=  0
	END CATCH
END