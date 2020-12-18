IF NOT EXISTS(SELECT ResourceKey FROM com_GridHeaderSetting WHERE ResourceKey = 'dis_grd_71001' and GridTypeCodeId=114122)
BEGIN
INSERT INTO com_GridHeaderSetting (GridTypeCodeId, ResourceKey, IsVisible, SequenceNumber, ColumnWidth, ColumnAlignment,OverrideGridTypeCodeId, OverrideResourceKey)
            VALUES (114122, 'dis_grd_71001', 1, 12, 0, 155001, NULL,NULL)
END