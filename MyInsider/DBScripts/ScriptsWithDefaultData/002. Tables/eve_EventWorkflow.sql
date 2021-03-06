/****** Object:  Table [dbo].[eve_EventWorkflow]    Script Date: 06/07/2016 12:05:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[eve_EventWorkflow]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[eve_EventWorkflow](
	[EventWorklowId] [int] NOT NULL,
	[EventSetCodeId] [int] NOT NULL,
	[EventCodeId] [int] NOT NULL,
	[SequenceNumber] [int] NOT NULL,
 CONSTRAINT [PK_eve_EventWorkflow] PRIMARY KEY CLUSTERED 
(
	[EventWorklowId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'eve_EventWorkflow', N'COLUMN',N'EventSetCodeId'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Refers com_Code
CodeGroupId = 152' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'eve_EventWorkflow', @level2type=N'COLUMN',@level2name=N'EventSetCodeId'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'eve_EventWorkflow', N'COLUMN',N'EventCodeId'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Refers com_Code
CodeGroupId = 153' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'eve_EventWorkflow', @level2type=N'COLUMN',@level2name=N'EventCodeId'
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_eve_EventWorkflow_com_Code_EventCodeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[eve_EventWorkflow]'))
ALTER TABLE [dbo].[eve_EventWorkflow]  WITH CHECK ADD  CONSTRAINT [FK_eve_EventWorkflow_com_Code_EventCodeId] FOREIGN KEY([EventCodeId])
REFERENCES [dbo].[com_Code] ([CodeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_eve_EventWorkflow_com_Code_EventCodeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[eve_EventWorkflow]'))
ALTER TABLE [dbo].[eve_EventWorkflow] CHECK CONSTRAINT [FK_eve_EventWorkflow_com_Code_EventCodeId]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_eve_EventWorkflow_com_Code_EventSetCodeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[eve_EventWorkflow]'))
ALTER TABLE [dbo].[eve_EventWorkflow]  WITH CHECK ADD  CONSTRAINT [FK_eve_EventWorkflow_com_Code_EventSetCodeId] FOREIGN KEY([EventSetCodeId])
REFERENCES [dbo].[com_Code] ([CodeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_eve_EventWorkflow_com_Code_EventSetCodeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[eve_EventWorkflow]'))
ALTER TABLE [dbo].[eve_EventWorkflow] CHECK CONSTRAINT [FK_eve_EventWorkflow_com_Code_EventSetCodeId]
GO
