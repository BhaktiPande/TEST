/*
	Created By  :	Shubhangi Gurude
	Created On  :   06-Mar-2017
	Description :	This stored Procedure is used to get Template for Form c for CO	
*/

IF EXISTS (SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_tra_GetTemplateforGroup')
	DROP PROCEDURE st_tra_GetTemplateforGroup
GO

CREATE PROCEDURE [dbo].[st_tra_GetTemplateforGroup]
        @Inp_DisclosureTypeCodeId INT,
    	@Inp_LetterForCodeId INT,
	@out_nReturnValue		INT = 0 OUTPUT,
	@out_nSQLErrCode		INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage		NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
	
AS
BEGIN
	DECLARE @ERR_TEMPLATEMASTER_GETDETAILS INT
	DECLARE @ERR_TEMPLATEMASTER_NOTFOUND INT
	
	DECLARE @TemplateMasterId INT

	BEGIN TRY
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;

		--Initialize variables
		SELECT	@ERR_TEMPLATEMASTER_NOTFOUND = 16075, -- Template does not exist.
				@ERR_TEMPLATEMASTER_GETDETAILS = 16077 -- Error occurred while fetching template details.
				
		 SELECT  @TemplateMasterId=max(TemplateMasterId) FROM tra_TemplateMaster
		  WHERE DisclosureTypeCodeId=@Inp_DisclosureTypeCodeId AND LetterForCodeId=@Inp_LetterForCodeId
		

		--Check if the TemplateMaster whose details are being fetched exists
		IF (NOT EXISTS(SELECT TemplateMasterId FROM tra_TemplateMaster WHERE TemplateMasterId = @TemplateMasterId))
		BEGIN	
				SET @out_nReturnValue = @ERR_TEMPLATEMASTER_NOTFOUND
				RETURN (@out_nReturnValue)
		END

		--Fetch the TemplateMaster details
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
			Where TemplateMasterId = @TemplateMasterId		

		SET @out_nReturnValue = 0
		RETURN @out_nReturnValue
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()
		
		-- Return common error if required, otherwise specific error.		
		SET @out_nReturnValue  = dbo.uf_com_GetErrorCode(@ERR_TEMPLATEMASTER_GETDETAILS, ERROR_NUMBER())
		RETURN @out_nReturnValue		
	END CATCH
END
GO

