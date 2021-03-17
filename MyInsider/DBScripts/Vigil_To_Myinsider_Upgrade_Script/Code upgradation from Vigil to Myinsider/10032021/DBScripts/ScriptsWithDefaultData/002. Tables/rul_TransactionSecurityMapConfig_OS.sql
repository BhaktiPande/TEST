
IF NOT EXISTS (SELECT NAME FROM SYS.TABLES WHERE NAME = 'rul_TransactionSecurityMapConfig_OS')
BEGIN

CREATE TABLE [dbo].[rul_TransactionSecurityMapConfig_OS](
	[TransactionSecurityMapId] [int] IDENTITY(1,1) NOT NULL,
	[MapToTypeCodeId] [int] NOT NULL,
	[TransactionTypeCodeId] [int] NOT NULL,
	[SecurityTypeCodeId] [int] NOT NULL,
 CONSTRAINT [PK_rul_TransactionSecurityMapConfig_OS] PRIMARY KEY CLUSTERED 
(
	[TransactionSecurityMapId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


ALTER TABLE [dbo].[rul_TransactionSecurityMapConfig_OS]  WITH CHECK ADD  CONSTRAINT [FK_rul_TransactionSecurityMapConfig_OS_com_Code_MapToTypeCodeId] FOREIGN KEY([MapToTypeCodeId])
REFERENCES [dbo].[com_Code] ([CodeID])


ALTER TABLE [dbo].[rul_TransactionSecurityMapConfig_OS] CHECK CONSTRAINT [FK_rul_TransactionSecurityMapConfig_OS_com_Code_MapToTypeCodeId]


ALTER TABLE [dbo].[rul_TransactionSecurityMapConfig_OS]  WITH CHECK ADD  CONSTRAINT [FK_rul_TransactionSecurityMapConfig_OS_com_Code_SecurityTypeCodeId] FOREIGN KEY([SecurityTypeCodeId])
REFERENCES [dbo].[com_Code] ([CodeID])


ALTER TABLE [dbo].[rul_TransactionSecurityMapConfig_OS] CHECK CONSTRAINT [FK_rul_TransactionSecurityMapConfig_OS_com_Code_SecurityTypeCodeId]


ALTER TABLE [dbo].[rul_TransactionSecurityMapConfig_OS]  WITH CHECK ADD  CONSTRAINT [FK_rul_TransactionSecurityMapConfig_OS_com_Code_TransactionTypeCodeId] FOREIGN KEY([TransactionTypeCodeId])
REFERENCES [dbo].[com_Code] ([CodeID])


ALTER TABLE [dbo].[rul_TransactionSecurityMapConfig_OS] CHECK CONSTRAINT [FK_rul_TransactionSecurityMapConfig_OS_com_Code_TransactionTypeCodeId]


EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Running Id for the configuration table' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_TransactionSecurityMapConfig_OS', @level2type=N'COLUMN',@level2name=N'TransactionSecurityMapId'


EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Map type : 132004=preclearance, 132007=Prohibit Preclearance during non-trading' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_TransactionSecurityMapConfig_OS', @level2type=N'COLUMN',@level2name=N'MapToTypeCodeId'


EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Transaction type code id : 143001=Buy, 143002=Sell, 143003=Cash exercise, 143004=Cashless All, 143005=Cashless partial' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_TransactionSecurityMapConfig_OS', @level2type=N'COLUMN',@level2name=N'TransactionTypeCodeId'


EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Security type code id : 139001=Shares, 139002=Warrants, 139003=Convertible Debentures, 139004=Future Contracts, 139005=Option Contracts' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_TransactionSecurityMapConfig_OS', @level2type=N'COLUMN',@level2name=N'SecurityTypeCodeId'

END


