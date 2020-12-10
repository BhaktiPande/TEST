/* ***************************************************************************
-- Author:		Priyanka Wani
-- Create date: 07-April-2017
-- Description:	This SP is used to run SP 'PROC_Delete_ExpiredUserSessions' on every database from CompanyList
****************************************************************************** */ 

IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_usr_JobProcAlertForExpiredSessions')
	DROP PROCEDURE st_usr_JobProcAlertForExpiredSessions
GO

CREATE PROCEDURE st_usr_JobProcAlertForExpiredSessions
AS
BEGIN
	DECLARE @CNT INT, @CNAME VARCHAR (100)
	
	SELECT 
		ROW_NUMBER() OVER (ORDER BY ConnectionDatabaseName) AS SR_NO,
		ConnectionDatabaseName as CName
	INTO #TempCompanyList
	FROM Companies
	
	SELECT @CNT = COUNT(SR_NO) FROM #TempCompanyList
	
	WHILE(@CNT > 0)
	BEGIN
		BEGIN TRY
			SELECT @CNAME = CName From #TempCompanyList WHERE SR_NO = @CNT
				
			EXECUTE ('EXECUTE ' + @CNAME + '..st_usr_DeleteExpiredSessions')
		END TRY
		
		BEGIN CATCH
		
			DECLARE @ERROR_MESSAGE VARCHAR(MAX) = 'Company: ' + @CNAME + '\n  ' + ERROR_MESSAGE()
			
		END CATCH;
		
		SET @CNT = @CNT - 1
	END
	DROP TABLE #TempCompanyList

END
