USE Vigilante_Master

IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'PROC_GET_SSOCONFIG_DETAILS')
	DROP PROCEDURE PROC_GET_SSOCONFIG_DETAILS
GO


CREATE PROCEDURE [dbo].[PROC_GET_SSOCONFIG_DETAILS]

AS

BEGIN
	SET NOCOUNT ON;
	
	SELECT
		[SSOId]
      ,[GroupID]
      ,[GroupName]
      ,[CompanyName]
      ,[InsertionType]
      ,[IDP_SP_URL]
      ,[DestinationURL]
      ,[AssertionConsumerServiceURL]
      ,[IssuerURL]
      ,[RelayState]
      ,[CertificateName]
      ,[Certificate]
      ,[Parameters]
      ,[CreatedBy]
      ,[CreatedDate]
      ,[UpdatedBy]
      ,[UpdatedDate]
      ,[Status]
      ,[IsSSOLoginActiveForEmployee]
      ,[IsSSOLoginActiveForCO]
      ,[IsSSOLoginActiveForNonEmployee]
      ,[IsSSOLoginActiveForCorporateUser]
	
	FROM 
		SSOConfiguration 
		
	WHERE 
		([Status]='True')

	SET NOCOUNT OFF;

END
