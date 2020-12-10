
--For insertion of code group
IF NOT EXISTS(Select 1 from com_CodeGroup where CodeGroupID = 536)
BEGIN
	Insert Into com_CodeGroup values(536,'Enable OTP Configuration', 'Enable OTP Configuration',0,0,NULL)
END

IF NOT EXISTS(Select 1 from com_CodeGroup where CodeGroupID = 537)
BEGIN
	Insert Into com_CodeGroup values(537,'OTP Configuration Applicable For', 'OTP Configuration Applicable For',0,0,NULL)
END


--for OTP to email allow or disallow
IF NOT EXISTS(Select 1 from com_Code where CodeID = 536001)
BEGIN
	Insert into com_Code values(536001, 'Yes', 536, 'Allow OTP configuration', 1, 1, 1, null, null, 1, GETDATE())
END
IF NOT EXISTS(Select 1 from com_Code where CodeID = 536002)
BEGIN
	Insert into com_Code values(536002, 'No', 536, 'Disallow OTP configuration', 1, 1, 2, null, null, 1, GETDATE())
END

-- for applicable for which user type
IF NOT EXISTS(Select 1 from com_Code where CodeID = 537001)
BEGIN
	Insert into com_Code values(537001, 'Applicable for - CO', 537, 'Applicable for - CO', 1, 1, 1, null, null, 1, GETDATE())
END
IF NOT EXISTS(Select 1 from com_Code where CodeID = 537002)
BEGIN
	Insert into com_Code values(537002, 'Applicable for - Employee', 537, 'Applicable for - Employee', 1, 1, 2, null, null, 1, GETDATE())
END
IF NOT EXISTS(Select 1 from com_Code where CodeID = 537003)
BEGIN
	Insert into com_Code values(537003, 'Applicable for - All', 537, 'Applicable for - All', 1, 1, 3, null, null, 1, GETDATE())
END
ELSE
BEGIN
	update com_Code set CodeName = 'Applicable for - All', Description = 'Applicable for - All' where CodeID = 537003
END

--for screen code
IF NOT EXISTS(Select 1 from com_Code where CodeID = 122113)
BEGIN
	Insert into com_Code values(122113, 'OTP configuration',122,'OTP configuration',1,1,121,null,null,1,GETDATE())
END

--for label
IF NOT EXISTS(Select 1 from mst_Resource where ResourceId = 61000)
BEGIN
	insert into mst_Resource values(61000, 'tfa_lbl_61000',	'Enter OTP','en-US',103003,	104002,	122113,'Enter OTP', 1, GETDATE())
END
IF NOT EXISTS(Select 1 from mst_Resource where ResourceId = 61001)
BEGIN
	insert into mst_Resource values(61001, 'tfa_msg_61001','<html><body>Dear $1, </br></br> Please use this one time password (OTP) for Login:<b> $2 </b></br></br></br><b>Thank you</b></br></br></body></html>','en-US',103003,	104001,	122113,'<html><body>Dear $1, </br></br> Please use this one time password (OTP) for Login:<b> $2 </b></br></br></br><b>Thank you</b></br></br></body></html>', 1, GETDATE())
END
ELSE
BEGIN
	Update mst_Resource set ResourceValue = '<html><body>Dear $1, </br></br> Please use this one time password (OTP) for Login:<b> $2 </b></br></br></br><b>Thank you</b></br></br></body></html>',
			OriginalResourceValue = '<html><body>Dear $1, </br></br> Please use this one time password (OTP) for Login:<b> $2 </b></br></br></br><b>Thank you</b></br></br></body></html>' 
			where ResourceKey = 'tfa_msg_61001' and ResourceId = 61001
END

IF NOT EXISTS(Select 1 from mst_Resource where ResourceId = 61002)
BEGIN
	insert into mst_Resource values(61002, 'tfa_lbl_61002','OTP for authentication','en-US',103003,	104006,	122113,'OTP for authentication', 1, GETDATE())
END

IF NOT EXISTS(Select 1 from mst_Resource where ResourceId = 61003)
BEGIN
	insert into mst_Resource values(61003, 'tfa_msg_61003','OTP is incorrect. Please enter correct OTP. You may click on Resend OTP, to generate new one','en-US',103003, 104001, 122113,'OTP is incorrect. Please enter correct OTP. You may click on Resend OTP, to generate new one', 1, GETDATE())
END
ELSE
BEGIN
	update mst_Resource set ResourceValue ='OTP is incorrect. Please enter correct OTP. You may click on Resend OTP, to generate new one', OriginalResourceValue = 'OTP is incorrect. Please enter correct OTP. You may click on Resend OTP, to generate new one'
		where ResourceKey = 'tfa_msg_61003' and ResourceId = 61003
END

IF NOT EXISTS(Select 1 from mst_Resource where ResourceId = 61004)
BEGIN
	insert into mst_Resource values(61004, 'tfa_msg_61004','OTP has expired. Please click on Resend OTP, to generate new one','en-US',103003, 104001, 122113,'OTP has expired. Please click on Resend OTP, to generate new one', 1, GETDATE())
END
ELSE
BEGIN
	update mst_Resource set ResourceValue ='OTP has expired. Please click on Resend OTP, to generate new one', OriginalResourceValue = 'OTP has expired. Please click on Resend OTP, to generate new one'
			where ResourceKey = 'tfa_msg_61004' and ResourceId = 61004
END
IF NOT EXISTS(Select 1 from mst_Resource where ResourceId = 61005)
BEGIN
	insert into mst_Resource values(61005, 'tfa_msg_61005','OTP has been re-sent to your registered email id','en-US',103003, 104001, 122113,'OTP has been re-sent to your registered email id', 1, GETDATE())
END
IF NOT EXISTS(Select 1 from mst_Resource where ResourceId = 61006)
BEGIN
	insert into mst_Resource values(61006, 'tfa_msg_61006','OTP has been sent to your registered email id.','en-US',103003, 104001, 122113,'OTP has been sent to your registered email id.', 1, GETDATE())
END
ELSE
BEGIN
	update mst_Resource set ResourceValue ='OTP has been sent to your registered email id', OriginalResourceValue = 'OTP has been sent to your registered email id'
			where ResourceKey = 'tfa_msg_61006' and ResourceId = 61006
END
IF NOT EXISTS(Select 1 from mst_Resource where ResourceId = 61007)
BEGIN
	insert into mst_Resource values(61007, 'tfa_msg_61007','• Do not refresh the page.','en-US',103003, 104001, 122113,'• Do not refresh the page.', 1, GETDATE())
END
ELSE
BEGIN
	update mst_Resource set ResourceValue ='• Do not refresh the page.', OriginalResourceValue = '• Do not refresh the page.'
			where ResourceKey = 'tfa_msg_61007' and ResourceId = 61007
END
IF NOT EXISTS(Select 1 from mst_Resource where ResourceId = 61008)
BEGIN
	insert into mst_Resource values(61008, 'tfa_msg_61008','OTP sending failed as your email id is not registered with us, kindly contact your administrator','en-US',103003, 104001, 122113,'OTP sending failed as your email id is not registered with us, kindly contact your administrator', 1, GETDATE())
END
