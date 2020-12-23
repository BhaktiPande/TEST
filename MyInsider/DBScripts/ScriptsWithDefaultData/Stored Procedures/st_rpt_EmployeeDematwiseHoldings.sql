IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_rpt_EmployeeDematwiseHoldings')
DROP PROCEDURE [dbo].[st_rpt_EmployeeDematwiseHoldings]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*-------------------------------------------------------------------------------------------------
Description:	Procedure to list Employee DematWiseHoldings.

Returns:		0, if Success.
				
Created by:		Harish
Created on:		21/12/2017

Modification History:

Modified By		Modified On		Description

Usage:

EXEC st_rpt_EmployeeDematwiseHoldings
----------------------------------------------------------*/
CREATE PROCEDURE [dbo].[st_rpt_EmployeeDematwiseHoldings]
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
			
SELECT
	[UserName] AS [UserName],
	[EmployeeId] AS [Employee ID],
	[SelfOrRelative] AS [Self/Relative],
	[Relation] AS [Relation],
	[FirstName] AS [First Name],
	[MiddleName] AS [Middle Name],
	[LastName] AS [Last Name],
	[AddressLine1] AS  [Address],
	[PinCode] AS [PinCode],
	[CountryName] AS [Country],
	[EmailId] AS [Email Address],
	[MobileNumber] AS [Mobile Number],
	[PAN] AS [Permanent Account Number],	
	[RoleName] AS [Role],
	[CompanyName] AS [Company Name],	
	CASE WHEN DateOfBecomingInsider='-' THEN '-' ELSE CONVERT(VARCHAR, CAST(DateOfBecomingInsider AS DATETIME), 106)  END AS [Date Of Becoming Insider],				 
	[EmpStatus] AS [Live/ Seperated],	
	CASE WHEN DateOfSeparation='-' THEN '-' ELSE CONVERT(VARCHAR, CAST(DateOfSeparation AS DATETIME), 106)  END AS [Date of Seperation],				 
	[EmpActiveInactive] AS [Status],	
	CASE WHEN DateOfInactivation='-' THEN '-' ELSE CONVERT(VARCHAR, CAST(DateOfInactivation AS DATETIME), 106)  END AS [Date of Inactivation],				 
	[Category] AS [Category],
	[SubCategory] AS [SubCategory],
	[Designation] AS [Designation],
	[Sub-Designation] AS [Sub-Designation],
	[Grade] AS [Grade],
	[Location] AS [Location],
	[DIN] AS [DIN], 		
	[Department] AS [Department],
	[SecurityType] AS [Security Type],
	[DMATAccNumber] AS [DMAT AccNumber],
	[DepositParticipantName] AS [Depository Participant Name],
	[DepositParticipantID] AS [Depository Participant ID],
	[TMID] AS [TMID],
	[Holdings] AS [Holdings]
FROM 
	rpt_EmpDematwiseDetails	

	RETURN 0
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue	=  0
	END CATCH

END

