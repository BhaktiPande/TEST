IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_mst_MenuMasterList')
DROP PROCEDURE [dbo].[st_mst_MenuMasterList]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Get the List of menus applicable to the user.

Returns:		0, if Success.
				
Created by:		Arundhati
Created on:		03-Feb-2015

Modification History:
Modified By		Modified On		Description
Arundhati		27-Feb-2015		MenuName is added in the output list
Arundhati		13-Mar-2015		Menus for the activities through delegation
Raghvendra		4-July-2015		Added status condition when showing the menus
Arundhati		27-Jul-2015		Resource key changed for the error code
Raghvendra		07-Sep-2016		Changed the GETDATE() call with function dbo.uf_com_GetServerDate(). This function will return the date to be used as server date.
Usage:
EXEC st_mst_MenuMasterList 2
-------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [st_mst_MenuMasterList]
	
	@inp_iPageSize INT = 10,
	@inp_iPageNo INT = 1,
	@inp_sSortField VARCHAR(255),
	@inp_sSortOrder	VARCHAR(5),	
	@inp_sUserInfoId int, -- Id of the logged in user
	@out_nReturnValue	INT = 0 OUTPUT,
	@out_nSQLErrCode			INT = 0 OUTPUT,				-- Output SQL Error Number, if error occurred.
	@out_sSQLErrMessage			VARCHAR(500) = '' OUTPUT  -- Output SQL Error Message, if error occurred.
	
AS
BEGIN
	DECLARE @sSQL NVARCHAR(MAX)
	DECLARE @ERR_MENU_LIST INT = 10000
	DECLARE @dtToday DATETIME = CONVERT(DATETIME, CONVERT(VARCHAR(11), dbo.uf_com_GetServerDate())) 
	DECLARE @nInActiveStatusCode INT = 102002
	DECLARE @CurrentRequiredModule INT
	DECLARE @OwnSecurityModule INT = 513001
	DECLARE @OtherSecurityModule INT = 513002
	DECLARE @BothSecurityModule INT = 513003
	DECLARE @MCQRequiredModule INT 

	BEGIN TRY
		
		SET NOCOUNT ON;
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''
			
		CREATE TABLE #tmpMenuList (MenuId INT, ParentMenuID INT)
		
		select @CurrentRequiredModule = RequiredModule,@MCQRequiredModule=IsMCQRequired from mst_company where IsImplementing=1
		IF(@MCQRequiredModule=521001)
		BEGIN
			UPDATE mst_MenuMaster SET StatusCodeID = 102001 WHERE upper(MenuName) =upper('MCQ Settings') and MenuID=66
			UPDATE mst_MenuMaster SET StatusCodeID = 102001 WHERE upper(MenuName) =upper('MCQ Report') and MenuID=67
		END
		ELSE 
		BEGIN
			UPDATE mst_MenuMaster SET StatusCodeID = 102002 WHERE upper(MenuName) =upper('MCQ Settings') and MenuID=66
			UPDATE mst_MenuMaster SET StatusCodeID = 102002 WHERE upper(MenuName) =upper('MCQ Report') and MenuID=67
		END

		IF(@CurrentRequiredModule=@OwnSecurityModule)
		BEGIN
			UPDATE usr_Activity set StatusCodeID=105001 where ActivityID=218
			UPDATE mst_MenuMaster set StatusCodeID=102001 where MenuID in(56,57)
		END
		ELSE
		BEGIN
			UPDATE usr_Activity set StatusCodeID=105002 where ActivityID=218
			UPDATE mst_MenuMaster set StatusCodeID=102002 where MenuID in(56,57)
		END

		IF(@CurrentRequiredModule<>@BothSecurityModule)
		BEGIN
			INSERT INTO #tmpMenuList(MenuId, ParentMenuID)
		
			SELECT DISTINCT MenuID, ParentMenuID
			FROM usr_UserRole UR JOIN usr_RoleActivity RA ON UR.RoleID = RA.RoleID
			join usr_Activity UA ON UA.ActivityID=RA.ActivityID
			JOIN mst_MenuMaster MChild ON MChild.ActivityID = RA.ActivityID
			WHERE Userinfoid = @inp_sUserInfoId AND MChild.StatusCodeId != @nInActiveStatusCode
			and ua.ApplicableFor in(@CurrentRequiredModule,@BothSecurityModule)
			UNION
			--- Menus for the activities thru delegation
			SELECT MenuID, ParentMenuID
			FROM usr_DelegationMaster DM JOIN usr_DelegationDetails DD ON DM.DelegationId = DD.DelegationId
			JOIN mst_MenuMaster MChild ON MChild.ActivityID = DD.ActivityID
			WHERE UserInfoIdTo = @inp_sUserInfoId AND MChild.StatusCodeId != @nInActiveStatusCode
			AND DelegationFrom <= @dtToday AND DelegationTo >= @dtToday
		END
		ELSE
		BEGIN 
		INSERT INTO #tmpMenuList(MenuId, ParentMenuID)
		
			SELECT DISTINCT MenuID, ParentMenuID
			FROM usr_UserRole UR JOIN usr_RoleActivity RA ON UR.RoleID = RA.RoleID
			join usr_Activity UA ON UA.ActivityID=RA.ActivityID
			JOIN mst_MenuMaster MChild ON MChild.ActivityID = RA.ActivityID
			WHERE Userinfoid = @inp_sUserInfoId AND MChild.StatusCodeId != @nInActiveStatusCode			
			UNION
			--- Menus for the activities thru delegation
			SELECT MenuID, ParentMenuID
			FROM usr_DelegationMaster DM JOIN usr_DelegationDetails DD ON DM.DelegationId = DD.DelegationId
			JOIN mst_MenuMaster MChild ON MChild.ActivityID = DD.ActivityID
			WHERE UserInfoIdTo = @inp_sUserInfoId AND MChild.StatusCodeId != @nInActiveStatusCode
			AND DelegationFrom <= @dtToday AND DelegationTo >= @dtToday
		END
		

		
		INSERT INTO #tmpMenuList(MenuId, ParentMenuID)
		SELECT MMain.MenuID, MMain.ParentMenuID
		FROM mst_MenuMaster MMain JOIN #tmpMenuList tChild ON MMain.MenuID = tChild.ParentMenuID
		
		INSERT INTO #tmpMenuList(MenuId, ParentMenuID)
		SELECT MMain.MenuID, MMain.ParentMenuID
		FROM mst_MenuMaster MMain JOIN #tmpMenuList tChild ON MMain.MenuID = tChild.ParentMenuID
		WHERE MMain.StatusCodeId != @nInActiveStatusCode


		-- Based on search parameters, insert only the Primary Index Field in the temporary table.
		SELECT @sSQL = @sSQL + 'INSERT INTO #tmpList (RowNumber, EntityID)'
		
		-- if Called From CreateUser
		SELECT @inp_sSortField = 'CONVERT(VARCHAR(10), DisplayOrder)',
				@inp_sSortOrder = 'ASC'


		SELECT @sSQL = @sSQL + ' SELECT DISTINCT DENSE_RANK() OVER(Order BY ' + @inp_sSortField + ' ' + @inp_sSortOrder +',M.MenuId),M.MenuId '
		SELECT @sSQL = @sSQL + ' FROM mst_MenuMaster M JOIN #tmpMenuList t ON M.MenuId = t.MenuId'
		SELECT @sSQL = @sSQL + ' WHERE 1 = 1 AND M.StatusCodeId != ' + Convert(VARCHAR,@nInActiveStatusCode) 
		
		PRINT(@sSQL)
		EXEC(@sSQL)
		
		DECLARE @iRetVal INT
		DECLARE @iRolVal INT
		SET @iRetVal=(Select ISNULL(AllowUpsiUser,0) AS AllowUpsiUser from usr_UserInfo where UserInfoId = @inp_sUserInfoId)
		SET @iRolVal =(select RoleId from usr_UserRole Where UserInfoID=@inp_sUserInfoId)
		
		IF((@iRolVal IS NULL)  AND (@iRetVal=1))
        BEGIN
		SELECT	DISTINCT M.MenuID AS ID, M.MenuName AS MenuName, M.Description AS MENUDESC, 
			 	M.ParentMenuID	AS PARENTMENUID, 
			 	M.MenuURL AS MenuURL,
			 	CONVERT(VARCHAR(10), DisplayOrder) AS LEVELS,
			 	ImageURL
			 FROM mst_MenuMaster M where M.MenuID=64
		END
		ELSE IF ((@iRolVal IS NOT NULL)  AND (@iRetVal=1))
		BEGIN
		      SELECT	DISTINCT M.MenuID AS ID, M.MenuName AS MenuName, M.Description AS MENUDESC, 
			 	M.ParentMenuID	AS PARENTMENUID, 
			 	M.MenuURL AS MenuURL,
			 	CONVERT(VARCHAR(10), DisplayOrder) AS LEVELS,
			 	ImageURL
			 FROM mst_MenuMaster M JOIN #tmpMenuList t ON M.MenuID = t.MenuId
			 WHERE M.StatusCodeId != @nInActiveStatusCode 
			 
			 UNION
			 SELECT	DISTINCT M.MenuID AS ID, M.MenuName AS MenuName, M.Description AS MENUDESC, 
			 	M.ParentMenuID	AS PARENTMENUID, 
			 	M.MenuURL AS MenuURL,
			 	CONVERT(VARCHAR(10), DisplayOrder) AS LEVELS,
			 	ImageURL
			 FROM mst_MenuMaster M where M.MenuID=64
			 ORDER BY CONVERT(VARCHAR(10), DisplayOrder)
		END
		ELSE
		    BEGIN
		     	 SELECT	DISTINCT M.MenuID AS ID, M.MenuName AS MenuName, M.Description AS MENUDESC, 
			 		M.ParentMenuID	AS PARENTMENUID, 
			 		M.MenuURL AS MenuURL,
			 		CONVERT(VARCHAR(10), DisplayOrder) AS LEVELS,
			 		ImageURL
				 FROM mst_MenuMaster M JOIN #tmpMenuList t ON M.MenuID = t.MenuId
				 WHERE M.StatusCodeId != @nInActiveStatusCode 
				 ORDER BY CONVERT(VARCHAR(10), DisplayOrder)
			END

		RETURN 0
	END	 TRY
	
	BEGIN CATCH		
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =  ERROR_MESSAGE()
		SET @out_nReturnValue	=  @ERR_MENU_LIST
	END CATCH
END
