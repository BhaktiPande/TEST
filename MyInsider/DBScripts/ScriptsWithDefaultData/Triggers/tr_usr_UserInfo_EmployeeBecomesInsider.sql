-- =============================================
-- Author:		Ashashree
-- Create date: 16-Jul-2015
-- Description:	Insert data in event log table for event "Employee becomes Insider(153003)", when DateOfBecomingInsider gets set for user of type Employee(101003)
-- =============================================

IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[tr_usr_UserInfo_EmployeeBecomesInsider]'))
DROP TRIGGER [dbo].[tr_usr_UserInfo_EmployeeBecomesInsider]
GO

CREATE TRIGGER [dbo].[tr_usr_UserInfo_EmployeeBecomesInsider] ON [dbo].[usr_UserInfo]
FOR INSERT, UPDATE
AS
BEGIN
	DECLARE @nEventCodeID INT = 153003
	DECLARE @nMapToType INT = 132003
	DECLARE @nUserTypeCodeId_Employee INT = 101003
	
	DECLARE @nUserInfoId INT
	DECLARE @nUserTypeCodeId INT
	DECLARE @dtNewDateOfBecomingInsider DATETIME
	
	DECLARE @dtOldDateOfBecomingInsider DATETIME
	
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT * INTO #tmpValues_New FROM INSERTED
	SELECT * INTO #tmpValues_Old FROM DELETED

	SELECT @nUserInfoId = UserInfoId, @nUserTypeCodeId = UserTypeCodeId, @dtNewDateOfBecomingInsider = ISNULL(DateOfBecomingInsider,NULL) 
	FROM #tmpValues_New tmpNew
	
	--Get the DateOfBecomingInsider if already assigned to user. Will be NULL is not assigned or during INSERT to table usr_UserInfo
	SELECT @dtOldDateOfBecomingInsider = ISNULL(DateOfBecomingInsider,NULL) FROM #tmpValues_Old WHERE UserInfoId = @nUserInfoId
	
	--If user is Employee and DateOfBecomingInsider field is not null at the time of INSERT/UPDATE to table usr_UserInfo only then add eventlog entry
	IF(@nUserTypeCodeId = @nUserTypeCodeId_Employee AND @dtOldDateOfBecomingInsider IS NULL AND @dtNewDateOfBecomingInsider IS NOT NULL)
	BEGIN
		INSERT INTO eve_EventLog(EventCodeId, EventDate, UserInfoId, MapToTypeCodeId, MapToId)
		VALUES (@nEventCodeID, @dtNewDateOfBecomingInsider , @nUserInfoId, @nMapToType, @nUserInfoId)
	END
	
    -- Insert statements for trigger here

END
GO
