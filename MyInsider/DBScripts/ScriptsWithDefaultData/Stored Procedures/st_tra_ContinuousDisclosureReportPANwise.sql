IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_tra_ContinuousDisclosureReportPANwise')
	DROP PROCEDURE st_tra_ContinuousDisclosureReportPANwise
GO
GO
/****** Object:  StoredProcedure [dbo].[st_tra_ContinuousDisclosureReportPANwise]    Script Date: 12/20/2017 10:02:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
Description:	This procedure returns PAN wise data for Continuous Disclosure Report.			
Created by:		Azhar Desai/Tushar Wakchaure
Created on:		05-December-2015
EXEC st_tra_ContinuousDisclosureReportPANwise
*/


CREATE PROCEDURE [dbo].[st_tra_ContinuousDisclosureReportPANwise]
AS
BEGIN

DECLARE @DisclosureTypeCode INT = 147002

	SELECT
		DISTINCT UI.PAN 
	FROM usr_UserInfo UI 
		INNER JOIN tra_TransactionMaster TM ON UI.UserInfoId = TM.UserInfoId 
	WHERE 
		DisclosureTypeCodeId  = @DisclosureTypeCode 
	ORDER BY 
		UI.PAN

END 