/*------------------------------------------------------------------------------------------------
Description:	Procedure perform update/add mode of acquisitin
				
Created by:		Amin
Created on:		15-Apr-2016

-------------------------------------------------------------------------------------------------*/

UPDATE com_Code set CodeName = 'Public Right', Description = 'Mode Of Acquisition - Public Right' where CodeID = '149002'
UPDATE com_Code set CodeName = 'Preferential Offer', Description = 'Mode Of Acquisition - Preferential Offer' where CodeID = '149003'
UPDATE com_Code set CodeName = 'Gift', Description = 'Mode Of Acquisition - Gift' where CodeID = '149004'

IF NOT EXISTS(SELECT CODENAME FROM com_Code WHERE CodeID = 149005)
BEGIN
	INSERT INTO com_Code VALUES
	(149005, 'Inter-se-Transfer', 149, 'Mode Of Acquisition - Inter-se-Transfer',1,1,5,NULL,NULL,1, GETDATE()),
	(149006, 'Conversion of security', 149, 'Mode Of Acquisition - Conversion of security',1,1,6,NULL,NULL,1, GETDATE()),
	(149007, 'Scheme of Amalgamation/Merger/Demerger/Arrangement', 149, 'Mode Of Acquisition - Scheme of Amalgamation/Merger/Demerger/Arrangement',1,1,7,NULL,NULL,1, GETDATE()),
	(149008, 'Off Market', 149, 'Mode Of Acquisition - Off Market',1,1,8,NULL,NULL,1, GETDATE()),
	(149009, 'ESOP', 149, 'Mode Of Acquisition - ESOP',1,1,9,NULL,NULL,1, GETDATE()),
	(149010, 'Market Sale', 149, 'Mode Of Acquisition - Market Sale',1,1,10,NULL,NULL,1, GETDATE())
END