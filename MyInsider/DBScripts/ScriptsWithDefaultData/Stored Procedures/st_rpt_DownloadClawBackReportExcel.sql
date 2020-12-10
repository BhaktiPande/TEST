IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_rpt_DownloadClawBackReportExcel')
DROP PROCEDURE [dbo].[st_rpt_DownloadClawBackReportExcel]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Procedure for Download Claw Back Report in Excel file.

Returns:		0, if Success.
				
Created by:		Tushar Wakchaure
Created on:		17-Aug-2018

-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_rpt_DownloadClawBackReportExcel]
	 @out_nReturnValue								INT			 = 0	OUTPUT
	,@out_nSQLErrCode								INT			 = 0	OUTPUT	-- Output SQL Error Number, if error occurred.
	,@out_sSQLErrMessage							VARCHAR(500) = ''	OUTPUT  -- Output SQL Error Message, if error occurred.	
---------------------------------------------------------------------------
AS
BEGIN

    DECLARE @ERR_CLAWBACKREPORT	INT = 50706
	BEGIN TRY
	
		SET NOCOUNT ON;
		-- Declare variables
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''


        SELECT 
	         ISNULL(Temp.EmployeeID,'-') AS 'Employee ID',
			 ISNULL(Temp.InsiderName,'-') AS 'Insider Name',
			 ISNULL(Temp.PAN,'-') AS 'PAN',
			 ISNULL(Temp.UserAddress,'-') AS 'Address',
			 Temp.PinCode AS 'Pin Code',
			 ISNULL(Temp.Country,'-') AS 'Country',
			 ISNULL(Temp.MobileNumber,'-') AS 'Mobile Number',
			 ISNULL(Temp.Email,'-') AS 'Email Address',
			 ISNULL(Temp.CompanyName,'-') AS 'Company Name',
			 Temp.TypeOfInsider AS 'Type Of Insider',
			 ISNULL(Temp.Category,'-') AS 'Category',
             ISNULL(Temp.Subcategory,'-') AS 'Subcategory',
			 ISNULL(Temp.CINDIN,'-') AS 'CIN/DIN',
			 ISNULL(Temp.Designation,'-') AS 'Designation',
			 ISNULL(Temp.Grade,'-') AS 'Grade',
			 ISNULL(Temp.Location,'-') AS 'Location',
			 ISNULL(Temp.Department,'-') AS 'Department',
			 Temp.DmatAccount AS 'Demat Details',
			 ISNULL(Temp.AccountHolderName,'-') AS 'Account Holder Name',
		     Temp.PreclearanceID AS 'Preclearance ID',
			 Temp.RequestDate AS 'Request Date',
			 Temp.SecurityType AS 'Security Type',
			 Temp.TransactionType AS 'Transaction Type',
			 Temp.TransactionDate AS 'Transaction Date',
		     Temp.Quantity AS 'Quantity',
			 Temp.Value AS 'Value'
	         FROM rpt_ClawBackReport Temp 

             RETURN 0
	END	 TRY
	
	BEGIN CATCH		
		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue	=  @ERR_CLAWBACKREPORT
	END CATCH
END