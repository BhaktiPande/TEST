



/*Update ScreenCodeId*/
UPDATE mst_Resource SET ScreenCodeId = 122001 -- CO User List
WHERE ResourceKey IN ('usr_grd_11065', 'usr_grd_11066', 'usr_grd_11067', 'usr_grd_11068', 'usr_grd_11069', 'usr_grd_11070', 'usr_grd_11071', 'usr_grd_11072',
'usr_btn_11232','usr_ttl_11233')


UPDATE mst_Resource SET ScreenCodeId = 122002 -- CO User Details
WHERE ResourceKey IN ('usr_msg_11030','usr_msg_11031','usr_ttl_11234')


UPDATE mst_Resource SET ScreenCodeId = 122003 -- Insdier User List
WHERE ResourceKey IN ('usr_grd_11074', 'usr_grd_11075', 'usr_grd_11076', 'usr_grd_11077', 'usr_grd_11078', 'usr_grd_11079', 'usr_grd_11080', 'usr_grd_11081', 'usr_grd_11082', 'usr_grd_11083', 'usr_grd_11084','usr_btn_11236','usr_btn_11237','usr_ttl_11235', 'usr_ttl_11275')


UPDATE mst_Resource SET ScreenCodeId = 122004 -- Insdier User Details
WHERE ResourceKey IN ('usr_msg_11024','usr_msg_11028','usr_msg_11032','usr_ttl_11238','usr_ttl_11239','usr_ttl_11240','usr_ttl_11250','usr_ttl_11251',
'usr_msg_11263', 'usr_msg_11264', 'usr_msg_11265')


UPDATE mst_Resource SET ScreenCodeId = 122005 -- Role List
WHERE ResourceKey IN ('usr_grd_12004','usr_grd_12005','usr_grd_12006','usr_grd_12007','usr_grd_12025','usr_btn_12034','usr_btn_12035','usr_msg_12003','usr_ttl_12033')


UPDATE mst_Resource SET ScreenCodeId = 122006 -- Role Details
WHERE ResourceKey IN ('usr_msg_12001','usr_msg_12002','usr_msg_12008','usr_msg_12009','usr_msg_12026','usr_msg_12027','usr_ttl_12036',
'usr_msg_12010','usr_msg_12016','usr_ttl_12037','usr_lbl_12038','usr_lbl_12039','usr_lbl_12040','usr_lbl_12041','usr_lbl_12042')


UPDATE mst_Resource SET ScreenCodeId = 122007 -- DMAT List
WHERE ResourceKey IN ('usr_grd_11094','usr_grd_11095','usr_grd_11096','usr_grd_11097','usr_grd_11098','usr_btn_11241','usr_msg_11040')


UPDATE mst_Resource SET ScreenCodeId = 122008 -- DMAT Details
WHERE ResourceKey IN ('usr_msg_11059','usr_msg_11060','usr_msg_11061','usr_msg_11203','usr_ttl_11242','usr_lbl_11205','usr_msg_11036','usr_msg_11037','usr_msg_11038',
'usr_lbl_11206','usr_lbl_11207','usr_lbl_11208','usr_lbl_11209', 'usr_lbl_11254', 'usr_lbl_11284')


UPDATE mst_Resource SET ScreenCodeId = 122009 -- Document List
WHERE ResourceKey IN ('usr_grd_11099','usr_grd_11200','usr_grd_11201','usr_btn_11244','usr_msg_11042')


UPDATE mst_Resource SET ScreenCodeId = 122010 -- Document Details
WHERE ResourceKey IN ('usr_lbl_11210','usr_msg_11041','usr_msg_11043','usr_msg_11044','usr_msg_11062','usr_msg_11063','usr_msg_11064','usr_msg_11204','usr_ttl_11245')


UPDATE mst_Resource SET ScreenCodeId = 122011 -- Company List
WHERE ResourceKey IN ('cmp_grd_13001','cmp_grd_13002','cmp_grd_13003','cmp_grd_13004','cmp_grd_13006', 'cmp_btn_13085','cmp_ttl_13084','cmp_msg_13005')


UPDATE mst_Resource SET ScreenCodeId = 122012 -- Company Details
WHERE ResourceKey IN ('cmp_lbl_13060','cmp_lbl_13061','cmp_lbl_13062','cmp_lbl_13063','cmp_ttl_13086',
'cmp_msg_13007','cmp_msg_13008','cmp_msg_13009','cmp_msg_13010','cmp_msg_13011','cmp_msg_13082','cmp_msg_13064',
'cmp_msg_13092', 'cmp_msg_13093', 'cmp_msg_13094', 'cmp_msg_13095', 'cmp_ttl_13096', 'cmp_msg_13105')


UPDATE mst_Resource SET ScreenCodeId = 122013 -- Other masters List
WHERE ResourceKey IN ('mst_grd_10002','mst_grd_10003','mst_grd_10004','mst_grd_10005','mst_grd_10006','mst_msg_10007')


UPDATE mst_Resource SET ScreenCodeId = 122014 -- Other masters Details
WHERE ResourceKey IN ('mst_btn_10036','mst_lbl_10019','mst_lbl_10020','mst_lbl_10021','mst_lbl_10022','mst_lbl_10023','mst_lbl_10024','mst_lbl_10029',
'mst_lbl_10030','mst_lbl_10031','mst_lbl_10032','mst_lbl_10033','mst_lbl_10034','mst_lbl_10035','mst_msg_10008','mst_msg_10009','mst_msg_10010',
'mst_msg_10011','mst_msg_10012','mst_msg_10013','mst_ttl_10043', 'mst_ttl_10044', 'mst_msg_10047', 'mst_msg_10048', 'mst_msg_10051')


UPDATE mst_Resource SET ScreenCodeId = 122015 -- Relatives List
WHERE ResourceKey IN ('usr_grd_11086','usr_grd_11087','usr_grd_11088','usr_grd_11089','usr_grd_11090','usr_grd_11091','usr_btn_11247')


UPDATE mst_Resource SET ScreenCodeId = 122016 -- Relatives Details
WHERE ResourceKey IN ('usr_msg_11092','usr_msg_11093','usr_ttl_11248')


UPDATE mst_Resource SET ScreenCodeId = 122017 -- Face Value List List
WHERE ResourceKey IN ('cmp_grd_13013','cmp_grd_13014','cmp_grd_13015','cmp_msg_13012')


UPDATE mst_Resource SET ScreenCodeId = 122018 -- Face Value Details
WHERE ResourceKey IN ('cmp_lbl_13065','cmp_lbl_13066','cmp_lbl_13067','cmp_ttl_13087',
'cmp_msg_13035','cmp_msg_13036','cmp_msg_13037','cmp_msg_13038','cmp_msg_13039','cmp_msg_13068','cmp_msg_13069')
OR (SUBSTRING(ResourceKey, len(ResourceKey) - 4, 5) <= 13111
AND SUBSTRING(ResourceKey, len(ResourceKey) - 4, 5) >= 13110)

UPDATE mst_Resource SET ScreenCodeId = 122019 -- Authorized capital List
WHERE ResourceKey IN ('cmp_grd_13017','cmp_grd_13018','cmp_msg_13016')


UPDATE mst_Resource SET ScreenCodeId = 122020 -- Authorized capital Details
WHERE ResourceKey IN ('cmp_lbl_13070','cmp_ttl_13088','cmp_msg_13040','cmp_msg_13041','cmp_msg_13052','cmp_msg_13053','cmp_msg_13054')


UPDATE mst_Resource SET ScreenCodeId = 122021 -- Paid Up & Subscribed Share Capital List
WHERE ResourceKey IN ('cmp_grd_13020','cmp_grd_13021','cmp_msg_13019')


UPDATE mst_Resource SET ScreenCodeId = 122022 -- Paid Up & Subscribed Share Capital Details
WHERE ResourceKey IN ('cmp_ttl_13089','cmp_msg_13055','cmp_msg_13056','cmp_msg_13057','cmp_msg_13058','cmp_msg_13059')
OR (SUBSTRING(ResourceKey, len(ResourceKey) - 4, 5) <= 13115
AND SUBSTRING(ResourceKey, len(ResourceKey) - 4, 5) >= 13114)


UPDATE mst_Resource SET ScreenCodeId = 122023 -- Listing Details List
WHERE ResourceKey IN ('cmp_grd_13023','cmp_grd_13024','cmp_grd_13025','cmp_msg_13022')


UPDATE mst_Resource SET ScreenCodeId = 122024 -- Listing Details Details
WHERE ResourceKey IN ('cmp_lbl_13071','cmp_lbl_13073','cmp_lbl_13074','cmp_ttl_13090',
'cmp_msg_13047','cmp_msg_13048','cmp_msg_13049','cmp_msg_13050','cmp_msg_13051','cmp_msg_13072')


UPDATE mst_Resource SET ScreenCodeId = 122025 -- Compliance Officers List
WHERE ResourceKey IN ('cmp_grd_13027','cmp_grd_13028','cmp_grd_13029','cmp_grd_13030','cmp_grd_13031','cmp_grd_13032','cmp_grd_13033','cmp_grd_13034','cmp_msg_13026')


UPDATE mst_Resource SET ScreenCodeId = 122026 -- Compliance Officers Details
WHERE ResourceKey IN ('cmp_lbl_13075','cmp_lbl_13076','cmp_lbl_13077','cmp_lbl_13078','cmp_lbl_13079','cmp_lbl_13080','cmp_ttl_13091',
'cmp_msg_13042','cmp_msg_13043','cmp_msg_13044','cmp_msg_13045','cmp_msg_13046','cmp_msg_13081','cmp_msg_13083')
OR (SUBSTRING(ResourceKey, len(ResourceKey) - 4, 5) <= 13119
AND SUBSTRING(ResourceKey, len(ResourceKey) - 4, 5) >= 13118)


UPDATE mst_Resource SET ScreenCodeId = 122027 -- Delegation List
WHERE ResourceKey IN ('usr_grd_12012','usr_grd_12013','usr_grd_12014','usr_grd_12015','usr_msg_12011', 'usr_ttl_12050')


UPDATE mst_Resource SET ScreenCodeId = 122028 -- Delegation Details
WHERE ResourceKey IN ('usr_msg_12017','usr_msg_12018','usr_msg_12019','usr_msg_12020','usr_msg_12021','usr_msg_12022','usr_msg_12023','usr_msg_12024','usr_msg_12031','usr_msg_12032', 'usr_ttl_12051')


UPDATE mst_Resource SET ScreenCodeId = 122029 -- DMAT Account Holder List
WHERE ResourceKey IN ('usr_grd_11213','usr_grd_11214','usr_grd_11215','usr_btn_11243','usr_msg_11216')


UPDATE mst_Resource SET ScreenCodeId = 122030 -- DMAT Account Holder Details
WHERE ResourceKey IN ('usr_lbl_11223','usr_lbl_11225','usr_msg_11218','usr_msg_11219','usr_msg_11220','usr_msg_11221','usr_msg_11222')


UPDATE mst_Resource SET ScreenCodeId = 122031 -- Resource Messages List
WHERE ResourceKey IN ('mst_grd_10015','mst_grd_10016','mst_grd_10017','mst_grd_10018','mst_grd_10028','mst_msg_10014','mst_ttl_10037')


UPDATE mst_Resource SET ScreenCodeId = 122032 -- Resource Message Details
WHERE ResourceKey IN ('mst_msg_10025','mst_msg_10026','mst_msg_10027','mst_ttl_10038','mst_lbl_10039','mst_lbl_10040','mst_lbl_10041','mst_msg_10042',
'mst_lbl_10045', 'mst_lbl_10046', 'mst_msg_10049', 'mst_lbl_10050')


UPDATE mst_Resource SET ScreenCodeId = 122033 -- Employee Separation List
WHERE ResourceKey IN (/*'usr_grd_11074','usr_grd_11075','usr_grd_11076','usr_grd_11077','usr_grd_11078','usr_grd_11079','usr_grd_11080','usr_grd_11081',
'usr_grd_11082','usr_grd_11083','usr_grd_11084',*/'usr_grd_11228','usr_grd_11229','usr_grd_11230')


UPDATE mst_Resource SET ScreenCodeId = 122034 -- Common for application
WHERE ResourceKey IN ('com_btn_14001','com_btn_14002','com_btn_14005','com_btn_14006','com_btn_14007','com_btn_14008','com_btn_14009','com_btn_14010',
'com_btn_14011','com_btn_14013','com_btn_14014','com_btn_14015','com_btn_14016','com_btn_14017','com_btn_14018','com_btn_14019',
'com_lbl_14003','com_lbl_14004', 'com_lbl_14012', 'com_msg_14020', 'com_lbl_14021', 'com_lbl_14022', 'com_btn_14023', 'com_msg_14024','com_btn_14025',
'com_msg_14026')


UPDATE mst_Resource SET ScreenCodeId = 122035 -- Trading Window Event - Financial period
WHERE ResourceKey IN ('rul_grd_15001','rul_grd_15002','rul_grd_15003','rul_grd_15004','rul_grd_15005','rul_grd_15006','rul_grd_15007','rul_msg_15008',
'rul_msg_15018', 'rul_lbl_15030', 'rul_ttl_15031', 'rul_lbl_15099', 'rul_msg_15380')


UPDATE mst_Resource SET ScreenCodeId = 122036 -- Transaction details list
WHERE ResourceKey IN ('tra_grd_16001', 'tra_grd_16002', 'tra_grd_16003', 'tra_grd_16004', 'tra_grd_16005', 'tra_grd_16006', 'tra_grd_16007', 'tra_grd_16008', 'tra_grd_16009', 'tra_grd_16010',
'tra_grd_16011', 'tra_grd_16012', 'tra_grd_16013', 'tra_grd_16014', 'tra_grd_16015', 'tra_msg_16016',
'tra_msg_16017', 'tra_msg_16018', 'tra_msg_16019', 'tra_msg_16020', 'tra_msg_16021',
'tra_lbl_16022', 'tra_lbl_16023', 'tra_lbl_16024', 'tra_lbl_16025', 'tra_lbl_16026', 'tra_lbl_16027', 'tra_lbl_16028', 'tra_lbl_16029', 
'tra_lbl_16030', 'tra_lbl_16031', 'tra_lbl_16032', 'tra_lbl_16033', 'tra_lbl_16034', 'tra_lbl_16035', 'tra_lbl_16036', 'tra_lbl_16037', 'tra_lbl_16038',
'tra_msg_16091','tra_msg_16092', 'tra_msg_16093', 'tra_msg_16187')

UPDATE mst_Resource 
SET ScreenCodeId = 122036 
WHERE ((SUBSTRING(ResourceKey, len(ResourceKey) - 4, 5) <= 16152
AND SUBSTRING(ResourceKey, len(ResourceKey) - 4, 5) >= 16094))
OR (SUBSTRING(ResourceKey, len(ResourceKey) - 4, 5) <= 16189
AND SUBSTRING(ResourceKey, len(ResourceKey) - 4, 5) >= 16179)


UPDATE mst_Resource SET ScreenCodeId = 122037 -- Policy Document List
WHERE ResourceKey IN ('rul_grd_15032', 'rul_grd_15033', 'rul_grd_15034', 'rul_grd_15035', 'rul_grd_15036', 'rul_grd_15037', 'rul_grd_15038', 'rul_grd_15039', 'rul_msg_15040',
'rul_msg_15100', 'rul_msg_15101')

UPDATE mst_Resource SET ScreenCodeId = 122038 -- Policy Document Details
WHERE ResourceKey IN ('rul_msg_15041', 'rul_msg_15042', 'rul_msg_15043', 'rul_msg_15044', 'rul_msg_15045',
'rul_msg_15062', 'rul_msg_15063', 'rul_msg_15064', 'rul_msg_15065', 'rul_msg_15066', 'rul_msg_15067',
'rul_lbl_15107','rul_lbl_15108','rul_lbl_15109','rul_lbl_15110','rul_lbl_15111', 'rul_lbl_15112', 'rul_lbl_15113', 'rul_lbl_15114','rul_lbl_15115','rul_lbl_15116','rul_lbl_15117','rul_lbl_15118','rul_lbl_15119',
'rul_ttl_15120', 'rul_ttl_15121', 'rul_btn_15122','rul_btn_15123','rul_btn_15124','rul_msg_15125','rul_msg_15126','rul_msg_15127','rul_msg_15128',
'rul_lbl_15411', 'rul_msg_15412', 'rul_msg_15413', 'rul_msg_15414')

UPDATE mst_Resource SET ScreenCodeId = 122039 -- Trading Policy List
WHERE ResourceKey IN ('rul_grd_15052','rul_grd_15053', 'rul_grd_15054', 'rul_grd_15055' ,'rul_grd_15056', 'rul_msg_15057',
'rul_msg_15102', 'rul_msg_15103', 'rul_msg_15104', 'rul_grd_15105','rul_grd_15106', 'rul_msg_15396', 'rul_msg_15397')

UPDATE mst_Resource SET ScreenCodeId = 122039 
WHERE SUBSTRING(ResourceKey, len(ResourceKey) - 4, 5) <= 15220
AND SUBSTRING(ResourceKey, len(ResourceKey) - 4, 5) >= 15217

UPDATE mst_Resource SET ScreenCodeId = 122040 -- Trading Policy Details
WHERE ResourceKey IN ('rul_msg_15058', 'rul_msg_15059', 'rul_msg_15060', 'rul_msg_15061',
'rul_msg_15068','rul_msg_15069','rul_msg_15070','rul_msg_15071','rul_msg_15072','rul_msg_15073','rul_msg_15074','rul_msg_15075','rul_msg_15076','rul_msg_15077',
'rul_msg_15078','rul_msg_15079','rul_msg_15080','rul_msg_15081','rul_msg_15082','rul_msg_15083','rul_msg_15084','rul_msg_15085','rul_msg_15086','rul_msg_15087',
'rul_msg_15088','rul_msg_15089','rul_msg_15090','rul_msg_15091','rul_msg_15092','rul_msg_15093','rul_msg_15094','rul_msg_15095','rul_msg_15096','rul_msg_15097',
'rul_msg_15098', 'rul_btn_15393', 'rul_btn_15394')

UPDATE mst_Resource SET ScreenCodeId = 122040 
WHERE SUBSTRING(ResourceKey, len(ResourceKey) - 4, 5) <= 15216
AND SUBSTRING(ResourceKey, len(ResourceKey) - 4, 5) >= 15139

UPDATE mst_Resource SET ScreenCodeId = 122041 -- Applicability
WHERE ResourceKey IN ('rul_grd_15046','rul_grd_15047', 'rul_grd_15048', 'rul_grd_15049', 'rul_grd_15050', 'rul_msg_15051',
'rul_msg_15129','rul_grd_15130','rul_grd_15131','rul_msg_15132','rul_msg_15133',
'rul_grd_15134','rul_grd_15135','rul_grd_15136','rul_msg_15137','rul_msg_15138',
'rul_grd_15339','rul_grd_15340','rul_grd_15341','rul_msg_15342', 'rul_msg_15226', 'rul_msg_15227',
'rul_grd_15255','rul_grd_15256','rul_grd_15257','rul_msg_15258','rul_msg_15259')


UPDATE mst_Resource SET ScreenCodeId = 122039 -- Trading Policy History List
WHERE ResourceKey IN ('rul_grd_15221','rul_grd_15222', 'rul_grd_15223', 'rul_grd_15224' ,'rul_grd_15225')


--Trading Policy update for new keys added on 17-Apr-2015
UPDATE mst_Resource 
SET ScreenCodeId = 122040 
WHERE (SUBSTRING(ResourceKey, len(ResourceKey) - 4, 5) <= 15244
AND SUBSTRING(ResourceKey, len(ResourceKey) - 4, 5) >= 15228)
OR (SUBSTRING(ResourceKey, len(ResourceKey) - 4, 5) <= 15364
AND SUBSTRING(ResourceKey, len(ResourceKey) - 4, 5) >= 15361)
OR (SUBSTRING(ResourceKey, len(ResourceKey) - 4, 5) <= 15379
AND SUBSTRING(ResourceKey, len(ResourceKey) - 4, 5) >= 15366)
OR ResourceKey IN ('rul_msg_15381', 'rul_msg_15395')
OR (SUBSTRING(ResourceKey, len(ResourceKey) - 4, 5) <= 15388
AND SUBSTRING(ResourceKey, len(ResourceKey) - 4, 5) >= 15387)

--Update for Company related new keys added on 17-Apr-2015
UPDATE mst_Resource 
SET ScreenCodeId = 122012 
WHERE ResourceKey in('cmp_msg_13097')
OR (SUBSTRING(ResourceKey, len(ResourceKey) - 4, 5) <= 13109
AND SUBSTRING(ResourceKey, len(ResourceKey) - 4, 5) >= 13107)

UPDATE mst_Resource 
SET ScreenCodeId = 122018 
WHERE ResourceKey in('cmp_msg_13098','cmp_msg_13102', 'cmp_msg_13106')


UPDATE mst_Resource 
SET ScreenCodeId = 122020 
WHERE ResourceKey in('cmp_msg_13099','cmp_msg_13100','cmp_msg_13101')
OR (SUBSTRING(ResourceKey, len(ResourceKey) - 4, 5) <= 13113
AND SUBSTRING(ResourceKey, len(ResourceKey) - 4, 5) >= 13112)
	
UPDATE mst_Resource 
SET ScreenCodeId = 122024 
WHERE ResourceKey in('cmp_msg_13103','cmp_msg_13104')
OR (SUBSTRING(ResourceKey, len(ResourceKey) - 4, 5) <= 13117
AND SUBSTRING(ResourceKey, len(ResourceKey) - 4, 5) >= 13116)


UPDATE mst_Resource SET ScreenCodeId = 122042 -- Trading window event calender
WHERE ResourceKey IN ('rul_msg_15343')
OR (SUBSTRING(ResourceKey, len(ResourceKey) - 4, 5) <= 15386
AND SUBSTRING(ResourceKey, len(ResourceKey) - 4, 5) >= 15382)

UPDATE mst_Resource SET ScreenCodeId = 122038 -- Policy Document Details
WHERE ResourceKey IN('rul_lbl_15245', 'rul_lbl_15246','rul_lbl_15247', 'rul_lbl_15248','rul_lbl_15249', 'rul_lbl_15250', 'rul_btn_15251',
'rul_msg_15252','rul_msg_15253','rul_msg_15254')

UPDATE mst_Resource SET ScreenCodeId = 122043 -- Transaction-->Policy Document view-agree user status list
WHERE ResourceKey IN ('tra_grd_16039', 'tra_grd_16040', 'tra_grd_16041','tra_grd_16042','tra_grd_16043','tra_msg_16044',
'tra_grd_16045','tra_grd_16046','tra_grd_16047','tra_grd_16048','tra_msg_16049',
'tra_grd_16050','tra_grd_16051','tra_grd_16052','tra_grd_16053','tra_grd_16054','tra_msg_16055',
'tra_lbl_16056','tra_lbl_16057','tra_lbl_16058','tra_lbl_16059','tra_lbl_16060','tra_lbl_16061','tra_lbl_16062', 'tra_lbl_16063','tra_lbl_16064','tra_lbl_16065','tra_lbl_16066','tra_lbl_16067','tra_lbl_16068','tra_lbl_16069')

UPDATE mst_Resource SET ScreenCodeId = 122044 -- Disclosure screen
WHERE ResourceKey IN ('dis_btn_17005', 'dis_btn_17006', 'dis_btn_17007', 'dis_btn_17009', 'dis_lbl_17001', 'dis_lbl_17002', 'dis_lbl_17003', 'dis_lbl_17004', 'dis_msg_17008', 'dis_msg_17013')
OR (SUBSTRING(ResourceKey, len(ResourceKey) - 4, 5) <= 17324
AND SUBSTRING(ResourceKey, len(ResourceKey) - 4, 5) >= 17320)


UPDATE mst_Resource SET ScreenCodeId = 122045 -- Trading window event - other
WHERE ResourceKey IN ('rul_btn_15027', 'rul_msg_15028', 'rul_msg_15029', 'rul_msg_15015', 'rul_msg_15016', 'rul_msg_15017', 
'rul_grd_15014', 'rul_grd_15013', 'rul_grd_15012', 'rul_grd_15011', 'rul_grd_15010', 'rul_grd_15009',
'rul_lbl_15019', 'rul_lbl_15020', 'rul_lbl_15021', 'rul_lbl_15022', 'rul_lbl_15023', 'rul_lbl_15024', 'rul_lbl_15025', 'rul_lbl_15026',
'rul_ttl_15349', 'rul_ttl_15350', 'rul_btn_15351', 'rul_lbl_15352', 'rul_lbl_15353', 'rul_lbl_15354', 'rul_lbl_15355', 'rul_lbl_15356',
'rul_lbl_15357', 'rul_lbl_15358', 'rul_lbl_15359', 'rul_lbl_15360', 'rul_msg_15260', 'rul_msg_15261')
OR (SUBSTRING(ResourceKey, len(ResourceKey) - 4, 5) <= 15408
AND SUBSTRING(ResourceKey, len(ResourceKey) - 4, 5) >= 15407)

UPDATE mst_Resource 
SET ScreenCodeId = 122046
WHERE (SUBSTRING(ResourceKey, len(ResourceKey) - 4, 5) <= 17029
AND SUBSTRING(ResourceKey, len(ResourceKey) - 4, 5) >= 17014)
OR (SUBSTRING(ResourceKey, len(ResourceKey) - 4, 5) <= 17076
AND SUBSTRING(ResourceKey, len(ResourceKey) - 4, 5) >= 17063)
OR (SUBSTRING(ResourceKey, len(ResourceKey) - 4, 5) <= 17304
AND SUBSTRING(ResourceKey, len(ResourceKey) - 4, 5) >= 17303)
OR (SUBSTRING(ResourceKey, len(ResourceKey) - 4, 5) <= 17310
AND SUBSTRING(ResourceKey, len(ResourceKey) - 4, 5) >= 17309)
OR ResourceKey IN ('dis_grd_17270', 'dis_btn_17333')


UPDATE mst_Resource 
SET ScreenCodeId = 122047 -- Period End Disclosure Status List
WHERE ResourceKey IN ('dis_grd_17010', 'dis_grd_17011', 'dis_grd_17012', 'dis_grd_17030', 'dis_grd_17031', 'dis_grd_17032', 'dis_ttl_17055', 'dis_lbl_17056')


UPDATE mst_Resource 
SET ScreenCodeId = 122048 -- Period End Summary
WHERE ResourceKey IN ('dis_grd_17033', 'dis_grd_17034', 'dis_grd_17035', 'dis_grd_17036', 'dis_grd_17037', 'dis_grd_17038', 'dis_grd_17039', 'dis_grd_17040', 'dis_msg_17041',
'dis_msg_17042', 'dis_msg_17043', 'dis_msg_17044', 'dis_msg_17045', 'dis_msg_17046', 'dis_msg_17047', 'dis_msg_17048', 'dis_msg_17049', 'dis_msg_17050',
'dis_msg_17051', 'dis_msg_17052', 'dis_msg_17053', 'dis_msg_17054', 'dis_ttl_17057', 'dis_lbl_17058', 'dis_lbl_17059', 'dis_msg_17060', 'dis_lbl_17061', 'dis_btn_17062',
'dis_lbl_17170', 'dis_lbl_17171', 'dis_msg_17174', 'dis_msg_17327', 'dis_msg_17328', 'dis_msg_17329', 'dis_msg_17331',
'dis_msg_17335', 'dis_msg_17336', 'dis_msg_17337', 'dis_msg_17338')

UPDATE mst_Resource SET ScreenCodeId = 122049 -- Template master list
WHERE ResourceKey IN ('tra_grd_16070','tra_grd_16071','tra_grd_16072','tra_grd_16073','tra_msg_16074','tra_msg_16076')

UPDATE mst_Resource SET ScreenCodeId = 122050 -- Template master details
WHERE ResourceKey IN ('tra_msg_16075','tra_msg_16077','tra_msg_16078','tra_msg_16079',
'tra_msg_16080', 'tra_msg_16081', 'tra_msg_16082','tra_msg_16083','tra_msg_16084','tra_msg_16085','tra_msg_16086','tra_msg_16087','tra_msg_16088','tra_msg_16089','tra_msg_16090',
'tra_msg_16153','tra_lbl_16154','tra_lbl_16155','tra_lbl_16156','tra_lbl_16157','tra_lbl_16158','tra_lbl_16159','tra_lbl_16160','tra_lbl_16161','tra_lbl_16162','tra_lbl_16163','tra_lbl_16164','tra_lbl_16165',
'tra_ttl_16166','tra_ttl_16167','tra_btn_16168','tra_lbl_16169','tra_lbl_16170','tra_lbl_16171','tra_msg_16172','tra_msg_16173','tra_msg_16174','tra_msg_16175','tra_msg_16176',
'tra_msg_16177','tra_msg_16178')


UPDATE mst_Resource 
SET ScreenCodeId = 122051 -- PreClearance Request Details
WHERE (SUBSTRING(ResourceKey, len(ResourceKey) - 4, 5) <= 17100
AND SUBSTRING(ResourceKey, len(ResourceKey) - 4, 5) >= 17077)
OR (SUBSTRING(ResourceKey, len(ResourceKey) - 4, 5) <= 17243
AND SUBSTRING(ResourceKey, len(ResourceKey) - 4, 5) >= 17231)
OR (SUBSTRING(ResourceKey, len(ResourceKey) - 4, 5) <= 17268
AND SUBSTRING(ResourceKey, len(ResourceKey) - 4, 5) >= 17265)
OR (SUBSTRING(ResourceKey, len(ResourceKey) - 4, 5) <= 17343
AND SUBSTRING(ResourceKey, len(ResourceKey) - 4, 5) >= 17342)
OR ResourceKey IN ('dis_lbl_17271', 'dis_msg_17307', 'dis_msg_17319', 'dis_msg_17326', 'dis_msg_17330', 'dis_msg_17332')


UPDATE mst_Resource SET ScreenCodeId = 122052 -- Transaction Letter
WHERE ResourceKey IN ('dis_ttl_17101','dis_ttl_17102','dis_ttl_17103','dis_lbl_17104','dis_lbl_17105','dis_lbl_17106','dis_lbl_17107','dis_lbl_17108',
'dis_lbl_17109','dis_lbl_17110','dis_btn_17111','dis_msg_17112','dis_msg_17113','dis_msg_17114','dis_msg_17115','dis_msg_17116',
'dis_lbl_17117','dis_lbl_17118','dis_lbl_17119',
'dis_lbl_17120','dis_lbl_17121','dis_lbl_17122','dis_lbl_17123','dis_lbl_17124','dis_lbl_17125','dis_lbl_17126','dis_lbl_17127','dis_lbl_17128','dis_lbl_17129','dis_lbl_17130',
'dis_grd_17131','dis_grd_17132','dis_grd_17133','dis_grd_17134','dis_grd_17135','dis_grd_17136','dis_grd_17137','dis_grd_17138','dis_grd_17139','dis_grd_17140',
'dis_grd_17141','dis_grd_17142','dis_grd_17143',
'dis_lbl_17175', 'dis_lbl_17176', 'dis_lbl_17177', 'dis_lbl_17178', 'dis_lbl_17179',
'dis_lbl_17180', 'dis_lbl_17181', 'dis_lbl_17182', 'dis_lbl_17183', 'dis_lbl_17184', 'dis_lbl_17185', 'dis_lbl_17186',
'dis_msg_17244', 'dis_msg_17245', 'dis_msg_17246')
UPDATE mst_Resource 
SET ScreenCodeId = 122052 -- Period End disclosure list for CO
WHERE (SUBSTRING(ResourceKey, len(ResourceKey) - 4, 5) <= 17230
AND SUBSTRING(ResourceKey, len(ResourceKey) - 4, 5) >= 17187)
OR (SUBSTRING(ResourceKey, len(ResourceKey) - 4, 5) <= 17341
AND SUBSTRING(ResourceKey, len(ResourceKey) - 4, 5) >= 17339)
OR (SUBSTRING(ResourceKey, len(ResourceKey) - 4, 5) <= 17346
AND SUBSTRING(ResourceKey, len(ResourceKey) - 4, 5) >= 17344)

UPDATE mst_Resource SET ScreenCodeId = 122053 -- Communication Rule list
WHERE ResourceKey IN ('cmu_grd_18001','cmu_grd_18002','cmu_grd_18003','cmu_grd_18004','cmu_grd_18005','cmu_grd_18006',
'cmu_msg_18017','cmu_ttl_18030','cmu_btn_18032')

UPDATE mst_Resource SET ScreenCodeId = 122054 -- Communication Rule details
WHERE ResourceKey IN ('cmu_grd_18007','cmu_grd_18008','cmu_grd_18009','cmu_grd_18010','cmu_grd_18011','cmu_msg_18015',
'cmu_msg_18016','cmu_msg_18018','cmu_msg_18019','cmu_msg_18020','cmu_lbl_18021','cmu_lbl_18022','cmu_lbl_18023','cmu_lbl_18024','cmu_lbl_18025','cmu_lbl_18026','cmu_lbl_18027','cmu_lbl_18028','cmu_lbl_18029',
'cmu_ttl_18031','cmu_btn_18033','cmu_msg_18051','cmu_msg_18052','cmu_msg_18053','cmu_msg_18054','cmu_msg_18055','cmu_lbl_18056','cmu_lbl_18057','cmu_lbl_18058','cmu_lbl_18059','cmu_msg_18061', 'cmu_msg_18062')



UPDATE mst_Resource 
SET ScreenCodeId = 122055 -- Period End disclosure list for CO
WHERE ((SUBSTRING(ResourceKey, len(ResourceKey) - 4, 5) <= 17169
AND SUBSTRING(ResourceKey, len(ResourceKey) - 4, 5) >= 17144)
OR ResourceKey IN ('dis_msg_17172', 'dis_msg_17173'))

UPDATE mst_Resource
SET ScreenCodeId = 122056
WHERE (
(SUBSTRING(ResourceKey, len(ResourceKey) - 4, 5) <= 17253
AND SUBSTRING(ResourceKey, len(ResourceKey) - 4, 5) >= 17247)
OR ResourceKey IN ('dis_grd_17269', 'dis_lbl_17308', 'dis_lbl_17325')
OR (SUBSTRING(ResourceKey, len(ResourceKey) - 4, 5) <= 17302
AND SUBSTRING(ResourceKey, len(ResourceKey) - 4, 5) >= 17291)
OR (SUBSTRING(ResourceKey, len(ResourceKey) - 4, 5) <= 17318
AND SUBSTRING(ResourceKey, len(ResourceKey) - 4, 5) >= 17311)
)

UPDATE mst_Resource 
SET ScreenCodeId = 122057
WHERE (SUBSTRING(ResourceKey, len(ResourceKey) - 4, 5) <= 17264
AND SUBSTRING(ResourceKey, len(ResourceKey) - 4, 5) >= 17254)
OR (SUBSTRING(ResourceKey, len(ResourceKey) - 4, 5) <= 17290
AND SUBSTRING(ResourceKey, len(ResourceKey) - 4, 5) >= 17272)
OR (SUBSTRING(ResourceKey, len(ResourceKey) - 4, 5) <= 17306
AND SUBSTRING(ResourceKey, len(ResourceKey) - 4, 5) >= 17305)
OR ResourceKey IN ('dis_btn_17334')

-- Reports
UPDATE mst_Resource 
SET ScreenCodeId = 122058
WHERE SUBSTRING(ResourceKey, len(ResourceKey) - 4, 5) <= 19031
AND SUBSTRING(ResourceKey, len(ResourceKey) - 4, 5) >= 19001

UPDATE mst_Resource SET ScreenCodeId = 122059 -- Communication Notification list
WHERE ResourceKey IN ('cmu_grd_18012','cmu_grd_18013','cmu_grd_18014','cmu_msg_18034','cmu_msg_18035','cmu_msg_18036',
'cmu_lbl_18037','cmu_lbl_18038','cmu_lbl_18039','cmu_lbl_18040','cmu_lbl_18041','cmu_lbl_18042','cmu_lbl_18043','cmu_lbl_18044','cmu_lbl_18045',
'cmu_ttl_18046','cmu_ttl_18047','cmu_btn_18048','cmu_grd_18049','cmu_grd_18050','cmu_lbl_18060',
'cmu_lbl_18063','cmu_btn_18064')

-- Period End Disclosure Reports
UPDATE mst_Resource 
SET ScreenCodeId = 122060
WHERE (SUBSTRING(ResourceKey, len(ResourceKey) - 4, 5) <= 19073
AND SUBSTRING(ResourceKey, len(ResourceKey) - 4, 5) >= 19039)
OR (SUBSTRING(ResourceKey, len(ResourceKey) - 4, 5) <= 19152
AND SUBSTRING(ResourceKey, len(ResourceKey) - 4, 5) >= 19135)
OR (SUBSTRING(ResourceKey, len(ResourceKey) - 4, 5) <= 19172
AND SUBSTRING(ResourceKey, len(ResourceKey) - 4, 5) >= 19166)
OR ResourceKey in ('rpt_ttl_19157', 'rpt_ttl_19158', 'rpt_ttl_19159', 'rpt_lbl_19160', 'rpt_lbl_19236', 'rpt_lbl_19237')

-- Initial Disclosure Reports
UPDATE mst_Resource 
SET ScreenCodeId = 122061
WHERE (SUBSTRING(ResourceKey, len(ResourceKey) - 4, 5) <= 19031
AND SUBSTRING(ResourceKey, len(ResourceKey) - 4, 5) >= 19004)
OR (SUBSTRING(ResourceKey, len(ResourceKey) - 4, 5) <= 19038
AND SUBSTRING(ResourceKey, len(ResourceKey) - 4, 5) >= 19032)
OR (SUBSTRING(ResourceKey, len(ResourceKey) - 4, 5) <= 19165
AND SUBSTRING(ResourceKey, len(ResourceKey) - 4, 5) >= 19161)
OR ResourceKey in ('rpt_grd_19072', 'rpt_grd_19073', 'rpt_lbl_19110', 'rpt_ttl_19153', 'rpt_ttl_19154')

-- Continuous Disclosure Reports
UPDATE mst_Resource 
SET ScreenCodeId = 122062
WHERE (SUBSTRING(ResourceKey, len(ResourceKey) - 4, 5) <= 19109
AND SUBSTRING(ResourceKey, len(ResourceKey) - 4, 5) >= 19074)
OR (SUBSTRING(ResourceKey, len(ResourceKey) - 4, 5) <= 19134
AND SUBSTRING(ResourceKey, len(ResourceKey) - 4, 5) >= 19111)
OR ResourceKey in ('rpt_ttl_19155', 'rpt_ttl_19156', 'rpt_lbl_19169')

-- Preclearance Report
UPDATE mst_Resource 
SET ScreenCodeId = 122063
WHERE (SUBSTRING(ResourceKey, len(ResourceKey) - 4, 5) <= 19235
AND SUBSTRING(ResourceKey, len(ResourceKey) - 4, 5) >= 19173)
OR ResourceKey IN ('rpt_lbl_19238')

-- Forget password screen
UPDATE mst_Resource 
SET ScreenCodeId = 122064
WHERE (SUBSTRING(ResourceKey, len(ResourceKey) - 4, 5) <= 11273
AND SUBSTRING(ResourceKey, len(ResourceKey) - 4, 5) >= 11270)
OR ResourceKey IN ('usr_msg_11282', 'usr_msg_11283')

UPDATE mst_Resource SET ScreenCodeId = 122000 -- XXX Details
WHERE ResourceKey IN ('')

UPDATE mst_Resource SET ModuleCodeId = 103007 WHERE ScreenCodeId IN (122005, 122006, 122027, 122028)

UPDATE mst_Resource 
SET ScreenCodeId = 122040
WHERE (SUBSTRING(ResourceKey, len(ResourceKey) - 4, 5) <= 15390
AND SUBSTRING(ResourceKey, len(ResourceKey) - 4, 5) >= 15389)
OR ResourceKey IN ('rul_msg_15392')
OR (SUBSTRING(ResourceKey, len(ResourceKey) - 4, 5) <= 15410
AND SUBSTRING(ResourceKey, len(ResourceKey) - 4, 5) >= 15409)

UPDATE mst_Resource 
SET ScreenCodeId = 122012
WHERE SUBSTRING(ResourceKey, len(ResourceKey) - 4, 5) <= 13121
AND SUBSTRING(ResourceKey, len(ResourceKey) - 4, 5) >= 13120

UPDATE mst_Resource 
SET ScreenCodeId = 122042
WHERE ResourceKey = 'rul_btn_15391'

--Grid headers, error message and popup title for Overlapping trading policy list for users of a trading policy
UPDATE mst_Resource SET ScreenCodeId = 122040 
WHERE SUBSTRING(ResourceKey, len(ResourceKey) - 4, 5) <= 15405
AND SUBSTRING(ResourceKey, len(ResourceKey) - 4, 5) >= 15398

UPDATE mst_Resource 
SET ScreenCodeId = 122041
WHERE ResourceKey = 'rul_msg_15406'

UPDATE mst_Resource
SET ScreenCodeId = 122064
WHERE SUBSTRING(ResourceKey, len(ResourceKey) - 4, 5) <= 11279
AND SUBSTRING(ResourceKey, len(ResourceKey) - 4, 5) >= 11278

UPDATE mst_Resource
SET ScreenCodeId = 122016
WHERE SUBSTRING(ResourceKey, len(ResourceKey) - 4, 5) = 11280

UPDATE mst_Resource
SET ScreenCodeId = 122054
WHERE SUBSTRING(ResourceKey, len(ResourceKey) - 4, 5) <= 18066
AND SUBSTRING(ResourceKey, len(ResourceKey) - 4, 5) >= 18065

