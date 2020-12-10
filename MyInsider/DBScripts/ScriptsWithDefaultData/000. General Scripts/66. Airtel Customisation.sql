/*
	Created By  :	SHUBHANGI GURUDE
	Created On 	:	31-Aug-2018
	Description :	This script is used to add validation messages in mst_resource and alter the table columns of rul_tradingPolicy
*/

/*-------Insert into table mst_Resource-------*/
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50714)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES ( 50714,'dis_msg_50714','You are not allowed to create a fresh pre-clearance as your previous pre-cerance is not approved.
You should only trade post approval of your request for pre-clearanace.','en-US',103009,104001,122051,'Case 9: Previous Pre-clearance not approved',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50715)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50715,'dis_msg_50715','You are not allowed to create a new pre-clearance till the end 
of current calender quarter $2 as your previous pre-cerance 
is rejected.New Pre clearance shall be enabled from $3','en-US',103009,104001,122051,'Case 10: Previous Pre-clearance rejected',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50716)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50716,'dis_msg_50716','You are not allowed to seek fresh approval to trade in securities under pre-clearance as your previous approval under pre-clearance is open and valid
till $4. Please update the details of trade against the preclearance date. $1, if any in Form C. You are debarred to request
fresh pre-clearance till the expiry of current approved PCT i.e. $2.','en-US',103009,104001,122051,'Case 1 : Previous Preclearance is open',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50717)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50717,'dis_msg_50717','You are not allowed to seek fresh  approval to trade in securities under pre-clearance as you have tarded in the securities of the Company earlier without seeking prior approval under Pre-clreance of Compalince officer.  
Due to non-adhernace to the Code of the Company you have been debarred to trade in the securities of the Company till the expiry of current calender quarter  i.e.  $2 .','en-US',103009,104001,122051,'Case 13 : Pre-clearance not taken',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50718)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50718,'dis_msg_50718','You are not allowed to seek fresh  approval to trade in securities under pre-clearance as you have not traded against the previous
	approval under pre-clearance date. $1. Please update the details of  non-trade against the said  preclearance in Form CoD.Due to non-disclosure of above tradnaction (non-trade) you have been 
	debarred to trade in the securities of the Company till the expiry of current calender quarter  i.e.  $2 .','en-US',103009,104001,122051,'Case 2b: Previous Pre-clearance not traded and reason provided for not trade after the pre-clearance validity',1,GETDATE())
END

--IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50719)
--BEGIN
--	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
--	VALUES (50719,'dis_msg_50719','You are not allowed to seek fresh approval to trade in securities under pre-clearance as you have traded in the securities of the Company after the expiry of valid period to
--	trade, intimated to you vide pre-clearance date. $1. Please update the details of trade against the said preclearance in Form C. Due to non-disclosure of trade you have
--	been debarred to trade in the securities of the Company till the expiry of current calendar quarter i.e. $2 .','en-US',103009,104001,122051,'Case 3: Traded after Pre-clearance validity period',1,GETDATE())
--END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50720)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50720,'dis_msg_50720','You are not allowed to seek fresh approval to trade in securities under pre-clearance as you have traded in the securities of the Company after the expiry of valid period to
	trade, intimated to you vide pre-clearance date. $1. Please update the details of trade against the said preclearance in Form C. Due to non-disclosure of trade you have
	been debarred to trade in the securities of the Company till the expiry of current calendar quarter i.e. $2.','en-US',103009,104001,122051,'Case 3: Traded after Pre-clearance validity period',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50721)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50721,'dis_msg_50721','You are not allowed to seek fresh approval to trade in securities under preclearance as you have not submitted the duly signed copy of Form C disclosing
	the details of trade in the securities of the Company against the approval under pre-clearance date. $1. Due to non-disclosure of trade you have been
	debarred to trade in the securities of the Company till the expiry of current quarter i.e. $2 . Please update the details of trade and share the duly
	signed Form C at earliest. ','en-US',103009,104001,122051,'Case 6  Traded against pre-clearance but softcopy and hard copy not submitted
	within pre-clearance validity + 2days',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50722)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50722,'dis_msg_50722','You are not allowed to seek fresh approval to trade in securities under preclearance as you have not submitted the duly signed copy of Form C disclosing
the details of trade in the securities of the Company against the approval under pre-clearance date. $1. Due to non-disclosure of trade you have been
debarred to trade in the securities of the Company till the expiry of current quarter i.e. $2 . Please update the details of trade and share the duly
signed Form C at earliest. ','en-US',103009,104001,122051,'Case 7: Traded against pre-clearance and softcopy submitted but hard copy not submitted',1,GETDATE())
END

IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50723)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50723,'dis_msg_50723','You are not allowed to seek fresh approval to trade in securities under pre-clearance as your previous approval under pre-clearance is partially traded and valid
till $4. Please update the details of remaining quantity against the preclearance date. $1, if any in Form C. You are debarred to request fresh pre-clearance till the
expiry of current approved PCT i.e. $2 . 
	 ','en-US',103009,104001,122051,'Case 14 : Previous Preclearance is partially traded',1,GETDATE())
END


IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50724)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50724,'dis_msg_50724','You are not allowed to raise the pre-clearance as the total quantity of equity shares sold 
	in this quarter exceeds $5. You are allowed to raise a pre-clearance less than $6 equity shares or $5 % (whichever is higher) of your total holdings in this quarter 
	 ','en-US',103009,104001,122051,'Qty excceds than $5',1,GETDATE())
END


IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50725)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50725,'dis_msg_50725','You are not allowed to raise the pre-clearance as the total quantity of equity shares sold 
	in this quarter exceeds $6. You are allowed to raise a pre-clearance less than $6 equity shares or $5 % (whichever is higher) of your total holdings in this quarter
	 ','en-US',103009,104001,122051,'Qty excceds than $6',1,GETDATE())
END

/*-------Alter table rul_tradingPolicy-------*/
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'IsProhibitPreClrFunctionalityApplicable' AND OBJECT_ID = OBJECT_ID(N'[rul_tradingPolicy]'))
BEGIN	
	ALTER TABLE rul_tradingPolicy ADD [IsProhibitPreClrFunctionalityApplicable][BIT] NULL DEFAULT 0
END 

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ProhibitPreClrPercentageAppFlag' AND OBJECT_ID = OBJECT_ID(N'[rul_tradingPolicy]'))
BEGIN	
	ALTER TABLE rul_tradingPolicy ADD [ProhibitPreClrPercentageAppFlag][BIT] NULL DEFAULT 0
END 

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ProhibitPreClrOnPercentage' AND OBJECT_ID = OBJECT_ID(N'[rul_tradingPolicy]'))
BEGIN	
	ALTER TABLE rul_tradingPolicy ADD [ProhibitPreClrOnPercentage] DECIMAL(5,2) 
END 

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ProhibitPreClrOnQuantityAppFlag' AND OBJECT_ID = OBJECT_ID(N'[rul_tradingPolicy]'))
BEGIN	
	ALTER TABLE rul_tradingPolicy ADD [ProhibitPreClrOnQuantityAppFlag][BIT] NULL DEFAULT 0
END 

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ProhibitPreClrOnQuantity' AND OBJECT_ID = OBJECT_ID(N'[rul_tradingPolicy]'))
BEGIN	
	ALTER TABLE rul_tradingPolicy ADD [ProhibitPreClrOnQuantity] DECIMAL(10,0) 
END 

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ProhibitPreClrForPeriod' AND OBJECT_ID = OBJECT_ID(N'[rul_tradingPolicy]'))
BEGIN	
	ALTER TABLE rul_tradingPolicy ADD [ProhibitPreClrForPeriod][INT] NULL
END

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ProhibitPreClrForAllSecurityType' AND OBJECT_ID = OBJECT_ID(N'[rul_tradingPolicy]'))
BEGIN	
	ALTER TABLE rul_tradingPolicy ADD [ProhibitPreClrForAllSecurityType][BIT] NULL DEFAULT 0
END

/* INSERT INTO com_CodeGroup */
IF NOT EXISTS(SELECT CodeGroupID FROM com_CodeGroup WHERE CodeGroupID = 512)
BEGIN
	INSERT INTO com_CodeGroup(CodeGroupID, COdeGroupName, [Description], IsVisible, IsEditable, ParentCodeGroupId) 
	VALUES (512,'Preclearance Module','Preclearance Module',1,0,null)
END

/* INSERT INTO com_Code */
IF NOT EXISTS(SELECT CodeID FROM com_Code WHERE CodeID = 512001)
BEGIN
	INSERT INTO com_Code(CodeID,CodeName, CodeGroupId, [Description], IsVisible, IsActive, DisplayOrder, DisplayCode, ParentCodeId, ModifiedBy, ModifiedOn) 
	VALUES (512001,'Exempt Prohibition on Preclearance',512,'Exempt Prohibition on Preclearance',1,1,1,'Exempt Prohibition on Preclearance',null,1,GETDATE())
END

/* INSERT INTO com_Code */
IF NOT EXISTS(SELECT CodeID FROM com_Code WHERE CodeID = 512002)
BEGIN
	INSERT INTO com_Code(CodeID,CodeName, CodeGroupId, [Description], IsVisible, IsActive, DisplayOrder, DisplayCode, ParentCodeId, ModifiedBy, ModifiedOn) 
	VALUES (512002,'Apply Prohibition on Preclearance',512,'Apply Prohibition on Preclearance',1,1,1,'Apply Prohibition on Preclearance',null,1,GETDATE())
END

/*-------Alter table mst_Company-------*/
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ProhibitPreClearance' AND OBJECT_ID = OBJECT_ID(N'[mst_Company]'))
BEGIN	
	ALTER TABLE mst_Company ADD ProhibitPreClearance int NOT NULL DEFAULT(512001)
END


--/* INSERT INTO com_Code */
--IF NOT EXISTS(SELECT CodeID FROM com_Code WHERE CodeID = 167014)
--BEGIN
--	INSERT INTO com_Code(CodeID,CodeName, CodeGroupId, [Description], IsVisible, IsActive, DisplayOrder, DisplayCode, ParentCodeId, ModifiedBy, ModifiedOn) 
--	VALUES (167014,'rpt_lbl_50726',167,'Traded with valid pre-clearance',1,1,1,'Traded with valid pre-clearance',null,1,GETDATE())
--END

--IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50726)
--BEGIN
--	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
--	VALUES (50726,'rpt_lbl_50726','Traded with valid pre-clearance','en-US',103011,104002,122063,'Traded with valid pre-clearance',1,GETDATE())
--END

--/* INSERT INTO com_Code */
--IF NOT EXISTS(SELECT CodeID FROM com_Code WHERE CodeID = 167015)
--BEGIN
--	INSERT INTO com_Code(CodeID,CodeName, CodeGroupId, [Description], IsVisible, IsActive, DisplayOrder, DisplayCode, ParentCodeId, ModifiedBy, ModifiedOn) 
--	VALUES (167015,'rpt_lbl_50727',167,'Traded without valid pre-clearance',1,1,1,'Traded without valid pre-clearance',null,1,GETDATE())
--END

--IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50727)
--BEGIN
--	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
--	VALUES (50727,'rpt_lbl_50727','Traded without valid pre-clearance','en-US',103011,104002,122063,'Traded without valid pre-clearance',1,GETDATE())
--END

--/* INSERT INTO com_Code */
--IF NOT EXISTS(SELECT CodeID FROM com_Code WHERE CodeID = 167016)
--BEGIN
--	INSERT INTO com_Code(CodeID,CodeName, CodeGroupId, [Description], IsVisible, IsActive, DisplayOrder, DisplayCode, ParentCodeId, ModifiedBy, ModifiedOn) 
--	VALUES (167016,'rpt_lbl_50728',167,'Traded without pre-clearance and fresh pre-clearance to trade was not allowed to create as previous pre-clearance was open',1,1,1,'Traded without pre-clearance and fresh pre-clearance to trade was not allowed to create as previous pre-clearance was open',null,1,GETDATE())
--END

--IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50728)
--BEGIN
--	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
--	VALUES (50728,'rpt_lbl_50728','Traded without pre-clearance and fresh pre-clearance to trade was not allowed to create as previous pre-clearance was open','en-US',103011,104002,122063,'Traded without pre-clearance and fresh pre-clearance to trade was not allowed to create as previous pre-clearance was open',1,GETDATE())
--END

--/* INSERT INTO com_Code */
--IF NOT EXISTS(SELECT CodeID FROM com_Code WHERE CodeID = 167017)
--BEGIN
--	INSERT INTO com_Code(CodeID,CodeName, CodeGroupId, [Description], IsVisible, IsActive, DisplayOrder, DisplayCode, ParentCodeId, ModifiedBy, ModifiedOn) 
--	VALUES (167017,'rpt_lbl_50729',167,'Traded without pre-clearance and fresh pre-clearance to was not allowed to create as no trade was carried against the previous approved pre-clearance and no trade details were submitted for no trade',1,1,1,'Traded without pre-clearance and fresh pre-clearance to was not allowed to create as no trade was carried against the previous approved pre-clearance and no trade details were submitted for no trade',null,1,GETDATE())
--END

--IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50729)
--BEGIN
--	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
--	VALUES (50729,'rpt_lbl_50729','Traded without pre-clearance and fresh pre-clearance to was not allowed to create as no trade was carried against the previous approved pre-clearance and no trade details were submitted for no trade','en-US',103011,104002,122063,'Traded without pre-clearance and fresh pre-clearance to was not allowed to create as no trade was carried against the previous approved pre-clearance and no trade details were submitted for no trade',1,GETDATE())
--END

--/* INSERT INTO com_Code */
--IF NOT EXISTS(SELECT CodeID FROM com_Code WHERE CodeID = 167018)
--BEGIN
--	INSERT INTO com_Code(CodeID,CodeName, CodeGroupId, [Description], IsVisible, IsActive, DisplayOrder, DisplayCode, ParentCodeId, ModifiedBy, ModifiedOn) 
--	VALUES (167018,'rpt_lbl_50730',167,'Traded without pre-clearance and fresh pre-clearance to trade was not allowed to create as traded beyond/ past the approved period to trade. ',1,1,1,'Traded without pre-clearance and fresh pre-clearance to trade was not allowed to create as traded beyond/ past the approved period to trade.',null,1,GETDATE())
--END

--IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50730)
--BEGIN
--	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
--	VALUES (50730,'rpt_lbl_50730','Traded without pre-clearance and fresh pre-clearance to trade was not allowed to create as traded beyond/ past the approved period to trade.','en-US',103011,104002,122063,'Traded without pre-clearance and fresh pre-clearance to trade was not allowed to create as traded beyond/ past the approved period to trade.',1,GETDATE())
--END

--/* INSERT INTO com_Code */
--IF NOT EXISTS(SELECT CodeID FROM com_Code WHERE CodeID = 167019)
--BEGIN
--	INSERT INTO com_Code(CodeID,CodeName, CodeGroupId, [Description], IsVisible, IsActive, DisplayOrder, DisplayCode, ParentCodeId, ModifiedBy, ModifiedOn) 
--	VALUES (167019,'rpt_lbl_50731',167,'Traded without pre-clearance',1,1,1,'Traded without pre-clearance',null,1,GETDATE())
--END

--IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50731)
--BEGIN
--	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
--	VALUES (50731,'rpt_lbl_50731','Traded without pre-clearance','en-US',103011,104002,122063,'Traded without pre-clearance',1,GETDATE())
--END




