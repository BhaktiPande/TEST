/****** Object:  Table [dbo].[rul_TradingWindowEvent]    Script Date: 06/07/2016 12:05:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[rul_TradingWindowEvent]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[rul_TradingWindowEvent](
	[TradingWindowEventId] [int] IDENTITY(1,1) NOT NULL,
	[FinancialYearCodeId] [int] NULL,
	[FinancialPeriodCodeId] [int] NULL,
	[TradingWindowId] [varchar](50) NULL,
	[EventTypeCodeId] [int] NOT NULL,
	[TradingWindowEventCodeId] [int] NULL,
	[ResultDeclarationDate] [datetime] NOT NULL,
	[WindowCloseDate] [datetime] NOT NULL,
	[WindowOpenDate] [datetime] NOT NULL,
	[DaysPriorToResultDeclaration] [int] NOT NULL,
	[DaysPostResultDeclaration] [int] NOT NULL,
	[WindowClosesBeforeHours] [int] NULL,
	[WindowClosesBeforeMinutes] [int] NULL,
	[WindowOpensAfterHours] [int] NULL,
	[WindowOpensAfterMinutes] [int] NULL,
	[TradingWindowStatusCodeId] [int] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[ModifiedBy] [int] NOT NULL,
	[ModifiedOn] [datetime] NOT NULL,
 CONSTRAINT [PK_rul_TradingWindowEvent] PRIMARY KEY CLUSTERED 
(
	[TradingWindowEventId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'rul_TradingWindowEvent', N'COLUMN',N'FinancialYearCodeId'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'CodeGroupId = 125
Applicable to event type = FinancialResult' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_TradingWindowEvent', @level2type=N'COLUMN',@level2name=N'FinancialYearCodeId'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'rul_TradingWindowEvent', N'COLUMN',N'FinancialPeriodCodeId'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'CodeGroupId = 124
Applicable to event type = FinancialResult' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_TradingWindowEvent', @level2type=N'COLUMN',@level2name=N'FinancialPeriodCodeId'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'rul_TradingWindowEvent', N'COLUMN',N'EventTypeCodeId'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'CodeGroupId = 126 (EventType)
126001: Financial Result
126002: Other' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_TradingWindowEvent', @level2type=N'COLUMN',@level2name=N'EventTypeCodeId'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'rul_TradingWindowEvent', N'COLUMN',N'TradingWindowEventCodeId'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'CodeGroupId = 127 (Trading Window Event)
NULL if EventTypeCodeId is 126001 (Financial Result)
If EventTypeCodeId = 126002 (Result), then this should be set.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_TradingWindowEvent', @level2type=N'COLUMN',@level2name=N'TradingWindowEventCodeId'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'rul_TradingWindowEvent', N'COLUMN',N'ResultDeclarationDate'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'For EventType = Other, this is EventDeclarationDate' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_TradingWindowEvent', @level2type=N'COLUMN',@level2name=N'ResultDeclarationDate'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'rul_TradingWindowEvent', N'COLUMN',N'WindowCloseDate'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'For EventType = Other, WindowClosesAt' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_TradingWindowEvent', @level2type=N'COLUMN',@level2name=N'WindowCloseDate'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'rul_TradingWindowEvent', N'COLUMN',N'WindowOpenDate'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'For EventType = Other, WindowOpensOn' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_TradingWindowEvent', @level2type=N'COLUMN',@level2name=N'WindowOpenDate'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'rul_TradingWindowEvent', N'COLUMN',N'DaysPriorToResultDeclaration'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'For EventType = Other, WindowClosesBeforeDays' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_TradingWindowEvent', @level2type=N'COLUMN',@level2name=N'DaysPriorToResultDeclaration'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'rul_TradingWindowEvent', N'COLUMN',N'DaysPostResultDeclaration'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'For EventType = Other, WindowOpensAfterDays' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_TradingWindowEvent', @level2type=N'COLUMN',@level2name=N'DaysPostResultDeclaration'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'rul_TradingWindowEvent', N'COLUMN',N'WindowClosesBeforeHours'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Applicablt to EventType = Other' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_TradingWindowEvent', @level2type=N'COLUMN',@level2name=N'WindowClosesBeforeHours'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'rul_TradingWindowEvent', N'COLUMN',N'WindowClosesBeforeMinutes'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Applicablt to EventType = Other' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_TradingWindowEvent', @level2type=N'COLUMN',@level2name=N'WindowClosesBeforeMinutes'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'rul_TradingWindowEvent', N'COLUMN',N'WindowOpensAfterHours'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Applicablt to EventType = Other' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_TradingWindowEvent', @level2type=N'COLUMN',@level2name=N'WindowOpensAfterHours'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'rul_TradingWindowEvent', N'COLUMN',N'WindowOpensAfterMinutes'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Applicablt to EventType = Other' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_TradingWindowEvent', @level2type=N'COLUMN',@level2name=N'WindowOpensAfterMinutes'
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_rul_TradingWindowEvent_com_Code_EventTypeCodeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[rul_TradingWindowEvent]'))
ALTER TABLE [dbo].[rul_TradingWindowEvent]  WITH CHECK ADD  CONSTRAINT [FK_rul_TradingWindowEvent_com_Code_EventTypeCodeId] FOREIGN KEY([EventTypeCodeId])
REFERENCES [dbo].[com_Code] ([CodeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_rul_TradingWindowEvent_com_Code_EventTypeCodeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[rul_TradingWindowEvent]'))
ALTER TABLE [dbo].[rul_TradingWindowEvent] CHECK CONSTRAINT [FK_rul_TradingWindowEvent_com_Code_EventTypeCodeId]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_rul_TradingWindowEvent_com_Code_FinancialPeriodCodeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[rul_TradingWindowEvent]'))
ALTER TABLE [dbo].[rul_TradingWindowEvent]  WITH CHECK ADD  CONSTRAINT [FK_rul_TradingWindowEvent_com_Code_FinancialPeriodCodeId] FOREIGN KEY([FinancialPeriodCodeId])
REFERENCES [dbo].[com_Code] ([CodeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_rul_TradingWindowEvent_com_Code_FinancialPeriodCodeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[rul_TradingWindowEvent]'))
ALTER TABLE [dbo].[rul_TradingWindowEvent] CHECK CONSTRAINT [FK_rul_TradingWindowEvent_com_Code_FinancialPeriodCodeId]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_rul_TradingWindowEvent_com_Code_FinancialYearCodeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[rul_TradingWindowEvent]'))
ALTER TABLE [dbo].[rul_TradingWindowEvent]  WITH CHECK ADD  CONSTRAINT [FK_rul_TradingWindowEvent_com_Code_FinancialYearCodeId] FOREIGN KEY([FinancialYearCodeId])
REFERENCES [dbo].[com_Code] ([CodeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_rul_TradingWindowEvent_com_Code_FinancialYearCodeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[rul_TradingWindowEvent]'))
ALTER TABLE [dbo].[rul_TradingWindowEvent] CHECK CONSTRAINT [FK_rul_TradingWindowEvent_com_Code_FinancialYearCodeId]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_rul_TradingWindowEvent_com_Code_TradingWindowEventCodeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[rul_TradingWindowEvent]'))
ALTER TABLE [dbo].[rul_TradingWindowEvent]  WITH CHECK ADD  CONSTRAINT [FK_rul_TradingWindowEvent_com_Code_TradingWindowEventCodeId] FOREIGN KEY([TradingWindowEventCodeId])
REFERENCES [dbo].[com_Code] ([CodeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_rul_TradingWindowEvent_com_Code_TradingWindowEventCodeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[rul_TradingWindowEvent]'))
ALTER TABLE [dbo].[rul_TradingWindowEvent] CHECK CONSTRAINT [FK_rul_TradingWindowEvent_com_Code_TradingWindowEventCodeId]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_rul_TradingWindowEvent_com_Code_TradingWindowStatus]') AND parent_object_id = OBJECT_ID(N'[dbo].[rul_TradingWindowEvent]'))
ALTER TABLE [dbo].[rul_TradingWindowEvent]  WITH CHECK ADD  CONSTRAINT [FK_rul_TradingWindowEvent_com_Code_TradingWindowStatus] FOREIGN KEY([TradingWindowStatusCodeId])
REFERENCES [dbo].[com_Code] ([CodeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_rul_TradingWindowEvent_com_Code_TradingWindowStatus]') AND parent_object_id = OBJECT_ID(N'[dbo].[rul_TradingWindowEvent]'))
ALTER TABLE [dbo].[rul_TradingWindowEvent] CHECK CONSTRAINT [FK_rul_TradingWindowEvent_com_Code_TradingWindowStatus]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_rul_TradingWindowEvent_usr_UserInfo_CreatedBy]') AND parent_object_id = OBJECT_ID(N'[dbo].[rul_TradingWindowEvent]'))
ALTER TABLE [dbo].[rul_TradingWindowEvent]  WITH CHECK ADD  CONSTRAINT [FK_rul_TradingWindowEvent_usr_UserInfo_CreatedBy] FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[usr_UserInfo] ([UserInfoId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_rul_TradingWindowEvent_usr_UserInfo_CreatedBy]') AND parent_object_id = OBJECT_ID(N'[dbo].[rul_TradingWindowEvent]'))
ALTER TABLE [dbo].[rul_TradingWindowEvent] CHECK CONSTRAINT [FK_rul_TradingWindowEvent_usr_UserInfo_CreatedBy]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_rul_TradingWindowEvent_usr_UserInfo_ModifiedBy]') AND parent_object_id = OBJECT_ID(N'[dbo].[rul_TradingWindowEvent]'))
ALTER TABLE [dbo].[rul_TradingWindowEvent]  WITH CHECK ADD  CONSTRAINT [FK_rul_TradingWindowEvent_usr_UserInfo_ModifiedBy] FOREIGN KEY([ModifiedBy])
REFERENCES [dbo].[usr_UserInfo] ([UserInfoId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_rul_TradingWindowEvent_usr_UserInfo_ModifiedBy]') AND parent_object_id = OBJECT_ID(N'[dbo].[rul_TradingWindowEvent]'))
ALTER TABLE [dbo].[rul_TradingWindowEvent] CHECK CONSTRAINT [FK_rul_TradingWindowEvent_usr_UserInfo_ModifiedBy]
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_rul_TradingWindowEvent_TradingWindowStatusCodeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[rul_TradingWindowEvent]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_rul_TradingWindowEvent_TradingWindowStatusCodeId]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[rul_TradingWindowEvent] ADD  CONSTRAINT [DF_rul_TradingWindowEvent_TradingWindowStatusCodeId]  DEFAULT ((131001)) FOR [TradingWindowStatusCodeId]
END


End
GO
