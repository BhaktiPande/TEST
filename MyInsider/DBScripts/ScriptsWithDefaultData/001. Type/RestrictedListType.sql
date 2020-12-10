IF EXISTS (SELECT NAME FROM SYS.types WHERE NAME = 'RestrictedListType')
BEGIN
	DROP TYPE RestrictedListType
END
GO

CREATE TYPE [RestrictedListType] AS TABLE(
	[ComapnyId]			[INT] NULL,	
	[ApplicableFromDate][DATETIME] NOT NULL,
	[ApplicableToDate]	[DATETIME] NOT NULL	
)
