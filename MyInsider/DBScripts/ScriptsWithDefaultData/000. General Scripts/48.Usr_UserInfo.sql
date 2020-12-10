--Add NoOfDaysToBeActive column in usr_userInfo table 0 means unlock and 1 means lock
IF NOT EXISTS(SELECT SYSTAB.NAME FROM SYS.TABLES SYSTAB INNER JOIN SYS.COLUMNS SYSCOL ON SYSTAB.OBJECT_ID = SYSCOL.OBJECT_ID WHERE SYSTAB.NAME = 'usr_UserInfo' AND SYSCOL.NAME = 'NoOfDaysToBeActive') 
ALTER TABLE [dbo].[usr_UserInfo] ADD NoOfDaysToBeActive BIT

