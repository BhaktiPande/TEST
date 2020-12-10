
/****** Object:  Table [dbo].[rpt_DefaulterReport_OS]    Script Date: 07/18/2019 04:13 PM ******/

IF NOT EXISTS (SELECT NAME FROM SYS.TABLES WHERE NAME = 'rpt_DefaulterReport_OS')
BEGIN
	CREATE TABLE [dbo].[rpt_DefaulterReport_OS](
		[DefaulterReportID] [bigint] IDENTITY(1,1) NOT NULL CONSTRAINT PK_rpt_DefaulterReport_OS PRIMARY KEY,
		[UserInfoID] [int] NOT NULL CONSTRAINT FK_rpt_DefaulterReport_OS_usr_UserInfo FOREIGN KEY (UserInfoId) REFERENCES USR_USERINFO (UserInfoId),
		[UserInfoIdRelative] [int] NULL CONSTRAINT FK_rpt_DefaulterReport_OS_usr_UserInfoRelative FOREIGN KEY (UserInfoId) REFERENCES USR_USERINFO (UserInfoId),
		[PreclearanceRequestId] [bigint] NULL CONSTRAINT FK_rpt_DefaulterReport_OS_tra_PreclearanceRequest_NonImplementationCompany FOREIGN KEY (PreclearanceRequestId) REFERENCES tra_PreclearanceRequest_NonImplementationCompany (PreclearanceRequestId),
		[TransactionMasterId] [bigint] NULL CONSTRAINT FK_rpt_DefaulterReport_OS_tra_TransactionMaster_OS FOREIGN KEY (TransactionMasterId) REFERENCES tra_TransactionMaster_OS (TransactionMasterId),
		[TransactionDetailsId] [bigint] NULL CONSTRAINT FK_rpt_DefaulterReport_OS_tra_TransactionDetails_OS FOREIGN KEY (TransactionDetailsId) REFERENCES tra_TransactionDetails_OS (TransactionDetailsId),
		[InitialContinousPeriodEndDisclosureRequired] [int] NULL,
		[LastSubmissionDate] [datetime] NULL,
		[NonComplainceTypeCodeId] [int] NOT NULL CONSTRAINT FK_rpt_DefaulterReport_OS_com_Code FOREIGN KEY (NonComplainceTypeCodeId) REFERENCES com_Code (CodeID),
		[PeriodEndDate] [datetime] NULL,
	) 
END