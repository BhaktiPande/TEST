/****** Object:  Table [dbo].[tra_TransactionLetter]    Script Date: 06/07/2016 12:05:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tra_TransactionLetter]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tra_TransactionLetter](
	[TransactionLetterId] [bigint] IDENTITY(1,1) NOT NULL,
	[TransactionMasterId] [bigint] NOT NULL,
	[LetterForCodeId] [int] NOT NULL,
	[Date] [datetime] NOT NULL,
	[ToAddress1] [nvarchar](250) NOT NULL,
	[ToAddress2] [nvarchar](250) NULL,
	[Subject] [nvarchar](150) NOT NULL,
	[Contents] [nvarchar](2000) NOT NULL,
	[Signature] [nvarchar](200) NOT NULL,
	[CreatedBy] [int] NOT NULL,
	[CreatedOn] [datetime] NOT NULL,
	[ModifiedBy] [int] NOT NULL,
	[ModifiedOn] [datetime] NOT NULL,
 CONSTRAINT [PK_tra_TransactionLetter] PRIMARY KEY CLUSTERED 
(
	[TransactionLetterId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tra_TransactionLetter_com_Code_LetterForCodeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[tra_TransactionLetter]'))
ALTER TABLE [dbo].[tra_TransactionLetter]  WITH CHECK ADD  CONSTRAINT [FK_tra_TransactionLetter_com_Code_LetterForCodeId] FOREIGN KEY([LetterForCodeId])
REFERENCES [dbo].[com_Code] ([CodeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tra_TransactionLetter_com_Code_LetterForCodeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[tra_TransactionLetter]'))
ALTER TABLE [dbo].[tra_TransactionLetter] CHECK CONSTRAINT [FK_tra_TransactionLetter_com_Code_LetterForCodeId]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tra_TransactionLetter_tra_TransactionMaster_TransactionMasterId]') AND parent_object_id = OBJECT_ID(N'[dbo].[tra_TransactionLetter]'))
ALTER TABLE [dbo].[tra_TransactionLetter]  WITH CHECK ADD  CONSTRAINT [FK_tra_TransactionLetter_tra_TransactionMaster_TransactionMasterId] FOREIGN KEY([TransactionMasterId])
REFERENCES [dbo].[tra_TransactionMaster] ([TransactionMasterId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tra_TransactionLetter_tra_TransactionMaster_TransactionMasterId]') AND parent_object_id = OBJECT_ID(N'[dbo].[tra_TransactionLetter]'))
ALTER TABLE [dbo].[tra_TransactionLetter] CHECK CONSTRAINT [FK_tra_TransactionLetter_tra_TransactionMaster_TransactionMasterId]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tra_TransactionLetter_usr_UserInfo_CreatedBy]') AND parent_object_id = OBJECT_ID(N'[dbo].[tra_TransactionLetter]'))
ALTER TABLE [dbo].[tra_TransactionLetter]  WITH CHECK ADD  CONSTRAINT [FK_tra_TransactionLetter_usr_UserInfo_CreatedBy] FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[usr_UserInfo] ([UserInfoId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tra_TransactionLetter_usr_UserInfo_CreatedBy]') AND parent_object_id = OBJECT_ID(N'[dbo].[tra_TransactionLetter]'))
ALTER TABLE [dbo].[tra_TransactionLetter] CHECK CONSTRAINT [FK_tra_TransactionLetter_usr_UserInfo_CreatedBy]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tra_TransactionLetter_usr_UserInfo_ModifiedBy]') AND parent_object_id = OBJECT_ID(N'[dbo].[tra_TransactionLetter]'))
ALTER TABLE [dbo].[tra_TransactionLetter]  WITH CHECK ADD  CONSTRAINT [FK_tra_TransactionLetter_usr_UserInfo_ModifiedBy] FOREIGN KEY([ModifiedBy])
REFERENCES [dbo].[usr_UserInfo] ([UserInfoId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tra_TransactionLetter_usr_UserInfo_ModifiedBy]') AND parent_object_id = OBJECT_ID(N'[dbo].[tra_TransactionLetter]'))
ALTER TABLE [dbo].[tra_TransactionLetter] CHECK CONSTRAINT [FK_tra_TransactionLetter_usr_UserInfo_ModifiedBy]
GO
