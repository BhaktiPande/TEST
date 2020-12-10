IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_MCQ_AutoSearchList')
	DROP PROCEDURE st_MCQ_AutoSearchList
GO
-- ======================================================================================
-- Author      : Samadhan Kadam									 
-- CREATED DATE: 15-Jun-2019                                                 		 
-- Description : THIS PROCEDURE FETCH THE  
--																					 	
--				 EXEC st_MCQ_AutoSearchList 'SEARCH_BY_DEPARTMENT','TP'							 
-- ======================================================================================



CREATE PROCEDURE [dbo].[st_MCQ_AutoSearchList]
(
	@inp_sAction				VARCHAR(250),
	@inp_sEmployeeId			VARCHAR(300) = NULL ,
	@inp_sName					VARCHAR(300) = NULL ,
	@inp_sDepartment			VARCHAR(300) = NULL ,
	@inp_sDesignation			VARCHAR(300) = NULL ,
	@out_nReturnValue			INT = 0 OUTPUT,
	@out_nSQLErrCode			INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage			VARCHAR(500) = '' OUTPUT    -- Output SQL Error Message, if error occurred.	
)
AS
BEGIN
	
	DECLARE @ERR_NOTIFICATIONQUEUE_GETDETAILS INT

	IF @out_nReturnValue IS NULL
		SET @out_nReturnValue = 0

	IF @out_nSQLErrCode IS NULL
		SET @out_nSQLErrCode = 0

	IF @out_sSQLErrMessage IS NULL
		SET @out_sSQLErrMessage = ''
		
	
	IF(@inp_sAction = 'SEARCH_BY_EMPLOYEEID')
	BEGIN
		BEGIN TRY	
			SELECT EmployeeId  FROM USR_USERINFO WHERE  UserTypeCodeId=101003 AND EmployeeId LIKE @inp_sEmployeeId+'%'
		END TRY
		BEGIN CATCH
			SET @out_nSQLErrCode    =  ERROR_NUMBER()
			SET @out_sSQLErrMessage =   ERROR_MESSAGE()
			SET @out_nReturnValue  = dbo.uf_com_GetErrorCode(@ERR_NOTIFICATIONQUEUE_GETDETAILS, ERROR_NUMBER())
			
			RETURN @out_nReturnValue		
		END CATCH
	END
	IF(@inp_sAction = 'SEARCH_BY_NAME')
	BEGIN
		BEGIN TRY	
			SELECT (ISNULL(FirstName,'') +' ' + ISNULL(MiddleName,'')+' ' + ISNULL(LastName,''))  as Name   FROM USR_USERINFO WHERE  UserTypeCodeId=101003 AND (ISNULL(FirstName,'') +' ' + ISNULL(MiddleName,'')+' ' + ISNULL(LastName,'')) LIKE @inp_sName+'%'
		END TRY
		BEGIN CATCH
			SET @out_nSQLErrCode    =  ERROR_NUMBER()
			SET @out_sSQLErrMessage =   ERROR_MESSAGE()
			SET @out_nReturnValue  = dbo.uf_com_GetErrorCode(@ERR_NOTIFICATIONQUEUE_GETDETAILS, ERROR_NUMBER())
			
			RETURN @out_nReturnValue		
		END CATCH
	END
	IF(@inp_sAction = 'SEARCH_BY_DEPARTMENT')
	BEGIN
		BEGIN TRY	
			SELECT DISTINCT  CodeName AS Department,
					CODEID AS DepartmentID
			 FROM USR_USERINFO AS UR INNER JOIN COM_CODE AS CC ON UR.DepartmentID =CC.CodeID WHERE   UserTypeCodeId=101003 AND CodeName LIKE @inp_sDepartment+'%'
		END TRY
		BEGIN CATCH
			SET @out_nSQLErrCode    =  ERROR_NUMBER()
			SET @out_sSQLErrMessage =   ERROR_MESSAGE()
			SET @out_nReturnValue  = dbo.uf_com_GetErrorCode(@ERR_NOTIFICATIONQUEUE_GETDETAILS, ERROR_NUMBER())
			
			RETURN @out_nReturnValue		
		END CATCH
	END
	IF(@inp_sAction = 'SEARCH_BY_DESIGNATION')
	BEGIN
		BEGIN TRY	
		SELECT DISTINCT CodeName AS Designation,
					CODEID AS DesignationID
			 FROM USR_USERINFO AS UR INNER JOIN COM_CODE AS CC ON UR.DesignationID =CC.CodeID WHERE   UserTypeCodeId=101003 AND CodeName LIKE @inp_sDesignation+'%'
		END TRY
		BEGIN CATCH
			SET @out_nSQLErrCode    =  ERROR_NUMBER()
			SET @out_sSQLErrMessage =   ERROR_MESSAGE()
			SET @out_nReturnValue  = dbo.uf_com_GetErrorCode(@ERR_NOTIFICATIONQUEUE_GETDETAILS, ERROR_NUMBER())
			
			RETURN @out_nReturnValue		
		END CATCH
	END
END

