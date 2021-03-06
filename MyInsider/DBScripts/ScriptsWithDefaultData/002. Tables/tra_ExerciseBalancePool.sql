
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[tra_ExerciseBalancePool]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[tra_ExerciseBalancePool](
	[UserInfoId] [int] NOT NULL,
	[SecurityTypeCodeId] [int] NOT NULL,
	[ESOPQuantity] [decimal](15, 0) NOT NULL DEFAULT 0,
	[OtherQuantity] [decimal](15, 0) NOT NULL DEFAULT 0,
 CONSTRAINT [PK_tra_ExerciseBalancePool] PRIMARY KEY CLUSTERED 
(
	[UserInfoId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_tra_ExerciseBalancePool_com_Code_SecurityTypeCodeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[tra_ExerciseBalancePool]'))
ALTER TABLE [dbo].[tra_ExerciseBalancePool]  WITH CHECK ADD  CONSTRAINT [fk_tra_ExerciseBalancePool_com_Code_SecurityTypeCodeId] FOREIGN KEY([SecurityTypeCodeId])
REFERENCES [dbo].[com_Code] ([CodeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_tra_ExerciseBalancePool_com_Code_SecurityTypeCodeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[tra_ExerciseBalancePool]'))
ALTER TABLE [dbo].[tra_ExerciseBalancePool] CHECK CONSTRAINT [fk_tra_ExerciseBalancePool_com_Code_SecurityTypeCodeId]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_tra_ExerciseBalancePool_Usr_UserInfo_UserINfoId]') AND parent_object_id = OBJECT_ID(N'[dbo].[tra_ExerciseBalancePool]'))
ALTER TABLE [dbo].[tra_ExerciseBalancePool]  WITH CHECK ADD  CONSTRAINT [fk_tra_ExerciseBalancePool_Usr_UserInfo_UserINfoId] FOREIGN KEY([UserInfoId])
REFERENCES [dbo].[usr_UserInfo] ([UserInfoId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[fk_tra_ExerciseBalancePool_Usr_UserInfo_UserINfoId]') AND parent_object_id = OBJECT_ID(N'[dbo].[tra_ExerciseBalancePool]'))
ALTER TABLE [dbo].[tra_ExerciseBalancePool] CHECK CONSTRAINT [fk_tra_ExerciseBalancePool_Usr_UserInfo_UserINfoId]
GO
