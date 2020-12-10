IF (OBJECT_ID('TRG_RLMasterList','tr')IS NOT NULL)
BEGIN
DROP TRIGGER TRG_RLMasterList
END
Go
-- ======================================================================================
-- Author      : Gaurav Ugale															=
-- CREATED DATE: 29-SEP-2015                                                 			=
-- Description : THIS TRIGGER IS USED TO MAINTAIN AUDIT FOR RISTRICTED MASTER LIST      =
--
/*Modified By	ModifiedOn	Description
ED		01-Mar-2016	Code merging done on 01-Mar-2016																						=

*/
-- ======================================================================================


CREATE TRIGGER TRG_RLMasterList ON [rl_RistrictedMasterList]
AFTER UPDATE
AS
	DECLARE @EventCodeId		INT;
	DECLARE @EventDate			DATETIME;
	DECLARE @UserInfoId			INT;
	DECLARE @MapToTypeCodeId	INT;
	DECLARE @MapToId			INT;
	DECLARE @CreatedBy			INT;
	
	SELECT @EventCodeId = 153044--153043;
	SELECT @EventDate = I.ApplicableToDate FROM inserted I;
	SELECT @MapToTypeCodeId = 132012--132004;
	SELECT @MapToId = I.RlMasterId FROM inserted I;
	SELECT @CreatedBy = I.CreatedBy FROM inserted I
	
	INSERT INTO eve_EventLog
	(
		EventCodeId, EventDate, UserInfoId, MapToTypeCodeId, MapToId, CreatedBy
	)
	SELECT @EventCodeId , @EventDate, @CreatedBy, @MapToTypeCodeId, 
		@MapToId, @CreatedBy 
	
GO
