/*
	Script from Parag on 4-Aug-2016
	Added table to stored configuration related to security type
*/
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[SecurityConfiguration]') AND type in (N'U'))
BEGIN
	CREATE TABLE SecurityConfiguration
	(
		SecurityTypeCodeId INT CONSTRAINT FK_SecurityConfiguration_SecurityTypeCodeId_com_Code_CodeID FOREIGN KEY(SecurityTypeCodeId)REFERENCES com_Code(CodeID),
		SecurityValueConstraint INT CONSTRAINT FK_SecurityConfiguration_SecurityValueConstraint_com_Code_CodeID FOREIGN KEY(SecurityValueConstraint)REFERENCES com_Code(CodeID),
	)
	
	/*
	Script from Parag on 4-Aug-2016
	Script to add configuration for security type
	*/

	INSERT INTO SecurityConfiguration
		(SecurityTypeCodeId, SecurityValueConstraint)
	VALUES
		(139001, 179001), -- Shares
		(139002, 179001), -- Warrants
		(139003, 179001), -- Convertible Debentures
		(139004, 179001), -- Future Contracts
		(139005, 179001) -- Option Contracts
END
GO
