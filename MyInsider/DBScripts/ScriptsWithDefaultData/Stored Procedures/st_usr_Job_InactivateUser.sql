IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_usr_Job_InactivateUser')
DROP PROCEDURE [dbo].[st_usr_Job_InactivateUser]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
This procedure is used to Inactive user status 
Created by:		Gaurishankar
Created on:		06-Nov-2015

Modification History:
Modified By		Modified On		Description
Raghvendra		07-Sep-2016		Changed the GETDATE() call with function dbo.uf_com_GetServerDate(). This function will return the date to be used as server date.

Usage:
DECLARE @RC int
EXEC st_usr_Job_InactivateUser
-------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[st_usr_Job_InactivateUser] 
AS
BEGIN
	BEGIN TRY
		DECLARE @nUSERSTATUSINACTIVE INT=102002
		DECLARE @nUSERSTATUSACTIVE INT=102001
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;		
		
		--UPDATE usr_UserInfo 
		--SET StatusCodeId = @nUSERSTATUSINACTIVE,
		--	ModifiedBy = 1,
		--	ModifiedOn = dbo.uf_com_GetServerDate()		
		--WHERE DateOfInactivation <= CAST(CAST(dbo.uf_com_GetServerDate() AS DATE) AS DATETIME)
		--AND StatusCodeId = @nUSERSTATUSACTIVE
		
		
DECLARE @nTotCount INT=0
DECLARE @nCount INT=0

DECLARE  @tmpUserInfoId AS TABLE(ID INT IDENTITY(1,1),UserInfoId INT,StatusCodeId INT)
		INSERT INTO @tmpUserInfoId (UserInfoId,StatusCodeId)
		SELECT  userinfoid,StatusCodeId 
		FROM usr_UserInfo
		WHERE DateOfInactivation <= (CAST(CAST(dbo.uf_com_GetServerDate() AS DATE) AS DATETIME))
		
		INSERT INTO @tmpUserInfoId (UserInfoId,StatusCodeId)
		SELECT  UR.UserInfoIdRelative,StatusCodeId 
		FROM @tmpUserInfoId UF join usr_UserRelation UR on UF.UserInfoId = UR.UserInfoId

		SELECT @nTotCount=count(UserInfoId) FROM @tmpUserInfoId
		WHILE @nCount<@nTotCount
		BEGIN
			DECLARE @nUserId INT=0
			SELECT @nUserId=UserInfoId FROM @tmpUserInfoId WHERE ID=@nCount+1
			UPDATE 
				usr_UserInfo SET StatusCodeId=@nUSERSTATUSINACTIVE,
				ModifiedBy = 1,
				ModifiedOn = dbo.uf_com_GetServerDate()	
			WHERE UserInfoId=@nUserId
			SET @nCount=@nCount+1
		END
				
		
	END TRY
	
	BEGIN CATCH	
		print 'error when updating user status as inactive.'
	END CATCH
END