CREATE TABLE rpt_DefaulterReport
(
DefaulterReportID BIGINT IDENTITY (1, 1),
UserInfoID INT NOT NULL,
UserInfoIdRelative INT,
PreclearanceRequestId BIGINT,
--PreclearanceApplicabletill DATETIME,
--PreclearanceStatusDate DATETIME,
--CompanyId INT,
TransactionMasterId BIGINT,
TransactionDetailsId BIGINT,
--TransactionTypeCodeId INT,
--SecurityTypeCodeId INT,
--TradeBuyTransactionQty DECIMAL(10,0),
--TradeSellTransactionQty DECIMAL(10,0),
--Quantity DECIMAL(10,0),
--Value DECIMAL(20,0),
--TradingDetailsSubmissionDate DATETIME,
InitialContinousPeriodEndDisclosureRequired INT,
LastSubmissionDate DATETIME,
--SoftCopySubmissionDate DATETIME,
--HardCopySubmissionDate DATETIME,
--HardCopyToEchangeSubmissionDate DATETIME,
NonComplainceTypeCodeId INT NOT NULL,
--IsOverrideFlag BIT NOT NULL DEFAULT 0,
--PeriodCodeId INT,
--YearCodeId INT,
PeriodEndDate DATETIME,
)
GO

-- PK on DefaulterReportID
ALTER TABLE rpt_DefaulterReport ADD CONSTRAINT PK_rpt_DefaulterReport PRIMARY KEY (DefaulterReportID)
GO

-- FK on UserInfoId
ALTER TABLE rpt_DefaulterReport ADD CONSTRAINT FK_rpt_DefaulterReport_usr_UserInfo_UserInfoId FOREIGN KEY
(UserInfoId) REFERENCES usr_UserInfo(UserInfoID)	
GO

-- FK on UserInfoIdRelative
ALTER TABLE rpt_DefaulterReport ADD CONSTRAINT FK_rpt_DefaulterReport_usr_UserInfo_UserInfoIdRelative FOREIGN KEY
(UserInfoIdRelative) REFERENCES usr_UserInfo(UserInfoID)	
GO

-- FK on PreclearanceRequestId
ALTER TABLE rpt_DefaulterReport ADD CONSTRAINT FK_rpt_DefaulterReport_tra_PreclearanceRequest_PreclearanceRequestId FOREIGN KEY
(PreclearanceRequestId) REFERENCES tra_PreclearanceRequest(PreclearanceRequestId)	
GO

---- FK CompanyId
--ALTER TABLE rpt_DefaulterReport ADD CONSTRAINT FK_rpt_DefaulterReport_mst_Company_CompanyId FOREIGN KEY
--(CompanyId) REFERENCES mst_Company(CompanyId)	
--GO

-- FK TransactionMasterId
ALTER TABLE rpt_DefaulterReport ADD CONSTRAINT FK_rpt_DefaulterReport_tra_TransactionMaster_TransactionMasterId FOREIGN KEY
(TransactionMasterId) REFERENCES tra_TransactionMaster(TransactionMasterId)	
GO

-- FK TransactionDetailsId
ALTER TABLE rpt_DefaulterReport ADD CONSTRAINT FK_rpt_DefaulterReport_tra_TransactionDetails_TransactionDetailsId FOREIGN KEY
(TransactionDetailsId) REFERENCES tra_TransactionDetails(TransactionDetailsId)	
GO

---- FK TransactionTypeCodeId
--ALTER TABLE rpt_DefaulterReport ADD CONSTRAINT FK_rpt_DefaulterReport_com_Code_TransactionTypeCodeId FOREIGN KEY
--(TransactionTypeCodeId) REFERENCES com_Code(CodeID)	
--GO

---- FK SecurityTypeCodeId
--ALTER TABLE rpt_DefaulterReport ADD CONSTRAINT FK_rpt_DefaulterReport_com_Code_SecurityTypeCodeId FOREIGN KEY
--(SecurityTypeCodeId) REFERENCES com_Code(CodeID)	
--GO

-- FK NonComplainceTypeCodeId
ALTER TABLE rpt_DefaulterReport ADD CONSTRAINT FK_rpt_DefaulterReport_com_Code_NonComplainceTypeCodeId FOREIGN KEY
(NonComplainceTypeCodeId) REFERENCES com_Code(CodeID)	
GO

---- FK PeriodCodeId
--ALTER TABLE rpt_DefaulterReport ADD CONSTRAINT FK_rpt_DefaulterReport_com_Code_PeriodCodeId FOREIGN KEY
--(PeriodCodeId) REFERENCES com_Code(CodeID)	
--GO

---- FK YearCodeId
--ALTER TABLE rpt_DefaulterReport ADD CONSTRAINT FK_rpt_DefaulterReport_com_Code_YearCodeId FOREIGN KEY
--(YearCodeId) REFERENCES com_Code(CodeID)	
--GO







----------------------------------------------------------------------------------------------------------------------

INSERT INTO DBUpdateStatus (ScriptNumber, ScriptFileName, Description, CreatedBy)
VALUES (184, '184 rpt_DefaulterReport_Create', 'Create rpt_DefaulterReport', 'Arundhati')
