/******************************************************************************************************************
Description:	Add column for 'FromMailId'

Returns:		
				
Created by:		Samadhan
Created on:		25-May-2020

Modification History:

*****************************************************************************************************************/


IF NOT EXISTS(SELECT 1 FROM sys.columns 
          WHERE Name = N'FromMailID'
          AND Object_ID = Object_ID(N'dbo.Companies'))
BEGIN

Alter table Companies add  FromMailID varchar(250)

END
