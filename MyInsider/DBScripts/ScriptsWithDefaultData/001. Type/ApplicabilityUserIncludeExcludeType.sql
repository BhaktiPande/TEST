IF EXISTS (SELECT NAME FROM SYS.types WHERE NAME = 'ApplicabilityUserIncludeExcludeType')
BEGIN
	DROP TYPE ApplicabilityUserIncludeExcludeType
END
GO

CREATE TYPE ApplicabilityUserIncludeExcludeType AS TABLE 
(
    UserId INT NULL,
    InsiderTypeCodeId INT	NULL,
    IncludeExcludeCodeId INT NULL
)
