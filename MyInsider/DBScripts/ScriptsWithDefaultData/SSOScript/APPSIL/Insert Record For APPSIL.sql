USE [Vigilante_Master]
--SELECT * FROM [Vigilante_Master].[dbo].[Companies] where [ConnectionDatabaseName]='APPSILDB'
--ConnectionDatabaseName in Companies should be same with CompanyName in SSOConfiguration
IF NOT EXISTS(Select * from [SSOConfiguration] where CompanyName='APPSILDB')
BEGIN
INSERT INTO [dbo].[SSOConfiguration] VALUES
           (NULL
           ,NULL
           ,'APPSILDB'
           ,'IDP'
           ,'Enter IDP_SP_URL'
           ,'Enter DestinationURL'
           ,'http://localhost:52194/SSO/AssertionConsumer'
           ,'Enter IssuerURL'
           ,'Enter RelayState'
		   ,'Enter Certificate Name'
           ,'Enter Certificate'
		   ,'CompanyID,EmployeeID,EmailID'
           ,'Admin'
           ,GETDATE()
           ,'Admin'
           ,GETDATE()
           ,1
           ,1
           ,1
           ,0
           ,0)
END
GO



