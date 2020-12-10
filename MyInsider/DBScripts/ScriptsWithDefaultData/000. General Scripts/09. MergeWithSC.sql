/* 
Modified By		Modified On		Description  
Parag			01-Apr-2016		acid-url mapping for Transaction Module (period end)
*/
INSERT INTO usr_ActivityURLMapping
	(ActivityID, ControllerName, ActionName, ActionButtonName, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
VALUES
	-- Disclosure Details for CO - Period End Disclosure - Disclosure Details for CO - Period End Disclosure Submission
	(169, 'PeriodEndDisclosure', 'Summary', NULL, 1, GETDATE(), 1, GETDATE()), -- Period End disclosure summary page
	
	-- Disclosure Details for Insider - Period End Disclosure - Disclosure Details for Insider -  Period End Disclosure
	(159, 'PeriodEndDisclosure', 'Summary', NULL, 1, GETDATE(), 1, GETDATE()) -- Period End disclosure summary page

	
	
/*
Sent by : Raghvendra on Date: 5-Apr-2016
Updated the Menu name for "Continuous Disclosure" to "Preclearance & Continuous Disclosure" as per suggested by ED team. 
The menu changed is seen under Transaction Details for CO and Insider.
*/
UPDATE mst_MenuMaster SET MenuName = 'Preclearance & Continuous Disclosures', Description = 'Preclearance & Continuous Disclosures' WHERE MenuId in(27,30)	



/*
Added by : Raghvendra Date : 5-Apr-2016
Adding the override grids for Transaction data grids seen on the Create Letter screen.
*/
/*
Enter new grid types for Disclosure letters for CO and Insider
*/
INSERT INTO [dbo].[com_Code] ([CodeID] ,[CodeName] ,[CodeGroupId] ,[Description] ,[IsVisible] ,[IsActive] ,[DisplayOrder] ,[DisplayCode] ,[ParentCodeId] ,[ModifiedBy] ,[ModifiedOn])
VALUES 
(114083 ,'Trading transaction details for Letter - Continuous Disclosure - Insider' ,114 ,'Trading transaction details for Letter - Continuous Disclosure - Insider' ,1 ,1 ,83 ,NULL ,NULL ,1 ,GETDATE()),
(114084 ,'Trading transaction details for Letter - Period End Disclosure - Insider' ,114 ,'Trading transaction details for Letter - Period End Disclosure - Insider' ,1 ,1 ,84 ,NULL ,NULL ,1 ,GETDATE()),
(114085 ,'Trading transaction details for Letter - Initial Disclosure - CO' ,114,'Trading transaction details for Letter - Initial Disclosure - CO'  ,1 ,1 ,85 ,NULL ,NULL ,1 ,GETDATE()),
(114086 ,'Trading transaction details for Letter - Continuous Disclosure - CO' ,114 ,'Trading transaction details for Letter - Continuous Disclosure - CO'  ,1 ,1 ,86 ,NULL ,NULL ,1 ,GETDATE()),
(114087 ,'Trading transaction details for Letter - Period End Disclosure - CO' ,114 ,'Trading transaction details for Letter - Period End Disclosure - CO'  ,1 ,1 ,87 ,NULL ,NULL ,1 ,GETDATE()),
(114088 ,'Trading transaction details for Letter - Initial Disclosure - Insider' ,114 ,'Trading transaction details for Letter - Initial Disclosure - Insider'  ,1 ,1 ,88 ,NULL ,NULL ,1 ,GETDATE())

/*
Enter new screen codes for the Transaction Data for Letter screen
*/
INSERT INTO [dbo].[com_Code] ([CodeID] ,[CodeName] ,[CodeGroupId] ,[Description] ,[IsVisible] ,[IsActive] ,[DisplayOrder] ,[DisplayCode] ,[ParentCodeId] ,[ModifiedBy] ,[ModifiedOn])
VALUES 
(122077 ,'Trading transaction details for Letter - Continuous Disclosure - Insider' ,122 ,'Screen - Trading transaction details for Letter - Continuous Disclosure - Insider' ,1 ,1 ,89 ,NULL ,103008 ,1 ,GETDATE()),
(122078 ,'Trading transaction details for Letter - Period End Disclosure - Insider' ,122 ,'Screen - Trading transaction details for Letter - Period End Disclosure - Insider' ,1 ,1 ,90 ,NULL ,103008 ,1 ,GETDATE()),
(122079 ,'Trading transaction details for Letter - Initial Disclosure - CO' ,122,'Screen - Trading transaction details for Letter - Initial Disclosure - CO'  ,1 ,1 ,91 ,NULL ,103008 ,1 ,GETDATE()),
(122080 ,'Trading transaction details for Letter - Continuous Disclosure - CO' ,122 ,'Screen - Trading transaction details for Letter - Continuous Disclosure - CO'  ,1 ,1 ,92 ,NULL ,103008 ,1 ,GETDATE()),
(122081 ,'Trading transaction details for Letter - Period End Disclosure - CO' ,122 ,'Screen - Trading transaction details for Letter - Period End Disclosure - CO'  ,1 ,1 ,93 ,NULL ,103008 ,1 ,GETDATE()),
(122082 ,'Trading transaction details for Letter - Initial Disclosure - Insider' ,122 ,'Screen - Trading transaction details for Letter - Initial Disclosure - Insider'  ,1 ,1 ,94 ,NULL ,103008 ,1 ,GETDATE())


/*
Add column resources for each of the new grids added

Resources for grid type codeid 114083
*/
INSERT INTO mst_Resource
(ResourceId, ResourceKey, ResourceValue, OriginalResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, ModifiedBy, ModifiedOn)
VALUES 
(16333 ,'tra_grd_16333' ,'Name, Address, Mobile Number' ,'Name, Address, Mobile Number' , 'en-US',103008 ,104003 ,122077 ,1 ,GETDATE()),
(16334 ,'tra_grd_16334' ,'PAN' ,'PAN' , 'en-US',103008 ,104003 ,122077 ,1 ,GETDATE()),
(16335 ,'tra_grd_16335' ,'Relation with insider' ,'Relation with insider' , 'en-US',103008 ,104003 ,122077 ,1 ,GETDATE()),
(16336 ,'tra_grd_16336' ,'Demat A/c No.' ,'Demat A/c No.' , 'en-US',103008 ,104003 ,122077 ,1 ,GETDATE()),
(16337 ,'tra_grd_16337' ,'No of Shares/Voting rights acquired' ,'No of Shares/Voting rights acquired' , 'en-US',103008 ,104003 ,122077 ,1 ,GETDATE()),
(16338 ,'tra_grd_16338' ,'Security Type' ,'Security Type' , 'en-US',103008 ,104003 ,122077 ,1 ,GETDATE()),
(16339 ,'tra_grd_16339' ,'% of Shares/Voting rights acquired' ,'% of Shares/Voting rights acquired' , 'en-US',103008 ,104003 ,122077 ,1 ,GETDATE()),
(16340 ,'tra_grd_16340' ,'Date of Acquisition' ,'Date of Acquisition' , 'en-US',103008 ,104003 ,122077 ,1 ,GETDATE()),
(16341 ,'tra_grd_16341' ,'Date of Intimation to Company' ,'Date of Intimation to Company' , 'en-US',103008 ,104003 ,122077 ,1 ,GETDATE()),
(16342 ,'tra_grd_16342' ,'Mode of Acquisition' ,'Mode of Acquisition' , 'en-US',103008 ,104003 ,122077 ,1 ,GETDATE()),
(16343 ,'tra_grd_16343' ,'Shareholding Subsequent to Acqusition' ,'Shareholding Subsequent to Acqusition' , 'en-US',103008 ,104003 ,122077 ,1 ,GETDATE()),
(16344 ,'tra_grd_16344' ,'Registration number of TM' ,'Registration number of TM' , 'en-US',103008 ,104003 ,122077 ,1 ,GETDATE()),
(16345 ,'tra_grd_16345' ,'Exchange' ,'Exchange' , 'en-US',103008 ,104003 ,122077 ,1 ,GETDATE()),
(16346 ,'tra_grd_16346' ,'Transaction Type' ,'Transaction Type' , 'en-US',103008 ,104003 ,122077 ,1 ,GETDATE()),
(16347 ,'tra_grd_16347' ,'Qty' ,'Qty' , 'en-US',103008 ,104003 ,122077 ,1 ,GETDATE()),
(16348 ,'tra_grd_16348' ,'Value' ,'Value' , 'en-US',103008 ,104003 ,122077 ,1 ,GETDATE()),

/*
Resources for grid type codeid 114084
*/
(16349 ,'tra_grd_16349' ,'Name, Address, Mobile Number' ,'Name, Address, Mobile Number' , 'en-US',103008 ,104003 ,122078 ,1 ,GETDATE()),
(16350 ,'tra_grd_16350' ,'PAN' ,'PAN' , 'en-US',103008 ,104003 ,122078 ,1 ,GETDATE()),
(16351 ,'tra_grd_16351' ,'Relation with insider' ,'Relation with insider' , 'en-US',103008 ,104003 ,122078 ,1 ,GETDATE()),
(16352 ,'tra_grd_16352' ,'Demat A/c No.' ,'Demat A/c No.' , 'en-US',103008 ,104003 ,122078 ,1 ,GETDATE()),
(16353 ,'tra_grd_16353' ,'No of Shares/Voting rights acquired' ,'No of Shares/Voting rights acquired' , 'en-US',103008 ,104003 ,122078 ,1 ,GETDATE()),
(16354 ,'tra_grd_16354' ,'Security Type' ,'Security Type' , 'en-US',103008 ,104003 ,122078 ,1 ,GETDATE()),
(16355 ,'tra_grd_16355' ,'% of Shares/Voting rights acquired' ,'% of Shares/Voting rights acquired' , 'en-US',103008 ,104003 ,122078 ,1 ,GETDATE()),
(16356 ,'tra_grd_16356' ,'Date of Acquisition' ,'Date of Acquisition' , 'en-US',103008 ,104003 ,122078 ,1 ,GETDATE()),
(16357 ,'tra_grd_16357' ,'Date of Intimation to Company' ,'Date of Intimation to Company' , 'en-US',103008 ,104003 ,122078 ,1 ,GETDATE()),
(16358 ,'tra_grd_16358' ,'Mode of Acquisition' ,'Mode of Acquisition' , 'en-US',103008 ,104003 ,122078 ,1 ,GETDATE()),
(16359 ,'tra_grd_16359' ,'Shareholding Subsequent to Acqusition' ,'Shareholding Subsequent to Acqusition' , 'en-US',103008 ,104003 ,122078 ,1 ,GETDATE()),
(16360 ,'tra_grd_16360' ,'Registration number of TM' ,'Registration number of TM' , 'en-US',103008 ,104003 ,122078 ,1 ,GETDATE()),
(16361 ,'tra_grd_16361' ,'Exchange' ,'Exchange' , 'en-US',103008 ,104003 ,122078 ,1 ,GETDATE()),
(16362 ,'tra_grd_16362' ,'Transaction Type' ,'Transaction Type' , 'en-US',103008 ,104003 ,122078 ,1 ,GETDATE()),
(16363 ,'tra_grd_16363' ,'Qty' ,'Qty' , 'en-US',103008 ,104003 ,122078 ,1 ,GETDATE()),
(16364 ,'tra_grd_16364' ,'Value' ,'Value' , 'en-US',103008 ,104003 ,122078 ,1 ,GETDATE()),

/*
Resources for grid type codeid 114085
*/
(16365 ,'tra_grd_16365' ,'Name, Address, Mobile Number' ,'Name, Address, Mobile Number' , 'en-US',103008 ,104003 ,122079 ,1 ,GETDATE()),
(16366 ,'tra_grd_16366' ,'PAN' ,'PAN' , 'en-US',103008 ,104003 ,122079 ,1 ,GETDATE()),
(16367 ,'tra_grd_16367' ,'Relation with insider' ,'Relation with insider' , 'en-US',103008 ,104003 ,122079 ,1 ,GETDATE()),
(16368 ,'tra_grd_16368' ,'Demat A/c No.' ,'Demat A/c No.' , 'en-US',103008 ,104003 ,122079 ,1 ,GETDATE()),
(16369 ,'tra_grd_16369' ,'No of Shares/Voting rights acquired' ,'No of Shares/Voting rights acquired' , 'en-US',103008 ,104003 ,122079 ,1 ,GETDATE()),
(16370 ,'tra_grd_16370' ,'Security Type' ,'Security Type' , 'en-US',103008 ,104003 ,122079 ,1 ,GETDATE()),
(16371 ,'tra_grd_16371' ,'% of Shares/Voting rights acquired' ,'% of Shares/Voting rights acquired' , 'en-US',103008 ,104003 ,122079 ,1 ,GETDATE()),
(16372 ,'tra_grd_16372' ,'Date of Acquisition' ,'Date of Acquisition' , 'en-US',103008 ,104003 ,122079 ,1 ,GETDATE()),
(16373 ,'tra_grd_16373' ,'Date of Intimation to Company' ,'Date of Intimation to Company' , 'en-US',103008 ,104003 ,122079 ,1 ,GETDATE()),
(16374 ,'tra_grd_16374' ,'Mode of Acquisition' ,'Mode of Acquisition' , 'en-US',103008 ,104003 ,122079 ,1 ,GETDATE()),
(16375 ,'tra_grd_16375' ,'Shareholding Subsequent to Acqusition' ,'Shareholding Subsequent to Acqusition' , 'en-US',103008 ,104003 ,122079 ,1 ,GETDATE()),
(16376 ,'tra_grd_16376' ,'Registration number of TM' ,'Registration number of TM' , 'en-US',103008 ,104003 ,122079 ,1 ,GETDATE()),
(16377 ,'tra_grd_16377' ,'Exchange' ,'Exchange' , 'en-US',103008 ,104003 ,122079 ,1 ,GETDATE()),
(16378 ,'tra_grd_16378' ,'Transaction Type' ,'Transaction Type' , 'en-US',103008 ,104003 ,122079 ,1 ,GETDATE()),
(16379 ,'tra_grd_16379' ,'Qty' ,'Qty' , 'en-US',103008 ,104003 ,122079 ,1 ,GETDATE()),
(16380 ,'tra_grd_16380' ,'Value' ,'Value' , 'en-US',103008 ,104003 ,122079 ,1 ,GETDATE()),

/*
Resources for grid type codeid 114086
*/
(16381 ,'tra_grd_16381' ,'Name, Address, Mobile Number' ,'Name, Address, Mobile Number' , 'en-US',103008 ,104003 ,122080 ,1 ,GETDATE()),
(16382 ,'tra_grd_16382' ,'PAN' ,'PAN' , 'en-US',103008 ,104003 ,122080 ,1 ,GETDATE()),
(16383 ,'tra_grd_16383' ,'Relation with insider' ,'Relation with insider' , 'en-US',103008 ,104003 ,122080 ,1 ,GETDATE()),
(16384 ,'tra_grd_16384' ,'Demat A/c No.' ,'Demat A/c No.' , 'en-US',103008 ,104003 ,122080 ,1 ,GETDATE()),
(16385 ,'tra_grd_16385' ,'No of Shares/Voting rights acquired' ,'No of Shares/Voting rights acquired' , 'en-US',103008 ,104003 ,122080 ,1 ,GETDATE()),
(16386 ,'tra_grd_16386' ,'Security Type' ,'Security Type' , 'en-US',103008 ,104003 ,122080 ,1 ,GETDATE()),
(16387 ,'tra_grd_16387' ,'% of Shares/Voting rights acquired' ,'% of Shares/Voting rights acquired' , 'en-US',103008 ,104003 ,122080 ,1 ,GETDATE()),
(16388 ,'tra_grd_16388' ,'Date of Acquisition' ,'Date of Acquisition' , 'en-US',103008 ,104003 ,122080 ,1 ,GETDATE()),
(16389 ,'tra_grd_16389' ,'Date of Intimation to Company' ,'Date of Intimation to Company' , 'en-US',103008 ,104003 ,122080 ,1 ,GETDATE()),
(16390 ,'tra_grd_16390' ,'Mode of Acquisition' ,'Mode of Acquisition' , 'en-US',103008 ,104003 ,122080 ,1 ,GETDATE()),
(16391 ,'tra_grd_16391' ,'Shareholding Subsequent to Acqusition' ,'Shareholding Subsequent to Acqusition' , 'en-US',103008 ,104003 ,122080 ,1 ,GETDATE()),
(16392 ,'tra_grd_16392' ,'Registration number of TM' ,'Registration number of TM' , 'en-US',103008 ,104003 ,122080 ,1 ,GETDATE()),
(16393 ,'tra_grd_16393' ,'Exchange' ,'Exchange' , 'en-US',103008 ,104003 ,122080 ,1 ,GETDATE()),
(16394 ,'tra_grd_16394' ,'Transaction Type' ,'Transaction Type' , 'en-US',103008 ,104003 ,122080 ,1 ,GETDATE()),
(16395 ,'tra_grd_16395' ,'Qty' ,'Qty' , 'en-US',103008 ,104003 ,122080 ,1 ,GETDATE()),
(16396 ,'tra_grd_16396' ,'Value' ,'Value' , 'en-US',103008 ,104003 ,122080 ,1 ,GETDATE()),

/*
Resources for grid type codeid 114087
*/
(16397 ,'tra_grd_16397' ,'Name, Address, Mobile Number' ,'Name, Address, Mobile Number' , 'en-US',103008 ,104003 ,122081 ,1 ,GETDATE()),
(16398 ,'tra_grd_16398' ,'PAN' ,'PAN' , 'en-US',103008 ,104003 ,122081 ,1 ,GETDATE()),
(16399 ,'tra_grd_16399' ,'Relation with insider' ,'Relation with insider' , 'en-US',103008 ,104003 ,122081 ,1 ,GETDATE()),
(16400 ,'tra_grd_16400' ,'Demat A/c No.' ,'Demat A/c No.' , 'en-US',103008 ,104003 ,122081 ,1 ,GETDATE()),
(16401 ,'tra_grd_16401' ,'No of Shares/Voting rights acquired' ,'No of Shares/Voting rights acquired' , 'en-US',103008 ,104003 ,122081 ,1 ,GETDATE()),
(16402 ,'tra_grd_16402' ,'Security Type' ,'Security Type' , 'en-US',103008 ,104003 ,122081 ,1 ,GETDATE()),
(16403 ,'tra_grd_16403' ,'% of Shares/Voting rights acquired' ,'% of Shares/Voting rights acquired' , 'en-US',103008 ,104003 ,122081 ,1 ,GETDATE()),
(16404 ,'tra_grd_16404' ,'Date of Acquisition' ,'Date of Acquisition' , 'en-US',103008 ,104003 ,122081 ,1 ,GETDATE()),
(16405 ,'tra_grd_16405' ,'Date of Intimation to Company' ,'Date of Intimation to Company' , 'en-US',103008 ,104003 ,122081 ,1 ,GETDATE()),
(16406 ,'tra_grd_16406' ,'Mode of Acquisition' ,'Mode of Acquisition' , 'en-US',103008 ,104003 ,122081 ,1 ,GETDATE()),
(16407 ,'tra_grd_16407' ,'Shareholding Subsequent to Acqusition' ,'Shareholding Subsequent to Acqusition' , 'en-US',103008 ,104003 ,122081 ,1 ,GETDATE()),
(16408 ,'tra_grd_16408' ,'Registration number of TM' ,'Registration number of TM' , 'en-US',103008 ,104003 ,122081 ,1 ,GETDATE()),
(16409 ,'tra_grd_16409' ,'Exchange' ,'Exchange' , 'en-US',103008 ,104003 ,122081 ,1 ,GETDATE()),
(16410 ,'tra_grd_16410' ,'Transaction Type' ,'Transaction Type' , 'en-US',103008 ,104003 ,122081 ,1 ,GETDATE()),
(16411 ,'tra_grd_16411' ,'Qty' ,'Qty' , 'en-US',103008 ,104003 ,122081 ,1 ,GETDATE()),
(16412 ,'tra_grd_16412' ,'Value' ,'Value' , 'en-US',103008 ,104003 ,122081 ,1 ,GETDATE()),

/*
Resources for grid type codeid 114088
*/
(16413 ,'tra_grd_16413' ,'Name, Address, Mobile Number' ,'Name, Address, Mobile Number' , 'en-US',103008 ,104003 ,122082 ,1 ,GETDATE()),
(16414 ,'tra_grd_16414' ,'PAN' ,'PAN' , 'en-US',103008 ,104003 ,122082 ,1 ,GETDATE()),
(16415 ,'tra_grd_16415' ,'Relation with insider' ,'Relation with insider' , 'en-US',103008 ,104003 ,122082 ,1 ,GETDATE()),
(16416 ,'tra_grd_16416' ,'Demat A/c No.' ,'Demat A/c No.' , 'en-US',103008 ,104003 ,122082 ,1 ,GETDATE()),
(16417 ,'tra_grd_16417' ,'No of Shares/Voting rights acquired' ,'No of Shares/Voting rights acquired' , 'en-US',103008 ,104003 ,122082 ,1 ,GETDATE()),
(16418 ,'tra_grd_16418' ,'Security Type' ,'Security Type' , 'en-US',103008 ,104003 ,122082 ,1 ,GETDATE()),
(16419 ,'tra_grd_16419' ,'% of Shares/Voting rights acquired' ,'% of Shares/Voting rights acquired' , 'en-US',103008 ,104003 ,122082 ,1 ,GETDATE()),
(16420 ,'tra_grd_16420' ,'Date of Acquisition' ,'Date of Acquisition' , 'en-US',103008 ,104003 ,122082 ,1 ,GETDATE()),
(16421 ,'tra_grd_16421' ,'Date of Intimation to Company' ,'Date of Intimation to Company' , 'en-US',103008 ,104003 ,122082 ,1 ,GETDATE()),
(16422 ,'tra_grd_16422' ,'Mode of Acquisition' ,'Mode of Acquisition' , 'en-US',103008 ,104003 ,122082 ,1 ,GETDATE()),
(16423 ,'tra_grd_16423' ,'Shareholding Subsequent to Acqusition' ,'Shareholding Subsequent to Acqusition' , 'en-US',103008 ,104003 ,122082 ,1 ,GETDATE()),
(16424 ,'tra_grd_16424' ,'Registration number of TM' ,'Registration number of TM' , 'en-US',103008 ,104003 ,122082 ,1 ,GETDATE()),
(16425 ,'tra_grd_16425' ,'Exchange' ,'Exchange' , 'en-US',103008 ,104003 ,122082 ,1 ,GETDATE()),
(16426 ,'tra_grd_16426' ,'Transaction Type' ,'Transaction Type' , 'en-US',103008 ,104003 ,122082 ,1 ,GETDATE()),
(16427 ,'tra_grd_16427' ,'Qty' ,'Qty' , 'en-US',103008 ,104003 ,122082 ,1 ,GETDATE()),
(16428 ,'tra_grd_16428' ,'Value' ,'Value' , 'en-US',103008 ,104003 ,122082 ,1 ,GETDATE()),
/*
Add resource for default Trading Transaction grid
*/
(16429 ,'tra_grd_16429' ,'Security Type' ,'Security Type' , 'en-US',103008 ,104003 ,122036 ,1 ,GETDATE())


/*Map the resources with the grid and the Overriden grid*/
INSERT INTO com_GridHeaderSetting (GridTypeCodeId,ResourceKey,OverrideGridTypeCodeId,IsVisible,SequenceNumber,ColumnWidth,ColumnAlignment,OverrideResourceKey)
values
/*
Add security type column to default transaction grid i.e. 114031
*/
(114031,'tra_grd_16429',NULL,1,0,0,155001,NULL),

/*
For grid type code id 114083
*/
(114031,'tra_grd_16001',114083,1,0,0,155001,'tra_grd_16333'),
(114031,'tra_grd_16002',114083,1,1,0,155001,'tra_grd_16334'),
(114031,'tra_grd_16003',114083,1,2,0,155001,'tra_grd_16335'),
(114031,'tra_grd_16004',114083,1,3,0,155001,'tra_grd_16336'),
(114031,'tra_grd_16005',114083,1,4,0,155001,'tra_grd_16337'),
(114031,'tra_grd_16429',114083,1,5,0,155001,'tra_grd_16338'),
(114031,'tra_grd_16006',114083,1,6,0,155001,'tra_grd_16339'),
(114031,'tra_grd_16007',114083,1,7,0,155001,'tra_grd_16340'),
(114031,'tra_grd_16008',114083,1,8,0,155001,'tra_grd_16341'),
(114031,'tra_grd_16009',114083,1,9,0,155001,'tra_grd_16342'),
(114031,'tra_grd_16010',114083,1,10,0,155001,'tra_grd_16343'),
(114031,'tra_grd_16011',114083,1,11,0,155001,'tra_grd_16344'),
(114031,'tra_grd_16012',114083,1,12,0,155001,'tra_grd_16345'),
(114031,'tra_grd_16013',114083,1,13,0,155001,'tra_grd_16346'),
(114031,'tra_grd_16014',114083,1,14,0,155001,'tra_grd_16347'),
(114031,'tra_grd_16015',114083,1,15,0,155001,'tra_grd_16348'),

/*
For grid type code id 114084
*/
(114031,'tra_grd_16001',114084,1,0,0,155001,'tra_grd_16349'),
(114031,'tra_grd_16002',114084,1,1,0,155001,'tra_grd_16350'),
(114031,'tra_grd_16003',114084,1,2,0,155001,'tra_grd_16351'),
(114031,'tra_grd_16004',114084,1,3,0,155001,'tra_grd_16352'),
(114031,'tra_grd_16005',114084,1,4,0,155001,'tra_grd_16353'),
(114031,'tra_grd_16429',114084,1,5,0,155001,'tra_grd_16354'),
(114031,'tra_grd_16006',114084,1,6,0,155001,'tra_grd_16355'),
(114031,'tra_grd_16007',114084,1,7,0,155001,'tra_grd_16356'),
(114031,'tra_grd_16008',114084,1,8,0,155001,'tra_grd_16357'),
(114031,'tra_grd_16009',114084,1,9,0,155001,'tra_grd_16358'),
(114031,'tra_grd_16010',114084,1,10,0,155001,'tra_grd_16359'),
(114031,'tra_grd_16011',114084,1,11,0,155001,'tra_grd_16360'),
(114031,'tra_grd_16012',114084,1,12,0,155001,'tra_grd_16361'),
(114031,'tra_grd_16013',114084,1,13,0,155001,'tra_grd_16362'),
(114031,'tra_grd_16014',114084,1,14,0,155001,'tra_grd_16363'),
(114031,'tra_grd_16015',114084,1,15,0,155001,'tra_grd_16364'),


/*
For grid type code id 114085
*/
(114031,'tra_grd_16001',114085,1,0,0,155001,'tra_grd_16365'),
(114031,'tra_grd_16002',114085,1,1,0,155001,'tra_grd_16366'),
(114031,'tra_grd_16003',114085,1,2,0,155001,'tra_grd_16367'),
(114031,'tra_grd_16004',114085,1,3,0,155001,'tra_grd_16368'),
(114031,'tra_grd_16005',114085,1,4,0,155001,'tra_grd_16369'),
(114031,'tra_grd_16429',114085,1,5,0,155001,'tra_grd_16370'),
(114031,'tra_grd_16006',114085,1,6,0,155001,'tra_grd_16371'),
(114031,'tra_grd_16007',114085,1,7,0,155001,'tra_grd_16372'),
(114031,'tra_grd_16008',114085,1,8,0,155001,'tra_grd_16373'),
(114031,'tra_grd_16009',114085,1,9,0,155001,'tra_grd_16374'),
(114031,'tra_grd_16010',114085,1,10,0,155001,'tra_grd_16375'),
(114031,'tra_grd_16011',114085,1,11,0,155001,'tra_grd_16376'),
(114031,'tra_grd_16012',114085,1,12,0,155001,'tra_grd_16377'),
(114031,'tra_grd_16013',114085,1,13,0,155001,'tra_grd_16378'),
(114031,'tra_grd_16014',114085,1,14,0,155001,'tra_grd_16379'),
(114031,'tra_grd_16015',114085,1,15,0,155001,'tra_grd_16380'),

/*
For grid type code id 114086
*/
(114031,'tra_grd_16001',114086,1,0,0,155001,'tra_grd_16381'),
(114031,'tra_grd_16002',114086,1,1,0,155001,'tra_grd_16382'),
(114031,'tra_grd_16003',114086,1,2,0,155001,'tra_grd_16383'),
(114031,'tra_grd_16004',114086,1,3,0,155001,'tra_grd_16384'),
(114031,'tra_grd_16005',114086,1,4,0,155001,'tra_grd_16385'),
(114031,'tra_grd_16429',114086,1,5,0,155001,'tra_grd_16386'),
(114031,'tra_grd_16006',114086,1,6,0,155001,'tra_grd_16387'),
(114031,'tra_grd_16007',114086,1,7,0,155001,'tra_grd_16388'),
(114031,'tra_grd_16008',114086,1,8,0,155001,'tra_grd_16389'),
(114031,'tra_grd_16009',114086,1,9,0,155001,'tra_grd_16390'),
(114031,'tra_grd_16010',114086,1,10,0,155001,'tra_grd_16391'),
(114031,'tra_grd_16011',114086,1,11,0,155001,'tra_grd_16392'),
(114031,'tra_grd_16012',114086,1,12,0,155001,'tra_grd_16393'),
(114031,'tra_grd_16013',114086,1,13,0,155001,'tra_grd_16394'),
(114031,'tra_grd_16014',114086,1,14,0,155001,'tra_grd_16395'),
(114031,'tra_grd_16015',114086,1,15,0,155001,'tra_grd_16396'),

/*
For grid type code id 114087
*/
(114031,'tra_grd_16001',114087,1,0,0,155001,'tra_grd_16397'),
(114031,'tra_grd_16002',114087,1,1,0,155001,'tra_grd_16398'),
(114031,'tra_grd_16003',114087,1,2,0,155001,'tra_grd_16399'),
(114031,'tra_grd_16004',114087,1,3,0,155001,'tra_grd_16400'),
(114031,'tra_grd_16005',114087,1,4,0,155001,'tra_grd_16401'),
(114031,'tra_grd_16429',114087,1,5,0,155001,'tra_grd_16402'),
(114031,'tra_grd_16006',114087,1,6,0,155001,'tra_grd_16403'),
(114031,'tra_grd_16007',114087,1,7,0,155001,'tra_grd_16404'),
(114031,'tra_grd_16008',114087,1,8,0,155001,'tra_grd_16405'),
(114031,'tra_grd_16009',114087,1,9,0,155001,'tra_grd_16406'),
(114031,'tra_grd_16010',114087,1,10,0,155001,'tra_grd_16407'),
(114031,'tra_grd_16011',114087,1,11,0,155001,'tra_grd_16408'),
(114031,'tra_grd_16012',114087,1,12,0,155001,'tra_grd_16409'),
(114031,'tra_grd_16013',114087,1,13,0,155001,'tra_grd_16410'),
(114031,'tra_grd_16014',114087,1,14,0,155001,'tra_grd_16411'),
(114031,'tra_grd_16015',114087,1,15,0,155001,'tra_grd_16412'),

/*
For grid type code id 114088
*/
(114031,'tra_grd_16001',114088,1,0,0,155001,'tra_grd_16413'),
(114031,'tra_grd_16002',114088,1,1,0,155001,'tra_grd_16414'),
(114031,'tra_grd_16003',114088,1,2,0,155001,'tra_grd_16415'),
(114031,'tra_grd_16004',114088,1,3,0,155001,'tra_grd_16416'),
(114031,'tra_grd_16005',114088,1,4,0,155001,'tra_grd_16417'),
(114031,'tra_grd_16429',114088,1,5,0,155001,'tra_grd_16418'),
(114031,'tra_grd_16006',114088,1,6,0,155001,'tra_grd_16419'),
(114031,'tra_grd_16007',114088,1,7,0,155001,'tra_grd_16420'),
(114031,'tra_grd_16008',114088,1,8,0,155001,'tra_grd_16421'),
(114031,'tra_grd_16009',114088,1,9,0,155001,'tra_grd_16422'),
(114031,'tra_grd_16010',114088,1,10,0,155001,'tra_grd_16423'),
(114031,'tra_grd_16011',114088,1,11,0,155001,'tra_grd_16424'),
(114031,'tra_grd_16012',114088,1,12,0,155001,'tra_grd_16425'),
(114031,'tra_grd_16013',114088,1,13,0,155001,'tra_grd_16426'),
(114031,'tra_grd_16014',114088,1,14,0,155001,'tra_grd_16427'),
(114031,'tra_grd_16015',114088,1,15,0,155001,'tra_grd_16428')


UPDATE tra_TransactionDetails SET DateOfAcquisition = CONVERT(DATE,DateOfAcquisition) WHERE DateOfAcquisition IS  NOT NULL
