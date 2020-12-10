
IF EXISTS (SELECT NAME FROM SYS.types WHERE NAME = 'TradingWindowEventType')
BEGIN
	DROP TYPE TradingWindowEventType
END
GO

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
