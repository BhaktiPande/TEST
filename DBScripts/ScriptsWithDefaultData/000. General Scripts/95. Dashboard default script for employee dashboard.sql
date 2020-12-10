-- ======================================================================================================
-- Author      : Samadhan Kadm																			=
-- CREATED DATE: 28-Nov-2016                                                 							=
-- Description : Dashboard default data																	=
-- ======================================================================================================


IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54186)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54186,'dis_btn_54186','Preclearance Requests','en-US',103008,104004,122083,'Preclearance Requests',1,GETDATE())
END


IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54187)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54187,'dis_btn_54187','Trade Details','en-US',103008,104004,122083,'Trade Details',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54188)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54188,'dis_lbl_54188','Own Securities Dashboard','en-US',103008,104002,122083,'Own Securities Dashboard',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54189)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54189,'dis_lbl_54189','Other Securities Dashboard','en-US',103008,104002,122083,'Other Securities Dashboard',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54190)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54190,'dis_lbl_54190','PCL Requested','en-US',103008,104002,122083,'PCL Requested',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54191)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54191,'dis_lbl_54191','Pending','en-US',103008,104002,122083,'Pending',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54192)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54192,'dis_lbl_54192','Rejected','en-US',103008,104002,122083,'Rejected',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54193)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54193,'dis_lbl_54193','Approved','en-US',103008,104002,122083,'Approved',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54194)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54194,'dis_lbl_54194','Submitted','en-US',103008,104002,122083,'Submitted',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54195)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54195,'dis_lbl_54195','Not Traded','en-US',103008,104002,122083,'Not Traded',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54196)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54196,'dis_lbl_54196','Pending','en-US',103008,104002,122083,'Pending',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54197)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54197,'dis_lbl_54197','Submitted','en-US',103008,104002,122083,'Submitted',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54198)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54198,'dis_lbl_54198','with Pre-clearance','en-US',103008,104002,122083,'with Pre-clearance',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54199)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54199,'dis_lbl_54199','without Pre-clearance','en-US',103008,104002,122083,'without Pre-clearance',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54200)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54200,'dis_btn_54200','View All','en-US',103008,104004,122083,'View All',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54201)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54201,'dis_btn_54201','View All','en-US',103008,104004,122083,'View All',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54202)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54202,'dis_btn_54202','View All','en-US',103008,104004,122083,'View All',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54203)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54203,'dis_btn_54203','View All','en-US',103008,104004,122083,'View All',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54204)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54204,'dis_lbl_54204','MAILS','en-US',103008,104002,122083,'MAILS',1,GETDATE())
END
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 54205)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (54205,'cmu_ttl_54205','Notification Details','en-US',103010,104006,122059,'Notification Details',1,GETDATE())
END


