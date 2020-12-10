IF EXISTS (SELECT NAME FROM SYS.types WHERE NAME = 'MassRistrictedMasterCompanyDataTable')
BEGIN
	IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_com_MassUploadCommonProcedureExecution')
		DROP PROCEDURE st_com_MassUploadCommonProcedureExecution
		
	DROP TYPE MassRistrictedMasterCompanyDataTable
END
GO

-- ======================================================================================================
-- Author      : GAURAV UGALE																			=
-- CREATED DATE: 25-JULY-2016                                                 							=
-- Description : THIS TABLE TYPE IS USED FOR RESTRICTED MASTER COMPANY LIST MASS-UPLOAD					=
-- ======================================================================================================

CREATE TYPE [dbo].[MassRistrictedMasterCompanyDataTable] AS TABLE
(	
	CompanyName				NVARCHAR(200),
	BSECode					NVARCHAR(50),
	NSECode					NVARCHAR(50),	
	ISIN					NVARCHAR(50)
)