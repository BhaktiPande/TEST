/****** Object:  Table [dbo].[eve_EventLog]    Script Date: 06/07/2016 12:05:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[eve_EventLog]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[eve_EventLog](
	[EventLogId] [bigint] IDENTITY(1,1) NOT NULL,
	[EventCodeId] [int] NOT NULL,
	[EventDate] [datetime] NOT NULL,
	[UserInfoId] [int] NOT NULL,
	[MapToTypeCodeId] [int] NOT NULL,
	[MapToId] [int] NOT NULL,
	[CreatedBy] [int] NOT NULL,
 CONSTRAINT [PK_eve_EventLog] PRIMARY KEY CLUSTERED 
(
	[EventLogId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'eve_EventLog', N'COLUMN',N'EventCodeId'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Refers com_Code
CodeGroupId = 153' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'eve_EventLog', @level2type=N'COLUMN',@level2name=N'EventCodeId'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'eve_EventLog', N'COLUMN',N'MapToTypeCodeId'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'refers com_code
CodeGroupId = 132' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'eve_EventLog', @level2type=N'COLUMN',@level2name=N'MapToTypeCodeId'
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_eve_EventLog_com_Code_EventCodeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[eve_EventLog]'))
ALTER TABLE [dbo].[eve_EventLog]  WITH CHECK ADD  CONSTRAINT [FK_eve_EventLog_com_Code_EventCodeId] FOREIGN KEY([EventCodeId])
REFERENCES [dbo].[com_Code] ([CodeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_eve_EventLog_com_Code_EventCodeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[eve_EventLog]'))
ALTER TABLE [dbo].[eve_EventLog] CHECK CONSTRAINT [FK_eve_EventLog_com_Code_EventCodeId]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_eve_EventLog_com_Code_MapToTypeCodeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[eve_EventLog]'))
ALTER TABLE [dbo].[eve_EventLog]  WITH CHECK ADD  CONSTRAINT [FK_eve_EventLog_com_Code_MapToTypeCodeId] FOREIGN KEY([MapToTypeCodeId])
REFERENCES [dbo].[com_Code] ([CodeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_eve_EventLog_com_Code_MapToTypeCodeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[eve_EventLog]'))
ALTER TABLE [dbo].[eve_EventLog] CHECK CONSTRAINT [FK_eve_EventLog_com_Code_MapToTypeCodeId]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_eve_EventLog_usr_UserInfo_UserInfoId]') AND parent_object_id = OBJECT_ID(N'[dbo].[eve_EventLog]'))
ALTER TABLE [dbo].[eve_EventLog]  WITH CHECK ADD  CONSTRAINT [FK_eve_EventLog_usr_UserInfo_UserInfoId] FOREIGN KEY([UserInfoId])
REFERENCES [dbo].[usr_UserInfo] ([UserInfoId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_eve_EventLog_usr_UserInfo_UserInfoId]') AND parent_object_id = OBJECT_ID(N'[dbo].[eve_EventLog]'))
ALTER TABLE [dbo].[eve_EventLog] CHECK CONSTRAINT [FK_eve_EventLog_usr_UserInfo_UserInfoId]
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_eve_EventLog_CreatedBy]') AND parent_object_id = OBJECT_ID(N'[dbo].[eve_EventLog]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_eve_EventLog_CreatedBy]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[eve_EventLog] ADD  CONSTRAINT [DF_eve_EventLog_CreatedBy]  DEFAULT ((1)) FOR [CreatedBy]
END


End
GO
