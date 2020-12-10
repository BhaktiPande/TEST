IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_tra_GetTradingPolicyIDfor_OS')
DROP PROCEDURE [dbo].[st_tra_GetTradingPolicyIDfor_OS]
GO
/****** Object:  StoredProcedure [dbo].[st_tra_GetTradingPolicyIDfor_OS]    Script Date: 17/02/2019 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	This Procedure is used to fetch trading policy Id for Others.

Returns:		0, if Success.
				
Created by:		Shubhangi Gurude
Created on:		17-Feb-2019

-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_tra_GetTradingPolicyIDfor_OS]
     @inp_iUserInfoId				                INT
	,@out_nReturnValue								INT			 = 0	OUTPUT
	,@out_nSQLErrCode								INT			 = 0	OUTPUT	-- Output SQL Error Number, if error occurred.
	,@out_sSQLErrMessage							VARCHAR(500) = ''	OUTPUT  -- Output SQL Error Message, if error occurred.	
---------------------------------------------------------------------------
AS
BEGIN
	
	--Variable Declaration
	DECLARE @ERR_PPDReConfirmation_Frequency			       INT = 50782	
	
	BEGIN TRY
	
		SET NOCOUNT ON;
		-- Declare variables
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''

		DECLARE @nUserTypeCodeId INT=0
		SELECT @nUserTypeCodeId=UserTypeCodeId FROM usr_UserInfo WHERE UserInfoId=@inp_iUserInfoId
		IF(@nUserTypeCodeId=101003)
		BEGIN
			SELECT  ISNULL(MAX(MapToId), 0) as TradingPolicyID_OS FROM vw_ApplicableTradingPolicyForUser_OS  where UserInfoId = @inp_iUserInfoId
		END
		ELSE
		BEGIN
			SELECT 0 AS TradingPolicyID_OS
		END
    RETURN 0
	END	TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue	=  @ERR_PPDReConfirmation_Frequency
	END CATCH
END
