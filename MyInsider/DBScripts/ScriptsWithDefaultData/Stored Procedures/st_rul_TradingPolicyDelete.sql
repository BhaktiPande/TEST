IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_rul_TradingPolicyDelete')
DROP PROCEDURE [dbo].[st_rul_TradingPolicyDelete]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
Description:	Marks the Trading Policy identified by input ID as Deleted.

Returns:		0, if Success.
				
Created by:		Ashashree
Created on:		5-Apr-2015

Modification History:
Modified By		Modified On			Description
Tushar			23-Jun-2015			Trading policy can't delete when applicability is defined and policy is active.
Raghvendra		10-Jul-2015			Change to handle the cases when to allow deleting the Trading Policy and if not possible
									then show corresponding messages. The cases when Trading Policy can be deleted are as follows,
									1) If Trading Policy is of future date (greater than today) and there are no versions maintained and 
									policy status is Active or Deactive then allow deleting. When deleting it also delete the applicability 
									associated with the policy
									2) If Trading Policy is of past date (today and less than today) and if no history versions are maintained and no applucability defined 
									against it then allow deleting it. 
									3) If trading Policy is of past date (today and less than today) and applicability associated then dont allow delete irrespective of the 
									status (Active / Deactive) of the Policy.
Raghvendra		07-Sep-2016		Changed the GETDATE() call with function dbo.uf_com_GetServerDate(). This function will return the date to be used as server date.

Usage:
DECLARE @RC int
EXEC st_rul_TradingPolicyDelete 1
-------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[st_rul_TradingPolicyDelete]
	-- Add the parameters for the stored procedure here
	@inp_iTradingPolicyId		INT,							-- Id of the Trading Policy which is to be deleted.
	@inp_nUserId				INT ,							-- Id of user marking the trading policy as deleted.	
	@out_nReturnValue			INT = 0 OUTPUT,		
	@out_nSQLErrCode			INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage			NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
	
AS
BEGIN
	DECLARE @ERR_TRADINGPOLICY_NOTFOUND INT
	DECLARE @ERR_TRADINGPOLICY_DELETE INT
	DECLARE @ERR_TRADINGPOLICY_DELETE_ACTIVE_POLICY	INT
	DECLARE @ERR_TRADINGPOLICY_DELETE_HISTORIC_RECORD INT
	DECLARE @ERR_TRADINGPOLICY_DELETE_APPLICABILITY_ASSOCIATED INT
	
	
	DECLARE @dtCurrentDate						DATETIME
	DECLARE	@dtExistingAppFromDate				DATETIME
	DECLARE	@dtExistingAppToDate				DATETIME
	DECLARE	@nTPExistingStatus					INT
	DECLARE @nTPStatusActive					INT
	
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

		--Initialize variables
		SELECT	@ERR_TRADINGPOLICY_NOTFOUND = 15059, --Trading Policy does not exist.
				@ERR_TRADINGPOLICY_DELETE = 15102,		--Error occurred while deleting trading policy.
				@ERR_TRADINGPOLICY_DELETE_ACTIVE_POLICY = 15103,	--Cannot delete trading policy because it is active with ongoing applicable date range
				@ERR_TRADINGPOLICY_DELETE_HISTORIC_RECORD = 15396,	--Cannot delete trading policy because history record exist for the same
				@ERR_TRADINGPOLICY_DELETE_APPLICABILITY_ASSOCIATED = 15397,	--Cannot delete trading policy because applicability is associated with the policy.
				@nTPStatusActive = 141002	--Trading policy Active status codeId
	
		--Check if the Trading Policy being deleted exists
		IF (NOT EXISTS(SELECT TradingPolicyId FROM rul_TradingPolicy WHERE TradingPolicyId = @inp_iTradingPolicyId))			
			BEGIN	
				SET @out_nReturnValue = @ERR_TRADINGPOLICY_NOTFOUND
				RETURN (@out_nReturnValue)
			END
		
		--Current System date to be used to check if the Trading Policy requested to be deleted is active or not
		SELECT @dtCurrentDate = dbo.uf_com_GetServerDate()
		SELECT @dtCurrentDate = CAST( CAST(@dtCurrentDate AS VARCHAR(11)) AS DATETIME ) --get only the date part and not the timestamp part
		
		--To find the applicability dates to decide if policy can be deleted or not
		SELECT @dtExistingAppFromDate = ApplicableFromDate, @dtExistingAppToDate = ApplicableToDate, @nTPExistingStatus = TradingPolicyStatusCodeId 
		FROM rul_TradingPolicy
		WHERE TradingPolicyId = @inp_iTradingPolicyId
		
		IF EXISTS (SELECT * FROM rul_TradingPolicy WHERE TradingPolicyId = @inp_iTradingPolicyId AND TradingPolicyParentId Is NOT NULL)
		BEGIN
			--Dont let delete the record, give error message
			SET @out_nReturnValue = @ERR_TRADINGPOLICY_DELETE_HISTORIC_RECORD
			RETURN (@out_nReturnValue)
		END
		ELSE IF @dtExistingAppFromDate > @dtCurrentDate
		BEGIN
			DELETE rul_ApplicabilityDetails WHERE ApplicabilityMstId = (SELECT ApplicabilityMstId FROM rul_ApplicabilityMaster WHERE MapToTypeCodeId = 132002 
				AND MapToId = @inp_iTradingPolicyId)
			DELETE rul_ApplicabilityMaster WHERE MapToTypeCodeId = 132002 
				AND MapToId = @inp_iTradingPolicyId
			UPDATE rul_TradingPolicy
				SET IsDeletedFlag = 1, ModifiedBy = @inp_nUserId, ModifiedOn = dbo.uf_com_GetServerDate()
				WHERE TradingPolicyId = @inp_iTradingPolicyId
		END
		ELSE IF @dtExistingAppFromDate <= @dtCurrentDate AND @dtExistingAppToDate <= @dtCurrentDate
		BEGIN
			IF(@nTPExistingStatus = @nTPStatusActive)	--Active policy cannot be marked as Deleted if current date between policy applicable dates
			BEGIN
				SET @out_nReturnValue = @ERR_TRADINGPOLICY_DELETE_ACTIVE_POLICY
				RETURN (@out_nReturnValue)
			END
			ELSE IF(EXISTS(SELECT ApplicabilityId FROM rul_ApplicabilityMaster WHERE MapToTypeCodeId = 132002 
				AND MapToId = @inp_iTradingPolicyId))
			BEGIN
				SET @out_nReturnValue = @ERR_TRADINGPOLICY_DELETE_APPLICABILITY_ASSOCIATED
				RETURN (@out_nReturnValue)
			END
			ELSE
			BEGIN
				SET @out_nReturnValue = @ERR_TRADINGPOLICY_DELETE_HISTORIC_RECORD
				RETURN (@out_nReturnValue)
			END
		END
		ELSE IF @dtExistingAppFromDate <= @dtCurrentDate AND @dtExistingAppToDate >= @dtCurrentDate
		BEGIN
			IF(@nTPExistingStatus = @nTPStatusActive)	--Active policy cannot be marked as Deleted if current date between policy applicable dates
			BEGIN
				SET @out_nReturnValue = @ERR_TRADINGPOLICY_DELETE_ACTIVE_POLICY
				RETURN (@out_nReturnValue)
			END
			ELSE IF(EXISTS(SELECT ApplicabilityId FROM rul_ApplicabilityMaster WHERE MapToTypeCodeId = 132002 
				AND MapToId = @inp_iTradingPolicyId))
			BEGIN
				SET @out_nReturnValue = @ERR_TRADINGPOLICY_DELETE_APPLICABILITY_ASSOCIATED
				RETURN (@out_nReturnValue)
			END
			ELSE
			BEGIN
				SET @out_nReturnValue = @ERR_TRADINGPOLICY_DELETE_HISTORIC_RECORD
				RETURN (@out_nReturnValue)
			END
		END 
		--Validate date and then mark as deleted if deletion is possible for applicable date range and current date
		--Fetch the current date of database server 
		--SELECT @dtCurrentDate = dbo.uf_com_GetServerDate()
		--SELECT @dtCurrentDate = CAST( CAST(@dtCurrentDate AS VARCHAR(11)) AS DATETIME ) --get only the date part and not the timestamp part
		--print @dtCurrentDate
		
		--Fetch applicable dates and window status of trading policy to compare the dates with current date and delete conditionally
		--SELECT @dtExistingAppFromDate = ApplicableFromDate, @dtExistingAppToDate = ApplicableToDate, @nTPExistingStatus = TradingPolicyStatusCodeId 
		--FROM rul_TradingPolicy
		--WHERE TradingPolicyId = @inp_iTradingPolicyId
	
		--IF( (@dtCurrentDate < @dtExistingAppFromDate AND @dtExistingAppFromDate <= @dtExistingAppToDate) OR 
		--	(@dtCurrentDate > @dtExistingAppToDate AND @dtExistingAppFromDate <= @dtExistingAppToDate) )
		--BEGIN
		--	--If current date < applicable from-to dates OR current date > applicable to-date then policy can be marked deleted when window status is Incomplete/Active/Inactive
		--	UPDATE rul_TradingPolicy
		--	SET IsDeletedFlag = 1, ModifiedBy = @inp_nUserId, ModifiedOn = dbo.uf_com_GetServerDate()
		--	WHERE TradingPolicyId = @inp_iTradingPolicyId
		--END 
		--ELSE IF(@dtExistingAppFromDate <= @dtCurrentDate AND @dtCurrentDate <= @dtExistingAppToDate AND @dtExistingAppFromDate <= @dtExistingAppToDate)
		--BEGIN
		--	IF(@nTPExistingStatus = @nTPStatusActive)	--Active policy cannot be marked as Deleted if current date between policy applicable dates
		--	BEGIN
		--		SET @out_nReturnValue = @ERR_TRADINGPOLICY_DELETE_ACTIVE_POLICY
		--		RETURN (@out_nReturnValue)
		--	END
		--	--If current date between applicable dates then policy can be marked deleted only when window status is Incomplete/Inactive
		--	UPDATE rul_TradingPolicy
		--	SET IsDeletedFlag = 1, ModifiedBy = @inp_nUserId, ModifiedOn = dbo.uf_com_GetServerDate()
		--	WHERE TradingPolicyId = @inp_iTradingPolicyId
		--END
		
		
		
		
	 --   IF(EXISTS(SELECT ApplicabilityId FROM rul_ApplicabilityMaster WHERE MapToTypeCodeId = 132002 
		--		AND MapToId = @inp_iTradingPolicyId))
		--BEGIN
		--	IF(@nTPExistingStatus = @nTPStatusActive)	--Active policy cannot be marked as Deleted if current date between policy applicable dates
		--	BEGIN
		--		SET @out_nReturnValue = @ERR_TRADINGPOLICY_DELETE_ACTIVE_POLICY
		--		RETURN (@out_nReturnValue)
		--	END
		--END
		--ELSE
		--BEGIN
		--	UPDATE rul_TradingPolicy
		--	SET IsDeletedFlag = 1, ModifiedBy = @inp_nUserId, ModifiedOn = dbo.uf_com_GetServerDate()
		--	WHERE TradingPolicyId = @inp_iTradingPolicyId
		--END

		SET @out_nReturnValue = 0
		RETURN @out_nReturnValue
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()
		
		-- Return common error if required, otherwise specific error.		
		SET @out_nReturnValue = dbo.uf_com_GetErrorCode(@ERR_TRADINGPOLICY_DELETE, ERROR_NUMBER())
		RETURN @out_nReturnValue
	END CATCH
END
