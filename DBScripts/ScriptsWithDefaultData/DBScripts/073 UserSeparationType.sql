-- ================================
-- Create User-defined Table Type
-- ================================
-- Create the data type
CREATE TYPE [dbo].[UserSeparationType] AS TABLE 
(
	UserInfoId INT NOT NULL, 
	DateOfSeparation DATETIME NOT NULL, 
	ReasonForSeparation NVARCHAR(200) NOT NULL
)
----------------------------------------------------------------------------------------------------------------------
INSERT INTO DBUpdateStatus (ScriptNumber, ScriptFileName, Description, CreatedBy)
VALUES (73, '073 UserSeparationType', 'Create type UserSeparationType', 'Ashish')
