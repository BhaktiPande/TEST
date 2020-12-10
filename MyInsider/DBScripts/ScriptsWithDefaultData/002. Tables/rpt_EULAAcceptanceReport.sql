/*
	Created By  : Priyanka	
	Created On  : 15-JUNE-2019
	Description : This script is used to create a table with name 'rpt_EULAAcceptanceReport'
*/
--drop table rpt_EULAAcceptanceReport
IF NOT EXISTS (SELECT NAME FROM SYS.TABLES WHERE NAME = 'rpt_EULAAcceptanceReport')
BEGIN

CREATE TABLE [dbo].[rpt_EULAAcceptanceReport](
	[EULAReportID] [int] IDENTITY(1,1) NOT NULL CONSTRAINT PK_rpt_EULAAcceptanceReport_EULAReportID PRIMARY KEY,
	[UserInfoID] [int] NOT NULL CONSTRAINT [FK_rpt_EULAAcceptanceReport_com_Document] DEFAULT (0),
	[DocumentID] [int] NOT NULL CONSTRAINT [FK_rpt_EULAAcceptanceReport_usr_UserInfo] DEFAULT (0),
	[EULAAcceptanceFlag] [bit] NOT NULL,
	[EULAAcceptanceDate] [datetime] NOT NULL,
)
END