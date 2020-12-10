IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_rpt_DigitalDatabase')
	DROP PROCEDURE st_rpt_DigitalDatabase
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
Description:	Procedure to list of Employee details.

Returns:		0, if Success.
				
Created by:		AniketS
Created on:		24-July-2019

Modification History:

Modified By		Modified On		Description

Usage:

EXEC st_rpt_DigitalDatabase
----------------------------------------------------------*/
CREATE PROCEDURE [dbo].[st_rpt_DigitalDatabase]
	 @out_nReturnValue				INT = 0 OUTPUT
	,@out_nSQLErrCode				INT = 0 OUTPUT				-- Output SQL Error Number, if error occurred.
	,@out_sSQLErrMessage			VARCHAR(500) = '' OUTPUT  -- Output SQL Error Message, if error occurred.	
AS
BEGIN
    
	BEGIN TRY
			SET NOCOUNT ON;

		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''

				SELECT EmployeeName,
				IdentificationNo,
				Designation + ',' + EmployeeID + ',' + Department + ',' + Location + ',' + Mobile AS 'Designation/Emp.No./Dept./Div./Location & Phone/ Mobile No.',
				RelativeName + ',' + RelationWithEmployee + ',' + RelativePAN + ',' + RelativeMobile AS 'Names of Immediate Relatives & Persons with material financial relationship, their PAN & mobile no. as disclosed by DP',
				Education + ',' + EducationYears + ',' + PastEmployers + ',' + PastEmployersYears AS 'Names of educational institutions attended & Past Employer(s) of DP',
				DematAccountNumber AS 'DP. BEN ID. or Folio No',			
				ISNULL(CONVERT(VARCHAR(50), DateOfBecomingInsider, 106),'') AS 'Date of identification',
				ISNULL(CONVERT(VARCHAR(50), DateOfSeparation, 106),'') AS 'Date of cessation'
				FROM VW_DIGITALDATABASE		

	RETURN 0
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue	=  0
	END CATCH

END