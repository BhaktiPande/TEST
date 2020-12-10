/*
Script received from Gaurishankar on 12 May 2016 
Applicability Changes 

*/
IF EXISTS (SELECT NAME FROM SYS.types WHERE NAME = 'ApplicabilityFilterType')
BEGIN
	IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_rul_ApplicabilityAssociationSave')
		DROP PROCEDURE st_rul_ApplicabilityAssociationSave
		
	DROP TYPE ApplicabilityFilterType
END
GO

CREATE TYPE [dbo].[ApplicabilityFilterType] AS TABLE(
	[ApplicabilityDtlsId] [int] NULL,
	[DepartmentCodeId] [int] NULL,
	[GradeCodeId] [int] NULL,
	[DesignationCodeId] [int] NULL,
	[CategoryCodeId] [int] NULL,
	[SubCategoryCodeId] [int] NULL,
	[RoleId] [int] NULL
)
GO