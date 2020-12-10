-- ======================================================================================================
-- Author      : Priyanka Wani
-- CREATED DATE: 22-MAR-2017
-- Description : Create usr_PasswordConfig table script

-- Modified By:  Tushar Wakchaure
-- Modified Date:10-Apr-2017
-- Description  :Added defaulttable data.

-- Modified By:  Vivek Mathur
-- Modified Date:10-Apr-2017
-- Description	: Added the checks before table creation & alter statements
-- ======================================================================================================

--Create usr_PasswordConfig table script
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[usr_PasswordConfig]') AND type in (N'U'))
CREATE TABLE [dbo].[usr_PasswordConfig](
	[PasswordConfigID] [int] IDENTITY(1,1) NOT NULL,
	[MinLength] [numeric](18, 0) NOT NULL,
	[MaxLength] [numeric](18, 0) NOT NULL,
	[MinAlphabets] [numeric](18, 0) NOT NULL,
	[MinNumbers] [numeric](18, 0) NOT NULL,
	[MinSplChar] [numeric](18, 0) NOT NULL,
	[MinUppercaseChar] [numeric](18, 0) NOT NULL,
	[CountOfPassHistory] [numeric](18, 0) NOT NULL,
	[PassValidity] [numeric](18, 0) NULL,
	[ExpiryReminder] [numeric](18, 0) NULL,
	[LastUpdatedOn] [datetime] NULL,
	[LastUpdatedBy] [varchar](50) NULL,
	[LoginAttempts] [numeric](18,0) NOT NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO
IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_PasswordConfig_MinLength]') AND type = 'D')
ALTER TABLE [dbo].[usr_PasswordConfig] ADD  CONSTRAINT [DF_PasswordConfig_MinLength]  DEFAULT ((0)) FOR [MinLength]
GO

IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_PasswordConfig_MaxLength]') AND type = 'D')
ALTER TABLE [dbo].[usr_PasswordConfig] ADD  CONSTRAINT [DF_PasswordConfig_MaxLength]  DEFAULT ((0)) FOR [MaxLength]
GO

IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_PasswordConfig_MinAlphabets]') AND type = 'D')
ALTER TABLE [dbo].[usr_PasswordConfig] ADD  CONSTRAINT [DF_PasswordConfig_MinAlphabets]  DEFAULT ((0)) FOR [MinAlphabets]
GO

IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_PasswordConfig_MinAlphabets]') AND type = 'D')
ALTER TABLE [dbo].[usr_PasswordConfig] ADD  CONSTRAINT [DF_PasswordConfig_MinAlphabets]  DEFAULT ((0)) FOR [MinNumbers]
GO

IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_PasswordConfig_MinSplChar]') AND type = 'D')
ALTER TABLE [dbo].[usr_PasswordConfig] ADD  CONSTRAINT [DF_PasswordConfig_MinSplChar]  DEFAULT ((0)) FOR [MinSplChar]
GO

IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_PasswordConfig_MinUppercaseChar]') AND type = 'D')
ALTER TABLE [dbo].[usr_PasswordConfig] ADD  CONSTRAINT [DF_PasswordConfig_MinUppercaseChar]  DEFAULT ((0)) FOR [MinUppercaseChar]
GO

IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_PasswordConfig_CountOfPassHistory]') AND type = 'D')
ALTER TABLE [dbo].[usr_PasswordConfig] ADD  CONSTRAINT [DF_PasswordConfig_CountOfPassHistory]  DEFAULT ((0)) FOR [CountOfPassHistory]
GO

IF NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_PasswordConfig_LoginAttempts]') AND type = 'D')
ALTER TABLE [dbo].[usr_PasswordConfig] ADD  CONSTRAINT [DF_PasswordConfig_LoginAttempts]  DEFAULT ((0)) FOR [LoginAttempts]
GO

--Add IsActive column in usr_userInfo table 0 means unlock and 1 means lock
IF NOT EXISTS(SELECT SYSTAB.NAME FROM SYS.TABLES SYSTAB INNER JOIN SYS.COLUMNS SYSCOL ON SYSTAB.OBJECT_ID = SYSCOL.OBJECT_ID WHERE SYSTAB.NAME = 'usr_UserInfo' AND SYSCOL.NAME = 'IsActive') 
ALTER TABLE [dbo].[usr_UserInfo] ADD IsActive BIT


-- Add default table data
BEGIN
IF NOT EXISTS (SELECT PasswordConfigID FROM usr_PasswordConfig)
INSERT INTO usr_PasswordConfig(MinLength,MaxLength,MinAlphabets,MinNumbers,MinSplChar,MinUppercaseChar,CountOfPassHistory,PassValidity,ExpiryReminder,LastUpdatedOn,LastUpdatedBy,LoginAttempts)
VALUES(8,20,1,1,1,1,5,45,5,GETDATE(),'Admin',3)
END
