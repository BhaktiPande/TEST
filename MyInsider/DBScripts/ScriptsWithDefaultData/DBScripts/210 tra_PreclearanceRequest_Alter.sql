
ALTER TABLE tra_PreclearanceRequest 
	ADD ESOPExcerciseOptionQty DECIMAL(15,4) NOT NULL CONSTRAINT DF_tra_PreclearanceRequest_EsopQty DEFAULT 0,
		OtherExcerciseOptionQty DECIMAL(15,4) NOT NULL CONSTRAINT DF_tra_PreclearanceRequest_OtherQty DEFAULT 0

GO
----------------------------------------------------------------------------------------------------------------
INSERT INTO DBUpdateStatus (ScriptNumber, ScriptFileName, Description, CreatedBy)
VALUES (210, '210 tra_PreclearanceRequest_Alter', 'tra_PreclearanceRequest alter', 'Arundhati')

