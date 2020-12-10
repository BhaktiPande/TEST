-- =============================================
-- Author:		Arundhati
-- Create date: 28-Apr-2015
-- Description:	Insert data in event for the event = Set password and Login for first time
-- =============================================

IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[tr_usr_Authentication_FirstLogin]'))
DROP TRIGGER [dbo].[tr_usr_Authentication_FirstLogin]
GO

/*
Modified By	Modified On	Description
Raghvendra	07-Sep-2016	Changed the GETDATE() call with function dbo.uf_com_GetServerDate(). This function will return the date to be used as server date.

*/

CREATE TRIGGER [dbo].[tr_usr_Authentication_FirstLogin] ON [dbo].[usr_Authentication]
FOR UPDATE
AS
BEGIN
	DECLARE @nEventCodeID INT = 153005 -- User Logs in/sets password
	DECLARE @nUserInfoId INT
	DECLARE @nModifiedBy INT
	DECLARE @nMapToType INT = 132003

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	--SELECT * INTO #tmpValues_Old FROM deleted
	SELECT * INTO #tmpValues_New FROM inserted

	SELECT @nUserInfoId = UserInfoId, @nModifiedBy = ModifiedBy FROM #tmpValues_New

	IF NOT EXISTS (SELECT EventLogId FROM eve_EventLog WHERE UserInfoId = @nUserInfoId AND EventCodeId = @nEventCodeID) AND @nModifiedBy = @nUserInfoId
	BEGIN
		INSERT INTO eve_EventLog(EventCodeId, EventDate, UserInfoId, MapToTypeCodeId, MapToId)
		SELECT @nEventCodeID, dbo.uf_com_GetServerDate(), UserInfoId, @nMapToType, UserInfoId
		FROM #tmpValues_New
	END

END
GO
