
IF NOT EXISTS(SELECT * FROM SYS.TABLES SYSTAB INNER JOIN SYS.COLUMNS SYSCOL ON SYSTAB.OBJECT_ID = SYSCOL.OBJECT_ID WHERE SYSTAB.NAME = 'DU_MAPPINGTABLES' AND SYSCOL.NAME = 'Sequence')
	ALTER TABLE DU_MAPPINGTABLES ADD Sequence INT 
GO

IF NOT EXISTS(SELECT * FROM SYS.TABLES SYSTAB INNER JOIN SYS.COLUMNS SYSCOL ON SYSTAB.OBJECT_ID = SYSCOL.OBJECT_ID WHERE SYSTAB.NAME = 'DU_MAPPINGTABLES' AND SYSCOL.NAME = 'IsActive')
	ALTER TABLE DU_MAPPINGTABLES ADD IsActive BIT DEFAULT 0
GO

