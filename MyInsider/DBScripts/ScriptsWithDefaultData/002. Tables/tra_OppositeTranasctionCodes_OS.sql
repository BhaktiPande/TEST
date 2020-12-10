/****** Object:  Table [dbo].[tra_OppositeTranasctionCodes_OS]    Script Date: 02/19/2019 12:55 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tra_OppositeTranasctionCodes_OS](
	[TransactionCodeId] [int] NOT NULL,
	[OppositeTransactionCodeId] [int] NOT NULL
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[tra_OppositeTranasctionCodes_OS]  WITH CHECK ADD  CONSTRAINT [FK_tra_OppositeTranasctionCodes_OS_com_Code_OppositeTransactionCodeId] FOREIGN KEY([OppositeTransactionCodeId])
REFERENCES [dbo].[com_Code] ([CodeID])
GO

ALTER TABLE [dbo].[tra_OppositeTranasctionCodes_OS] CHECK CONSTRAINT [FK_tra_OppositeTranasctionCodes_OS_com_Code_OppositeTransactionCodeId]
GO

ALTER TABLE [dbo].[tra_OppositeTranasctionCodes_OS]  WITH CHECK ADD  CONSTRAINT [FK_tra_OppositeTranasctionCodes_OS_com_Code_TransactionCodeId] FOREIGN KEY([TransactionCodeId])
REFERENCES [dbo].[com_Code] ([CodeID])
GO

ALTER TABLE [dbo].[tra_OppositeTranasctionCodes_OS] CHECK CONSTRAINT [FK_tra_OppositeTranasctionCodes_OS_com_Code_TransactionCodeId]
GO


