USE Vigilante_Master
IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'PROC_SSOCONFIG_SAVE_UPDATE')
	DROP PROCEDURE PROC_SSOCONFIG_SAVE_UPDATE
GO


CREATE PROCEDURE [dbo].[PROC_SSOCONFIG_SAVE_UPDATE]
@SSOID int,
@GroupID int,
@GroupName NVARCHAR(200),
@InsertionType nvarchar(50),
@CompanyName nvarchar(50),
@IDP_OR_SP_URL nvarchar(1000),
@Destination nvarchar(1000),
@AssertionConsumerServiceURL nvarchar(1000),
@Issuer  nvarchar(1000),
@RelayState nvarchar(1000),
@CertificateName nvarchar(200),
@Certificate nvarchar(max),
@Parameters NVARCHAR(1000),
@Status nvarchar(10),
@IsSSOLoginActiveForEmployee bit,
@IsSSOLoginActiveForCO bit,
@IsSSOLoginActiveForNonEmployee bit,
@IsSSOLoginActiveForCorporateUser bit,
@Message NVARCHAR(100) OUT

AS
BEGIN
	SET NOCOUNT ON;
    IF(@SSOID=0)
		IF EXISTS (SELECT * FROM [dbo].[SSOConfiguration] WHERE [CompanyName] =@CompanyName AND [Status]='True') 
		BEGIN
		  SET @Message='Company Name Already Exist.';
		END
		ELSE
		BEGIN
				
				INSERT INTO [dbo].[SSOConfiguration] ([GroupID],[GroupName], [CompanyName], [InsertionType], [IDP_SP_URL], [DestinationURL], [AssertionConsumerServiceURL],[IssuerURL],[RelayState],[CertificateName],[Certificate], [Parameters], [CreatedBy], [CreatedDate], [UpdatedBy], [UpdatedDate], [Status], [IsSSOLoginActiveForEmployee], [IsSSOLoginActiveForCO],[IsSSOLoginActiveForNonEmployee], [IsSSOLoginActiveForCorporateUser] )
				VALUES(@GroupID, @GroupName, @CompanyName, @InsertionType, @IDP_OR_SP_URL,@Destination, @AssertionConsumerServiceURL, @Issuer, @RelayState,@CertificateName, @Certificate, @Parameters, 'Admin', GETDATE(), 'Admin', GETDATE(), @Status, @IsSSOLoginActiveForEmployee, @IsSSOLoginActiveForCO, @IsSSOLoginActiveForNonEmployee, @IsSSOLoginActiveForCorporateUser);
				SET @Message='Saved';
			
		END

	ELSE IF(@SSOID > 0 AND @Status='True')
	    IF EXISTS (SELECT * FROM [dbo].[SSOConfiguration] WHERE [CompanyName] =@CompanyName AND [Status]='True' AND SSOId <> @SSOID ) 
			BEGIN
			  SET @Message='Company Name Already Exist.';
			END
		ELSE
			BEGIN
			UPDATE [dbo].[SSOConfiguration] SET [GroupID]=@GroupID, [GroupName]=@GroupName, [CompanyName]=@CompanyName, [InsertionType]=@InsertionType, [IDP_SP_URL]=@IDP_OR_SP_URL, [DestinationURL]=@Destination, 
			[AssertionConsumerServiceURL]=@AssertionConsumerServiceURL,[IssuerURL]=@Issuer,[RelayState]=@RelayState,[CertificateName]=@CertificateName,[Certificate]=@Certificate, [Parameters]=@Parameters, [UpdatedBy]='Admin', [UpdatedDate]=GETDATE(), [Status]=@Status,  [IsSSOLoginActiveForEmployee]=@IsSSOLoginActiveForEmployee, [IsSSOLoginActiveForCO]=@IsSSOLoginActiveForCO, [IsSSOLoginActiveForNonEmployee]=@IsSSOLoginActiveForNonEmployee, [IsSSOLoginActiveForCorporateUser]=@IsSSOLoginActiveForCorporateUser  
			WHERE SSOId=@SSOID
			SET @Message ='Updated'
			END
	ELSE IF(@SSOID > 0 AND @Status='False')
		BEGIN
		 UPDATE [dbo].[SSOConfiguration] SET [UpdatedBy]='Admin', [UpdatedDate]=GETDATE(), [Status]=@Status WHERE SSOId=@SSOID
		 SET @Message ='Deleted'
		END
   ELSE
	   BEGIN
			SET @Message = 'Action is not performed'
		  END
		  IF @@ERROR <> 0
			BEGIN
		    SET @Message = 'Some error found while action performed'
		END

END
