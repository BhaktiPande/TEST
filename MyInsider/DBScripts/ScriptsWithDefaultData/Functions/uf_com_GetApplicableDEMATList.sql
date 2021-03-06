IF EXISTS (SELECT * FROM SYS.all_objects WHERE NAME = 'uf_com_GetApplicableDEMATList' AND Type = 'TF')
	DROP FUNCTION dbo.uf_com_GetApplicableDEMATList
GO
/*-------------------------------------------------------------------------------------------------
Description:	This function will return a table of the DEMAT account details which are applicable 
				for the given user as per the allowed DP configurations done at the Company Master.

Returns:		0, if Success.
				
Created by:		Parag
Created on:		06-Sept-2016

Modification History:
Modified By		Modified On	Description

Usage:

-------------------------------------------------------------------------------------------------*/
CREATE FUNCTION [dbo].[uf_com_GetApplicableDEMATList]
(
	@inp_nForUserInfoId			INT,
	@inp_nActionTypeId			INT = NULL,	-- refer to code group 183
	@inp_bIsWithRelative		BIT = 0
)
RETURNS 
@ReturnTable TABLE 
(
	DEMATID        INT,
	Value       VARCHAR(100),
	Width       VARCHAR(100)
)
AS
BEGIN

	DECLARE @DematSetting_ConfigCodeId INT
	DECLARE @IsMappingCode BIT

	DECLARE @DematSetting_AllDemat	 INT = 184001
	DECLARE @DematSetting_SelectedDemat INT = 184002

	DECLARE @MapToTypeCodeId_DematAccount INT = 132014

	DECLARE @CompanyConfiguration_DematSetting INT = 180002

    -- Check if action type code is NULL or not, in case of null fetch all demat account otherwoise fetch demat base on configuration table
		IF(@inp_nActionTypeId IS NOT NULL AND @inp_nActionTypeId <> '')
		BEGIN
			-- check configuration base on Action type id 
			select @DematSetting_ConfigCodeId = ConfigurationValueCodeId, @IsMappingCode = IsMappingCode
			from com_CompanySettingConfiguration where ConfigurationCodeId = @inp_nActionTypeId AND ConfigurationTypeCodeId = @CompanyConfiguration_DematSetting

			IF(@DematSetting_ConfigCodeId = @DematSetting_AllDemat)
			BEGIN
				-- get all demat account list for user
				INSERT INTO @ReturnTable
				SELECT 
					DMATDetailsID AS ID, 
					DEMATAccountNumber + ' - ' + CASE 
													WHEN d.DPBankCodeId IS NULL THEN d.DPBank
													ELSE 
														CASE 
															WHEN ccDpBank.DisplayCode IS NULL OR ccDpBank.DisplayCode = '' THEN ccDpBank.CodeName 
															ELSE ccDpBank.DisplayCode 
														END
												END AS Value, 
					TMID AS Width 
				FROM usr_DMATDetails d
				LEFT JOIN com_Code ccDpBank ON d.DPBankCodeId IS NOT NULL AND d.DPBankCodeId = ccDpBank.CodeID
				WHERE UserInfoId = @inp_nForUserInfoId and d.DmatAccStatusCodeId = 102001
			END
			ELSE IF(@DematSetting_ConfigCodeId = @DematSetting_SelectedDemat AND @IsMappingCode = 1)
			BEGIN
				-- get selected demat account list for user
				INSERT INTO @ReturnTable
				SELECT 
					DMATDetailsID AS ID, 
					DEMATAccountNumber + ' - ' + CASE 
													WHEN d.DPBankCodeId IS NULL THEN d.DPBank
													ELSE 
														CASE 
															WHEN ccDpBank.DisplayCode IS NULL OR ccDpBank.DisplayCode = '' THEN ccDpBank.CodeName 
															ELSE ccDpBank.DisplayCode 
														END
												END AS Value, 
					TMID AS Width 
				FROM usr_DMATDetails d
				INNER JOIN com_CompanySettingConfigurationMapping config ON 
								d.DPBankCodeId = config.ConfigurationValueId AND 
								config.MapToTypeCodeId = @MapToTypeCodeId_DematAccount AND 
								config.ConfigurationMapToId = @inp_nActionTypeId
				LEFT JOIN com_Code ccDpBank ON d.DPBankCodeId IS NOT NULL AND d.DPBankCodeId = ccDpBank.CodeID
				WHERE d.UserInfoId = @inp_nForUserInfoId
			END
		END
		ELSE -- ignore configuration and get all demat account list for user
		BEGIN
			-- get all demat account list for user
			IF(@inp_bIsWithRelative = 0) -- fetch demat only for user
			BEGIN
				INSERT INTO @ReturnTable
				SELECT 
					DMATDetailsID AS ID, 
					DEMATAccountNumber + ' - ' + CASE 
													WHEN d.DPBankCodeId IS NULL THEN d.DPBank
													ELSE 
														CASE 
															WHEN ccDpBank.DisplayCode IS NULL OR ccDpBank.DisplayCode = '' THEN ccDpBank.CodeName 
															ELSE ccDpBank.DisplayCode 
														END
												END AS Value, 
					TMID AS Width 
				FROM usr_DMATDetails d
				LEFT JOIN com_Code ccDpBank ON d.DPBankCodeId IS NOT NULL AND d.DPBankCodeId = ccDpBank.CodeID
				WHERE UserInfoId = @inp_nForUserInfoId and d.DmatAccStatusCodeId = 102001
			END
			ELSE 
			BEGIN
				-- With Relative demat details
				INSERT INTO @ReturnTable
				SELECT 
					DMATDetailsID AS ID, 
					DEMATAccountNumber + ' - ' + CASE 
													WHEN d.DPBankCodeId IS NULL THEN d.DPBank
													ELSE 
														CASE 
															WHEN ccDpBank.DisplayCode IS NULL OR ccDpBank.DisplayCode = '' THEN ccDpBank.CodeName 
															ELSE ccDpBank.DisplayCode 
														END
												END AS Value, 
					TMID AS Width 
				FROM usr_DMATDetails d
				LEFT JOIN com_Code ccDpBank ON d.DPBankCodeId IS NOT NULL AND d.DPBankCodeId = ccDpBank.CodeID
				WHERE UserInfoId = @inp_nForUserInfoId and d.DmatAccStatusCodeId = 102001

				UNION
				
				SELECT DMATDetailsID AS ID , 
					DEMATAccountNumber + ' - ' + CASE 
													WHEN DD.DPBankCodeId IS NULL THEN DD.DPBank
													ELSE 
														CASE 
															WHEN ccDpBank2.DisplayCode IS NULL OR ccDpBank2.DisplayCode = '' THEN ccDpBank2.CodeName 
															ELSE ccDpBank2.DisplayCode 
														END
												END AS Value, 
					TMID AS Width 
				FROM usr_DMATDetails DD
				LEFT JOIN com_Code ccDpBank2 ON DD.DPBankCodeId IS NOT NULL AND DD.DPBankCodeId = ccDpBank2.CodeID
				JOIN usr_UserRelation UR ON DD.UserInfoID = UR.UserInfoIdRelative
				WHERE DD.UserInfoID = UR.UserInfoIdRelative AND UR.UserInfoId = @inp_nForUserInfoId and DD.DmatAccStatusCodeId = 102001
			END
			
		END

	RETURN 
END
