/*
DROP PROCEDURE st_com_MassUploadCommonProcedureExecution
DROP TYPE MassRegisterAndTransferDataTable
*/
GO
CREATE TYPE [dbo].[MassRegisterAndTransferDataTable] AS TABLE(	
	[PANNumber]			[nvarchar](50) NOT NULL,
	[SecurityType]		[nvarchar](50) NOT NULL,
	[DPID]				[nvarchar](50) NOT NULL,
	[ClientId]			[nvarchar](50) NOT NULL,
	[DematAccount]		[nvarchar](50) NOT NULL,
	[UserInfoId]		[nvarchar](50) NULL,
	[EmployeeName]		[nvarchar](200) NULL,
	[Shares]			[decimal](10,0) NOT NULL,
	[Equity]			[nvarchar](50) NOT NULL,	
	[Category]			[nvarchar](50) NOT NULL
)
GO

----------------------------------------------------------------------------------------------------------------
INSERT INTO DBUpdateStatus (ScriptNumber, ScriptFileName, Description, CreatedBy)
VALUES (213, '213 MassRegisterAndTransferDataTable_Create', 'MassRegisterAndTransferDataTable Create', 'ED 18-Dec')
