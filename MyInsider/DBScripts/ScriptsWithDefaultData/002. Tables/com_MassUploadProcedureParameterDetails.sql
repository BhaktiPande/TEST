/****** Object:  Table [dbo].[com_MassUploadProcedureParameterDetails]    Script Date: 06/07/2016 12:05:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[com_MassUploadProcedureParameterDetails]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[com_MassUploadProcedureParameterDetails](
	[MassUploadProcedureParameterDetailsId] [int] NOT NULL,
	[MassUploadSheetId] [int] NOT NULL,
	[MassUploadProcedureParameterNumber] [int] NOT NULL,
	[MassUploadDataTableId] [int] NULL,
	[MassUploadExcelDataTableColumnMappingId] [int] NULL,
	[MassUploadProcedureParameterValue] [nvarchar](100) NULL
) ON [PRIMARY]
END
GO
