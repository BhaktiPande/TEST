IF EXISTS (SELECT NAME FROM SYS.OBJECTS WHERE NAME = 'uf_com_Split')
	DROP FUNCTION uf_com_Split
GO

/*-- =============================================
-- Author:		Arundhati
-- Create date: 5/3/2015
-- Description:	Function which takes comma separated string and returns a table containing items as split values

Usage:
------
declare @i varchar(500)
set @i = '120,160'
select items from [dbo].[uf_com_Split](@i)

Modified By		Modified On	    Description
-- =============================================*/


CREATE FUNCTION [dbo].[uf_com_Split](@String VARCHAR(max))       
RETURNS @temptable TABLE (items VARCHAR(max))       
AS       
BEGIN     
		--declare @Delimiter char(1)  
       DECLARE @idx INT       
       DECLARE @slice VARCHAR(max)       
        
       SET @String = LTRIM(RTRIM(@String))
       SELECT @idx = 1       
           IF LEN(@String)<1 OR @String IS NULL  RETURN       
         
      WHILE @idx!= 0       
       BEGIN       
           SET @idx = CHARINDEX(',',@String)       
           IF @idx!=0       
              SET @slice = left(@String,@idx - 1)       
           ELSE       
              SET @slice = @String       
             
           IF(LEN(@slice)>0)  
               INSERT INTO @temptable(Items) VALUES(@slice)       
     
          SET @String = right(@String,len(@String) - @idx)       
          IF LEN(@String) = 0 BREAK       
       END   
	RETURN       
END
