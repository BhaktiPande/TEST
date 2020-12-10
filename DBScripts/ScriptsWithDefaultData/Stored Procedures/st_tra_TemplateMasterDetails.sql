IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_tra_TemplateMasterDetails')
DROP PROCEDURE [dbo].[st_tra_TemplateMasterDetails]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Get the TemplateMaster details

Returns:		0, if Success.
				
Created by:		Gaurishankar
Created on:		09-May-2015

Modification History:
Modified By		Modified On		Description
Gaurishankar	19-Jun-2015		Added SequenceNo field for FAQ.
Parag			20-Aug-2015		Change query to get "IsCommunicationTemplate" field in result.

Usage:
EXEC st_tra_TemplateMasterDetails 1
-------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[st_tra_TemplateMasterDetails]
	@inp_iTemplateMasterId	INT,							-- Id of the TemplateMaster whose details are to be fetched.
	@out_nReturnValue		INT = 0 OUTPUT,
	@out_nSQLErrCode		INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage		NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
	
AS
BEGIN
	DECLARE @ERR_TEMPLATEMASTER_GETDETAILS INT
	DECLARE @ERR_TEMPLATEMASTER_NOTFOUND INT

	BEGIN TRY
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;

		--Initialize variables
		SELECT	@ERR_TEMPLATEMASTER_NOTFOUND = 16075, -- Template does not exist.
				@ERR_TEMPLATEMASTER_GETDETAILS = 16077 -- Error occurred while fetching template details.

		--Check if the TemplateMaster whose details are being fetched exists
		IF (NOT EXISTS(SELECT TemplateMasterId FROM tra_TemplateMaster WHERE TemplateMasterId = @inp_iTemplateMasterId))
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
			Where TemplateMasterId = @inp_iTemplateMasterId
		

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

