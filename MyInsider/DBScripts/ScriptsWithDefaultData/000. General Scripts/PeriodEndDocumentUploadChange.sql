IF NOT EXISTS(Select 1 from com_Code where CodeID = 132026 )
BEGIN
    INSERT INTO com_Code
(CodeID, CodeName, CodeGroupId, Description, IsVisible, IsActive, DisplayOrder, DisplayCode, ParentCodeId, ModifiedBy, ModifiedOn)
VALUES
(132026, 'Period End Document Upload',132, 'Map To Type - Period End Document Upload',	1, 1, 26, NULL, NULL, 1, GETDATE())
END