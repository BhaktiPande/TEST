/*
	Created By  :	Akhilesh Kamate
	Created On 	:	12-Mar-2016
	Description :	This type is used to update seperation
	
*/

IF NOT EXISTS (SELECT 1 FROM SYS.TYPES ST JOIN SYS.SCHEMAS SS ON ST.schema_id = SS.schema_id WHERE (ST.name = N'du_type_UpdateSeperation') AND (SS.name = N'dbo'))
BEGIN
	CREATE TYPE du_type_UpdateSeperation AS TABLE 
	(
		[EmployeeId] VARCHAR(MAX) NOT NULL,
		[DateOfSeparation] DATETIME NOT NULL,
		[ReasonForSeparation] NVARCHAR(200) NOT NULL,
		[NoOfDaysToBeActive] INT NULL
	)	
END
GO
