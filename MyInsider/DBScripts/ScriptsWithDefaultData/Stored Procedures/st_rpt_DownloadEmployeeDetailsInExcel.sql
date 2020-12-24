IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_rpt_DownloadEmployeeDetailsInExcel')
DROP PROCEDURE dbo.st_rpt_DownloadEmployeeDetailsInExcel
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[st_rpt_DownloadEmployeeDetailsInExcel] 
	 @out_nReturnValue					INT = 0 OUTPUT
	,@out_nSQLErrCode					INT = 0 OUTPUT				-- Output SQL Error Number, if error occurred.
	,@out_sSQLErrMessage				VARCHAR(500) = '' OUTPUT  -- Output SQL Error Message, if error occurred.	
---------------------------------------------------------------------------
AS
BEGIN		
			
SELECT 

	EmployeeID AS 'User ID',
	UserName AS 'User Name', 
	FirstName AS 'First Name', 		
	MiddleName AS 'Middle Name', 	
	LAStName AS 'LASt Name', 
	CompanyName AS 'Company Name',
	RoleName AS 'Role',
	AddressLine1 AS 'Address',
	PinCode AS 'Pin Code',
	CountryName AS 'Country',
	EmailId AS 'Email Address',
	MobileNumber AS 'Mobile Number', 
	PAN AS 'Permanent Account Number',
    CASE WHEN DateOfJoining='-' THEN '-' ELSE CONVERT(VARCHAR, CAST(DateOfJoining AS DATETIME), 106) END AS 'Date Of Joining',				 
   	CASE WHEN DateOfBecomingInsider='-' THEN '-' ELSE CONVERT(VARCHAR, CAST(DateOfBecomingInsider AS DATETIME), 106)  END AS 'Date Of Becoming Insider',				 
	EmpStatus AS 'Live/ Seperated', 
	CASE WHEN DateOfSeparation='-' THEN '-' ELSE CONVERT(VARCHAR, CAST(DateOfSeparation AS DATETIME), 106) END AS 'Date of Seperation',				        
	EmpActiveInactive AS 'Status',	
	CASE WHEN DateOfInactivation='-' THEN '-' ELSE CONVERT(VARCHAR, CAST(DateOfInactivation AS DATETIME), 106) END AS 'Date of Inactivation',				        	
	Category AS 'Category',
	SubCategory	AS 'SubCategory',					    
	Designation  AS 'Designation',
	[Sub-Designation] AS 'Sub-Designation',
	Grade AS 'Grade',
	Location AS 'Location',
	DIN AS 'DIN', 
	Department AS 'Department',					    
	TradingPolicyName AS 'Applicable Trading Policy Name',    
	CASE WHEN TradePolicyFromDate='-' THEN '-' ELSE CONVERT(VARCHAR, CAST(TradePolicyFromDate AS DATETIME), 106) END AS 'Trading Policy From Date',				        	
	CASE WHEN TradePolicyToDate='-' THEN '-' ELSE CONVERT(VARCHAR, CAST(TradePolicyToDate AS DATETIME), 106) END AS 'Trading Policy To Date',				        	
	SecurityType AS 'Security Type',
	SelfHoldings AS 'Self Holdings',
	RelativesHolding AS 'Relatives Holding',
	TotalHoldingsSelfRelatives AS 'Total Holdings (Self & Relatives)'
		    
FROM

	rpt_EmployeeHoldingDetails 
		
END				
					 
					
				
					      

