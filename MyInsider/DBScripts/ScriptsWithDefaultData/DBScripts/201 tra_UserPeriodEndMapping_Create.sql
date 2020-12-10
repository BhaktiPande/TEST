CREATE TABLE tra_UserPeriodEndMapping
(
UserPeriodEndMappingId BIGINT IDENTITY(1,1),
UserInfoId INT NOT NULL,
TradingPolicyId INT NOT NULL,
YearCodeId INT NOT NULL,
PeriodCodeId INT NOT NULL,
PEStartDate DATETIME NOT NULL,
PEEndDate DATETIME NOT NULL,
CreatedBy INT,
CreatedOn DATETIME,
ModifiedBy INT,
ModifiedOn DATETIME
)
GO

-- PK on DefaulterReportID
ALTER TABLE tra_UserPeriodEndMapping ADD CONSTRAINT PK_tra_UserPeriodEndMapping PRIMARY KEY (UserPeriodEndMappingId)
GO

-- FK on UserInfoId
ALTER TABLE tra_UserPeriodEndMapping ADD CONSTRAINT FK_tra_UserPeriodEndMapping_usr_UserInfo_UserInfoId FOREIGN KEY
(UserInfoId) REFERENCES usr_UserInfo(UserInfoID)	
GO

-- FK on TradingPolicyId
ALTER TABLE tra_UserPeriodEndMapping ADD CONSTRAINT FK_tra_UserPeriodEndMapping_rul_TradingPolicy_TradingPolicyId FOREIGN KEY
(TradingPolicyId) REFERENCES rul_TradingPolicy(TradingPolicyId)	
GO

-- FK on YearCodeId
ALTER TABLE tra_UserPeriodEndMapping ADD CONSTRAINT FK_tra_UserPeriodEndMapping_com_code_YearCodeId FOREIGN KEY
(YearCodeId) REFERENCES com_Code(CodeId)	
GO

-- FK on PeriodCodeId
ALTER TABLE tra_UserPeriodEndMapping ADD CONSTRAINT FK_tra_UserPeriodEndMapping_com_code_PeriodCodeId FOREIGN KEY
(PeriodCodeId) REFERENCES com_Code(CodeId)	
GO

-- FK on CreatedBy
ALTER TABLE tra_UserPeriodEndMapping ADD CONSTRAINT FK_tra_UserPeriodEndMapping_usr_UserInfo_CreatedBy FOREIGN KEY
(CreatedBy) REFERENCES usr_UserInfo(UserInfoID)	
GO

-- FK on ModifiedBy
ALTER TABLE tra_UserPeriodEndMapping ADD CONSTRAINT FK_tra_UserPeriodEndMapping_usr_UserInfo_ModifiedBy FOREIGN KEY
(ModifiedBy) REFERENCES usr_UserInfo(UserInfoID)	
GO

CREATE UNIQUE NONCLUSTERED INDEX uk_tra_UserPeriodEndMapping_UserTPYearPeriod ON dbo.tra_UserPeriodEndMapping
(
UserInfoId,
TradingPolicyId,
YearCodeId,
PeriodCodeId
)
GO

----------------------------------------------------------------------------------------------------------------
INSERT INTO DBUpdateStatus (ScriptNumber, ScriptFileName, Description, CreatedBy)
VALUES (201, '201 tra_UserPeriodEndMapping_Create', 'Create tra_UserPeriodEndMapping_Create', 'Arundhati')
