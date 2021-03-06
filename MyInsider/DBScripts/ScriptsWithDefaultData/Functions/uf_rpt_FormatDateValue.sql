IF EXISTS (SELECT NAME FROM SYS.OBJECTS WHERE NAME = 'uf_rpt_FormatDateValue')
	DROP FUNCTION uf_rpt_FormatDateValue
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Author:			Raghvendra
Create date:	29-Oct-2015
Description:	This function will check if the given data is null or not and if it is not null then 
				the date will be formatted to specified date format.

Modification History:
Modified By		Modified On		Description
Raghvendra		5-Nov-2015		Added a parameter to show Pending when date is not available
Raghvendra		30-Dec-2015		Added - character to be shown when there is no data to be shown
-------------------------------------------------------------------------------------------------*/


CREATE FUNCTION [dbo].[uf_rpt_FormatDateValue]
(
	-- Add the parameters for the function here
	@inp_dtDateValue DATETIME,
	@inp_bShowPending bit		--1:Show Pending when value is empty or null, 0:Dont show Pending when value is empty or null
)
RETURNS NVARCHAR(100) -- Formatted date as String
AS
BEGIN
	DECLARE @sFormattedDateValue NVARCHAR(100)
	DECLARE @sDashCharacter VARCHAR(10) = 'Pending'
	IF @inp_bShowPending <> 1
	BEGIN
		SELECT @sDashCharacter = '-'
	END
		SELECT @sFormattedDateValue = CASE  WHEN ISNULL(@inp_dtDateValue,'') = '' THEN @sDashCharacter ELSE UPPER(REPLACE(CONVERT(NVARCHAR, @inp_dtDateValue, 106),' ','/')) END
	RETURN @sFormattedDateValue
END
