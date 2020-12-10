/**********************************************************************************************************************

Created by : Swapnil Mahajan

Desc : To Create the table which are used for the handling the redirection on global level
	=> com_GlobalRedirectionControllerActionPair = Contain the Controller and Action level key as "ControllerAction" which is used for deciding whether to handle the Redireciton or not
	=> com_GlobalRedirectToURL					 = Contain the URL of the redirection path.

**********************************************************************************************************************
**********************************************************************************************************************/

create table com_GlobalRedirectToURL
(
	ID INT NOT NULL,
	Controller NVARCHAR(255) NOT NULL,
	Action NVARCHAR(255) NOT NULL,
	Parameter NVARCHAR(255),	
	ModifiedBy int NOT NULL,
	ModifiedOn datetime NOT NULL,
)
GO

ALTER TABLE com_GlobalRedirectToURL ADD CONSTRAINT PK_com_GlobalRedirectToURL PRIMARY KEY (ID)
GO

ALTER TABLE com_GlobalRedirectToURL ADD CONSTRAINT fk_com_GlobalRedirectToURL_usr_UserInfo_ModifiedBy FOREIGN KEY (ModifiedBy)
REFERENCES usr_UserInfo(UserInfoId)
GO

----------------------------------------------------------------------------------------------------------------
INSERT INTO DBUpdateStatus (ScriptNumber, ScriptFileName, Description, CreatedBy)
VALUES (171, '171 com_GlobalRedirectToURL_create', 'Create com_GlobalRedirectToURL', 'Arundhati')

