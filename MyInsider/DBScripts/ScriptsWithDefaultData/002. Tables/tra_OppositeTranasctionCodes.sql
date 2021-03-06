/****** Object:  Table [dbo].[tra_OppositeTranasctionCodes]    Script Date: 06/07/2016 12:05:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tra_OppositeTranasctionCodes]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tra_OppositeTranasctionCodes](
	[TransactionCodeId] [int] NOT NULL,
	[OppositeTransactionCodeId] [int] NOT NULL
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tra_OppositeTranasctionCodes_com_Code_OppositeTransactionCodeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[tra_OppositeTranasctionCodes]'))
ALTER TABLE [dbo].[tra_OppositeTranasctionCodes]  WITH CHECK ADD  CONSTRAINT [FK_tra_OppositeTranasctionCodes_com_Code_OppositeTransactionCodeId] FOREIGN KEY([OppositeTransactionCodeId])
REFERENCES [dbo].[com_Code] ([CodeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tra_OppositeTranasctionCodes_com_Code_OppositeTransactionCodeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[tra_OppositeTranasctionCodes]'))
ALTER TABLE [dbo].[tra_OppositeTranasctionCodes] CHECK CONSTRAINT [FK_tra_OppositeTranasctionCodes_com_Code_OppositeTransactionCodeId]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tra_OppositeTranasctionCodes_com_Code_TransactionCodeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[tra_OppositeTranasctionCodes]'))
ALTER TABLE [dbo].[tra_OppositeTranasctionCodes]  WITH CHECK ADD  CONSTRAINT [FK_tra_OppositeTranasctionCodes_com_Code_TransactionCodeId] FOREIGN KEY([TransactionCodeId])
REFERENCES [dbo].[com_Code] ([CodeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tra_OppositeTranasctionCodes_com_Code_TransactionCodeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[tra_OppositeTranasctionCodes]'))
ALTER TABLE [dbo].[tra_OppositeTranasctionCodes] CHECK CONSTRAINT [FK_tra_OppositeTranasctionCodes_com_Code_TransactionCodeId]
GO
