IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_com_GetAccess')
DROP PROCEDURE [dbo].[st_com_GetAccess]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Procedure For validating user access for specified page, user should not view or modify other user details.

Returns:		0, if Success.
				
Created by:		Gaurishankar
Created on:		22-Feb-2016

Modification History:
Modified By		Modified On		Description

Usage:
DECLARE @inp_iMapToTypeCodeId INT = 132003,						-- Map to type code id.
@inp_iMapToId BIGINT = 31,								-- Map to id
@inp_iLoggenInUserId INT = 19,						-- USer Info ID.
@out_nIsAccess  BIT,
@out_nReturnValue	INT = 0 ,				-- Output Error number, if Error occured.
@out_nSQLErrCode	INT = 0 ,				-- Output SQL Error Number, if error occurred.
@out_sSQLErrMessage	 VARCHAR(500) = '',
@RC INT

EXEC @RC = st_com_GetAccess @inp_iMapToTypeCodeId, @inp_iMapToId, @inp_iLoggenInUserId, @out_nIsAccess output,
			@out_nReturnValue output, @out_nSQLErrCode output,@out_sSQLErrMessage output
 
SELECT @out_nIsAccess, @out_nReturnValue , @out_nSQLErrCode ,@out_sSQLErrMessage,@RC

----------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_com_GetAccess]
@inp_iMapToTypeCodeId INT,						-- Map to type code id.
@inp_iMapToId BIGINT,								-- Map to id
@inp_iLoggenInUserId INT,						-- USer Info ID.
@out_nIsAccess  BIT = 0 OUTPUT,			-- Redirectin to Number.
@out_nReturnValue	INT = 0 OUTPUT,				-- Output Error number, if Error occured.
@out_nSQLErrCode	INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
@out_sSQLErrMessage	VARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
AS
BEGIN
--------------------------------------------------------------------------------
	
	DECLARE @MapToTypePolicyDocument INT = 132001
	DECLARE @MapToTypeTradingPolicy INT = 132002
	DECLARE @MapToTypeUser INT = 132003
	DECLARE @MapToTypePreclearance INT = 132004
	DECLARE @MapToTypeDisclosureTransaction INT = 132005
	DECLARE @MapToTypeTradingWindowOther INT = 132009
	DECLARE @MapToTypeDefaulterReport INT = 132011
	DECLARE @nUserTypeCodeId INT
	DECLARE @ERR_GETDETAILS INT = 11034
	DECLARE @NEMPLOYEE INT = 101003
	DECLARE @NCORPORATEUSER INT = 101004
	DECLARE @NNONEMPLOYEE INT = 101006
	
	BEGIN TRY
		SELECT @nUserTypeCodeId = UserTypeCodeId FROM usr_UserInfo WHERE UserInfoId = @inp_iLoggenInUserId		
		SELECT @out_nIsAccess = 0
		IF(@nUserTypeCodeId in (@NEMPLOYEE,@NNONEMPLOYEE,@NCORPORATEUSER) )
		BEGIN
			IF (@inp_iMapToTypeCodeId = @MapToTypePolicyDocument ) -- Policy Document
			BEGIN		
				IF (EXISTS(SELECT ApplicabilityMstId FROM vw_ApplicablePolicyDocumentForUser WHERE UserInfoId = @inp_iLoggenInUserId AND MapToId = @inp_iMapToId ))
				BEGIN					
					SELECT @out_nIsAccess = 1
				END
			END
			ELSE IF (@inp_iMapToTypeCodeId = @MapToTypeTradingPolicy )  -- Trading Policy 
			BEGIN			
				IF (EXISTS(SELECT ApplicabilityMstId FROM vw_ApplicableTradingPolicyForUser WHERE UserInfoId = @inp_iLoggenInUserId AND MapToId = @inp_iMapToId ))
				BEGIN				
					SELECT @out_nIsAccess = 1
				END
			END
			ELSE IF (@inp_iMapToTypeCodeId = @MapToTypeUser ) -- User Or it's Relative			
			BEGIN			
				IF ( @inp_iLoggenInUserId = @inp_iMapToId OR EXISTS(SELECT UserRelationId FROM usr_UserRelation WHERE UserInfoId = @inp_iLoggenInUserId AND UserInfoIdRelative = @inp_iMapToId ))
				BEGIN				
					SELECT @out_nIsAccess = 1
				END
			END
			ELSE IF (@inp_iMapToTypeCodeId = @MapToTypePreclearance )--Preclearance
			BEGIN			
				IF ( EXISTS(SELECT PreclearanceRequestId FROM tra_PreclearanceRequest WHERE UserInfoId = @inp_iLoggenInUserId AND PreclearanceRequestId = @inp_iMapToId ))
				BEGIN				
					SELECT @out_nIsAccess = 1
				END
			END
			ELSE IF (@inp_iMapToTypeCodeId = @MapToTypeDisclosureTransaction ) -- Disclosure Transaction
			BEGIN			
				IF (EXISTS(SELECT TransactionMasterId FROM tra_TransactionMaster WHERE UserInfoId 
				IN(SELECT UserInfoId FROM usr_UserInfo WHERE usr_UserInfo.UserInfoId=@inp_iLoggenInUserId
				UNION SELECT usr_UserRelation.UserInfoIdRelative AS UserInfoId FROM usr_UserInfo
				JOIN usr_UserRelation ON usr_UserInfo.UserInfoId=usr_UserRelation.UserInfoId
				WHERE usr_UserInfo.UserInfoId=@inp_iLoggenInUserId) AND TransactionMasterId = @inp_iMapToId ))
				BEGIN				
					SELECT @out_nIsAccess = 1
				END	
				IF (EXISTS(SELECT TransactionMasterId FROM tra_TransactionMaster_OS WHERE UserInfoId 
				IN(SELECT UserInfoId FROM usr_UserInfo WHERE usr_UserInfo.UserInfoId=@inp_iLoggenInUserId
				UNION SELECT usr_UserRelation.UserInfoIdRelative AS UserInfoId FROM usr_UserInfo
				JOIN usr_UserRelation ON usr_UserInfo.UserInfoId=usr_UserRelation.UserInfoId
				WHERE usr_UserInfo.UserInfoId=@inp_iLoggenInUserId) AND TransactionMasterId = @inp_iMapToId ))
				BEGIN				
					SELECT @out_nIsAccess = 1
				END					
			END
			ELSE
			BEGIN
				SELECT @out_nIsAccess = 0
			END	
			SELECT 1
			SELECT @out_nReturnValue = 0
			RETURN 0		
		END
		ELSE
		BEGIN		
			SELECT 1
			SELECT @out_nIsAccess = 1
			SELECT @out_nReturnValue = 0
			RETURN 0
		END
		
	END TRY
	BEGIN CATCH
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()	
		
		-- Return common error if required, otherwise specific error.		
		SET @out_nReturnValue	=  @ERR_GETDETAILS
		RETURN @out_nReturnValue
	END CATCH
END

