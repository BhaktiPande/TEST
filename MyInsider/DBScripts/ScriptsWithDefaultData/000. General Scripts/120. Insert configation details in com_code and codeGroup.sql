--For insertion of code group
IF NOT EXISTS(Select 1 from com_CodeGroup where CodeGroupID = 538)
BEGIN
	Insert Into com_CodeGroup values(538,'Enable Concurrent Session Configuration', 'Enable Concurrent Session Configuration',0,0,NULL)
END


--for OTP to email allow or disallow
IF NOT EXISTS(Select 1 from com_Code where CodeID = 538001)
BEGIN
	Insert into com_Code values(538001, 'Yes', 538, 'Allow Concurrent Session configuration', 1, 1, 1, null, null, 1, GETDATE())
END
IF NOT EXISTS(Select 1 from com_Code where CodeID = 538002)
BEGIN
	Insert into com_Code values(538002, 'No', 538, 'Disallow Concurrent Session configuration', 1, 1, 2, null, null, 1, GETDATE())
END