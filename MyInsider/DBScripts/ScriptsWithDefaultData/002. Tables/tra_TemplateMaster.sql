/****** Object:  Table [dbo].[tra_TemplateMaster]    Script Date: 06/07/2016 12:05:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tra_TemplateMaster]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tra_TemplateMaster](
	[TemplateMasterId] [int] IDENTITY(1,1) NOT NULL,
	[TemplateName] [nvarchar](255) NOT NULL,
	[CommunicationModeCodeId] [int] NOT NULL,
	[DisclosureTypeCodeId] [int] NULL,
	[LetterForCodeId] [int] NULL,
	[IsActive] [bit] NOT NULL,
	[Date] [datetime] NULL,
	[ToAddress1] [nvarchar](250) NULL,
	[ToAddress2] [nvarchar](250) NULL,
	[Subject] [nvarchar](150) NULL,
	[Contents] [nvarchar](4000) NOT NULL,
	[Signature] [nvarchar](200) NULL,
	[CommunicationFrom] [varchar](100) NULL,
	[SequenceNo] [varchar](50) NULL,
	[IsCommunicationTemplate] [bit] NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[ModifiedBy] [int] NOT NULL,
	[ModifiedOn] [datetime] NOT NULL,
 CONSTRAINT [PK_tra_TemplateMaster] PRIMARY KEY CLUSTERED 
(
	[TemplateMasterId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'tra_TemplateMaster', N'COLUMN',N'TemplateName'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Name with which template can be referred.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tra_TemplateMaster', @level2type=N'COLUMN',@level2name=N'TemplateName'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'tra_TemplateMaster', N'COLUMN',N'CommunicationModeCodeId'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Refers: com_Code. 156001:Letter, 156002:Email, 156003:SMS, 156004:Text Alert, 156005:Popup Alert.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tra_TemplateMaster', @level2type=N'COLUMN',@level2name=N'CommunicationModeCodeId'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'tra_TemplateMaster', N'COLUMN',N'DisclosureTypeCodeId'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Refers com_Code, CodeGroupID = 147
147001: Initial
147002: Continuous
147003: Period End. Applicable for Transaction Letter.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tra_TemplateMaster', @level2type=N'COLUMN',@level2name=N'DisclosureTypeCodeId'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'tra_TemplateMaster', N'COLUMN',N'LetterForCodeId'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Refers com_Code, CodeGroupID = 151
151001: Insider
151002: CO. Applicable for Transaction Letter.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tra_TemplateMaster', @level2type=N'COLUMN',@level2name=N'LetterForCodeId'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'tra_TemplateMaster', N'COLUMN',N'IsActive'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'1: Active, 0: Inactive' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tra_TemplateMaster', @level2type=N'COLUMN',@level2name=N'IsActive'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'tra_TemplateMaster', N'COLUMN',N'Date'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Applicable for Transaction Letter.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tra_TemplateMaster', @level2type=N'COLUMN',@level2name=N'Date'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'tra_TemplateMaster', N'COLUMN',N'ToAddress1'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Applicable for Transaction Letter.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tra_TemplateMaster', @level2type=N'COLUMN',@level2name=N'ToAddress1'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'tra_TemplateMaster', N'COLUMN',N'ToAddress2'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Applicable for Transaction Letter.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tra_TemplateMaster', @level2type=N'COLUMN',@level2name=N'ToAddress2'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'tra_TemplateMaster', N'COLUMN',N'Subject'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Applicable only for email and transaction letter. Empty string or NULL in case of CM- SMS/Alert/Popup' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tra_TemplateMaster', @level2type=N'COLUMN',@level2name=N'Subject'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'tra_TemplateMaster', N'COLUMN',N'Contents'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'will contain formatted text along with placeholders in between the content, where placeholder will be codename from com_Code related to placeholderCode. Placeholders will be handled at a later stage, not in first cut.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tra_TemplateMaster', @level2type=N'COLUMN',@level2name=N'Contents'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'tra_TemplateMaster', N'COLUMN',N'Signature'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Applicable for Letter, Email.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tra_TemplateMaster', @level2type=N'COLUMN',@level2name=N'Signature'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'tra_TemplateMaster', N'COLUMN',N'CommunicationFrom'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Appliable only in case of Email and SMS - email from email address / SMS from number.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tra_TemplateMaster', @level2type=N'COLUMN',@level2name=N'CommunicationFrom'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'tra_TemplateMaster', N'COLUMN',N'SequenceNo'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Sequence number as 1, 1.1, 1.1.2, 2.1, 2.1.1 when Subject and Contents store FAQ and corresponding answer' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tra_TemplateMaster', @level2type=N'COLUMN',@level2name=N'SequenceNo'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'tra_TemplateMaster', N'COLUMN',N'IsCommunicationTemplate'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Flag to indicate whether template is for Email/SMS/Text Alert/Popup Alert (value =1) or for Letter/FAQ (value=0)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'tra_TemplateMaster', @level2type=N'COLUMN',@level2name=N'IsCommunicationTemplate'
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tra_TemplateMaster_com_Code_CommunicationModeCodeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[tra_TemplateMaster]'))
ALTER TABLE [dbo].[tra_TemplateMaster]  WITH CHECK ADD  CONSTRAINT [FK_tra_TemplateMaster_com_Code_CommunicationModeCodeId] FOREIGN KEY([CommunicationModeCodeId])
REFERENCES [dbo].[com_Code] ([CodeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tra_TemplateMaster_com_Code_CommunicationModeCodeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[tra_TemplateMaster]'))
ALTER TABLE [dbo].[tra_TemplateMaster] CHECK CONSTRAINT [FK_tra_TemplateMaster_com_Code_CommunicationModeCodeId]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tra_TemplateMaster_com_Code_DisclosureTypeCodeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[tra_TemplateMaster]'))
ALTER TABLE [dbo].[tra_TemplateMaster]  WITH CHECK ADD  CONSTRAINT [FK_tra_TemplateMaster_com_Code_DisclosureTypeCodeId] FOREIGN KEY([DisclosureTypeCodeId])
REFERENCES [dbo].[com_Code] ([CodeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tra_TemplateMaster_com_Code_DisclosureTypeCodeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[tra_TemplateMaster]'))
ALTER TABLE [dbo].[tra_TemplateMaster] CHECK CONSTRAINT [FK_tra_TemplateMaster_com_Code_DisclosureTypeCodeId]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tra_TemplateMaster_com_Code_LetterForCodeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[tra_TemplateMaster]'))
ALTER TABLE [dbo].[tra_TemplateMaster]  WITH CHECK ADD  CONSTRAINT [FK_tra_TemplateMaster_com_Code_LetterForCodeId] FOREIGN KEY([LetterForCodeId])
REFERENCES [dbo].[com_Code] ([CodeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tra_TemplateMaster_com_Code_LetterForCodeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[tra_TemplateMaster]'))
ALTER TABLE [dbo].[tra_TemplateMaster] CHECK CONSTRAINT [FK_tra_TemplateMaster_com_Code_LetterForCodeId]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tra_TemplateMaster_usr_UserInfo_CreatedBy]') AND parent_object_id = OBJECT_ID(N'[dbo].[tra_TemplateMaster]'))
ALTER TABLE [dbo].[tra_TemplateMaster]  WITH CHECK ADD  CONSTRAINT [FK_tra_TemplateMaster_usr_UserInfo_CreatedBy] FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[usr_UserInfo] ([UserInfoId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tra_TemplateMaster_usr_UserInfo_CreatedBy]') AND parent_object_id = OBJECT_ID(N'[dbo].[tra_TemplateMaster]'))
ALTER TABLE [dbo].[tra_TemplateMaster] CHECK CONSTRAINT [FK_tra_TemplateMaster_usr_UserInfo_CreatedBy]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tra_TemplateMaster_usr_UserInfo_ModifiedBy]') AND parent_object_id = OBJECT_ID(N'[dbo].[tra_TemplateMaster]'))
ALTER TABLE [dbo].[tra_TemplateMaster]  WITH CHECK ADD  CONSTRAINT [FK_tra_TemplateMaster_usr_UserInfo_ModifiedBy] FOREIGN KEY([ModifiedBy])
REFERENCES [dbo].[usr_UserInfo] ([UserInfoId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tra_TemplateMaster_usr_UserInfo_ModifiedBy]') AND parent_object_id = OBJECT_ID(N'[dbo].[tra_TemplateMaster]'))
ALTER TABLE [dbo].[tra_TemplateMaster] CHECK CONSTRAINT [FK_tra_TemplateMaster_usr_UserInfo_ModifiedBy]
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tra_TemplateMaster_CommunicationModeCodeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[tra_TemplateMaster]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tra_TemplateMaster_CommunicationModeCodeId]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tra_TemplateMaster] ADD  CONSTRAINT [DF_tra_TemplateMaster_CommunicationModeCodeId]  DEFAULT ((156001)) FOR [CommunicationModeCodeId]
END


End
GO
IF Not EXISTS (SELECT * FROM sys.default_constraints WHERE object_id = OBJECT_ID(N'[dbo].[DF_tra_TemplateMaster_IsCommunicationTemplate]') AND parent_object_id = OBJECT_ID(N'[dbo].[tra_TemplateMaster]'))
Begin
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_tra_TemplateMaster_IsCommunicationTemplate]') AND type = 'D')
BEGIN
ALTER TABLE [dbo].[tra_TemplateMaster] ADD  CONSTRAINT [DF_tra_TemplateMaster_IsCommunicationTemplate]  DEFAULT ((1)) FOR [IsCommunicationTemplate]
END


End
GO
