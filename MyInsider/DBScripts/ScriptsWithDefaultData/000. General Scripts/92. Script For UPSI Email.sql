
-- ======================================================================================================
-- Author      : Samadhan Kadm																			=
-- CREATED DATE: 07-APR-2016                                                 							=
-- Description : INSERT DATA IN  mst_Resource,	com_code,	com_CodeGroup	,com_PlaceholderMaster		=
-- ======================================================================================================

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54177)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54177,'cmp_lbl_54177','Email Settings','en-US',103005,104002,122084,'Email Settings',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54178)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54178,'cmp_lbl_54178','Trigger Emails- UPSI Updated','en-US',103005,104002,122084,'Trigger Emails- UPSI Updated',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54179)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54179,'cmp_lbl_54179','Trigger Emails- UPSI published','en-US',103005,104002,122084,'Trigger Emails- UPSI published',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54180)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54180,'cmp_lbl_54180','To','en-US',103005,104002,122084,'To',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54181)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54181,'cmp_lbl_54181','CC','en-US',103005,104002,122084,'CC',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54182)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54182,'cmp_msg_54182','Success','en-US',103005,104001,122084,'Success',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54183)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54183,'cmp_msg_54183','Fail','en-US',103005,104001,122084,'Fail',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54184)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54184,'cmp_msg_54184','Value from To section and CC section can not be same.','en-US',103005,104001,122084,'Value from To section and CC section can not be same.',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54185)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54185,'cmp_msg_54185','Please select value from To section','en-US',103005,104001,122084,'Please select value from To section.',1,GETDATE())
END

IF NOT EXISTS(SELECT codeid FROM com_code WHERE codeid = 192003)
BEGIN
	INSERT INTO com_code([CodeID],[CodeName],[CodeGroupId],[Description],[IsVisible],[IsActive],[DisplayOrder],[DisplayCode],[ParentCodeId],[ModifiedBy],[ModifiedOn])
	VALUES ( 192003,	'Yes',192,'Yes',1,1,1,NULL,	NULL,1,	getdate())
END

IF NOT EXISTS(SELECT codeid FROM com_code WHERE codeid = 192004)
BEGIN
	INSERT INTO com_code([CodeID],[CodeName],[CodeGroupId],[Description],[IsVisible],[IsActive],[DisplayOrder],[DisplayCode],[ParentCodeId],[ModifiedBy],[ModifiedOn])
	VALUES ( 192004,	'No',192,'No',1,1,1,NULL,	NULL,1,	getdate())
END
IF NOT EXISTS(SELECT codeid FROM com_code WHERE codeid = 192005)
BEGIN
	INSERT INTO com_code([CodeID],[CodeName],[CodeGroupId],[Description],[IsVisible],[IsActive],[DisplayOrder],[DisplayCode],[ParentCodeId],[ModifiedBy],[ModifiedOn])
	VALUES ( 192005,	'Yes',192,'Yes',1,1,1,NULL,	NULL,1,	getdate())
END

IF NOT EXISTS(SELECT codeid FROM com_code WHERE codeid = 192006)
BEGIN
	INSERT INTO com_code([CodeID],[CodeName],[CodeGroupId],[Description],[IsVisible],[IsActive],[DisplayOrder],[DisplayCode],[ParentCodeId],[ModifiedBy],[ModifiedOn])
	VALUES ( 192006,	'No',192,'No',1,1,1,NULL,	NULL,1,	getdate())
END
IF NOT EXISTS(SELECT codegroupid FROM com_CodeGroup WHERE codegroupid = 525)
BEGIN
	INSERT INTO com_CodeGroup([CodeGroupID],[COdeGroupName],[Description],[IsVisible],[IsEditable],[ParentCodeGroupId])
	VALUES ( 525,'UPSI User Type','UPSI User Type',1,1,NULL)
END
IF NOT EXISTS(SELECT codegroupid FROM com_CodeGroup WHERE codegroupid = 526)
BEGIN
	INSERT INTO com_CodeGroup([CodeGroupID],[COdeGroupName],[Description],[IsVisible],[IsEditable],[ParentCodeGroupId])
	VALUES ( 526,'Types of Email Settings','Types of Email Settings',1,1,NULL)
END
IF NOT EXISTS(SELECT codeid FROM com_code WHERE codeid = 525001)
BEGIN
	INSERT INTO com_code([CodeID],[CodeName],[CodeGroupId],[Description],[IsVisible],[IsActive],[DisplayOrder],[DisplayCode],[ParentCodeId],[ModifiedBy],[ModifiedOn])
	VALUES ( 525001,	'Updated by',525,'Updated by',1,1,1,NULL,	NULL,1,	getdate())
END
IF NOT EXISTS(SELECT codeid FROM com_code WHERE codeid = 525002)
BEGIN
	INSERT INTO com_code([CodeID],[CodeName],[CodeGroupId],[Description],[IsVisible],[IsActive],[DisplayOrder],[DisplayCode],[ParentCodeId],[ModifiedBy],[ModifiedOn])
	VALUES ( 525002,	'Information shared with',525,'Information shared with',1,1,1,NULL,	NULL,1,	getdate())
END
IF NOT EXISTS(SELECT codeid FROM com_code WHERE codeid = 525003)
BEGIN
	INSERT INTO com_code([CodeID],[CodeName],[CodeGroupId],[Description],[IsVisible],[IsActive],[DisplayOrder],[DisplayCode],[ParentCodeId],[ModifiedBy],[ModifiedOn])
	VALUES ( 525003,	'Information shared by',525,'Information shared by',1,1,1,NULL,	NULL,1,	getdate())
END


IF NOT EXISTS(SELECT codeid FROM com_code WHERE codeid = 180008)
BEGIN
	INSERT INTO com_code([CodeID],[CodeName],[CodeGroupId],[Description],[IsVisible],[IsActive],[DisplayOrder],[DisplayCode],[ParentCodeId],[ModifiedBy],[ModifiedOn])
	VALUES ( 180008,	'Email Settings',180,'Email Settings',1,1,8,NULL,	NULL,1,	getdate())
END

IF NOT EXISTS(SELECT codeid FROM com_code WHERE codeid = 180009)
BEGIN
	INSERT INTO com_code([CodeID],[CodeName],[CodeGroupId],[Description],[IsVisible],[IsActive],[DisplayOrder],[DisplayCode],[ParentCodeId],[ModifiedBy],[ModifiedOn])
	VALUES ( 180009,	'Email Settings To',180,'Email Settings To',1,1,8,NULL,	NULL,1,	getdate())
END

IF NOT EXISTS(SELECT codeid FROM com_code WHERE codeid = 180010)
BEGIN
	INSERT INTO com_code([CodeID],[CodeName],[CodeGroupId],[Description],[IsVisible],[IsActive],[DisplayOrder],[DisplayCode],[ParentCodeId],[ModifiedBy],[ModifiedOn])
	VALUES ( 180010,	'Email Settings CC',180,'Email Settings CC',1,1,8,NULL,	NULL,1,	getdate())
END


IF NOT EXISTS(SELECT codeid FROM com_code WHERE codeid = 526001)
BEGIN
	INSERT INTO com_code([CodeID],[CodeName],[CodeGroupId],[Description],[IsVisible],[IsActive],[DisplayOrder],[DisplayCode],[ParentCodeId],[ModifiedBy],[ModifiedOn])
	VALUES ( 526001,	'Trigger Emails- UPSI Updated',526,'Trigger Emails- UPSI Updated',1,1,8,NULL,	NULL,1,	getdate())
END
IF NOT EXISTS(SELECT codeid FROM com_code WHERE codeid = 526002)
BEGIN
	INSERT INTO com_code([CodeID],[CodeName],[CodeGroupId],[Description],[IsVisible],[IsActive],[DisplayOrder],[DisplayCode],[ParentCodeId],[ModifiedBy],[ModifiedOn])
	VALUES ( 526002,	'Trigger Emails- UPSI Published',526,'Trigger Emails- UPSI Published',1,1,9,NULL,	NULL,1,	getdate())
END

IF NOT EXISTS(SELECT codeid FROM com_code WHERE codeid = 156011)
BEGIN
	INSERT INTO com_code([CodeID],[CodeName],[CodeGroupId],[Description],[IsVisible],[IsActive],[DisplayOrder],[DisplayCode],[ParentCodeId],[ModifiedBy],[ModifiedOn])
	VALUES ( 156011,	'Emails- UPSI Updated',156,'Emails- UPSI Updated',1,1,11,NULL,	NULL,1,	getdate())
END
IF NOT EXISTS(SELECT codeid FROM com_code WHERE codeid = 156012)
BEGIN
	INSERT INTO com_code([CodeID],[CodeName],[CodeGroupId],[Description],[IsVisible],[IsActive],[DisplayOrder],[DisplayCode],[ParentCodeId],[ModifiedBy],[ModifiedOn])
	VALUES ( 156012,	'Emails- UPSI Published',156,'Emails- UPSI Published',1,1,12,NULL,	NULL,1,	getdate())
END


--CREATE PLACE HOLDERS FOR  UPSI Updated mail triggertamplete  

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156011 AND PlaceholderTag='[DocumentNumber]')
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag,	PlaceholderDisplayName,	PlaceholderGroupId,	PlaceholderDescription,	IsVisible,	DisplayOrder,CreatedBy,	CreatedOn,	ModifiedBy,	ModifiedOn)
	VALUES('[DocumentNumber]',	'Document Number'	,156011	,'Document Number',	1,	1,	1	,GETDATE(),	1,GETDATE())
END
IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156011 AND PlaceholderTag='[UPSIInformationOf]')
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag,	PlaceholderDisplayName,	PlaceholderGroupId,	PlaceholderDescription,	IsVisible,	DisplayOrder,CreatedBy,	CreatedOn,	ModifiedBy,	ModifiedOn)
	VALUES('[UPSIInformationOf]',	'UPSI Information Of'	,156011	,'UPSI Information Of',	1,	2,	1	,GETDATE(),	1,GETDATE())
END
IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156011 AND PlaceholderTag='[CategoryOfInformation]')
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag,	PlaceholderDisplayName,	PlaceholderGroupId,	PlaceholderDescription,	IsVisible,	DisplayOrder,CreatedBy,	CreatedOn,	ModifiedBy,	ModifiedOn)
	VALUES('[CategoryOfInformation]',	'Category of Information'	,156011	,'Category of Information',	1,	3,	1	,GETDATE(),	1,GETDATE())
END
IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156011 AND PlaceholderTag='[Comments]')
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag,	PlaceholderDisplayName,	PlaceholderGroupId,	PlaceholderDescription,	IsVisible,	DisplayOrder,CreatedBy,	CreatedOn,	ModifiedBy,	ModifiedOn)
	VALUES('[Comments]',	'Comments'	,156011	,'Comments',	1,	4,	1	,GETDATE(),	1,GETDATE())
END
IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156011 AND PlaceholderTag='[ReasonForSharingInformation]')
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag,	PlaceholderDisplayName,	PlaceholderGroupId,	PlaceholderDescription,	IsVisible,	DisplayOrder,CreatedBy,	CreatedOn,	ModifiedBy,	ModifiedOn)
	VALUES('[ReasonForSharingInformation]',	'Reason For Sharing Information'	,156011	,'Reason For Sharing Information',	1,	5,	1	,GETDATE(),	1,GETDATE())
END
IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156011 AND PlaceholderTag='[ModeOfSharingInformation]')
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag,	PlaceholderDisplayName,	PlaceholderGroupId,	PlaceholderDescription,	IsVisible,	DisplayOrder,CreatedBy,	CreatedOn,	ModifiedBy,	ModifiedOn)
	VALUES('[ModeOfSharingInformation]',	'Mode Of Sharing Information'	,156011	,'Mode Of Sharing Information',	1,	6,	1	,GETDATE(),	1,GETDATE())
END
IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156011 AND PlaceholderTag='[DateOfSharingInformation]')
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag,	PlaceholderDisplayName,	PlaceholderGroupId,	PlaceholderDescription,	IsVisible,	DisplayOrder,CreatedBy,	CreatedOn,	ModifiedBy,	ModifiedOn)
	VALUES('[DateOfSharingInformation]',	'Date Of Sharing Information'	,156011	,'Date Of Sharing Information',	1,	7,	1	,GETDATE(),	1,GETDATE())
END
IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156011 AND PlaceholderTag='[TimeOfSharingInformation]')
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag,	PlaceholderDisplayName,	PlaceholderGroupId,	PlaceholderDescription,	IsVisible,	DisplayOrder,CreatedBy,	CreatedOn,	ModifiedBy,	ModifiedOn)
	VALUES('[TimeOfSharingInformation]',	'Time Of Sharing Information'	,156011	,'Time Of Sharing Information',	1,	8,	1	,GETDATE(),	1,GETDATE())
END
IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156011 AND PlaceholderTag='[SharedByName]')
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag,	PlaceholderDisplayName,	PlaceholderGroupId,	PlaceholderDescription,	IsVisible,	DisplayOrder,CreatedBy,	CreatedOn,	ModifiedBy,	ModifiedOn)
	VALUES('[SharedByName]',	'Shared By Name'	,156011	,'Shared By Name',	1,	9,	1	,GETDATE(),	1,GETDATE())
END
IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156011 AND PlaceholderTag='[SharedByEmailID]')
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag,	PlaceholderDisplayName,	PlaceholderGroupId,	PlaceholderDescription,	IsVisible,	DisplayOrder,CreatedBy,	CreatedOn,	ModifiedBy,	ModifiedOn)
	VALUES('[SharedByEmailID]',	'Shared By Email ID'	,156011	,'Shared By Email ID',	1,	10,	1	,GETDATE(),	1,GETDATE())
END
IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156011 AND PlaceholderTag='[SharedByPAN]')
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag,	PlaceholderDisplayName,	PlaceholderGroupId,	PlaceholderDescription,	IsVisible,	DisplayOrder,CreatedBy,	CreatedOn,	ModifiedBy,	ModifiedOn)
	VALUES('[SharedByPAN]',	'Shared By PAN'	,156011	,'Shared By PAN',	1,	11,	1	,GETDATE(),	1,GETDATE())
END
IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156011 AND PlaceholderTag='[NameOfCompany]')
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag,	PlaceholderDisplayName,	PlaceholderGroupId,	PlaceholderDescription,	IsVisible,	DisplayOrder,CreatedBy,	CreatedOn,	ModifiedBy,	ModifiedOn)
	VALUES('[NameOfCompany]',	'Name Of Company'	,156011	,'Name Of Company',	1,	12,	1	,GETDATE(),	1,GETDATE())
END
IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156011 AND PlaceholderTag='[SharedWithName]')
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag,	PlaceholderDisplayName,	PlaceholderGroupId,	PlaceholderDescription,	IsVisible,	DisplayOrder,CreatedBy,	CreatedOn,	ModifiedBy,	ModifiedOn)
	VALUES('[SharedWithName]',	'Shared With Name'	,156011	,'Shared With Name',	1,	13,	1	,GETDATE(),	1,GETDATE())
END
IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156011 AND PlaceholderTag='[SharedWithEmailID]')
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag,	PlaceholderDisplayName,	PlaceholderGroupId,	PlaceholderDescription,	IsVisible,	DisplayOrder,CreatedBy,	CreatedOn,	ModifiedBy,	ModifiedOn)
	VALUES('[SharedWithEmailID]',	'Shared With Email ID'	,156011	,'Shared With Email ID',	1,	14,	1	,GETDATE(),	1,GETDATE())
END
IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156011 AND PlaceholderTag='[SharedWithPAN]')
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag,	PlaceholderDisplayName,	PlaceholderGroupId,	PlaceholderDescription,	IsVisible,	DisplayOrder,CreatedBy,	CreatedOn,	ModifiedBy,	ModifiedOn)
	VALUES('[SharedWithPAN]',	'Shared With PAN'	,156011	,'Shared With PAN',	1,	15,	1	,GETDATE(),	1,GETDATE())
END
IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156011 AND PlaceholderTag='[SharedWithNameOfCompany]')
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag,	PlaceholderDisplayName,	PlaceholderGroupId,	PlaceholderDescription,	IsVisible,	DisplayOrder,CreatedBy,	CreatedOn,	ModifiedBy,	ModifiedOn)
	VALUES('[SharedWithNameOfCompany]',	'Shared With Name Of Company'	,156011	,'Shared With Name Of Company',	1,	16,	1	,GETDATE(),	1,GETDATE())
END
IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156011 AND PlaceholderTag='[DateOfPublishing]')
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag,	PlaceholderDisplayName,	PlaceholderGroupId,	PlaceholderDescription,	IsVisible,	DisplayOrder,CreatedBy,	CreatedOn,	ModifiedBy,	ModifiedOn)
	VALUES('[DateOfPublishing]',	'Date Of Publishing'	,156011	,'Date Of Publishing',	1,	17,	1	,GETDATE(),	1,GETDATE())
END
IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156011 AND PlaceholderTag='[NameOfTheUserWhoUpdatedThisInformation]')
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag,	PlaceholderDisplayName,	PlaceholderGroupId,	PlaceholderDescription,	IsVisible,	DisplayOrder,CreatedBy,	CreatedOn,	ModifiedBy,	ModifiedOn)
	VALUES('[NameOfTheUserWhoUpdatedThisInformation]',	'Name Of The User Who Updated This Information'	,156011	,'Name Of The User Who Updated This Information',	1,	18,	1	,GETDATE(),	1,GETDATE())
END



--CREATE PLACE HOLDERS FOR  UPSI publish mail triggertamplete  

IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156012 AND PlaceholderTag='[DocumentNumber]')
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag,	PlaceholderDisplayName,	PlaceholderGroupId,	PlaceholderDescription,	IsVisible,	DisplayOrder,CreatedBy,	CreatedOn,	ModifiedBy,	ModifiedOn)
	VALUES('[DocumentNumber]',	'Document Number'	,156012	,'Document Number',	1,	1,	1	,GETDATE(),	1,GETDATE())
END
IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156012 AND PlaceholderTag='[UPSIInformationOf]')
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag,	PlaceholderDisplayName,	PlaceholderGroupId,	PlaceholderDescription,	IsVisible,	DisplayOrder,CreatedBy,	CreatedOn,	ModifiedBy,	ModifiedOn)
	VALUES('[UPSIInformationOf]',	'UPSI Information Of'	,156012	,'UPSI Information Of',	1,	2,	1	,GETDATE(),	1,GETDATE())
END
IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156012 AND PlaceholderTag='[CategoryOfInformation]')
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag,	PlaceholderDisplayName,	PlaceholderGroupId,	PlaceholderDescription,	IsVisible,	DisplayOrder,CreatedBy,	CreatedOn,	ModifiedBy,	ModifiedOn)
	VALUES('[CategoryOfInformation]',	'Category of Information'	,156012	,'Category of Information',	1,	3,	1	,GETDATE(),	1,GETDATE())
END
IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156012 AND PlaceholderTag='[Comments]')
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag,	PlaceholderDisplayName,	PlaceholderGroupId,	PlaceholderDescription,	IsVisible,	DisplayOrder,CreatedBy,	CreatedOn,	ModifiedBy,	ModifiedOn)
	VALUES('[Comments]',	'Comments'	,156012	,'Comments',	1,	4,	1	,GETDATE(),	1,GETDATE())
END
IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156012 AND PlaceholderTag='[ReasonForSharingInformation]')
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag,	PlaceholderDisplayName,	PlaceholderGroupId,	PlaceholderDescription,	IsVisible,	DisplayOrder,CreatedBy,	CreatedOn,	ModifiedBy,	ModifiedOn)
	VALUES('[ReasonForSharingInformation]',	'Reason For Sharing Information'	,156012	,'Reason For Sharing Information',	1,	5,	1	,GETDATE(),	1,GETDATE())
END
IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156012 AND PlaceholderTag='[ModeOfSharingInformation]')
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag,	PlaceholderDisplayName,	PlaceholderGroupId,	PlaceholderDescription,	IsVisible,	DisplayOrder,CreatedBy,	CreatedOn,	ModifiedBy,	ModifiedOn)
	VALUES('[ModeOfSharingInformation]',	'Mode Of Sharing Information'	,156012	,'Mode Of Sharing Information',	1,	6,	1	,GETDATE(),	1,GETDATE())
END
IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156012 AND PlaceholderTag='[DateOfSharingInformation]')
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag,	PlaceholderDisplayName,	PlaceholderGroupId,	PlaceholderDescription,	IsVisible,	DisplayOrder,CreatedBy,	CreatedOn,	ModifiedBy,	ModifiedOn)
	VALUES('[DateOfSharingInformation]',	'Date Of Sharing Information'	,156012	,'Date Of Sharing Information',	1,	7,	1	,GETDATE(),	1,GETDATE())
END
IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156012 AND PlaceholderTag='[TimeOfSharingInformation]')
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag,	PlaceholderDisplayName,	PlaceholderGroupId,	PlaceholderDescription,	IsVisible,	DisplayOrder,CreatedBy,	CreatedOn,	ModifiedBy,	ModifiedOn)
	VALUES('[TimeOfSharingInformation]',	'Time Of Sharing Information'	,156012	,'Time Of Sharing Information',	1,	8,	1	,GETDATE(),	1,GETDATE())
END
IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156012 AND PlaceholderTag='[SharedByName]')
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag,	PlaceholderDisplayName,	PlaceholderGroupId,	PlaceholderDescription,	IsVisible,	DisplayOrder,CreatedBy,	CreatedOn,	ModifiedBy,	ModifiedOn)
	VALUES('[SharedByName]',	'Shared By Name'	,156012	,'Shared By Name',	1,	9,	1	,GETDATE(),	1,GETDATE())
END
IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156012 AND PlaceholderTag='[SharedByEmailID]')
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag,	PlaceholderDisplayName,	PlaceholderGroupId,	PlaceholderDescription,	IsVisible,	DisplayOrder,CreatedBy,	CreatedOn,	ModifiedBy,	ModifiedOn)
	VALUES('[SharedByEmailID]',	'Shared By Email ID'	,156012	,'Shared By Email ID',	1,	10,	1	,GETDATE(),	1,GETDATE())
END
IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156012 AND PlaceholderTag='[SharedByPAN]')
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag,	PlaceholderDisplayName,	PlaceholderGroupId,	PlaceholderDescription,	IsVisible,	DisplayOrder,CreatedBy,	CreatedOn,	ModifiedBy,	ModifiedOn)
	VALUES('[SharedByPAN]',	'Shared By PAN'	,156012	,'Shared By PAN',	1,	11,	1	,GETDATE(),	1,GETDATE())
END
IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156012 AND PlaceholderTag='[NameOfCompany]')
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag,	PlaceholderDisplayName,	PlaceholderGroupId,	PlaceholderDescription,	IsVisible,	DisplayOrder,CreatedBy,	CreatedOn,	ModifiedBy,	ModifiedOn)
	VALUES('[NameOfCompany]',	'Name Of Company'	,156012	,'Name Of Company',	1,	12,	1	,GETDATE(),	1,GETDATE())
END
IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156012 AND PlaceholderTag='[SharedWithName]')
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag,	PlaceholderDisplayName,	PlaceholderGroupId,	PlaceholderDescription,	IsVisible,	DisplayOrder,CreatedBy,	CreatedOn,	ModifiedBy,	ModifiedOn)
	VALUES('[SharedWithName]',	'Shared With Name'	,156012	,'Shared With Name',	1,	13,	1	,GETDATE(),	1,GETDATE())
END
IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156012 AND PlaceholderTag='[SharedWithEmailID]')
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag,	PlaceholderDisplayName,	PlaceholderGroupId,	PlaceholderDescription,	IsVisible,	DisplayOrder,CreatedBy,	CreatedOn,	ModifiedBy,	ModifiedOn)
	VALUES('[SharedWithEmailID]',	'Shared With Email ID'	,156012	,'Shared With Email ID',	1,	14,	1	,GETDATE(),	1,GETDATE())
END
IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156012 AND PlaceholderTag='[SharedWithPAN]')
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag,	PlaceholderDisplayName,	PlaceholderGroupId,	PlaceholderDescription,	IsVisible,	DisplayOrder,CreatedBy,	CreatedOn,	ModifiedBy,	ModifiedOn)
	VALUES('[SharedWithPAN]',	'Shared With PAN'	,156012	,'Shared With PAN',	1,	15,	1	,GETDATE(),	1,GETDATE())
END
IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156012 AND PlaceholderTag='[SharedWithNameOfCompany]')
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag,	PlaceholderDisplayName,	PlaceholderGroupId,	PlaceholderDescription,	IsVisible,	DisplayOrder,CreatedBy,	CreatedOn,	ModifiedBy,	ModifiedOn)
	VALUES('[SharedWithNameOfCompany]',	'Shared With Name Of Company'	,156012	,'Shared With Name Of Company',	1,	16,	1	,GETDATE(),	1,GETDATE())
END
IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156012 AND PlaceholderTag='[DateOfPublishing]')
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag,	PlaceholderDisplayName,	PlaceholderGroupId,	PlaceholderDescription,	IsVisible,	DisplayOrder,CreatedBy,	CreatedOn,	ModifiedBy,	ModifiedOn)
	VALUES('[DateOfPublishing]',	'Date Of Publishing'	,156012	,'Date Of Publishing',	1,	17,	1	,GETDATE(),	1,GETDATE())
END
IF NOT EXISTS(SELECT PlaceholderMasterId FROM com_PlaceholderMaster WHERE PlaceholderGroupId = 156012 AND PlaceholderTag='[NameOfTheUserWhoUpdatedThisInformation]')
BEGIN
	INSERT INTO com_PlaceholderMaster(PlaceholderTag,	PlaceholderDisplayName,	PlaceholderGroupId,	PlaceholderDescription,	IsVisible,	DisplayOrder,CreatedBy,	CreatedOn,	ModifiedBy,	ModifiedOn)
	VALUES('[NameOfTheUserWhoUpdatedThisInformation]',	'Name Of The User Who Updated This Information'	,156012	,'Name Of The User Who Updated This Information',	1,	18,	1	,GETDATE(),	1,GETDATE())
END