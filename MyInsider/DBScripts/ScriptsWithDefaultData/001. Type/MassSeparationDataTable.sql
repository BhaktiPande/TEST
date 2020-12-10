IF EXISTS (SELECT NAME FROM SYS.types WHERE NAME = 'MassSeparationDataTable')
BEGIN
	IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_com_MassUploadCommonProcedureExecution')
		DROP PROCEDURE st_com_MassUploadCommonProcedureExecution
		
	DROP TYPE MassSeparationDataTable
END
GO
-- ======================================================================================================
-- Author      : Gaurav Ugale																			=
-- CREATED DATE: 05-APR-2016                                                 							=
-- Description : THIS TABLE TYPE IS USED FOR USER SEPARATION Mass-Upload								=
-- ======================================================================================================
CREATE TYPE [dbo].[MassSeparationDataTable] AS TABLE
(	
	LoginId					NVARCHAR(200) NOT NULL,
	EmployeeId				NVARCHAR(200),
	PAN						NVARCHAR(10),
	DateOfSeparation		DATETIME NOT NULL,
	ReasonForSeparation		NVARCHAR(200) NOT NULL,
	NoOfDaysToBeActive		INT NULL		
)
