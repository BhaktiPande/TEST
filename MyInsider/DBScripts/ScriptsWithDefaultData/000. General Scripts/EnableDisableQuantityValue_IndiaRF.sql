
IF NOT EXISTS(SELECT CodeGroupID FROM com_CodeGroup WHERE CodeGroupID=400)
BEGIN
	 INSERT INTO com_CodeGroup(CodeGroupID,COdeGroupName,[Description],IsVisible,IsEditable,ParentCodeGroupId)
	 VALUES
	 (400,'Enable/Disable Quantity and Values','Enable/Disable Quantity and Values',1,0,NULL)
END

Go
IF NOT EXISTS (SELECT CodeID FROM com_Code WHERE CodeID=400001)
BEGIN
     INSERT INTO com_Code(CodeID,CodeName,CodeGroupId,[Description],IsVisible,IsActive,DisplayOrder,DisplayCode,ParentCodeId,ModifiedBy,ModifiedOn)
	 VALUES 
	 (400001,'Enable Qunatity and Value',400,'Enable Qunatity and Value',0,1,'200',null,null,1,GETDATE())
END


IF NOT EXISTS (SELECT CodeID FROM com_Code WHERE CodeID=400002)
BEGIN
     INSERT INTO com_Code(CodeID,CodeName,CodeGroupId,[Description],IsVisible,IsActive,DisplayOrder,DisplayCode,ParentCodeId,ModifiedBy,ModifiedOn)
	 VALUES 
	 (400002,'Disable and Show Qunatity and Value',400,'Disable and Show Qunatity and Value',0,1,'201',null,null,1,GETDATE())
END

IF NOT EXISTS (SELECT CodeID FROM com_Code WHERE CodeID=400003)
BEGIN
     INSERT INTO com_Code(CodeID,CodeName,CodeGroupId,[Description],IsVisible,IsActive,DisplayOrder,DisplayCode,ParentCodeId,ModifiedBy,ModifiedOn)
	 VALUES 
	 (400003,'Disable and Hide Qunatity and Value',400,'Disable and Hide Qunatity and Value',0,1,'202',null,null,1,GETDATE())
END

--select * from mst_Company
IF NOT EXISTS(SELECT 1 FROM sys.columns WHERE Name = N'EnableDisableQuantityValue' AND Object_ID = Object_ID(N'mst_Company'))
BEGIN
	Alter table mst_Company
	ADD EnableDisableQuantityValue INT
END
GO
	Update mst_Company
	Set EnableDisableQuantityValue=400001
