
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[tr_usr_UserInfo_UserUpdated]'))
DROP TRIGGER [dbo].[tr_usr_UserInfo_UserUpdated]
GO

/*
Modified By	Modified On	Description
Raghvendra	07-Sep-2016	Changed the GETDATE() call with function dbo.uf_com_GetServerDate(). This function will return the date to be used as server date.
*/

CREATE TRIGGER [dbo].[tr_usr_UserInfo_UserUpdated] ON [dbo].[usr_UserInfo]
FOR UPDATE
AS
BEGIN
	DECLARE @nEventCodeID INT = 153048
	DECLARE @nMapToType INT = 132006
	
	DECLARE @nUserTypeCodeId_COUser INT = 101002
	DECLARE @nUserTypeCodeId_Employee INT = 101003
	DECLARE @nUserTypeCodeId_CorporateUser INT = 101004
	DECLARE @nUserTypeCodeId_NonEmployee INT = 101006
	
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	SELECT * INTO #tmpValues_New FROM INSERTED

	-- 
	DECLARE @DateOfSeparation date = (select DateOfSeparation from #tmpValues_New)
	DECLARE @DateOfInactivation date = (select DateOfInactivation from #tmpValues_New)

	IF(@DateOfSeparation IS NOT NULL AND @DateOfInactivation IS NOT NULL )
	BEGIN
	--print 'Update'
	INSERT INTO eve_EventLog(EventCodeId, EventDate, UserInfoId, MapToTypeCodeId, MapToId)
	SELECT @nEventCodeID, dbo.uf_com_GetServerDate(), UserInfoId, @nMapToType, UserInfoId
	FROM #tmpValues_New
	WHERE UserTypeCodeId IN (@nUserTypeCodeId_COUser, @nUserTypeCodeId_CorporateUser, @nUserTypeCodeId_Employee, @nUserTypeCodeId_NonEmployee)
	END
    -- Insert statements for trigger here

END
