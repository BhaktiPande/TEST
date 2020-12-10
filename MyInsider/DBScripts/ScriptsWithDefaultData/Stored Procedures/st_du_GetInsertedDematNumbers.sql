/*
	Created By  :	AKHILESH KAMATE
	Created On 	:	20-JUN-2017
	Description :	This stored Procedure is used to update Demat upload flag
	
	EXEC st_du_GetInsertedDematNumbers '2017-06-20 11:11:24.947', '2017-06-20 11:21:11.840'
	
*/


IF EXISTS (SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_du_GetInsertedDematNumbers')
	DROP PROCEDURE st_du_GetInsertedDematNumbers
GO

CREATE PROCEDURE st_du_GetInsertedDematNumbers
	
	@FROM_DATE	DATETIME,
	@TO_DATE	DATETIME
	
AS	
BEGIN
	SET NOCOUNT ON;
		
	SELECT 
		USR.PAN AS UserId,USR.PAN AS UserName,USR.FirstName,USR.MiddleName,USR.LastName, USR.PAN,(SELECT top 1 CompanyName FROM mst_Company WHERE CompanyId = USR.CompanyId) AS CompanyName, DMAT.DEMATAccountNumber AS [DMAT Account Number], DMAT.DPBank AS [DP Bank Name], DMAT.DPID, DMAT.TMID
	FROM 
		usr_DMATDetails AS DMAT
	INNER JOIN usr_UserInfo AS USR ON DMAT.UserInfoID = USR.UserInfoId
	WHERE 
		DMAT.CreatedOn BETWEEN @FROM_DATE AND @TO_DATE
		
	SET NOCOUNT OFF;
END
GO