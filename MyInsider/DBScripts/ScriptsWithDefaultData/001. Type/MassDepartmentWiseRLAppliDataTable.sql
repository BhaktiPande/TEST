
IF EXISTS (SELECT NAME FROM SYS.types WHERE NAME = 'MassDepartmentWiseRLAppliDataTable')
BEGIN
	IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_com_MassUploadCommonProcedureExecution')
		DROP PROCEDURE st_com_MassUploadCommonProcedureExecution
		
	DROP TYPE MassDepartmentWiseRLAppliDataTable
END
GO
-- ======================================================================================================
-- Author      : GAURAV UGALE																			=
-- CREATED DATE: 25-JULY-2016                                                 							=
-- Description : THIS TABLE TYPE IS USED FOR DEPARTMENT WISE RESTRICTED LIST MASS-UPLOAD				=
-- ======================================================================================================

CREATE TYPE [dbo].[MassDepartmentWiseRLAppliDataTable] AS TABLE
(		
	Department				NVARCHAR(300),	
	Designation				NVARCHAR(300)
)