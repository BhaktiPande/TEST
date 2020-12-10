IF NOT EXISTS(SELECT SYSTAB.NAME FROM SYS.TABLES SYSTAB INNER JOIN SYS.COLUMNS SYSCOL ON SYSTAB.OBJECT_ID = SYSCOL.OBJECT_ID 
WHERE SYSTAB.NAME = 'usr_Activity' AND SYSCOL.NAME = 'ApplicableFor')
BEGIN
	ALTER TABLE usr_Activity ADD [ApplicableFor] INT NOT NULL DEFAULT(513003)
END
GO
update usr_Activity set ApplicableFor = 513002 where ActivityID in (239,216,217,240)
update usr_Activity set ApplicableFor = 513001 where ActivityID in (9,230,153)

