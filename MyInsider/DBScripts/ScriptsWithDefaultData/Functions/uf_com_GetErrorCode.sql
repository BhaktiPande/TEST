IF EXISTS (SELECT NAME FROM SYS.OBJECTS WHERE NAME = 'uf_com_GetErrorCode')
	DROP FUNCTION uf_com_GetErrorCode
GO
/*-------------------------------------------------------------------------------------------------
Description:	This routine returns custom errorcodes for some specific SQL error numbers
				otherwise, returns a default error number associated with specific module.
Created by:		Arundhati
Created on:		05-Feb-2014

Modification History:
Modified By		Modified On	Description
--------------------------------------------------------------------------------------------------*/

CREATE FUNCTION [dbo].[uf_com_GetErrorCode]
(
	@inp_iDefaultErrorNumber	INT,	-- Default error number
	@inp_iCurrentErrorNumber	INT		-- SQL Server Specific error number just occurred.
)
RETURNS INT AS  
BEGIN
	DECLARE @iRetErrNo INT

	-- Init the return value with default error number.
	SET @iRetErrNo = @inp_iDefaultErrorNumber

	-- Just in case there are specific SQL errors which need to be reported to the user
	-- in specific manner, then trap those errors and return corresponding custom error numbers for the same.

	IF (@inp_iCurrentErrorNumber = 515)			-- Cannot insert the value NULL into column '%.*ls', table '%.*ls'; column does not allow nulls. %ls fails.
		SET @iRetErrNo = 99996

	ELSE IF (@inp_iCurrentErrorNumber = 547)	-- The %ls statement conflicted with the %ls constraint "%.*ls". The conflict occurred in database "%.*ls", table "%.*ls"%ls%.*ls%ls.
		SET @iRetErrNo = 99997

	ELSE IF (@inp_iCurrentErrorNumber = 2627)	-- Violation of %ls constraint '%.*ls'. Cannot insert duplicate key in object '%.*ls'.
		SET @iRetErrNo = 99998

	ELSE IF (@inp_iCurrentErrorNumber = 2601)	-- Cannot insert duplicate key row in object '%.*ls' with unique index '%.*ls'.
		SET @iRetErrNo = 99998
		
	RETURN @iRetErrNo
END


