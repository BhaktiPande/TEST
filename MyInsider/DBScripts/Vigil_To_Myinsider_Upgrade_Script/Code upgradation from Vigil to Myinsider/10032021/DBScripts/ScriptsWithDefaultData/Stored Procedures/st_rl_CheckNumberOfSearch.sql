IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_rl_CheckNumberOfSearch')
DROP PROCEDURE [dbo].[st_rl_CheckNumberOfSearch]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Check how many times employee search for company

Returns:		1, if Success.
				
Created by:		Priyanka,Rajashri
Created on:		15-Dec-2016

Modification History:
Modified By		Modified On	Description

Usage:
EXEC st_rl_CheckNumberOfSearch 2
-------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[st_rl_CheckNumberOfSearch] 
	@inp_iUserId INT,
	--@inp_iRequiredModule INT,
	@out_parameter          INT = 0 OUTPUT,
	@out_nReturnValue		INT = 0 OUTPUT,
	@out_nSQLErrCode		INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage		NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
	
AS
BEGIN
	
	DECLARE @ERR_DURING_FETCH_MASSUPLOAD_COUNT INT
	
	BEGIN TRY
		SET NOCOUNT ON
		-- interfering with SELECT statements.
		SET NOCOUNT ON;
		SELECT @ERR_DURING_FETCH_MASSUPLOAD_COUNT = 0
		DECLARE @UserCount INT
		DECLARE @SearchLimit INT
		DECLARE @ConfigurationTypeCodeId INT
		DECLARE @ConfigurationCodeId INT
		DECLARE @TradingPolicyId INT
		
		SET @ConfigurationTypeCodeId=180003
		SET @ConfigurationCodeId=185006
		
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0

		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0

		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''
			DECLARE @inp_iRequiredModule INT



			SELECT @inp_iRequiredModule =RequiredModule FROM mst_Company WHERE CompanyId=1

			
       If(@inp_iRequiredModule=513001) --Own Securities
	     BEGIN
		     SET @UserCount = (SELECT COUNT(CreatedOn) FROM dbo.rl_SearchAudit WHERE CONVERT(DATE, [CreatedOn]) = CONVERT(DATE, GETDATE())AND UserInfoId=@inp_iUserId);			
   		     SET @SearchLimit = (SELECT RLSearchLimit FROM com_CompanySettingConfiguration WHERE ConfigurationTypeCodeId=@ConfigurationTypeCodeId AND ConfigurationCodeId=@ConfigurationCodeId);
	     END
	   ELSE IF (@inp_iRequiredModule=513002 OR @inp_iRequiredModule=513003 ) --Other Securities Or Both
	   BEGIN  
	   print(1234)
	        SET @UserCount = (SELECT COUNT(CreatedOn) FROM dbo.rl_SearchAudit WHERE CONVERT(DATE, [CreatedOn]) = CONVERT(DATE, GETDATE())AND UserInfoId=@inp_iUserId);			
			
			SET @TradingPolicyId = (SELECT MAX(MapToId) FROM vw_ApplicableTradingPolicyForUser_OS WHERE UserInfoId=@inp_iUserId);	
				Select @SearchLimit= rl.SearchLimit from rul_TradingPolicy_OS TPOS JOIN rl_RestrictedListConfig RL on TPOS.RestrictedListConfigId=RL.Id
				where TPOS.TradingPolicyId=	@TradingPolicyId	
		END
	  
		--Check whether search limit exceeds by user
		IF (@SearchLimit = 0 or @SearchLimit IS NULL )
		BEGIN	
				SET @out_parameter = 1  --true
				RETURN @out_parameter
		END
		
		ELSE IF(@UserCount<@SearchLimit)
		BEGIN --print 'in'
				SET @out_parameter = 1  --true
				RETURN @out_parameter
		END
		
		ELSE
		BEGIN
				SET @out_parameter=50383 --FALSE
				RETURN (@out_parameter)
		END	
		
		SET @out_nReturnValue = 0
		RETURN @out_nReturnValue
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()
		--print ERROR_MESSAGE()
		-- Return common error if required, otherwise specific error.		
		SET @out_nReturnValue  = dbo.uf_com_GetErrorCode(@ERR_DURING_FETCH_MASSUPLOAD_COUNT, ERROR_NUMBER())
		RETURN @out_nReturnValue		
	END CATCH
	
	SET NOCOUNT OFF
	
END

