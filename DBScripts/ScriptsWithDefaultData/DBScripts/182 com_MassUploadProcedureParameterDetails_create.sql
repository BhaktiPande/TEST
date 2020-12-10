/****** Object:  Table [dbo].[com_MassUploadProcedureParameterDetails]    Script Date: 09/30/2015 17:25:22 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[com_MassUploadProcedureParameterDetails](
	[MassUploadProcedureParameterDetailsId] [int] IDENTITY(1,1) NOT NULL,
	[MassUploadSheetId] [int] NOT NULL,
	[MassUploadProcedureParameterNumber] [int] NOT NULL,
	[MassUploadDataTableId] [int] NULL,
	[MassUploadExcelDataTableColumnMappingId] [int] NULL,
	[MassUploadProcedureParameterValue] [nvarchar](100) NULL
) ON [PRIMARY]

GO

----------------------------------------------------------------------------------------------------------------
INSERT INTO DBUpdateStatus (ScriptNumber, ScriptFileName, Description, CreatedBy)
VALUES (182, '182 com_MassUploadProcedureParameterDetails_create', 'Create com_MassUploadProcedureParameterDetails', 'Raghvendra')
