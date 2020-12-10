ALTER TABLE tra_TransactionDetails 
	ADD SegregateESOPAndOtherExcerciseOptionQtyFalg BIT NOT NULL CONSTRAINT DF_tra_TransactionDetails_SegEsopOtherFlag DEFAULT 0,
		ESOPExcerciseOptionQty DECIMAL(10,0) NOT NULL CONSTRAINT DF_tra_TransactionDetails_EsopQty DEFAULT 0,
		OtherExcerciseOptionQty DECIMAL(10,0) NOT NULL CONSTRAINT DF_tra_TransactionDetails_OtherQty DEFAULT 0,
		ESOPExcerseOptionQtyFlag INT NOT NULL CONSTRAINT DF_tra_TransactionDetails_EsopQtyFlg DEFAULT 0,
		OtherESOPExcerseOptionFlag INT NOT NULL CONSTRAINT DF_tra_TransactionDetails_OtherQtyFlg DEFAULT 0,
		ContractSpecification VARCHAR(50)

GO
----------------------------------------------------------------------------------------------------------------
INSERT INTO DBUpdateStatus (ScriptNumber, ScriptFileName, Description, CreatedBy)
VALUES (207, '207 tra_TransactionDetails_Alter', 'tra_TransactionDetails alter', 'Arundhati')

