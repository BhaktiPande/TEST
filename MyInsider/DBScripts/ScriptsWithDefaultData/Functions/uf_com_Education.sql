IF OBJECT_ID(N'dbo.uf_com_Education', N'TF') IS NOT NULL
    DROP FUNCTION dbo.uf_com_Education;
GO

/*---------------------------------------------------------
Created by:		AniketG
Created on:		24-July-2019

Modification History:
Modified By		Modified On		Description
----------------------------------------------------------*/

CREATE FUNCTION [dbo].[uf_com_Education] 
(
	@UserInfoID int
)
RETURNS VARCHAR(max)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @ResultVar VARCHAR(max)
	SET @ResultVar = ''
	
	SELECT @ResultVar = @ResultVar + Convert(Varchar, isnull(ED.InstituteName,'')) + ',' FROM usr_EducationWorkDetails ED
	WHERE UserInfoId  = @UserInfoID

	if len(@ResultVar )>1
		SELECT @ResultVar = LEFT(@ResultVar , LEN(@ResultVar) - 1)
	-- Return the result of the function
	RETURN @ResultVar

END
