IF (OBJECT_ID('st_rl_GETCompanyMasterDetails','P')) IS NOT NULL
	DROP PROCEDURE st_rl_GETCompanyMasterDetails
GO
/*-------------------------------------------------------------------------------------------------
Description:	Received from Esop Direct

Returns:		
				
Created by:		ED
Created on:		13-Oct-2015

Modification History:
Modified By		Modified On	Description

Usage:
-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE st_rl_GETCompanyMasterDetails
	@inp_iUserInfoId		INT,						-- Id of the NotificationQueue whose details are to be fetched.
	@inp_iCase				INT,
	@inp_iParam1			VARCHAR(100),	
	@out_nReturnValue		INT = 0 OUTPUT,
	@out_nSQLErrCode		INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage		NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @ERR_NOTIFICATIONQUEUE_GETDETAILS INT
	DECLARE @ERR_NOTIFICATIONQUEUE_NOTFOUND INT,
	 @inp_sParam1 INT= 103301--103013
	 
	IF @out_nReturnValue IS NULL
		SET @out_nReturnValue = 0
	IF @out_nSQLErrCode IS NULL
		SET @out_nSQLErrCode = 0
	IF @out_sSQLErrMessage IS NULL
		SET @out_sSQLErrMessage = '' 
	 
	 
	BEGIN TRY
		IF(@inp_iCase=1)
		BEGIN
			IF(@inp_iParam1 IS NOT NULL)
			BEGIN
				SELECT RlCompanyID AS RlCompanyId,RL.CompanyName AS CompanyName, BSECode AS BSECode, NSECode AS NSECode, ISINCode AS ISINCode  
				FROM rl_CompanyMasterList RL
				JOIN com_Code code On RL.ModuleCodeId = code.CodeID
				WHERE RL.StatusCodeID = 105001 AND ModuleCodeId = @inp_sParam1 and RL.RlCompanyId = @inp_iParam1
			END
		END	
		--
		IF(@inp_iCase = 2)
		BEGIN
			IF(@inp_iParam1 IS NOT NULL)
			BEGIN
				SELECT	RLML.RlMasterId,RLML.RlCompanyId,RLML.ModuleCodeId,Convert(Date,RLML.ApplicableFromDate) AS ApplicableFromDate,
						Convert(Date,RLML.ApplicableToDate) AS ApplicableToDate,RLML.StatusCodeId,RLML.CreatedBy,
						RLML.CreatedOn,RLML.ModifiedBy,RLML.ModifiedOn,
						RLCL.CompanyName,RLCL.BSECode,RLCL.NSECode,RLCL.ISINCode,
						UI.UserInfoId,UI.FirstName +' '+ UI.LastName AS UserName
				FROM	rl_RistrictedMasterList RLML
				JOIN	rl_CompanyMasterList RLCL ON RLCL.RlCompanyId = RLML.RlCompanyId
				JOIN	usr_UserInfo UI ON UI.UserInfoId = RLML.CreatedBy
				WHERE	RLCL.StatusCodeID = 105001 AND RLML.RLMASTERID = @inp_iParam1
			END
		END	 
	END TRY
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()
		
		-- Return common error if required, otherwise specific error.		
		SET @out_nReturnValue  = dbo.uf_com_GetErrorCode(@ERR_NOTIFICATIONQUEUE_GETDETAILS, ERROR_NUMBER())
		RETURN @out_nReturnValue		
	END CATCH
	--SET NOCOUNT OFF;
END