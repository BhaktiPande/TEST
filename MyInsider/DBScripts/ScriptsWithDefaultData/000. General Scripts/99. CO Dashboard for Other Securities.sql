-- ======================================================================================================
-- Author      : Samadhan Kadam																		=
-- CREATED DATE: 22-Jan-2020                                                 							=
-- Description : Script for Admin/CO Dashboard for OS                                               		 
-- ======================================================================================================

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54206)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54206,'dis_lbl_54206','Own Securities Dashboard','en-US',103008,104002,122074,'Own Securities Dashboard',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54207)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54207,'dis_lbl_54207','Other Securities Dashboard','en-US',103008,104002,122074,'Other Securities Dashboard',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54208)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54208,'tra_lbl_54208','Pending Transactions','en-US',103008,104002,122074,'Pending Transactions',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54209)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54209,'tra_lbl_54209','Insider','en-US',103008,104002,122074,'Insider',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54210)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54210,'tra_lbl_54210','Insider','en-US',103008,104002,122074,'Insider',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54211)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54211,'tra_lbl_54211','Personal Details Confirmation','en-US',103008,104002,122074,'Personal Details Confirmation',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54212)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54212,'tra_lbl_54212','Personal Details Reconfirmation','en-US',103008,104002,122074,'Personal Details Reconfirmation',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54213)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54213,'tra_lbl_54213','Initial Disclosures','en-US',103008,104002,122074,'Initial Disclosures',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54214)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54214,'tra_lbl_54214','Initial Disclosures-Relative','en-US',103008,104002,122074,'Initial Disclosures-Relative',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54215)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54215,'tra_lbl_54215','Pre Clearance','en-US',103008,104002,122074,'Pre Clearance',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54216)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54216,'tra_lbl_54216','Trade Details','en-US',103008,104002,122074,'Trade Details',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54217)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54217,'tra_lbl_54217','Period end Disclosures','en-US',103008,104002,122074,'Period end Disclosures',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54218)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54218,'tra_lbl_54218','Pending Activities For CO','en-US',103008,104002,122074,'Pending Activities For CO',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54219)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54219,'tra_lbl_54219','Pre clearance Approval','en-US',103008,104002,122074,'Pre clearance Approval',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54220)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54220,'tra_lbl_54220','Trading Policy due for Expiry','en-US',103008,104002,122074,'Trading Policy due for Expiry',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54221)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54221,'tra_lbl_54221','Policy Document due for Expiry','en-US',103008,104002,122074,'Policy Document due for Expiry',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54222)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54222,'tra_lbl_54222','Upcoming events in next 30 days','en-US',103008,104002,122074,'Upcoming events in next 30 days',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54223)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54223,'dis_lbl_54223','Quick Picks','en-US',103008,104002,122074,'Quick Picks',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54224)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54224,'dis_lbl_54224','Update Restricted List','en-US',103008,104002,122074,'Update Restricted List',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54225)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54225,'dis_lbl_54225','Mark User Separation','en-US',103008,104002,122074,'Mark User Separation',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54226)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54226,'dis_lbl_54226','Add Designated Persons','en-US',103008,104002,122074,'Add Designated Persons',1,GETDATE())
END


/* tra_CoDashboardCount : insert default count 0 for other Securities*/

--INSERT INTO tra_CoDashboardCount

--select 26 as DashboardCountId,'tra_lbl_54211' as ResourceKey,'Personal Details Confirmation' as FieldName,0 as Count,0 as Status,1 as ModifiedBy,GETDATE() as ModifiedOn
--union 
--select 27 as DashboardCountId,'tra_lbl_54212' as ResourceKey,'Personal Details Reconfirmation' as FieldName,0 as Count,0 as Status,1 as ModifiedBy,GETDATE() as ModifiedOn
--union 
--select 28 as DashboardCountId,'tra_lbl_54213' as ResourceKey,'Initial Disclosures' as FieldName,0 as Count,0 as Status,1 as ModifiedBy,GETDATE() as ModifiedOn
--union 
--select 29 as DashboardCountId,'tra_lbl_54214' as ResourceKey,'Initial Disclosures-Relative' as FieldName,0 as Count,0 as Status,1 as ModifiedBy,GETDATE() as ModifiedOn
--union 
--select 30 as DashboardCountId,'tra_lbl_54216' as ResourceKey,'Trade Details' as FieldName,0 as Count,0 as Status,1 as ModifiedBy,GETDATE() as ModifiedOn
--union 
--select 31 as DashboardCountId,'tra_lbl_54217' as ResourceKey,'Period end Disclosures' as FieldName,0 as Count,0 as Status,1 as ModifiedBy,GETDATE() as ModifiedOn
--union 
--select 32 as DashboardCountId,'tra_lbl_54219' as ResourceKey,'Pre clearance Approval' as FieldName,0 as Count,0 as Status,1 as ModifiedBy,GETDATE() as ModifiedOn
--union
--select 33 as DashboardCountId,'tra_lbl_54220' as ResourceKey,'Trading Policy due for Expiry' as FieldName,0 as Count,0 as Status,1 as ModifiedBy,GETDATE() as ModifiedOn
--union 
--select 34 as DashboardCountId,'tra_lbl_54221' as ResourceKey,'Policy Document due for Expiry' as FieldName,0 as Count,0 as Status,1 as ModifiedBy,GETDATE() as ModifiedOn


