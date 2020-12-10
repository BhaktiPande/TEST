
IF NOT EXISTS(SELECT codeid FROM com_code WHERE codeid = 103306)
BEGIN
	INSERT INTO com_code([CodeID],[CodeName],[CodeGroupId],[Description],[IsVisible],[IsActive],[DisplayOrder],[DisplayCode],[ParentCodeId],[ModifiedBy],[ModifiedOn])
	VALUES ( 103306,	'MCQ',103,'MCQ',1,1,1,NULL,	NULL,1,	getdate())
END
IF NOT EXISTS(SELECT MenuID FROM mst_MenuMaster WHERE  UPPER(MenuName) ='MCQ Settings' and ParentMenuID =10) 
BEGIN
INSERT INTO mst_MenuMaster (MenuID,MenuName,[Description],MenuURL,DisplayOrder,ParentMenuID,StatusCodeID,ImageURL,ToolTipText,ActivityID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
VALUES
(66 ,'MCQ Settings','MCQ Settings','/MCQSetting/MCQSettings',2302,10,102001,NULL,NULL,327,1,GETDATE(),1,GETDATE()) 
END

IF NOT EXISTS(SELECT codeid FROM com_code WHERE codeid = 122109)
BEGIN
	INSERT INTO com_code([CodeID],[CodeName],[CodeGroupId],[Description],[IsVisible],[IsActive],[DisplayOrder],[DisplayCode],[ParentCodeId],[ModifiedBy],[ModifiedOn])
	VALUES ( 122109,	'MCQ Settings',122,'MCQ Settings',1,1,1,NULL,	NULL,1,	getdate())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54071)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54071,'usr_lbl_54071','MCQ Setting','en-US',103306,104002, 122109,'MCQ Setting',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54072)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54072,'usr_lbl_54072','Display MCQs at first time login','en-US',103306,104002, 122109,'Display MCQs at first time login',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54073)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54073,'usr_lbl_54073','Display MCQs at first time login','en-US',103306,104002, 122109,'Display MCQs at first time login',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54074)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54074,'usr_lbl_54074','Frequency of MCQs to be displayed','en-US',103306,104002, 122109,'Frequency of MCQs to be displayed',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54075)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54075,'usr_btn_54075','Scheduled','en-US',103306,104004, 122109,'Scheduled',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54076)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54076,'usr_btn_54076','Select Date','en-US',103306,104004, 122109,'Select Date',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54077)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54077,'usr_lbl_54077','Duration','en-US',103306,104002, 122109,'Duration',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54078)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54078,'usr_lbl_54078','days after set frequency','en-US',103306,104002, 122109,'days after set frequency',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54079)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54079,'usr_lbl_54079','Block the user after set duration','en-US',103306,104002, 122109,'Block the user after set duration',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54080)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54080,'usr_lbl_54080','No of questions to be displayed randomly','en-US',103306,104002, 122109,'No of questions to be displayed randomly',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54081)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54081,'usr_lbl_54081','Allow application access only if','en-US',103306,104002, 122109,'Allow application access only if',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54082)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54082,'usr_lbl_54082','questions are answered correctly.','en-US',103306,104002, 122109,'questions are answered correctly.',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54083)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54083,'usr_lbl_54083','Number of atempts to answer the MCQs','en-US',103306,104002, 122109,'Number of atempts to answer the MCQs',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54084)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54084,'usr_lbl_54084','Block the user after number of attempts exceeded','en-US',103306,104002, 122109,'Block the user after number of attempts exceeded',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54085)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54085,'usr_lbl_54085','Unblock the user for next frequency','en-US',103306,104002, 122109,'Unblock the user for next frequency',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54086)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54086,'com_lbl_54086','Yes','en-US',103306,104002, 122109,'Yes',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54087)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54087,'com_lbl_54087','No','en-US',103306,104002, 122109,'No',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54088)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54088,'usr_btn_54088','Save','en-US',103306,104004, 122109,'Save',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54089)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54089,'usr_btn_54089','Back','en-US',103306,104004, 122109,'Back',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54090)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54090,'usr_btn_54090','SET/VIEW QUESTIONS','en-US',103306,104004, 122109,'SET/VIEW QUESTIONS',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54091)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54091,'usr_btn_54091','Add New Question','en-US',103306,104004, 122109,'Add New Question',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54092)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54092,'usr_btn_54092','Back','en-US',103306,104004, 122109,'Back',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54093)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54093,'usr_msg_54093','Error occurred while saving MCQ Settings.','en-US',103306,104001, 122109,'Error occurred while saving MCQ Settings',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54094)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54094,'usr_msg_54094','MCQ settings details saved successfully.','en-US',103306,104001, 122109,'MCQ settings details saved successfully.',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54095)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54095,'com_lbl_54095','MCQ','en-US',103306,104002, 122109,'MCQ',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54096)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54096,'usr_lbl_54096','Question','en-US',103306,104002, 122109,'Question',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54097)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54097,'usr_lbl_54097','Answer Type','en-US',103306,104002, 122109,'Answer Type',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54098)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54098,'usr_lbl_54098','Option number','en-US',103306,104002, 122109,'Option number',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54099)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54099,'usr_lbl_54099','Correct answer','en-US',103306,104002, 122109,'Correct answer',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54100)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54100,'usr_lbl_54100','Options','en-US',103306,104002, 122109,'Options',1,GETDATE())
END

IF NOT EXISTS(SELECT codeid FROM com_code WHERE codeid = 114124) --grid type for mcq
BEGIN
	INSERT INTO com_code([CodeID],[CodeName],[CodeGroupId],[Description],[IsVisible],[IsActive],[DisplayOrder],[DisplayCode],[ParentCodeId],[ModifiedBy],[ModifiedOn])
	VALUES ( 114124,	'MCQ Questions List',114,'MCQ Questions List',1,1,121,NULL,	NULL,1,	getdate())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54101)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54101,'usr_grd_54101','Question','en-US',103306,104003, 122109,'Question',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54102)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54102,'usr_grd_54102','Type','en-US',103306,104003, 122109,'Type',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54103)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54103,'usr_grd_54103','Options','en-US',103306,104003, 122109,'Options',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54104)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54104,'usr_grd_54104','Correct Answer','en-US',103306,104003, 122109,'Correct Answer',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54105)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54105,'usr_msg_54105','Record deleted successfully','en-US',103306,104001, 122109,'Record deleted successfully',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54106)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54106,'usr_msg_54106','MCQ question saved successfully','en-US',103306,104001, 122109,'MCQ question saved successfully',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54107)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54107,'usr_btn_54107','Save And Add New Question','en-US',103306,104004, 122109,'Save And Add New Question',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54108)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54108,'usr_lbl_54108','User Block/Unblock','en-US',103306,104002, 122109,'User Block/Unblock',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54109)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54109,'usr_lbl_54109','Status','en-US',103306,104002, 122109,'Status',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54110)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54110,'usr_lbl_54110','Reason','en-US',103306,104002, 122109,'Reason',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54111)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54111,'usr_btn_54111','Save','en-US',103306,104004, 122109,'Save',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54112)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54112,'usr_btn_54112','Cancel','en-US',103306,104004, 122109,'Cancel',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54113)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54113,'usr_lbl_54113','Block','en-US',103306,104002, 122109,'Block',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54114)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54114,'usr_lbl_54114','Unblock','en-US',103306,104002, 122109,'Unblock',1,GETDATE())
END
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114124 and ResourceKey='usr_grd_54101')
begin
insert into com_GridHeaderSetting ([GridTypeCodeId],	[ResourceKey],	[IsVisible],	[SequenceNumber],	[ColumnWidth]	,[ColumnAlignment],	[OverrideGridTypeCodeId]	,[OverrideResourceKey])
values (114124,	'usr_grd_54101',	1,	1,	0,	155001,	NULL,NULL)
end
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114124 and ResourceKey='usr_grd_54102')
begin
insert into com_GridHeaderSetting ([GridTypeCodeId],	[ResourceKey],	[IsVisible],	[SequenceNumber],	[ColumnWidth]	,[ColumnAlignment],	[OverrideGridTypeCodeId]	,[OverrideResourceKey])
values (114124,	'usr_grd_54102',	1,	2,	0,	155001,	NULL,NULL)
end
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114124 and ResourceKey='usr_grd_54103')
begin
insert into com_GridHeaderSetting ([GridTypeCodeId],	[ResourceKey],	[IsVisible],	[SequenceNumber],	[ColumnWidth]	,[ColumnAlignment],	[OverrideGridTypeCodeId]	,[OverrideResourceKey])
values (114124,	'usr_grd_54103',	1,	3,	0,	155001,	NULL,NULL)
end
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114124 and ResourceKey='usr_grd_54104')
begin
insert into com_GridHeaderSetting ([GridTypeCodeId],	[ResourceKey],	[IsVisible],	[SequenceNumber],	[ColumnWidth]	,[ColumnAlignment],	[OverrideGridTypeCodeId]	,[OverrideResourceKey])
values (114124,	'usr_grd_54104',	1,	4,	0,	155001,	NULL,NULL)
end
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114124 and ResourceKey='usr_grd_11073')
begin
insert into com_GridHeaderSetting ([GridTypeCodeId],	[ResourceKey],	[IsVisible],	[SequenceNumber],	[ColumnWidth]	,[ColumnAlignment],	[OverrideGridTypeCodeId]	,[OverrideResourceKey])
values (114124,	'usr_grd_11073',	1,	5,	0,	155001,	NULL,NULL)
end


IF NOT EXISTS(
SELECT cm.COLUMN_NAME FROM INFORMATION_SCHEMA.TABLES  as tb inner join INFORMATION_SCHEMA.COLUMNS as cm  on tb.TABLE_NAME=cm.TABLE_NAME
  		     WHERE
  			 tb.TABLE_NAME = 'usr_UserInfo' and COLUMN_NAME in( 'IsBlocked'))
 BEGIN  			 
	  ALTER TABLE [usr_UserInfo]
	  ADD IsBlocked bit 
	ALTER TABLE usr_UserInfo ADD CONSTRAINT DF_usr_UserInfo_IsBlocked DEFAULT 0 FOR IsBlocked;	
 END
 IF NOT EXISTS(
SELECT cm.COLUMN_NAME FROM INFORMATION_SCHEMA.TABLES  as tb inner join INFORMATION_SCHEMA.COLUMNS as cm  on tb.TABLE_NAME=cm.TABLE_NAME
  		     WHERE
  			 tb.TABLE_NAME = 'usr_UserInfo' and COLUMN_NAME in( 'Blocked_UnBlock_Reason'))
 BEGIN  			 
	  ALTER TABLE [usr_UserInfo]
	  ADD Blocked_UnBlock_Reason varchar(max) null
 END


IF NOT EXISTS(SELECT codegroupid FROM com_CodeGroup WHERE codegroupid = 521)
BEGIN
	INSERT INTO com_CodeGroup([CodeGroupID],[COdeGroupName],[Description],[IsVisible],[IsEditable],[ParentCodeGroupId])
	VALUES ( 521,'MCQ','MCQ',1,1,NULL)
END

IF NOT EXISTS(SELECT codeid FROM com_code WHERE codeid = 521001)
BEGIN
	INSERT INTO com_code([CodeID],[CodeName],[CodeGroupId],[Description],[IsVisible],[IsActive],[DisplayOrder],[DisplayCode],[ParentCodeId],[ModifiedBy],[ModifiedOn])
	VALUES ( 521001,	'MCQ Required',521,'MCQ Required',1,1,1,NULL,	NULL,1,	getdate())
END
IF NOT EXISTS(SELECT codeid FROM com_code WHERE codeid = 521002)
BEGIN
	INSERT INTO com_code([CodeID],[CodeName],[CodeGroupId],[Description],[IsVisible],[IsActive],[DisplayOrder],[DisplayCode],[ParentCodeId],[ModifiedBy],[ModifiedOn])
	VALUES ( 521002,	'MCQ Not Required',521,'MCQ Not Required',1,1,1,NULL,	NULL,1,	getdate())
END

 IF NOT EXISTS(
SELECT cm.COLUMN_NAME FROM INFORMATION_SCHEMA.TABLES  as tb inner join INFORMATION_SCHEMA.COLUMNS as cm  on tb.TABLE_NAME=cm.TABLE_NAME
  		     WHERE
  			 tb.TABLE_NAME = 'mst_company' and COLUMN_NAME in( 'IsMCQRequired'))
 BEGIN  			 
	  ALTER TABLE [mst_company]
	  ADD IsMCQRequired int 
 END
 
 IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54115)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54115,'usr_btn_54115','Submit','en-US',103306,104004, 122109,'Submit',1,GETDATE())
END


IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54116)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54116,'usr_msg_54116','You have $1 attempts to answer these questions correctly.','en-US',103306,104001, 122109,'You have $1 attempts to answer these questions correctly.',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54117)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54117,'usr_msg_54117','You have $1 attempt(s) left  to answer the questions.','en-US',103306,104001, 122109,'You have $1 attempt(s) left  to answer the questions.',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54118)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54118,'usr_msg_54118','Congratulations!! You have answered all the questions correctly!  Click to proceed to the dashboard.','en-US',103306,104001, 122109,'Congratulations!! You have answered all the questions correctly!  Click to proceed to the dashboard.',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54119)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54119,'usr_msg_54119','Give it a try by clicking on "Try Again"','en-US',103306,104001, 122109,'Give it a try by clicking on "Try Again"',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54120)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54120,'usr_msg_54120','Oops!! Your account has been blocked. Please contact the Compliance Officer (give name/ email id) to unblock your account.','en-US',103306,104001, 122109,'Oops!! Your account has been blocked. Please contact the Compliance Officer (give name/ email id) to unblock your account.',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54121)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54121,'usr_msg_54121','Test submitted successfully.','en-US',103306,104001, 122109,'Test submitted successfully.',1,GETDATE())
END
 IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54122)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54122,'usr_btn_54122','Try Again','en-US',103306,104004, 122109,'Try Again',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54123)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54123,'usr_msg_54123','Opps!! MCQ date expired. You are not allowed to access the application.Your account has been blocked. Please contact administrator.','en-US',103306,104001, 122109,'Opps!! MCQ date expired. You are not allowed to access the application.Your account has been blocked. Please contact administrator.',1,GETDATE())
END

--INSERT SCRIPT FOR usr_Activity	
 DECLARE @ActivityID BIGINT		
BEGIN
	IF NOT EXISTS (SELECT ActivityID FROM usr_Activity WHERE UPPER(ScreenName) ='MCQ Setting' and UPPER(ActivityName)='View')
	BEGIN
		SELECT @ActivityID = 327 from usr_Activity
		INSERT INTO usr_Activity(ActivityID,ScreenName,ActivityName,ModuleCodeID,ControlName,
				[Description],StatusCodeID,DisplayOrder,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(@ActivityID,'MCQ Setting','View','103306',NULL,'View right for MCQ Setting',105001,' ',1,GETDATE(),1,GETDATE())
		
--INSERT SCRIPT FOR USR_USERTYPEACTIVITY		
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101001')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101002')
	END
	IF NOT EXISTS (SELECT ActivityID FROM usr_Activity WHERE UPPER(ScreenName) ='MCQ Setting' and UPPER(ActivityName)='Create')
	BEGIN
		SELECT @ActivityID = 328 from usr_Activity
		INSERT INTO usr_Activity(ActivityID,ScreenName,ActivityName,ModuleCodeID,ControlName,
				[Description],StatusCodeID,DisplayOrder,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(@ActivityID,'MCQ Setting','Create','103306',NULL,'Create right for MCQ Setting',105001,' ',1,GETDATE(),1,GETDATE())
		
--INSERT SCRIPT FOR USR_USERTYPEACTIVITY		
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101001')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101002')
	END
	IF NOT EXISTS (SELECT ActivityID FROM usr_Activity WHERE UPPER(ScreenName) ='MCQ Setting' and UPPER(ActivityName)='Edit')
	BEGIN
		SELECT @ActivityID = 329 from usr_Activity
		INSERT INTO usr_Activity(ActivityID,ScreenName,ActivityName,ModuleCodeID,ControlName,
				[Description],StatusCodeID,DisplayOrder,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(@ActivityID,'MCQ Setting','Edit','103306',NULL,'Edit right for MCQ Setting',105001,' ',1,GETDATE(),1,GETDATE())
		
--INSERT SCRIPT FOR USR_USERTYPEACTIVITY		
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101001')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101002')
	END
	IF NOT EXISTS (SELECT ActivityID FROM usr_Activity WHERE UPPER(ScreenName) ='MCQ Setting' and UPPER(ActivityName)='Delete')
	BEGIN
		SELECT @ActivityID = 330 from usr_Activity
		INSERT INTO usr_Activity(ActivityID,ScreenName,ActivityName,ModuleCodeID,ControlName,
				[Description],StatusCodeID,DisplayOrder,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(@ActivityID,'MCQ Setting','Delete','103306',NULL,'Delete right for MCQ Setting',105001,' ',1,GETDATE(),1,GETDATE())
		
--INSERT SCRIPT FOR USR_USERTYPEACTIVITY		
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101001')
		INSERT INTO USR_USERTYPEACTIVITY (ACTIVITYID,USERTYPECODEID) VALUES (@ActivityID,'101002')
	END
END


create table #usr_Activity(ID int identity,RoleID int)
insert into #usr_Activity
select RoleID from usr_RoleMaster where roleid in(1,3)
Declare @nCount int =0
Declare @nTotCount int=0

select @nTotCount=COUNT(RoleID)  from #usr_Activity

while @nCount<@nTotCount
begin
declare @nRoleId int=0
select @nRoleId =RoleID from #usr_Activity where ID=@nCount+1


	IF NOT EXISTS (SELECT ActivityID FROM usr_RoleActivity WHERE ActivityID ='327' AND RoleID =@nRoleId)
	BEGIN
		INSERT INTO usr_RoleActivity(ActivityID,RoleID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(327,@nRoleId,1,GETDATE(),1,GETDATE())
		
	END
	
	IF NOT EXISTS (SELECT ActivityID FROM usr_RoleActivity WHERE ActivityID ='328' AND RoleID =@nRoleId)
	BEGIN
		INSERT INTO usr_RoleActivity(ActivityID,RoleID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(328,@nRoleId,1,GETDATE(),1,GETDATE())
		
	END
	IF NOT EXISTS (SELECT ActivityID FROM usr_RoleActivity WHERE ActivityID ='329' AND RoleID =@nRoleId)
	BEGIN
		INSERT INTO usr_RoleActivity(ActivityID,RoleID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(329,@nRoleId,1,GETDATE(),1,GETDATE())
	END
	IF NOT EXISTS (SELECT ActivityID FROM usr_RoleActivity WHERE ActivityID ='330' AND RoleID =@nRoleId)
	BEGIN
		
		INSERT INTO usr_RoleActivity(ActivityID,RoleID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
		VALUES(330,@nRoleId,1,GETDATE(),1,GETDATE())
	END
set @nCount=@nCount+1
END

drop table #usr_Activity


 IF NOT EXISTS(
SELECT cm.COLUMN_NAME FROM INFORMATION_SCHEMA.TABLES  as tb inner join INFORMATION_SCHEMA.COLUMNS as cm  on tb.TABLE_NAME=cm.TABLE_NAME
  		     WHERE
  			 tb.TABLE_NAME = 'usr_UserInfo' and COLUMN_NAME in( 'Blocked_Date'))
 BEGIN  			 
	  ALTER TABLE [usr_UserInfo]
	  ADD Blocked_Date DATETIME NULL
 END
 IF NOT EXISTS(
SELECT cm.COLUMN_NAME FROM INFORMATION_SCHEMA.TABLES  as tb inner join INFORMATION_SCHEMA.COLUMNS as cm  on tb.TABLE_NAME=cm.TABLE_NAME
  		     WHERE
  			 tb.TABLE_NAME = 'usr_UserInfo' and COLUMN_NAME in( 'UnBlocked_Date'))
 BEGIN  			 
	  ALTER TABLE [usr_UserInfo]
	  ADD  UnBlocked_Date DATETIME NULL
 END

  IF NOT EXISTS(
SELECT cm.COLUMN_NAME FROM INFORMATION_SCHEMA.TABLES  as tb inner join INFORMATION_SCHEMA.COLUMNS as cm  on tb.TABLE_NAME=cm.TABLE_NAME
  		     WHERE
  			 tb.TABLE_NAME = 'usr_UserInfo' and COLUMN_NAME in( 'FrequencyDateBYAdmin'))
 BEGIN  			 
	  ALTER TABLE [usr_UserInfo]
	  ADD  FrequencyDateBYAdmin DATETIME NULL
 END
   IF NOT EXISTS(
SELECT cm.COLUMN_NAME FROM INFORMATION_SCHEMA.TABLES  as tb inner join INFORMATION_SCHEMA.COLUMNS as cm  on tb.TABLE_NAME=cm.TABLE_NAME
  		     WHERE
  			 tb.TABLE_NAME = 'usr_UserInfo' and COLUMN_NAME in( 'ReasonForBlocking'))
 BEGIN  			 
	  ALTER TABLE [usr_UserInfo]
	  ADD  ReasonForBlocking VARCHAR(MAX) NULL
 END
 
 IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54124)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54124,'usr_msg_54124','Exceeded number of attempts/Not attempted in given time','en-US',103306,104001, 122109,'Exceeded number of attempts/Not attempted in given time',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54125)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54125,'usr_lbl_54125','Employee Id','en-US',103306,104002, 122109,'Employee Id',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54126)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54126,'usr_lbl_54126','Name','en-US',103306,104002, 122109,'Name',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54127)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54127,'usr_lbl_54127','Department','en-US',103306,104002, 122109,'Department',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54128)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54128,'usr_lbl_54128','Designation','en-US',103306,104002, 122109,'Designation',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54129)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54129,'usr_lbl_54129','MCQ Status','en-US',103306,104002, 122109,'MCQ Status',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54130)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54130,'usr_lbl_54130','From Date','en-US',103306,104002, 122109,'From Date',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54131)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54131,'usr_lbl_54131','To Date','en-US',103306,104002, 122109,'To Date',1,GETDATE())
END

 
 IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54132)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54132,'usr_btn_54132','Download','en-US',103306,104004, 122109,'Download',1,GETDATE())
END

 IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54133)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54133,'usr_btn_54133','Reset','en-US',103306,104004, 122109,'Reset',1,GETDATE())
END

 IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54134)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54134,'usr_btn_54134','Reset','en-US',103306,104004, 122109,'Reset',1,GETDATE())
END
 IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54135)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54135,'usr_btn_54135','Back','en-US',103306,104004, 122109,'Back',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54136)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54136,'usr_lbl_54136','MCQ Report','en-US',103306,104002, 122109,'MCQ Report',1,GETDATE())
END


IF NOT EXISTS(SELECT codegroupid FROM com_CodeGroup WHERE codegroupid = 522)
BEGIN
	INSERT INTO com_CodeGroup([CodeGroupID],[COdeGroupName],[Description],[IsVisible],[IsEditable],[ParentCodeGroupId])
	VALUES ( 522,'MCQ Status','MCQ Status of result',1,1,NULL)
END

IF NOT EXISTS(SELECT codeid FROM com_code WHERE codeid = 522001)
BEGIN
	INSERT INTO com_code([CodeID],[CodeName],[CodeGroupId],[Description],[IsVisible],[IsActive],[DisplayOrder],[DisplayCode],[ParentCodeId],[ModifiedBy],[ModifiedOn])
	VALUES ( 522001,	'Pending',522,'Pending',1,1,1,NULL,	NULL,1,	getdate())
END
IF NOT EXISTS(SELECT codeid FROM com_code WHERE codeid = 522002)
BEGIN
	INSERT INTO com_code([CodeID],[CodeName],[CodeGroupId],[Description],[IsVisible],[IsActive],[DisplayOrder],[DisplayCode],[ParentCodeId],[ModifiedBy],[ModifiedOn])
	VALUES ( 522002,	'Success',522,'Success',1,1,2,NULL,	NULL,1,	getdate())
END
IF NOT EXISTS(SELECT codeid FROM com_code WHERE codeid = 522003)
BEGIN
	INSERT INTO com_code([CodeID],[CodeName],[CodeGroupId],[Description],[IsVisible],[IsActive],[DisplayOrder],[DisplayCode],[ParentCodeId],[ModifiedBy],[ModifiedOn])
	VALUES ( 522003,	'Failed',522,'Failed',1,1,3,NULL,	NULL,1,	getdate())
END
IF NOT EXISTS(SELECT MenuID FROM mst_MenuMaster WHERE  UPPER(MenuName) ='MCQ Report' and ParentMenuID =36) 
BEGIN
INSERT INTO mst_MenuMaster (MenuID,MenuName,[Description],MenuURL,DisplayOrder,ParentMenuID,StatusCodeID,ImageURL,ToolTipText,ActivityID,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
VALUES
(67 ,'MCQ Report','MCQ Report','/MCQReport/MCQ_Report',3509,36,102001,NULL,NULL,327,1,GETDATE(),1,GETDATE())--activity id 11 need to change
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54137)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54137,'usr_msg_54137','Value can not be blank.','en-US',103306,104001, 122109,'Value can not be blank.',1,GETDATE())
END


IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54138)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54138,'usr_msg_54138','Please attempt at least one question.','en-US',103306,104001, 122109,'Please attempt at least one question.',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54139)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54139,'usr_msg_54139','Error occured while saving question details','en-US',103306,104001, 122109,'Error occured while saving question details',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54140)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54140,'usr_msg_54140','Error occurred while fetching list of questions details','en-US',103306,104001, 122109,'Error occurred while fetching list of questions details',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54141)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54141,'usr_msg_54141','Error occured while updatting user','en-US',103306,104001, 122109,'Error occured while updatting user',1,GETDATE())
END

IF not exists(SELECT object_id FROM sys.indexes  WHERE name='IX_MCQ_usr_UserInfo_UserTypeCodeId' AND object_id = OBJECT_ID('dbo.usr_UserInfo'))
BEGIN
CREATE NONCLUSTERED INDEX IX_MCQ_usr_UserInfo_UserTypeCodeId
ON [dbo].[usr_UserInfo] ([UserTypeCodeId])
INCLUDE ([UserInfoId])
end
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54142)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54142,'usr_msg_54142','The Select Date checkbox is required.','en-US',103306,104001, 122109,'The Select Date checkbox is required.',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54143)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54143,'usr_msg_54143','The Scheduled checkbox is required.','en-US',103306,104001, 122109,'The Scheduled checkbox is required.',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54144)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54144,'usr_msg_54144','Only number is required.','en-US',103306,104001, 122109,'Only number is required.',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54145)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54145,'usr_msg_54145','The scheduled frequency is required.','en-US',103306,104001, 122109,'The scheduled frequency is required.',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54146)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54146,'usr_msg_54146','The scheduled date is required.','en-US',103306,104001, 122109,'The scheduled date is required.',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54147)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54147,'usr_msg_54147','Duplicate options are not allowed.','en-US',103306,104001, 122109,'Duplicate options are not allowed.',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54148)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54148,'usr_msg_54148','Select correct answer.','en-US',103306,104001, 122109,'Select correct answer.',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54149)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54149,'usr_btn_54149','Go to Dashboard','en-US',103306,104004, 122109,'Go to Dashboard',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54150)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54150,'usr_msg_54150','Empty options are not allowed.','en-US',103306,104001, 122109,'Empty options are not allowed.',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54151)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54151,'usr_msg_54151','Special characters are not allowed.','en-US',103306,104001, 122109,'Special characters are not allowed.',1,GETDATE())
END

IF NOT EXISTS(SELECT ID FROM com_GlobalRedirectionControllerActionPair WHERE ID = 10)
BEGIN
	INSERT INTO com_GlobalRedirectionControllerActionPair VALUES(10,'MCQSettingShowMCQTest',1,GETDATE())
END


IF NOT EXISTS(SELECT ID FROM com_GlobalRedirectToURL WHERE ID = 9)
BEGIN
	INSERT INTO com_GlobalRedirectToURL VALUES(9,'MCQSetting','MCQ_User','acid,328',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54152)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54152,'usr_msg_54152','The Question field is required.','en-US',103306,104001, 122109,'The Question field is required',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54153)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54153,'usr_msg_54153','Cannot delete this question because it is already answered by employee.','en-US',103306,104001, 122109,'Cannot delete this question because it is already answered by employee.',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54154)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54154,'usr_btn_54154','Save','en-US',103306,104004, 122109,'Save',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54155)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54155,'usr_msg_54155','The Answer Type field is required.','en-US',103306,104001, 122109,'The Answer Type field is required.',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54156)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54156,'usr_msg_54156','The Option number field is required.','en-US',103306,104001, 122109,'The Option number field is required.',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54157)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54157,'usr_msg_54157','Unblock the user for next frequency is true','en-US',103306,104001, 122109,'Unblock the user for next frequency is true',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54158)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54158,'usr_msg_54158','Frequency of MCQs to be displayed is required','en-US',103306,104001, 122109,'Frequency of MCQs to be displayed is required',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54159)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54159,'usr_msg_54159','No records found for download','en-US',103306,104001, 122109,'No records found for download',1,GETDATE())
END
IF NOT EXISTS(SELECT 1 FROM sys.default_constraints WHERE NAME = 'DF_mst_Company_IsMCQRequired')
BEGIN
  ALTER TABLE mst_Company ADD CONSTRAINT DF_mst_Company_IsMCQRequired DEFAULT 521002 FOR IsMCQRequired;
END
GO
