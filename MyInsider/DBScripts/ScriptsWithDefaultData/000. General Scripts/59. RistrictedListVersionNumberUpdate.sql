/*Script By Priyanka,Vivek Dated- 04 Jan 2018 */
/*UPDATE OLD RECORDS WITH RlMasterVersionNumber FROM rl_RistrictedMasterList TABLE*/
DECLARE @COUNT INT
DECLARE @FLAG1 INT
DECLARE @FLAG2 INT
DECLARE @ISFOUND INT
SET @ISFOUND = (SELECT TOP 1 RlMasterVersionNumber FROM rl_RistrictedMasterList)
IF (@ISFOUND IS NULL)
BEGIN
	SET @COUNT = (SELECT COUNT(*) FROM rl_RistrictedMasterList)
	SET @FLAG1 = 1
	SET @FLAG2 = 1
   	WHILE(@FLAG1<=@COUNT)
	BEGIN
		WHILE(@FLAG2 <= @COUNT)
		BEGIN
			IF EXISTS(SELECT * FROM rl_RistrictedMasterList WHERE RlMasterId = @FLAG1)
			BEGIN
				UPDATE rl_RistrictedMasterList SET RlMasterVersionNumber = @FLAG2 WHERE RlMasterId=@FLAG1
				SET @FLAG2 = @FLAG2 + 1 
			END
			SET @FLAG1 = @FLAG1 + 1 
		END
	END
END

/* Script By Tushar Dated- 10 Jan 2018 */
/* Deleted Duplicate Entry of security type coloumn in Disclosure details grid (before submission)*/
DECLARE @RecordCount INT
SET @RecordCount = (SELECT COUNT(GridTypeCodeId) FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114031 AND ResourceKey ='tra_grd_16429' AND OverrideGridTypeCodeId IS NULL)
IF(@RecordCount > 1)
BEGIN
  DELETE TOP(@RecordCount - 1) FROM com_GridHeaderSetting WHERE GridTypeCodeId = 114031 and ResourceKey ='tra_grd_16429' and OverrideGridTypeCodeId IS NULL
END

/* INSERT INTO mst_Resource */
IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 50771)
BEGIN
	INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
	VALUES (50771,'cmp_msg_50771','Entry is already present for the same date period','en-US',103005,104001,122012,'Entry is already present for the same date period',1,GETDATE())
END