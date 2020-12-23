IF OBJECT_ID(N'dbo.FN_VIGILANTE_SPLIT', N'TF') IS NOT NULL
    DROP FUNCTION dbo.FN_VIGILANTE_SPLIT;
GO

/*
Created By	:	Manasi Patil
Created On	:	17-Sep-2014
Description	:	Created a Function to split the data using the delimiter ','

Modified By	Modified ON	Description
ED		01-March-2016   Changed in Code merging done in 1-March-2016
*/



CREATE FUNCTION FN_VIGILANTE_SPLIT
(
   @RepParam NVARCHAR(MAX), 
   @Delim char(1)= ','
) 

RETURNS @Values TABLE (Param NVARCHAR(MAX))AS 

BEGIN 
  DECLARE @chrind INT 
  DECLARE @Piece NVARCHAR(MAX) 
  
  SELECT @chrind = 1  
	  WHILE @chrind > 0 
		BEGIN 
		  SELECT @chrind = CHARINDEX(@Delim, @RepParam) 
		  IF @chrind  > 0 
			SELECT @Piece = LEFT(@RepParam, @chrind - 1) 
		  ELSE 
			SELECT @Piece = @RepParam 
		  
		  INSERT  @Values(Param) VALUES(CAST(@Piece AS nVARCHAR(max))) 
		  SELECT @RepParam = RIGHT(@RepParam, LEN(@RepParam) - @chrind) 			  
		  
		  IF LEN(@RepParam) = 0 BREAK 
	  END 
  RETURN 
END
