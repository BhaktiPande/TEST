IF EXISTS (SELECT NAME FROM SYS.types WHERE NAME = 'MassHistoryTransactionImportDataTable')
BEGIN
	IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_com_MassUploadCommonProcedureExecution')
		DROP PROCEDURE st_com_MassUploadCommonProcedureExecution
		
	DROP TYPE MassHistoryTransactionImportDataTable
END
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