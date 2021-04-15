USE [Vigilante_Master]
--SELECT * FROM [Vigilante_Master].[dbo].[Companies] where [ConnectionDatabaseName]='shardulDB'
--ConnectionDatabaseName in Companies should be same with CompanyName in SSOConfiguration
IF NOT EXISTS(Select * from [SSOConfiguration] where CompanyName='shardulDB')
BEGIN
INSERT INTO [dbo].[SSOConfiguration] VALUES
           (NULL
           ,NULL
           ,'shardulDB'
           ,'IDP'
           ,'https://amsadfs.amsshardul.com/adfs/ls/idpinitiatedsignon.htm'
           ,'https://amsadfs.amsshardul.com/adfs/ls/idpinitiatedsignon.htm'
           ,'http://localhost:52194/SSO/AssertionConsumer'
           ,'https://amsadfs.amsshardul.com/adfs/ls/idpinitiatedsignon.htm'
           ,'https://amsadfs.amsshardul.com/adfs/ls/idpinitiatedsignon.htm'
		   ,'Enter Certificate Name'
           ,'MIIC6DCCAdCgAwIBAgIQIoSFIW8J/79EpIJ7rN/rOzANBgkqhkiG9w0BAQsFADAwMS4wLAYDVQQDEyVBREZTIFNpZ25pbmcgLSBhbXNhZGZzLmFtc3NoYXJkdWwuY29tMB4XDTIwMDYxNDE0MjYwN1oXDTIxMDYxNDE0MjYwN1owMDEuMCwGA1UEAxMlQURGUyBTaWduaW5nIC0gYW1zYWRmcy5hbXNzaGFyZHVsLmNvbTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBAO6h4fmlF7/UUE8jVSsv6PA8jktuQee5fYN1ZLJ3GW5Jb+nX/Kn7kXNqIBbtodAQ3VAzD1I6Zs0Lvg7jnaLXoQ2KpgLvEo2nAgpmhkWh3nyh0BV4xCvBhi3zkivcZ+QjT6yJD+2jR6IKaws2XOQ0zyXTW/C6Z3m1LsMJnkEBCPru9yNAil92yRAAWbDZsKWuptpRKdPEoYXq6KveUIfcd91NilC0IGNLKNZF9rb0KeVjkyMuYL6IFRPCLCPZrkN6MQmVqMeIlTNfnzsnaibgQloui0UFKV55Y50UZEmS9/LgIZqaT5bTCsmtXY0Kj7bskSb0tkJZESctJsGVt5V+RokCAwEAATANBgkqhkiG9w0BAQsFAAOCAQEA7lQaInnLvDY0OrPsO9HS1Ud2LshAA4BH/K6zy7/cLlCIYvHCjk/7NIwRrNfFjdeLGac5W9RJObxxLA1u1lztcf/n6IaZxMI4dIU2Z317wyWcaNc1ss3tWJjLrAQ9EOXiJJrR2aExOfExP25ioQHyWPI4dw/dF9PdZO997e/dYfZZFnirtn7d8whtx4A9C7w06mmjMlYhjy0gRuVuG2vcdIWY+dAt52d1o5cXjrWO9vYBZT0Dd3Y1cB6vVFiZHmrpec/NGmUa2DCswW+3tgK2hyC1za9DlNHarGfWLBMx45gc4YAkBtM2u/haZCa+3SHsQ2pxY9LeAO6gDyHcVrY27g=='
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

select * from [SSOConfiguration]



