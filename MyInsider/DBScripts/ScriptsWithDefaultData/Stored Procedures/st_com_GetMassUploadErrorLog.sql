IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_com_GetMassUploadErrorLog')
	DROP PROCEDURE st_com_GetMassUploadErrorLog
GO 

/*
	Created By  :	Manasi Patil
	Created On 	:	29-DEC-2015
	Description :	This stored Procedure is used to get the Error Log for
					View Error Log Report
	
	EXEC st_com_GetMassUploadErrorLog '1,2', '2015-09-01 00:00:00', '2016-01-01 00:00:00'
*/


CREATE PROCEDURE [dbo].[st_com_GetMassUploadErrorLog]
	@inp_iMassUploadTypeId  VARCHAR(200),
	@inp_iFromDate			DATE,
	@inp_iToDate			DATE	
AS
BEGIN
	SELECT DISTINCT dbo.uf_rpt_ReplaceSpecialChar(UU.FirstName) + dbo.uf_rpt_ReplaceSpecialChar(ISNULL(UU.MiddleName,'')) + dbo.uf_rpt_ReplaceSpecialChar( ISNULL(UU.LastName,'')) AS [UserName], dbo.uf_rpt_ReplaceSpecialChar(CMUE.MassUploadExcelId) AS [MassUploadExcelId], dbo.uf_rpt_ReplaceSpecialChar(CMUE.MassUploadName) AS [Mass Upload Name], dbo.uf_rpt_ReplaceSpecialChar(CTM.ErrorMessage)AS [ErrorMessage], dbo.uf_rpt_ReplaceSpecialChar(REPLACE(CONVERT(NVARCHAR, CTM.CreatedOn, 106),' ','/')) AS [ErrorOccurredOn]
	FROM com_tbl_MassUploadLog AS CTM
	INNER JOIN usr_UserInfo AS UU ON UU.UserInfoId = CTM.CreatedBy
	INNER JOIN eve_EventLog AS EE ON EE.UserInfoId = CTM.CreatedBy 
	INNER JOIN com_MassUploadExcel AS CMUE ON CMUE.MassUploadExcelId = CTM.MassUploadTypeId
	WHERE CONVERT(DATE, CTM.CreatedOn) BETWEEN CONVERT(DATE, @inp_iFromDate) AND CONVERT(DATE, @inp_iToDate) AND CONVERT(VARCHAR(200), CTM.MassUploadTypeId) IN (SELECT [PARAM] FROM FN_VIGILANTE_SPLIT(@inp_iMassUploadTypeId, ','))
END	