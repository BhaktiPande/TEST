IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'SP_Data_For_Separation_MassUpload')
	DROP PROCEDURE SP_Data_For_Separation_MassUpload
GO
-- ======================================================================================================
-- Author      : Gaurav Ugale																			=
-- CREATED DATE: 06-APR-2016                                                 							=
-- Description : THIS SP GIVES DATA FOR SEPARATION MASS UPLOAD											=
-- ======================================================================================================

CREATE PROCEDURE SP_Data_For_Separation_MassUpload
AS
BEGIN	
	SELECT UAT.LoginID,
		UIF.EmployeeId, 
		PAN,
		DateOfSeparation,
		ReasonForSeparation,
		NoOfDaysToBeActive,
		DateOfInactivation 
	FROM usr_UserInfo UIF
	LEFT JOIN usr_Authentication UAT ON UAT.UserInfoID = UIF.UserInfoId
	WHERE StatusCodeId = 102001
	AND UIF.UserTypeCodeId <> 101001 --- Admin
	AND UIF.UserTypeCodeId <> 101002 --- CO User
	AND UIF.UserTypeCodeId <> 101005 --- Super Admin  
	AND UIF.UserTypeCodeId <> 101007 --- User Relative
END