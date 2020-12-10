CREATE TYPE ApplicabilityFilterType AS TABLE 
(
    ApplicabilityDtlsId INT NULL, 
    DepartmentCodeId INT NULL,
    GradeCodeId	INT	NULL,
    DesignationCodeId	INT	NULL
)
----------------------------------------------------------------------------------------------------------------------
INSERT INTO DBUpdateStatus (ScriptNumber, ScriptFileName, Description, CreatedBy)
VALUES (100, '100 ApplicabilityFilterType_Create', 'Create ApplicabilityFilterType', 'Ashashree')
