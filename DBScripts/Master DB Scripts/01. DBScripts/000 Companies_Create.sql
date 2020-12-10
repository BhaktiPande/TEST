CREATE TABLE [dbo].[Companies](
	[CompanyId] [int] NOT NULL,
	[CompanyName] [varchar](200) NULL,
	[ConnectionServer] [varchar](200) NULL,
	[ConnectionDatabaseName] [varchar](200) NULL,
	[ConnectionUserName] [varchar](200) NULL,
	[ConnectionPassword] [varchar](200) NULL,
	[UpdateResources] [int] NOT NULL CONSTRAINT [DF_Companies_UpdateResources]  DEFAULT ((0)),
) ON [PRIMARY]

GO
INSERT INTO DBUpdateStatus (ScriptNumber, ScriptFileName, Description, CreatedBy)
VALUES (0, '000 Companies_Create.sql', 'Added table for maintaining the companies details', 'Raghvendra')

