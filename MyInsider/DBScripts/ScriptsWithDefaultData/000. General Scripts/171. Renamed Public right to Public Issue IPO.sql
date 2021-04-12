UPDATE com_Code
SET CodeName = REPLACE(CodeName, 'Public right', 'Public Issue/IPO'),
Description = REPLACE(Description, 'Public right', 'Public Issue/IPO'),
DisplayCode = REPLACE(DisplayCode, 'Public right', 'Public Issue/IPO')
WHERE CodeName like '%Public right%'