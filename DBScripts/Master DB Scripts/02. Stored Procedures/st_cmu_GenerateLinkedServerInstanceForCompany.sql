/******************************************************************************************************************
Description:	Routine to generate LinkedServer instance for companyId of a company from table Companies.

Returns:		0: Success in creating LinkedServer, 1: Failure in creating LinkedServer.
				
Created by:		Ashashree
Created on:		03-Jun-2015
Modification History:
Modified By		Modified On		Description

------------------Start : Sample call to procedures to create linked server and assign login credentials to the newly created linked server-------------

--exec sp_addlinkedserver @server = 'LNKSRV_FOR_KPCS_COMPANY1_ON_EMERGEBOI', 
--						@srvproduct = 'SQLSERVER', 
--						@provider = 'SQLNCLI', 
--						@datasrc = 'EMERGEBOI',
--						@location = 'KPCS_COMPANY1_ON_EMERGEBOI_SERVER_MACHINE',
--						@provstr = NULL,
--						@catalog = 'KPCS_InsiderTrading_Company1'

--exec sp_addlinkedsrvlogin @rmtsrvname = 'LNKSRV_FOR_KPCS_COMPANY1_ON_EMERGEBOI',
--						  @useself = 'FALSE',
--						  @locallogin = NULL,
--						  @rmtuser = 'sa', --username as stored in table KPCS_InsiderTrading_Master.dbo.Companies
--						  @rmtpassword = 's0ft#c0rn3r' --password as stored in table KPCS_InsiderTrading_Master.dbo.Companies

--exec sp_dropserver 'LNKSRV_KPCS_FOR_COMPANY_ID_2', 'droplogins';

------------------End : Sample call to procedures to create linked server and assign login credentials to the newly created linked server-------------
************************************************************************************************************/
/*Drop procedure if already exists and then run the CREATE script*/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[st_cmu_GenerateLinkedServerInstanceForCompany]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[st_cmu_GenerateLinkedServerInstanceForCompany]
GO


CREATE PROCEDURE [dbo].[st_cmu_GenerateLinkedServerInstanceForCompany]
				 @inp_nCompanyId INT,
				 @out_nReturnValue	INT = 0 OUTPUT,
				 @out_nSQLErrCode	INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
				 @out_sSQLErrMessage	VARCHAR(500) = '' OUTPUT  -- Output SQL Error Message, if error occurred.
AS
BEGIN
	DECLARE @sLinkedServerPrefix VARCHAR(50)
	DECLARE @sLinkedServerDatasource VARCHAR(4000)
	DECLARE @sLinkedServerName VARCHAR(50)
	DECLARE @sLinkedServerLocation VARCHAR(4000)
	DECLARE @sCatalogName VARCHAR(200)
	DECLARE @sLinkedServerUserName VARCHAR(200)
	DECLARE @sLinkedServerPwd VARCHAR(200)
	
	DECLARE @sSQL VARCHAR(4000)
	DECLARE @nServerExists INT = 0 -- IF this stores 0 after execution of 'sp_helpserver' then it indicates that linked server is already existing. If set to 1 it means linked server is not already existing, so a new linked server is created for the input companyId
	
	DECLARE @ERR_COMPANY_NOT_FOUND INT = 10001
	DECLARE @ERR_GENERATING_LINKED_SERVER_INSTANCE INT = 10002
	DECLARE @ERR_COMPANY_DATABASENAME_NOT_FOUND INT = 10009
	DECLARE @ERR_COMPANY_DATABASE_SERVERNAME_NOT_FOUND INT = 10011
	DECLARE @ERR_COMPANY_CONNECTION_USERNAME_NOT_FOUND INT = 10012
	DECLARE @ERR_COMPANY_CONNECTION_PASSWORD_NOT_FOUND INT = 10013
	
	
	CREATE TABLE #tmpLinkedServers(ID INT IDENTITY(1,1), 
									LSName VARCHAR(50), 
									LSNetworkName VARCHAR(255), 
									LSStatus VARCHAR(70), 
									LSId CHAR(4), 
									LSCollationName VARCHAR(255), 
									LSConnectTimeout INT, 
									LSQueryTimeout INT
								   )

	BEGIN TRY
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''


		SELECT @sLinkedServerPrefix = 'LNKSRV_KPCS_FOR_COMPANY_ID_'
		
		IF(EXISTS(SELECT CompanyName FROM Companies WHERE CompanyId = @inp_nCompanyId ))--Create linked server only if company exists for input @inp_nCompanyId
		BEGIN		
				SELECT @sLinkedServerDatasource = ConnectionServer, @sCatalogName = ConnectionDatabaseName, 
				@sLinkedServerUserName = ConnectionUserName, @sLinkedServerPwd = ConnectionPassword
				FROM Companies WHERE CompanyId = @inp_nCompanyId
				
				IF(@sLinkedServerDatasource IS NULL OR LTRIM(RTRIM(@sLinkedServerDatasource)) = '')
				BEGIN
					SET @out_nReturnValue = @ERR_COMPANY_DATABASE_SERVERNAME_NOT_FOUND
				RETURN @out_nReturnValue
				END
				
				IF(@sCatalogName IS NULL OR LTRIM(RTRIM(@sCatalogName)) = '')
				BEGIN
					SET @out_nReturnValue = @ERR_COMPANY_DATABASENAME_NOT_FOUND
				RETURN @out_nReturnValue
				END
				
				IF(@sLinkedServerUserName IS NULL OR LTRIM(RTRIM(@sLinkedServerUserName)) = '')
				BEGIN
					SET @out_nReturnValue = @ERR_COMPANY_CONNECTION_USERNAME_NOT_FOUND
				RETURN @out_nReturnValue
				END
				
				IF(@sLinkedServerPwd IS NULL OR LTRIM(RTRIM(@sLinkedServerPwd)) = '')
				BEGIN
					SET @out_nReturnValue = @ERR_COMPANY_CONNECTION_PASSWORD_NOT_FOUND
				RETURN @out_nReturnValue
				END
				
				
				SELECT @sLinkedServerName = @sLinkedServerPrefix + CAST(@inp_nCompanyId AS VARCHAR(10)) 

				SELECT @sLinkedServerLocation = 'DATABASE_' + @sCatalogName + '_ON_' + @sLinkedServerDatasource + '_MACHINE'

				--SELECT @sLinkedServerName AS ServerName, @sLinkedServerDatasource AS Datasource, 
				--@sLinkedServerLocation as Location, @sCatalogName as CatalogName,
				--@sLinkedServerUserName as RmtUser, @sLinkedServerPwd as RmtPassword

				--Check if the linkedserver already exists
				INSERT INTO #tmpLinkedServers(LSName, LSNetworkName, LSStatus, LSId, LSCollationName, LSConnectTimeout, LSQueryTimeout)
				Exec sp_helpserver
				
				--SELECT 'entries form #tmpLinkedServers'
				--SELECT * FROM #tmpLinkedServers
				
				IF(NOT EXISTS(SELECT ID FROM #tmpLinkedServers WHERE LSName = @sLinkedServerName))
				BEGIN
					--Generate the Linked server instance for company specified by company Id
					exec sp_addlinkedserver @server = @sLinkedServerName, 
											@srvproduct = 'SQLSERVER', 
											@provider = 'SQLNCLI', 
											@datasrc = @sLinkedServerDatasource,
											@location = @sLinkedServerLocation,
											@provstr = NULL,
											@catalog = @sCatalogName
					--Add login credential details to newly created Linked server instance, for company specified by company Id	
					exec sp_addlinkedsrvlogin @rmtsrvname = @sLinkedServerName,
											  @useself = 'FALSE',
											  @locallogin = NULL,
											  @rmtuser = @sLinkedServerUserName, --username as stored in table KPCS_InsiderTrading_Master.dbo.Companies
											  @rmtpassword = @sLinkedServerPwd --password as stored in table KPCS_InsiderTrading_Master.dbo.Companies
					
					SELECT 'all linked servers list'
					exec sp_linkedservers

					--Test the linked server connection using below query
					SELECT @sSQL = 'SELECT name FROM [' + @sLinkedServerName + '].master.sys.sysdatabases' 	
					EXEC(@sSQL)			  

					--Queries should be of the form : SELECT * FROM <linked server name>.<database name>.<schema name>.<table name>
					SELECT @sSQL = 'SELECT * FROM [' + @sLinkedServerName +'].[' + @sCatalogName + '].dbo.com_Code'
					EXEC(@sSQL)
					
					--Update the linked server's name in the Companies table for Company with Id = @inp_nCompanyId
					UPDATE Companies SET LinkedServerName = @sLinkedServerName WHERE CompanyId = @inp_nCompanyId			  
				END
		END
		ELSE --Company record not found for CompanyId
		BEGIN
			SET @out_nReturnValue	=  @ERR_COMPANY_NOT_FOUND
		END
	END TRY
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue	=  @ERR_GENERATING_LINKED_SERVER_INSTANCE
	END CATCH
	
	DROP TABLE #tmpLinkedServers
	
	RETURN @out_nReturnValue
END