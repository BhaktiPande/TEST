-- ======================================================================================================
-- Author      : Gaurav Ugale																			=
-- CREATED DATE: 04-JAN-2016                                                 							=
-- Description : THIS TABLE TYPE IS USED FOR Non-Trading Day Mass-Upload								=
-- ======================================================================================================

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

------------------------------------------------------------------------------------------------------------------------

INSERT INTO DBUpdateStatus (ScriptNumber, ScriptFileName, Description, CreatedBy)
VALUES (227, '227 MassNonTradingDaysDataTable_Create', 'Create Type MassNonTradingDaysDataTable', 'ED Team')

------------------------------------------------------------------------------------------------------------------------