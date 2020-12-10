/******************************************************************************************************************
Description:	Routine to get configuration details of a company, to send out Email / SMS notifications

Returns:		
				
Created by:		Ashashree
Created on:		05-Jun-2015

Modification History:
Modified By		Modified On		Description
Raghvendra		5-Aug-2015		Added a new parameter @inp_sCompanyDBName for using this script to fetch the notification related configuration
								parameters for selected company based on Company DB name. In this case the @inp_nCompanyId will have 0 value.
****************************************************************************************************************/
/*Drop procedure if already exists and then run the CREATE script*/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[st_cmu_GetCompanyDetailsForNotification]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[st_cmu_GetCompanyDetailsForNotification]
GO

CREATE PROCEDURE [dbo].[st_cmu_GetCompanyDetailsForNotification]
				 @inp_nCompanyId INT = 0,
				 @inp_sCompanyDBName VARCHAR(200) = '',
				 @out_nReturnValue	INT = 0 OUTPUT,
				 @out_nSQLErrCode	INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
				 @out_sSQLErrMessage	VARCHAR(500) = '' OUTPUT  -- Output SQL Error Message, if error occurred.
AS
BEGIN
	DECLARE @ERR_GET_COMPANY_DETAILS_FOR_NOTIFICATION INT = 10003
	DECLARE @ERR_COMPANY_NOT_FOUND INT = 10001
	DECLARE @ERR_SMTP_SERVER_NOT_DEFINED INT = 10004
	
	DECLARE @sSmtpServer VARCHAR(200) = ''
	DECLARE @nSmtpPortNumber INT = 0
	DECLARE @sSmtpUserName VARCHAR(200) = ''
	DECLARE @sSmtpPassword VARCHAR(200) = ''
	DECLARE @sFromMailID VARCHAR(200) = ''
	
	BEGIN TRY
		--If Company Database name is provided for fetching the notification configuration details then use it to find the company id
		--The found company id will be used for fetching the details. This us used in case of forgot password where email is to be sent
		--using the notification configuration details for selected company based on company database name.
		IF (@inp_nCompanyId = 0 AND @inp_sCompanyDBName <> '')
		BEGIN
			SELECT @inp_nCompanyId = CompanyId FROM Companies WHERE ConnectionDatabaseName = @inp_sCompanyDBName
		END
		
		IF(EXISTS(SELECT CompanyName FROM Companies WHERE CompanyId = @inp_nCompanyId ))
		BEGIN
			--Fetch the details pertaining to Email /SMS notification sending feature
			SELECT @sSmtpServer = SmtpServer, @nSmtpPortNumber = SmtpPortNumber, @sSmtpUserName = SmtpUserName, @sSmtpPassword = SmtpPassword ,@sFromMailID=FromMailID
			FROM Companies 
			WHERE CompanyId = @inp_nCompanyId
			
			--Give error is SMTP server is not defined, other fields : SmtpPortNumber, SmtpUserName, SmtpPassword are optional
			IF(@sSmtpServer IS NULL OR LTRIM(RTRIM(@sSmtpServer)) = '')
			BEGIN
				SET @out_nReturnValue	=  @ERR_SMTP_SERVER_NOT_DEFINED
				RETURN @out_nReturnValue
			END
			
			SELECT @sSmtpServer AS SmtpServer, @nSmtpPortNumber AS SmtpPortNumber, @sSmtpUserName AS SmtpUserName, @sSmtpPassword AS SmtpPassword ,FromMailID as FromMailID
			FROM Companies 
			WHERE CompanyId = @inp_nCompanyId
			
			SELECT @out_nReturnValue = 0
			RETURN @out_nReturnValue
		END
		ELSE --Company record not found for CompanyId
		BEGIN
			SET @out_nReturnValue	=  @ERR_COMPANY_NOT_FOUND
			RETURN @out_nReturnValue
		END
	END TRY
	BEGIN CATCH
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue	=  @ERR_GET_COMPANY_DETAILS_FOR_NOTIFICATION
		RETURN @out_nReturnValue
	END CATCH
END