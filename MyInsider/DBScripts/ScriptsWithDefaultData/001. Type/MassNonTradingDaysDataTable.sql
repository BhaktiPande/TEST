IF EXISTS (SELECT NAME FROM SYS.types WHERE NAME = 'MassNonTradingDaysDataTable')
BEGIN
	IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_com_MassUploadCommonProcedureExecution')
		DROP PROCEDURE st_com_MassUploadCommonProcedureExecution
		
	DROP TYPE MassNonTradingDaysDataTable
END
GO
BEGIN
	CREATE TYPE [dbo].[MassNonTradingDaysDataTable] AS TABLE
	(	
		[Reason]			[nvarchar](200) 	NOT NULL,
		[NonTradDay]		[datetime] 	NOT NULL
		
	)
END