
-- ======================================================================================================
-- Author      : Shubhangi Gurude
-- CREATED DATE: 15-Mar-2018
-- Description : Script for Continuous Disclosures Form for Other Companies .
-- ======================================================================================================

----com_Code entry for 'Initial Disclosures Form for Other Companies Open--
IF NOT EXISTS(SELECT codeid FROM com_code WHERE codeid = 156009)
BEGIN
	INSERT INTO com_code([CodeID],[CodeName],[CodeGroupId],[Description],[IsVisible],[IsActive],[DisplayOrder],[DisplayCode],[ParentCodeId],[ModifiedBy],[ModifiedOn])
	VALUES ( 156009,'Continuous Disclosures Form for Other Securities',156,'Continuous Disclosures Form for Other Securities',1,1,9,NULL,	166002,1,	getdate())
END

--IF NOT EXISTS(SELECT codeid FROM com_code WHERE codeid = 132020)
--BEGIN
--	INSERT INTO com_code([CodeID],[CodeName],[CodeGroupId],[Description],[IsVisible],[IsActive],[DisplayOrder],[DisplayCode],[ParentCodeId],[ModifiedBy],[ModifiedOn])
--	VALUES ( 132020,	'Disclosure Transaction for OS',132,'Map To Type - Disclosure Transaction for OS',1,1,20,NULL,	166002,1,	getdate())
--END
----com_Code entry for 'Initial Disclosures Form for Other Companies close--


--- com_PlaceholderMaster for Initial Disclosures Form for Other Companies Open
IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156009 AND PlaceholderTag='[CDOS_FIRSTNAME]')
	INSERT INTO com_PlaceholderMaster(PlaceholderTag,	PlaceholderDisplayName,	PlaceholderGroupId,	PlaceholderDescription,	IsVisible,	DisplayOrder,CreatedBy,	CreatedOn,	ModifiedBy,	ModifiedOn)
	VALUES('[CDOS_FIRSTNAME]',	'First name'	,156009	,'Frist name OS',	1,	1,	1	,GETDATE(),	1,GETDATE())
IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156009 AND PlaceholderTag='[CDOS_MIDDLENAME]')
	INSERT INTO com_PlaceholderMaster(PlaceholderTag,	PlaceholderDisplayName,	PlaceholderGroupId,	PlaceholderDescription,	IsVisible,	DisplayOrder,CreatedBy,	CreatedOn,	ModifiedBy,	ModifiedOn)
	VALUES('[CDOS_MIDDLENAME]','Middle name'	,156009	 ,'Middle name OS',	1,	2,	1	,GETDATE(),	1,GETDATE())
IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156009 AND PlaceholderTag='[CDOS_LASTNAME]')
	INSERT INTO com_PlaceholderMaster(PlaceholderTag,	PlaceholderDisplayName,	PlaceholderGroupId,	PlaceholderDescription,	IsVisible,	DisplayOrder,CreatedBy,	CreatedOn,	ModifiedBy,	ModifiedOn)
	VALUES('[CDOS_LASTNAME]',	'Last name'	,156009	 ,'Last name OS',	1,	3,	1	,GETDATE(),	1,GETDATE())
IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156009 AND PlaceholderTag='[CDOS_EMPLOYEEID]')
	INSERT INTO com_PlaceholderMaster(PlaceholderTag,	PlaceholderDisplayName,	PlaceholderGroupId,	PlaceholderDescription,	IsVisible,	DisplayOrder,CreatedBy,	CreatedOn,	ModifiedBy,	ModifiedOn)
	VALUES('[CDOS_EMPLOYEEID]',	'EMPLOYEEID'	,156009	 ,'EMPLOYEEID OS',	1,	4,	1	,GETDATE(),	1,GETDATE())
IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156009 AND PlaceholderTag='[CDOS_DEPT]')
	INSERT INTO com_PlaceholderMaster(PlaceholderTag,	PlaceholderDisplayName,	PlaceholderGroupId,	PlaceholderDescription,	IsVisible,	DisplayOrder,CreatedBy,	CreatedOn,	ModifiedBy,	ModifiedOn)
	VALUES('[CDOS_DEPT]',	'Department'	,156009,'Department/branch OS',	1,	5,	1	,GETDATE(),	1,GETDATE())
	
IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156009 AND PlaceholderTag='[PCLOS_NO]')
	INSERT INTO com_PlaceholderMaster(PlaceholderTag,	PlaceholderDisplayName,	PlaceholderGroupId,	PlaceholderDescription,	IsVisible,	DisplayOrder,CreatedBy,	CreatedOn,	ModifiedBy,	ModifiedOn)
	VALUES('[PCLOS_NO]','Pre Clearance No for OS'	,156009,'Pre Clearance No for OS',	1,	6,	1	,GETDATE(),	1,GETDATE())
	
IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156009 AND PlaceholderTag='[PCLOS_DATE]')
	INSERT INTO com_PlaceholderMaster(PlaceholderTag,	PlaceholderDisplayName,	PlaceholderGroupId,	PlaceholderDescription,	IsVisible,	DisplayOrder,CreatedBy,	CreatedOn,	ModifiedBy,	ModifiedOn)
	VALUES('[PCLOS_DATE]','Pre Clearance Date for OS'	,156009,'Pre Clearance Date for OS',	1,	7,	1	,GETDATE(),	1,GETDATE())
	
IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156009 AND PlaceholderTag='[CDOS_ACCOUNTHOLDERNAME]')
	INSERT INTO com_PlaceholderMaster(PlaceholderTag,	PlaceholderDisplayName,	PlaceholderGroupId,	PlaceholderDescription,	IsVisible,	DisplayOrder,CreatedBy,	CreatedOn,	ModifiedBy,	ModifiedOn)
	VALUES('[CDOS_ACCOUNTHOLDERNAME]','Account Holder Name for OS'	,156009,'Account Holder Name for OS',	1,	8,	1	,GETDATE(),	1,GETDATE())
	
IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156009 AND PlaceholderTag='[CDOS_RELATIONWITHINSIDER]')
	INSERT INTO com_PlaceholderMaster(PlaceholderTag,	PlaceholderDisplayName,	PlaceholderGroupId,	PlaceholderDescription,	IsVisible,	DisplayOrder,CreatedBy,	CreatedOn,	ModifiedBy,	ModifiedOn)
	VALUES('[CDOS_RELATIONWITHINSIDER]','Relation with Insider for OS'	,156009,'Relation with Insider for OS',	1,	9,	1	,GETDATE(),	1,GETDATE())
	
IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156009 AND PlaceholderTag='[CDOS_PAN]')
	INSERT INTO com_PlaceholderMaster(PlaceholderTag,	PlaceholderDisplayName,	PlaceholderGroupId,	PlaceholderDescription,	IsVisible,	DisplayOrder,CreatedBy,	CreatedOn,	ModifiedBy,	ModifiedOn)
	VALUES('[CDOS_PAN]','PAN for OS',156009,'PAN for OS',	1,	10,	1	,GETDATE(),	1,GETDATE())
	
IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156009 AND PlaceholderTag='[CDOS_COMPANYNAME]')
	INSERT INTO com_PlaceholderMaster(PlaceholderTag,	PlaceholderDisplayName,	PlaceholderGroupId,	PlaceholderDescription,	IsVisible,	DisplayOrder,CreatedBy,	CreatedOn,	ModifiedBy,	ModifiedOn)
	VALUES('[CDOS_COMPANYNAME]','Name of the Security(ies) for OS'	,156009,'Name of the Security(ies) for OS',	1,	10,	1	,GETDATE(),	1,GETDATE())
	
IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156009 AND PlaceholderTag='[CDOS_SECURITYTYPE]')
	INSERT INTO com_PlaceholderMaster(PlaceholderTag,	PlaceholderDisplayName,	PlaceholderGroupId,	PlaceholderDescription,	IsVisible,	DisplayOrder,CreatedBy,	CreatedOn,	ModifiedBy,	ModifiedOn)
	VALUES('[CDOS_SECURITYTYPE]','Type of Security for OS'	,156009,'Type of Security for OS',	1,	11,	1	,GETDATE(),	1,GETDATE())
	
IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156009 AND PlaceholderTag='[CDOS_TRANSACTIONTYPE]')
	INSERT INTO com_PlaceholderMaster(PlaceholderTag,	PlaceholderDisplayName,	PlaceholderGroupId,	PlaceholderDescription,	IsVisible,	DisplayOrder,CreatedBy,	CreatedOn,	ModifiedBy,	ModifiedOn)
	VALUES('[CDOS_TRANSACTIONTYPE]','Nature of Transaction for OS'	,156009,'Nature of Transaction for OS',	1,	12,	1	,GETDATE(),	1,GETDATE())
	
IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156009 AND PlaceholderTag='[CDOS_DEMATACCOUNTNO]')
	INSERT INTO com_PlaceholderMaster(PlaceholderTag,	PlaceholderDisplayName,	PlaceholderGroupId,	PlaceholderDescription,	IsVisible,	DisplayOrder,CreatedBy,	CreatedOn,	ModifiedBy,	ModifiedOn)
	VALUES('[CDOS_DEMATACCOUNTNO]','Demat Account No. for OS'	,156009,'Demat Account No. for OS',	1,	13,	1	,GETDATE(),	1,GETDATE())
	
IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156009 AND PlaceholderTag='[CDOS_HOLDINGS]')
	INSERT INTO com_PlaceholderMaster(PlaceholderTag,	PlaceholderDisplayName,	PlaceholderGroupId,	PlaceholderDescription,	IsVisible,	DisplayOrder,CreatedBy,	CreatedOn,	ModifiedBy,	ModifiedOn)
	VALUES('[CDOS_HOLDINGS]','Quantity of Security (ies) for OS'	,156009,'Quantity of Security (ies) for OS',	1,	14,	1	,GETDATE(),	1,GETDATE())
	
IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156009 AND PlaceholderTag='[CDOS_NAMEOFEXCHANGE]')
	INSERT INTO com_PlaceholderMaster(PlaceholderTag,	PlaceholderDisplayName,	PlaceholderGroupId,	PlaceholderDescription,	IsVisible,	DisplayOrder,CreatedBy,	CreatedOn,	ModifiedBy,	ModifiedOn)
	VALUES('[CDOS_NAMEOFEXCHANGE]',	'Name of the Exchange for OS'	,156009,'Name of the Exchange for OS',	1,	15,	1	,GETDATE(),	1,GETDATE())
	
IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156009 AND PlaceholderTag='[CDOS_INTIMATIONDATE]')
	INSERT INTO com_PlaceholderMaster(PlaceholderTag,	PlaceholderDisplayName,	PlaceholderGroupId,	PlaceholderDescription,	IsVisible,	DisplayOrder,CreatedBy,	CreatedOn,	ModifiedBy,	ModifiedOn)
	VALUES('[CDOS_INTIMATIONDATE]',	'Date of intimation for OS'	,156009,'Date of intimation for OS',	1,	15,	1	,GETDATE(),	1,GETDATE())	

---script for initial disclosures From tamplete for tra_TamplateMaster table open
IF NOT EXISTS(SELECT * FROM tra_TemplateMaster WHERE CommunicationModeCodeId = 156009)
BEGIN
			INSERT INTO tra_TemplateMaster(TemplateName,CommunicationModeCodeId,DisclosureTypeCodeId,LetterForCodeId,IsActive
					   ,Date,ToAddress1,ToAddress2,Subject,Contents,Signature,CommunicationFrom,SequenceNo,IsCommunicationTemplate
					   ,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
			 VALUES('Continuous Disclosures Form for Other Securities Template',156009,NULL,NULL,1,NULL,NULL,NULL,NULL,
					'<div style="margin: 30px; width: 650px;font-family: ''Roboto'', sans-serif;font-size:11.5px; padding-left:10px;">
					 <p style="text-align: center;font-size:18px""><b>
						Trade Details Form for Other Securities </b>
					</p>
					<br /><br />
					<p><b>Date</b> &nbsp;:  [CDOS_INTIMATIONDATE] </p>
					<p><b>To</b> &nbsp;&nbsp;&nbsp;  :  Compliance Officer </p>
					<p><b>From</b> :  [CDOS_FIRSTNAME] [CDOS_MIDDLENAME] [CDOS_LASTNAME]</p>
					<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;      [CDOS_EMPLOYEEID]</p>
					<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;    [CDOS_DEPT] </p>    
					<br />
					<p style="text-align: justify;"> DETAILS OF TRANSACTION</p>
					<br />
					<p>Ref: Your Approval PCL  No.&nbsp; [PCLOS_NO] &nbsp; dated &nbsp; [PCLOS_DATE] </p>
					<P>I hereby inform you that &nbsp; [CDOS_FIRSTNAME] [CDOS_MIDDLENAME] [CDOS_LASTNAME] &nbsp; has bought/sold/ Securities as mentioned below </P>
					<br/>
					<table border="1" cellspacing="0" cellpadding="10" style="max-width: 700px;font-family:inherit;font-size:inherit;">
					   <tbody>
						<tr height="18">
							<td width="50" valign="top" style="word-wrap: break-word"><b>Account Holder Name  </b></td>
							<td width="50" valign="top" style="word-wrap: break-word"><b>Relation with Insider </b></td>
							<td width="80" valign="top" style="word-wrap: break-word"><b>PAN </b></td>
							<td width="50" valign="top" style="word-wrap: break-word"><b>Name of the Security(ies) </b></td>
							<td width="50" valign="top" style="word-wrap: break-word"><b>Type of Security </b></td>
							<td width="45" valign="top" style="word-wrap: break-word"><b>Nature of Transaction </b></td>
							<td width="50" valign="top" style="word-wrap: break-word"><b>Demat Account No. </b></td>
							<td width="50" valign="top" style="word-wrap: break-word"><b>Quantity of Security (ies) </b></td>
							<td width="60" valign="top" style="word-wrap: break-word"><b>Name of the Exchange </b></td>
						</tr>

						<tr height="18">
							<td width="50" height="18" valign="top"> [CDOS_ACCOUNTHOLDERNAME] </td>
							<td width="50" height="18" valign="top"> [CDOS_RELATIONWITHINSIDER] </td>
							<td width="80" height="18" valign="top"> [CDOS_PAN] </td>
							<td width="50" height="18" valign="top"> [CDOS_COMPANYNAME] </td>
							<td width="45" height="18" valign="top"> [CDOS_SECURITYTYPE] </td>
							<td width="45" height="18" valign="top"> [CDOS_TRANSACTIONTYPE] </td>
							<td width="50" height="18" valign="top"> [CDOS_DEMATACCOUNTNO] </td>
							<td width="50" height="18" valign="top"> [CDOS_HOLDINGS] </td>
							<td width="60" height="18" valign="top"> [CDOS_NAMEOFEXCHANGE] </td>
						</tr>
						 </tbody>
					</table>
					<br /> <br />
					<p style="text-align: justify;">I declare that the above information is correct and that no provisions of the Company’s Trading Code of Conduct and/or applicable laws/regulations have been contravened for effecting the above said transaction(s).</p>
					<p style="text-align: justify;">I agree not to buy/sell ● the Securities for a period of 6 months/30 days ●, as the case may be from the date of the aforesaid transaction (applicable in case of purchase / sale transaction by Designated Persons only).</p>
					<p style="text-align: justify;">In case there is any urgent need to sell these Securities within the said period, I shall approach the Company (Compliance Officer) for necessary approval (applicable in case of purchase / subscription).</p>

					<br/>
					<p>Yours truly,</p>
					<p>Signature:</p>
					<br/>
					<p>Name:[CDOS_FIRSTNAME] [CDOS_MIDDLENAME] [CDOS_LASTNAME]</p>       
    
					</div>',
					NULL,NULL,NULL,0,1,GETDATE(),1,GETDATE()
					)
END

---script for initial disclosures From tamplete for tra_TamplateMaster table close

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 52079)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (52079,'dis_msg_52079','Error occurred while generating form C For OS details','en-US',103303,104001, 122044,'Error occurred while generating form C For OS details',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 52080)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (52080,'dis_msg_52080','FORM C for OS is not generated.','en-US',103303,104001, 122103,'FORM C for OS is not generated.',1,GETDATE())
END

