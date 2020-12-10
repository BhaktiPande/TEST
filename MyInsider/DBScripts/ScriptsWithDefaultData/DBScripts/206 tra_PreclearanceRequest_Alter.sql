ALTER TABLE tra_PreclearanceRequest 
	ADD ESOPExcerciseOptionQtyFlag BIT NOT NULL CONSTRAINT DF_tra_PreclearanceRequest_EsopQtyFlg DEFAULT 0,
		OtherESOPExcerciseOptionQtyFlag BIT NOT NULL CONSTRAINT DF_tra_PreclearanceRequest_OtherQtyFlg DEFAULT 0

GO

----------------------------------------------------------------------------------------------------------------
INSERT INTO DBUpdateStatus (ScriptNumber, ScriptFileName, Description, CreatedBy)
VALUES (206, '206 tra_PreclearanceRequest_Alter', 'tra_PreclearanceRequest alter', 'Arundhati')

