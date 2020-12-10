IF EXISTS (SELECT NAME FROM SYS.types WHERE NAME = 'MassHistoryPreclearanceRequestImportDataTable')
BEGIN
	IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_com_MassUploadCommonProcedureExecution')
		DROP PROCEDURE st_com_MassUploadCommonProcedureExecution
		
	DROP TYPE MassHistoryPreclearanceRequestImportDataTable
END
GO

CREATE TYPE [MassHistoryPreclearanceRequestImportDataTable] AS TABLE(
	PreclearanceRequestId			INT NULL, 
	UserName						NVARCHAR(100)  NULL,
	RelationCodeId					INT NULL,
	FirstLastName					NVARCHAR(55) NULL,
	DateApplyingForPreClearance		DATETIME NULL,
	TransactionTypeCodeId			INT NULL,
	SecurityTypeCodeId				INT NULL,
	SecuritiesToBeTradedQty			DECIMAL(15,4) NULL,
	SecuritiesToBeTradedValue		DECIMAL(15,4) NULL,
	ProposedTradeRateRangeFrom		DECIMAL(15,4) NULL,
	ProposedTradeRateRangeTo		DECIMAL(15,4) NULL,
	DMATDetailsINo					NVARCHAR(50) NULL,
	PreclearanceStatusCodeId		INT NULL,
	DateForApprovalRejection		DATETIME NULL		
)

GO