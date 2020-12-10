/******************************************************************************************************************
Description:	Routine to get details of Company based on CompanyDatabaseName, 
				or details of all companies if not database name is specified.

Returns:		
				
Created by:		Arundhati
Created on:		

Modification History:
Modified By		Modified On		Description

****************************************************************************************************************/
/*Drop procedure if already exists and then run the CREATE script*/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[st_com_GetCompanyDetails]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[st_com_GetCompanyDetails]
GO

CREATE PROCEDURE [dbo].[st_com_GetCompanyDetails] 
@inp_sCompanyDatabaseName varchar(200) = ''
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	--SET NOCOUNT ON;

    IF @inp_sCompanyDatabaseName = ''
    BEGIN
    SELECT CompanyId,	LOWER(CompanyName) as CompanyName,	ConnectionServer,	ConnectionDatabaseName,	ConnectionUserName,	ConnectionPassword,	UpdateResources,	IsDatabaseServerRemote,
			SmtpServer,	SmtpPortNumber,	SmtpUserName,	SmtpPassword,	LinkedServerName,	DeploymentDate	,DeploymentDescriptions	,
			MessageFromDate,	MessageToDate,	IsDeployedMessageShown	,SSOUrl	,IsSSOActivated	,FromMailID
	 FROM Companies
    END
    ELSE
    BEGIN
    SELECT  CompanyId,	LOWER(CompanyName) as CompanyName,	ConnectionServer,	ConnectionDatabaseName,	ConnectionUserName,	ConnectionPassword,	UpdateResources,	IsDatabaseServerRemote,
			SmtpServer,	SmtpPortNumber,	SmtpUserName,	SmtpPassword,	LinkedServerName,	DeploymentDate	,DeploymentDescriptions	,
			MessageFromDate,	MessageToDate,	IsDeployedMessageShown	,SSOUrl	,IsSSOActivated	,FromMailID FROM Companies WHERE LOWER( ConnectionDatabaseName) = LOWER(@inp_sCompanyDatabaseName)
    END
	--RETURN 0
	
END