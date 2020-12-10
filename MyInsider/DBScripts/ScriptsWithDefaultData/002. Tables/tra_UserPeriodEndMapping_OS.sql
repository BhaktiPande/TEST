/****** Object:  Table [dbo].[tra_UserPeriodEndMapping_OS]    Script Date: 06/07/2016 12:05:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tra_UserPeriodEndMapping_OS]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tra_UserPeriodEndMapping_OS](
	[UserPeriodEndMappingId] [bigint] IDENTITY(1,1) NOT NULL,
	[UserInfoId] [int] NOT NULL,
	[TradingPolicyId] [int] NOT NULL,
	[YearCodeId] [int] NOT NULL,
	[PeriodCodeId] [int] NULL,
	[PEStartDate] [datetime] NULL,
	[PEEndDate] [datetime] NULL,
	[CreatedBy] [int] NULL,
	[CreatedOn] [datetime] NULL,
	[ModifiedBy] [int] NULL,
	[ModifiedOn] [datetime] NULL,
 CONSTRAINT [PK_tra_UserPeriodEndMapping_OS] PRIMARY KEY CLUSTERED 
(
	[UserPeriodEndMappingId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tra_UserPeriodEndMapping_OS_com_code_PeriodCodeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[tra_UserPeriodEndMapping_OS]'))
ALTER TABLE [dbo].[tra_UserPeriodEndMapping_OS]  WITH CHECK ADD  CONSTRAINT [FK_tra_UserPeriodEndMapping_OS_com_code_PeriodCodeId] FOREIGN KEY([PeriodCodeId])
REFERENCES [dbo].[com_Code] ([CodeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tra_UserPeriodEndMapping_OS_com_code_PeriodCodeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[tra_UserPeriodEndMapping_OS]'))
ALTER TABLE [dbo].[tra_UserPeriodEndMapping_OS] CHECK CONSTRAINT [FK_tra_UserPeriodEndMapping_OS_com_code_PeriodCodeId]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tra_UserPeriodEndMapping_OS_com_code_YearCodeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[tra_UserPeriodEndMapping_OS]'))
ALTER TABLE [dbo].[tra_UserPeriodEndMapping_OS]  WITH CHECK ADD  CONSTRAINT [FK_tra_UserPeriodEndMapping_OS_com_code_YearCodeId] FOREIGN KEY([YearCodeId])
REFERENCES [dbo].[com_Code] ([CodeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tra_UserPeriodEndMapping_OS_com_code_YearCodeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[tra_UserPeriodEndMapping_OS]'))
ALTER TABLE [dbo].[tra_UserPeriodEndMapping_OS] CHECK CONSTRAINT [FK_tra_UserPeriodEndMapping_OS_com_code_YearCodeId]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tra_UserPeriodEndMapping_OS_rul_TradingPolicy_OS_TradingPolicyId]') AND parent_object_id = OBJECT_ID(N'[dbo].[tra_UserPeriodEndMapping_OS]'))
ALTER TABLE [dbo].[tra_UserPeriodEndMapping_OS]  WITH CHECK ADD  CONSTRAINT [FK_tra_UserPeriodEndMapping_OS_rul_TradingPolicy_OS_TradingPolicyId] FOREIGN KEY([TradingPolicyId])
REFERENCES [dbo].[rul_TradingPolicy_OS] ([TradingPolicyId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tra_UserPeriodEndMapping_OS_rul_TradingPolicy_OS_TradingPolicyId]') AND parent_object_id = OBJECT_ID(N'[dbo].[tra_UserPeriodEndMapping_OS]'))
ALTER TABLE [dbo].[tra_UserPeriodEndMapping_OS] CHECK CONSTRAINT [FK_tra_UserPeriodEndMapping_OS_rul_TradingPolicy_OS_TradingPolicyId]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tra_UserPeriodEndMapping_OS_usr_UserInfo_CreatedBy]') AND parent_object_id = OBJECT_ID(N'[dbo].[tra_UserPeriodEndMapping_OS]'))
ALTER TABLE [dbo].[tra_UserPeriodEndMapping_OS]  WITH CHECK ADD  CONSTRAINT [FK_tra_UserPeriodEndMapping_OS_usr_UserInfo_CreatedBy] FOREIGN KEY([CreatedBy])
REFERENCES [dbo].[usr_UserInfo] ([UserInfoId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tra_UserPeriodEndMapping_OS_usr_UserInfo_CreatedBy]') AND parent_object_id = OBJECT_ID(N'[dbo].[tra_UserPeriodEndMapping_OS]'))
ALTER TABLE [dbo].[tra_UserPeriodEndMapping_OS] CHECK CONSTRAINT [FK_tra_UserPeriodEndMapping_OS_usr_UserInfo_CreatedBy]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tra_UserPeriodEndMapping_OS_usr_UserInfo_ModifiedBy]') AND parent_object_id = OBJECT_ID(N'[dbo].[tra_UserPeriodEndMapping_OS]'))
ALTER TABLE [dbo].[tra_UserPeriodEndMapping_OS]  WITH CHECK ADD  CONSTRAINT [FK_tra_UserPeriodEndMapping_OS_usr_UserInfo_ModifiedBy] FOREIGN KEY([ModifiedBy])
REFERENCES [dbo].[usr_UserInfo] ([UserInfoId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tra_UserPeriodEndMapping_OS_usr_UserInfo_ModifiedBy]') AND parent_object_id = OBJECT_ID(N'[dbo].[tra_UserPeriodEndMapping_OS]'))
ALTER TABLE [dbo].[tra_UserPeriodEndMapping_OS] CHECK CONSTRAINT [FK_tra_UserPeriodEndMapping_OS_usr_UserInfo_ModifiedBy]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tra_UserPeriodEndMapping_OS_usr_UserInfo_UserInfoId]') AND parent_object_id = OBJECT_ID(N'[dbo].[tra_UserPeriodEndMapping_OS]'))
ALTER TABLE [dbo].[tra_UserPeriodEndMapping_OS]  WITH CHECK ADD  CONSTRAINT [FK_tra_UserPeriodEndMapping_OS_usr_UserInfo_UserInfoId] FOREIGN KEY([UserInfoId])
REFERENCES [dbo].[usr_UserInfo] ([UserInfoId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_tra_UserPeriodEndMapping_OS_usr_UserInfo_UserInfoId]') AND parent_object_id = OBJECT_ID(N'[dbo].[tra_UserPeriodEndMapping_OS]'))
ALTER TABLE [dbo].[tra_UserPeriodEndMapping_OS] CHECK CONSTRAINT [FK_tra_UserPeriodEndMapping_OS_usr_UserInfo_UserInfoId]
GO
