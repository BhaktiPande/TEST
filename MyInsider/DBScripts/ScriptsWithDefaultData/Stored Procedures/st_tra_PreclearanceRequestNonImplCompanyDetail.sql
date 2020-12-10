IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_tra_PreclearanceRequestNonImplCompanyDetail')
DROP PROCEDURE [dbo].[st_tra_PreclearanceRequestNonImplCompanyDetail]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Saves the PreclearanceRequest details for non implementing company

Returns:		0, if Success.
				
Created by:		Parag
Created on:		22-Sept-2016

Modification History:
Modified By		Modified On		Description

Usage:

-------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[st_tra_PreclearanceRequestNonImplCompanyDetail] 
	@inp_iPreclearanceRequestId			BIGINT,
	@out_nReturnValue					INT = 0 OUTPUT,
	@out_nSQLErrCode					INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage					NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
AS
BEGIN

	DECLARE @ERR_PRECLEARANCEREQUEST_DETAIL_ERROR	INT = 17528 -- Error occured while fetching preclearance for non implementing company
	
	DECLARE @PreclearanceStatus_Requested INT = 144001

	DECLARE @nMapToTypeCodeId_PCLNonImplCompany INT = 132015 -- Preclearance - NonImplementing Company

	DECLARE @Event_PreClearanceApproved INT = 153046
	DECLARE @Event_PreClearanceRejected INT = 153047
	
	BEGIN TRY
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''
		
		SELECT 
			pcl.PreclearanceRequestId, pcl.RlSearchAuditId, pcl.DisplaySequenceNo, pcl.PreclearanceRequestForCodeId, pcl.UserInfoId,
			pcl.UserInfoIdRelative, pcl.TransactionTypeCodeId, pcl.SecurityTypeCodeId, pcl.SecuritiesToBeTradedQty, pcl.SecuritiesToBeTradedValue,
			pcl.PreclearanceStatusCodeId, pcl.CompanyId, pcl.DMATDetailsID, pcl.ModeOfAcquisitionCodeId, pcl.ReasonForRejection,

			ccstatus.CodeName AS 'PreclearanceStatusText', 
			rlc.CompanyName AS 'CompanyName',
			pcl.CreatedOn as 'PreclearanceCreatedOn',
			pcl.CreatedBy as 'PreclearanceCreatedBy',
			CASE 
				WHEN pcl.PreclearanceStatusCodeId <> @PreclearanceStatus_Requested THEN 
					CASE 
						WHEN pcl.IsAutoApproved = 1 THEN pcl.ApprovedBy 
						ELSE eve.CreatedBy 
					END
				ELSE NULL
			END AS 'ApproveOrRejectedBy',
			CASE 
				WHEN pcl.PreclearanceStatusCodeId <> @PreclearanceStatus_Requested THEN 
					CASE 
						WHEN pcl.IsAutoApproved = 1 THEN 'Auto Approved'
						ELSE usr.FirstName + ' ' + usr.LastName
					END
				ELSE ''
			END AS 'ApprovedByName',
			CASE 
				WHEN pcl.PreclearanceStatusCodeId <> @PreclearanceStatus_Requested THEN 
					CASE 
						WHEN pcl.IsAutoApproved = 1 THEN pcl.ApprovedOn 
						ELSE eve.EventDate 
					END
				ELSE NULL
			END AS 'ApproveOrRejectOn',
			usr.FirstName +' '+usr.LastName  AS 'a',
			c.CodeName AS ReasonForNotTradingCodeText,
			pcl.ReasonForNotTradingText,
			pcl.ReasonForApproval,cReasonForApproval.CodeName AS ReasonForApprovalCodeId
		FROM tra_PreclearanceRequest_NonImplementationCompany pcl
		LEFT JOIN com_Code ccstatus ON pcl.PreclearanceStatusCodeId = ccstatus.CodeID
		LEFT JOIN rl_CompanyMasterList rlc ON pcl.CompanyId = RlCompanyId
		LEFT JOIN eve_EventLog eve ON eve.MapToTypeCodeId = @nMapToTypeCodeId_PCLNonImplCompany 
										AND pcl.UserInfoId = eve.UserInfoId AND pcl.PreclearanceRequestId = eve.MapToId
										AND (eve.EventCodeId = @Event_PreClearanceApproved OR eve.EventCodeId = @Event_PreClearanceRejected)
		LEFT JOIN usr_UserInfo usr on eve.UserInfoId IS NOT NULL AND eve.UserInfoId = usr.UserInfoId
		LEFT JOIN com_Code c ON pcl.ReasonForNotTradingCodeId= c.CodeID
		LEFT JOIN com_Code cReasonForApproval ON cReasonForApproval.CodeID = pcl.ReasonForApprovalCodeId
		WHERE PreclearanceRequestId = @inp_iPreclearanceRequestId

		SET @out_nReturnValue = 0
		RETURN @out_nReturnValue
	END	 TRY

	BEGIN CATCH	
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()	
		SET @out_nReturnValue =  dbo.uf_com_GetErrorCode(@ERR_PRECLEARANCEREQUEST_DETAIL_ERROR, ERROR_NUMBER())
		
		RETURN @out_nReturnValue
	END CATCH
END