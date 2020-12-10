CREATE TYPE TradingWindowEventType AS TABLE 
(
	TradingWindowEventId			INT
	,FinancialYearCodeId			INT
	,FinancialPeriodCodeId			INT
	,TradingWindowId				VARCHAR (50)
	,EventTypeCodeId				INT
	,TradingWindowEventCodeId		INT
	,ResultDeclarationDate			DATETIME
	,WindowCloseDate				DATETIME
	,WindowOpenDate					DATETIME
	,DaysPriorToResultDeclaration	INT
	,DaysPostResultDeclaration		INT
	,WindowClosesBeforeHours		INT
	,WindowClosesBeforeMinutes		INT
	,WindowOpensAfterHours			INT
	,WindowOpensAfterMinutes		INT
)

----------------------------------------------------------------------------------------------------------------------
INSERT INTO DBUpdateStatus (ScriptNumber, ScriptFileName, Description, CreatedBy)
VALUES (78, '078 TradingWindowEventType_Create', 'Create type TradingWindowEventType', 'GS')
