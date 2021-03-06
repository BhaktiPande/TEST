
GO
/****** Object:  StoredProcedure [dbo].[st_rul_DefineApplicability_OS]    Script Date: 08/25/2020 12:44 PM ******/
SET ANSI_NULLS ON
IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_rul_DefineApplicability_OS')
DROP PROCEDURE [dbo].[st_rul_DefineApplicability_OS]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	

Returns:		0, if Success.
				
Created by:		Rajashri
Created on:		05-Aug-2020
-------------------------------------------------------------------------------------------------*/
create PROCEDURE [dbo].[st_rul_DefineApplicability_OS]
	@inp_iTradingPolicyId		INT,
	@inp_nUserId				INT,   
	@out_nReturnValue					INT = 0 OUTPUT,
	@out_nSQLErrCode					INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage					NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
AS
BEGIN

	
	DECLARE @ERR_INPRECLERANCEREQUEST INT = 11025 -- Error occuerd while Preclerance Request the Name		
	DECLARE @nRetValue INT	
	DECLARE @nMapToTypeCodeId									INT = 132022	--MapToTypeCodeId indicating type is of Trading Policy Other Security
	DECLARE @nPrevTradingPolicyId								INT			
	DECLARE @nMaxAppVersionNumber								INT = 0			--Store the applicability's maximum version number
	DECLARE @nExistingApplicabilityMstId						INT = 0			--Store the applicability-master-id for applicability with maximum version number belonging to maptotype = 132002 and maptoId = TradingPolicyId-being-marked-history
	DECLARE @nNewApplicabilityMstId								INT
	
	BEGIN TRY
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;

		--Initialize variables
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''

			/*--------------- Start : Applicability change done on 16-Apr-2015---------------------------
				If one or more applicability records found for trading policy record being marked as History then, 
				copy the applicability records (master-details) from the record marked as History to the newly added Curent record 
				for maximum applicability version number*/
				DECLARE @RootTradingPolicyID int 
				SELECT @RootTradingPolicyID=TradingPolicyParentId FROM rul_TradingPolicy_OS WHERE TradingPolicyId=@inp_iTradingPolicyId group by TradingPolicyParentId
				
				
				SELECT @nPrevTradingPolicyId=MAX(TradingPolicyId)  
					from (
						SELECT TradingPolicyParentId, TradingPolicyId 
						FROM rul_TradingPolicy_OS   group by TradingPolicyParentId,TradingPolicyId
					)tp where TradingPolicyParentId=@RootTradingPolicyID and TradingPolicyId !=@inp_iTradingPolicyId

					IF(@nPrevTradingPolicyId IS NULL OR @nPrevTradingPolicyId='' OR @nPrevTradingPolicyId=0)
					BEGIN
						SET @nPrevTradingPolicyId=@RootTradingPolicyID
					END


				IF(EXISTS(SELECT ApplicabilityId FROM rul_ApplicabilityMaster_OS WHERE MapToTypeCodeId = @nMapToTypeCodeId AND MapToId = @nPrevTradingPolicyId))
				BEGIN	
					print 'Applicability is mapped'
					SELECT @nMaxAppVersionNumber = MAX(VersionNumber) FROM rul_ApplicabilityMaster_OS WHERE MapToTypeCodeId = @nMapToTypeCodeId AND MapToId = @nPrevTradingPolicyId
					SELECT @nExistingApplicabilityMstId = ApplicabilityId FROM rul_ApplicabilityMaster_OS WHERE MapToTypeCodeId = @nMapToTypeCodeId AND MapToId = @nPrevTradingPolicyId AND VersionNumber = @nMaxAppVersionNumber 
					--Copy applicability for newly added trading policy record by inserting the records from previous trading policy record
					INSERT INTO rul_ApplicabilityMaster_OS(MapToTypeCodeId, MapToId, VersionNumber, CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
					VALUES(@nMapToTypeCodeId, @inp_iTradingPolicyId, @nMaxAppVersionNumber, @inp_nUserId, dbo.uf_com_GetServerDate(), @inp_nUserId, dbo.uf_com_GetServerDate())
					
					SELECT @nNewApplicabilityMstId = SCOPE_IDENTITY() --Get ApplicabilityMstID for newly added applicability-master record
					
					--Copy the applicability details records by doing a bulk insert-select-from
					INSERT	INTO rul_ApplicabilityDetails_Os(ApplicabilityMstId, AllEmployeeFlag, AllInsiderFlag, AllEmployeeInsiderFlag, 
								InsiderTypeCodeId, DepartmentCodeId, GradeCodeId, DesignationCodeId, UserId, IncludeExcludeCodeId, 
								CreatedBy, CreatedOn, ModifiedBy, ModifiedOn,
								RoleId,Category,SubCategory,AllCo,AllCorporateEmployees,AllNonEmployee,NonInsFltrDepartmentCodeId,NonInsFltrGradeCodeId,
								NonInsFltrDesignationCodeId,NonInsFltrRoleId,NonInsFltrCategory,NonInsFltrSubCategory)
							SELECT  @nNewApplicabilityMstId, AD.AllEmployeeFlag, AD.AllInsiderFlag, AD.AllEmployeeInsiderFlag,
									AD.InsiderTypeCodeId, AD.DepartmentCodeId, AD.GradeCodeId, Ad.DesignationCodeId,
									AD.UserId, AD.IncludeExcludeCodeId, 
									@inp_nUserId, dbo.uf_com_GetServerDate(), @inp_nUserId, dbo.uf_com_GetServerDate(),
									AD.RoleId,AD.Category,AD.SubCategory,AD.AllCo,AD.AllCorporateEmployees,AD.AllNonEmployee,AD.NonInsFltrDepartmentCodeId,AD.NonInsFltrGradeCodeId,
									AD.NonInsFltrDesignationCodeId,AD.NonInsFltrRoleId,AD.NonInsFltrCategory,AD.NonInsFltrSubCategory
							FROM    rul_ApplicabilityDetails_Os AD
							WHERE   AD.ApplicabilityMstId = @nExistingApplicabilityMstId
				END	--Applicability exists for trading policy which is being-marked-history
				/*--------------- End : Applicability change done on 16-Apr-2015---------------------------*/	
				RETURN @out_nReturnValue	
	END	 TRY	
	BEGIN CATCH	
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()	
		
		-- Return common error if required, otherwise specific error.		
		SET @out_nReturnValue =  dbo.uf_com_GetErrorCode(@ERR_INPRECLERANCEREQUEST, ERROR_NUMBER())
		RETURN @out_nReturnValue
	END CATCH
END