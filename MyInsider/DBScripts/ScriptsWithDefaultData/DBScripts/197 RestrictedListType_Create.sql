
CREATE TYPE [RestrictedListType] AS TABLE(
	[ComapnyId]			[INT] NULL,	
	[ApplicableFromDate][DATETIME] NOT NULL,
	[ApplicableToDate]	[DATETIME] NOT NULL	
)

----------------------------------------------------------------------------------------------------------------------

INSERT INTO DBUpdateStatus (ScriptNumber, ScriptFileName, Description, CreatedBy)
VALUES (197, '197 RestrictedListType_Create', 'RestrictedListType_Create', 'KPCS')
