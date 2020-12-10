-- ======================================================================================================
-- Author      : Tushar Wakchaure
-- CREATED DATE: 14-June-2019
-- Description : Script for label changes on Form C.
-- ======================================================================================================

IF EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 17127 AND ResourceKey = 'dis_lbl_17127')
BEGIN
	UPDATE mst_Resource SET ResourceValue = 'Signature', OriginalResourceValue = 'Signature' WHERE ResourceId = 17127 AND ResourceKey = 'dis_lbl_17127'
END

IF EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 17128 AND ResourceKey = 'dis_lbl_17128')
BEGIN
	UPDATE mst_Resource SET ResourceValue = 'Designation', OriginalResourceValue = 'Designation' WHERE ResourceId = 17128 AND ResourceKey = 'dis_lbl_17128'
END