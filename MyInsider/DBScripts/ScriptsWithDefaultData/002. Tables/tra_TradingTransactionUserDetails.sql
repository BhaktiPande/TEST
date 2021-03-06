/* 
	Script from Parag on 09-May-2016	
	Script to create table to save user information for per transaction when transcation is submitted
*/

IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'tra_TradingTransactionUserDetails')
BEGIN

	CREATE TABLE tra_TradingTransactionUserDetails
	(
		TransactionUserDetailsId BIGINT IDENTITY(1,1), TransactionMasterId BIGINT NOT NULL, TransactionDetailsId BIGINT NULL, FormDetails BIT DEFAULT 0,
		UserInfoId INT NOT NULL, UserTypeCode INT NOT NULL, ForUserInfoId INT NOT NULL, EmployeeId VARCHAR(50) NULL,
		FirstName VARCHAR(50) NULL, MiddleName VARCHAR(50) NULL, LastName VARCHAR(50) NULL, Relation VARCHAR(550) NULL, FormCategoryPerson VARCHAR(550) NULL,
		Email VARCHAR(250) NULL, MobileNumber VARCHAR(15) NULL, CompanyName VARCHAR(200) NULL, [Address] VARCHAR(500) NULL,
		Country VARCHAR(550) NULL, Pincode VARCHAR(50) NULL, ContactPerson VARCHAR(100) NULL, DateOfJoining DATETIME NULL,
		DateOfBecomingInsider DATETIME NULL, PanNumber VARCHAR(50) NULL, Landline1 VARCHAR(50) NULL, Landline2 VARCHAR(50) NULL,
		TanNumber VARCHAR(50) NULL, Category VARCHAR(550) NULL, Subcategory VARCHAR(550) NULL, Grade VARCHAR(550) NULL,
		Designation VARCHAR(550) NULL, Subdesignation VARCHAR(550) NULL, Location VARCHAR(50) NULL, Department VARCHAR(550) NULL,
		UPSIAccessofcompany INT NULL, DematAccountNumber VARCHAR(50) NULL, DPBank VARCHAR(550) NULL, DPId VARCHAR(50) NULL,
		TMId VARCHAR(50) NULL, StockExchange VARCHAR(550) NULL, CINNumber VARCHAR(50) NULL, DIN VARCHAR(50) NULL,
		CreatedBy INT NOT NULL, CreatedOn DATETIME NOT NULL, ModifiedBy INT NOT NULL, ModifiedOn DATETIME NOT NULL
	)
	

	-- add foregin key on transaction master id field
	ALTER TABLE tra_TradingTransactionUserDetails ADD CONSTRAINT 
		FK_tra_TradingTransactionUserDetails_tra_TransactionMaster_TransactionMasterId  FOREIGN KEY(TransactionMasterId) REFERENCES tra_TransactionMaster (TransactionMasterId)
	

	-- add foregin key on transaction details id field
	ALTER TABLE tra_TradingTransactionUserDetails ADD CONSTRAINT 
		FK_tra_TradingTransactionUserDetails_tra_TransactionDetails_TransactionDetailsId  FOREIGN KEY(TransactionDetailsId) REFERENCES tra_TransactionDetails (TransactionDetailsId)
	

	-- add foregin key on user info field
	ALTER TABLE tra_TradingTransactionUserDetails ADD CONSTRAINT 
		FK_tra_TradingTransactionUserDetails_usr_UserInfo_UserInfoId  FOREIGN KEY(UserInfoId) REFERENCES usr_UserInfo (UserInfoId)
	

	-- add foregin key on created by field
	ALTER TABLE tra_TradingTransactionUserDetails ADD CONSTRAINT 
		FK_tra_TradingTransactionUserDetails_usr_UserInfo_CreatedBy  FOREIGN KEY(CreatedBy) REFERENCES usr_UserInfo (UserInfoId)
	

	-- add foregin key on modified by field	
	ALTER TABLE tra_TradingTransactionUserDetails ADD CONSTRAINT 
		FK_tra_TradingTransactionUserDetails_usr_UserInfo_ModifiedBy  FOREIGN KEY(ModifiedBy) REFERENCES usr_UserInfo (UserInfoId)
	
END