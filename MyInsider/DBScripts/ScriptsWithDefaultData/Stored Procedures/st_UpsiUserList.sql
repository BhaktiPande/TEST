IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_UpsiUserList')
DROP PROCEDURE [dbo].[st_UpsiUserList]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
Description:	Procedure to list Upsi User List.

Returns:		0, if Success.
				
Created by:		Arvind
Created on:		30-Apri-2019

Usage:
EXEC st_UpsiUserList 1
-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_UpsiUserList]
     @inp_iUserInfoId				INT = 0
	,@out_nReturnValue				INT = 0 OUTPUT
	,@out_nSQLErrCode				INT = 0 OUTPUT				-- Output SQL Error Number, if error occurred.
	,@out_sSQLErrMessage			VARCHAR(500) = '' OUTPUT  -- Output SQL Error Message, if error occurred.	
AS
BEGIN
	DECLARE @sSQL NVARCHAR(MAX) = ''
	DECLARE @ERR_COMPANY_LIST INT = 13005 -- Error occurred while fetching list of documents for user.
	
	BEGIN TRY
		
		SET NOCOUNT ON;
		-- Declare variables
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''

		select
		CONCAT(UI.FirstName, ' ',UI.LASTNAME) AS FirstName,
		      --UI.FirstName,
			  UI.LastName,
			  UI.EmployeeId,
			  ISNULL(UI.PAN,'-') AS PAN,
			  UI.MobileNumber,
			  ISNULL(UI.EmailId,'-') AS EmailId,
			  ISNULL(MC.CompanyName,'-') AS CompanyName,
			  ISNULL(MC.Address,'-') AS [Address],
			  CONCAT(UI.ContactPerson, ' ',MC.CompanyName,' ') AS ContactPerson
			
		from 
		     usr_UserInfo UI LEFT JOIN mst_Company MC ON UI.CompanyId=MC.CompanyId WHERE UI.UserInfoId=@inp_iUserInfoId
	
	SET @out_nReturnValue = 0
		RETURN @out_nReturnValue
		--RETURN 0
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue	=  @ERR_COMPANY_LIST
	END CATCH
END
