IF EXISTS (SELECT NAME FROM SYS.OBJECTS WHERE NAME = 'uf_rpt_FormatValue')
	DROP FUNCTION uf_rpt_FormatValue
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Author:			Raghvendra
Create date:	29-Oct-2015
Description:	This function will check if the given data is null or not and if it is not empty or else show the character for empty.

Modification History:
Modified By		Modified On		Description

-------------------------------------------------------------------------------------------------*/
CREATE FUNCTION [dbo].[uf_rpt_FormatValue]
(
	-- Add the parameters for the function here
	@inp_sValue VARCHAR(1000),
	@inp_bShowDash bit	--1: Show dash when value is empty or null, 0:Show default value when value is null or empty
)
RETURNS VARCHAR(1000) -- Formatted date as String
AS
BEGIN
	DECLARE @sFormattedValue VARCHAR(1000)
	DECLARE @sDashCharacter VARCHAR(5) = '-'
	IF @inp_bShowDash <> 1
	BEGIN
		SELECT @sDashCharacter = ''
	END
	
	SELECT @sFormattedValue = CASE  WHEN ISNULL(@inp_sValue,'') = '' THEN @sDashCharacter ELSE @inp_sValue END
	RETURN @sFormattedValue
END
