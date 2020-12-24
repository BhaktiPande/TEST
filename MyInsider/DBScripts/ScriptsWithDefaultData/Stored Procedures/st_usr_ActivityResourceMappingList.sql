IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_usr_ActivityResourceMappingList')
DROP PROCEDURE [dbo].[st_usr_ActivityResourceMappingList]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Get the Activity resource mapping for the activities applicable to logged in user

Returns:		0, if Success.
				
Created by:		Arundhati
Created on:		16-Mar-2015

Modification History:
Modified By		Modified On		Description
Arundhati		18-Mar-2015		Activity Id is removed from output
Arundhati		23-Mar-2015		IsRelative flag is added in the output.
Arundhati		26-May-2015		Added activity ids for CIN/DIN
Arundhati		03-Nov-2015		Changes made to show only one activity for Grade and GradeText, for Designation and DesignationText
Parag			23-Mar-2016		Made change to fetch activies those are Mandatory but not editable  
Novit			30-July-2018	Added ActivityID for Seperation of Employee Name and Employee Relative Name in Edit Permissions for Insider and 
								Mandatory Fields for Insider Screen.

Usage:
EXEC st_usr_ActivityResourceMappingList null
-------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[st_usr_ActivityResourceMappingList]
	@inp_iUserInfoID		INT,						-- Id of the Role whose details are to be fetched.
	@out_nReturnValue		INT = 0 OUTPUT,
	@out_nSQLErrCode		INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage		NVARCHAR(500) = '' OUTPUT	-- Output SQL Error Message, if error occurred.
	
AS
BEGIN
	DECLARE @ERR_ACTIVITYRESOURCEMAPPING_LIST INT = -1
	--DECLARE @ERR_ROLE_NOTFOUND INT
	--DECLARE @ACTIVITY_STATUS_ACTIVE INT
	DECLARE @tmpResourceEditMandatory TABLE(IsForRelative INT DEFAULT 0, ResourceKey VARCHAR(15), ActivityIdE INT, ActivityIdM INT, ColumnName VARCHAR(100))
	--DECLARE @inp_iForRelative INT = 0
	DECLARE @tmpMapTable TABLE(ActivityIdDropdown INT, ActivityIdText INT)
	DECLARE @nUserTypeCodeId INT
	DECLARE @nUserType_Admin INT = 101001
	DECLARE @nUserType_CO INT = 101002

	BEGIN TRY
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;
		
		INSERT INTO @tmpMapTable VALUES(57, 143), (75, 149)
		
		SELECT @nUserTypeCodeId = UserTypeCodeId FROM usr_UserInfo WHERE UserInfoId = @inp_iUserInfoID
		
		--Initialize variables
		INSERT INTO @tmpResourceEditMandatory(ResourceKey, ActivityIdE, ColumnName)
		SELECT ResourceKey , RA.ActivityID, ARM.ColumnName
		FROM 
		usr_UserRole UR 
			JOIN usr_RoleActivity RA ON UR.RoleID = RA.RoleID
			JOIN usr_ActivityResourceMapping ARM ON RA.ActivityID = ARM.ActivityId
		WHERE (RA.ActivityID BETWEEN 45 AND 62 OR RA.ActivityID = 133 OR RA.ActivityID BETWEEN 85 AND 89 OR RA.ActivityID BETWEEN 141 AND 146 OR RA.ActivityID BETWEEN 161 AND 162 OR RA.ActivityID BETWEEN 231 AND 232 OR RA.ActivityID BETWEEN 260 AND 269 OR RA.ActivityID BETWEEN 272 AND 274  OR RA.ActivityID BETWEEN 278 AND 279 OR RA.ActivityID BETWEEN 280 AND 290 OR RA.ActivityID BETWEEN 302 AND 308 OR RA.ActivityID BETWEEN 316 AND 320 OR RA.ActivityID in(342))
			AND UserInfoID = @inp_iUserInfoID

		INSERT INTO @tmpResourceEditMandatory(IsForRelative, ResourceKey, ActivityIdE, ColumnName)
		SELECT 1, ResourceKey , RA.ActivityID, ARM.ColumnName
		FROM 
		usr_UserRole UR 
			JOIN usr_RoleActivity RA ON UR.RoleID = RA.RoleID
			JOIN usr_ActivityResourceMapping ARM ON RA.ActivityID = ARM.ActivityId
		WHERE RA.ActivityID BETWEEN 90 AND 100
			AND UserInfoID = @inp_iUserInfoID
		UNION 
		SELECT 1, ResourceKey , RA.ActivityID, ARM.ColumnName
		FROM 
		    usr_UserRole UR 
		    JOIN usr_RoleActivity RA ON UR.RoleID = RA.RoleID
			JOIN usr_ActivityResourceMapping ARM ON RA.ActivityID = ARM.ActivityId
		WHERE 
		 UserInfoID = @inp_iUserInfoID and RA.ActivityID BETWEEN 233 AND 234
		
		INSERT INTO @tmpResourceEditMandatory(IsForRelative, ResourceKey, ActivityIdM, ColumnName)
		SELECT 0, ARM.ResourceKey , RA.ActivityID, ARM.ColumnName
		FROM usr_UserRole UR 
			JOIN usr_RoleActivity RA ON UR.RoleID = RA.RoleID
			JOIN usr_ActivityResourceMapping ARM ON RA.ActivityID = ARM.ActivityId
			LEFT JOIN @tmpResourceEditMandatory EM ON ARM.ResourceKey = EM.ResourceKey AND ARM.ColumnName = EM.ColumnName AND 0 = EM.IsForRelative
		WHERE 	UserInfoID = @inp_iUserInfoID
			AND (RA.ActivityID BETWEEN 235 AND 236 OR RA.ActivityID BETWEEN 63 AND 80 OR RA.ActivityID BETWEEN 101 AND 105 OR RA.ActivityID BETWEEN 147 AND 152 OR RA.ActivityID BETWEEN 163 AND 164 OR RA.ActivityID BETWEEN 250 AND 259 OR RA.ActivityID BETWEEN 270 AND 271 OR RA.ActivityID BETWEEN 275 AND 277 OR RA.ActivityID BETWEEN 291 AND 301 OR RA.ActivityID BETWEEN 309 AND 315 OR RA.ActivityID BETWEEN 321 AND 325 )
			AND EM.ResourceKey IS NULL
		
		INSERT INTO @tmpResourceEditMandatory(IsForRelative, ResourceKey, ActivityIdM, ColumnName)
		SELECT 1, ARM.ResourceKey , RA.ActivityID, ARM.ColumnName
		FROM usr_UserRole UR 
			JOIN usr_RoleActivity RA ON UR.RoleID = RA.RoleID
			JOIN usr_ActivityResourceMapping ARM ON RA.ActivityID = ARM.ActivityId
			LEFT JOIN @tmpResourceEditMandatory EM ON ARM.ResourceKey = EM.ResourceKey AND ARM.ColumnName = EM.ColumnName AND 1 = EM.IsForRelative
		WHERE 	UserInfoID = @inp_iUserInfoID
			AND (RA.ActivityID BETWEEN 106 AND 116)
			AND EM.ResourceKey IS NULL
		UNION 
		SELECT 1, ARM.ResourceKey , RA.ActivityID, ARM.ColumnName
		FROM usr_UserRole UR 
			JOIN usr_RoleActivity RA ON UR.RoleID = RA.RoleID
			JOIN usr_ActivityResourceMapping ARM ON RA.ActivityID = ARM.ActivityId
			LEFT JOIN @tmpResourceEditMandatory EM ON ARM.ResourceKey = EM.ResourceKey AND ARM.ColumnName = EM.ColumnName AND 1 = EM.IsForRelative
		WHERE 	UserInfoID = @inp_iUserInfoID
			AND (RA.ActivityID BETWEEN 237 AND 238)
			AND EM.ResourceKey IS NULL
		
		UPDATE EM
		SET ActivityIdM = RA.ActivityID
		FROM usr_UserRole UR 
			JOIN usr_RoleActivity RA ON UR.RoleID = RA.RoleID
			JOIN usr_ActivityResourceMapping ARM ON RA.ActivityID = ARM.ActivityId
			JOIN @tmpResourceEditMandatory EM ON ARM.ResourceKey = EM.ResourceKey AND ARM.ColumnName = EM.ColumnName
		WHERE UserInfoID = @inp_iUserInfoID
			AND IsForRelative = 0 AND (RA.ActivityID BETWEEN 235 AND 236 OR RA.ActivityID BETWEEN 63 AND 80 OR RA.ActivityID BETWEEN 101 AND 105 OR RA.ActivityID BETWEEN 147 AND 152 OR RA.ActivityID BETWEEN 163 AND 164 OR RA.ActivityID BETWEEN 250 AND 259 OR RA.ActivityID BETWEEN 270 AND 271 OR RA.ActivityID BETWEEN 275 AND 277 OR RA.ActivityID BETWEEN 291 AND 301 OR RA.ActivityID BETWEEN 309 AND 315 OR RA.ActivityID BETWEEN 321 AND 325 OR RA.ActivityID in (343) )
		
		UPDATE EM
		SET ActivityIdM = RA.ActivityID
		FROM usr_UserRole UR 
			JOIN usr_RoleActivity RA ON UR.RoleID = RA.RoleID
			JOIN usr_ActivityResourceMapping ARM ON RA.ActivityID = ARM.ActivityId
			JOIN @tmpResourceEditMandatory EM ON ARM.ResourceKey = EM.ResourceKey AND ARM.ColumnName = EM.ColumnName
		WHERE UserInfoID = @inp_iUserInfoID
			AND IsForRelative = 1 AND (RA.ActivityID BETWEEN 106 AND 116 OR RA.ActivityID BETWEEN 237 AND 238)
		
		IF @nUserTypeCodeId IN (@nUserType_Admin, @nUserType_CO)
		BEGIN
			print '1'
			--INSERT INTO @tmpResourceEditMandatory(ActivityIdE, ActivityIdM, ColumnName, IsForRelative, ResourceKey)
			--SELECT ARM.ActivityId, ARMMand.ActivityId, ARM.ColumnName, IsForRelative, ARM.ResourceKey
			--FROM @tmpResourceEditMandatory tmpREM JOIN @tmpMapTable tmpMT ON tmpREM.ActivityIdE = tmpMT.ActivityIdDropdown
			--	JOIN usr_ActivityResourceMapping ARM ON tmpMT.ActivityIdText = ARM.ActivityId
			--	LEFT JOIN @tmpMapTable tmpMTMand ON tmpREM.ActivityIdM = tmpMTMand.ActivityIdDropdown
			--	LEFT JOIN usr_ActivityResourceMapping ARMMand ON tmpMTMand.ActivityIdText = ARMMand.ActivityId

			--INSERT INTO @tmpResourceEditMandatory(ActivityIdE, ActivityIdM, ColumnName, IsForRelative, ResourceKey)
			--SELECT NULL, ARMMand.ActivityId, ARMMand.ColumnName, IsForRelative, ARMMand.ResourceKey
			--FROM @tmpResourceEditMandatory tmpREM JOIN @tmpMapTable tmpMTMand ON tmpREM.ActivityIdM = tmpMTMand.ActivityIdDropdown
			--	JOIN usr_ActivityResourceMapping ARMMand ON tmpMTMand.ActivityIdText = ARMMand.ActivityId
			--WHERE tmpREM.ActivityIdE IS NULL

		END
		
		--IF @nUserTypeCodeId = 101006
		--BEGIN
		--	UPDATE @tmpResourceEditMandatory SET ColumnName = 'GradeId' WHERE ColumnName = 'GradeName'
		--	UPDATE @tmpResourceEditMandatory SET ColumnName = 'Category' WHERE ColumnName = 'CategoryName'
		--	UPDATE @tmpResourceEditMandatory SET ColumnName = 'SubCategory' WHERE ColumnName = 'SubCategoryName'
		--	UPDATE @tmpResourceEditMandatory SET ColumnName = 'DesignationId' WHERE ColumnName = 'DesignationName'
		--	UPDATE @tmpResourceEditMandatory SET ColumnName = 'SubDesignationId' WHERE ColumnName = 'SubDesignationName'
		--	UPDATE @tmpResourceEditMandatory SET ColumnName = 'DepartmentId' WHERE ColumnName = 'DepartmentName'
		--END
		
		SELECT Act.ResourceKey,
			CASE WHEN Act.ActivityIdE IS NULL THEN 0 ELSE 1 END EditFlag,
			CASE WHEN Act.ActivityIdM IS NULL THEN 0 ELSE 1 END MandatoryFlag,
			Act.ColumnName,
			IsForRelative,
			ActivityIdE,
			ActivityIdM
		FROM @tmpResourceEditMandatory Act 
		--WHERE IsForRelative = 0
		
		--SELECT Act.ResourceKey,
		--	CASE WHEN Act.ActivityIdE IS NULL THEN 0 ELSE 1 END EditFlag,
		--	CASE WHEN Act.ActivityIdM IS NULL THEN 0 ELSE 1 END MandatoryFlag,
		--	Act.ColumnName,
		--	IsForRelative
		--FROM @tmpResourceEditMandatory Act
		--WHERE IsForRelative = 1

		SET @out_nReturnValue = 0
		RETURN @out_nReturnValue
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()
		
		-- Return common error if required, otherwise specific error.		
		SET @out_nReturnValue  = dbo.uf_com_GetErrorCode(@ERR_ACTIVITYRESOURCEMAPPING_LIST, ERROR_NUMBER())
		RETURN @out_nReturnValue		
	END CATCH
END

