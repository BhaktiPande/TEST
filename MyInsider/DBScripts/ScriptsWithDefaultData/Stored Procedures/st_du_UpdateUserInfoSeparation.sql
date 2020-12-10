/*
	Created By  :	AKHILESH KAMATE
	Created On 	:	12-Mar-2016
	Description :	This stored Procedure is used to update seperation information
*/


IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_du_UpdateUserInfoSeparation')
DROP PROCEDURE [dbo].[st_du_UpdateUserInfoSeparation]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/*
Modified By	Modified On	Description
Raghvendra	07-Sep-2016	Changed the GETDATE() call with function dbo.uf_com_GetServerDate(). This function will return the date to be used as server date.
*/


CREATE PROCEDURE [dbo].[st_du_UpdateUserInfoSeparation] 
	@inp_tblUserSeparationType du_type_UpdateSeperation READONLY,
	@inp_iLoggedInUserId	INT = null,						-- Id of the user updating 
	@out_nReturnValue		INT = 0 OUTPUT,
	@out_nSQLErrCode		INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage		NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
AS
BEGIN
	DECLARE @ERR_USERDETAILS_SAVE INT = 11231 -- Error occurred while saving User separation Details
	DECLARE @ERR_USERDETAILS_NOTFOUND INT = 11025 -- User does not exist.
	DECLARE @nUserInfoId INT
	BEGIN TRY
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;
		
		UPDATE usr_UserInfo
		SET DateOfSeparation = UST.DateOfSeparation,
			ReasonForSeparation = UST.ReasonForSeparation,
			NoOfDaysToBeActive = DATEDIFF(day,UST.DateOfSeparation,CASE WHEN USI.Category = 112001 THEN DATEADD(day,180,UST.DateOfSeparation) ELSE UST.DateOfSeparation END),
			StatusCodeId = 102001,
			DateOfInactivation = CASE WHEN USI.Category = 112001 THEN DATEADD(day,180,UST.DateOfSeparation) ELSE UST.DateOfSeparation END,
			ModifiedBy = @inp_iLoggedInUserId,
			ModifiedOn = dbo.uf_com_GetServerDate()
		FROM @inp_tblUserSeparationType UST
		INNER JOIN 	usr_UserInfo USI on UST.EmployeeId = USI.EmployeeId
		
		SET @out_nReturnValue = 0
		RETURN @out_nReturnValue
	END	 TRY
	
	BEGIN CATCH	
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()	
		
		-- Return common error if required, otherwise specific error.		
		SET @out_nReturnValue =  dbo.uf_com_GetErrorCode(@ERR_USERDETAILS_SAVE, ERROR_NUMBER())
		RETURN @out_nReturnValue
	END CATCH

END