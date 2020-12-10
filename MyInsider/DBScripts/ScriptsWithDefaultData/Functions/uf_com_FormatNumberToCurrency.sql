IF EXISTS (SELECT * FROM SYS.all_objects WHERE NAME = 'uf_com_FormatNumberToCurrency' AND Type = 'FN')
	DROP FUNCTION uf_com_FormatNumberToCurrency
GO

/*-------------------------------------------------------------------------------------------------
Author:			Gaurishankar
Create date:	27-Sep-2016
Description:	This function will return number with currency format.

Modification History:
Modified By		Modified On		Description

DECLARE @rc VARCHAR(100)
EXEC @rc = uf_com_FormatNumberToCurrency 457,'IND'
SELECT @rc
-------------------------------------------------------------------------------------------------*/

CREATE FUNCTION [dbo].[uf_com_FormatNumberToCurrency]
(    
  @InNumericValue NUMERIC(38,2)
 ,@InFormatType   VARCHAR(10)
)
RETURNS VARCHAR(60)
AS
BEGIN
	DECLARE     @RetVal     VARCHAR(60)
				,@StrRight  VARCHAR(5) 
				,@StrFinal  VARCHAR(60)
				,@StrLength INT
	                 
	SET @RetVal = ''
	SET @RetVal= @InNumericValue 
	SET @RetVal= SUBSTRING(@RetVal,1,CASE WHEN CHARINDEX('.', @RetVal)=0 THEN LEN(@RetVal)ELSE CHARINDEX('.',@RetVal)-1 END)

	IF(@InFormatType = 'US')
	BEGIN
		SET @StrFinal= CONVERT(VARCHAR(60), CONVERT(MONEY, @RetVal) , 1)
		SET @StrFinal= SUBSTRING(@StrFinal,0,CHARINDEX('.', @StrFinal))
	END
	ELSE IF(@InFormatType = 'IND')
	BEGIN
		SET @StrLength = LEN(@RetVal)
		IF(@StrLength > 3)
		BEGIN
			SET @StrFinal = RIGHT(@RetVal,3)         
			SET @RetVal = SUBSTRING(@RetVal,-2,@StrLength)
			SET @StrLength = LEN(@RetVal)
		IF (LEN(@RetVal) > 0 AND LEN(@RetVal) < 3)
		BEGIN
			SET @StrFinal = @RetVal + ',' + @StrFinal
			END
			WHILE LEN(@RetVal) > 2
			BEGIN
				SET @StrRight=RIGHT(@RetVal,2)               
				SET @StrFinal = @StrRight + ',' + @StrFinal
				SET @RetVal = SUBSTRING(@RetVal,-1,@StrLength)
				SET @StrLength = LEN(@RetVal)
				IF(LEN(@RetVal) > 2)
					CONTINUE
				ELSE
					SET @StrFinal = @RetVal + ',' + @StrFinal
					BREAK
			END
		END
		ELSE
		BEGIN
			SET @StrFinal = @RetVal
		END

	END
	SELECT @StrFinal = ISNULL(@StrFinal,00)
	RETURN @StrFinal
END
