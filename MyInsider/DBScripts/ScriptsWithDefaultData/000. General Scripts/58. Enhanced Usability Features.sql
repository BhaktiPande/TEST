/*Script By Tushar Dated- 11 Oct 2017 */
/*Added the new resource message For search continuous disclosure records by PAN Number */
/*Updated By: Aniket Shingate- 17-Aug-2017*/
/*Adding the mst_Resource entries FOR displaying SMTP details required for Kotak, done at product level */
/*Updated By: Aniket Shingate/Vivek- 10 Jan 2018 */
/*Added Transaction type for Split in com_Code*/
/*Updated By: Aniket Shingate/Vivek- 12 Feb 2018 */
/*Added resource button for download department-wise RL */

/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50597)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50597,'dis_grd_50597','PAN','en-US',103009,104003,122057,'PAN',1,GETDATE())
END

/* INSERT INTO com_GridHeaderSetting*/
IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'dis_grd_50597')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114049,'dis_grd_50597',1,2,0,155001,NULL,NULL)
END

/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50598)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50598,'dis_lbl_50598','PAN','en-US',103009,104002,122057,'PAN',1,GETDATE())
END

IF EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 505796)
BEGIN
	DELETE FROM mst_Resource where ResourceId=505796
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50596)
BEGIN
	INSERT INTO mst_Resource(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES(50596,'pc_msg_50596','Expiry reminder can not be greater than password validity','en-US','103302','104001','122096','Expiry reminder can not be greater than password validity',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50599)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50599,'com_btn_50599','Upload Hardcopy','en-US',103003,104004,122034,'Upload Hardcopy',1,GETDATE())
END

/* INSERT INTO mst_Resource for displaying SMTP details, Kotak enhancement, done at product level*/
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50612)
BEGIN
	INSERT INTO mst_Resource VALUES (50612,'dis_lbl_50612','Smtp Server Name','en-US',103009,104002,122051,'Smtp Server Name',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50613)
BEGIN
	INSERT INTO mst_Resource VALUES (50613,'dis_lbl_50613','Smtp Port Number','en-US',103009,104002,122051,'Smtp Port Number',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50614)
BEGIN
	INSERT INTO mst_Resource VALUES (50614,'dis_lbl_50614','Smtp User Name','en-US',103009,104002,122051,'Smtp User Name',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50615)
BEGIN
	INSERT INTO mst_Resource VALUES (50615,'dis_lbl_50615','Smtp Password','en-US',103009,104002,122051,'Smtp Password',1,GETDATE())
END

/* ADDED BY PRIYANKA- View the history of companies*/
/* UPDATE RECORD-DELETE BUTTON TO HISTORY BUTTON OF RESTRICTED LIST FUNCTIONALITY*/
IF EXISTS (SELECT ActivityID FROM  usr_ActivityURLMapping WHERE ActivityID = 200 AND ControllerName = 'RestrictedList' AND ActionName = 'DeleteFromGrid')
BEGIN 
	UPDATE usr_ActivityURLMapping SET ActionName='History' WHERE ActivityID=200
END

IF EXISTS (SELECT GridTypeCodeId FROM  com_GridHeaderSetting WHERE GridTypeCodeId = 114079 AND ResourceKey = 'usr_grd_11073')
BEGIN
	UPDATE com_GridHeaderSetting SET ColumnWidth=13 WHERE GridTypeCodeId = 114079 AND ResourceKey = 'usr_grd_11073'
END

/* FOR RESTRICTED LIST COMPANY STATUS*/
IF NOT EXISTS(SELECT CodeGroupID FROM com_CodeGroup WHERE CodeGroupID = 511)
BEGIN
    INSERT INTO com_CodeGroup(CodeGroupID, ParentCodeGroupId, COdeGroupName, Description, IsVisible, IsEditable)
    VALUES(511, null, 'Restricted List Status', 'Restricted List Status', 1, 0)
END

IF NOT EXISTS(SELECT CodeID FROM com_Code WHERE CodeID = 511001)
BEGIN
    INSERT INTO com_Code(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
    VALUES(511001, NULL, 'Active', null, 511, 'Restricted List Status - Active', 1, 1, GETDATE(), 1)
END

IF NOT EXISTS(SELECT CodeID FROM com_Code WHERE CodeID = 511002)
BEGIN
    INSERT INTO com_Code(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
    VALUES(511002, NULL, 'Inactive', null, 511, 'Restricted List Status - Inactive', 1, 1, GETDATE(), 1)
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50607)
BEGIN
	INSERT INTO mst_Resource(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES(50607,'rl_lbl_50607','Restricted List Status','en-US','103013','104002','122076','Restricted List Status',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50616)
BEGIN
	INSERT INTO mst_Resource(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES(50616,'rl_ttl_50616','Restricted List History','en-US','103013','104006','122076','Restricted List History',1,GETDATE())
END

-- For Employee/Insider Page Notes
/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50621)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50621,'usr_lbl_50621','All employees of the Bank.','en-US',103002,104002,122003,'All employees of the Bank.',1,GETDATE())
END

/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50622)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50622,'usr_lbl_50622','Promoters','en-US',103002,104002,122003,'Promoters',1,GETDATE())
END

/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50623)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50623,'usr_lbl_50623','Whole Time Directors and Key Managerial Personnel and those employees of the Subsidiary Companies of the Bank, who are granted stock options by the Bank.','en-US',103002,104002,122003,'Whole Time Directors and Key Managerial Personnel and those employees of the Subsidiary Companies of the Bank, who are granted stock options by the Bank.',1,GETDATE())
END

-----Search by Employee Status Wise-------

IF NOT EXISTS(SELECT CodeGroupID FROM com_CodeGroup WHERE CodeGroupID = 510)
BEGIN
    INSERT INTO com_CodeGroup(CodeGroupID, ParentCodeGroupId, COdeGroupName, Description, IsVisible, IsEditable)
    VALUES(510, null, 'Employee Status', 'Employee Status', 1, 0)
END


IF NOT EXISTS(SELECT CodeID FROM com_Code WHERE CodeID = 510001)
BEGIN
    INSERT INTO com_Code(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
    VALUES(510001, NULL, 'Live', null, 510, 'Employee Status - Live', 1, 1, GETDATE(), 1)
END

IF NOT EXISTS(SELECT CodeID FROM com_Code WHERE CodeID = 510002)
BEGIN
    INSERT INTO com_Code(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
    VALUES(510002, NULL, 'Separated', null, 510, 'Employee Status - Separated', 1, 1, GETDATE(), 2)
END

IF NOT EXISTS(SELECT CodeID FROM com_Code WHERE CodeID = 510003)
BEGIN
    INSERT INTO com_Code(CodeID, ParentCodeId, CodeName, DisplayCode, CodeGroupId, Description, IsVisible, ModifiedBy, ModifiedOn, DisplayOrder)
    VALUES(510003, NULL, 'Inactive', null, 510, 'Employee Status - Inactive', 1, 1, GETDATE(), 3)
END

/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50605)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50605,'dis_grd_50605','Employee Status','en-US',103009,104003,122057,'Employee Status',1,GETDATE())
END

/* INSERT INTO com_GridHeaderSetting*/
IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'dis_grd_50605')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114049,'dis_grd_50605',1,3,0,155001,NULL,NULL)
END

/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50606)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50606,'dis_lbl_50606','Employee Status','en-US',103009,104002,122057,'Employee Status',1,GETDATE())
END

-- For Initial Disclosure 
/* INSERT INTO com_GridHeaderSetting*/
IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'dis_grd_50608')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114048,'dis_grd_50608',1,3,0,155001,NULL,NULL)
END

/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50608)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50608,'dis_grd_50608','Employee Status','en-US',103009,104003,122056,'Employee Status',1,GETDATE())
END

/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50609)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50609,'dis_lbl_50609','Employee Status','en-US',103009,104002,122056,'Employee Status',1,GETDATE())
END

/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50610)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50610,'dis_grd_50610','PAN','en-US',103009,104003,122056,'PAN',1,GETDATE())
END

/* INSERT INTO com_GridHeaderSetting*/
IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'dis_grd_50610')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114048,'dis_grd_50610',1,2,0,155001,NULL,NULL)
END

/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50611)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50611,'dis_lbl_50611','PAN','en-US',103009,104002,122056,'PAN',1,GETDATE())
END

-- For Period End Disclosures  
/* INSERT INTO com_GridHeaderSetting*/
IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'dis_grd_50617')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114045,'dis_grd_50617',1,3,0,155001,NULL,NULL)
END

/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50617)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50617,'dis_grd_50617','Employee Status','en-US',103009,104003,122055,'Employee Status',1,GETDATE())
END

/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50618)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50618,'dis_lbl_50618','Employee Status','en-US',103009,104002,122055,'Employee Status',1,GETDATE())
END

/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50619)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50619,'dis_grd_50619','PAN','en-US',103009,104003,122055,'PAN',1,GETDATE())
END

/* INSERT INTO com_GridHeaderSetting*/
IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'dis_grd_50619')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114045,'dis_grd_50619',1,2,0,155001,NULL,NULL)
END

/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50620)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50620,'dis_lbl_50620','PAN','en-US',103009,104002,122055,'PAN',1,GETDATE())
END


IF NOT EXISTS(SELECT SYSTAB.NAME FROM SYS.TABLES SYSTAB INNER JOIN SYS.COLUMNS SYSCOL ON SYSTAB.OBJECT_ID = SYSCOL.OBJECT_ID 
WHERE SYSTAB.NAME = 'rl_RistrictedMasterList' AND SYSCOL.NAME = 'RlMasterVersionNumber')
BEGIN
	ALTER TABLE [dbo].[rl_RistrictedMasterList] ADD  [RlMasterVersionNumber][INT] NULL
END

-- For Employee Details Excel Buttons

/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50624)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50624,'usr_btn_50624','Download Employee Details','en-US',103002,104004,122003,'Download Employee Details',1,GETDATE())
END

/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50625)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50625,'usr_btn_50625','Download Employee Dematwise Holdings','en-US',103002,104004,122003,'Download Employee Dematwise Holdings',1,GETDATE())
END

/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50626)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50626,'pc_msg_50626','Password validity cannot be zero','en-US',103302,104001,122096,'Password validity cannot be zero',1,GETDATE())
END

--Added Transaction type Split
IF EXISTS(SELECT 1 FROM COM_CODE WHERE CodeID = 143009 AND CodeName = 'Split')
BEGIN
	DELETE FROM rul_TradingPolicyForTransactionMode WHERE TransactionModeCodeId = 143009
	DELETE FROM COM_CODE WHERE CodeID = 143009 AND CodeName = 'Split'
END
IF NOT EXISTS(SELECT 1 FROM COM_CODE WHERE CodeName = 'Split' AND Description = 'Mode Of Acquisition - Split')
BEGIN
	INSERT INTO COM_CODE VALUES ((SELECT MAX(CodeID) + 1 FROM com_Code WHERE CodeGroupID = 149), 'Split', 149, 'Mode Of Acquisition - Split', 1, 1, 9, NULL, NULL, 1, GETDATE())
END

/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50627)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50627,'rl_msg_50627','Restricted list limited search field can not be Zero(0).It should be anything between 1 to 99','en-US',103301,104001,122091,'Restricted list limited search field can not be Zero(0).It should be anything between 1 to 99',1,GETDATE())
END

/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50630)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50630,'usr_btn_50630','Download Departmentwise Restricted List','en-US',103301, 104004, 122076, 'Download Departmentwise RL',1, GETDATE())	
END

/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50635)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50635,'rul_msg_50635','Applicable From Date cannot be less than Today''s Date','en-US',103006, 104001, 122038, 'Applicable From Date cannot be less than Today''s Date',1, GETDATE())	
END

/*Added by Priyanka*/
/*Added alert message to avoid duplicate entry*/
/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50628)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50628,'tra_msg_50628','$1 transaction for $2 on $3 with $4 $5 quantity and $6 value through $7 on $8 stock exchange traded against Demat account number:$9, DP Name:#1 and DP ID:#2, TM ID:#3',
	'en-US',103008,104001,122066,'$1 transaction for $2 on $3 with $4 $5 quantity and $6 value through $7 on $8 stock exchange traded against Demat account number:$9, DP Name:#1 and DP ID:#2, TM ID:#3',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50629)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50629,'tra_btn_50629','NO, View the transaction already $1/$2 in the system','en-US',103008,104004,122066,'NO, View the transaction already $1/$2 in the system',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50631)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50631,'tra_msg_50631','Saved','en-US',103008,104001,122066,'Saved',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50632)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50632,'tra_msg_50632','Submitted','en-US',103008,104001,122066,'Submitted',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50633)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50633,'tra_msg_50633','This is potentially duplicate entry.','en-US',103008,104001,122066,'This is potentially duplicate entry.',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50634)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50634,'tra_msg_50634','The entry you are trying to $1 is already available in the system. Below are the transations already Saved/Submitted in the system.','en-US',103008,104001,122066,'The entry you are trying to $1 is already available in the system. Below are the transations already Saved/Submitted in the system.',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50636)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50636,'tra_msg_50636','$1 this data will create a duplicate entry in the system. Do you really want to $2 this data?','en-US',103008,104001,122066, '$1 this data will create a duplicate entry in the system. Do you really want to $2 this data?',1, GETDATE())	
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50637)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50637,'tra_msg_50637','Saving','en-US',103008,104001,122066, 'Saving',1, GETDATE())	
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50638)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50638,'tra_msg_50638','Submitting','en-US',103008,104001,122066, 'Submitting',1, GETDATE())	
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50639)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50639,'tra_msg_50639','Save','en-US',103008,104001,122066, 'Save',1, GETDATE())	
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50640)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50640,'tra_msg_50640','Submit','en-US',103008,104001,122066, 'Submit',1, GETDATE())	
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50641)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50641,'tra_msg_50641','There is/are potentially duplicate entry/entries in the system','en-US',103008,104001,122066, 'There is/are potentially duplicate entry/entries in the system',1, GETDATE())	
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50642)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50642,'tra_btn_50642','View the duplicate transaction','en-US',103008,104004,122066, 'View the duplicate transaction',1, GETDATE())	
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50643)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50643,'tra_btn_50643','Close','en-US',103008,104004,122066, 'Close',1, GETDATE())	
END

/*Script By Harish Dated- 15 March 2018 */
/*Added the new column (UserCount) in rul_ApplicabilityMaster Table and removing the procedure st_rul_ApplicabilityNoOfUserCount*/
IF NOT EXISTS(SELECT NAME FROM SYS.COLUMNS WHERE NAME = 'UserCount' AND OBJECT_ID = OBJECT_ID('[dbo].[rul_ApplicabilityMaster]'))
BEGIN
ALTER TABLE dbo.rul_ApplicabilityMaster ADD
	UserCount int NOT NULL CONSTRAINT DF_rul_ApplicabilityMaster_UserCount DEFAULT 0
END
--IF EXISTS (SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_rul_ApplicabilityNoOfUserCount')
--DROP PROCEDURE [dbo].[st_rul_ApplicabilityNoOfUserCount]

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50644)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50644,'tra_lbl_50644','NSE','en-US',103008,104002,122066, 'NSE',1, GETDATE())	
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50645)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50645,'tra_lbl_50645','BSE','en-US',103008,104002,122066, 'BSE',1, GETDATE())	
END


-- Added new column as 'Individual Traded Value' in preclerance and continuous disclosure grid for user and co/admin.
/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50646)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50646,'dis_grd_50646','Individual Traded Value','en-US',103009,104003,122057,'Individual Traded Value',1,GETDATE())
END

/* INSERT INTO com_GridHeaderSetting*/
IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'dis_grd_50646')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114049,'dis_grd_50646',1,9,0,155001,NULL,NULL)
END


/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50647)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50647,'dis_grd_50647','Individual Traded Value','en-US',103009,104003,122046,'Individual Traded Value',1,GETDATE())
END

/* INSERT INTO com_GridHeaderSetting*/
IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'dis_grd_50647')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES (114038,'dis_grd_50647',1,8,0,155001,NULL,NULL)
END


/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50648)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50648,'tra_btn_50648','Yes','en-US',103009,104003,122046,'Yes',1,GETDATE())
END
/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50649)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50649,'tra_btn_50649','No','en-US',103009,104003,122046,'No',1,GETDATE())
END
/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50650)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50650,'tra_msg_50650','You have an approved pre-clearance pending for transaction submission. Do you still want to submit your trade without pre-clearance?','en-US',103009,104003,122046,'You have an approved pre-clearance pending for transaction submission. Do you still want to submit your trade without pre-clearance?',1,GETDATE())
END

/* For Security Transfer Functionality */

IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 50651)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES
	(50651, 'usr_lbl_50651', 'ESOPs : ', 'en-US', 103002, 104002, 122092, 'ESOPs : ', 1, GETDATE())
END

IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 50652)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES
	(50652, 'usr_lbl_50652', 'Other than ESOPs : ', 'en-US', 103002, 104002, 122092, 'Other than ESOPs : ', 1, GETDATE())
END

IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 50653)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES
	(50653, 'usr_lbl_50653', 'ESOPs', 'en-US', 103002, 104002, 122092, 'ESOPs', 1, GETDATE())
END


/* Update msg for Security Transfer Functionality */

IF EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 11460)
BEGIN
	UPDATE mst_Resource SET ResourceValue = 'ESOP quantity & Other than ESOP quantity can not be less than or equal to 0 & both can not be blank.',
	OriginalResourceValue = 'Enter transfer quantity is greater than zero.'
	WHERE ResourceId = 11460
END

/* Update button name for period end ease out flow */
IF EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 17059)
BEGIN
	UPDATE mst_Resource SET ResourceValue = 'Add Missing Transaction',
	OriginalResourceValue = 'Add Missing Transaction'
	WHERE ResourceId = 17059
END

IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 50654)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES
	(50654, 'dis_btn_50654', 'Confirm', 'en-US', 103009, 104004, 122001, 'Confirm', 1, GETDATE())
END

/* INSERT INTO com_GridHeaderSetting*/
IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'usr_grd_11073' AND GridTypeCodeId=114039)
BEGIN	
	INSERT INTO com_GridHeaderSetting(GridTypeCodeId,ResourceKey,IsVisible,SequenceNumber,ColumnWidth,ColumnAlignment,OverrideGridTypeCodeId,OverrideResourceKey)
	VALUES(114039,'usr_grd_11073',1,9,0,155001,null,null)
END

/* Add msg for axis bank while doing transaction */
IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 50655)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES
	(50655, 'dis_lbl_50655', 'Please note that you are only allowed to trade from AXIS DIRECT or EDELWEISS Demat account', 'en-US', 103009, 104002, 122051, 'Please note that you are only allowed to trade from AXIS DIRECT or EDELWEISS Demat account', 1, GETDATE())
END

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'TotalTradeValue' AND OBJECT_ID = OBJECT_ID(N'[tra_TransactionMaster]'))
BEGIN
	ALTER TABLE [dbo].[tra_TransactionMaster] ADD  [TotalTradeValue] decimal(10,0) null 
END 

/* Add msg for axis bank while doing transaction */
IF NOT EXISTS(select ResourceId from mst_Resource where ResourceId = 50736)
BEGIN
	INSERT INTO mst_Resource
	(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES
	(50736, 'dis_lbl_50736', 'The data on this page will be processed after every 1 minute. Please refresh the page to view the updated data', 'en-US', 103009, 104002, 122057, 'The data on this page will be processed after every 1 minute. Please refresh the page to view the updated data', 1, GETDATE())
END

