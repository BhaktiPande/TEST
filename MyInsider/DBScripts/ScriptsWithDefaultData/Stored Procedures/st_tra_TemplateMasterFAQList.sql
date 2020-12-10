IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_tra_TemplateMasterFAQList')
DROP PROCEDURE [dbo].[st_tra_TemplateMasterFAQList]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	This procedure is used for fetching the FAQ data to be shown on the CO and Insider dashboard and 
				on the FAQ List page in treestructure format.

Returns:		0, if Success.
				
Created by:		Raghvendra
Created on:		18-AUG-2015

Modification History:
Modified By		Modified On		Description
Raghvendra		09-Sept-2015	Change to take the max records number as variable rather than hardcode.
Usage:
EXEC 
-------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[st_tra_TemplateMasterFAQList]
	@inp_iListForPage			INT = 0 --1: Dashboard, 2: FAQ List (tree structure)
	,@inp_iUserTypeCodeId		INT = 0 --Based on this user type i.e. CO:151001 or Insider:151002 the FAQ will be fetched.
	,@inp_iPageSize				INT = 10
	,@inp_iPageNo				INT = 1
	,@inp_sSortField			VARCHAR(255)
	,@inp_sSortOrder			VARCHAR(5)
	,@out_nReturnValue			INT = 0 OUTPUT
	,@out_nSQLErrCode			INT = 0 OUTPUT				-- Output SQL Error Number, if error occurred.
	,@out_sSQLErrMessage		VARCHAR(500) = '' OUTPUT  -- Output SQL Error Message, if error occurred.	
AS
BEGIN
	DECLARE @sSQL NVARCHAR(MAX) = ''
	DECLARE @ERR_FAQLISTFETCH_LIST INT = 0 -- Error occurred while fetching list of Template.
	DECLARE @FAQ_COMMUNICATIONCODEID INT = 156006
	DECLARE @FAQ_FOR_INSIDER INT = 151003, @FAQ_FOR_CO INT = 151004
	DECLARE @USERTYPE_ADMIN INT = 101001,@USERTYPE_CO INT = 101002
	DECLARE @nFaqForUserType INT
	
	BEGIN TRY
		
		SET NOCOUNT ON;
		-- Declare variables
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''
		
		IF @inp_iUserTypeCodeId = @USERTYPE_ADMIN OR @inp_iUserTypeCodeId = @USERTYPE_CO
		BEGIN
			SELECT @nFaqForUserType = @FAQ_FOR_CO
		END
		ELSE
		BEGIN
			SELECT @nFaqForUserType = @FAQ_FOR_INSIDER
		END
				
		IF @inp_iListForPage = 1
		BEGIN
			SELECT TOP 5 * FROM tra_TemplateMaster 
			WHERE IsActive = 1 AND CommunicationModeCodeId = @FAQ_COMMUNICATIONCODEID
			AND CHARINDEX('.',SequenceNo) = 0 AND LetterForCodeId = @nFaqForUserType
			ORDER BY SequenceNo ASC
		END
		ELSE IF @inp_iListForPage = 2
		BEGIN
			SELECT * FROM tra_TemplateMaster 
			WHERE IsActive = 1 AND CommunicationModeCodeId = @FAQ_COMMUNICATIONCODEID 
			AND LetterForCodeId = @nFaqForUserType
			ORDER BY SequenceNo ASC		
		END
		
		RETURN 0
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue	=  @ERR_FAQLISTFETCH_LIST
	END CATCH
END
