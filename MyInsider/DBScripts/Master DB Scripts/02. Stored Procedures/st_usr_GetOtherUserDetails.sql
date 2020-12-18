USE [Blank_database_MyInsider]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Procedure to save user info.

Returns:		0, if Success.
				
Created by:		Aditya Dhage 
Created on:		7-Dec-2020

Modification History:
Modified By		Modified On		Description

-------------------------------------------------------------------------------------------------*/

CREATE OR ALTER PROCEDURE [dbo].[st_usr_GetOtherUserDetails]
	@SharingBy INT,
	@Term varchar(500) = NULL
	
AS
BEGIN
	
		
		SET NOCOUNT ON;
		-- Declare variables
		if(@Term IS NULL OR @Term = '')
		  BEGIN
		  	SELECT DISTINCT Email,Name,PAN,CompanyName, CompanyAddress,Phone FROM usr_UPSIDocumentDetail WHERE SharingBy = @SharingBy ORDER BY 1 DESC
		  END
		ELSE
		  BEGIN
		    SELECT DISTINCT Email,Name,PAN,CompanyName, CompanyAddress,Phone FROM usr_UPSIDocumentDetail WHERE SharingBy = @SharingBy AND Email LIKE '%' + @Term + '%' ORDER BY 1 DESC
		  END
		
END


