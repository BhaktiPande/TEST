IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_rpt_DepartmentwiseRestricedListDetails')
DROP PROCEDURE [dbo].[st_rpt_DepartmentwiseRestricedListDetails]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- ======================================================================================================
-- Author			: Aniket Shingate																	=
-- Created date		: 22-JAN-2018                                                 						=
-- Description		: THIS PROCEDURE USED FOR SAVE SECURITY QUESTIONS									=

-- Modified By	  Modified On		Description
-- Sandesh Lande  17-Mar-2021		Added new columns in rpt_RestrictedListDetails, This table returning all column data.
-- ======================================================================================================
CREATE PROCEDURE [dbo].[st_rpt_DepartmentwiseRestricedListDetails]
	@out_nReturnValue		INT = 0 OUTPUT,
	@out_nSQLErrCode		INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage		NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
AS
BEGIN
	DECLARE @RestrictedListType INT = 132012	

	BEGIN TRY
	
	SET NOCOUNT ON;
	
--SELECT DISTINCT
--	[CompanyName] AS [Company Name],	
--	[Department] AS [Department],	
--	[BSECode] AS [BSECode],	
--	[NSECode] AS [NSECode],	
--	[ISINCode] AS [ISINCode],	
--	[ApplicableFromDate] AS [Applicable From Date],	
--	[ApplicableToDate] AS [Applicable To Date]
--FROM 
--	rpt_RestrictedListDetails		
	
	SELECT distinct
	ROW_NUMBER() OVER (ORDER BY [EmployeeId]) AS [Sr No.],
	[EmployeeId] AS [Designated Person ID],
	[PersonName] AS [Designated Person Name],
	[PAN] AS [PAN],
	[Department] AS [Department],	
	[Designation] AS [Designation],
	[Category] AS [Category],
	[Role] AS [Role],
	[CompanyName] AS [Company Name],	
	[ISINCode] AS [ISINCode],	
	[NSECode] AS [NSECode],	
	[BSECode] AS [BSECode],	
	[ApplicableFromDate] AS [Applicable From Date],	
	[ApplicableToDate] AS [Applicable To Date]
FROM 
	rpt_RestrictedListDetails
	ORDER BY [EmployeeId];

	END	 TRY	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue	=  0
	END CATCH
END