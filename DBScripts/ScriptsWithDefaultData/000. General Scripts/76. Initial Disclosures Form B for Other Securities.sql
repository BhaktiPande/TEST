
-- ======================================================================================================
-- Author      : Samadhan kadam
-- CREATED DATE: 06-Mar-2018
-- Description : Script for Initial Disclosures Form for Other Companies .
-- ======================================================================================================

----com_Code entry for 'Initial Disclosures Form for Other Companies Open--
IF NOT EXISTS(SELECT codeid FROM com_code WHERE codeid = 156008)
BEGIN
	INSERT INTO com_code([CodeID],[CodeName],[CodeGroupId],[Description],[IsVisible],[IsActive],[DisplayOrder],[DisplayCode],[ParentCodeId],[ModifiedBy],[ModifiedOn])
	VALUES ( 156008,	'Initial Disclosures Form for Other Securities',156,'Initial Disclosures Form for Other Securities',1,1,8,NULL,	166002,1,	getdate())
END

IF NOT EXISTS(SELECT codeid FROM com_code WHERE codeid = 132020)
BEGIN
	INSERT INTO com_code([CodeID],[CodeName],[CodeGroupId],[Description],[IsVisible],[IsActive],[DisplayOrder],[DisplayCode],[ParentCodeId],[ModifiedBy],[ModifiedOn])
	VALUES ( 132020,	'Disclosure Transaction for OS',132,'Map To Type - Disclosure Transaction for OS',1,1,20,NULL,	166002,1,	getdate())
END
----com_Code entry for 'Initial Disclosures Form for Other Companies close--


--- com_PlaceholderMaster for Initial Disclosures Form for Other Companies Open
IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156008 AND PlaceholderTag='[USROS_FIRSTNAME]')
	INSERT INTO com_PlaceholderMaster(PlaceholderTag,	PlaceholderDisplayName,	PlaceholderGroupId,	PlaceholderDescription,	IsVisible,	DisplayOrder,CreatedBy,	CreatedOn,	ModifiedBy,	ModifiedOn)
	VALUES('[USROS_FIRSTNAME]',	'First name'	,156008	,'Frist name OS',	1,	1,	1	,GETDATE(),	1,GETDATE())
IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156008 AND PlaceholderTag='[USROS_MIDDLENAME]')
	INSERT INTO com_PlaceholderMaster(PlaceholderTag,	PlaceholderDisplayName,	PlaceholderGroupId,	PlaceholderDescription,	IsVisible,	DisplayOrder,CreatedBy,	CreatedOn,	ModifiedBy,	ModifiedOn)
	VALUES('[USROS_MIDDLENAME]','Middle name'	,156008	 ,'Middle name OS',	1,	2,	1	,GETDATE(),	1,GETDATE())
IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156008 AND PlaceholderTag='[USROS_LASTNAME]')
	INSERT INTO com_PlaceholderMaster(PlaceholderTag,	PlaceholderDisplayName,	PlaceholderGroupId,	PlaceholderDescription,	IsVisible,	DisplayOrder,CreatedBy,	CreatedOn,	ModifiedBy,	ModifiedOn)
	VALUES('[USROS_LASTNAME]',	'Last name'	,156008	 ,'Last name OS',	1,	3,	1	,GETDATE(),	1,GETDATE())
IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156008 AND PlaceholderTag='[USROS_EMPLOYEEID]')
	INSERT INTO com_PlaceholderMaster(PlaceholderTag,	PlaceholderDisplayName,	PlaceholderGroupId,	PlaceholderDescription,	IsVisible,	DisplayOrder,CreatedBy,	CreatedOn,	ModifiedBy,	ModifiedOn)
	VALUES('[USROS_EMPLOYEEID]',	'EMPLOYEEID'	,156008	 ,'EMPLOYEEID OS',	1,	4,	1	,GETDATE(),	1,GETDATE())
IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156008 AND PlaceholderTag='[USROS_DEPT]')
	INSERT INTO com_PlaceholderMaster(PlaceholderTag,	PlaceholderDisplayName,	PlaceholderGroupId,	PlaceholderDescription,	IsVisible,	DisplayOrder,CreatedBy,	CreatedOn,	ModifiedBy,	ModifiedOn)
	VALUES('[USROS_DEPT]',	'Department'	,156008,'Department/branch OS',	1,	5,	1	,GETDATE(),	1,GETDATE())
IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156008 AND PlaceholderTag='[USROS_INITIALDISCLOSURESUBMISSIONDATE]')
	INSERT INTO com_PlaceholderMaster(PlaceholderTag,	PlaceholderDisplayName,	PlaceholderGroupId,	PlaceholderDescription,	IsVisible,	DisplayOrder,CreatedBy,	CreatedOn,	ModifiedBy,	ModifiedOn)
	VALUES('[USROS_INITIALDISCLOSURESUBMISSIONDATE]',	'INITIAL DISCLOSURE SUBMISSION DATE'	,156008	 ,'INITIAL DISCLOSURE SUBMISSION DATE OS',	1,	6,	1	,GETDATE(),	1,GETDATE())
IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156008 AND PlaceholderTag='[USROS_DEMATACCOUNT]')
	INSERT INTO com_PlaceholderMaster(PlaceholderTag,	PlaceholderDisplayName,	PlaceholderGroupId,	PlaceholderDescription,	IsVisible,	DisplayOrder,CreatedBy,	CreatedOn,	ModifiedBy,	ModifiedOn)
	VALUES('[USROS_DEMATACCOUNT]',	'DEMAT ACCOUNT'	,156008	,'DEMAT ACCOUNT OS',	1,	7,	1	,GETDATE(),	1,GETDATE())
IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156008 AND PlaceholderTag='[USROS_DESIGNATION]')
	INSERT INTO com_PlaceholderMaster(PlaceholderTag,	PlaceholderDisplayName,	PlaceholderGroupId,	PlaceholderDescription,	IsVisible,	DisplayOrder,CreatedBy,	CreatedOn,	ModifiedBy,	ModifiedOn)
	VALUES('[USROS_DESIGNATION]',	'DESIGNATION NAME'	,156008	,'DESIGNATION NAME OS',	1,	8,	1	,GETDATE(),	1,GETDATE())
IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156008 AND PlaceholderTag='[USROS_RELATIONWITHINSIDER]')
	INSERT INTO com_PlaceholderMaster(PlaceholderTag,	PlaceholderDisplayName,	PlaceholderGroupId,	PlaceholderDescription,	IsVisible,	DisplayOrder,CreatedBy,	CreatedOn,	ModifiedBy,	ModifiedOn)
	VALUES('[USROS_RELATIONWITHINSIDER]',	'RELATION WITH INSIDER'	,156008	 ,'RELATION WITH INSIDER OS',	1,	9,	1	,GETDATE(),	1,GETDATE())
IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156008 AND PlaceholderTag='[USROS_PAN]')
	INSERT INTO com_PlaceholderMaster(PlaceholderTag,	PlaceholderDisplayName,	PlaceholderGroupId,	PlaceholderDescription,	IsVisible,	DisplayOrder,CreatedBy,	CreatedOn,	ModifiedBy,	ModifiedOn)
	VALUES('[USROS_PAN]',	'PAN'	,156008	,'PAN OS',	1,	10,	1	,GETDATE(),	1,GETDATE())
IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156008 AND PlaceholderTag='[USROS_SCRIP_NAME]')
	INSERT INTO com_PlaceholderMaster(PlaceholderTag,	PlaceholderDisplayName,	PlaceholderGroupId,	PlaceholderDescription,	IsVisible,	DisplayOrder,CreatedBy,	CreatedOn,	ModifiedBy,	ModifiedOn)
	VALUES('[USROS_SCRIP_NAME]',	'SCRIP NAME'	,156008	,'SCRIP NAME OS',	1,	11,	1	,GETDATE(),	1,GETDATE())
IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156008 AND PlaceholderTag='[USROS_ISIN]')
	INSERT INTO com_PlaceholderMaster(PlaceholderTag,	PlaceholderDisplayName,	PlaceholderGroupId,	PlaceholderDescription,	IsVisible,	DisplayOrder,CreatedBy,	CreatedOn,	ModifiedBy,	ModifiedOn)
	VALUES('[USROS_ISIN]',	'ISIN'	,156008	 ,'ISIN OS',	1,	12,	1	,GETDATE(),	1,GETDATE())
IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156008 AND PlaceholderTag='[USROS_SECURITYTYPE]')
	INSERT INTO com_PlaceholderMaster(PlaceholderTag,	PlaceholderDisplayName,	PlaceholderGroupId,	PlaceholderDescription,	IsVisible,	DisplayOrder,CreatedBy,	CreatedOn,	ModifiedBy,	ModifiedOn)
	VALUES('[USROS_SECURITYTYPE]',	'SECURITY TYPE'	,156008 ,'SECURITY TYPE OS',	1,	13,	1	,GETDATE(),	1,GETDATE())
IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156008 AND PlaceholderTag='[USROS_HOLDINGS]')
	INSERT INTO com_PlaceholderMaster(PlaceholderTag,	PlaceholderDisplayName,	PlaceholderGroupId,	PlaceholderDescription,	IsVisible,	DisplayOrder,CreatedBy,	CreatedOn,	ModifiedBy,	ModifiedOn)
	VALUES('[USROS_HOLDINGS]',	'USROS_HOLDINGS'	,156008	 ,'HOLDINGS OS',	1,	14,	1	,GETDATE(),	1,GETDATE())
--- com_PlaceholderMaster for Initial Disclosures Form for Other Companies close

---script for initial disclosures From tamplete for tra_TamplateMaster table open
IF NOT EXISTS(SELECT * FROM tra_TemplateMaster WHERE CommunicationModeCodeId = 156008)
BEGIN
			INSERT INTO tra_TemplateMaster(TemplateName,CommunicationModeCodeId,DisclosureTypeCodeId,LetterForCodeId,IsActive
					   ,Date,ToAddress1,ToAddress2,Subject,Contents,Signature,CommunicationFrom,SequenceNo,IsCommunicationTemplate
					   ,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
			 VALUES('Initial Disclosures Form for Other Securities Template',156008,NULL,NULL,1,NULL,NULL,NULL,NULL,
					'<div style="margin: 30px; width: 650px;font-family: ''Roboto'', sans-serif;font-size:12px; padding-left:10px;">
        <p style="text-align: center; font-size:18px">
            <b>Initial Disclosures Form for Other Securities  </b>
        </p>
        <br /><br /><br /><br />

        <p><b>NAME : </b> [USROS_FIRSTNAME] [USROS_MIDDLENAME] [USROS_LASTNAME]</p><br />
        <p><b>EMPLOYEE CODE : </b>[USROS_EMPLOYEEID]</p><br />
        <p><b>BRANCH/DEPARTMENT : </b> [USROS_DEPT]</p>
      
        <br /><br /><br />
        <p style="text-align: justify;"> <b>Please note that as of [USROS_INITIALDISCLOSURESUBMISSIONDATE] I hold securities of the following listed companies, as under: </b></p>
        <br /><br />

        <table border="1" cellspacing="0" cellpadding="10" style="max-width: 700px;font-family:inherit;font-size:inherit;">
           <tbody>
            <tr height="18">
                <td width="120" valign="top" style="word-wrap: break-word"><b>Demat Account  </b></td>
                <td width="50" valign="top" style="word-wrap: break-word"><b>Account Holder Name </b></td>
                <td width="52" valign="top" style="word-wrap: break-word"><b>Relation with Insider </b></td>
                <td width="80" valign="top" style="word-wrap: break-word"><b>PAN </b></td>
                <td width="90" valign="top" style="word-wrap: break-word"><b>Scrip Name </b></td>
                <td width="50" valign="top" style="word-wrap: break-word"><b>ISIN </b></td>
                <td width="50" valign="top" style="word-wrap: break-word"><b>Security Type </b></td>
                <td width="52" valign="top" style="word-wrap: break-word"><b>Holdings </b></td>

            </tr>

            <tr height="18">
                <td width="120" height="18" valign="top"> [USROS_DEMATACCOUNT] </td>
                <td width="50" height="18" valign="top"> [USROS_FIRSTNAME] [USROS_MIDDLENAME] [USROS_LASTNAME] </td>
                <td width="52" height="18" valign="top"> [USROS_RELATIONWITHINSIDER] </td>
                <td width="80" height="18" valign="top"> [USROS_PAN] </td>
                <td width="90" height="18" valign="top"> [USROS_SCRIP_NAME] </td>
                <td width="50" height="18" valign="top"> [USROS_ISIN] </td>
                <td width="50" height="18" valign="top"> [USROS_SECURITYTYPE] </td>
                <td width="52" height="18" valign="top"> [USROS_HOLDINGS] </td>
              
            </tr>
             </tbody>
        </table>
        <br /> <br /><br /><br /><br /><br /><br /><br />

        <p><b>Signature:</b></p><br />
        <p><b>Designation: </b> [USROS_DESIGNATION] </p><br />
        <p><b>Date: </b></p><br />
        <p><b>Place: </b></p>
    
    </div>' ,
					NULL,NULL,NULL,0,1,GETDATE(),1,GETDATE()
					)
END

---script for initial disclosures From tamplete for tra_TamplateMaster table close

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54058)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54058,'dis_msg_54058','Error occurred while generating form B For OS details','en-US',103009,104001, 122044,'Error occurred while generating form B For OS details',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54059)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54059,'dis_msg_54059','FORM B for OS not generated.','en-US',103009,104001, 122044,'ORM B for OS not generated.',1,GETDATE())
END
