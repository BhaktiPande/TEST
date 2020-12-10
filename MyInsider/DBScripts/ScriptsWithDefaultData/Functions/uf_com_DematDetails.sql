IF OBJECT_ID(N'dbo.uf_com_DematDetails', N'TF') IS NOT NULL
    DROP FUNCTION dbo.uf_com_DematDetails;
GO

/*---------------------------------------------------------
Created by:		AniketG
Created on:		24-July-2019

Modification History:
Modified By		Modified On		Description
----------------------------------------------------------*/

CREATE FUNCTION [dbo].[uf_com_DematDetails]
(
	@UserInfoID int
)
RETURNS VARCHAR(max)
AS
BEGIN
	-- Declare the return variable here
	DECLARE @ResultVar VARCHAR(max)
	SET @ResultVar = ''
	
	SELECT @ResultVar = @ResultVar + Convert(Varchar, isnull(DD.DEMATAccountNumber,'') + '/' + isnull(DD.DPID,'')) + ',' FROM usr_DMATDetails DD
	WHERE UserInfoId  = @UserInfoID

	if len(@ResultVar )>1
		SELECT @ResultVar = LEFT(@ResultVar , LEN(@ResultVar) - 1)
	-- Return the result of the function
	RETURN @ResultVar

END