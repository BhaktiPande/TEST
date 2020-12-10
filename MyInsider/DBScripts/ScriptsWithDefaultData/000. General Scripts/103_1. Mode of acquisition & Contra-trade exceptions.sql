          -- ============================================================================================================
-- Author      : Samadhan Kadam																	      =
-- CREATED DATE: 16-Apruk-2020                                                 							      =
-- Description : Add'Buy-Back' in Mode  Acquisition List                                                    =
-- ============================================================================================================

IF NOT EXISTS( SELECT CodeID FROM COM_CODE WHERE CODEID=149016)
BEGIN
	INSERT INTO COM_CODE
	(	
		CodeID,	CodeName,	CodeGroupId,	Description,	IsVisible,	IsActive,	DisplayOrder,	DisplayCode,	ParentCodeId,	
		ModifiedBy,	ModifiedOn
	) 
	VALUES
	(
		149016,'Buy back',149,'Mode Of Acquisition - Buy back',1,1,16,NULL,NULL,1,GETDATE()
	)

END
IF NOT EXISTS( SELECT CodeID FROM COM_CODE WHERE CODEID=149017)
BEGIN
	INSERT INTO COM_CODE
	(	
		CodeID,	CodeName,	CodeGroupId,	Description,	IsVisible,	IsActive,	DisplayOrder,	DisplayCode,	ParentCodeId,	
		ModifiedBy,	ModifiedOn
	) 
	VALUES
	(
		149017,'Exit offers',149,'Mode Of Acquisition - Exit offers',1,1,17,NULL,NULL,1,GETDATE()
	)

END

IF NOT EXISTS( SELECT CodeID FROM COM_CODE WHERE CODEID=149018)
BEGIN
	INSERT INTO COM_CODE
	(	
		CodeID,	CodeName,	CodeGroupId,	Description,	IsVisible,	IsActive,	DisplayOrder,	DisplayCode,	ParentCodeId,	
		ModifiedBy,	ModifiedOn
	) 
	VALUES
	(
		149018,'Lend',149,'Mode Of Acquisition - Lend',1,1,18,NULL,NULL,1,GETDATE()
	)

END

IF NOT EXISTS( SELECT CodeID FROM COM_CODE WHERE CODEID=149019)
BEGIN
	INSERT INTO COM_CODE
	(	
		CodeID,	CodeName,	CodeGroupId,	Description,	IsVisible,	IsActive,	DisplayOrder,	DisplayCode,	ParentCodeId,	
		ModifiedBy,	ModifiedOn
	) 
	VALUES
	(
		149019,'Open offers',149,'Mode Of Acquisition - Open offers',1,1,19,NULL,NULL,1,GETDATE()
	)

END


IF NOT EXISTS( SELECT CodeID FROM COM_CODE WHERE CODEID=149020)
BEGIN
	INSERT INTO COM_CODE
	(	
		CodeID,	CodeName,	CodeGroupId,	Description,	IsVisible,	IsActive,	DisplayOrder,	DisplayCode,	ParentCodeId,	
		ModifiedBy,	ModifiedOn
	) 
	VALUES
	(
		149020,'Rights issues',149,'Mode Of Acquisition - Rights issues',1,1,20,NULL,NULL,1,GETDATE()
	)

END

IF NOT EXISTS( SELECT CodeID FROM COM_CODE WHERE CODEID=149021)
BEGIN
	INSERT INTO COM_CODE
	(	
		CodeID,	CodeName,	CodeGroupId,	Description,	IsVisible,	IsActive,	DisplayOrder,	DisplayCode,	ParentCodeId,	
		ModifiedBy,	ModifiedOn
	) 
	VALUES
	(
		149021,'Follow-on public offer (FPO)',149,'Mode Of Acquisition - Follow-on public offer (FPO)',1,1,21,NULL,NULL,1,GETDATE()
	)

END
IF NOT EXISTS( SELECT CodeID FROM COM_CODE WHERE CODEID=149022)
BEGIN
	INSERT INTO COM_CODE
	(	
		CodeID,	CodeName,	CodeGroupId,	Description,	IsVisible,	IsActive,	DisplayOrder,	DisplayCode,	ParentCodeId,	
		ModifiedBy,	ModifiedOn
	) 
	VALUES
	(
		149022,'Preferential allotment',149,'Mode Of Acquisition - Preferential allotment',1,1,22,NULL,NULL,1,GETDATE()
	)

END

IF NOT EXISTS( SELECT CodeID FROM COM_CODE WHERE CODEID=149023)
BEGIN
	INSERT INTO COM_CODE
	(	
		CodeID,	CodeName,	CodeGroupId,	Description,	IsVisible,	IsActive,	DisplayOrder,	DisplayCode,	ParentCodeId,	
		ModifiedBy,	ModifiedOn
	) 
	VALUES
	(
		149023,'Borrow',149,'Mode Of Acquisition - Borrow',1,1,23,NULL,NULL,1,GETDATE()
	)

END


--Security type Share 139001
-- tran. type buy -143001
--Mode Of Acquisition - Buy back  149016
--Acution- Buy    504001
--Impact on Post Share Quantity - Add 505001
--CONTRA TRADE- 506002	NO

IF NOT EXISTS(
SELECT TTTS_ID FROM TRA_TRANSACTIONTYPESETTINGS WHERE
												SECURITY_TYPE_CODE_ID=139001 AND  TRANS_TYPE_CODE_ID= 143002 
												AND MODE_OF_ACQUIS_CODE_ID=149016 AND ACTION_CODE_ID=504002 
												AND IMPT_POST_SHARE_QTY_CODE_ID=505002 AND  CONTRA_TRADE_CODE_ID=506002) 
BEGIN
	INSERT INTO tra_TransactionTypeSettings
	(
			SECURITY_TYPE_CODE_ID,	TRANS_TYPE_CODE_ID,	MODE_OF_ACQUIS_CODE_ID,	ACTION_CODE_ID,	IMPT_POST_SHARE_QTY_CODE_ID,
			CONTRA_TRADE_CODE_ID,	CREATED_BY,	CREATED_ON,	UPDATED_BY,	UPDATED_ON,	EXEMPT_PRE_FOR_MODE_OF_ACQUISITION
	)
	VALUES
	(
			139001,143002,149016,504002,505002,506002,1,GETDATE(),1,GETDATE(),1
	)

END

IF NOT EXISTS(
SELECT TTTS_ID FROM TRA_TRANSACTIONTYPESETTINGS WHERE
												SECURITY_TYPE_CODE_ID=139001 AND  TRANS_TYPE_CODE_ID= 143002 
												AND MODE_OF_ACQUIS_CODE_ID=149017 AND ACTION_CODE_ID=504002 
												AND IMPT_POST_SHARE_QTY_CODE_ID=505002 AND  CONTRA_TRADE_CODE_ID=506002) 
BEGIN
	INSERT INTO tra_TransactionTypeSettings
	(
			SECURITY_TYPE_CODE_ID,	TRANS_TYPE_CODE_ID,	MODE_OF_ACQUIS_CODE_ID,	ACTION_CODE_ID,	IMPT_POST_SHARE_QTY_CODE_ID,
			CONTRA_TRADE_CODE_ID,	CREATED_BY,	CREATED_ON,	UPDATED_BY,	UPDATED_ON,	EXEMPT_PRE_FOR_MODE_OF_ACQUISITION
	)
	VALUES
	(
			139001,143002,149017,504002,505002,506002,1,GETDATE(),1,GETDATE(),1
	)

END

IF NOT EXISTS(
SELECT TTTS_ID FROM TRA_TRANSACTIONTYPESETTINGS WHERE
												SECURITY_TYPE_CODE_ID=139001 AND  TRANS_TYPE_CODE_ID= 143002 
												AND MODE_OF_ACQUIS_CODE_ID=149018 AND ACTION_CODE_ID=504002 
												AND IMPT_POST_SHARE_QTY_CODE_ID=505002 AND  CONTRA_TRADE_CODE_ID=506002) 
BEGIN
	INSERT INTO tra_TransactionTypeSettings
	(
			SECURITY_TYPE_CODE_ID,	TRANS_TYPE_CODE_ID,	MODE_OF_ACQUIS_CODE_ID,	ACTION_CODE_ID,	IMPT_POST_SHARE_QTY_CODE_ID,
			CONTRA_TRADE_CODE_ID,	CREATED_BY,	CREATED_ON,	UPDATED_BY,	UPDATED_ON,	EXEMPT_PRE_FOR_MODE_OF_ACQUISITION
	)
	VALUES
	(
			139001,143002,149018,504002,505002,506002,1,GETDATE(),1,GETDATE(),1
	)

END


IF NOT EXISTS(
SELECT TTTS_ID FROM TRA_TRANSACTIONTYPESETTINGS WHERE
												SECURITY_TYPE_CODE_ID=139001 AND  TRANS_TYPE_CODE_ID= 143001 
												AND MODE_OF_ACQUIS_CODE_ID=149019 AND ACTION_CODE_ID=504001 
												AND IMPT_POST_SHARE_QTY_CODE_ID=505001 AND  CONTRA_TRADE_CODE_ID=506002) 
BEGIN
	INSERT INTO tra_TransactionTypeSettings
	(
			SECURITY_TYPE_CODE_ID,	TRANS_TYPE_CODE_ID,	MODE_OF_ACQUIS_CODE_ID,	ACTION_CODE_ID,	IMPT_POST_SHARE_QTY_CODE_ID,
			CONTRA_TRADE_CODE_ID,	CREATED_BY,	CREATED_ON,	UPDATED_BY,	UPDATED_ON,	EXEMPT_PRE_FOR_MODE_OF_ACQUISITION
	)
	VALUES
	(
			139001,143001,149019,504001,505001,506002,1,GETDATE(),1,GETDATE(),1
	)

END

IF NOT EXISTS(
SELECT TTTS_ID FROM TRA_TRANSACTIONTYPESETTINGS WHERE
												SECURITY_TYPE_CODE_ID=139001 AND  TRANS_TYPE_CODE_ID= 143001 
												AND MODE_OF_ACQUIS_CODE_ID=149020 AND ACTION_CODE_ID=504001 
												AND IMPT_POST_SHARE_QTY_CODE_ID=505001 AND  CONTRA_TRADE_CODE_ID=506002) 
BEGIN
	INSERT INTO tra_TransactionTypeSettings
	(
			SECURITY_TYPE_CODE_ID,	TRANS_TYPE_CODE_ID,	MODE_OF_ACQUIS_CODE_ID,	ACTION_CODE_ID,	IMPT_POST_SHARE_QTY_CODE_ID,
			CONTRA_TRADE_CODE_ID,	CREATED_BY,	CREATED_ON,	UPDATED_BY,	UPDATED_ON,	EXEMPT_PRE_FOR_MODE_OF_ACQUISITION
	)
	VALUES
	(
			139001,143001,149020,504001,505001,506002,1,GETDATE(),1,GETDATE(),1
	)

END

IF NOT EXISTS(
SELECT TTTS_ID FROM TRA_TRANSACTIONTYPESETTINGS WHERE
												SECURITY_TYPE_CODE_ID=139001 AND  TRANS_TYPE_CODE_ID= 143001 
												AND MODE_OF_ACQUIS_CODE_ID=149021 AND ACTION_CODE_ID=504001 
												AND IMPT_POST_SHARE_QTY_CODE_ID=505001 AND  CONTRA_TRADE_CODE_ID=506002) 
BEGIN
	INSERT INTO tra_TransactionTypeSettings
	(
			SECURITY_TYPE_CODE_ID,	TRANS_TYPE_CODE_ID,	MODE_OF_ACQUIS_CODE_ID,	ACTION_CODE_ID,	IMPT_POST_SHARE_QTY_CODE_ID,
			CONTRA_TRADE_CODE_ID,	CREATED_BY,	CREATED_ON,	UPDATED_BY,	UPDATED_ON,	EXEMPT_PRE_FOR_MODE_OF_ACQUISITION
	)
	VALUES
	(
			139001,143001,149021,504001,505001,506002,1,GETDATE(),1,GETDATE(),1
	)

END
IF NOT EXISTS(
SELECT TTTS_ID FROM TRA_TRANSACTIONTYPESETTINGS WHERE
												SECURITY_TYPE_CODE_ID=139001 AND  TRANS_TYPE_CODE_ID= 143001 
												AND MODE_OF_ACQUIS_CODE_ID=149022 AND ACTION_CODE_ID=504001 
												AND IMPT_POST_SHARE_QTY_CODE_ID=505001 AND  CONTRA_TRADE_CODE_ID=506002) 
BEGIN
	INSERT INTO tra_TransactionTypeSettings
	(
			SECURITY_TYPE_CODE_ID,	TRANS_TYPE_CODE_ID,	MODE_OF_ACQUIS_CODE_ID,	ACTION_CODE_ID,	IMPT_POST_SHARE_QTY_CODE_ID,
			CONTRA_TRADE_CODE_ID,	CREATED_BY,	CREATED_ON,	UPDATED_BY,	UPDATED_ON,	EXEMPT_PRE_FOR_MODE_OF_ACQUISITION
	)
	VALUES
	(
			139001,143001,149022,504001,505001,506002,1,GETDATE(),1,GETDATE(),1
	)

END
IF NOT EXISTS(
SELECT TTTS_ID FROM TRA_TRANSACTIONTYPESETTINGS WHERE
												SECURITY_TYPE_CODE_ID=139001 AND  TRANS_TYPE_CODE_ID= 143001 
												AND MODE_OF_ACQUIS_CODE_ID=149023 AND ACTION_CODE_ID=504001 
												AND IMPT_POST_SHARE_QTY_CODE_ID=505001 AND  CONTRA_TRADE_CODE_ID=506002) 
BEGIN
	INSERT INTO tra_TransactionTypeSettings
	(
			SECURITY_TYPE_CODE_ID,	TRANS_TYPE_CODE_ID,	MODE_OF_ACQUIS_CODE_ID,	ACTION_CODE_ID,	IMPT_POST_SHARE_QTY_CODE_ID,
			CONTRA_TRADE_CODE_ID,	CREATED_BY,	CREATED_ON,	UPDATED_BY,	UPDATED_ON,	EXEMPT_PRE_FOR_MODE_OF_ACQUISITION
	)
	VALUES
	(
			139001,143001,149023,504001,505001,506002,1,GETDATE(),1,GETDATE(),1
	)

END
