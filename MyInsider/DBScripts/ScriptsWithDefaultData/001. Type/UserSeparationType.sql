-- ================================
-- Create User-defined Table Type
-- ================================
-- Create the data type

IF EXISTS (SELECT NAME FROM SYS.types WHERE NAME = 'UserSeparationType')
BEGIN
	DROP TYPE UserSeparationType
END
GO

CREATE TYPE [dbo].[UserSeparationType] AS TABLE(
	[UserInfoId] int NOT NULL,
	[DateOfSeparation] datetime NOT NULL,
	[ReasonForSeparation] nvarchar(200) NOT NULL,
	NoOfDaysToBeActive INT NULL,
	DateOfInactivation DATETIME NULL
)
----------------------------------------------------------------------------------------------------------------------
