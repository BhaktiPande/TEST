CREATE TABLE tra_ExerciseBalancePool
(UserInfoId INT NOT NULL,
SecurityTypeCodeId INT NOT NULL,
ESOPQuantity DECIMAL(15,0) NOT NULL DEFAULT 0,
OtherQuantity DECIMAL(15, 0) NOT NULL DEFAULT 0
)
GO

-- PK on DefaulterReportID
ALTER TABLE tra_ExerciseBalancePool ADD CONSTRAINT PK_tra_ExerciseBalancePool PRIMARY KEY (UserInfoId)
GO

ALTER TABLE tra_ExerciseBalancePool ADD CONSTRAINT fk_tra_ExerciseBalancePool_Usr_UserInfo_UserINfoId FOREIGN KEY(UserInfoId) 
REFERENCES usr_UserINfo(UserInfoId)
GO

ALTER TABLE tra_ExerciseBalancePool ADD CONSTRAINT fk_tra_ExerciseBalancePool_com_Code_SecurityTypeCodeId FOREIGN KEY(SecurityTypeCodeId)
REFERENCES com_Code(CodeId)
GO

----------------------------------------------------------------------------------------------------------------------

INSERT INTO DBUpdateStatus (ScriptNumber, ScriptFileName, Description, CreatedBy)
VALUES (208, '208 tra_ExerciseBalancePool_Create', 'Create tra_ExerciseBalancePool', 'Arundhati')
