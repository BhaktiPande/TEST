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
	
SELECT
	[CompanyName] AS [Company Name],	
	[Department] AS [Department],	
	[BSECode] AS [BSECode],	
	[NSECode] AS [NSECode],	
	[ISINCode] AS [ISINCode],	
	[ApplicableFromDate] AS [Applicable From Date],	
	[ApplicableToDate] AS [Applicable To Date]
FROM 
	rpt_RestrictedListDetails		
	
	END	 TRY	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue	=  0
	END CATCH
END