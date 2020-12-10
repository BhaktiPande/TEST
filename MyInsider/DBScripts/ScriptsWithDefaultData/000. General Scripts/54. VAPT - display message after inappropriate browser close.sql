
-- ======================================================================================================
-- Author      : Shubhangi Gurude												=
-- CREATED DATE: 28-AUG-2017                                                 							=
-- Description : Scripts to display message for inappropriate browser close   												=
-- ======================================================================================================

IF NOT EXISTS (SELECT ResourceId FROM mst_Resource WHERE ResourceId=14027)
BEGIN
	INSERT INTO mst_Resource(ResourceId, ResourceKey, ResourceValue, ResourceCulture, ModuleCodeId, CategoryCodeId, ScreenCodeId, OriginalResourceValue, ModifiedBy, ModifiedOn)
	VALUES(14027,'com_lbl_14027','Your previous session was not properly closed. Please login after 20 minutes.','en-US','103003','104001','122034','Your previous session was not properly closed. Please login after 20 minutes.',1,GETDATE())
END
