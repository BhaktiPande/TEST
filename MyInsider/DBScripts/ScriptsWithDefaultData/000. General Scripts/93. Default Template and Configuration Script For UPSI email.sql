-- ======================================================================================================
-- Author      : Samadhan Kadm																			=
-- CREATED DATE: 07-APR-2016                                                 							=
-- Description : INSERT DATA IN  com_CompanySettingConfiguration	,tra_TemplateMaster					=
-- ======================================================================================================

IF NOT EXISTS(SELECT * FROM com_CompanySettingConfiguration WHERE ConfigurationTypeCodeId=180008 AND ConfigurationCodeId=526001 AND ConfigurationValueCodeId=192006)
BEGIN
	INSERT INTO com_CompanySettingConfiguration
	(
		ConfigurationTypeCodeId	,
		ConfigurationCodeId	,
		ConfigurationValueCodeId	,
		ConfigurationValueOptional	,
		IsMappingCode	,
		CreatedBy	,
		CreatedOn	,
		ModifiedBy	,
		ModifiedOn	,
		RLSearchLimit
	)
	VALUES( 180008,526001,192006,NULL,0,1,GETDATE(),1,GETDATE(),NULL)
END
IF NOT EXISTS(SELECT * FROM com_CompanySettingConfiguration WHERE ConfigurationTypeCodeId=180008 AND ConfigurationCodeId=526002 AND ConfigurationValueCodeId=192006)
BEGIN
	INSERT INTO com_CompanySettingConfiguration
	(
		ConfigurationTypeCodeId	,
		ConfigurationCodeId	,
		ConfigurationValueCodeId	,
		ConfigurationValueOptional	,
		IsMappingCode	,
		CreatedBy	,
		CreatedOn	,
		ModifiedBy	,
		ModifiedOn	,
		RLSearchLimit
	)
	VALUES( 180008,526002,192006,NULL,0,1,GETDATE(),1,GETDATE(),NULL)
END
IF NOT EXISTS(SELECT * FROM com_CompanySettingConfiguration WHERE ConfigurationTypeCodeId=180008 AND ConfigurationCodeId=180009 AND ConfigurationValueOptional='525002')
BEGIN
	INSERT INTO com_CompanySettingConfiguration
	(
		ConfigurationTypeCodeId	,
		ConfigurationCodeId	,
		ConfigurationValueCodeId	,
		ConfigurationValueOptional	,
		IsMappingCode	,
		CreatedBy	,
		CreatedOn	,
		ModifiedBy	,
		ModifiedOn	,
		RLSearchLimit
	)
	VALUES( 180008,180009,180008,'525002',0,1,GETDATE(),1,GETDATE(),NULL)
END
IF NOT EXISTS(SELECT * FROM com_CompanySettingConfiguration WHERE ConfigurationTypeCodeId=180008 AND ConfigurationCodeId=180010 AND ConfigurationValueOptional='525003')
BEGIN
	INSERT INTO com_CompanySettingConfiguration
	(
		ConfigurationTypeCodeId	,
		ConfigurationCodeId	,
		ConfigurationValueCodeId	,
		ConfigurationValueOptional	,
		IsMappingCode	,
		CreatedBy	,
		CreatedOn	,
		ModifiedBy	,
		ModifiedOn	,
		RLSearchLimit
	)
	VALUES( 180008,180010,180008,'525003',0,1,GETDATE(),1,GETDATE(),NULL)
END

---script for UPSI Updated mail triggertamplete for tra_TamplateMaster table 
IF NOT EXISTS(SELECT * FROM tra_TemplateMaster WHERE CommunicationModeCodeId = 156011)
BEGIN
			INSERT INTO tra_TemplateMaster(TemplateName,CommunicationModeCodeId,DisclosureTypeCodeId,LetterForCodeId,IsActive
					   ,Date,ToAddress1,ToAddress2,Subject,Contents,Signature,CommunicationFrom,SequenceNo,IsCommunicationTemplate
					   ,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
			 VALUES('UPSI Updated',156011,NULL,NULL,1,NULL,NULL,NULL,'Updated Mail',
					'<div style="margin: 30px; width: 1080px;font-family: ''Roboto'', sans-serif;font-size:12px; padding-left:10px;">
					<div>
						<div>
							Hi,
							<p>Please note that the following unpublished price sensitive information (UPSI) has been shared:</p>
							<br />
							Category of Information: [CategoryOfInformation]<br />
							Reason for sharing information: [ReasonForSharingInformation]<br />
							Mode of sharing information: [ModeOfSharingInformation]<br />
							Date and Time of sharing information:  [DateOfSharingInformation]: [TimeOfSharingInformation]<br /><br />

							Information shared by : <br />
							Name: [SharedByName]<br />
							Email:[SharedByEmailID]<br />
								<table>
							<br /><br />
							Information updated on Vigilante by:<br />
							Name: [NameOfTheUserWhoUpdatedThisInformation]
					   </div>
					</div>
				</div>' ,
					NULL,NULL,NULL,0,1,GETDATE(),1,GETDATE()
					)
END


---script for UPSI Published mail triggertamplete for tra_TamplateMaster table 
--DELETE FROM tra_TemplateMaster WHERE CommunicationModeCodeId = 156011
IF NOT EXISTS(SELECT * FROM tra_TemplateMaster WHERE CommunicationModeCodeId = 156012)
BEGIN
			INSERT INTO tra_TemplateMaster(TemplateName,CommunicationModeCodeId,DisclosureTypeCodeId,LetterForCodeId,IsActive
					   ,Date,ToAddress1,ToAddress2,Subject,Contents,Signature,CommunicationFrom,SequenceNo,IsCommunicationTemplate
					   ,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
			 VALUES('UPSI Published',156012,NULL,NULL,1,NULL,NULL,NULL,'Published Mail',
					'<div style="margin: 30px; width: 1080px;font-family: ''Roboto'', sans-serif;font-size:12px; padding-left:10px;">
					<div>
						<div>
							Hi,
							<p>Please note that the following unpublished price sensitive information (UPSI) that was shared has now been published:</p>
							<br />
							Category of Information: [CategoryOfInformation]<br />
							Reason for sharing information: [ReasonForSharingInformation]<br />
							Mode of sharing information: [ModeOfSharingInformation]<br />
							Date and Time of sharing information:  [DateOfSharingInformation]: [TimeOfSharingInformation]<br />
							Date of publishing: [DateOfPublishing]<br /><br />
							Information shared by : <br />
							Name: [SharedByName]<br />
							Email:[SharedByEmailID]<br /><br />
							
							<table>

							<br /><br />Information updated on Vigilante by:<br />
							Name: [NameOfTheUserWhoUpdatedThisInformation]
					   </div>
					</div>
				</div>' ,
					NULL,NULL,NULL,0,1,GETDATE(),1,GETDATE()
					)
END

