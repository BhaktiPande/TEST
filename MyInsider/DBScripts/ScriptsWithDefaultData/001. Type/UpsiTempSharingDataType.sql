IF EXISTS (SELECT NAME FROM SYS.types WHERE NAME = 'UpsiTempSharingDataType')
BEGIN
	IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_usr_UpsiTempDataDetails')
		DROP PROCEDURE st_usr_UpsiTempDataDetails
		DROP TYPE UpsiTempSharingDataType
END
GO
CREATE TYPE UpsiTempSharingDataType AS TABLE
(
       
		Company_Name                Varchar(500) NULL,
		Company_Address				Varchar(500) NULL,
		Category_Shared             nvarchar(50) NULL,
		Reason_sharing      	    nvarchar(500) NULL,
		Comments					nvarchar(500) NULL,	
		PAN							nvarchar(50) NULL,
		Name						nvarchar(250) NULL,
		Phone				        nvarchar(15) NULL,	
		E_mail                      nvarchar(250) NULL,
		SharingDate                 datetime NULL,
		UserInfoId					INT NOT NULL,
		ModeOfSharing               INT,
		SharingTime					Time,
        Temp1						NVARCHAR(250),	
		Temp2						NVARCHAR(250),	
		Temp3						NVARCHAR(250),	
		Temp4						NVARCHAR(250),	
		Temp5						NVARCHAR(250),
		DocumentNo					NVARCHAR(250),
		Sharedby					NVARCHAR(250),
		PublishDate					DATETIME NULL
)
	    
			
		
   
		
		
		
		 			
		

			
			
			
     
