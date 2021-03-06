IF EXISTS (SELECT NAME FROM SYS.OBJECTS WHERE NAME = 'uf_rpt_ReplaceSpecialChar')
	DROP FUNCTION uf_rpt_ReplaceSpecialChar
GO
/****** Object:  UserDefinedFunction [dbo].[ReplaceSpecialChar]    Script Date: 09/02/2016 18:28:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/* ****************************************************************************
Modified By: Amit Kurakar
Modified Date: 02-Sep-2016
Description: This Function is used to replace special character form the column value.
*****************************************************************************/ 

CREATE FUNCTION [dbo].[uf_rpt_ReplaceSpecialChar] (
	@ColValue Varchar(max) -- Input number with as many as 18 digits
) 	RETURNS VARCHAR(Max) 

AS BEGIN


		DECLARE @outputString VARCHAR(8000)
		DECLARE @PrefixChar VARChar(10)
		
		IF(@ColValue is not null And @ColValue<>'')
		Begin
		
				SELECT @PrefixChar=SUBSTRING(@ColValue, 1, 1) 
				if(@PrefixChar='=')
				Begin
						SET @outputString= replace(@ColValue,@PrefixChar,'''=')
				End 
				Else
				Begin
						SET @outputString=@ColValue
				End
		End
		ELSE
		BEGIN 
				SET @outputString =@ColValue
		END
		
RETURN @outputString -- return the result
END
