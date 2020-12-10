




UPDATE du_MappingTables SET Query='
TRUNCATE TABLE Vigilante_HRMS  
INSERT INTO Vigilante_HRMS 
SELECT EMPLOYEE_NUMBER , FIRST_NAME, MIDDLE_NAMES, LAST_NAME, CITY, PINCODE, substring(MOBILE_NO,0,30) as  MOBILE_NO,cASE WhEN ADIT.LWD is NULL ThEN  OFFICIAL_EMAIL_ID  WhEN ADIT.LWD is not NULL ThEN  HRMS.PERSONAL_EMAIL  END AS OFFICIAL_EMAIL_ID, PAN_NUMBER, ROLE_NAME, DATE_OF_JOINING, GRADE_NAME, HRMS.DEPARTMENT, LWD AS DateOfSeparation,   RESG_REASON AS ReasonForSeparation,'' AS NoOfDaysToBeActive   FROM  [HRMSDLDB]..[VIGIL].[AXIS_DATA_FOR_INSIDER_TRADING] ADIT  INNER JOIN [HRMSDLDB]..[AEPUSER].[HRMS_AEP_USERS] HRMS ON HRMS.EMPNO = ADIT.EMPLOYEE_NUMBER  WHERE CONVERT(DATE,DATEADD(DAY,180,CASE WHEN LWD IS NOT NULL THEN LWD ELSE GETDATE() END)) >= CONVERT(DATE,GETDATE())   AND ((LWD IS NOT NULL AND RESG_REASON IS NOT NULL) OR (LWD IS NULL AND RESG_REASON IS NULL));  
INSERT INTO du_Vigilante_HRMS_History 
SELECT EMPLOYEE_NUMBER,FIRST_NAME,MIDDLE_NAMES,LAST_NAME,CITY,PINCODE,MOBILE_NO,OFFICIAL_EMAIL_ID,PAN_NUMBER,ROLE_NAME,DATE_OF_JOINING,GRADE_NAME,HS.DEPARTMENT,DateOfSeparation,ReasonForSeparation,  NoOfDaysToBeActive,GETDATE() FROM Vigilante_HRMS HS
SELECT EMPLOYEE_NUMBER,FIRST_NAME,MIDDLE_NAMES,LAST_NAME,CITY,PINCODE,MOBILE_NO,OFFICIAL_EMAIL_ID,PAN_NUMBER,ROLE_NAME,DATE_OF_JOINING,GRADE_NAME,HS.DEPARTMENT,DateOfSeparation,ReasonForSeparation,  NoOfDaysToBeActive FROM Vigilante_HRMS HS WHERE ROW_NO >= 1 AND ROW_NO <=30000;'
WHERE MappingTableID=1

UPDATE du_MappingTables SET Query='
INSERT INTO du_Insider_Trading_Mis_History
SELECT [ENTITY_ID],[EMP_NO],[TRD_NO],[ENT_FULL_NAME],[ENTITY_DP_AC_NO],[TRD_DT],[SMST_ISIN_CODE],[SMST_SECURITY_NAME],[TRD_SEM_ID],[TRD_BUY_SELL_FLG] ,  [TRD_QTY],[TRD_PRICE],[ENTITY_PAN],GETDATE() FROM [dbo].[Insider_Trading_Mis]
SELECT [ENTITY_ID],[EMP_NO],[TRD_NO],[ENT_FULL_NAME],[ENTITY_DP_AC_NO],[TRD_DT],[SMST_ISIN_CODE],[SMST_SECURITY_NAME],[TRD_SEM_ID],[TRD_BUY_SELL_FLG] ,  [TRD_QTY],[TRD_PRICE],[ENTITY_PAN] FROM [dbo].[Insider_Trading_Mis]'
WHERE  MappingTableID=3