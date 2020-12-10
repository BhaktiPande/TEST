
/****** Object:  UserDefinedTableType [dbo].[SecuritywiseLimits]    Script Date: 05/25/2015 15:34:37 ******/
CREATE TYPE [dbo].[SecuritywiseLimitsType] AS TABLE(
	[SecurityTypeCodeId] [int] NULL,
	[NoOfShares] [int] NULL,
	[PercPaidSubscribedCap] decimal(15,4) NULL,
	[ValueOfShares]  decimal(18,4) NULL
)


--------------------------------------------------------------------------------------------------------
INSERT INTO DBUpdateStatus (ScriptNumber, ScriptFileName, Description, CreatedBy)
VALUES (142, '142 SecuritywiseLimitsType', 'Create SecuritywiseLimitsType', 'Tushar')




