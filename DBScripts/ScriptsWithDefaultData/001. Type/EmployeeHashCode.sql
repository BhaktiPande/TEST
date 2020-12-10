/*Data table for updating the hash codes for insider type users in bulk after performing mass upload for corresponding users.*/

IF EXISTS (SELECT NAME FROM SYS.types WHERE NAME = 'EmployeeHashCode')
BEGIN
	DROP TYPE EmployeeHashCode
END
GO

CREATE TYPE EmployeeHashCode AS TABLE 
(
	LoginId NVARCHAR(255),
	HashCode NVARCHAR(3000)
)
GO