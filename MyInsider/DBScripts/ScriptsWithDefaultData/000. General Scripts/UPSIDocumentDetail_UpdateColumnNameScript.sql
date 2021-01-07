IF COL_LENGTH('dbo.usr_UPSIDocumentDetail', 'Temp1') IS NOT NULL
BEGIN
    EXEC sp_RENAME 'dbo.usr_UPSIDocumentDetail.Temp1', 'IsRegisteredUser', 'COLUMN'
END