IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 71001)
BEGIN
INSERT INTO mst_Resource (ResourceId,ResourceKey,ResourceValue,ResourceCulture,ModuleCodeId,CategoryCodeId,ScreenCodeId,OriginalResourceValue,ModifiedBy,ModifiedOn)
            VALUES (71001, 'dis_grd_71001','UPSI Recipient','en-US',103304,104003,122108,'UPSI Recipient',1,GETDATE())
END
