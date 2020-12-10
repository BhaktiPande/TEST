-- ======================================================================================================
-- Author      :Rajashri Sathe
-- CREATED DATE: 08-Apr-2020
-- Description : Script for Period End Issue
-- ======================================================================================================

----------------------------------Add colum in mst_Company table-------------------------------------

IF NOT EXISTS(SELECT SYSTAB.NAME FROM SYS.TABLES SYSTAB INNER JOIN SYS.COLUMNS SYSCOL ON SYSTAB.OBJECT_ID = SYSCOL.OBJECT_ID 
WHERE SYSTAB.NAME = 'mst_Company' AND SYSCOL.NAME = 'TradingDaysCountTypePE_OS')
BEGIN
	ALTER TABLE mst_Company ADD TradingDaysCountTypePE_OS [int] NOT NULL DEFAULT(532001)
END

-- --------------------------------Add CodeGroupID in com_CodeGroup table---------------------------
 IF NOT EXISTS(SELECT CodeGroupID FROM com_CodeGroup WHERE CodeGroupID =532)
BEGIN
	INSERT INTO com_CodeGroup([CodeGroupID],[COdeGroupName],[Description],[IsVisible],[IsEditable],[ParentCodeGroupId])
	VALUES (532,'Trading Days Count Type for Period End Other securities','Trading Days Count Type for Period End Other securities',1,1,NULL)
END

-----------------------------------------Insert the value in com_Code table for TradingDays------------------------------------------------------
IF NOT EXISTS (SELECT CodeID FROM com_Code WHERE CodeID=532001)
BEGIN
     INSERT INTO com_Code(CodeID,CodeName,CodeGroupId,[Description],IsVisible,IsActive,DisplayOrder,DisplayCode,ParentCodeId,ModifiedBy,ModifiedOn)
	 VALUES 
	 (532001,'TradingDays',532,'TradingDays',1,1,1,'Trading Days',null,1,GETDATE())
END

-----------------------------------------Insert the value in com_Code table for CalendarDays------------------------------------------------------
IF NOT EXISTS (SELECT CodeID FROM com_Code WHERE CodeID=532002)
BEGIN
     INSERT INTO com_Code(CodeID,CodeName,CodeGroupId,[Description],IsVisible,IsActive,DisplayOrder,DisplayCode,ParentCodeId,ModifiedBy,ModifiedOn)
	 VALUES 
	 (532002,'CalendarDays',532,'CalendarDays',1,1,2,'Calendar Days',null,1,GETDATE())
END


---------------------------------------Own Securites--------------------------------------------------------------------------


--------------------------------Add colum in mst_Company table-------------------------------------

IF NOT EXISTS(SELECT SYSTAB.NAME FROM SYS.TABLES SYSTAB INNER JOIN SYS.COLUMNS SYSCOL ON SYSTAB.OBJECT_ID = SYSCOL.OBJECT_ID 
WHERE SYSTAB.NAME = 'mst_Company' AND SYSCOL.NAME = 'TradingDaysCountTypePE')
BEGIN
	ALTER TABLE mst_Company ADD TradingDaysCountTypePE [int] NOT NULL DEFAULT(533001);
END
 
 --------------------------------Add CodeGroupID in com_CodeGroup table---------------------------
 IF NOT EXISTS(SELECT CodeGroupID FROM com_CodeGroup WHERE CodeGroupID =533)
BEGIN
	INSERT INTO com_CodeGroup([CodeGroupID],[COdeGroupName],[Description],[IsVisible],[IsEditable],[ParentCodeGroupId])
	VALUES (533,'Trading Days Count Type for Period End Own securities','Trading Days Count Type for Period End Own securities',1,1,NULL)
END

---------------------------------------Insert the value in com_Code table for TradingDays------------------------------------------------------
IF NOT EXISTS (SELECT CodeID FROM com_Code WHERE CodeID=533001)
BEGIN
     INSERT INTO com_Code(CodeID,CodeName,CodeGroupId,[Description],IsVisible,IsActive,DisplayOrder,DisplayCode,ParentCodeId,ModifiedBy,ModifiedOn)
	 VALUES 
	 (533001,'TradingDays',533,'TradingDays',1,1,1,'Trading Days',null,1,GETDATE())
END

---------------------------------------Insert the value in com_Code table for CalendarDays------------------------------------------------------
IF NOT EXISTS (SELECT CodeID FROM com_Code WHERE CodeID=533002)
BEGIN
     INSERT INTO com_Code(CodeID,CodeName,CodeGroupId,[Description],IsVisible,IsActive,DisplayOrder,DisplayCode,ParentCodeId,ModifiedBy,ModifiedOn)
	 VALUES 
	 (533002,'CalendarDays',533,'CalendarDays',1,1,2,'Calendar Days',null,1,GETDATE())
END

----------------------------------------------------Pre clearance request--------------------------------------------------------------------------

IF NOT EXISTS(SELECT SYSTAB.NAME FROM SYS.TABLES SYSTAB INNER JOIN SYS.COLUMNS SYSCOL ON SYSTAB.OBJECT_ID = SYSCOL.OBJECT_ID 
WHERE SYSTAB.NAME = 'mst_Company' AND SYSCOL.NAME = 'PreclearnceValidyDateCountType_OS')
BEGIN
	ALTER TABLE mst_Company ADD PreclearnceValidyDateCountType_OS [int] NOT NULL DEFAULT(534001);
END
 
 --------------------------------Add CodeGroupID in com_CodeGroup table---------------------------------
 IF NOT EXISTS(SELECT CodeGroupID FROM com_CodeGroup WHERE CodeGroupID =534)
BEGIN
	INSERT INTO com_CodeGroup([CodeGroupID],[COdeGroupName],[Description],[IsVisible],[IsEditable],[ParentCodeGroupId])
	VALUES (534,'Trading Days Count Type for PreClerance Other securities','Trading Days Count Type for PreClerance Other securities',1,1,NULL)
END

---------------------------------------Insert the value in com_Code table for TradingDays------------------------------------------------------
IF NOT EXISTS (SELECT CodeID FROM com_Code WHERE CodeID=534001)
BEGIN
     INSERT INTO com_Code(CodeID,CodeName,CodeGroupId,[Description],IsVisible,IsActive,DisplayOrder,DisplayCode,ParentCodeId,ModifiedBy,ModifiedOn)
	 VALUES 
	 (534001,'TradingDays',534,'TradingDays',1,1,1,'Trading Days',null,1,GETDATE())
END

---------------------------------------Insert the value in com_Code table for CalendarDays------------------------------------------------------
IF NOT EXISTS (SELECT CodeID FROM com_Code WHERE CodeID=534002)
BEGIN
     INSERT INTO com_Code(CodeID,CodeName,CodeGroupId,[Description],IsVisible,IsActive,DisplayOrder,DisplayCode,ParentCodeId,ModifiedBy,ModifiedOn)
	 VALUES 
	 (534002,'CalendarDays',534,'CalendarDays',1,1,2,'Calendar Days',null,1,GETDATE())
END