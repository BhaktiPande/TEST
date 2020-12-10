IF OBJECT_ID(N'dbo.uf_com_Relative_Name', N'TF') IS NOT NULL
    DROP FUNCTION dbo.uf_com_Relative_Name;
GO

/*---------------------------------------------------------
Created by:		AniketG
Created on:		24-July-2019

Modification History:
Modified By		Modified On		Description
----------------------------------------------------------*/

CREATE FUNCTION [dbo].[uf_com_Relative_Name] 
(
	@UserInfoID int
)
RETURNS VARCHAR(max)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @ResultVar VARCHAR(max)
	SET @ResultVar = ''
	
	SELECT @ResultVar = @ResultVar + ISNULL(UI.FirstName,'') + ' ' + ISNULL(UI.LastName,'') + ',' FROM usr_UserRelation UR INNER JOIN usr_UserInfo UI ON UR.UserInfoIdRelative = UI.UserInfoId
	WHERE UR.UserInfoId  = @UserInfoID

	IF LEN(@ResultVar) > 1
		SELECT @ResultVar = LEFT(@ResultVar , LEN(@ResultVar) - 1)

	-- Return the result of the function
	RETURN @ResultVar

END

