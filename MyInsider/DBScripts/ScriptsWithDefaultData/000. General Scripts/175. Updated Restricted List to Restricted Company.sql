  --select * from com_Code where CodeName like '%Restricted List%'

UPDATE com_Code
SET CodeName = REPLACE(CodeName, 'Restricted List', 'Restricted Company'),
Description = REPLACE(Description, 'Restricted List', 'Restricted Company')
WHERE CodeID=170005
--WHERE CodeName like '%Restricted List%