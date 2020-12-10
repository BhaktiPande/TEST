
IF EXISTS (SELECT NAME FROM SYS.types WHERE NAME = 'MassEmployeePeriodEndDataTable')
BEGIN
	IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_com_MassUploadCommonProcedureExecution')
		DROP PROCEDURE st_com_MassUploadCommonProcedureExecution
		
	DROP TYPE MassEmployeePeriodEndDataTable
END
GO

/*
	Script from Parag on 13 September 2016
	Create Data table to save company configuration
*/

/*Define the Data Table to be used for Period End Performed Mass Upload*/
IF NOT EXISTS (select * from sys.types where name = 'MassEmployeePeriodEndDataTable')
BEGIN
	CREATE TYPE MassEmployeePeriodEndDataTable AS TABLE
	(
		UserInfoId INT,
		LoginId NVARCHAR(100),
		PeriodEndPerformed INT,	--Com_Code value with GodeGroup 186
		EmployeeName NVARCHAR(100)
	)

END
GO


