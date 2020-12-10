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

CREATE TYPE [MassHistoryTransactionImportDataTable] AS TABLE(
	TransactionMasterId			INT NULL 
	,PreclearanceId				INT NULL
	,UserLoginName				NVARCHAR(100) NULL		
	,RelationCodeId				INT	 NULL						
	,FirstLastName				NVARCHAR(55) NULL			
	,DateOfAcquisition			DATETIME NULL
	,ModeOfAcquisitionCodeId		INT	 NULL	
	,DateOfInitimationToCompany	DATETIME NULL		
	,SecuritiesHeldPriorToAcquisition		decimal NULL
	,DEMATAccountNo				NVARCHAR(50) NULL
	,ExchangeCodeId				INT	 NULL	
	,TransactionTypeCodeId		INT NULL
	,SecurityTypeCodeId			INT		 NULL	
	,PerOfSharesPreTransaction	DECIMAL(5,2) NULL	
	,PerOfSharesPostTransaction	DECIMAL(5,2) NULL	
	,Quantity						DECIMAL NULL 
	,Value						DECIMAL NULL	
	,Quantity2					DECIMAL  NULL
	,Value2						DECIMAL NULL	
	,LotSize						INT	 NULL		
	,ContractSpecification		NVARCHAR(50) NULL
)
GO
------------------------------------------------------------------------------------------------------------------------

INSERT INTO DBUpdateStatus (ScriptNumber, ScriptFileName, Description, CreatedBy)
VALUES (219, '219 MassHistoryPreclearanceRequestImportDataTable_Create', 'create type MassHistoryPreclearanceRequestImportDataTable', 'Raghvendra')
