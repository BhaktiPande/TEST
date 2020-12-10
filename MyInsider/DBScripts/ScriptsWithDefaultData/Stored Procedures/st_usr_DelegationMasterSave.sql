IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_usr_DelegationMasterSave')
DROP PROCEDURE [dbo].[st_usr_DelegationMasterSave]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
Description:	Procedure to save delegations.

Returns:		0, if Success.
				
Created by:		Arundhati
Created on:		03-Mar-2015

Modification History:
Modified By		Modified On		Description
Arundhati		09-Mar-2015		Added few more checks regarding start and end date
Arundhati		16-Mar-2015		From date can also be changed, if the delegation is not yet started
Amar			08-May-2015		PartialSave set to 0 when user only wants to validate the data and not save to database
Arundhati		25-Jun-2015		Checked that From and To user should not be same
Raghvendra		07-Sep-2016		Changed the GETDATE() call with function dbo.uf_com_GetServerDate(). This function will return the date to be used as server date.

Usage:
EXEC st_usr_DelegationMasterSave
-------------------------------------------------------------------------------------------------*/

CREATE PROCEDURE [dbo].[st_usr_DelegationMasterSave]
	@inp_iDelegationId				INT
	,@inp_iUserInfoIdFrom			INT
	,@inp_iUserInfoIdTo				INT
	,@inp_dtDelegationFrom			DATETIME
	,@inp_dtDelegationTo			DATETIME
	,@inp_nPartialSave				INT
	,@inp_iLoggedInUserId			INT
	,@out_nReturnValue				INT = 0 OUTPUT
	,@out_nSQLErrCode				INT = 0 OUTPUT				-- Output SQL Error Number, if error occurred.
	,@out_sSQLErrMessage			VARCHAR(500) = '' OUTPUT  -- Output SQL Error Message, if error occurred.	
AS
BEGIN
	DECLARE @ERR_DELEGATION_SAVE INT = 12017 -- Error occurred while saving delegations.
	DECLARE @ERR_DELEGATION_NOTFOUND INT = 12018 -- Delegation does not exist.
	DECLARE @ERR_DELEGATIONSFORSAMEPERIODEXISTS INT = 12019 -- Delegations from the delegating user to delegated user for overlapping/same period exists
	DECLARE @ERR_DELEGATIONBYDELEGATEDUSEREXISTS INT = 12020 -- Delegation is already defined by the delegated user for the same/overlapping period	
	DECLARE @ERR_DELEGATIONTODELEGATINGUSEREXISTS INT = 12021 -- Delegation is already defined to the delegating user for the same/overlapping period.
	DECLARE @ERR_CANNOTDELETEDEGATION INT = 12023 -- Cannot delete or change delegation. To delete delegation record, Start date must be greater than today
	DECLARE @ERR_FROMDATELESSTHANTODAY INT = 12028 -- From Date should be greater than or equal to Today.
	DECLARE @ERR_TODATENOTGREATERTHANFROMDATE INT = 12029 -- To Date should be greater than or equal to From Date.
	DECLARE @ERR_TODATENOTGREATERTHANTODAY INT = 12030 -- To Date should be greater than or equal to Today.
	DECLARE @ERR_FROMTOUSERSSHOULDNOTBESAME INT = 12049 -- From and To users should not be same while defining delegation
	DECLARE @dtToday DATETIME = CONVERT(DATETIME, CONVERT(VARCHAR(11), dbo.uf_com_GetServerDate()))

	BEGIN TRY
		
		SET NOCOUNT ON;
		-- Declare variables
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''

		-- From and To users should not be same while defining delegation
		IF (@inp_iDelegationId = 0 AND @inp_iUserInfoIdFrom = @inp_iUserInfoIdTo)
		BEGIN
			SET @out_nReturnValue = @ERR_FROMTOUSERSSHOULDNOTBESAME
			RETURN (@out_nReturnValue)		
		END
		
		-- #1 Chek that input from date is not less than today for new record
		-- For existing record, if input from date is less than today, then it should be same as the date already set in the database
		IF (@inp_dtDelegationFrom < @dtToday
			AND (@inp_iDelegationId = 0 OR
				NOT EXISTS (SELECT DelegationId FROM usr_DelegationMaster 
							WHERE DelegationId = @inp_iDelegationId AND DelegationFrom = @inp_dtDelegationFrom)))
		BEGIN		
			SET @out_nReturnValue = @ERR_FROMDATELESSTHANTODAY
			RETURN (@out_nReturnValue)
		END
		
		-- Chek that input from date is greater than input to date
		IF @inp_dtDelegationFrom > @inp_dtDelegationTo
		BEGIN		
			SET @out_nReturnValue = @ERR_TODATENOTGREATERTHANFROMDATE
			RETURN (@out_nReturnValue)
		END

		-- Check that the To date is greater or equal to today
		IF (@inp_dtDelegationTo < @dtToday)
		BEGIN		
			SET @out_nReturnValue = @ERR_TODATENOTGREATERTHANTODAY
			RETURN (@out_nReturnValue)
		END

		/********** (2) System should not allow delegations from a user to same user for overlapping/same period **********/
		IF EXISTS (SELECT DelegationId FROM usr_DelegationMaster
					WHERE (	(@inp_dtDelegationFrom >= DelegationFrom AND @inp_dtDelegationFrom <= DelegationTo)
							OR (@inp_dtDelegationTo >= DelegationFrom AND @inp_dtDelegationTo <= DelegationTo)
							OR (DelegationFrom >= @inp_dtDelegationFrom AND DelegationFrom <= @inp_dtDelegationTo)
							OR (DelegationTo >= @inp_dtDelegationFrom AND DelegationTo <= @inp_dtDelegationTo)
							)
						AND DelegationId <> @inp_iDelegationId
						AND UserInfoIdFrom = @inp_iUserInfoIdFrom AND UserInfoIdTo = @inp_iUserInfoIdTo)
		BEGIN
			SET @out_nReturnValue = @ERR_DELEGATIONSFORSAMEPERIODEXISTS
			RETURN @out_nReturnValue
		END
		
		/********** (3) There should not be cyclic delegations defined. **********/
		-- (3a) Delegation is not defined by the delegated user for the same/overlapping period
		IF EXISTS(SELECT * FROM usr_DelegationMaster
					WHERE UserInfoIdFrom = @inp_iUserInfoIdTo
						AND ((@inp_dtDelegationFrom >= DelegationFrom AND @inp_dtDelegationFrom <= DelegationTo)
							OR (@inp_dtDelegationTo >= DelegationFrom AND @inp_dtDelegationTo <= DelegationTo)
							OR (DelegationFrom >= @inp_dtDelegationFrom AND DelegationFrom <= @inp_dtDelegationTo)
							OR (DelegationTo >= @inp_dtDelegationFrom AND DelegationTo <= @inp_dtDelegationTo)
							))
		BEGIN
			SET @out_nReturnValue = @ERR_DELEGATIONBYDELEGATEDUSEREXISTS
			RETURN @out_nReturnValue			
		END

		-- (3b) Delegation is not defined from someone to the delegating user for the same/overlapping period.
		IF EXISTS(SELECT * FROM usr_DelegationMaster
					WHERE UserInfoIdTo = @inp_iUserInfoIdFrom
						AND ((@inp_dtDelegationFrom >= DelegationFrom AND @inp_dtDelegationFrom <= DelegationTo)
							OR (@inp_dtDelegationTo >= DelegationFrom AND @inp_dtDelegationTo <= DelegationTo)
							OR (DelegationFrom >= @inp_dtDelegationFrom AND DelegationFrom <= @inp_dtDelegationTo)
							OR (DelegationTo >= @inp_dtDelegationFrom AND DelegationTo <= @inp_dtDelegationTo)
							))
		BEGIN
			SET @out_nReturnValue = @ERR_DELEGATIONTODELEGATINGUSEREXISTS
			RETURN @out_nReturnValue			
		END
		IF @inp_nPartialSave = 1
		BEGIN
			IF @inp_iDelegationId = 0
			BEGIN		
				/********** Insert new record. **********/
				INSERT INTO usr_DelegationMaster
					(DelegationFrom, DelegationTo, UserInfoIdFrom, UserInfoIdTo, 
					CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
				VALUES
					(@inp_dtDelegationFrom, @inp_dtDelegationTo, @inp_iUserInfoIdFrom, @inp_iUserInfoIdTo,
					@inp_iLoggedInUserId, dbo.uf_com_GetServerDate(), @inp_iLoggedInUserId, dbo.uf_com_GetServerDate())			
				
				SET @inp_iDelegationId = SCOPE_IDENTITY()
			END
			ELSE
			BEGIN
				--Check if the DelegationId being updated exists
				IF (NOT EXISTS(SELECT DelegationId FROM usr_DelegationMaster WHERE DelegationId = @inp_iDelegationId))
				BEGIN		
					SET @out_nReturnValue = @ERR_DELEGATION_NOTFOUND
					RETURN (@out_nReturnValue)
				END
				
				-- Update existing details, ToDate is allowed to change, 
				UPDATE usr_DelegationMaster
				SET DelegationFrom = CONVERT(DATETIME, CONVERT(VARCHAR(11), @inp_dtDelegationFrom)),
					DelegationTo = CONVERT(DATETIME, CONVERT(VARCHAR(11), @inp_dtDelegationTo)),
					ModifiedBy = @inp_iLoggedInUserId,
					ModifiedOn = dbo.uf_com_GetServerDate()
				WHERE DelegationId = @inp_iDelegationId
			END
		
			SELECT DelegationId, DelegationFrom, DelegationTo, UserInfoIdFrom, UserInfoIdTo
			FROM usr_DelegationMaster
			WHERE DelegationId = @inp_iDelegationId
		END
		ELSE
		BEGIN
			SELECT @inp_iDelegationId as DelegationId, @inp_iUserInfoIdFrom as UserInfoIdFrom, @inp_iUserInfoIdTo as UserInfoIdTo, @inp_dtDelegationFrom as DelegationFrom, @inp_dtDelegationTo as DelegationTo
		END
		
		RETURN 0
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue	=  @ERR_DELEGATION_SAVE
	END CATCH
END
