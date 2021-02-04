
DECLARE @DBNAME VARCHAR(100) = UPPER((SELECT DB_NAME()))

If (@DBNAME='myinsider_indiarf')
BEGIN 
	IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 55400)
	BEGIN
		INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
		VALUES (55400,'dis_msg_55400','You are required to execute the trade within 5 calendar days of the date of approval. The details of such trade should be submitted in the system within 7 calendar days of the execution of the trade. In case the transaction is not undertaken, a reporting to that effect shall be filed in the system.','en-US',103009,104001,122044,'You are required to execute the trade within 5 calendar days of the date of approval. The details of such trade should be submitted in the system within 7 calendar days of the execution of the trade. In case the transaction is not undertaken, a reporting to that effect shall be filed in the system.',1,GETDATE())
	END
END

ELSE
	BEGIN 
	IF NOT EXISTS(SELECT ResourceId FROM mst_Resource WHERE ResourceId = 55400)
	BEGIN
		INSERT INTO mst_Resource([ResourceId],[ResourceKey],[ResourceValue],[ResourceCulture],[ModuleCodeId],[CategoryCodeId],[ScreenCodeId],[OriginalResourceValue],[ModifiedBy],[ModifiedOn])
		VALUES (55400,'dis_msg_55400',' You are required to file within 2 trading days of the execution of the trade, the details of such trade with the Compliance Officer in the Form F. In case the transaction is not undertaken, a report to that effect shall be filed in Form F within 2 trading days of the expiry of the validity of pre-clearance.','en-US',103009,104001,122044,' You are required to file within 2 trading days of the execution of the trade, the details of such trade with the Compliance Officer in the Form F. In case the transaction is not undertaken, a report to that effect shall be filed in Form F within 2 trading days of the expiry of the validity of pre-clearance.',1,GETDATE())
	END
END

