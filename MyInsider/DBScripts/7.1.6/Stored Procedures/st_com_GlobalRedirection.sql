IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_com_GlobalRedirection')
DROP PROCEDURE [dbo].[st_com_GlobalRedirection]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
Description:	Procedure For handling the redirection at global level.

Returns:		0, if Success.
				
Created by:		Swapnil
Created on:		03-Sept-2015

Modification History:
Modified By		Modified On		Description
Swapnil M		9-Sept-2015		Removed DateOfBecomingInsider condition.
Parag			16-Sep-2015		Made change to add condition before initial disclosure check to check if user has confirm persoanl details or not 
Parag			23-Sep-2015		Change to use proper acid for each type of user when check for personal details confirmation
Raghvendra		31-Oct-2015		Change to not check filter condition if called from initial disclosure screen
Raghvendra		3-Nov-2015		Fix for checking the initial disclosures completion condition only after the personal details filter is confirmed.
Arundhati		4-Nov-2015		While assigning to variable @sPolicyDocument, string + Int was taken, which was giving conversion fail error
Usage:
EXEC st_com_GlobalRedirection '',,
****************************************************************************************************
Redirect To (Returns as a Value of @out_nRedirectionType)
Number - Description.
----------------------
1 - Redirect to Insider Initial Disclosure as It is not disclosed by logged in user
2 - Redirect to Accept new policy if applciable to logged in user and Initial Disclosure is submitted.
3 - Redirect to Insider personal details page (employee and non-employee)
4 - Redirect to Insider personal details page (corporate)
----------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_com_GlobalRedirection]
	@inp_sControllerAction		VARCHAR(250),				-- Initial check called from.
	@inp_iUserInfoId			INT,						-- USer Info ID.
	@out_nReturnValue			INT = 0 OUTPUT,				-- Output Error number, if Error occured.
	@out_nSQLErrCode			INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage			VARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
AS
BEGIN
--------------------------------------------------------------------------------
DECLARE @RedirectToInitialDisclosurePage		INT = 1,
		@RedirectToPolicyDisplayPage			INT = 2,
		@RedirectTo_emp_Personal_Details_Page	INT = 3,
		@RedirectTo_Cor_Personal_Details_Page	INT = 4,
		@RedirectTo_nonemp_Personal_details_page INT = 5,
		@RedirectTo_Change_Password_Page        INT = 6
---------------------------------------------------------------------------------

	DECLARE @MapToTypePolicyDocument			INT = 132001
	DECLARE @EventInitialDisclosureEntered		INT = 153035
	DECLARE @POLICYDOCUMENTACTIVE				INT = 131002
	DECLARE @DISCLOSURETRANSACTION				INT = 132005
	DECLARE @CountForFinalResultTable			INT = 0	
	DECLARE @USERTYPE							INT
	DECLARE @PolicyDocumentViewed				INT = 153027
	DECLARE @PolicyDocumentAgreed				INT = 153028
	DECLARE @USERTYPE_ADMIN						INT = 101001,
			@USERTYPE_COUSER					INT = 101002,
			@USERTYPE_EMPLOYEE					INT = 101003,
			@USERTYPE_CORPORATEUSER				INT = 101004,
			@USERTYPE_SUPERADMIN				INT = 101005,
			@USERTYPE_NONEMPLOYEE				INT = 101006
			
	DECLARE @nConfirm_Personal_Details_Event	INT = 153043
	DECLARE @INITIALDISCLOSURECONTROLLERACTION VARCHAR(50) = 'InsiderInitialDisclosureIndex'
	DECLARE @MapToTypeChangePassword			INT = 132019
	DECLARE @nPasswordValidity INT
	DECLARE @nExpiryDate     DATETIME
	
	BEGIN TRY		
		SELECT @USERTYPE = u.UserTypeCodeId FROM usr_UserInfo u WHERE u.UserInfoId = @inp_iUserInfoId
		
		
		
		IF(@USERTYPE = @USERTYPE_EMPLOYEE OR @USERTYPE = @USERTYPE_CORPORATEUSER OR @USERTYPE = @USERTYPE_NONEMPLOYEE)
		BEGIN
			
			IF(EXISTS(SELECT ID FROM com_GlobalRedirectionControllerActionPair WHERE ControllerActionName = @inp_sControllerAction))
			BEGIN
				-- before checking initial disclosure first check if user has confirm personal details or not
				-- If personal details are confirm then continue with check for initial disclosure and policy document accepted or not 
				-- else redirect user to personal details page
				IF(NOT EXISTS(SELECT * FROM eve_EventLog WHERE EventCodeId = @nConfirm_Personal_Details_Event AND UserInfoId = @inp_iUserInfoId))
				BEGIN
					-- Redirect to personal details page base on user type
					IF (@USERTYPE = @USERTYPE_CORPORATEUSER)
					BEGIN
						SELECT Controller, Action, Parameter + ',nUserInfoID,'+ CONVERT(VARCHAR, @inp_iUserInfoId) as Parameter FROM com_GlobalRedirectToURL g where g.ID = @RedirectTo_Cor_Personal_Details_Page
					END
					ELSE IF (@USERTYPE = @USERTYPE_NONEMPLOYEE)
					BEGIN
						SELECT Controller, Action, Parameter + ',nUserInfoID,'+ CONVERT(VARCHAR, @inp_iUserInfoId) as Parameter FROM com_GlobalRedirectToURL g where g.ID = @RedirectTo_nonemp_Personal_details_page
					END
					ELSE
					BEGIN
						SELECT Controller, Action, Parameter + ',nUserInfoID,'+ CONVERT(VARCHAR, @inp_iUserInfoId) as Parameter FROM com_GlobalRedirectToURL g where g.ID = @RedirectTo_emp_Personal_Details_Page
					END
				END
				ELSE 
				BEGIN 
					-- To check whether INITIAL DISCLOSURE is submitted by user or not.	
					
					--If called from the Initial Disclosure ControllerAction then dont check for Initial disclosure completion so go directly to the requested page
					IF (@inp_sControllerAction = @INITIALDISCLOSURECONTROLLERACTION)
					BEGIN
						SET @out_nReturnValue = 0
						RETURN @out_nReturnValue
					END
		
		
					IF(NOT EXISTS(SELECT EventLogId FROM eve_EventLog WHERE EventCodeId = @EventInitialDisclosureEntered and UserInfoId = @inp_iUserInfoId AND MapToTypeCodeId = @DISCLOSURETRANSACTION ))
					BEGIN
						SELECT Controller,Action,Parameter as Parameter FROM com_GlobalRedirectToURL g where g.ID = @RedirectToInitialDisclosurePage
					END
					ELSE -- After submission of ID , if any policy is left to View/Agree
					BEGIN
						SELECT @nPasswordValidity = PassValidity FROM usr_PasswordConfig
						select @nExpiryDate = DATEADD(DAY, @nPasswordValidity, (select ModifiedOn from usr_authentication where userinfoid=@inp_iUserInfoId))
						IF(@nExpiryDate<GETDATE())
						BEGIN
							SELECT Controller,Action,Parameter as Parameter FROM com_GlobalRedirectToURL g where g.ID = @RedirectTo_Change_Password_Page
						END
						ELSE
						BEGIN
							DECLARE @FinalResult TABLE (SequenceNumber INT IDENTITY(1,1),PolicyDocumentId INT,DocumentId INT)
											
							INSERT INTO @FinalResult(PolicyDocumentId,DocumentId)
							SELECT	VW.MapToId,d.DocumentId
							FROM	vw_ApplicablePolicyDocumentForUser VW 				
									JOIN com_DocumentObjectMapping d ON VW.MapToId = d.MapToId 
									JOIN rul_PolicyDocument p1 ON p1.PolicyDocumentId = d.MapToId
							WHERE	VW.UserInfoId = @inp_iUserInfoId 
									AND d.MapToTypeCodeId = @MapToTypePolicyDocument AND p1.WindowStatusCodeId = @POLICYDOCUMENTACTIVE	AND P1.DocumentViewAgreeFlag = 1					
									AND VW.MapToId NOT IN(
															SELECT	DISTINCT e.MapToId 
															FROM	eve_EventLog e 
																	JOIN vw_ApplicablePolicyDocumentForUser v ON v.MapToId = e.MapToId 
																	JOIN rul_PolicyDocument p ON v.MapToId = p.PolicyDocumentId  
															WHERE	e.UserInfoId = @inp_iUserInfoId AND e.MapToTypeCodeId = @MapToTypePolicyDocument 
																	AND p.IsDeleted = 0 AND p.WindowStatusCodeId = @POLICYDOCUMENTACTIVE  AND p.DocumentViewAgreeFlag = 1
																	AND (e.EventCodeId = @PolicyDocumentViewed OR e.EventCodeId = @PolicyDocumentAgreed)
														 )

							SELECT @CountForFinalResultTable = COUNT(*) from @FinalResult					
							IF(@CountForFinalResultTable > 0)
							BEGIN
								DECLARE @sPolicyDocument VARCHAR(100) 
								SELECT TOP 1 @sPolicyDocument = ',PolicyDocumentId,' + CONVERT(VARCHAR(15), PolicyDocumentId) + ',DocumentId,' + CONVERT(VARCHAR(15), DocumentId) FROM @FinalResult 
								SELECT Controller,Action,Parameter + @sPolicyDocument as Parameter FROM com_GlobalRedirectToURL where ID = @RedirectToPolicyDisplayPage 
							END	
						END							
					END
				END
			END
			ELSE
			BEGIN
				SET @out_nReturnValue = 0
				RETURN @out_nReturnValue
			END	
		END
		ELSE IF (@USERTYPE = @USERTYPE_COUSER OR @USERTYPE = @USERTYPE_ADMIN OR @USERTYPE = @USERTYPE_SUPERADMIN)
		BEGIN
			SET @out_nReturnValue = 0
			RETURN @out_nReturnValue
		END
		
		SET @out_nReturnValue = 0
		RETURN @out_nReturnValue
				
		
	
	END TRY
	BEGIN CATCH
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()	
		
		-- Return common error if required, otherwise specific error.		
		SET @out_nReturnValue =  0
		RETURN @out_nReturnValue
	END CATCH
END
