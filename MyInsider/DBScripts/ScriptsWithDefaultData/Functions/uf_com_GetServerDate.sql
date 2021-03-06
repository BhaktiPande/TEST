IF EXISTS (SELECT * FROM SYS.all_objects WHERE NAME = 'uf_com_GetServerDate' AND Type = 'FN')
	DROP FUNCTION uf_com_GetServerDate
GO

/*-------------------------------------------------------------------------------------------------
Author:			Raghvendra
Create date:		04-Sep-2016
Description:	This function will return the database server date using the GETDATE() function.
If it is required to simulate changing the server date for testing then we will require to change 
the date in this function and it will be reflected in all the code. So we can have different server 
date for different databases. The date return from this function should be timestamp

Modification History:
Modified By		Modified On		Description

-------------------------------------------------------------------------------------------------*/



CREATE FUNCTION [dbo].[uf_com_GetServerDate]
()
RETURNS DATETIME 
AS
BEGIN
	DECLARE @sFormattedValue DATETIME = GETDATE()
	RETURN @sFormattedValue
END

