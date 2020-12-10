/*Data table for updating the hash codes for insider type users in bulk after performing mass upload for corresponding users.*/
CREATE TYPE EmployeeHashCode AS TABLE 
(
	LoginId NVARCHAR(255),
	HashCode NVARCHAR(3000)
)
GO

INSERT INTO DBUpdateStatus (ScriptNumber, ScriptFileName, Description, CreatedBy)
VALUES (224, '224 EmployeeHashCode_Create', 'EmployeeHashCode Create Type', 'Raghvendra')

