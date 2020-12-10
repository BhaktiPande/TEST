IF EXISTS (SELECT NAME FROM SYS.types WHERE NAME = 'MassRestrictedListAppliDataTable')
BEGIN
	IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_com_MassUploadCommonProcedureExecution')
		DROP PROCEDURE st_com_MassUploadCommonProcedureExecution
		
	DROP TYPE MassRestrictedListAppliDataTable
END
GO

-- ======================================================================================================
-- Author      : GAURAV UGALE																		=
-- CREATED DATE: 25-JULY-2016                                                 							=
-- Description : THIS TABLE TYPE IS USED FOR RESTRICTED LIST Mass-Upload								=
-- ======================================================================================================

CREATE TYPE [dbo].[MassRestrictedListAppliDataTable] AS TABLE
(		
	EmployeeId				NVARCHAR(100),
	EmployeeName			NVARCHAR(100),
	CompanyName				NVARCHAR(200),
	ISIN					NVARCHAR(50),
	NSECode					NVARCHAR(50),
	BSECode					NVARCHAR(50),
	ApplicableFrom			DATETIME,
	ApplicableTo			DATETIME	
)