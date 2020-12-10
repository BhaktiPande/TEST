-- ======================================================================================================
-- Author      : Priyanka Bhangale, Rutuja Purandare													=
-- CREATED DATE: 29-DEC-2016                                                 							=
-- Description : SCRIPTS FOR FORM G     												                =
-- ======================================================================================================

/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50442)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50442,'dis_grd_50442','Name,PAN,CIN/DIN,& address with contact nos.','en-US',103009,104003,122052,'Name,PAN,CIN/DIN,& address with contact nos.',1,GETDATE())
END

/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50388)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50388,'dis_grd_50388','Category of Person (Promoters/ KMP/ Directors/ immediate relative to/ others etc.)','en-US',103009,104003,122052,'Category of Person (Promo ters/ KMP/ Directors/ immediate relative to/ others etc.)',1,GETDATE())
END

/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50389)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50389,'dis_grd_50389','Holding at the beginning of the period','en-US',103009,104003,122052,'Holding at the beginning of the period',1,GETDATE())
END

/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50390)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50390,'dis_grd_50390','Type of security (For eg. Shares, Warrants, Convertibl e Debenture s etc.)','en-US',103009,104003,122052,'Type of security (For eg. Shares, Warrants, Convertibl e Debenture s etc.)',1,GETDATE())
END

/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50391)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50391,'dis_grd_50391','No. and % of shareholding','en-US',103009,104003,122052,'No. and % of shareholding',1,GETDATE())
END

/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50392)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50392,'dis_grd_50392','Securities acquired/ disposed during the period','en-US',103009,104003,122052,'Securities acquired/ disposed during the period',1,GETDATE())
END

/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50393)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50393,'dis_grd_50393','Buy Qty','en-US',103009,104003,122052,'Buy Qty',1,GETDATE())
END

/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50394)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50394,'dis_grd_50394','Sell Qty','en-US',103009,104003,122052,'Sell Qty',1,GETDATE())
END

/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50395)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50395,'dis_grd_50395','Holding at the end of the period','en-US',103009,104003,122052,'Holding at the end of the period',1,GETDATE())
END

/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50396)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50396,'dis_grd_50396','Type of security (For eg. Shares, Warrants, Convertibl e Debenture s etc.)','en-US',103009,104003,122052,'Type of security (For eg. Shares, Warrants, Convertibl e Debenture s etc.)',1,GETDATE())
END

/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50397)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50397,'dis_grd_50397','No. and % of shareholding','en-US',103009,104003,122052,'No. and % of shareholding',1,GETDATE())
END

/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50398)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50398,'dis_grd_50398','Date of intimation to company','en-US',103009,104003,122052,'Date of intimation to company',1,GETDATE())
END

/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50399)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50399,'dis_grd_50399','No. of Securities Pledge at the period','en-US',103009,104003,122052,'No. of Securities Pledge at the period',1,GETDATE())
END

/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50400)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50400,'dis_grd_50400','No. of Securities Pledge during the period','en-US',103009,104003,122052,'No. of Securities Pledge during the period',1,GETDATE())
END

/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50401)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50401,'dis_grd_50401','No. of Securities Unpledge during the period','en-US',103009,104003,122052,'No. of Securities Unpledge during the period',1,GETDATE())
END

/* INSERT INTO com_Code */
IF NOT EXISTS(SELECT CodeID FROM com_Code WHERE CodeID = 507003)
BEGIN
	INSERT INTO com_Code(CodeID,CodeName, CodeGroupId, [Description], IsVisible, IsActive, DisplayOrder, DisplayCode, ParentCodeId, ModifiedBy, ModifiedOn) 
	VALUES (507003,'Period end disclosure data for letter for Employee Insider Grid2',185,'Period end disclosure data for letter for Employee Insider Grid2',1,1,2,null,null,1,GETDATE())
END

/* INSERT INTO com_Code */
IF NOT EXISTS(SELECT CodeID FROM com_Code WHERE CodeID = 507004)
BEGIN
	INSERT INTO com_Code(CodeID,CodeName, CodeGroupId, [Description], IsVisible, IsActive, DisplayOrder, DisplayCode, ParentCodeId, ModifiedBy, ModifiedOn) 
	VALUES (507004,'Period end disclosure data for letter for Employee Insider Grid1',185,'Period end disclosure data for letter for Employee Insider Grid1',1,1,2,null,null,1,GETDATE())
END

/*INSERT INTO com_GridHeaderSetting */
IF NOT EXISTS(SELECT [ResourceKey] FROM com_GridHeaderSetting WHERE [ResourceKey] = 'dis_grd_50442')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES(507004,'dis_grd_50442',1,10000,0,155001,NULL,NULL)
END

/*INSERT INTO com_GridHeaderSetting */
IF NOT EXISTS(SELECT [ResourceKey] FROM com_GridHeaderSetting WHERE [ResourceKey] = 'dis_grd_50388')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES(507004,'dis_grd_50388',1,20000,0,155001,NULL,NULL)
END

/*INSERT INTO com_GridHeaderSetting */
IF NOT EXISTS(SELECT [ResourceKey] FROM com_GridHeaderSetting WHERE [ResourceKey] = 'dis_grd_50389')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES(507004,'dis_grd_50389',1,30000,0,155001,NULL,NULL)
END

/*INSERT INTO com_GridHeaderSetting */
IF NOT EXISTS(SELECT [ResourceKey] FROM com_GridHeaderSetting WHERE [ResourceKey] = 'dis_grd_50390')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES(507004,'dis_grd_50390',1,40003,0,155001,NULL,NULL)
END

/*INSERT INTO com_GridHeaderSetting */
IF NOT EXISTS(SELECT [ResourceKey] FROM com_GridHeaderSetting WHERE [ResourceKey] = 'dis_grd_50391')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES(507004,'dis_grd_50391',1,50003,0,155001,NULL,NULL)
END

/*INSERT INTO com_GridHeaderSetting */
IF NOT EXISTS(SELECT [ResourceKey] FROM com_GridHeaderSetting WHERE [ResourceKey] = 'dis_grd_50392')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES(507004,'dis_grd_50392',1,60000,0,155001,NULL,NULL)
END

/*INSERT INTO com_GridHeaderSetting */
IF NOT EXISTS(SELECT [ResourceKey] FROM com_GridHeaderSetting WHERE [ResourceKey] = 'dis_grd_50393')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES(507004,'dis_grd_50393',1,70006,0,155001,NULL,NULL)
END

/*INSERT INTO com_GridHeaderSetting */
IF NOT EXISTS(SELECT [ResourceKey] FROM com_GridHeaderSetting WHERE [ResourceKey] = 'dis_grd_50394')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES(507004,'dis_grd_50394',1,80006,0,155001,NULL,NULL)
END

/*INSERT INTO com_GridHeaderSetting */
IF NOT EXISTS(SELECT [ResourceKey] FROM com_GridHeaderSetting WHERE [ResourceKey] = 'dis_grd_50395')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES(507004,'dis_grd_50395',1,90000,0,155001,NULL,NULL)
END

/*INSERT INTO com_GridHeaderSetting */
IF NOT EXISTS(SELECT [ResourceKey] FROM com_GridHeaderSetting WHERE [ResourceKey] = 'dis_grd_50396')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES(507004,'dis_grd_50396',1,100009,0,155001,NULL,NULL)
END

/*INSERT INTO com_GridHeaderSetting */
IF NOT EXISTS(SELECT [ResourceKey] FROM com_GridHeaderSetting WHERE [ResourceKey] = 'dis_grd_50397')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES(507004,'dis_grd_50397',1,110009,0,155001,NULL,NULL)
END

/*INSERT INTO com_GridHeaderSetting */
IF NOT EXISTS(SELECT [ResourceKey] FROM com_GridHeaderSetting WHERE [ResourceKey] = 'dis_grd_50398')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES(507004,'dis_grd_50398',1,120000,0,155001,NULL,NULL)
END

/*INSERT INTO com_GridHeaderSetting */
IF NOT EXISTS(SELECT [ResourceKey] FROM com_GridHeaderSetting WHERE [ResourceKey] = 'dis_grd_50399')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES(507004,'dis_grd_50399',1,130000,0,155001,NULL,NULL)
END

/*INSERT INTO com_GridHeaderSetting */
IF NOT EXISTS(SELECT [ResourceKey] FROM com_GridHeaderSetting WHERE [ResourceKey] = 'dis_grd_50400')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES(507004,'dis_grd_50400',1,140000,0,155001,NULL,NULL)
END

/*INSERT INTO com_GridHeaderSetting */
IF NOT EXISTS(SELECT [ResourceKey] FROM com_GridHeaderSetting WHERE [ResourceKey] = 'dis_grd_50401')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES(507004,'dis_grd_50401',1,150000,0,155001,NULL,NULL)
END

/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50402)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50402,'dis_grd_50402','Trading in derivatives (Specify type of contract, Futures or Options etc)','en-US',103009,104003,122052,'Trading in derivatives (Specify type of contract, Futures or Options etc)',1,GETDATE())
END

/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50403)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50403,'dis_grd_50403','Type of contract','en-US',103009,104003,122052,'Type of contract',1,GETDATE())
END

/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50404)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50404,'dis_grd_50404','Holding at the beginning of the period','en-US',103009,104003,122052,'Holding at the beginning of the period',1,GETDATE())
END

/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50405)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50405,'dis_grd_50405','Bought during the period','en-US',103009,104003,122052,'Bought during the period',1,GETDATE())
END

/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50406)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50406,'dis_grd_50406','Number of units (contracts * lot size)','en-US',103009,104003,122052,'Number of units (contracts * lot size)',1,GETDATE())
END

/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50407)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50407,'dis_grd_50407','Sold during the period','en-US',103009,104003,122052,'Sold during the period',1,GETDATE())
END

/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50408)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50408,'dis_grd_50408','Holding at end of period','en-US',103009,104003,122052,'Holding at end of period',1,GETDATE())
END

/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50422)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50422,'dis_grd_50422','Number of units (contracts * lot size)','en-US',103009,104003,122052,'Number of units (contracts * lot size)',1,GETDATE())
END
/*INSERT INTO com_GridHeaderSetting */
IF NOT EXISTS(SELECT [ResourceKey] FROM com_GridHeaderSetting WHERE [ResourceKey] = 'dis_grd_50402')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES(507003,'dis_grd_50402',1,10000,0,155003,NULL,NULL)
END

/*INSERT INTO com_GridHeaderSetting */
IF NOT EXISTS(SELECT [ResourceKey] FROM com_GridHeaderSetting WHERE [ResourceKey] = 'dis_grd_50403')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES(507003,'dis_grd_50403',1,20001,0,155003,NULL,NULL)
END

/*INSERT INTO com_GridHeaderSetting */
IF NOT EXISTS(SELECT [ResourceKey] FROM com_GridHeaderSetting WHERE [ResourceKey] = 'dis_grd_50404')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES(507003,'dis_grd_50404',1,30001,0,155003,NULL,NULL)
END

/*INSERT INTO com_GridHeaderSetting */
IF NOT EXISTS(SELECT [ResourceKey] FROM com_GridHeaderSetting WHERE [ResourceKey] = 'dis_grd_50405')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES(507003,'dis_grd_50405',1,40001,0,155003,NULL,NULL)
END

/*INSERT INTO com_GridHeaderSetting */
IF NOT EXISTS(SELECT [ResourceKey] FROM com_GridHeaderSetting WHERE [ResourceKey] = 'dis_grd_50406')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES(507003,'dis_grd_50406',1,50004,0,155003,NULL,NULL)
END

/*INSERT INTO com_GridHeaderSetting */
IF NOT EXISTS(SELECT [ResourceKey] FROM com_GridHeaderSetting WHERE [ResourceKey] = 'dis_grd_50407')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES(507003,'dis_grd_50407',1,60001,0,155003,NULL,NULL)
END

/*INSERT INTO com_GridHeaderSetting */
IF NOT EXISTS(SELECT [ResourceKey] FROM com_GridHeaderSetting WHERE [ResourceKey] = 'dis_grd_50408')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES(507003,'dis_grd_50408',1,80001,0,155003,NULL,NULL)
END

/*INSERT INTO com_GridHeaderSetting */
IF NOT EXISTS(SELECT [ResourceKey] FROM com_GridHeaderSetting WHERE [ResourceKey] = 'dis_grd_50422')
BEGIN
	INSERT INTO com_GridHeaderSetting([GridTypeCodeId],[ResourceKey],[IsVisible],[SequenceNumber],[ColumnWidth],[ColumnAlignment],[OverrideGridTypeCodeId],[OverrideResourceKey])
	VALUES(507003,'dis_grd_50422',1,70006,0,155003,NULL,NULL)
END

/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50409)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50409,'dis_lbl_50409','SEBI (Prohibition of Insider Trading) Regulations, 2015','en-US',103009,104002,122052,'SEBI (Prohibition of Insider Trading) Regulations, 2015',1,GETDATE())
END

/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50410)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50410,'dis_lbl_50410','{0} statement of holdings of securities from {1} to {2}','en-US',103009,104002,122052,'{0} statement of holdings of securities from {1} to {2}',1,GETDATE())
END

/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50411)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50411,'dis_lbl_50411','Name of the Company','en-US',103009,104002,122052,'Name of the Company',1,GETDATE())
END

/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50412)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50412,'dis_lbl_50412','ISIN of the Company','en-US',103009,104002,122052,'ISIN of the Company',1,GETDATE())
END

/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50413)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50413,'dis_lbl_50413','Details of Period End holdings of Securities of Promoter,Employee or Director of a listed company and other such person','en-US',103009,104002,122052,'Details of Period End holdings of Securities of Promoter,Employee or Director of a listed company and other such person',1,GETDATE())
END

/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50414)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50414,'dis_lbl_50414','Note: "Securities" shall have the meaning as defined under regulation 2(1)(i) of SEBI (Prohibition of Insider Trading) Regulations, 2015.','en-US',103009,104002,122052,'Note: "Securities" shall have the meaning as defined under regulation 2(1)(i) of SEBI (Prohibition of Insider Trading) Regulations, 2015.',1,GETDATE())
END

/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50415)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50415,'dis_lbl_50415','Details of holdings of derivatives of the company by Promoter,Employee or Director of a listed company and other such person as mentioned in Regulation 6[2].','en-US',103009,104002,122052,'Details of holdings of derivatives of the company by Promoter,Employee or Director of a listed company and other such person as mentioned in Regulation 6[2].',1,GETDATE())
END

/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50416)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50416,'dis_lbl_50416','Signature','en-US',103009,104002,122052,'Signature',1,GETDATE())
END

/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50417)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50417,'dis_lbl_50417','Designation','en-US',103009,104002,122052,'Designation',1,GETDATE())
END

/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50418)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50418,'dis_lbl_50418','Date','en-US',103009,104002,122052,'Date',1,GETDATE())
END

/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50419)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50419,'dis_lbl_50419','Place','en-US',103009,104002,122052,'Place',1,GETDATE())
END

/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50420)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50420,'dis_lbl_50420','Designation of Employee','en-US',103009,104002,122052,'Designation of Employee',1,GETDATE())
END

/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50421)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50421,'dis_lbl_50421','Current date','en-US',103009,104002,122052,'Current date',1,GETDATE())
END

/* DELETE FROM com_GridHeaderSetting */
IF EXISTS(SELECT GridTypeCodeId FROM com_GridHeaderSetting WHERE ResourceKey = 'dis_grd_50387')
BEGIN
	DELETE FROM com_GridHeaderSetting WHERE ResourceKey='dis_grd_50387'
END