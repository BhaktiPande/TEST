
update com_Code set IsVisible = 1 where CodeID in (153045,153046,153047)
update com_Code set Description=163001 where CodeID in (153052,153054,153055,153056,153057,153059,153060,153061,153062,153064,153065,153066,153067)

update com_Code set Description='163001,163002' where CodeID in (153068)

update com_Code set CodeName = 'Pre-Clearance Requested -  For Other Securities' where CodeID = 153045
update com_Code set CodeName = 'Pre-Clearance Approved -  For Other Securities' where CodeID = 153046
update com_Code set CodeName = 'Pre-Clearance Rejected -  For Other Securities' where CodeID = 153047
update com_Code set CodeName = 'Pre-Clearance Expiry -  For Other Securities' where CodeID = 153067

update com_Code set CodeName = 'Initial Disclosure - Details Entered For Other Securities' where CodeID = 153052
update com_Code set CodeName = 'Initial Disclosure - Softcopy Submitted For Other Securities' where CodeID = 153054
update com_Code set CodeName = 'Initial Disclosure - Hardcopy Submitted For Other Securities' where CodeID = 153055
update com_Code set CodeName = 'Initial Disclosure - Confirmed  For Other Securities' where CodeID = 153056
update com_Code set CodeName = 'Initial Disclosure - Uploaded For Other Securities' where CodeID = 153053

update com_Code set CodeName = 'Continuous Disclosure - Details Entered  For Other Securities' where CodeID = 153057
update com_Code set CodeName = 'Continuous Disclosure - Softcopy Submitted For Other Securities' where CodeID = 153059
update com_Code set CodeName = 'Continuous Disclosure - Hardcopy Submitted For Other Securities' where CodeID = 153060
update com_Code set CodeName = 'Continuous Disclosure - Confirmed For Other Securities' where CodeID = 153061
update com_Code set CodeName = 'Continuous Disclosure - Uploaded For Other Securities' where CodeID = 153058

update com_Code set CodeName = 'Period End Disclosure - Details Entered  For Other Securities' where CodeID = 153062
update com_Code set CodeName = 'Period End Disclosure - Softcopy Submitted For Other Securities' where CodeID = 153064
update com_Code set CodeName = 'Period End Disclosure - Hardcopy Submitted For Other Securities' where CodeID = 153065
update com_Code set CodeName = 'Period End Disclosure - Confirmed For Other Securities' where CodeID = 153066
update com_Code set CodeName = 'Period End Disclosure - Uploaded For Other Securities' where CodeID = 153063

IF NOT EXISTS(Select 1 from com_Code where CodeID = 153069)
BEGIN
	Insert into com_Code values(153069, 'Period End Date - For Other Securities', 153, 163001, 1, 1, 66, null, null, 1, GETDATE())
END
IF NOT EXISTS(Select 1 from com_Code where CodeID = 153070)
BEGIN
	Insert into com_Code values(153070, 'Not Traded - For Other Securities', 153, 163001, 1, 1, 69, null, null, 1, GETDATE())
END