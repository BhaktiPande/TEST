-------------------------------------Deployment Instructions for "DataUploadUtility" [START] -------------------------------------

1. Take the latest Solution dll's from InsiderTrading and InsiderTradingDAL folder paste it in "DataUploadUtility\Binaries".
	a) InsiderTrading.dll
	b) InsiderTradingDAL.dll

2. Rebuild DataUploadUtility solution and copy exe file and dll's following files from "DataUploadUtility\Binaries" and paste it in "InsiderTrading\bin" folder.
	a) DataUploadUtility.exe
	b) DataUploadUtility.exe.config
	c) SFTPFileDownload.dll
	d) WinSCP.exe
	e) WinSCPnet.dll
	

3. Update the HRMSScheduler.exe.config for follwing parameters.
	a) CompanyNames : Company name for which data to be upload.
	b) DefaultConnection : Master database connection string.
	c) WriteToFileLogPath : Folder level path where the File will get created with the log details
	d) MailFrom : Email send from.
	e) MailTo : Email send to
	f) MailCC : Email CC
	g) MailBCC : Email BCC
	h) WriteToConsole : If it is set to "Y" details will be shown on console

-------------------------------------Deployment Instructions for "DataUploadUtility" [END] -------------------------------------