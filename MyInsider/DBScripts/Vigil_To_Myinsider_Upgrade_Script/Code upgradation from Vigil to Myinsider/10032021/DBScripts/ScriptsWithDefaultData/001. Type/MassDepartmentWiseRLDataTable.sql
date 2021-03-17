IF EXISTS (SELECT NAME FROM SYS.types WHERE NAME = 'MassDepartmentWiseRLDataTable')
BEGIN
	IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_com_MassUploadCommonProcedureExecution')
		DROP PROCEDURE st_com_MassUploadCommonProcedureExecution
		
	DROP TYPE MassDepartmentWiseRLDataTable
END
GO
-- ======================================================================================================
-- Author      : GAURAV UGALE																			=
-- CREATED DATE: 25-JULY-2016                                                 							=
-- Description : THIS TABLE TYPE IS USED FOR DEPARTMENT WISE RESTRICTED LIST MASS-UPLOAD				=
-- ======================================================================================================

CREATE TYPE [dbo].[MassDepartmentWiseRLDataTable] AS TABLE
(		
	CompanyName				NVARCHAR(200),
	ISINCode				NVARCHAR(500),
	ApplicableFrom			DATETIME,
	ApplicableTo			DATETIME,
	MassCounter				INT
)
