-- ======================================================================================================================================
--	AUTHOR			: AMOL KADAM																									    =
--	CREATION DATE	: 24 MAY 2016																									    =
--	PURPOSE			: ADD NEW ROWS IN RUL_TRANSACTIONSECURITYMAPCONFIG TABLE FOR PLEDGE ENHANCEMENT	                                    =
-- ======================================================================================================================================


/* Add Mapping Entries for Pledge */

IF NOT EXISTS(SELECT TransactionSecurityMapId FROM rul_TransactionSecurityMapConfig WHERE MapToTypeCodeId = 132004 and TransactionTypeCodeId = 143006 and SecurityTypeCodeId = 139001)
BEGIN
	INSERT INTO rul_TransactionSecurityMapConfig(MapToTypeCodeId, TransactionTypeCodeId, SecurityTypeCodeId)
	VALUES(132004,143006,139001)
END

IF NOT EXISTS(SELECT TransactionSecurityMapId FROM rul_TransactionSecurityMapConfig WHERE MapToTypeCodeId = 132004 and TransactionTypeCodeId = 143007 and SecurityTypeCodeId = 139001)
BEGIN
	INSERT INTO rul_TransactionSecurityMapConfig(MapToTypeCodeId, TransactionTypeCodeId, SecurityTypeCodeId)
	VALUES(132004,143007,139001)
END

IF NOT EXISTS(SELECT TransactionSecurityMapId FROM rul_TransactionSecurityMapConfig WHERE MapToTypeCodeId = 132004 and TransactionTypeCodeId = 143008  and SecurityTypeCodeId = 139001)
BEGIN
	INSERT INTO rul_TransactionSecurityMapConfig(MapToTypeCodeId, TransactionTypeCodeId, SecurityTypeCodeId)
	VALUES(132004,143008,139001)
END

IF NOT EXISTS(SELECT TransactionSecurityMapId FROM rul_TransactionSecurityMapConfig WHERE MapToTypeCodeId = 132007 and TransactionTypeCodeId = 143006 and SecurityTypeCodeId = 139001)
BEGIN
	INSERT INTO rul_TransactionSecurityMapConfig(MapToTypeCodeId, TransactionTypeCodeId, SecurityTypeCodeId)
	VALUES(132007,143006,139001)
END

IF NOT EXISTS(SELECT TransactionSecurityMapId FROM rul_TransactionSecurityMapConfig WHERE MapToTypeCodeId = 132007 and TransactionTypeCodeId = 143007 and SecurityTypeCodeId = 139001)
BEGIN
	INSERT INTO rul_TransactionSecurityMapConfig(MapToTypeCodeId, TransactionTypeCodeId, SecurityTypeCodeId)
	VALUES(132007,143007,139001)
END

IF NOT EXISTS(SELECT TransactionSecurityMapId FROM rul_TransactionSecurityMapConfig WHERE MapToTypeCodeId = 132007 and TransactionTypeCodeId = 143008 and SecurityTypeCodeId = 139001)
BEGIN
	INSERT INTO rul_TransactionSecurityMapConfig(MapToTypeCodeId, TransactionTypeCodeId, SecurityTypeCodeId)
	VALUES(132007,143008,139001)
END


-- ======================================================================================================================================
--	AUTHOR			: AMOL KADAM																									    =
--	CREATION DATE	: 24 MAY 2016																									    =
--	PURPOSE			: ADD NEW ROWS IN COM_CODE TABLE FOR PLEDGE ENHANCEMENT	                                                            =
-- ======================================================================================================================================
/* Transaction Type */

IF NOT EXISTS (SELECT CodeID FROM com_Code WHERE CodeID = '143006')
BEGIN
	INSERT INTO com_Code
	(CodeID, CodeName, CodeGroupId, [Description], IsVisible, IsActive, DisplayOrder, DisplayCode, ParentCodeId, ModifiedBy, ModifiedOn)
	VALUES
	('143006', 'Pledge', '143', 'Transaction type - Pledge', 1, 1, 6, NULL, NULL, 1, GETDATE())
END

IF NOT EXISTS (SELECT CodeID FROM com_Code WHERE CodeID = '143007')
BEGIN
	INSERT INTO com_Code
	(CodeID, CodeName, CodeGroupId, [Description], IsVisible, IsActive, DisplayOrder, DisplayCode, ParentCodeId, ModifiedBy, ModifiedOn)
	VALUES
	('143007', 'Pledge Revoke', '143', 'Transaction type - Pledge Revoke', 1, 1, 7, NULL, NULL, 1, GETDATE())
END

IF NOT EXISTS (SELECT CodeID FROM com_Code WHERE CodeID = '143008')
BEGIN
	INSERT INTO com_Code
	(CodeID, CodeName, CodeGroupId, [Description], IsVisible, IsActive, DisplayOrder, DisplayCode, ParentCodeId, ModifiedBy, ModifiedOn)
	VALUES
	('143008', 'Pledge Invoke', '143', 'Transaction type - Pledge Invoke', 1, 1, 8, NULL, NULL, 1, GETDATE())
END

/* Mode of Acquisition */

IF NOT EXISTS (SELECT CodeID FROM com_Code WHERE CodeID = '149012')
BEGIN
	INSERT INTO com_Code
	(CodeID, CodeName, CodeGroupId, [Description], IsVisible, IsActive, DisplayOrder, DisplayCode, ParentCodeId, ModifiedBy, ModifiedOn)
	VALUES
	('149012', 'Pledge Creation', '149', 'Mode Of Acquisition - Pledge Creation', 1, 1, 12, NULL, NULL, 1, GETDATE())
END

IF NOT EXISTS (SELECT CodeID FROM com_Code WHERE CodeID = '149013')
BEGIN
	INSERT INTO com_Code
	(CodeID, CodeName, CodeGroupId, [Description], IsVisible, IsActive, DisplayOrder, DisplayCode, ParentCodeId, ModifiedBy, ModifiedOn)
	VALUES
	('149013', 'Revokation of Pledge', '149', 'Mode Of Acquisition - Revokation of Pledge', 1, 1, 13, NULL, NULL, 1, GETDATE())
END

IF NOT EXISTS (SELECT CodeID FROM com_Code WHERE CodeID = '149014')
BEGIN
	INSERT INTO com_Code
	(CodeID, CodeName, CodeGroupId, [Description], IsVisible, IsActive, DisplayOrder, DisplayCode, ParentCodeId, ModifiedBy, ModifiedOn)
	VALUES
	('149014', 'Invocation of Pledge', '149', 'Mode Of Acquisition - Invocation of Pledge', 1, 1, 14, NULL, NULL, 1, GETDATE())
END

--IF NOT EXISTS (SELECT CodeID FROM com_Code WHERE CodeID = '149011')
--BEGIN
--	INSERT INTO com_Code
--	(CodeID, CodeName, CodeGroupId, [Description], IsVisible, IsActive, DisplayOrder, DisplayCode, ParentCodeId, ModifiedBy, ModifiedOn)
--	VALUES
--	('149011', 'Bonus', '149', 'Mode Of Acquisition - Bonus', 1, 1, 11, NULL, NULL, 1, GETDATE())
--END

/* ACTION */

IF NOT EXISTS (SELECT CodeGroupID FROM com_CodeGroup WHERE CodeGroupID = '504')
BEGIN
	INSERT INTO com_CodeGroup
	(CodeGroupID, COdeGroupName, Description, IsVisible, IsEditable, ParentCodeGroupId)
	VALUES
	('504', 'Acion', 'Action', 1, 0, NULL)
END

IF NOT EXISTS (SELECT CodeID FROM com_Code WHERE CodeID = '504001')
BEGIN
	INSERT INTO com_Code
	(CodeID, CodeName, CodeGroupId, [Description], IsVisible, IsActive, DisplayOrder, DisplayCode, ParentCodeId, ModifiedBy, ModifiedOn)
	VALUES
	('504001', 'Buy', '504', 'Buy', 1, 1, 1, NULL, NULL, 1, GETDATE())
END

IF NOT EXISTS (SELECT CodeID FROM com_Code WHERE CodeID = '504002')
BEGIN
	INSERT INTO com_Code
	(CodeID, CodeName, CodeGroupId, [Description], IsVisible, IsActive, DisplayOrder, DisplayCode, ParentCodeId, ModifiedBy, ModifiedOn)
	VALUES
	('504002', 'Sell', '504', 'Sell', 1, 1, 1, NULL, NULL, 2, GETDATE())
END

IF NOT EXISTS (SELECT CodeID FROM com_Code WHERE CodeID = '504003')
BEGIN
	INSERT INTO com_Code
	(CodeID, CodeName, CodeGroupId, [Description], IsVisible, IsActive, DisplayOrder, DisplayCode, ParentCodeId, ModifiedBy, ModifiedOn)
	VALUES
	('504003', 'Buy/Sell', '504', 'Buy/Sell', 1, 1, 1, NULL, NULL, 2, GETDATE())
END

/* Impact on Post Share Quantity */

IF NOT EXISTS (SELECT CodeGroupID FROM com_CodeGroup WHERE CodeGroupID = '505')
BEGIN
	INSERT INTO com_CodeGroup
	(CodeGroupID, COdeGroupName, Description, IsVisible, IsEditable, ParentCodeGroupId)
	VALUES
	('505', 'Impact on Post Share Quantity', 'Impact on Post Share Quantity', 1, 0, NULL)
END

IF NOT EXISTS (SELECT CodeID FROM com_Code WHERE CodeID = '505001')
BEGIN
	INSERT INTO com_Code
	(CodeID, CodeName, CodeGroupId, [Description], IsVisible, IsActive, DisplayOrder, DisplayCode, ParentCodeId, ModifiedBy, ModifiedOn)
	VALUES
	('505001', 'Add', '505', 'Impact on Post Share Quantity - Add', 1, 1, 1, NULL, NULL, 1, GETDATE())
END

IF NOT EXISTS (SELECT CodeID FROM com_Code WHERE CodeID = '505002')
BEGIN
	INSERT INTO com_Code
	(CodeID, CodeName, CodeGroupId, [Description], IsVisible, IsActive, DisplayOrder, DisplayCode, ParentCodeId, ModifiedBy, ModifiedOn)
	VALUES
	('505002', 'Less', '505', 'Impact on Post Share Quantity - Less', 1, 1, 2, NULL, NULL, 1, GETDATE())
END

IF NOT EXISTS (SELECT CodeID FROM com_Code WHERE CodeID = '505003')
BEGIN
	INSERT INTO com_Code
	(CodeID, CodeName, CodeGroupId, [Description], IsVisible, IsActive, DisplayOrder, DisplayCode, ParentCodeId, ModifiedBy, ModifiedOn)
	VALUES
	('505003', 'Both', '505', 'Impact on Post Share Quantity - Both', 1, 1, 3, NULL, NULL, 1, GETDATE())
END

IF NOT EXISTS (SELECT CodeID FROM com_Code WHERE CodeID = '505004')
BEGIN
	INSERT INTO com_Code
	(CodeID, CodeName, CodeGroupId, [Description], IsVisible, IsActive, DisplayOrder, DisplayCode, ParentCodeId, ModifiedBy, ModifiedOn)
	VALUES
	('505004', 'No', '505', 'Impact on Post Share Quantity - No', 1, 1, 4, NULL, NULL, 1, GETDATE())
END


/* Contra Trade */

IF NOT EXISTS (SELECT CodeGroupID FROM com_CodeGroup WHERE CodeGroupID = '506')
BEGIN
	INSERT INTO com_CodeGroup
	(CodeGroupID, COdeGroupName, Description, IsVisible, IsEditable, ParentCodeGroupId)
	VALUES
	('506', 'Contra Trade', 'Contra Trade', 1, 0, NULL)
END

IF NOT EXISTS (SELECT CodeID FROM com_Code WHERE CodeID = '506001')
BEGIN
	INSERT INTO com_Code
	(CodeID, CodeName, CodeGroupId, [Description], IsVisible, IsActive, DisplayOrder, DisplayCode, ParentCodeId, ModifiedBy, ModifiedOn)
	VALUES
	('506001', 'YES', '506', 'Contra Trade - YES', 1, 1, 4, NULL, NULL, 1, GETDATE())
END

IF NOT EXISTS (SELECT CodeID FROM com_Code WHERE CodeID = '506002')
BEGIN
	INSERT INTO com_Code
	(CodeID, CodeName, CodeGroupId, [Description], IsVisible, IsActive, DisplayOrder, DisplayCode, ParentCodeId, ModifiedBy, ModifiedOn)
	VALUES
	('506002', 'NO', '506', 'Contra Trade - NO', 1, 1, 4, NULL, NULL, 1, GETDATE())
END

-- ======================================================================================================================================
--	AUTHOR			: AMOL KADAM																									    =
--	CREATION DATE	: 24 MAY 2016																									    =
--	PURPOSE			: ADD NEW COLUMNS PLEDGEQUANTITY & NOTIMPACTEDQUANTITY IN TRA_EXERCISEBALANCEPOOL TABLE FOR PLEDGE ENHANCEMENT	    =
-- ======================================================================================================================================

IF NOT EXISTS(SELECT SYSTAB.NAME FROM SYS.TABLES SYSTAB INNER JOIN SYS.COLUMNS SYSCOL ON SYSTAB.OBJECT_ID = SYSCOL.OBJECT_ID WHERE SYSTAB.NAME = 'tra_ExerciseBalancePool' AND SYSCOL.NAME = 'PledgeQuantity') 
 BEGIN 
		ALTER TABLE tra_ExerciseBalancePool ADD PledgeQuantity DECIMAL(15, 0)  NOT NULL DEFAULT(0)
 END
 GO
 
 
 IF NOT EXISTS(SELECT SYSTAB.NAME FROM SYS.TABLES SYSTAB INNER JOIN SYS.COLUMNS SYSCOL ON SYSTAB.OBJECT_ID = SYSCOL.OBJECT_ID WHERE SYSTAB.NAME = 'tra_ExerciseBalancePool' AND SYSCOL.NAME = 'NotImpactedQuantity') 
 BEGIN 
		ALTER TABLE tra_ExerciseBalancePool ADD NotImpactedQuantity DECIMAL(15, 0)  NOT NULL DEFAULT(0)
 END
 GO
 
 
 -- ======================================================================================================================================================================
--	AUTHOR			: AMOL KADAM																									                                    =
--	CREATION DATE	: 02 JUN 2016																									                                    =
--	PURPOSE			: ADD NEW COLUMNS PLEDGEBUYQUANTITY,PLEDGESELLQUANTITY & PLEDGECLOSINGBALANCE IN TRA_TRANSACTIONSUMMARYDMATWISE TABLE FOR PLEDGE ENHANCEMENT	    =
-- ======================================================================================================================================================================


IF NOT EXISTS(SELECT SYSTAB.NAME FROM SYS.TABLES SYSTAB INNER JOIN SYS.COLUMNS SYSCOL ON SYSTAB.OBJECT_ID = SYSCOL.OBJECT_ID WHERE SYSTAB.NAME = 'tra_TransactionSummaryDMATWise' AND SYSCOL.NAME = 'PledgeBuyQuantity') 
 BEGIN 
		ALTER TABLE tra_TransactionSummaryDMATWise ADD PledgeBuyQuantity DECIMAL(10, 0)  NOT NULL DEFAULT(0)
 END
 GO
 
 
 IF NOT EXISTS(SELECT SYSTAB.NAME FROM SYS.TABLES SYSTAB INNER JOIN SYS.COLUMNS SYSCOL ON SYSTAB.OBJECT_ID = SYSCOL.OBJECT_ID WHERE SYSTAB.NAME = 'tra_TransactionSummaryDMATWise' AND SYSCOL.NAME = 'PledgeSellQuantity') 
 BEGIN 
		ALTER TABLE tra_TransactionSummaryDMATWise ADD PledgeSellQuantity DECIMAL(10, 0)  NOT NULL DEFAULT(0)
 END
 GO
 
 
 IF NOT EXISTS(SELECT SYSTAB.NAME FROM SYS.TABLES SYSTAB INNER JOIN SYS.COLUMNS SYSCOL ON SYSTAB.OBJECT_ID = SYSCOL.OBJECT_ID WHERE SYSTAB.NAME = 'tra_TransactionSummaryDMATWise' AND SYSCOL.NAME = 'PledgeClosingBalance') 
 BEGIN 
		ALTER TABLE tra_TransactionSummaryDMATWise ADD PledgeClosingBalance DECIMAL(10, 0)  NOT NULL DEFAULT(0)
 END
 GO
 
 
 -- ==============================================================================================================================================================
--	AUTHOR			: AMOL KADAM																									                            =
--	CREATION DATE	: 02 JUN 2016																									                            =
--	PURPOSE			: ADD NEW COLUMNS PLEDGEBUYQUANTITY,PLEDGESELLQUANTITY & PLEDGECLOSINGBALANCE IN TRA_TRANSACTIONSUMMARY TABLE FOR PLEDGE ENHANCEMENT	    =
-- ==============================================================================================================================================================


IF NOT EXISTS(SELECT SYSTAB.NAME FROM SYS.TABLES SYSTAB INNER JOIN SYS.COLUMNS SYSCOL ON SYSTAB.OBJECT_ID = SYSCOL.OBJECT_ID WHERE SYSTAB.NAME = 'tra_TransactionSummary' AND SYSCOL.NAME = 'PledgeBuyQuantity') 
 BEGIN 
		ALTER TABLE tra_TransactionSummary ADD PledgeBuyQuantity DECIMAL(10, 0)  NOT NULL DEFAULT(0)
 END
 GO
 
 
 IF NOT EXISTS(SELECT SYSTAB.NAME FROM SYS.TABLES SYSTAB INNER JOIN SYS.COLUMNS SYSCOL ON SYSTAB.OBJECT_ID = SYSCOL.OBJECT_ID WHERE SYSTAB.NAME = 'tra_TransactionSummary' AND SYSCOL.NAME = 'PledgeSellQuantity') 
 BEGIN 
		ALTER TABLE tra_TransactionSummary ADD PledgeSellQuantity DECIMAL(10, 0)  NOT NULL DEFAULT(0)
 END
 GO
 
 
 IF NOT EXISTS(SELECT SYSTAB.NAME FROM SYS.TABLES SYSTAB INNER JOIN SYS.COLUMNS SYSCOL ON SYSTAB.OBJECT_ID = SYSCOL.OBJECT_ID WHERE SYSTAB.NAME = 'tra_TransactionSummary' AND SYSCOL.NAME = 'PledgeClosingBalance') 
 BEGIN 
		ALTER TABLE tra_TransactionSummary ADD PledgeClosingBalance DECIMAL(10, 0)  NOT NULL DEFAULT(0)
 END
 GO
 
 
 -- =========================================================================================================================================
--	AUTHOR			: AMOL KADAM																									       =
--	CREATION DATE	: 01 JUN 2016																									       =
--	PURPOSE			: ADD NEW COLUMNS PLEDGEOPTIONQTY & MODEOFACQUISITIONCODEID IN TRA_PRECLEARANCEREQUEST TABLE FOR PLEDGE ENHANCEMENT    =
-- =========================================================================================================================================


IF NOT EXISTS(SELECT SYSTAB.NAME FROM SYS.TABLES SYSTAB INNER JOIN SYS.COLUMNS SYSCOL ON SYSTAB.OBJECT_ID = SYSCOL.OBJECT_ID WHERE SYSTAB.NAME = 'tra_PreclearanceRequest' AND SYSCOL.NAME = 'PledgeOptionQty') 
 BEGIN 
		ALTER TABLE tra_PreclearanceRequest ADD PledgeOptionQty DECIMAL(15, 4) NOT NULL DEFAULT(0)
 END
 GO
 
 IF NOT EXISTS(SELECT SYSTAB.NAME FROM SYS.TABLES SYSTAB INNER JOIN SYS.COLUMNS SYSCOL ON SYSTAB.OBJECT_ID = SYSCOL.OBJECT_ID WHERE SYSTAB.NAME = 'tra_PreclearanceRequest' AND SYSCOL.NAME = 'ModeOfAcquisitionCodeId') 
 BEGIN 
		ALTER TABLE tra_PreclearanceRequest ADD ModeOfAcquisitionCodeId INT NOT NULL DEFAULT(0)
 END
 GO
 
 
 