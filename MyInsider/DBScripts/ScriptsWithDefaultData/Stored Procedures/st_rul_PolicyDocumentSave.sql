IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_rul_PolicyDocumentSave')
DROP PROCEDURE [dbo].[st_rul_PolicyDocumentSave]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*-------------------------------------------------------------------------------------------------
Description:	Saves the Policy Document details

Returns:		0, if Success.
				
Created by:		Ashashree
Created on:		26-Mar-2015
Modification History:
Modified By		Modified On		Description
Tushar			09-Sep-2016		Add Validation for View And View Agree flag at least select one checkbox.
Raghvendra		07-Sep-2016		Changed the GETDATE() call with function dbo.uf_com_GetServerDate(). This function will return the date to be used as server date.

Usage:
DECLARE @RC int
EXEC st_rul_PolicyDocumentSave ,1
-------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[st_rul_PolicyDocumentSave] 
	@inp_iPolicyDocumentId	INT,
	@inp_sPolicyDocumentName	NVARCHAR(200),
	@inp_iDocumentCategoryCodeId	INT,
	@inp_iDocumentSubCategoryCodeId	INT,
	@inp_dtApplicableFrom	DATETIME,
	@inp_dtApplicableTo	DATETIME,
	@inp_iCompanyId	INT,
	@inp_sDisplayInPolicyDocumentFlag	BIT,
	@inp_sSendEmailUpdateFlag	BIT,
	@inp_bDocumentViewFlag	BIT,
	@inp_bDocumentViewAgreeFlag	BIT,
	@inp_iWindowStatusCodeId	INT,

	@inp_nUserId INT,									-- Id of the user inserting/updating the Policy Document
	@out_nReturnValue		INT = 0 OUTPUT,
	@out_nSQLErrCode		INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage		NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
AS
BEGIN

	DECLARE @ERR_POLICYDOCUMENT_SAVE INT
	DECLARE @ERR_POLICYDOCUMENT_NOTFOUND INT
	DECLARE @ERR_POLICYDOCUMENT_INVALIDDATES INT
	DECLARE @ERR_POLICYDOCUMENT_OVERLAPPING_POLICY_EXISTS INT
	DECLARE @ERR_POLICYDOCUMENT_SUBCATEGORY_MANDATORY INT
	DECLARE @ERR_POLICYDOCUMENT_NAME_MANDATORY	INT
	DECLARE @ERR_POLICYDOCUMENT_CATEGORY_MANDATORY	INT
	DECLARE @ERR_POLICYDOCUMENT_APPLICABLE_DATES_MANDATORY	INT
	DECLARE @ERR_POLICYDOCUMENT_COMPANY_MANDATORY	INT
	DECLARE @ERR_POLICYDOCUMENT_INVALID_STATUS INT
	DECLARE @ERR_SELECTATLEASTONEVIEWANDVIEWAGREE INT
	
	DECLARE	@nOverlappingPolicyExists	INT
	DECLARE @nPolicyDocumentIncomplete	INT
	DECLARE @nPolicyDocumentActive		INT
	DECLARE	@nPolicyDocumentInactive	INT
	DECLARE @nSubCategoryCount	INT
	DECLARE @dtCurrentDate	DATETIME
	DECLARE	@dtAppFromDate	DATETIME
	DECLARE	@dtAppToDate	DATETIME
	DECLARE @nExistingWindowStatusCodeId INT
	DECLARE @nPolicyDocumentAggreedEventCodeId INT
	DECLARE	@nPolicyDocumentViewedEventCodeId INT
	
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
		SELECT	@ERR_POLICYDOCUMENT_SAVE = 15041, --Error occurred while saving policy document details.
				@ERR_POLICYDOCUMENT_NOTFOUND = 15043, --Policy document does not exist.
				@ERR_POLICYDOCUMENT_INVALIDDATES = 15044, --ApplicableFrom date should be <= ApplicableTo date
				@ERR_POLICYDOCUMENT_OVERLAPPING_POLICY_EXISTS = 15045,
				@ERR_POLICYDOCUMENT_SUBCATEGORY_MANDATORY = 15062, --If Category has sub-category associated in com_Code then policy document should also have sub-category specified
				@ERR_POLICYDOCUMENT_NAME_MANDATORY = 15063,
				@ERR_POLICYDOCUMENT_CATEGORY_MANDATORY = 15064,
				@ERR_POLICYDOCUMENT_APPLICABLE_DATES_MANDATORY = 15065,
				@ERR_POLICYDOCUMENT_COMPANY_MANDATORY = 15066,
				@ERR_POLICYDOCUMENT_INVALID_STATUS = 15067,
				@ERR_SELECTATLEASTONEVIEWANDVIEWAGREE = 15459,
				
				@nPolicyDocumentIncomplete = 131001,
				@nPolicyDocumentActive = 131002,
				@nPolicyDocumentInactive = 131003,
				@nPolicyDocumentViewedEventCodeId=153027,
				@nPolicyDocumentAggreedEventCodeId=153028
		/*-------Start: VALIDATIONS to be done before saving the Policy Document-------*/
		--Validate : Policy Document Name is mandatory
		IF(@inp_sPolicyDocumentName IS NULL OR @inp_sPolicyDocumentName = '')
		BEGIN
			SET @out_nReturnValue = @ERR_POLICYDOCUMENT_NAME_MANDATORY
			RETURN (@out_nReturnValue)
		END
		
		--Validate : Policy category is mandatory
		IF(@inp_iDocumentCategoryCodeId IS NULL OR @inp_iDocumentCategoryCodeId <= 0)
		BEGIN
			SET @out_nReturnValue = @ERR_POLICYDOCUMENT_CATEGORY_MANDATORY
			RETURN (@out_nReturnValue)
		END
		
		IF(@inp_bDocumentViewFlag = 0 AND @inp_bDocumentViewAgreeFlag = 0)
		BEGIN
			SET @out_nReturnValue = @ERR_SELECTATLEASTONEVIEWANDVIEWAGREE
			RETURN (@out_nReturnValue)
		END
		
		/*Validate : If selected category has a sub-category associated in the master - com_code then, sub-category should also get associated for the policy document*/
		SET @nSubCategoryCount = 0
		SELECT @nSubCategoryCount = COUNT(CodeID) FROM com_Code WHERE ParentCodeId = @inp_iDocumentCategoryCodeId
		IF(@nSubCategoryCount > 0 AND (@inp_iDocumentSubCategoryCodeId IS NULL OR @inp_iDocumentSubCategoryCodeId <= 0) )
		BEGIN 
			SET @out_nReturnValue = @ERR_POLICYDOCUMENT_SUBCATEGORY_MANDATORY
			RETURN (@out_nReturnValue)
		END
		
		--Validate : Policy From-To dates are mandatory
		IF(@inp_dtApplicableFrom IS NULL OR @inp_dtApplicableTo IS NULL)
		BEGIN
			SET @out_nReturnValue = @ERR_POLICYDOCUMENT_APPLICABLE_DATES_MANDATORY
			RETURN (@out_nReturnValue)
		END
		--Validate : Applicable To date should be greater/equal applicable from date
		IF(@inp_dtApplicableTo IS NOT NULL AND (@inp_dtApplicableFrom > @inp_dtApplicableTo) )
		BEGIN
			SET @out_nReturnValue = @ERR_POLICYDOCUMENT_INVALIDDATES
			RETURN (@out_nReturnValue)
		END
		
		--Validate : Policy company is mandatory
		IF(@inp_iCompanyId IS NULL OR @inp_iCompanyId <= 0)
		BEGIN
			SET @out_nReturnValue = @ERR_POLICYDOCUMENT_COMPANY_MANDATORY
			RETURN (@out_nReturnValue)
		END
		
		--SET Default values for flags if they are NULL
		IF(@inp_sDisplayInPolicyDocumentFlag IS NULL)
			SET @inp_sDisplayInPolicyDocumentFlag = 0
		IF(@inp_sSendEmailUpdateFlag IS NULL)
			SET @inp_sSendEmailUpdateFlag = 0
		IF(@inp_bDocumentViewFlag IS NULL)
			SET @inp_bDocumentViewFlag = 0
		IF(@inp_bDocumentViewAgreeFlag IS NULL)
			SET @inp_bDocumentViewAgreeFlag = 0
		
		--TODO : No 2 documents of same category and sub-category should overlap during the same applicable date range.
		
		/*-------End: VALIDATIONS to be done before saving the Policy Document-------*/
		--Save the PolicyDocument details
		IF @inp_iPolicyDocumentId = 0
		BEGIN
			SET @inp_iWindowStatusCodeId = @nPolicyDocumentIncomplete
			Insert into rul_PolicyDocument(
					PolicyDocumentName,
					DocumentCategoryCodeId,
					DocumentSubCategoryCodeId,
					ApplicableFrom,
					ApplicableTo,
					CompanyId,
					DisplayInPolicyDocumentFlag,
					SendEmailUpdateFlag,
					DocumentViewFlag,
					DocumentViewAgreeFlag,
					WindowStatusCodeId,
					CreatedBy, CreatedOn, ModifiedBy, ModifiedOn )
			Values (
					@inp_sPolicyDocumentName,
					@inp_iDocumentCategoryCodeId,
					@inp_iDocumentSubCategoryCodeId,
					@inp_dtApplicableFrom,
					@inp_dtApplicableTo,
					@inp_iCompanyId,
					@inp_sDisplayInPolicyDocumentFlag,
					@inp_sSendEmailUpdateFlag,
					@inp_bDocumentViewFlag,
					@inp_bDocumentViewAgreeFlag,
					@inp_iWindowStatusCodeId,
					@inp_nUserId, dbo.uf_com_GetServerDate(), @inp_nUserId, dbo.uf_com_GetServerDate() )
			
			SET @inp_iPolicyDocumentId = SCOPE_IDENTITY()
			
		END
		ELSE
		BEGIN
			--Check if the PolicyDocument whose details are being updated exists
			IF (NOT EXISTS(SELECT PolicyDocumentId FROM rul_PolicyDocument WHERE PolicyDocumentId = @inp_iPolicyDocumentId))			
			BEGIN	
				SET @out_nReturnValue = @ERR_POLICYDOCUMENT_NOTFOUND
				RETURN (@out_nReturnValue)
			END	
			
			--Fetch the current date of database server 
			SELECT @dtCurrentDate = dbo.uf_com_GetServerDate()
			SELECT @dtCurrentDate = CAST( CAST(@dtCurrentDate AS VARCHAR(11)) AS DATETIME ) --get only the date part and not the timestamp part
			print @dtCurrentDate
			
			--Fetch applicable dates of policy to compare the dates with current date and update details conditionally
			SELECT @dtAppFromDate = ApplicableFrom, @dtAppToDate = ApplicableTo, @nExistingWindowStatusCodeId = WindowStatusCodeId
			FROM rul_PolicyDocument
			WHERE PolicyDocumentId = @inp_iPolicyDocumentId
			
			--If (existing windowStatus is Incomplete) OR (current date < applicable-from-date) then allow update for everything
			IF( (@nExistingWindowStatusCodeId = @nPolicyDocumentIncomplete))
			BEGIN
				UPDATE	rul_PolicyDocument
				SET		PolicyDocumentName = @inp_sPolicyDocumentName,
						DocumentCategoryCodeId = @inp_iDocumentCategoryCodeId,
						DocumentSubCategoryCodeId = @inp_iDocumentSubCategoryCodeId,
						ApplicableFrom = @inp_dtApplicableFrom,
						ApplicableTo = @inp_dtApplicableTo,
						CompanyId = @inp_iCompanyId,
						DisplayInPolicyDocumentFlag = @inp_sDisplayInPolicyDocumentFlag,
						SendEmailUpdateFlag = @inp_sSendEmailUpdateFlag,
						DocumentViewFlag = @inp_bDocumentViewFlag,
						DocumentViewAgreeFlag = @inp_bDocumentViewAgreeFlag,
						WindowStatusCodeId = @inp_iWindowStatusCodeId,
						ModifiedBy	= @inp_nUserId,
						ModifiedOn = dbo.uf_com_GetServerDate()
				WHERE	PolicyDocumentId = @inp_iPolicyDocumentId	
			END 
			ELSE --@nExistingWindowStatusCodeId = @nPolicyDocumentActive / @nPolicyDocumentInactive
			BEGIN
					IF(@dtCurrentDate < @dtAppFromDate AND @dtAppFromDate <= @dtAppToDate) 
					BEGIN
						UPDATE	rul_PolicyDocument
						SET		PolicyDocumentName = @inp_sPolicyDocumentName,
								DocumentCategoryCodeId = @inp_iDocumentCategoryCodeId,
								DocumentSubCategoryCodeId = @inp_iDocumentSubCategoryCodeId,
								ApplicableFrom = @inp_dtApplicableFrom,
								ApplicableTo = @inp_dtApplicableTo,
								CompanyId = @inp_iCompanyId,
								DisplayInPolicyDocumentFlag = @inp_sDisplayInPolicyDocumentFlag,
								SendEmailUpdateFlag = @inp_sSendEmailUpdateFlag,
								DocumentViewFlag = @inp_bDocumentViewFlag,
								DocumentViewAgreeFlag = @inp_bDocumentViewAgreeFlag,
								WindowStatusCodeId = @inp_iWindowStatusCodeId,
								ModifiedBy	= @inp_nUserId,
								ModifiedOn = dbo.uf_com_GetServerDate()
						WHERE	PolicyDocumentId = @inp_iPolicyDocumentId
					END
					--If current date between applicable-from-date and applicable-to-date then update only the applicable-to-date and status
					ELSE IF(@dtAppFromDate <= @dtCurrentDate AND @dtCurrentDate <= @dtAppToDate AND @dtAppFromDate <= @dtAppToDate)
					BEGIN
						--Validate : If current-date is between applicable-from-date and applicable-to-date then status cannot be changed from Active/Deactive --> Incomplete
						--Active cannot be changed to Inactive.
						IF(	(@nExistingWindowStatusCodeId = @nPolicyDocumentActive AND @inp_iWindowStatusCodeId = @nPolicyDocumentIncomplete) OR
							(@nExistingWindowStatusCodeId = @nPolicyDocumentActive AND @inp_iWindowStatusCodeId = @nPolicyDocumentInactive) OR
							(@nExistingWindowStatusCodeId = @nPolicyDocumentInactive AND @inp_iWindowStatusCodeId = @nPolicyDocumentIncomplete) )
						BEGIN
							--checking eventcode in eve_EventLog table for codes of policy document agreed and viewed.
							--if present then dont update policy status active=>deactive
							  IF EXISTS(SELECT eventlog.EventCodeId
									    FROM vw_ApplicablePolicyDocumentForUser vwApplicablePolicyDocumentUser
									   INNER JOIN usr_UserInfo ui
									   ON ui.UserInfoId=vwApplicablePolicyDocumentUser.UserInfoId	 
									   INNER JOIN eve_EventLog eventlog
									   ON eventlog.MapToId=vwApplicablePolicyDocumentUser.MapToId
									   WHERE vwApplicablePolicyDocumentUser.MapToId= @inp_iPolicyDocumentId 
									   AND ui.DateOfSeparation IS NULL
									   AND eventlog.EventCodeId IN(@nPolicyDocumentViewedEventCodeId,@nPolicyDocumentAggreedEventCodeId))
							 BEGIN
											SET @out_nReturnValue = @ERR_POLICYDOCUMENT_INVALID_STATUS
										    RETURN (@out_nReturnValue)
							 END
							 ELSE
								BEGIN
										UPDATE rul_PolicyDocument
										   SET	 WindowStatusCodeId = @inp_iWindowStatusCodeId,
												 ModifiedBy	= @inp_nUserId,
												 ModifiedOn = dbo.uf_com_GetServerDate()
									      WHERE  PolicyDocumentId = @inp_iPolicyDocumentId	
								END
						END
						UPDATE	rul_PolicyDocument
						SET		
								WindowStatusCodeId = @inp_iWindowStatusCodeId,
								ModifiedBy	= @inp_nUserId,
								ModifiedOn = dbo.uf_com_GetServerDate()
						WHERE	PolicyDocumentId = @inp_iPolicyDocumentId		
					END
					--If current date greater than applicable-to-date then only update status
					ELSE IF(@dtCurrentDate > @dtAppToDate AND @dtAppFromDate <= @dtAppToDate)
					BEGIN
						--Validate : If current-date is greater than applicable-from-date and applicable-to-date then status cannot be changed from Active/Deactive --> Incomplete
						--Inactive cannot be changed to Active.
						IF(	(@nExistingWindowStatusCodeId = @nPolicyDocumentActive AND @inp_iWindowStatusCodeId = @nPolicyDocumentIncomplete) OR
							(@nExistingWindowStatusCodeId = @nPolicyDocumentInactive AND @inp_iWindowStatusCodeId = @nPolicyDocumentIncomplete) OR
							(@nExistingWindowStatusCodeId = @nPolicyDocumentInactive AND @inp_iWindowStatusCodeId = @nPolicyDocumentActive) )
						BEGIN
							SET @out_nReturnValue = @ERR_POLICYDOCUMENT_INVALID_STATUS
							RETURN (@out_nReturnValue)
						END
						
						UPDATE	rul_PolicyDocument
						SET		WindowStatusCodeId = @inp_iWindowStatusCodeId,
								ModifiedBy	= @inp_nUserId,
								ModifiedOn = dbo.uf_com_GetServerDate()
						WHERE	PolicyDocumentId = @inp_iPolicyDocumentId		
					END --(@dtCurrentDate > @dtAppToDate AND @dtAppFromDate <= @dtAppToDate)
			END
		END
		
		-- in case required to return for partial save case.
		Select PolicyDocumentId, PolicyDocumentName, DocumentCategoryCodeId, DocumentSubCategoryCodeId, 
			   ApplicableFrom, ApplicableTo, CompanyId, DisplayInPolicyDocumentFlag, SendEmailUpdateFlag, 
			   DocumentViewFlag, DocumentViewAgreeFlag, WindowStatusCodeId
		From rul_PolicyDocument
		Where PolicyDocumentId = @inp_iPolicyDocumentId

		SET @out_nReturnValue = 0
		RETURN @out_nReturnValue
		
	END	 TRY
	
	BEGIN CATCH	
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()	
		
		-- Return common error if required, otherwise specific error.		
		SET @out_nReturnValue =  dbo.uf_com_GetErrorCode(@ERR_POLICYDOCUMENT_SAVE, ERROR_NUMBER())
		RETURN @out_nReturnValue
	END CATCH
END