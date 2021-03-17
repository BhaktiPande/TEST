IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_tra_TemplateMasterSave')
DROP PROCEDURE [dbo].[st_tra_TemplateMasterSave]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Saves the TemplateMaster details

Returns:		0, if Success.
				
Created by:		Gaurishankar
Created on:		09-May-2015
Modification History:
Modified By		Modified On		Description
Gaurishankar	16-May-2015		Added unique check for template Name.
Gaurishankar	15-Jun-2015		Removed the Date mandatory check.
Gaurishankar	19-Jun-2015		Added SequenceNo field for FAQ.
Gaurishankar	22-Jun-2015		Added code for  "Template with same name already exists."
Gaurishankar	22-Jun-2015		Added field IsCommunicationTemplate
Gaurishankar	21-Jul-2015		Commented the Mandatory check for ToAddress 2
Parag			20-Aug-2015		add input to stored value in "IsCommunicationTemplate" field if communication mode is letter.
Raghvendra		07-Sep-2016		Changed the GETDATE() call with function dbo.uf_com_GetServerDate(). This function will return the date to be used as server date.
Raghvendra		13-Oct-2016		Changing the datatype for input parameter Contents from NVARCHAR(4000) to NVARCHAR(MAX)
Raghvendra		08-Nov-2016		Fix to replace "\r\n" with "" only when communicationModeCode is Form E, because Form E contents will be formatted using ckEditor.

Usage:
DECLARE @RC int
EXEC st_tra_TemplateMasterSave ,1
-------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[st_tra_TemplateMasterSave] 
		@inp_iTemplateMasterId			INT,
		@inp_sTemplateName				NVARCHAR(MAX),
		@inp_iCommunicationModeCodeId	INT, -- CodeGroupID = 156 156001:Letter, 156002:Email, 156003:SMS, 156004:Text Alert, 156005:Popup Alert.
		@inp_iDisclosureTypeCodeId		INT, -- CodeGroupID = 147 147001: Initial 147002: Continuous 147003: Period End. Applicable for Transaction Letter.
		@inp_iLetterForCodeId			INT, -- CodeGroupID = 151 151001: Insider 151002: CO. Applicable for Transaction Letter. And 151003: Insider 151004: CO. Applicable for FAQ. 
		@inp_bIsActive					BIT, -- 1: Active, 0: Inactive
		@inp_dtDate						DATETIME, -- Applicable for Transaction Letter.
		@inp_sToAddress1				NVARCHAR(250), -- Applicable for Transaction Letter.
		@inp_sToAddress2				NVARCHAR(250), -- Applicable for Transaction Letter.
		@inp_sSubject					NVARCHAR(MAX), -- Applicable only for email and transaction letter. Empty string or NULL in case of CM- SMS/Alert/Popup
		@inp_sContents					NVARCHAR(MAX), -- will contain formatted text along with placeholders in between the content, where placeholder will be from a placeholder master table. Placeholders will be handled at a later stage, not in first cut.
		@inp_sSignature					NVARCHAR(MAX), -- Applicable for Letter, Email.
		@inp_sCommunicationFrom			NVARCHAR(100), -- Appliable only in case of Email and SMS - email from email address / SMS from number.
		@inp_sSequenceNo				NVARCHAR(50), -- Applicable for FAQ
		@inp_bIsCommunicationTemplate	BIT,  -- 1: Active, 0: Inactive (In case of communcation type as Letter used to check "ToAddress2" field is required or not 
		@inp_nUserId					INT,			-- Id of the user inserting/updating the TemplateMaster
		@out_nReturnValue				INT = 0 OUTPUT,
		@out_nSQLErrCode				INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
		@out_sSQLErrMessage				NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
AS
BEGIN

	DECLARE @ERR_TEMPLATEMASTER_SAVE INT
	DECLARE @ERR_TEMPLATEMASTER_NOTFOUND INT
	DECLARE @ERR_TEMPLATEMASTER_TEMPLATENAME_MANDATORY INT
	DECLARE @ERR_TEMPLATEMASTER_COMMUNICATIONMODE_MANDATORY INT
	DECLARE @ERR_TEMPLATEMASTER_DISCLOSURETYPE_MANDATORY INT
	DECLARE @ERR_TEMPLATEMASTER_LETTERFORCODE_MANDATORY INT
	DECLARE @ERR_TEMPLATEMASTER_DATE_MANDATORY INT
	DECLARE @ERR_TEMPLATEMASTER_TOADDRESS1_MANDATORY INT
	DECLARE @ERR_TEMPLATEMASTER_TOADDRESS2_MANDATORY INT
	DECLARE @ERR_TEMPLATEMASTER_SUBJECT_MANDATORY INT
	DECLARE @ERR_TEMPLATEMASTER_CONTENTS_MANDATORY INT
	DECLARE @ERR_TEMPLATEMASTER_SIGNATURE_MANDATORY INT
	DECLARE @ERR_TEMPLATEMASTER_COMMUNICATIONFROM_MANDATORY INT	
	DECLARE @ERR_TEMPLATEMASTER_SEQUENCENO_MANDATORY INT
	DECLARE @ERR_TEMPLATEMASTER_TEMPLATE_NAME_EXISTS INT
	DECLARE @bIsCommunicationTemplate BIT = 0

	BEGIN TRY
		DECLARE @nCommunicationType_Letter INT	= 156001
	
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;
	
		--Initialize variables
		SELECT	@ERR_TEMPLATEMASTER_NOTFOUND = 16075, -- Template does not exist.
				@ERR_TEMPLATEMASTER_SAVE = 16079, --Error occurred while saving template.
				@ERR_TEMPLATEMASTER_TEMPLATENAME_MANDATORY = 16080, --Template name is mandatory.
				@ERR_TEMPLATEMASTER_COMMUNICATIONMODE_MANDATORY = 16081,-- Communication mode is mandatory.
				@ERR_TEMPLATEMASTER_DISCLOSURETYPE_MANDATORY = 16082, -- Disclosure type is mandatory.
				@ERR_TEMPLATEMASTER_LETTERFORCODE_MANDATORY = 16083, -- Letter for is mandatory.
				@ERR_TEMPLATEMASTER_DATE_MANDATORY = 16084, -- Date is mandatory.
				@ERR_TEMPLATEMASTER_TOADDRESS1_MANDATORY = 16085, -- ToAddress1 is mandatory.
				@ERR_TEMPLATEMASTER_TOADDRESS2_MANDATORY = 16086, -- ToAddress2 is mandatory.
				@ERR_TEMPLATEMASTER_SUBJECT_MANDATORY = 16087, -- Subject is mandatory.
				@ERR_TEMPLATEMASTER_CONTENTS_MANDATORY = 16088, -- Content is mandatory.
				@ERR_TEMPLATEMASTER_SIGNATURE_MANDATORY = 16089, -- Signature is mandatory.
				@ERR_TEMPLATEMASTER_COMMUNICATIONFROM_MANDATORY = 16090, -- Notification from is mandatory.
				@ERR_TEMPLATEMASTER_SEQUENCENO_MANDATORY = 16174, -- SEQUENCENO is mandatory.
				@ERR_TEMPLATEMASTER_TEMPLATE_NAME_EXISTS = 16176 -- Template Name Already exists.
		
		IF @inp_bIsActive IS NULL  
		BEGIN
			SET @inp_bIsActive = 0
		END
		
		-- check if communication mode is for Communication category or not. 
		-- if communcation mode is for communication category then set 1 else check if communcation mode is letter then used value from input parameter 		
		IF EXISTS(SELECT CodeID FROM com_Code WHERE CodeID = @inp_iCommunicationModeCodeId AND ParentCodeId = 166001)  
		BEGIN
			SET @bIsCommunicationTemplate = 1
		END
		ELSE IF @inp_iCommunicationModeCodeId = @nCommunicationType_Letter
		BEGIN 
			SET @bIsCommunicationTemplate = @inp_bIsCommunicationTemplate
		END
		
		IF @inp_sTemplateName IS NULL OR @inp_sTemplateName = '' 
		BEGIN
			SET @out_nReturnValue = @ERR_TEMPLATEMASTER_TEMPLATENAME_MANDATORY
			RETURN @out_nReturnValue
		END
		IF @inp_iCommunicationModeCodeId IS NULL OR @inp_iCommunicationModeCodeId = 0 
		BEGIN
			SET @out_nReturnValue = @ERR_TEMPLATEMASTER_COMMUNICATIONMODE_MANDATORY
			RETURN @out_nReturnValue
		END
		IF @inp_sContents IS NULL OR @inp_sContents = '' 
		BEGIN
			SET @out_nReturnValue = @ERR_TEMPLATEMASTER_CONTENTS_MANDATORY
			RETURN @out_nReturnValue
		END
		
		IF @inp_iCommunicationModeCodeId = 156001 -- IF Communication type is Letter then Following fields are mandatory.
		BEGIN
			IF @inp_iDisclosureTypeCodeId IS NULL OR @inp_iDisclosureTypeCodeId = 0 
			BEGIN
				SET @out_nReturnValue = @ERR_TEMPLATEMASTER_DISCLOSURETYPE_MANDATORY
				RETURN @out_nReturnValue
			END
			IF @inp_iLetterForCodeId IS NULL OR @inp_iLetterForCodeId = 0 
			BEGIN
				SET @out_nReturnValue = @ERR_TEMPLATEMASTER_LETTERFORCODE_MANDATORY
				RETURN @out_nReturnValue
			END
			--IF @inp_dtDate IS NULL 
			--BEGIN
			--	SET @out_nReturnValue = @ERR_TEMPLATEMASTER_DATE_MANDATORY
			--	RETURN @out_nReturnValue
			--END
			IF @inp_sToAddress1 IS NULL OR @inp_sToAddress1 = '' 
			BEGIN
				SET @out_nReturnValue = @ERR_TEMPLATEMASTER_TOADDRESS1_MANDATORY
				RETURN @out_nReturnValue
			END
			
			-- check address 2 mandatory or not only when @inp_bIsCommunicationTemplate field is 1 
			-- (in case of letter this is used to indicate if address 2 is required or not)
			IF @inp_bIsCommunicationTemplate = 1 AND (@inp_sToAddress2 IS NULL OR @inp_sToAddress2 = '') 
			BEGIN
				SET @out_nReturnValue = @ERR_TEMPLATEMASTER_TOADDRESS2_MANDATORY
				RETURN @out_nReturnValue
			END
		END
		
		IF @inp_iCommunicationModeCodeId = 156001 OR @inp_iCommunicationModeCodeId = 156002-- IF Communication type is Letter OR Email then Following fields are mandatory.
		BEGIN
			IF @inp_sSubject IS NULL OR @inp_sSubject = '' 
			BEGIN
				SET @out_nReturnValue = @ERR_TEMPLATEMASTER_SUBJECT_MANDATORY
				RETURN @out_nReturnValue
			END
			
			IF @inp_sSignature IS NULL OR @inp_sSignature = '' 
			BEGIN
				SET @out_nReturnValue = @ERR_TEMPLATEMASTER_SIGNATURE_MANDATORY
				RETURN @out_nReturnValue
			END
		END
		IF @inp_iCommunicationModeCodeId = 156002 OR @inp_iCommunicationModeCodeId = 156003-- IF Communication type is Email OR SMS then Following fields are mandatory.
		BEGIN
			IF @inp_sCommunicationFrom IS NULL OR @inp_sCommunicationFrom = '' 
			BEGIN
				SET @out_nReturnValue = @ERR_TEMPLATEMASTER_COMMUNICATIONFROM_MANDATORY
				RETURN @out_nReturnValue
			END
		END
		IF @inp_iCommunicationModeCodeId = 156006 -- IF Communication type is FAQ then Following fields are mandatory.
		BEGIN
			IF @inp_sSequenceNo IS NULL OR @inp_sSequenceNo = '' 
			BEGIN
				SET @out_nReturnValue = @ERR_TEMPLATEMASTER_SEQUENCENO_MANDATORY -- Error Sequence No is required
				RETURN @out_nReturnValue
			END
		END
		
		IF EXISTS(SELECT TemplateMasterId FROM tra_TemplateMaster 
					WHERE TemplateName = @inp_sTemplateName AND (@inp_iTemplateMasterId = 0 OR TemplateMasterId != @inp_iTemplateMasterId))
		BEGIN
			SET @out_nReturnValue = @ERR_TEMPLATEMASTER_TEMPLATE_NAME_EXISTS
			RETURN @out_nReturnValue
		END
		--Replace "\r\n" with "" for CommunicationModeCodeId Form E(156007) or Form G 156010 because editor formatting will be used for Contents of Form E(156007)	
		IF(@inp_iCommunicationModeCodeId = 156007 OR @inp_iCommunicationModeCodeId =156010)
		BEGIN
			SELECT @inp_sContents = REPLACE(@inp_sContents,'\r\n','')
		END
		--Save the TemplateMaster details
		select @inp_sContents=Replace(@inp_sContents,'[[','[')
		IF @inp_iTemplateMasterId = 0
		BEGIN
			Insert into tra_TemplateMaster(
					TemplateName
					,CommunicationModeCodeId
					,DisclosureTypeCodeId
					,LetterForCodeId
					,IsActive
					,[Date]
					,ToAddress1
					,ToAddress2
					,[Subject]
					,Contents
					,[Signature]
					,CommunicationFrom
					,SequenceNo
					,IsCommunicationTemplate
					,CreatedBy, CreatedOn, ModifiedBy, ModifiedOn )
			Values (
					@inp_sTemplateName,
					@inp_iCommunicationModeCodeId,
					@inp_iDisclosureTypeCodeId,
					@inp_iLetterForCodeId,
					@inp_bIsActive,
					@inp_dtDate,
					@inp_sToAddress1,
					@inp_sToAddress2,
					@inp_sSubject,
					@inp_sContents,
					@inp_sSignature,
					@inp_sCommunicationFrom,
					@inp_sSequenceNo,
					@bIsCommunicationTemplate,
					@inp_nUserId, dbo.uf_com_GetServerDate(), @inp_nUserId, dbo.uf_com_GetServerDate() )
					  
					SELECT @inp_iTemplateMasterId = @@IDENTITY
		END
		ELSE
		BEGIN
			--Check if the TemplateMaster whose details are being updated exists
			IF (NOT EXISTS(SELECT TemplateMasterId FROM tra_TemplateMaster WHERE TemplateMasterId = @inp_iTemplateMasterId))			
			BEGIN	
				SET @out_nReturnValue = @ERR_TEMPLATEMASTER_NOTFOUND
				RETURN (@out_nReturnValue)
			END	
			Update tra_TemplateMaster
			Set 	TemplateName = @inp_sTemplateName,
					CommunicationModeCodeId = @inp_iCommunicationModeCodeId,
					DisclosureTypeCodeId = @inp_iDisclosureTypeCodeId,
					LetterForCodeId = @inp_iLetterForCodeId,
					IsActive = @inp_bIsActive,
					[Date] = @inp_dtDate,
					ToAddress1 = @inp_sToAddress1,
					ToAddress2 = @inp_sToAddress2,
					[Subject] = @inp_sSubject,
					Contents = @inp_sContents,
					[Signature] = @inp_sSignature,
					CommunicationFrom = @inp_sCommunicationFrom,
					SequenceNo = @inp_sSequenceNo,
					IsCommunicationTemplate = @bIsCommunicationTemplate,
					ModifiedBy	= @inp_nUserId,
					ModifiedOn = dbo.uf_com_GetServerDate()
			Where TemplateMasterId = @inp_iTemplateMasterId	
			
		END
		
		-- in case required to return for partial save case.
		Select TemplateMasterId
				,TemplateName
				,CommunicationModeCodeId
				,DisclosureTypeCodeId
				,LetterForCodeId
				,IsActive
				,[Date]
				,ToAddress1
				,ToAddress2
				,[Subject]
				,Contents
				,[Signature]
				,CommunicationFrom
				,SequenceNo
				,IsCommunicationTemplate
			From tra_TemplateMaster
			Where TemplateMasterId = @inp_iTemplateMasterId		

		SET @out_nReturnValue = 0
		RETURN @out_nReturnValue
	END	 TRY
	
	BEGIN CATCH	
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()	
		
		-- Return common error if required, otherwise specific error.		
		SET @out_nReturnValue =  dbo.uf_com_GetErrorCode(@ERR_TEMPLATEMASTER_SAVE, ERROR_NUMBER())
		RETURN @out_nReturnValue
	END CATCH
END