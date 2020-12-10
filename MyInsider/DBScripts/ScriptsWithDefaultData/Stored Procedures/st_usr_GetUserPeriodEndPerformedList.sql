IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_usr_GetUserPeriodEndPerformedList')
DROP PROCEDURE [dbo].[st_usr_GetUserPeriodEndPerformedList]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Procedure to fetch the current status of Period End Performed details for the user 
based on the PerformPeriodEnd flag saved in usr_UserInfo table.
The list will be of the users who can login to the system i.e. all the users except for the relatives.

Returns:		0, if Success.
				
Created by:		Raghvendra
Created on:		11-Sep-2016

Modification History:
Modified By		Modified On		Description

Usage:
DECLARE @out_nReturnValue				INT = 0 
	,@out_nSQLErrCode				INT = 0 
	,@out_sSQLErrMessage			VARCHAR(500) = '' 
EXEC st_usr_GetUserPeriodEndPerformedList
-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_usr_GetUserPeriodEndPerformedList]
	@out_nReturnValue				INT = 0 OUTPUT
	,@out_nSQLErrCode				INT = 0 OUTPUT
	,@out_sSQLErrMessage			VARCHAR(500) = '' OUTPUT  -- Output SQL Error Message, if error occurred.	
AS
BEGIN
	DECLARE @ERR_SAVE_RECORD INT = 11029	--Add new resource
	DECLARE @USERTYPE_EMPLOYEE INT = 101003
	DECLARE @USERTYPE_CORPORATE INT = 101004
	DECLARE @USERTYPE_NONEMPLOYEE INT = 101006
	DECLARE @CODEGROUP_PERFORM_PERIODEND INT = 186
	DECLARE @CODE_PERFORM_PERIODEND_NO_CODE INT = 186002
	DECLARE @CODE_PERFORM_PERIODEND_NO_VALUE VARCHAR(20)

	BEGIN TRY
		
		SET NOCOUNT ON;
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''
		
		SELECT @CODE_PERFORM_PERIODEND_NO_VALUE = CodeName 
		FROM com_Code 
		WHERE CodeGroupId = @CODEGROUP_PERFORM_PERIODEND AND CodeId = @CODE_PERFORM_PERIODEND_NO_CODE

		SELECT UI.UserInfoId, AU.LoginID, ISNULL(ISNULL(CD.DisplayCode, CD.CodeName),@CODE_PERFORM_PERIODEND_NO_VALUE) AS PeriodEndPerformed, ISNULL(UI.FirstName,'') + ' ' + ISNULL(UI.LastName,'') AS EmployeeName FROM usr_UserInfo UI 
		JOIN usr_Authentication AU ON AU.UserInfoID = UI.UserInfoId
		LEFT JOIN com_Code CD ON CD.CodeID = UI.PeriodEndDisclosureUploaded AND CD.CodeGroupId = @CODEGROUP_PERFORM_PERIODEND
		WHERE UI.UserTypeCodeId IN (@USERTYPE_EMPLOYEE, @USERTYPE_CORPORATE, @USERTYPE_NONEMPLOYEE)

		RETURN 0
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()
		SET @out_nReturnValue = dbo.uf_com_GetErrorCode(@ERR_SAVE_RECORD,ERROR_NUMBER())
		RETURN @out_nReturnValue
	END CATCH
END
