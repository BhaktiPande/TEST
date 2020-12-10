CREATE TYPE ApplicabilityUserIncludeExcludeType AS TABLE 
(
    UserId INT NULL,
    InsiderTypeCodeId INT	NULL,
    IncludeExcludeCodeId INT NULL
)
----------------------------------------------------------------------------------------------------------------------
INSERT INTO DBUpdateStatus (ScriptNumber, ScriptFileName, Description, CreatedBy)
VALUES (101, '101 ApplicabilityUserIncludeExcludeType_Create', 'Create ApplicabilityUserIncludeExcludeType', 'Ashashree')
