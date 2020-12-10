CREATE TYPE NotificationQueueResponse AS TABLE 
(
	RowId INT NOT NULL, --Running Id starting from 1 onwards, to uniquely idetify records in the table type
    NotificationQueueId BIGINT NOT NULL,
    CompanyIdentifierCodeId INT NULL,
    ResponseStatusCodeId INT NULL,
    ResponseMessage	NVARCHAR(200) NULL
)
----------------------------------------------------------------------------------------------------------------------
INSERT INTO DBUpdateStatus (ScriptNumber, ScriptFileName, Description, CreatedBy)
VALUES (2, '002 NotificationQueueResponse_TableType_Create', 'Create NotificationQueueResponse TableType', 'Ashashree')
