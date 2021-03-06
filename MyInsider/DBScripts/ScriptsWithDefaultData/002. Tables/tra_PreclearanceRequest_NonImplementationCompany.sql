/*
	Script from Parag on 15 September 2016
	Pre-clearance table for non-implementing company
*/
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'tra_PreclearanceRequest_NonImplementationCompany'))
BEGIN
	CREATE TABLE tra_PreclearanceRequest_NonImplementationCompany
	(
		PreclearanceRequestId BIGINT NOT NULL IDENTITY (1, 1) CONSTRAINT PK_tra_PreclearanceRequest_NonImplementationCompany_PreclearanceRequestId PRIMARY KEY (PreclearanceRequestId),
		RlSearchAuditId INT NOT NULL CONSTRAINT FK_tra_PreclearanceRequest_NonImplementationCompany_RlSearchAuditId_rl_SearchAudit_RlSearchAuditId FOREIGN KEY(RlSearchAuditId) REFERENCES rl_SearchAudit(RlSearchAuditId),
		DisplaySequenceNo BIGINT NOT NULL,
		PreclearanceRequestForCodeId INT NOT NULL CONSTRAINT FK_tra_PreclearanceRequest_NonImplementationCompany_PreclearanceRequestForCodeId_com_Code_CodeID FOREIGN KEY(PreclearanceRequestForCodeId) REFERENCES com_Code(CodeID),
		UserInfoId INT NOT NULL CONSTRAINT FK_tra_PreclearanceRequest_NonImplementationCompany_UserInfoId_usr_UserInfo_UserINfoId FOREIGN KEY(UserInfoId) REFERENCES usr_UserINfo(UserInfoId),
		UserInfoIdRelative INT NULL CONSTRAINT FK_tra_PreclearanceRequest_NonImplementationCompany_UserInfoIdRelative_usr_UserInfo_UserINfoId FOREIGN KEY(UserInfoIdRelative) REFERENCES usr_UserINfo(UserInfoId),
		TransactionTypeCodeId INT NOT NULL CONSTRAINT FK_tra_PreclearanceRequest_NonImplementationCompany_TransactionTypeCodeId_com_Code_CodeID FOREIGN KEY(TransactionTypeCodeId) REFERENCES com_Code(CodeID),
		SecurityTypeCodeId INT NOT NULL CONSTRAINT FK_tra_PreclearanceRequest_NonImplementationCompany_SecurityTypeCodeId_com_Code_CodeID FOREIGN KEY(SecurityTypeCodeId) REFERENCES com_Code(CodeID),
		SecuritiesToBeTradedQty DECIMAL(15, 4) NOT NULL,
		SecuritiesToBeTradedValue DECIMAL(20, 4) NOT NULL,
		PreclearanceStatusCodeId INT NOT NULL CONSTRAINT FK_tra_PreclearanceRequest_NonImplementationCompany_PreclearanceStatusCodeId_com_Code_CodeID FOREIGN KEY(PreclearanceStatusCodeId) REFERENCES com_Code(CodeID),
		CompanyId INT NOT NULL, CONSTRAINT FK_tra_PreclearanceRequest_NonImplementationCompany_CompanyId_rl_CompanyMasterList_RlCompanyId FOREIGN KEY(CompanyId) REFERENCES rl_CompanyMasterList(RlCompanyId),
		DMATDetailsID INT NOT NULL CONSTRAINT FK_tra_PreclearanceRequest_NonImplementationCompany_DMATDetailsID_usr_DMATDetails_DMATDetailsID FOREIGN KEY(DMATDetailsID) REFERENCES usr_DMATDetails(DMATDetailsID),
		ModeOfAcquisitionCodeId INT NOT NULL CONSTRAINT FK_tra_PreclearanceRequest_NonImplementationCompany_ModeOfAcquisitionCodeId_com_Code_CodeID FOREIGN KEY(ModeOfAcquisitionCodeId) REFERENCES com_Code(CodeID),
		ReasonForRejection NVARCHAR(200) NULL,
		PledgeOptionQty DECIMAL(15, 4) NOT NULL DEFAULT 0,
		IsAutoApproved BIT NOT NULL DEFAULT 0,
		ApprovedBy INT NULL CONSTRAINT FK_tra_PreclearanceRequest_NonImplementationCompany_ApprovedBy_usr_UserInfo_UserINfoId FOREIGN KEY(ApprovedBy) REFERENCES usr_UserINfo(UserInfoId),
		ApprovedOn DATETIME NULL,
		CreatedBy INT NOT NULL CONSTRAINT FK_tra_PreclearanceRequest_NonImplementationCompany_CreatedBy_usr_UserInfo_UserINfoId FOREIGN KEY(CreatedBy) REFERENCES usr_UserINfo(UserInfoId),
		CreatedOn DATETIME NOT NULL DEFAULT GETDATE(),
		ModifiedBy INT NOT NULL CONSTRAINT FK_com_tra_PreclearanceRequest_NonImplementationCompany_ModifiedBy_usr_UserInfo_UserINfoId FOREIGN KEY(ModifiedBy) REFERENCES usr_UserINfo(UserInfoId),
		ModifiedOn DATETIME NOT NULL DEFAULT GETDATE()
	)
END
GO