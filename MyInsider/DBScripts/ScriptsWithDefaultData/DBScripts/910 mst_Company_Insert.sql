SET IDENTITY_INSERT mst_Company ON

INSERT INTO mst_Company
(CompanyId,
CompanyName
,Address
,IsImplementing
,CreatedBy
,CreatedOn
,ModifiedBy
,ModifiedOn)
VALUES
(1, 'Implementing Company', 'Address', 1, 1, GETDATE(), 1, GETDATE())

SET IDENTITY_INSERT mst_Company OFF


/* Added On: 20-Jan-2016 */
/* Send By : Parag*/
/* Update implementing company column for default trading days count type */
UPDATE mst_Company set TradingDaysCountType = 174002 WHERE IsImplementing = 1