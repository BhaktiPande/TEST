/*9-Oct-2015 : Script to update fields MapToId and MapToTypeCodeId as NOT NULL for table eve_eventLog*/

UPDATE eve_eventLog SET MapToId = UserInfoId, MapToTypeCodeId = 132003 WHERE (MapToId IS NULL OR MapToTypeCodeId IS NULL)

ALTER TABLE eve_EventLog ALTER COLUMN MapToId INTEGER NOT NULL 

ALTER TABLE eve_EventLog ALTER COLUMN MapToTypeCodeId INTEGER NOT NULL
----------------------------------------------------------------------------------------------------------------------

INSERT INTO DBUpdateStatus (ScriptNumber, ScriptFileName, Description, CreatedBy)
VALUES (193, '193 eve_EventLog_Alter', 'eve_EventLog Alter to make MapToId, MapToTypeCodeId NOT NULL', 'Ashashree')
