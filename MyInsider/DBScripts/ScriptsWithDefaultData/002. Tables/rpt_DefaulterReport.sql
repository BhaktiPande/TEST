/****** Object:  Table [dbo].[rpt_DefaulterReport]    Script Date: 06/07/2016 12:05:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[rpt_DefaulterReport]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[rpt_DefaulterReport](
	[DefaulterReportID] [bigint] IDENTITY(1,1) NOT NULL,
	[UserInfoID] [int] NOT NULL,
	[UserInfoIdRelative] [int] NULL,
	[PreclearanceRequestId] [bigint] NULL,
	[TransactionMasterId] [bigint] NULL,
	[TransactionDetailsId] [bigint] NULL,
	[InitialContinousPeriodEndDisclosureRequired] [int] NULL,
	[LastSubmissionDate] [datetime] NULL,
	[NonComplainceTypeCodeId] [int] NOT NULL,
	[PeriodEndDate] [datetime] NULL,
 CONSTRAINT [PK_rpt_DefaulterReport] PRIMARY KEY CLUSTERED 
(
	[DefaulterReportID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_rpt_DefaulterReport_com_Code_NonComplainceTypeCodeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[rpt_DefaulterReport]'))
ALTER TABLE [dbo].[rpt_DefaulterReport]  WITH CHECK ADD  CONSTRAINT [FK_rpt_DefaulterReport_com_Code_NonComplainceTypeCodeId] FOREIGN KEY([NonComplainceTypeCodeId])
REFERENCES [dbo].[com_Code] ([CodeID])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_rpt_DefaulterReport_com_Code_NonComplainceTypeCodeId]') AND parent_object_id = OBJECT_ID(N'[dbo].[rpt_DefaulterReport]'))
ALTER TABLE [dbo].[rpt_DefaulterReport] CHECK CONSTRAINT [FK_rpt_DefaulterReport_com_Code_NonComplainceTypeCodeId]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_rpt_DefaulterReport_tra_PreclearanceRequest_PreclearanceRequestId]') AND parent_object_id = OBJECT_ID(N'[dbo].[rpt_DefaulterReport]'))
ALTER TABLE [dbo].[rpt_DefaulterReport]  WITH CHECK ADD  CONSTRAINT [FK_rpt_DefaulterReport_tra_PreclearanceRequest_PreclearanceRequestId] FOREIGN KEY([PreclearanceRequestId])
REFERENCES [dbo].[tra_PreclearanceRequest] ([PreclearanceRequestId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_rpt_DefaulterReport_tra_PreclearanceRequest_PreclearanceRequestId]') AND parent_object_id = OBJECT_ID(N'[dbo].[rpt_DefaulterReport]'))
ALTER TABLE [dbo].[rpt_DefaulterReport] CHECK CONSTRAINT [FK_rpt_DefaulterReport_tra_PreclearanceRequest_PreclearanceRequestId]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_rpt_DefaulterReport_tra_TransactionDetails_TransactionDetailsId]') AND parent_object_id = OBJECT_ID(N'[dbo].[rpt_DefaulterReport]'))
ALTER TABLE [dbo].[rpt_DefaulterReport]  WITH CHECK ADD  CONSTRAINT [FK_rpt_DefaulterReport_tra_TransactionDetails_TransactionDetailsId] FOREIGN KEY([TransactionDetailsId])
REFERENCES [dbo].[tra_TransactionDetails] ([TransactionDetailsId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_rpt_DefaulterReport_tra_TransactionDetails_TransactionDetailsId]') AND parent_object_id = OBJECT_ID(N'[dbo].[rpt_DefaulterReport]'))
ALTER TABLE [dbo].[rpt_DefaulterReport] CHECK CONSTRAINT [FK_rpt_DefaulterReport_tra_TransactionDetails_TransactionDetailsId]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_rpt_DefaulterReport_tra_TransactionMaster_TransactionMasterId]') AND parent_object_id = OBJECT_ID(N'[dbo].[rpt_DefaulterReport]'))
ALTER TABLE [dbo].[rpt_DefaulterReport]  WITH CHECK ADD  CONSTRAINT [FK_rpt_DefaulterReport_tra_TransactionMaster_TransactionMasterId] FOREIGN KEY([TransactionMasterId])
REFERENCES [dbo].[tra_TransactionMaster] ([TransactionMasterId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_rpt_DefaulterReport_tra_TransactionMaster_TransactionMasterId]') AND parent_object_id = OBJECT_ID(N'[dbo].[rpt_DefaulterReport]'))
ALTER TABLE [dbo].[rpt_DefaulterReport] CHECK CONSTRAINT [FK_rpt_DefaulterReport_tra_TransactionMaster_TransactionMasterId]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_rpt_DefaulterReport_usr_UserInfo_UserInfoId]') AND parent_object_id = OBJECT_ID(N'[dbo].[rpt_DefaulterReport]'))
ALTER TABLE [dbo].[rpt_DefaulterReport]  WITH CHECK ADD  CONSTRAINT [FK_rpt_DefaulterReport_usr_UserInfo_UserInfoId] FOREIGN KEY([UserInfoID])
REFERENCES [dbo].[usr_UserInfo] ([UserInfoId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_rpt_DefaulterReport_usr_UserInfo_UserInfoId]') AND parent_object_id = OBJECT_ID(N'[dbo].[rpt_DefaulterReport]'))
ALTER TABLE [dbo].[rpt_DefaulterReport] CHECK CONSTRAINT [FK_rpt_DefaulterReport_usr_UserInfo_UserInfoId]
GO
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_rpt_DefaulterReport_usr_UserInfo_UserInfoIdRelative]') AND parent_object_id = OBJECT_ID(N'[dbo].[rpt_DefaulterReport]'))
ALTER TABLE [dbo].[rpt_DefaulterReport]  WITH CHECK ADD  CONSTRAINT [FK_rpt_DefaulterReport_usr_UserInfo_UserInfoIdRelative] FOREIGN KEY([UserInfoIdRelative])
REFERENCES [dbo].[usr_UserInfo] ([UserInfoId])
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_rpt_DefaulterReport_usr_UserInfo_UserInfoIdRelative]') AND parent_object_id = OBJECT_ID(N'[dbo].[rpt_DefaulterReport]'))
ALTER TABLE [dbo].[rpt_DefaulterReport] CHECK CONSTRAINT [FK_rpt_DefaulterReport_usr_UserInfo_UserInfoIdRelative]
GO
