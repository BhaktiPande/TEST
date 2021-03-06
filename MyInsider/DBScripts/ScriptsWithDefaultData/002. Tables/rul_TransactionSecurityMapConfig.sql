/****** Object:  Table [dbo].[rul_TransactionSecurityMapConfig]    Script Date: 06/07/2016 12:05:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[rul_TransactionSecurityMapConfig]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[rul_TransactionSecurityMapConfig](
	[TransactionSecurityMapId] [int] IDENTITY(1,1) NOT NULL,
	[MapToTypeCodeId] [int] NOT NULL,
	[TransactionTypeCodeId] [int] NOT NULL,
	[SecurityTypeCodeId] [int] NOT NULL,
 CONSTRAINT [PK_rul_TransactionSecurityMapConfig] PRIMARY KEY CLUSTERED 
(
	[TransactionSecurityMapId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'rul_TransactionSecurityMapConfig', N'COLUMN',N'TransactionSecurityMapId'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Running Id for the configuration table' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_TransactionSecurityMapConfig', @level2type=N'COLUMN',@level2name=N'TransactionSecurityMapId'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'rul_TransactionSecurityMapConfig', N'COLUMN',N'MapToTypeCodeId'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Map type : 132004=preclearance, 132007=Prohibit Preclearance during non-trading' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_TransactionSecurityMapConfig', @level2type=N'COLUMN',@level2name=N'MapToTypeCodeId'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'rul_TransactionSecurityMapConfig', N'COLUMN',N'TransactionTypeCodeId'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Transaction type code id : 143001=Buy, 143002=Sell, 143003=Cash exercise, 143004=Cashless All, 143005=Cashless partial' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_TransactionSecurityMapConfig', @level2type=N'COLUMN',@level2name=N'TransactionTypeCodeId'
GO
IF NOT EXISTS (SELECT * FROM ::fn_listextendedproperty(N'MS_Description' , N'SCHEMA',N'dbo', N'TABLE',N'rul_TransactionSecurityMapConfig', N'COLUMN',N'SecurityTypeCodeId'))
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Security type code id : 139001=Shares, 139002=Warrants, 139003=Convertible Debentures, 139004=Future Contracts, 139005=Option Contracts' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'rul_TransactionSecurityMapConfig', @level2type=N'COLUMN',@level2name=N'SecurityTypeCodeId'
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_rul_TransactionSecurityMapConfig_com_Code_MapToTypeCodeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[rul_TransactionSecurityMapConfig]'))
ALTER TABLE [dbo].[rul_TransactionSecurityMapConfig]  WITH CHECK ADD  CONSTRAINT [FK_rul_TransactionSecurityMapConfig_com_Code_MapToTypeCodeId] FOREIGN KEY([MapToTypeCodeId])
REFERENCES [dbo].[com_Code] ([CodeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_rul_TransactionSecurityMapConfig_com_Code_MapToTypeCodeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[rul_TransactionSecurityMapConfig]'))
ALTER TABLE [dbo].[rul_TransactionSecurityMapConfig] CHECK CONSTRAINT [FK_rul_TransactionSecurityMapConfig_com_Code_MapToTypeCodeId]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_rul_TransactionSecurityMapConfig_com_Code_SecurityTypeCodeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[rul_TransactionSecurityMapConfig]'))
ALTER TABLE [dbo].[rul_TransactionSecurityMapConfig]  WITH CHECK ADD  CONSTRAINT [FK_rul_TransactionSecurityMapConfig_com_Code_SecurityTypeCodeId] FOREIGN KEY([SecurityTypeCodeId])
REFERENCES [dbo].[com_Code] ([CodeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_rul_TransactionSecurityMapConfig_com_Code_SecurityTypeCodeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[rul_TransactionSecurityMapConfig]'))
ALTER TABLE [dbo].[rul_TransactionSecurityMapConfig] CHECK CONSTRAINT [FK_rul_TransactionSecurityMapConfig_com_Code_SecurityTypeCodeId]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_rul_TransactionSecurityMapConfig_com_Code_TransactionTypeCodeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[rul_TransactionSecurityMapConfig]'))
ALTER TABLE [dbo].[rul_TransactionSecurityMapConfig]  WITH CHECK ADD  CONSTRAINT [FK_rul_TransactionSecurityMapConfig_com_Code_TransactionTypeCodeId] FOREIGN KEY([TransactionTypeCodeId])
REFERENCES [dbo].[com_Code] ([CodeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_rul_TransactionSecurityMapConfig_com_Code_TransactionTypeCodeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[rul_TransactionSecurityMapConfig]'))
ALTER TABLE [dbo].[rul_TransactionSecurityMapConfig] CHECK CONSTRAINT [FK_rul_TransactionSecurityMapConfig_com_Code_TransactionTypeCodeId]
GO
