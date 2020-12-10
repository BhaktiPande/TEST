UPDATE com_Code
SET [CodeName]='Equity Shares', [Description]='Security type as Equity Shares' --Shares
WHERE [CodeID]=139001

-----------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE com_Code
SET [CodeName]='Preference Shares', [Description]='Security type as Preference Shares' --Warrants
WHERE [CodeID]=139002

-----------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE com_MassUploadExcelDataTableColumnMapping	
SET DependentValueColumnValue=REPLACE(REPLACE(DependentValueColumnValue,'Shares','Equity Shares'),'Warrants','Preference Shares')	
WHERE MassUploadExcelDataTableColumnMappingId IN(136,138,139,140,141,142,143,144,145)	

------------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE mst_Resource
SET ResourceValue='Type of security (For e.g. ? Equity Shares, Preference Shares, Convertible Debentures etc.)'
WHERE ResourceKey='dis_grd_17135'


------------------------------------------------------------------------------------------------------------------------------------------------------


UPDATE mst_Resource
SET ResourceValue='Type of security (For e.g. ? Equity Shares, Preference Shares, Convertible Debentures etc.)'
WHERE ResourceKey='dis_grd_17190'


------------------------------------------------------------------------------------------------------------------------------------------------------


UPDATE mst_Resource
SET ResourceValue='Type of security (For e.g. ? Equity Shares, Preference Shares, Convertible Debentures etc.)'
WHERE ResourceKey='dis_grd_17193'


------------------------------------------------------------------------------------------------------------------------------------------------------


UPDATE mst_Resource
SET ResourceValue='Type of security (For e.g. ? Equity Shares, Preference Shares, Convertible Debentures etc.)'
WHERE ResourceKey='dis_grd_17198'


------------------------------------------------------------------------------------------------------------------------------------------------------


UPDATE mst_Resource
SET ResourceValue='Type of security (For e.g. ? Equity Shares, Preference Shares, Convertible Debentures etc.)'
WHERE ResourceKey='dis_grd_17212'


------------------------------------------------------------------------------------------------------------------------------------------------------


UPDATE mst_Resource
SET ResourceValue='Type of security (For e.g. ? Equity Shares, Preference Shares, Convertible Debentures etc.)'
WHERE ResourceKey='dis_grd_17215'


------------------------------------------------------------------------------------------------------------------------------------------------------


UPDATE mst_Resource
SET ResourceValue='Type of security (For e.g. ? Equity Shares, Preference Shares, Convertible Debentures etc.)'
WHERE ResourceKey='dis_grd_17220'


------------------------------------------------------------------------------------------------------------------------------------------------------


UPDATE mst_Resource
SET ResourceValue='Type of security (For e.g. Equity Shares, Preference Shares, Convertible Debentures etc.)'
WHERE ResourceKey='dis_grd_50390'


------------------------------------------------------------------------------------------------------------------------------------------------------


UPDATE mst_Resource
SET ResourceValue='Type of security (For e.g. Equity Shares, Preference Shares, Convertible Debentures etc.)'
WHERE ResourceKey='dis_grd_50396'


------------------------------------------------------------------------------------------------------------------------------------------------------


UPDATE mst_Resource
SET OriginalResourceValue='Type of security (For e.g. ? Equity Shares, Preference Shares, Convertible Debentures etc.)'
WHERE ResourceKey='dis_grd_17135'


------------------------------------------------------------------------------------------------------------------------------------------------------


UPDATE mst_Resource
SET OriginalResourceValue='Type of security (For e.g. ? Equity Shares, Preference Shares, Convertible Debentures etc.)'
WHERE ResourceKey='dis_grd_17190'


------------------------------------------------------------------------------------------------------------------------------------------------------


UPDATE mst_Resource
SET OriginalResourceValue='Type of security (For e.g. ? Equity Shares, Preference Shares, Convertible Debentures etc.)'
WHERE ResourceKey='dis_grd_17193'


------------------------------------------------------------------------------------------------------------------------------------------------------


UPDATE mst_Resource
SET OriginalResourceValue='Type of security (For e.g. ? Equity Shares, Preference Shares, Convertible Debentures etc.)'
WHERE ResourceKey='dis_grd_17198'


------------------------------------------------------------------------------------------------------------------------------------------------------



UPDATE mst_Resource
SET OriginalResourceValue='Type of security (For e.g. ? Equity Shares, Preference Shares, Convertible Debentures etc.)'
WHERE ResourceKey='dis_grd_17212'


------------------------------------------------------------------------------------------------------------------------------------------------------


UPDATE mst_Resource
SET OriginalResourceValue='Type of security (For e.g. ? Equity Shares, Preference Shares, Convertible Debentures etc.)'
WHERE ResourceKey='dis_grd_17215'


------------------------------------------------------------------------------------------------------------------------------------------------------


UPDATE mst_Resource
SET OriginalResourceValue='Type of security (For e.g. ? Equity Shares, Preference Shares, Convertible Debentures etc.)'
WHERE ResourceKey='dis_grd_17220'


------------------------------------------------------------------------------------------------------------------------------------------------------


UPDATE mst_Resource
SET OriginalResourceValue='Type of security (For e.g. Equity Shares, Preference Shares, Convertible Debentures etc.)'
WHERE ResourceKey='dis_grd_50390'


------------------------------------------------------------------------------------------------------------------------------------------------------


UPDATE mst_Resource
SET OriginalResourceValue='Type of security (For e.g. Equity Shares, Preference Shares, Convertible Debentures etc.)'
WHERE ResourceKey='dis_grd_50396'


------------------------------------------------------------------------------------------------------------------------------------------------------

----------------14/08/2018--------------------------------------------------------------------------------------------------------------------------

UPDATE mst_Resource
SET ResourceValue='Equity Shares',OriginalResourceValue='Equity Shares'
WHERE ResourceKey in ('cmp_grd_13018','cmp_grd_13021','cmp_lbl_13070')

-----------------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE mst_Resource
SET ResourceValue='Enter Authorized Equity Shares value max 15 digit number',OriginalResourceValue='Enter Authorized Equity Shares value max 15 digit number'
WHERE ResourceKey in ('cmp_msg_13100','cmp_msg_13101')

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE mst_Resource
SET ResourceValue='Mandatory : Any one/both of - No of Equity shares / % of paid up & subscribed capital.',OriginalResourceValue='Mandatory : Any one/all of - No of Equity shares/% of paid up & subscribed capital/Value of Equity share.'
WHERE ResourceKey = 'rul_msg_15074'

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE mst_Resource
SET ResourceValue='Mandatory : Any one/all of - No of Equity shares/% of paid up & subscribed capital/Value of Equity share.',OriginalResourceValue='Mandatory : Any one/all of - No of Equity shares/% of paid up & subscribed capital/Value of Equity share.'
WHERE ResourceKey = 'rul_msg_15087'

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE mst_Resource
SET ResourceValue='Mandatory : Any one/all of - Transaction frequency-calendar or financial year/ No of Equity shares/% of paid up & subscribed capital/Value of Equity share.',OriginalResourceValue='Mandatory : Any one/all of - Transaction frequency-calendar or financial year/ No of Equity shares/% of paid up & subscribed capital/Value of Equity share.'
WHERE ResourceKey = 'rul_msg_15088'


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE mst_Resource
SET ResourceValue='No. of Equity Shares',OriginalResourceValue='No. of Equity Shares'
WHERE ResourceKey ='rul_lbl_15157'

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE mst_Resource
SET ResourceValue='System should consider ESOP Exercise(Cash and Cashless Partial Exercise) option first and then other Equity shares',OriginalResourceValue='System should consider ESOP Exercise(Cash and Cashless Partial Exercise) option first and then other Equity shares'
WHERE ResourceKey ='rul_lbl_15437'

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE mst_Resource
SET ResourceValue='Securities prior to acquisition, Percentage of Equity shares pre transaction & Percentage of Equity shares post transaction',OriginalResourceValue='Securities prior to acquisition, Percentage of Equity shares pre transaction & Percentage of Equity shares post transaction'
WHERE ResourceKey ='rul_lbl_15440'

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE mst_Resource
SET ResourceValue='Mandatory: Select value for Securities prior to acquisition, Percentage of Equity shares pre transaction & Percentage of Equity shares post transaction.',OriginalResourceValue='Mandatory: Select value for Securities prior to acquisition, Percentage of Equity shares pre transaction & Percentage of Equity shares post transaction.'
WHERE ResourceKey ='rul_msg_15443'

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE mst_Resource
SET ResourceValue='Percentage Of Equity Shares Pre Transaction field is required',OriginalResourceValue='Percentage Of Equity Shares Pre Transaction field is required'
WHERE ResourceKey = 'tra_msg_16122'

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE mst_Resource
SET ResourceValue='Percentage Of Equity Shares Post Transaction field is required',OriginalResourceValue='Percentage Of Equity Shares Post Transaction field is required'
WHERE ResourceKey = 'tra_msg_16123'

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE mst_Resource
SET ResourceValue='Enter valid percentage of Equity shares pre transaction',OriginalResourceValue='Enter valid percentage of Equity shares pre transaction'
WHERE ResourceKey = 'tra_msg_16137'

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE mst_Resource
SET ResourceValue='Enter valid percentage of Equity shares post transaction',OriginalResourceValue='Enter valid percentage of Equity shares post transaction'
WHERE ResourceKey = 'tra_msg_16138'

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE mst_Resource
SET ResourceValue='No of Equity Shares/Voting rights acquired',OriginalResourceValue='No of Equity Shares/Voting rights acquired'
WHERE ResourceKey in ('tra_grd_16194','tra_grd_16210','tra_grd_16226','tra_grd_16242','tra_grd_16258','tra_grd_16274','tra_grd_16337','tra_grd_16353','tra_grd_16369','tra_grd_16385','tra_grd_16401','tra_grd_16417')

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE mst_Resource
SET ResourceValue='% of Equity Shares/Voting rights acquired',OriginalResourceValue='% of Equity Shares/Voting rights acquired'
WHERE ResourceKey in('tra_grd_16195','tra_grd_16211','tra_grd_16227','tra_grd_16243','tra_grd_16259','tra_grd_16275','tra_grd_16339','tra_grd_16355','tra_grd_16371','tra_grd_16387','tra_grd_16403','tra_grd_16419')

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE mst_Resource
SET ResourceValue='Number of Equity shares or Units must be sum of ESOP Excercise Qty and Other than ESOP Excercise Qty.',OriginalResourceValue='Number of Equity shares or Units must be sum of ESOP Excercise Qty and Other than ESOP Excercise Qty.'
WHERE ResourceKey = 'tra_msg_16328'

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE mst_Resource
SET ResourceValue='I hereby certify that :- I do not have any access or have not unpublished price sensitive information up to the time of signing this letter. - The proposed Trade(s) do not violate the Securities and Exchange Board of India (Prohibition of Insider Trading) Regulation, 1992; - In case if, I have Access to or receive any unpublished price sensitive information after The signing of this letter, but before the execution of the transaction, I shall Inform the Compliance officer accordingly and would completely refrain From dealing in the Equity shares of the Company till the time such information becomes public . - I have not contravened the code of conduct for prevention of Insider Trading as notified by the Company from time to time. - The disclosure Made above is full and true disclosure.',OriginalResourceValue='I hereby certify that :- I do not have any access or have not unpublished price sensitive information up to the time of signing this letter. - The proposed Trade(s) do not violate the Securities and Exchange Board of India (Prohibition of Insider Trading) Regulation, 1992; - In case if, I have Access to or receive any unpublished price sensitive information after The signing of this letter, but before the execution of the transaction, I shall Inform the Compliance officer accordingly and would completely refrain From dealing in the Equity shares of the Company till the time such information becomes public . - I have not contravened the code of conduct for prevention of Insider Trading as notified by the Company from time to time. - The disclosure Made above is full and true disclosure.'
WHERE ResourceKey = 'dis_lbl_17088'

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE mst_Resource
SET ResourceValue='Date of allotment advice/ acquisition of shares/ sale of Equity shares specify',OriginalResourceValue='Date of allotment advice/ acquisition of shares/ sale of Equity shares specify'
WHERE ResourceKey = 'dis_grd_17200'

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE mst_Resource
SET ResourceValue='Date of allotment advice/ acquisition of Equity shares/ sale of Equity shares specify',OriginalResourceValue='Date of allotment advice/ acquisition of Equity shares/ sale of Equity shares specify'
WHERE ResourceKey = 'dis_grd_17222'

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE mst_Resource
SET ResourceValue='1. Under Depository Name: If you have a demat account, please select NSDL, CDSL. If you have physical Equity shares, select Others',OriginalResourceValue='1. In note we have mentioned: Under Depository Name, please enter NSDL, CDSL or others, but we have not provided option to update Depository name.'
WHERE ResourceKey = 'usr_lbl_50058'


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE mst_Resource
SET ResourceValue='4. If you have physical Equity shares, select ?Physical Equity Shares? under Depository Participant name and enter your folio number under Client ID (this will be auto populated under Depository Participant ID)',OriginalResourceValue='4. If you have physical Equity shares, select "Physical Equity Shares" under Depository Participant name and enter your folio number under Client ID (this will be auto populated under Depository Participant ID) '
WHERE ResourceKey = 'usr_lbl_50061'

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE mst_Resource
SET ResourceValue='Note: The number of Equity shares displayed under “Securities” is your balance of Equity shares as on 1st April, 2016. Please note that transactions post 1st April, 2016 can be viewed on the “Preclearances / Continuous Disclosures” webpage. Please update shareholding of your relatives as on 1st April, 2016 by clicking on "Add Equity Shares" link on this screen. The balance of Equity shares as on date can be viewed on your dashboard',OriginalResourceValue='Note: The number of Equity shares displayed under “Securities” is your balance of Equity shares as on 1st April, 2016. Please note that transactions post 1st April, 2016 can be viewed on the “Preclearances / Continuous Disclosures” webpage. Please update shareholding of your relatives as on 1st April, 2016 by clicking on "Add Equity Shares" link on this screen. The balance of Equity shares as on date can be viewed on your dashboard'
WHERE ResourceKey = 'tra_lbl_50062'

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE mst_Resource
SET ResourceValue='Enter valid percentage of Equity shares pre transaction',OriginalResourceValue='Enter valid percentage of Equity shares pre transaction'
WHERE ResourceKey = 'tra_msg_50519'

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/* INSERT VALUES INTO mst_Resource TABLE ---- START */
IF NOT EXISTS (SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50709)
BEGIN
	INSERT INTO mst_Resource (ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES(50709, 'dis_lbl_50709', 
	'Equity Shares', 
	'en-US', '103008', '104002', '122083', 
	'Equity Shares', 1, 
	GETDATE() )
END

IF NOT EXISTS (SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50710)
BEGIN
	INSERT INTO mst_Resource (ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES(50710, 'dis_lbl_50710', 
	'Preference Shares', 
	'en-US', '103008', '104002', '122083', 
	'Preference Shares', 1, 
	GETDATE() )
END

IF NOT EXISTS (SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50711)
BEGIN
	INSERT INTO mst_Resource (ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES(50711, 'dis_lbl_50711', 
	'Debentures', 
	'en-US', '103008', '104002', '122083', 
	'Debentures', 1, 
	GETDATE() )
END

IF NOT EXISTS (SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50712)
BEGIN
	INSERT INTO mst_Resource (ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES(50712, 'dis_lbl_50712', 
	'Futures', 
	'en-US', '103008', '104002', '122083', 
	'Futures', 1, 
	GETDATE() )
END

IF NOT EXISTS (SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50713)
BEGIN
	INSERT INTO mst_Resource (ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES(50713, 'dis_lbl_50713', 
	'Options', 
	'en-US', '103008', '104002', '122083', 
	'Options', 1, 
	GETDATE() )
END

/* INSERT VALUES INTO mst_Resource TABLE ---- END */

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--29-08-2018

UPDATE mst_Resource
SET ResourceValue='Paid Up & Subscribed Equity Share Capital',OriginalResourceValue='Paid Up & Subscribed Equity Share Capital'
WHERE ResourceKey = 'cmp_ttl_13089'

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE mst_Resource
SET ResourceValue='Error occurred while fetching list of Paid Up & Subscribed Equity Share Capital of the company.',OriginalResourceValue='Error occurred while fetching list of Paid Up & Subscribed Equity Share Capital of the company.'
WHERE ResourceKey = 'cmp_msg_13019'

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE mst_Resource
SET ResourceValue='Error occurred while deleting Paid Up & Subscribed Equity Share Capital of the company.',OriginalResourceValue='Error occurred while deleting Paid Up & Subscribed Equity Share Capital of the company.'
WHERE ResourceKey = 'cmp_msg_13055'

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE mst_Resource
SET ResourceValue='Cannot delete Paid Up & Subscribed Equity Share Capital details for a company, as some dependent information exists on it.',OriginalResourceValue='Cannot delete Paid Up & Subscribed Equity Share Capital details for a company, as some dependent information exists on it.'
WHERE ResourceKey = 'cmp_msg_13056'

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE mst_Resource
SET ResourceValue='Paid Up & Subscribed Equity Share Capital details for a company does not exist.',OriginalResourceValue='Paid Up & Subscribed Equity Share Capital details for a company does not exist.'
WHERE ResourceKey = 'cmp_msg_13057'

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE mst_Resource
SET ResourceValue='Error occurred while fetching Paid Up & Subscribed Equity Share Capital details of the company.',OriginalResourceValue='Error occurred while fetching Paid Up & Subscribed Equity Share Capital details of the company.'
WHERE ResourceKey = 'cmp_msg_13058'

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------

UPDATE mst_Resource
SET ResourceValue='Error occurred while saving Paid Up & Subscribed Equity Share Capital details of the company.',OriginalResourceValue='Error occurred while saving Paid Up & Subscribed Equity Share Capital details of the company.'
WHERE ResourceKey = 'cmp_msg_13059'

UPDATE mst_Resource
SET ResourceValue='Date of allotment advice/ acquisition of Equity shares/ sale of Equity shares specify',OriginalResourceValue='Date of allotment advice/ acquisition of Equity shares/ sale of Equity shares specify'
WHERE ResourceKey = 'dis_grd_17200'


