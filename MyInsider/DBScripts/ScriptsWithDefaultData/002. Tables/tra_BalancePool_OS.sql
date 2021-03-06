
/****** Object:  Table [dbo].[tra_BalancePool_OS]    Script Date: 02/20/2019 12:55 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tra_BalancePool_OS](
	[ExerciseBalanceID] [bigint] IDENTITY(1,1) NOT NULL,
	[UserInfoId] [int] NOT NULL,
	[DMATDetailsID] [int] NOT NULL,
	[CompanyID] [int] NOT NULL,
	[SecurityTypeCodeId] [int] NOT NULL,
	[VirtualQuantity] [decimal](15, 0) NULL,
	[ActualQuantity] [decimal](15, 0) NULL,
	[PledgeQuantity] [decimal](15, 0) NULL,
	[NotImpactedQuantity] [decimal](15, 0) NULL,
 CONSTRAINT [PK_tra_BalancePool_OS] PRIMARY KEY CLUSTERED 
(
	[ExerciseBalanceID] ASC,
	[UserInfoId] ASC,
	[DMATDetailsID] ASC,
	[CompanyID] ASC,
	[SecurityTypeCodeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[tra_BalancePool_OS]  WITH CHECK ADD  CONSTRAINT [FK_tra_BalancePool_OS_com_Code_SecurityTypeCodeId] FOREIGN KEY([SecurityTypeCodeId])
REFERENCES [dbo].[com_Code] ([CodeID])
GO

ALTER TABLE [dbo].[tra_BalancePool_OS] CHECK CONSTRAINT [FK_tra_BalancePool_OS_com_Code_SecurityTypeCodeId]
GO

ALTER TABLE [dbo].[tra_BalancePool_OS]  WITH CHECK ADD  CONSTRAINT [FK_tra_BalancePool_OS_rl_CompanyMasterList] FOREIGN KEY([CompanyID])
REFERENCES [dbo].[rl_CompanyMasterList] ([RlCompanyId])
GO

ALTER TABLE [dbo].[tra_BalancePool_OS] CHECK CONSTRAINT [FK_tra_BalancePool_OS_rl_CompanyMasterList]
GO

ALTER TABLE [dbo].[tra_BalancePool_OS]  WITH CHECK ADD  CONSTRAINT [FK_tra_BalancePool_OS_usr_DMATDetails_DMATDetailsID] FOREIGN KEY([DMATDetailsID])
REFERENCES [dbo].[usr_DMATDetails] ([DMATDetailsID])
GO

ALTER TABLE [dbo].[tra_BalancePool_OS] CHECK CONSTRAINT [FK_tra_BalancePool_OS_usr_DMATDetails_DMATDetailsID]
GO

ALTER TABLE [dbo].[tra_BalancePool_OS]  WITH CHECK ADD  CONSTRAINT [FK_tra_BalancePool_OS_Usr_UserInfo_UserInfoId] FOREIGN KEY([UserInfoId])
REFERENCES [dbo].[usr_UserInfo] ([UserInfoId])
GO

ALTER TABLE [dbo].[tra_BalancePool_OS] CHECK CONSTRAINT [FK_tra_BalancePool_OS_Usr_UserInfo_UserInfoId]
GO


