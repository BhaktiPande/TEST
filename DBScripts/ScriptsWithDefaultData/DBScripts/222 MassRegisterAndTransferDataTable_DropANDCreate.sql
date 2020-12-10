IF EXISTS (SELECT NAME FROM SYS.types WHERE NAME = 'MassRegisterAndTransferDataTable')
BEGIN
	IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_com_MassUploadCommonProcedureExecution')
		DROP PROCEDURE st_com_MassUploadCommonProcedureExecution
		
	DROP TYPE MassRegisterAndTransferDataTable
END
GO

CREATE TYPE [dbo].[MassRegisterAndTransferDataTable] AS TABLE
	(	
		[PANNumber]			[nvarchar](50) 	NOT NULL,
		[SecurityType]		[nvarchar](50) 	NOT NULL,
		[DPID]				[nvarchar](50) 	NOT NULL,
		[ClientId]			[nvarchar](50) 	NULL,
		[DematAccount]		[nvarchar](50) 	NOT NULL,
		[UserInfoId]		[nvarchar](50) 	NULL,
		[EmployeeName]		[nvarchar](200)	NULL,
		[Shares]			[nvarchar](50)	NULL
	)

GO

----------------------------------------------------------------------------------------------------------------
INSERT INTO DBUpdateStatus (ScriptNumber, ScriptFileName, Description, CreatedBy)
VALUES (222, '222 MassRegisterAndTransferDataTable_DropAndCreate', 'MassRegisterAndTransferDataTable DropAndCreate', 'ED 04-Jan')
