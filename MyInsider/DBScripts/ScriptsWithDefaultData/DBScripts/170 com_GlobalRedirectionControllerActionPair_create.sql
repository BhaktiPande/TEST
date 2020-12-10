/**********************************************************************************************************************

Created by : Swapnil Mahajan

Desc : To Create the table which are used for the handling the redirection on global level
	=> com_GlobalRedirectionControllerActionPair = Contain the Controller and Action level key as "ControllerAction" which is used for deciding whether to handle the Redireciton or not
	=> com_GlobalRedirectToURL					 = Contain the URL of the redirection path.

**********************************************************************************************************************
**********************************************************************************************************************/

create table com_GlobalRedirectionControllerActionPair
(
	ID INT NOT NULL,
	ControllerActionName NVARCHAR(255) NOT NULL,
	ModifiedBy int NOT NULL,
	ModifiedOn datetime NOT NULL,
)
GO

ALTER TABLE com_GlobalRedirectionControllerActionPair ADD CONSTRAINT PK_com_GlobalRedirectionControllerActionPair PRIMARY KEY (ID)
GO

ALTER TABLE com_GlobalRedirectionControllerActionPair ADD CONSTRAINT fk_com_GlobalRedirection_usr_UserInfo_ModifiedBy FOREIGN KEY (ModifiedBy)
REFERENCES usr_UserInfo(UserInfoId)
GO
----------------------------------------------------------------------------------------------------------------
INSERT INTO DBUpdateStatus (ScriptNumber, ScriptFileName, Description, CreatedBy)
VALUES (170, '170 com_GlobalRedirectionControllerActionPair_create', 'Create com_GlobalRedirectionControllerActionPair', 'Arundhati')

