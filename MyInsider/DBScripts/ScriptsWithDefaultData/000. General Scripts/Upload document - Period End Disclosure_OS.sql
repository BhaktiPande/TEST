IF NOT EXISTS(SELECT 1 FROM com_Code WHERE CodeID = 132026 AND CodeName = 'Period End Disclosure_OS')
 BEGIN
  INSERT INTO com_Code(CodeID, CodeName, CodeGroupId, Description, IsVisible, IsActive, DisplayOrder, DisplayCode, ParentCodeId, ModifiedBy, ModifiedOn)
  VALUES(132026, 'Period End Disclosure_OS', 132, 'Map To Type - Period End Disclosure Other Securities', 1, 1, 26, NULL, NULL, 1, GETDATE())
 END