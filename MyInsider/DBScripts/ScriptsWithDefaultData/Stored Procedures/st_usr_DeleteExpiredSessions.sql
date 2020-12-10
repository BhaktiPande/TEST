/* *****************************************************************************************************
-- Author:		Priyanka wani
-- Create date: 07-April-2017
-- Description:	This SP is used to call by SQL JOB to delete expired sessions from UserSessions table.
******************************************************************************************************* */
IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_usr_DeleteExpiredSessions')
	DROP PROCEDURE st_usr_DeleteExpiredSessions
GO

CREATE PROCEDURE st_usr_DeleteExpiredSessions
AS

BEGIN

	SET NOCOUNT ON;
	CREATE TABLE #tmpUserInfoId
	(
	ID INT IDENTITY(1,1),
	UserInfoID INT
	)
	INSERT INTO #tmpUserInfoId(UserInfoId)
	SELECT UserInfoId FROM usr_UserCookies WHERE ExpireOn < GETDATE() AND CookieName = 'Unauthorised'
	
	DELETE FROM usr_UserSessions WHERE UserName IN (SELECT UserInfoId FROM #tmpUserInfoId)			   
	
	DELETE FROM usr_UserCookies WHERE UserInfoID IN(SELECT UserInfoId FROM #tmpUserInfoId)
	
	DELETE FROM usr_UserWiseFormTokenList WHERE UserInfoID IN(SELECT UserInfoId FROM #tmpUserInfoId)
	
	DELETE FROM usr_UserValidSession WHERE UserInfoID IN(SELECT UserInfoId FROM #tmpUserInfoId)
	
	DROP TABLE #tmpUserInfoId
	
	--DELETE FROM usr_UserSessions WHERE UserName
	--	 IN(
	--	SELECT UserInfoId FROM usr_UserCookies WHERE CookieName='Unauthorised')		
	
	--DELETE FROM usr_UserCookies WHERE CookieName='Unauthorised' 
		
	SET NOCOUNT OFF;

END
GO
