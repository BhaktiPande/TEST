-- ======================================================================================================
-- Author      : Shubhangi Gurude												=
-- CREATED DATE: 19-JuN-2017                                                 							=
-- Description : SCRIPTS To Add UPSI Declaration on preclearence form     												=
-- ======================================================================================================

/* INSERT INTO com_CodeGroup */
IF NOT EXISTS(SELECT CodeGroupID FROM com_CodeGroup WHERE CodeGroupID = 509)
BEGIN
	INSERT INTO com_CodeGroup(CodeGroupID, COdeGroupName, [Description], IsVisible, IsEditable, ParentCodeGroupId) 
	VALUES (509,'Add reason of pre clearence approval','Add reason of pre clearence approval',1,1,null)
END
GO

/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50551)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50551,'rul_lbl_50551','Reason for pre clearence approval to be provided','en-US',103006,104002,122040,'Reason for pre clearence approval to be provided',1,GETDATE())
END
GO

/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50552)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50552,'dis_lbl_50552','Reason for Approval','en-US',103009,104002,122051,'Reason for Approval',1,GETDATE())
END
GO

/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50550)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50550,'dis_lbl_50550','Description for Approval','en-US',103009,104002,122051,'Description for Approval',1,GETDATE())
END
GO