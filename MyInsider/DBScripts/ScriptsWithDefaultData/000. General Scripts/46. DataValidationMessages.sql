-- ======================================================================================================
-- Author      : Rutuja Purandare, Priyanka Wani
-- CREATED DATE: 20-FEB-2017
-- Description : Script for Data Validation Messages
-- ======================================================================================================
/*For UserInfo Model*/
/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50489)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50489,'usr_msg_50489','Please enter characters only','en-US',103002,104001,122004,'Please enter characters only',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50490)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50490,'usr_msg_50490','Please enter digits only','en-US',103002,104001,122004,'Please enter digits only',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50491)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50491,'usr_msg_50491','Special characters(*,<,>) are not allowed.','en-US',103002,104001,122004,'Special characters(*,<,>) are not allowed.',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50513)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50513,'dis_msg_50513','Special characters(*,<,>) are not allowed.','en-US',103009,104001,122052,'Special characters(*,<,>) are not allowed.',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50518)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50518,'dis_msg_50518','Please enter in correct format','en-US',103009,104001,122052,'Please enter in correct format',1,GETDATE())
END
/*For Role Model*/
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50492)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50492,'role_msg_50492','Please enter charachers only','en-US',103007,104001,122006,'Please enter charachers only',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50493)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50493,'role_msg_50493','Special characters(*,<,>) are not allowed.','en-US',103007,104001,122006,'Special characters(*,<,>) are not allowed.',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50494)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50494,'role_msg_50494','Please select status only','en-US',103007,104001,122006,'Please select status only',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50495)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50495,'role_msg_50495','Please select user type','en-US',103007,104001,122006,'Please select user type',1,GETDATE())
END

/*For Policy Document Model*/
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50496)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50496,'rul_msg_50496','Please enter alphanumerics only','en-US',103006,104001,122038,'Please enter alphanumerics only',1,GETDATE())
END

/*For Trading Policy model*/
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50497)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50497,'rul_msg_50497','Please enter alphanumerics only','en-US',103006,104001,122040,'Please enter alphanumerics only',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50498)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50498,'rul_msg_50498','Special characters(*,<,>) are not allowed.','en-US',103006,104001,122040,'Special characters(*,<,>) are not allowed.',1,GETDATE())
END

/*For Company model*/
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50501)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50501,'cmp_msg_50501','Please enter alphanumerics only','en-US',103005,104001,122012,'Please enter alphanumerics only',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50517)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50517,'cmp_msg_50517','Please enter correct ISIN Number.','en-US',103005,104001,122012,'Please enter correct ISIN Number.',1,GETDATE())
END
/*For ComCode Model*/
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50502)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50502,'mst_msg_50502','Special characters(*,<,>) are not allowed.','en-US',103004,104001,122014,'Special characters(*,<,>) are not allowed.',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50503)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50503,'mst_msg_50503','Special characters(*,<,>) are not allowed.','en-US',103004,104001,122014,'Special characters(*,<,>) are not allowed.',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50504)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50504,'mst_msg_50504','Please enter digits only','en-US',103004,104001,122014,'Please enter digits only',1,GETDATE())
END
/*For TransactionLetter Model*/
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50505)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50505,'dis_msg_50505','Special characters(*,<,>) are not allowed.','en-US',103009,104001,122052,'Special characters(*,<,>) are not allowed.',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50514)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50514,'dis_msg_50514','Please enter characters only','en-US',103009,104001,122052,'Please enter characters only',1,GETDATE())
END

/*For Communication Rule Master Model*/
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50515)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50515,'cmu_msg_50515','Please enter rule name.','en-US',103010,104001,122054,'Please enter rule name.',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50516)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50516,'cmu_msg_50516','Special characters(*,<,>) not allowed.','en-US',103010,104001,122054,'Special characters(*,<,>) not allowed.',1,GETDATE())
END

/*for trading Transaction model*/
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50519)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50519,'tra_msg_50519','Enter valid percentage of shares pre transaction','en-US',103006,104001,122040,'Enter valid percentage of shares pre transaction',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50520)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50520,'tra_msg_50520','please enter aplhanumeric.','en-US',103006,104001,122040,'please enter aplhanumeric.',1,GETDATE())
END

/*for DefaulterReportOverride Model*/
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50521)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50521,'rpt_msg_50521','Special characters(*,<,>) are not allowed','en-US',103011,104001,122074,'Special characters(*,<,>) are not allowed',1,GETDATE())
END

/*for DMATDetails Model*/
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50522)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50522,'usr_msg_50522','Please enter alphanumeric only.','en-US',103001,104001,122001,'Please enter alphanumeric only.',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50523)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50523,'usr_msg_50523','Please enter characters only.','en-US',103001,104001,122001,'Please enter characters only.',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50524)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50524,'usr_msg_50524','Special characters(*,<,>) are not allowed.','en-US',103001,104001,122001,'Special characters(*,<,>) are not allowed.',1,GETDATE())
END

/*for DocumentDetails Model*/
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50525)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50525,'usr_msg_50525','Please enter alphanumeric.','en-US',103002,104001,122010,'Please enter alphanumeric.',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50526)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50526,'usr_msg_50526','Special characters(*,<,>) are not allowed.','en-US',103002,104001,122010,'Special characters(*,<,>) are not allowed.',1,GETDATE())
END

/*For TemplateMaster Model*/
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50527)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50527,'tra_msg_50527','please select communication mode.','en-US',103008,104001,122050,'please select communication mode.',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50528)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50528,'tra_msg_50528','please select disclosure Type.','en-US',103008,104001,122050,'please select disclosure Type.',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50529)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50529,'tra_msg_50529','Please select letter for code Id','en-US',103008,104001,122050,'Please select letter for code Id',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50530)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50530,'tra_msg_50530','Please enter alphanumeric only.','en-US',103008,104001,122050,'Please enter alphanumeric only.',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50531)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50531,'tra_msg_50531','Special characters(<,>) are not allowed.','en-US',103008,104001,122050,'Special characters(<,>) are not allowed.',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50532)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50532,'tra_msg_50532','Please enter characters only.','en-US',103008,104001,122050,'Please enter characters only.',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50533)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50533,'tra_msg_50533','Please enter numbers only.','en-US',103008,104001,122050,'Please enter numbers only.',1,GETDATE())
END

/* ******************************************************************* */
/*For TemplateMaster Model*/
update mst_Resource set ResourceValue='Special characters(<,>) are not allowed.',OriginalResourceValue='Special characters(<,>) are not allowed.' 
where ResourceId=50531

/*for DocumentDetails Model*/
update mst_Resource set ResourceValue='Special characters(*,<,>) are not allowed.',OriginalResourceValue='Special characters(*,<,>) are not allowed.' 
where ResourceId=50526


/*for DMATDetails Model*/
update mst_Resource set ResourceValue='Special characters(*,<,>) are not allowed.',OriginalResourceValue='Special characters(*,<,>) are not allowed.' 
where ResourceId=50524

/*for DefaulterReportOverride Model*/
update mst_Resource set ResourceValue='Special characters(*,<,>) are not allowed.',OriginalResourceValue='Special characters(*,<,>) are not allowed.' 
where ResourceId=50521

/*For Communication Rule Master Model*/
update mst_Resource set ResourceValue='Special characters(*,<,>) are not allowed.',OriginalResourceValue='Special characters(*,<,>) are not allowed.' 
where ResourceId=50516

/*For TransactionLetter Model*/
update mst_Resource set ResourceValue='Special characters(*,<,>) are not allowed.',OriginalResourceValue='Special characters(*,<,>) are not allowed.' 
where ResourceId=50505

/*For ComCode Model*/
update mst_Resource set ResourceValue='Special characters(*,<,>) are not allowed.',OriginalResourceValue='Special characters(*,<,>) are not allowed.' 
where ResourceId=50502

update mst_Resource set ResourceValue='Special characters(*,<,>) are not allowed.',OriginalResourceValue='Special characters(*,<,>) are not allowed.' 
where ResourceId=50503

/*For Trading Policy model*/
update mst_Resource set ResourceValue='Special characters(*,<,>) are not allowed.',OriginalResourceValue='Special characters(*,<,>) are not allowed.' 
where ResourceId=50498

/*For Role Model*/
update mst_Resource set ResourceValue='Special characters(*,<,>) are not allowed.',OriginalResourceValue='Special characters(*,<,>) are not allowed.' 
where ResourceId=50493

/* INSERT INTO mst_Resource */
update mst_Resource set ResourceValue='Special characters(*,<,>) are not allowed.',OriginalResourceValue='Special characters(*,<,>) are not allowed.' 
where ResourceId=50491

update mst_Resource set ResourceValue='Special characters(*,<,>) are not allowed.',OriginalResourceValue='Special characters(*,<,>) are not allowed.' 
where ResourceId=50513