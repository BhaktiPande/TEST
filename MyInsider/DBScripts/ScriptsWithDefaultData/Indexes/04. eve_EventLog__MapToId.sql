IF NOT EXISTS (SELECT NAME FROM SYS.INDEXES WHERE NAME = 'eve_EventLog__MapToId')
BEGIN

	CREATE NONCLUSTERED INDEX eve_EventLog__MapToId ON eve_EventLog 
	(
		MapToId ASC		
	)
	WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
END
GO

