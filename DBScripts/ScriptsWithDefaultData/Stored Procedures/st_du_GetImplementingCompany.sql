/*
	Created By  :	AKHILESH KAMATE
	Created On 	:	03-MAR-2016
	Description :	This stored Procedure is used to get GetImplementingCompany from du_MappingTables table
	
	EXEC st_du_GetImplementingCompany 0,0,''
*/


IF EXISTS (SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_du_GetImplementingCompany')
	DROP PROCEDURE st_du_GetImplementingCompany
GO

CREATE PROCEDURE st_du_GetImplementingCompany
	@out_nReturnValue		INT = 0 OUTPUT,
	@out_nSQLErrCode		INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage		NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
AS	
BEGIN
	SET NOCOUNT ON;
	
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''
				
		SELECT TOP 1 CompanyName FROM mst_Company WHERE IsImplementing = 1
		
		
	SET NOCOUNT OFF;
END