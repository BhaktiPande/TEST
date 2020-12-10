-- ======================================================================================================
-- Author      : Gaurav Ugale																			=
-- CREATED DATE: 16-DEC-2016                                                 							=
-- Description : KOTAK OBSERVATION ISSUE																=
-- ======================================================================================================

IF NOT EXISTS(SELECT ActivityID FROM usr_ActivityURLMapping WHERE ActivityID = 177 AND ControllerName = 'TemplateMaster' AND ActionName = 'SaveAction')
BEGIN
	INSERT INTO usr_ActivityURLMapping(ActivityID, ControllerName, ActionName, ActionButtonName, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
	VALUES (177,'TemplateMaster','SaveAction',null,1,GETDATE(),1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50384)
BEGIN
	INSERT INTO mst_Resource(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES(50384,'usr_lbl_50384','TMID','en-US',103002,104002,122008,'TMID',1,GETDATE())
END