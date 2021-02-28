
--==========================================Form B====================================

IF EXISTS (SELECT * FROM mst_Resource WHERE ResourceKey ='dis_lbl_17122')
BEGIN
	update mst_Resource set ResourceValue='[Regulation 7 (1) (b) read with Regulation 6(2) – Disclosure on becoming a Key Managerial Personnel/Director/Promoter/Member of the promoter group]', OriginalResourceValue='[Regulation 7 (1) (b) read with Regulation 6(2) – Disclosure on becoming a Key Managerial Personnel/Director/Promoter/Member of the promoter group]' where ResourceKey ='dis_lbl_17122'
END

IF EXISTS (SELECT * FROM mst_Resource WHERE ResourceKey ='dis_lbl_17125')
BEGIN
	update mst_Resource set ResourceValue='Details of Securities held on appointment of Key Managerial Personnel (KMP) or Director or upon becoming a Promoter or member of the promoter group of a listed company and immediate relatives of such persons and by other such persons as mentioned in Regulation 6(2).', OriginalResourceValue='Details of Securities held on appointment of Key Managerial Personnel (KMP) or Director or upon becoming a Promoter or member of the promoter group of a listed company and immediate relatives of such persons and by other such persons as mentioned in Regulation 6(2).' where ResourceKey ='dis_lbl_17125'
END

IF EXISTS (SELECT * FROM mst_Resource WHERE ResourceKey ='dis_grd_17132')
BEGIN
	update mst_Resource set ResourceValue='Category of Person (KMP/Director or Promoter or member of the promoter group/immediate relative to/others, etc.)', OriginalResourceValue='Category of Person (KMP/Director or Promoter or member of the promoter group/immediate relative to/others, etc.)' where ResourceKey ='dis_grd_17132'
END

IF EXISTS (SELECT * FROM mst_Resource WHERE ResourceKey ='dis_grd_17135')
BEGIN
	update mst_Resource set ResourceValue='Type of securities (For eg.– Shares, Warrant, Convertible Debentures, Rights entitlements, etc.)', OriginalResourceValue='Type of securities (For eg.– Shares, Warrant, Convertible Debentures, Rights entitlements, etc.)' where ResourceKey ='dis_grd_17135'
END

IF EXISTS (SELECT * FROM mst_Resource WHERE ResourceKey ='dis_lbl_17405')
BEGIN
	update mst_Resource set ResourceValue='Details of open interest (OI) in derivatives on the securities of the Company held on appointment of KMP / Director or upon becoming a Promoter / member of Promoter group of a listed company and immediate relatives of such persons and by other such persons as mentioned in Regulation 6(2).', OriginalResourceValue='Details of open interest (OI) in derivatives on the securities of the Company held on appointment of KMP / Director or upon becoming a Promoter / member of Promoter group of a listed company and immediate relatives of such persons and by other such persons as mentioned in Regulation 6(2).' where ResourceKey ='dis_lbl_17405'
END

IF EXISTS (SELECT * FROM mst_Resource WHERE ResourceKey ='dis_grd_17138')
BEGIN
	update mst_Resource set ResourceValue='Open Interest of the Future contracts held at the time of becoming Promoter/member of Promoter group/ appointment of Director/KMP', OriginalResourceValue='Open Interest of the Future contracts held at the time of becoming Promoter/member of Promoter group/ appointment of Director/KMP' where ResourceKey ='dis_grd_17138'
END


IF EXISTS (SELECT * FROM mst_Resource WHERE ResourceKey ='dis_grd_17141')
BEGIN
	update mst_Resource set ResourceValue='Open Interest of the Option Contracts held at the time of becoming Promoter/member of Promoter group/ appointment of Director/KMP', OriginalResourceValue='Open Interest of the Option Contracts held at the time of becoming Promoter/member of Promoter group/ appointment of Director/KMP' where ResourceKey ='dis_grd_17141'
END

--==========================================Form C=====================================================================

IF EXISTS (SELECT * FROM mst_Resource WHERE ResourceKey ='dis_lbl_17180')
BEGIN
	update mst_Resource set ResourceValue='Details of change in holding of Securities of Promoter, Member of the Promoter Group, Designated Person or Director of a listed company and immediate relatives of such persons and other such persons as mentioned in Regulation 6(2)', OriginalResourceValue='Details of change in holding of Securities of Promoter, Member of the Promoter Group, Designated Person or Director of a listed company and immediate relatives of such persons and other such persons as mentioned in Regulation 6(2)' where ResourceKey ='dis_lbl_17180'
END

IF EXISTS (SELECT * FROM mst_Resource WHERE ResourceKey ='dis_grd_17200')
BEGIN
	update mst_Resource set ResourceValue='Date of allotment advice/acquisition of shares/ disposal of shares specify', OriginalResourceValue='Date of allotment advice/acquisition of shares/ disposal of shares specify' where ResourceKey ='dis_grd_17200'
END

IF EXISTS (SELECT * FROM mst_Resource WHERE ResourceKey ='dis_grd_17188')
BEGIN
	update mst_Resource set ResourceValue='Cate-gory of Person (Promoter/ Member of Promoter group/ designated person/KMP / Director/Immediate Relative to/others etc.)', OriginalResourceValue='Cate-gory of Person (Promoter/ Member of Promoter group/ designated person/KMP / Director/Immediate Relative to/others etc.)' where ResourceKey ='dis_grd_17188'
END

IF EXISTS (SELECT * FROM mst_Resource WHERE ResourceKey ='dis_grd_17190')
BEGIN
	update mst_Resource set ResourceValue='Type of securities (For eg.– Shares, Warrant, Convertible Debentures, Rights entitlements, etc.)', OriginalResourceValue='Type of securities (For eg.– shares, Warrant, Convertible Debentures, Rights entitlements, etc.)' where ResourceKey ='dis_grd_17190'
END

IF EXISTS (SELECT * FROM mst_Resource WHERE ResourceKey ='dis_grd_17193')
BEGIN
	update mst_Resource set ResourceValue='Type of Securities (For eg. –Shares,Warrants,Convertible Debentures, Rights entitlements,etc.)', OriginalResourceValue='Type of Securities (For eg. –Shares,Warrants,Convertible Debentures, Rights entitlements,etc.)' where ResourceKey ='dis_grd_17193'
END

IF EXISTS (SELECT * FROM mst_Resource WHERE ResourceKey ='dis_grd_17198')
BEGIN
	update mst_Resource set ResourceValue='Type of Securities (For eg. –Shares,Warrants,Convertible Debentures, Rights entitlements,etc.)', OriginalResourceValue='Type of Securities (For eg. –Shares,Warrants,Convertible Debentures, Rights entitlements,etc.)' where ResourceKey ='dis_grd_17198'
END

IF EXISTS (SELECT * FROM mst_Resource WHERE ResourceKey ='dis_grd_17196')
BEGIN
	update mst_Resource set ResourceValue='Transaction type (Purchase / Sale/Pledge/ Revocation / Invocation/ Others-please specify)', OriginalResourceValue='Transaction type (Purchase / Sale/Pledge/ Revocation / Invocation/ Others-please specify)' where ResourceKey ='dis_grd_17196'
END

IF EXISTS (SELECT * FROM mst_Resource WHERE ResourceKey ='dis_lbl_17407')
BEGIN
	update mst_Resource set ResourceValue='Details of trading in derivatives on the securities of the company by Promoter, member of the promoter group, designated person or Director of a listed company and immediate relatives of such persons and other such persons as mentioned in Regulation 6(2)', OriginalResourceValue='Details of trading in derivatives on the securities of the company by Promoter, member of the promoter group, designated person or Director of a listed company and immediate relatives of such persons and other such persons as mentioned in Regulation 6(2)' where ResourceKey ='dis_lbl_17407'
END


IF EXISTS (SELECT * FROM mst_Resource WHERE ResourceKey ='dis_lbl_17181')
BEGIN
	update mst_Resource set ResourceValue='Note: i. "Securities" shall have the meaning as defined under regulation 2(1)(i) of SEBI (Prohibition of Insider Trading) Regulations, 2015.', OriginalResourceValue='Note: i. "Securities" shall have the meaning as defined under regulation 2(1)(i) of SEBI (Prohibition of Insider Trading) Regulations, 2015.' where ResourceKey ='dis_lbl_17181'
END

IF NOT EXISTS (SELECT * FROM mst_Resource WHERE ResourceId=55500 AND ResourceKey ='dis_lbl_55500')
BEGIN
	INSERT INTO mst_Resource Values(55500,'dis_lbl_55500','  ii. Value of transaction excludes taxes/brokerage/any other charges.','en-US',103009,104002,122052,'ii. Value of transaction excludes taxes/brokerage/any other charges.',1,GETDATE());
END

IF NOT EXISTS (SELECT * FROM mst_Resource WHERE ResourceId=55501 AND ResourceKey ='dis_grd_55501')
BEGIN
	INSERT INTO mst_Resource Values(55501,'dis_grd_55501','Exchange on which the trade was executed','en-US',103009,104002,122052,'Exchange on which the trade was executed',1,GETDATE());
END

IF NOT EXISTS(SELECT *  FROM com_GridHeaderSetting WHERE GridTypeCodeId=114046 AND ResourceKey='dis_grd_55501')
BEGIN
	Insert Into com_GridHeaderSetting values(114046,'dis_grd_55501',1,190000,0,155001,NULL,NULL)

END

--==========================================Form D=================================================================

IF EXISTS (SELECT * FROM mst_Resource WHERE ResourceKey ='dis_grd_17212')
BEGIN
	update mst_Resource set ResourceValue='Type of Securities (For eg. –Shares,Warrants,Convertible Debentures, Rights entitlements,etc.)', OriginalResourceValue='Type of Securities (For eg. –Shares,Warrants,Convertible Debentures, Rights entitlements,etc.)' where ResourceKey ='dis_grd_17212'
END

IF EXISTS (SELECT * FROM mst_Resource WHERE ResourceKey ='dis_grd_17215')
BEGIN
	update mst_Resource set ResourceValue='Type of Securities (For eg. –Shares,Warrants,Convertible Debentures, Rights entitlements,etc.)', OriginalResourceValue='Type of Securities (For eg. –Shares,Warrants,Convertible Debentures, Rights entitlements,etc.)' where ResourceKey ='dis_grd_17215'
END

IF EXISTS (SELECT * FROM mst_Resource WHERE ResourceKey ='dis_grd_17218')
BEGIN
	update mst_Resource set ResourceValue='Transaction type (Purchase / Sale/ Pledge/ Revocation / Invocation/ Others-please specify)', OriginalResourceValue='Transaction type (Purchase / Sale/ Pledge/ Revocation / Invocation/ Others-please specify)' where ResourceKey ='dis_grd_17218'
END


IF EXISTS (SELECT * FROM mst_Resource WHERE ResourceKey ='dis_grd_17220')
BEGIN
	update mst_Resource set ResourceValue='Type of Securities (For eg. –Shares,Warrants,Convertible Debentures, Rights entitlements,etc.)', OriginalResourceValue='Type of Securities (For eg. –Shares,Warrants,Convertible Debentures, Rights entitlements,etc.)' where ResourceKey ='dis_grd_17220'
END

IF EXISTS (SELECT * FROM mst_Resource WHERE ResourceKey ='dis_grd_17222')
BEGIN
	update mst_Resource set ResourceValue='Date of allotment advice/acquisition of shares/ disposal of shares specify', OriginalResourceValue='Date of allotment advice/acquisition of shares/ disposal sale of shares specify' where ResourceKey ='dis_grd_17222'
END


IF NOT EXISTS (SELECT * FROM mst_Resource WHERE ResourceId=55502 AND  ResourceKey ='dis_grd_55502')
BEGIN
	INSERT INTO mst_Resource Values(55502,'dis_grd_55502','Exchange on which the trade was executed','en-US',103009,104002,122052,'Exchange on which the trade was executed',1,GETDATE());
END

IF NOT EXISTS(SELECT *  FROM com_GridHeaderSetting WHERE GridTypeCodeId=114047 AND ResourceKey='dis_grd_55502')
BEGIN
	INSERT INTO com_GridHeaderSetting VALUES(114047,'dis_grd_55502',1,190000,0,155001,NULL,NULL)
END

IF NOT EXISTS (SELECT *  FROM mst_Resource WHERE ResourceId=55503 AND ResourceKey ='dis_lbl_55503')
BEGIN
	INSERT INTO mst_Resource Values(55503,'dis_lbl_55503','ii. Value of transaction excludes taxes/brokerage/any other charges','en-US',103009,104002,122052,'ii. Value of transaction excludes taxes/brokerage/any other charges',1,GETDATE());
END

IF EXISTS (SELECT * FROM mst_Resource WHERE ResourceKey ='dis_lbl_17185')
BEGIN
	update mst_Resource set ResourceValue='Note: i. "Securities" shall have the meaning as defined under regulation 2(1)(i) of SEBI (Prohibition of Insider Trading) Regulations, 2015.', OriginalResourceValue='Note: i. "Securities" shall have the meaning as defined under regulation 2(1)(i) of SEBI (Prohibition of Insider Trading) Regulations, 2015.' where ResourceKey ='dis_lbl_17185'
END


IF EXISTS (SELECT * FROM mst_Resource WHERE ResourceKey ='dis_lbl_17409')
BEGIN
	update mst_Resource set ResourceValue='Details of trading in derivatives on the securities by other connected persons as identified by the company', OriginalResourceValue='Details of trading in derivatives on the securities by other connected persons as identified by the company' where ResourceKey ='dis_lbl_17409'
END

