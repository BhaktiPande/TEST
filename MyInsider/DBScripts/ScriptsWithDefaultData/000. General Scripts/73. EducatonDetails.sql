
-- ======================================================================================================
-- Author      : Samadhan kadam
-- CREATED DATE: 07-feb-2018
-- Description : Script for Education Details Confirmation Functionality.
-- ======================================================================================================

--Add Screen
----com_CodeGroup entry for grid Open--
IF NOT EXISTS(SELECT codegroupid FROM com_CodeGroup WHERE codegroupid = 514)
BEGIN
	INSERT INTO com_CodeGroup([CodeGroupID],[COdeGroupName],[Description],[IsVisible],[IsEditable],[ParentCodeGroupId])
	VALUES ( 514,'Resident Status','Resident Status for personal details',1,1,NULL)
END

----com_CodeGroup entry for grid Open--
----Com code entry for grid Open--

IF NOT EXISTS(SELECT codeid FROM com_code WHERE codeid = 114115)
BEGIN
	INSERT INTO com_code([CodeID],[CodeName],[CodeGroupId],[Description],[IsVisible],[IsActive],[DisplayOrder],[DisplayCode],[ParentCodeId],[ModifiedBy],[ModifiedOn])
	VALUES ( 114115,	'Education List',114,'Education List',1,1,112,NULL,	NULL,1,	getdate())
END

IF NOT EXISTS(SELECT codeid FROM com_code WHERE codeid = 114116)
BEGIN
	INSERT INTO com_code([CodeID],[CodeName],[CodeGroupId],[Description],[IsVisible],[IsActive],[DisplayOrder],[DisplayCode],[ParentCodeId],[ModifiedBy],[ModifiedOn])
	VALUES ( 114116,	'Work List',114,'Work List',1,1,113,NULL,	NULL,1,	getdate())
END

----Com code entry for grid close--

----Com code entry for resident type open--
IF NOT EXISTS(SELECT codeid FROM com_code WHERE codeid = 514001)
BEGIN
	INSERT INTO com_code([CodeID],[CodeName],[CodeGroupId],[Description],[IsVisible],[IsActive],[DisplayOrder],[DisplayCode],[ParentCodeId],[ModifiedBy],[ModifiedOn])
	VALUES ( 514001,	'Resident',514,'Resident',1,1,1,NULL,	NULL,1,	getdate())
END
IF NOT EXISTS(SELECT codeid FROM com_code WHERE codeid = 514002)
BEGIN
	INSERT INTO com_code([CodeID],[CodeName],[CodeGroupId],[Description],[IsVisible],[IsActive],[DisplayOrder],[DisplayCode],[ParentCodeId],[ModifiedBy],[ModifiedOn])
	VALUES ( 514002,	'Non Resident',514,'Non Resident',1,1,2,NULL,	NULL,1,	getdate())
END
IF NOT EXISTS(SELECT codeid FROM com_code WHERE codeid = 514003)
BEGIN
	INSERT INTO com_code([CodeID],[CodeName],[CodeGroupId],[Description],[IsVisible],[IsActive],[DisplayOrder],[DisplayCode],[ParentCodeId],[ModifiedBy],[ModifiedOn])
	VALUES ( 514003,	'Foreign National',514,'Foreign National',1,1,3,NULL,	NULL,1,	getdate())
END


----Com code entry for resident type close--

--Add new reourcekey for "Education Details"


IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54001)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54001,'usr_btn_54001','Education Details','en-US',103002,104004, 122003,'Education Details',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54002)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54002,'usr_lbl_54002','Education Details','en-US',103002,104002, 122003,'Education Details',1,GETDATE())
END


IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54003)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54003,'usr_lbl_54003','Institute Name','en-US',103002,104002, 122003,'Institute Name',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54004)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54004,'usr_lbl_54004','Course Name','en-US',103002,104002, 122003,'Course Name',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54005)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54005,'usr_lbl_54005','Passing Month','en-US',103002,104002, 122003,'Passing Month',1,GETDATE())
END


IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54006)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54006,'usr_lbl_54006','Passing Year','en-US',103002,104002, 122003,'Passing Year',1,GETDATE())
END


IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54007)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54007,'usr_lbl_54007','Work Details','en-US',103002,104002, 122003,'Work Details',1,GETDATE())
END


IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54008)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54008,'usr_btn_54008','Save','en-US',103002,104004, 122003,'Save',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54009)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54009,'usr_btn_54009','Cancel','en-US',103002,104004, 122003,'Cancel',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54010)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54010,'usr_lbl_54010','Employer','en-US',103002,104002, 122003,'Employer',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54011)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54011,'usr_lbl_54011','Designation','en-US',103002,104002, 122003,'Designation',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54012)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54012,'usr_btn_54012','Add Education Details','en-US',103002,104004, 122003,'Add Education Details',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54013)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54013,'usr_btn_54013','Save','en-US',103002,104004, 122003,'Save',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54014)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54014,'usr_btn_54014','Cancel','en-US',103002,104004, 122003,'Cancel',1,GETDATE())
END

/*Education & work details Gridview column keys Open*/
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54015)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54015,'usr_grd_54015','Institute Name','en-US',103002,104003, 122003,'Institute Name',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54016)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54016,'usr_grd_54016','Course Name','en-US',103002,104003, 122003,'Course Name',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54017)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54017,'usr_grd_54017','Passing Month','en-US',103002,104003, 122003,'Passing Month',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54018)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54018,'usr_grd_54018','Passing Year','en-US',103002,104003, 122003,'Passing Year',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54019)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54019,'usr_grd_54019','From Month','en-US',103002,104003, 122003,'From Month',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54020)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54020,'usr_grd_54020','From Year','en-US',103002,104003, 122003,'From Year',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54021)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54021,'usr_grd_54021','To Month','en-US',103002,104003, 122003,'To Month',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54022)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54022,'usr_grd_54022','To Year','en-US',103002,104003, 122003,'To Year',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54023)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54023,'usr_grd_54023','Designation','en-US',103002,104003, 122003,'Designation',1,GETDATE())
END
/*Education & work details Gridview column keys Close*/

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54024)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54024,'usr_lbl_54024','From Month','en-US',103002,104002, 122003,'From Month',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54025)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54025,'usr_lbl_54025','From Year','en-US',103002,104002, 122003,'From Year',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54026)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54026,'usr_lbl_54026','To Month','en-US',103002,104002, 122003,'To Month',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54027)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54027,'usr_lbl_54027','To Year','en-US',103002,104002, 122003,'To Year',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54028)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54028,'usr_btn_54028','Add Work Details','en-US',103002,104004, 122003,'Add Work Details',1,GETDATE())
END
/*Education & work details Gridview column keys Open*/

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54029)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54029,'usr_lbl_54029','Education and Work Details','en-US',103002,104002, 122003,'Education and Work Details',1,GETDATE())
END


IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54030)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54030,'usr_grd_54030','Employer','en-US',103002,104003, 122003,'Employer',1,GETDATE())
END
/*Education & work details Gridview column keys Close*/


/*Education & work details Error message Open*/

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54031)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54031,'usr_msg_54031','Education details saved successfully','en-US',103002,104001, 122003,'Education details saved successfully',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54032)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54032,'usr_msg_54032','Work details saved successfully','en-US',103002,104001, 122003,'Work details saved successfully',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54033)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54033,'usr_msg_54033','Record deleted successfully','en-US',103002,104001, 122003,'Record deleted successfully',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54034)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54034,'usr_msg_54034','Please enter characters only','en-US',103002,104001, 122003,'Please enter characters only',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54035)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54035,'usr_msg_54035','Please enter characters only','en-US',103002,104001, 122003,'Please enter characters only',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54036)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54036,'usr_msg_54036','Error occurred while fetching list of education details for user.','en-US',103002,104001, 122003,'Error occurred while fetching list of education details for user.',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54037)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54037,'usr_msg_54037','Error occurred while fetching list of work details for user.','en-US',103002,104001, 122003,'Error occurred while fetching list of work details for user.',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54038)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54038,'usr_msg_54038','Please enter characters only','en-US',103002,104001, 122003,'Please enter characters only',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54039)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54039,'usr_msg_54039','Please enter characters only','en-US',103002,104001, 122003,'Please enter characters only',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54040)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54040,'usr_msg_54040','Error occurred while saving education details for employee.','en-US',103002,104001, 122003,'Error occurred while saving education details for employee.',1,GETDATE())
END

--54041 -54045 used by arvind

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54046)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54046,'usr_btn_54046','I don''t have education/work details, Proceed','en-US',103002,104004, 122003,'I don''t have education/work details, Proceed',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54047)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54047,'usr_msg_54047','Education details already exists.','en-US',103002,104001, 122003,'Education details already exists.',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54048)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54048,'usr_msg_54048','Work details already exists.','en-US',103002,104001, 122003,'Work details already exists.',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54049)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54049,'usr_msg_54049','You can not select greater than current month.','en-US',103002,104001, 122003,'You can not select greater than current month.',1,GETDATE())
END


/*Education & work details Error message Close*/
/* Personal details open */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54050)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54050,'usr_lbl_54050','Resident Type','en-US',103002,104002, 122004,'Resident Type',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54051)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54051,'usr_lbl_54051','Identification Number','en-US',103002,104002, 122004,'Identification Number',1,GETDATE())
END
/* Personal details close */

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54052)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54052,'usr_msg_54052','You must select to year greater than from year.','en-US',103002,104001, 122003,'You must select to year greater than from year.',1,GETDATE())
END
/* Insert into grid header setting Open*/


IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54053)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54053,'usr_msg_54053','Special characters(*,<,>,_) are not allowed.','en-US',103002,104001, 122004,'Special characters(*,<,>,_) are not allowed.',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54054)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54054,'usr_msg_54054','At list one field required, you can not insert blank details.','en-US',103002,104001, 122004,'At list one field required, you can not insert blank details.',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54055)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54055,'usr_msg_54055','You have not provided the education/work detail. Are you sure you want to proceed to fill the relative information ?','en-US',103002,104001, 122004,'You have not provided the education/work detail. Are you sure you want to proceed to fill the relative information ?',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54056)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54056,'usr_msg_54056','From month can not be greater than to month.please select proper month.','en-US',103002,104001, 122004,'From month can not be greater than to month.please select proper month.',1,GETDATE())
END

IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114115 and ResourceKey='usr_grd_54015')
begin
insert into com_GridHeaderSetting ([GridTypeCodeId],	[ResourceKey],	[IsVisible],	[SequenceNumber],	[ColumnWidth]	,[ColumnAlignment],	[OverrideGridTypeCodeId]	,[OverrideResourceKey])
values (114115,	'usr_grd_54015',	1,	1,	0,	155001,	NULL,NULL)
end
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114115 and ResourceKey='usr_grd_54016')
begin
insert into com_GridHeaderSetting ([GridTypeCodeId],	[ResourceKey],	[IsVisible],	[SequenceNumber],	[ColumnWidth]	,[ColumnAlignment],	[OverrideGridTypeCodeId]	,[OverrideResourceKey])
values (114115,	'usr_grd_54016',	1,	2,	0,	155001,	NULL,NULL)
end
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114115 and ResourceKey='usr_grd_54017')
begin
insert into com_GridHeaderSetting ([GridTypeCodeId],	[ResourceKey],	[IsVisible],	[SequenceNumber],	[ColumnWidth]	,[ColumnAlignment],	[OverrideGridTypeCodeId]	,[OverrideResourceKey])
values (114115,	'usr_grd_54017',	1,	3,	0,	155001,	NULL,NULL)
end
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114115 and ResourceKey='usr_grd_54018')
begin
insert into com_GridHeaderSetting ([GridTypeCodeId],	[ResourceKey],	[IsVisible],	[SequenceNumber],	[ColumnWidth]	,[ColumnAlignment],	[OverrideGridTypeCodeId]	,[OverrideResourceKey])
values (114115,	'usr_grd_54018',	1,	4,	0,	155001,	NULL,NULL)
end
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114115 and ResourceKey='usr_grd_11073')
begin
insert into com_GridHeaderSetting ([GridTypeCodeId],	[ResourceKey],	[IsVisible],	[SequenceNumber],	[ColumnWidth]	,[ColumnAlignment],	[OverrideGridTypeCodeId]	,[OverrideResourceKey])
values (114115,	'usr_grd_11073',	1,	5,	0,	155001,	NULL,NULL)
end



IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114116 and ResourceKey='usr_grd_54030')
begin
insert into com_GridHeaderSetting ([GridTypeCodeId],	[ResourceKey],	[IsVisible],	[SequenceNumber],	[ColumnWidth]	,[ColumnAlignment],	[OverrideGridTypeCodeId]	,[OverrideResourceKey])
values (114116,	'usr_grd_54030',	1,	1,	0,	155001,	NULL,NULL)
end
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114116 and ResourceKey='usr_grd_54023')
begin
insert into com_GridHeaderSetting ([GridTypeCodeId],	[ResourceKey],	[IsVisible],	[SequenceNumber],	[ColumnWidth]	,[ColumnAlignment],	[OverrideGridTypeCodeId]	,[OverrideResourceKey])
values (114116,	'usr_grd_54023',	1,	2,	0,	155001,	NULL,NULL)
end
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114116 and ResourceKey='usr_grd_54019')
begin
insert into com_GridHeaderSetting ([GridTypeCodeId],	[ResourceKey],	[IsVisible],	[SequenceNumber],	[ColumnWidth]	,[ColumnAlignment],	[OverrideGridTypeCodeId]	,[OverrideResourceKey])
values (114116,	'usr_grd_54019',	1,	3,	0,	155001,	NULL,NULL)
end
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114116 and ResourceKey='usr_grd_54020')
begin
insert into com_GridHeaderSetting ([GridTypeCodeId],	[ResourceKey],	[IsVisible],	[SequenceNumber],	[ColumnWidth]	,[ColumnAlignment],	[OverrideGridTypeCodeId]	,[OverrideResourceKey])
values (114116,	'usr_grd_54020',	1,	4,	0,	155001,	NULL,NULL)
end
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114116 and ResourceKey='usr_grd_54021')
begin
insert into com_GridHeaderSetting ([GridTypeCodeId],	[ResourceKey],	[IsVisible],	[SequenceNumber],	[ColumnWidth]	,[ColumnAlignment],	[OverrideGridTypeCodeId]	,[OverrideResourceKey])
values (114116,	'usr_grd_54021',	1,	5,	0,	155001,	NULL,NULL)
end
IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114116 and ResourceKey='usr_grd_54022')
begin
insert into com_GridHeaderSetting ([GridTypeCodeId],	[ResourceKey],	[IsVisible],	[SequenceNumber],	[ColumnWidth]	,[ColumnAlignment],	[OverrideGridTypeCodeId]	,[OverrideResourceKey])
values (114116,	'usr_grd_54022',	1,	6,	0,	155001,	NULL,NULL)
end

IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114116 and ResourceKey='usr_grd_11073')
begin
insert into com_GridHeaderSetting ([GridTypeCodeId],	[ResourceKey],	[IsVisible],	[SequenceNumber],	[ColumnWidth]	,[ColumnAlignment],	[OverrideGridTypeCodeId]	,[OverrideResourceKey])
values (114116,	'usr_grd_11073',	1,	7,	0,	155001,	NULL,NULL)
end
/* Insert into grid header setting Close*/


/* Multiple mobile number Add Scren Open */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54041)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54041,'usr_lbl_54041','Contact Details','en-US',103002,104002, 122004,'Contact Details',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54042)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54042,'usr_lbl_54042','Mobile Number','en-US',103002,104002, 122004,'Mobile Number',1,GETDATE())
END


IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54043)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54043,'usr_btn_54043','Save','en-US',103002,104004, 122004,'Save',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54044)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54044,'usr_btn_54044','Cancel','en-US',103002,104004, 122004,'Cancel',1,GETDATE())
END


IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54045)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54045,'usr_msg_54045','Contact Details Save Successfully','en-US',103002,104001, 122004,'Contact Details Save Successfully',1,GETDATE())
END

/* Multiple mobile number Add Scren Open */
/* Table alter scripts open */
IF NOT EXISTS(
SELECT cm.COLUMN_NAME FROM INFORMATION_SCHEMA.TABLES  as tb inner join INFORMATION_SCHEMA.COLUMNS as cm  on tb.TABLE_NAME=cm.TABLE_NAME
  		     WHERE
  			 tb.TABLE_NAME = 'usr_UserInfo' and COLUMN_NAME in( 'ResidentTypeId','UIDAI_IdentificationNo','DoYouHaveEduOrWorkDetails'))
 BEGIN  			 
	  ALTER TABLE [usr_UserInfo]
	  ADD ResidentTypeId int null,
		  UIDAI_IdentificationNo varchar(50) null,
		  DoYouHaveEduOrWorkDetails int null
	      
	  ALTER TABLE usr_UserInfo ADD CONSTRAINT DF_usr_UserInfo_DoYouHaveEduOrWorkDetails DEFAULT 0 FOR DoYouHaveEduOrWorkDetails;
 END
  /* Table alter scripts close */
  
 IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54057)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54057,'usr_btn_54057','You do not have rights to add education/work details, please processed','en-US',103002,104004, 122004,'You do not have rights to add education/work details, please processed',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54064)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54064,'usr_msg_54064','Please enter only numbers in mobile number.','en-US',103002,104002, 122004,'Please enter only numbers in mobile number.',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54065)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54065,'usr_msg_54065','Mobile no. should be min. 3 & max. 15 digits (including +)','en-US',103002,104002, 122004,'Mobile no. should be min. 3 & max. 15 digits (including +)',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54066)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54066,'usr_msg_54066','Please enter only numbers in mobile number.','en-US',103002,104002, 122004,'Please enter only numbers in mobile number.',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54067)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54067,'usr_lbl_54067','Identification Type','en-US',103002,104002, 122004,'Identification Type',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54068)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54068,'usr_lbl_54068','Identification Type','en-US',103002,104002, 122016,'Identification Type',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54069)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54069,'usr_lbl_54069','Identification Number','en-US',103002,104002, 122016,'Identification Number',1,GETDATE())
END

/*Code group for identity type open*/
IF NOT EXISTS(SELECT codegroupid FROM com_CodeGroup WHERE codegroupid = 516)
BEGIN
	INSERT INTO com_CodeGroup([CodeGroupID],[COdeGroupName],[Description],[IsVisible],[IsEditable],[ParentCodeGroupId])
	VALUES ( 516,'Identification Type - Self','Identification Type  for personal details',1,1,NULL)
END
IF NOT EXISTS(SELECT codegroupid FROM com_CodeGroup WHERE codegroupid = 517)
BEGIN
	INSERT INTO com_CodeGroup([CodeGroupID],[COdeGroupName],[Description],[IsVisible],[IsEditable],[ParentCodeGroupId])
	VALUES ( 517,'Identification Type - Relative','Identification Type  for relative details',1,1,NULL)
END
/*Code group for identity type close*/

----Com code entry for Identification type open--
IF NOT EXISTS(SELECT codeid FROM com_code WHERE codeid = 516001)
BEGIN
	INSERT INTO com_code([CodeID],[CodeName],[CodeGroupId],[Description],[IsVisible],[IsActive],[DisplayOrder],[DisplayCode],[ParentCodeId],[ModifiedBy],[ModifiedOn])
	VALUES ( 516001,	'Aadhar Card',516,'Aadhar Card',1,1,1,NULL,	NULL,1,	getdate())
END
IF NOT EXISTS(SELECT codeid FROM com_code WHERE codeid = 516002)
BEGIN
	INSERT INTO com_code([CodeID],[CodeName],[CodeGroupId],[Description],[IsVisible],[IsActive],[DisplayOrder],[DisplayCode],[ParentCodeId],[ModifiedBy],[ModifiedOn])
	VALUES ( 516002,	'Driving License',516,'Driving License',1,1,2,NULL,	NULL,1,	getdate())
END
IF NOT EXISTS(SELECT codeid FROM com_code WHERE codeid = 516003)
BEGIN
	INSERT INTO com_code([CodeID],[CodeName],[CodeGroupId],[Description],[IsVisible],[IsActive],[DisplayOrder],[DisplayCode],[ParentCodeId],[ModifiedBy],[ModifiedOn])
	VALUES ( 516003,	'Passport',516,'Passport',1,1,3,NULL,	NULL,1,	getdate())
END

----Com code entry for Identification type close--


----Com code entry for Identification type For Relative open--
IF NOT EXISTS(SELECT codeid FROM com_code WHERE codeid = 517001)
BEGIN
	INSERT INTO com_code([CodeID],[CodeName],[CodeGroupId],[Description],[IsVisible],[IsActive],[DisplayOrder],[DisplayCode],[ParentCodeId],[ModifiedBy],[ModifiedOn])
	VALUES ( 517001,	'Aadhar Card',517,'Aadhar Card',1,1,1,NULL,	NULL,1,	getdate())
END
IF NOT EXISTS(SELECT codeid FROM com_code WHERE codeid = 517002)
BEGIN
	INSERT INTO com_code([CodeID],[CodeName],[CodeGroupId],[Description],[IsVisible],[IsActive],[DisplayOrder],[DisplayCode],[ParentCodeId],[ModifiedBy],[ModifiedOn])
	VALUES ( 517002,	'Driving License',517,'Driving License',1,1,2,NULL,	NULL,1,	getdate())
END
IF NOT EXISTS(SELECT codeid FROM com_code WHERE codeid = 517003)
BEGIN
	INSERT INTO com_code([CodeID],[CodeName],[CodeGroupId],[Description],[IsVisible],[IsActive],[DisplayOrder],[DisplayCode],[ParentCodeId],[ModifiedBy],[ModifiedOn])
	VALUES ( 517003,	'Passport',517,'Passport',1,1,3,NULL,	NULL,1,	getdate())
END

----Com code entry for Identification type For Relative close--

/* Table alter scripts open */
IF NOT EXISTS(
SELECT cm.COLUMN_NAME FROM INFORMATION_SCHEMA.TABLES  as tb inner join INFORMATION_SCHEMA.COLUMNS as cm  on tb.TABLE_NAME=cm.TABLE_NAME
  		     WHERE
  			 tb.TABLE_NAME = 'usr_UserInfo' and COLUMN_NAME in( 'IdentificationTypeId'))
 BEGIN  			 
	  ALTER TABLE [usr_UserInfo]
	  ADD IdentificationTypeId int null
		
 END
  /* Table alter scripts close */


  /* --- Add category column on Grid Header And mst_Resource Open---   */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54060)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54060,'dis_grd_54060','Category','en-US',103002,104003, 122033,'Category',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54061)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54061,'dis_grd_54061','Category','en-US',103009,104003, 122056,'Category',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54062)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54062,'dis_grd_54062','Category','en-US',103009,104003, 122055,'Category',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54063)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54063,'dis_grd_54063','Category','en-US',103009,104003, 122057,'Category',1,GETDATE())
END

IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114002 and ResourceKey='dis_grd_54060')
begin
insert into com_GridHeaderSetting ([GridTypeCodeId],	[ResourceKey],	[IsVisible],	[SequenceNumber],	[ColumnWidth]	,[ColumnAlignment],	[OverrideGridTypeCodeId]	,[OverrideResourceKey])
values (114002,	'dis_grd_54060',	1,	13,	0,	155001,	NULL,NULL)
end

IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114048 and ResourceKey='dis_grd_54061')
begin
insert into com_GridHeaderSetting ([GridTypeCodeId],	[ResourceKey],	[IsVisible],	[SequenceNumber],	[ColumnWidth]	,[ColumnAlignment],	[OverrideGridTypeCodeId]	,[OverrideResourceKey])
values (114048,	'dis_grd_54061',	1,	10,	0,	155001,	NULL,NULL)
end


IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114045 and ResourceKey='dis_grd_54062')
begin
insert into com_GridHeaderSetting ([GridTypeCodeId],	[ResourceKey],	[IsVisible],	[SequenceNumber],	[ColumnWidth]	,[ColumnAlignment],	[OverrideGridTypeCodeId]	,[OverrideResourceKey])
values (114045,	'dis_grd_54062',	1,	10,	0,	155001,	NULL,NULL)
end

IF NOT EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114049 and ResourceKey='dis_grd_54063')
begin
insert into com_GridHeaderSetting ([GridTypeCodeId],	[ResourceKey],	[IsVisible],	[SequenceNumber],	[ColumnWidth]	,[ColumnAlignment],	[OverrideGridTypeCodeId]	,[OverrideResourceKey])
values (114049,	'dis_grd_54063',	1,	14,	0,	155001,	NULL,NULL)
end
/* --- Add category column on Grid Header And mst_Resource Close---   */

/* --- Add Closing Balance Label on Priclarance Req And not taken open ---   */

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 55025)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (55025,'usr_lbl_55025','Closing Balance','en-US',103009,104002, 122051,'Closing Balance',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 55026)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (55026,'usr_lbl_55026','Closing Balance','en-US',103008,104002, 122036,'Closing Balance',1,GETDATE())
END

/* --- Add Closing Balance Label on Priclarance Req And not taken Close  ---   */


