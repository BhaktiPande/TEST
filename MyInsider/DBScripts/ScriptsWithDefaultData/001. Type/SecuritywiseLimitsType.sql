IF EXISTS (SELECT NAME FROM SYS.types WHERE NAME = 'SecuritywiseLimitsType')
BEGIN
	DROP TYPE SecuritywiseLimitsType
END
GO

CREATE TYPE [dbo].[SecuritywiseLimitsType] AS TABLE(
	[SecurityTypeCodeId] [int] NULL,
	[NoOfShares] [int] NULL,
	[PercPaidSubscribedCap] decimal(15,4) NULL,
	[ValueOfShares]  decimal(18,4) NULL
)
