IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_tra_InitialDisclosureDetails')
DROP PROCEDURE [dbo].[st_tra_InitialDisclosureDetails]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Get the st_tra_Initial Disclosure Details

Returns:		0, if Success.
				
Created by:		Tushar Tekawade
Created on:		12-May-2016

Modification History:
Modified By		Modified On		Description

Usage:
EXEC st_tra_InitialDisclosureDetails 1
-------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[st_tra_InitialDisclosureDetails]
	@inp_iUserInfoID		INT,					-- User Info ID
	@out_nReturnValue		INT = 0 OUTPUT,
	@out_nSQLErrCode		INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage		NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
	
AS
BEGIN
	DECLARE @ERR_INITIALDISCLOSURE_DETAILS INT = 17453 -- Error occurred while fetching initial disclosure details.

	BEGIN TRY
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;

		DECLARE @nInitialDisclsureConfirmedStatus INT = 153035
		DECLARE @nInitialDisclsureConfirmedStatus_OS INT = 153056
		DECLARE @nRequiredModule INT=0
		SELECT @nRequiredModule=RequiredModule FROM mst_Company WHERE CompanyId=1

		IF(@nRequiredModule=513001)
		BEGIN		
			IF(EXISTS(SELECT EventDate FROM eve_EventLog WHERE UserInfoId = @inp_iUserInfoID AND EventCodeId = @nInitialDisclsureConfirmedStatus))
			BEGIN
				SELECT EventDate FROM eve_EventLog WHERE UserInfoId = @inp_iUserInfoID AND EventCodeId = @nInitialDisclsureConfirmedStatus
			END
			ELSE
			BEGIN
				SELECT NULL AS EventDate 
			END				
		END
		IF(@nRequiredModule=513002)
		BEGIN		
			IF(EXISTS(SELECT EventDate FROM eve_EventLog WHERE UserInfoId = @inp_iUserInfoID AND EventCodeId = @nInitialDisclsureConfirmedStatus_OS))
			BEGIN
				SELECT EventDate FROM eve_EventLog WHERE UserInfoId = @inp_iUserInfoID AND EventCodeId = @nInitialDisclsureConfirmedStatus_OS
			END
			ELSE
			BEGIN
				SELECT NULL AS EventDate 
			END			
		END
		IF(@nRequiredModule=513003)
		BEGIN
			DECLARE @nIDConfirmCnt INT=0
			SELECT @nIDConfirmCnt=COUNT(EventDate) FROM eve_EventLog 
			WHERE UserInfoId = @inp_iUserInfoID AND EventCodeId IN(@nInitialDisclsureConfirmedStatus, @nInitialDisclsureConfirmedStatus_OS)
			IF(@nIDConfirmCnt>1)
			BEGIN
				SELECT EventDate FROM eve_EventLog 
				WHERE UserInfoId = @inp_iUserInfoID AND EventCodeId IN(@nInitialDisclsureConfirmedStatus, @nInitialDisclsureConfirmedStatus_OS)
			END
			ELSE
			BEGIN
				SELECT NULL AS EventDate 
			END
		END

		SET @out_nReturnValue = 0
		RETURN @out_nReturnValue
		
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()
		
		-- Return common error if required, otherwise specific error.		
		SET @out_nReturnValue  = dbo.uf_com_GetErrorCode(@ERR_INITIALDISCLOSURE_DETAILS, ERROR_NUMBER())
		RETURN @out_nReturnValue		
	END CATCH
END

