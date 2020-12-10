/*
Script received from Gaurishankar on 12 May 2016 
Applicability Changes 

*/

IF EXISTS (SELECT NAME FROM SYS.types WHERE NAME = 'NonInsEmpApplicabilityFilterType')
BEGIN
	DROP TYPE NonInsEmpApplicabilityFilterType
END
GO

CREATE TYPE [dbo].[NonInsEmpApplicabilityFilterType] AS TABLE(
	[ApplicabilityDtlsId] [int] NULL,
	[DepartmentCodeId] [int] NULL,
	[GradeCodeId] [int] NULL,
	[DesignationCodeId] [int] NULL,
	[CategoryCodeId] [int] NULL,
	[SubCategoryCodeId] [int] NULL,
	[RoleId] [int] NULL
)
GO