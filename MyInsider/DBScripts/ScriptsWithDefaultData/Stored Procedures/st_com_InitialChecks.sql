IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_com_InitialChecks')
DROP PROCEDURE [dbo].[st_com_InitialChecks]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
Description:	Procedure For applying initial checks for logged in user.

Returns:		0, if Success.
				
Created by:		Swapnil
Created on:		12-May-2015

Modification History:
Modified By		Modified On		Description
Swapnil			16-May-2015		Change in @EventInitialDisclosureEntered for checking Initial disclosure status is confirmed or not
								and added @DISCLOSURETRANSACTION = 132005.
Swapnil			29-may-2015		Added two ValidationType and redirection to null for Non Insider.
Swpanil			29-May-2015		If every Condition Fails then return true by setting @out_nRedirectionType = 0
Raghvendra		07-Sep-2016	Changed the GETDATE() call with function dbo.uf_com_GetServerDate(). This function will return the date to be used as server date.

Usage:
EXEC st_com_InitialChecks
****************************************************************************************************
Redirect To (Returns as a Value of @out_nRedirectionType)
Number - Description.
----------------------
1 - Redirect to Insider Initial Disclosure as It is not disclosed by logged in user
2 - Redirect to Accept new policy if applciable to logged in user
----------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_com_InitialChecks]
@inp_iValidationType INT,						-- Initial check called from.
@inp_iLoggenInUserId INT,						-- USer Info ID.
@out_nRedirectionType  INT = 0 OUTPUT,			-- Redirectin to Number.
@out_nReturnValue	INT = 0 OUTPUT,				-- Output Error number, if Error occured.
@out_nSQLErrCode	INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
@out_sSQLErrMessage	VARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
AS
BEGIN
--------------------------------------------------------------------------------
DECLARE @RedirectToInitialDisclosurePage	INT = 1,
		@RedirectToPolicyDisplayPage		INT = 2 
---------------------------------------------------------------------------------
	
	DECLARE @DOBI DATETIME
	DECLARE @MapToTypePolicyDocument INT = 132001
	DECLARE @EventInitialDisclosureEntered INT = 153035
	DECLARE @POLICYDOCUMENTACTIVE INT = 131002
	DECLARE @DISCLOSURETRANSACTION INT = 132005
	DECLARE @CountForFinalResultTable INT = 0
	BEGIN TRY
	
	SELECT @DOBI = DateOfBecomingInsider from usr_UserInfo where UserInfoId = @inp_iLoggenInUserId
	IF(@DOBI < dbo.uf_com_GetServerDate() AND @DOBI IS NOT NULL)
	BEGIN	
		IF(@inp_iValidationType = 1 OR @inp_iValidationType = 2 OR @inp_iValidationType = 3 OR @inp_iValidationType = 4)
		BEGIN	
			IF(NOT EXISTS(SELECT EventLogId FROM eve_EventLog WHERE EventCodeId = @EventInitialDisclosureEntered and UserInfoId = @inp_iLoggenInUserId AND MapToTypeCodeId = @DISCLOSURETRANSACTION ))
			BEGIN	
			
				SET @out_nRedirectionType = @RedirectToInitialDisclosurePage
			END
			ELSE
			BEGIN	
				DECLARE @FinalResult TABLE (SequenceNumber INT IDENTITY(1,1),PolicyDocumentId INT,DocumentId INT,CalledFrom VARCHAR(10))
				
				INSERT INTO @FinalResult(PolicyDocumentId,DocumentId,CalledFrom)
				SELECT	VW.MapToId,d.DocumentId,'ViewAgree'
				FROM	vw_ApplicablePolicyDocumentForUser VW 				
						JOIN com_DocumentObjectMapping d ON VW.MapToId = d.MapToId 
						JOIN rul_PolicyDocument p1 ON p1.PolicyDocumentId = d.MapToId
				WHERE	VW.UserInfoId = @inp_iLoggenInUserId 
						AND d.MapToTypeCodeId = @MapToTypePolicyDocument AND p1.WindowStatusCodeId = @POLICYDOCUMENTACTIVE					
						AND VW.MapToId NOT IN(
												SELECT	DISTINCT e.MapToId 
												FROM	eve_EventLog e 
														JOIN vw_ApplicablePolicyDocumentForUser v ON v.MapToId = e.MapToId 
														JOIN rul_PolicyDocument p ON v.MapToId = p.PolicyDocumentId  
												WHERE	e.UserInfoId = @inp_iLoggenInUserId AND e.MapToTypeCodeId = @MapToTypePolicyDocument 
														AND p.IsDeleted = 0 AND p.WindowStatusCodeId = @POLICYDOCUMENTACTIVE 
														AND (e.EventCodeId = 153027 OR e.EventCodeId = 153028)
							                 )
				
				select @CountForFinalResultTable = COUNT(*) from @FinalResult				
				IF(@CountForFinalResultTable > 0)
				BEGIN
					SET @out_nRedirectionType = @RedirectToPolicyDisplayPage
					SELECT TOP 1 PolicyDocumentId,DocumentId,CalledFrom FROM @FinalResult
				END								
			END	
		END		
		IF(	@out_nRedirectionType IS NULL)
		BEGIN
		SET @out_nRedirectionType = 0
		END
		SET @out_nReturnValue = 0
		RETURN @out_nReturnValue		
	 END
	 ELSE
	 BEGIN
		SET @out_nRedirectionType = 0
		SET @out_nReturnValue = 0
		RETURN @out_nReturnValue
	 END	
	END TRY
	BEGIN CATCH
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()	
		
		-- Return common error if required, otherwise specific error.		
		SET @out_nReturnValue =  0
		RETURN @out_nReturnValue
	END CATCH
END
