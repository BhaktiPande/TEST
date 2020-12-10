-- ======================================================================================================
-- Author      : Priyanka Bhangale
-- CREATED DATE: 04-Dec-2019
-- Description : Script to set Period end and financial year to Jul to Jun (For Client Accelya)
-- ======================================================================================================

USE [Vigilante_Accelya]
GO

update com_Code set Description = '1-Jul-1971', DisplayCode = 'Year' where CodeID = 124001
update com_Code set Description = '1-Jan-1970', DisplayCode = 'Half year 1' where CodeID = 124002
update com_Code set Description = '1-Jul-1971', DisplayCode = 'Half year 2' where CodeID = 124003
update com_Code set Description = '1-Oct-1970', DisplayCode = 'Quater 1' where CodeID = 124004
update com_Code set Description = '1-Jan-1970', DisplayCode = 'Quater 2' where CodeID = 124005
update com_Code set Description = '1-Apr-1970', DisplayCode = 'Quater 3' where CodeID = 124006
update com_Code set Description = '1-Jul-1971', DisplayCode = 'Quater 4' where CodeID = 124007
update com_Code set Description = '1-Aug-1970', DisplayCode = 'July' where CodeID = 124008
update com_Code set Description = '1-Sep-1970', DisplayCode = 'August' where CodeID = 124009
update com_Code set Description = '1-Oct-1970', DisplayCode = 'September' where CodeID = 124010
update com_Code set Description = '1-Nov-1970', DisplayCode = 'October' where CodeID = 124011
update com_Code set Description = '1-Dec-1970', DisplayCode = 'November' where CodeID = 124012
update com_Code set Description = '1-Jan-1970', DisplayCode = 'December' where CodeID = 124013
update com_Code set Description = '1-Feb-1970', DisplayCode = 'January' where CodeID = 124014
update com_Code set Description = '1-Mar-1970', DisplayCode = 'February' where CodeID = 124015
update com_Code set Description = '1-Apr-1970', DisplayCode = 'March' where CodeID = 124016
update com_Code set Description = '1-May-1970', DisplayCode = 'April' where CodeID = 124017
update com_Code set Description = '1-Jun-1970', DisplayCode = 'May' where CodeID = 124018
update com_Code set Description = '1-Jul-1971', DisplayCode = 'June' where CodeID = 124019