IF EXISTS(SELECT NAME FROM SYS.PROCEDURES WHERE NAME = 'st_tra_TradingTransactionUserDetailsSave')
DROP PROCEDURE [dbo].[st_tra_TradingTransactionUserDetailsSave]
GO
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*-------------------------------------------------------------------------------------------------
Description:	Save user details for each transcation details for transcation master

Returns:		0, if Success.
				
Created by:		Parag
Created on:		06-May-2016

Modification History:
Modified By		Modified On		Description
Parag			08-Aug-2016		Made change to save transaction detail for form in case of partial trade/transaction limit is set
Raghvendra		07-Sep-2016		Changed the GETDATE() call with function dbo.uf_com_GetServerDate(). This function will return the date to be used as server date.
								
Usage:
EXEC st_tra_TransactionUserDetailsSave <transaction master id>
-------------------------------------------------------------------------------------------------*/
CREATE PROCEDURE [dbo].[st_tra_TradingTransactionUserDetailsSave]
	@inp_nTransactionMasterId				BIGINT,
	@inp_bFormDetails						BIT = 0,
	@out_nReturnValue						INT = 0 OUTPUT,
	@out_nSQLErrCode						INT = 0 OUTPUT,
	@out_sSQLErrMessage						NVARCHAR(500) = '' OUTPUT
	
AS
BEGIN
	DECLARE @ERR_TRANSACTION_USER_DETAILS_SAVE_FAIL INT = 16433 -- Error occured while saving user details for transaction
	DECLARE @ERR_TRANSACTION_FORM_DETAILS_SAVE_FAIL INT = 16434 -- Error occured while saving user details for transaction
	
	DECLARE @nUserType_Employee INT = 101003 
	DECLARE @nUserType_NonEmployee INT = 101006 
	
	DECLARE @bNoTransactionDetails BIT = 0 
	
	DECLARE @tmpTransactions TABLE(TransactionMasterId BIGINT)
		
	BEGIN TRY
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;
		IF @out_nReturnValue IS NULL
			SET @out_nReturnValue = 0
		IF @out_nSQLErrCode IS NULL
			SET @out_nSQLErrCode = 0
		IF @out_sSQLErrMessage IS NULL
			SET @out_sSQLErrMessage = ''
		
		-- for transaction master fetch all the details of transaction details 
		-- also fetch user details and save into table for each transaction details 
		
		-- create temp table to save user info for each transaction details
		CREATE TABLE #tmpUserDetails(
			TransactionMasterId BIGINT NOT NULL, TransactionDetailsId BIGINT NULL, UserInfoId INT NOT NULL, 
			EmployeeId VARCHAR(50) NULL, FirstName VARCHAR(50) NULL, MiddleName VARCHAR(50) NULL, FormCategoryPerson VARCHAR(550) NULL,
			LastName VARCHAR(50) NULL, Relation VARCHAR(550) NULL,  Email VARCHAR(250) NULL, MobileNumber VARCHAR(15) NULL,
			CompanyName VARCHAR(200) NULL, [Address] VARCHAR(500) NULL, Country VARCHAR(550) NULL, Pincode VARCHAR(50) NULL,
			ContactPerson VARCHAR(100) NULL, DateOfJoining DATETIME NULL, DateOfBecomingInsider DATETIME NULL, PanNumber VARCHAR(50) NULL,
			Landline1 VARCHAR(50) NULL, Landline2 VARCHAR(50) NULL, TanNumber VARCHAR(50) NULL, Category VARCHAR(550) NULL, 
			Subcategory VARCHAR(550) NULL, Grade VARCHAR(550) NULL, Designation VARCHAR(550) NULL, Subdesignation VARCHAR(550) NULL,
			Location VARCHAR(50) NULL, Department VARCHAR(550) NULL, UPSIAccessofcompany INT NULL, DematAccountNumber VARCHAR(50) NULL,
			DPBank VARCHAR(550) NULL, DPId VARCHAR(50) NULL, TMId VARCHAR(50) NULL, StockExchange VARCHAR(550) NULL,
			ForUserInfoId INT NULL, CINNumber VARCHAR(50) NULL, DIN VARCHAR(50) NULL, UserTypeCode INT, ModifiedBy INT
		)
		
		-- check if transaction is no holding flag set in that case save user details only 
		IF EXISTS (SELECT tm.TransactionMasterId FROM tra_TransactionMaster tm WHERE tm.TransactionMasterId = @inp_nTransactionMasterId AND 
					tm.NoHoldingFlag = 1)
		BEGIN
			SET @bNoTransactionDetails = 1 -- set flag to indicate there are no transaction details for user
		END
		
		-- In case of form details being saved, get all the transcation master assciated with form
		IF(@inp_bFormDetails = 1)
		BEGIN
			-- get all transcation master id related to form
			INSERT INTO @tmpTransactions
			EXEC st_tra_TransactionIdsForLetter @inp_nTransactionMasterId
		END
		ELSE
		BEGIN
			INSERT INTO @tmpTransactions (TransactionMasterId) VALUES (@inp_nTransactionMasterId)
		END
		
		-- Add all the transaction and related user for transcation
		INSERT INTO #tmpUserDetails (TransactionMasterId, TransactionDetailsId, UserInfoId, ForUserInfoId, ModifiedBy)
		SELECT TM.TransactionMasterId, TD.TransactionDetailsId, TM.UserInfoId, 
				CASE WHEN TD.TransactionDetailsId IS NULL THEN TM.UserInfoId ELSE TD.ForUserInfoId END, 
				CASE WHEN TD.TransactionDetailsId IS NULL THEN TM.ModifiedBy ELSE TD.ModifiedBy END 
		FROM tra_TransactionMaster TM 
		INNER JOIN @tmpTransactions tmpTM ON TM.TransactionMasterId = tmpTM.TransactionMasterId
		LEFT JOIN tra_TransactionDetails TD ON TD.TransactionMasterId = TM.TransactionMasterId 
		
		-- update user details for each transaction
		UPDATE t
		SET 
			t.EmployeeId = ui.EmployeeId,
			t.FirstName = ui.FirstName,
			t.MiddleName = ui.MiddleName,
			t.LastName = ui.LastName,
			t.UserTypeCode = ui.UserTypeCodeId,
			t.Relation = CASE 
							WHEN @inp_bFormDetails = 0 THEN
								CASE 
									WHEN cc_relation.CodeName IS NOT NULL THEN
										CASE 
											WHEN cc_relation.DisplayCode IS NULL OR cc_relation.DisplayCode = '' THEN cc_relation.CodeName 
											ELSE cc_relation.DisplayCode 
										END
									ELSE 'Self' 
								END
							ELSE NULL
						END,
			t.FormCategoryPerson = CASE 
							WHEN @inp_bFormDetails = 1 THEN
								CASE 
									WHEN cc_relation.CodeName IS NOT NULL THEN 'Immediate Relative'
									WHEN ui.UserTypeCodeId = @nUserType_Employee THEN
										CASE 
											WHEN cc_subcategory.DisplayCode IS NULL OR cc_subcategory.DisplayCode = '' THEN cc_subcategory.CodeName 
											ELSE cc_subcategory.DisplayCode 
										END
									ELSE ui.SubCategoryText 
								END
							ELSE NULL
						END,
			t.Email = ui.EmailId,
			t.MobileNumber = ui.MobileNumber,
			t.CompanyName = com.CompanyName,
			t.Address = ui.AddressLine1,
			t.Country = CASE 
							WHEN cc_country.CodeID IS NOT NULL THEN
								CASE 
									WHEN cc_country.DisplayCode IS NULL OR cc_country.DisplayCode = '' THEN cc_country.CodeName 
									ELSE cc_country.DisplayCode 
								END
							ELSE NULL
						END,
			t.Pincode = ui.PinCode,
			t.ContactPerson = ui.ContactPerson,
			t.DateOfJoining = CASE 
								-- in case of form details save user details for relative
								WHEN @inp_bFormDetails = 1 AND cc_relation.CodeName IS NOT NULL THEN 
										(SELECT u.DateOfJoining FROM usr_UserInfo u WHERE UserInfoID = ur.UserInfoId)
								ELSE 
									ui.DateOfJoining
							  END,
			t.DateOfBecomingInsider = CASE 
										-- in case of form details save user details for relative
										WHEN @inp_bFormDetails = 1 AND cc_relation.CodeName IS NOT NULL THEN 
												(SELECT u.DateOfBecomingInsider FROM usr_UserInfo u WHERE UserInfoID = ur.UserInfoId)
										ELSE 
											ui.DateOfBecomingInsider
									  END,
			t.PanNumber = ui.PAN,
			t.Landline1 = ui.LandLine1,
			t.Landline2 = ui.LandLine2,
			t.TanNumber = ui.TAN,
			t.Location = ui.Location,
			t.Category = CASE 
							WHEN ui.UserTypeCodeId = @nUserType_Employee THEN
								CASE 
									WHEN cc_category.DisplayCode IS NULL OR cc_category.DisplayCode = '' THEN cc_category.CodeName 
									ELSE cc_category.DisplayCode 
								END
							ELSE ui.CategoryText
						END,
			t.Subcategory = CASE 
								WHEN ui.UserTypeCodeId = @nUserType_Employee THEN
									CASE 
										WHEN cc_subcategory.DisplayCode IS NULL OR cc_subcategory.DisplayCode = '' THEN cc_subcategory.CodeName 
										ELSE cc_subcategory.DisplayCode 
									END
								ELSE ui.SubCategoryText
							END,
			t.Grade = CASE 
						WHEN ui.UserTypeCodeId = @nUserType_Employee THEN
							CASE 
								WHEN cc_grade.DisplayCode IS NULL OR cc_grade.DisplayCode = '' THEN cc_grade.CodeName 
								ELSE cc_grade.DisplayCode 
							END
						ELSE ui.GradeText
					END,
			t.Designation = CASE 
								WHEN ui.UserTypeCodeId = @nUserType_Employee THEN
									CASE 
										WHEN cc_designation.DisplayCode IS NULL OR cc_designation.DisplayCode = '' THEN cc_designation.CodeName 
										ELSE cc_designation.DisplayCode 
									END
								ELSE ui.DesignationText
							END,
			t.Subdesignation = CASE 
									WHEN ui.UserTypeCodeId = @nUserType_Employee THEN
										CASE 
											WHEN cc_subdesignation.DisplayCode IS NULL OR cc_subdesignation.DisplayCode = '' THEN cc_subdesignation.CodeName 
											ELSE cc_subdesignation.DisplayCode 
										END
									ELSE ui.SubDesignationText
								END,
			t.Department = CASE 
								WHEN ui.UserTypeCodeId = @nUserType_Employee THEN
									CASE 
										WHEN cc_department.DisplayCode IS NULL OR cc_department.DisplayCode = '' THEN cc_department.CodeName 
										ELSE cc_department.DisplayCode 
									END
								ELSE ui.DepartmentText
							END,
			t.UPSIAccessofcompany = CASE 
										WHEN ui.UserTypeCodeId = @nUserType_NonEmployee THEN
											CASE 
												WHEN cc_UPSICompnay.DisplayCode IS NULL OR cc_UPSICompnay.DisplayCode = '' THEN cc_UPSICompnay.CodeName 
												ELSE cc_UPSICompnay.DisplayCode 
											END
										ELSE NULL
									END,
			t.DematAccountNumber = d.DEMATAccountNumber,
			t.DPBank = CASE 
							WHEN d.DPBankCodeId IS NULL THEN d.DPBank
							ELSE 
								CASE 
									WHEN cc_dpbank.DisplayCode IS NULL OR cc_dpbank.DisplayCode = '' THEN cc_dpbank.CodeName 
									ELSE cc_dpbank.DisplayCode 
								END
						END,
			t.DPId = d.DPID,
			t.TMId = d.TMID,
			t.StockExchange = CASE 
								WHEN cc_exchange.CodeID IS NOT NULL THEN
									CASE 
										WHEN cc_exchange.DisplayCode IS NULL OR cc_exchange.DisplayCode = '' THEN cc_exchange.CodeName 
										ELSE cc_exchange.DisplayCode 
									END
								ELSE NULL
							END,
			t.CINNumber = ui.CIN,
			t.DIN = ui.DIN
		FROM #tmpUserDetails t
		LEFT JOIN tra_TransactionDetails td ON t.TransactionDetailsId = td.TransactionDetailsId
		LEFT JOIN usr_UserInfo ui ON t.ForUserInfoId = ui.UserInfoId
		LEFT JOIN usr_UserRelation ur ON ui.UserInfoId = ur.UserInfoIdRelative 
		LEFT JOIN com_Code cc_relation ON ur.RelationTypeCodeId = cc_relation.CodeID
		LEFT JOIN mst_Company com ON ui.CompanyId = com.CompanyId
		LEFT JOIN com_Code cc_country ON ui.CountryId = cc_country.CodeID
		LEFT JOIN com_Code cc_category ON UI.Category = cc_category.CodeID
		LEFT JOIN com_Code cc_subcategory ON UI.SubCategory = cc_subcategory.CodeID
		LEFT JOIN com_Code cc_grade ON UI.GradeId = cc_grade.CodeID
		LEFT JOIN com_Code cc_designation ON UI.DesignationId = cc_designation.CodeID
		LEFT JOIN com_Code cc_subdesignation ON UI.SubDesignationId = cc_subdesignation.CodeID
		LEFT JOIN com_Code cc_department ON UI.DepartmentId = cc_department.CodeID
		LEFT JOIN com_Code cc_UPSICompnay ON UI.UPSIAccessOfCompanyID = cc_UPSICompnay.CodeID
		LEFT JOIN usr_DMATDetails d ON ui.UserInfoId = d.UserInfoID
		LEFT JOIN com_Code cc_exchange ON td.ExchangeCodeId = cc_exchange.CodeID
		LEFT JOIN com_Code cc_dpbank ON d.DPBankCodeId IS NOT NULL AND d.DPBankCodeId = cc_dpbank.CodeID
		
		
		INSERT INTO tra_TradingTransactionUserDetails
			(TransactionMasterId, TransactionDetailsId, FormDetails, UserInfoId, UserTypeCode, ForUserInfoId, EmployeeId,
			FirstName, MiddleName, LastName, Relation, FormCategoryPerson, Email, MobileNumber, CompanyName, [Address],
			Country, Pincode, ContactPerson, DateOfJoining, DateOfBecomingInsider, PanNumber, Landline1, Landline2,
			TanNumber, Category, Subcategory, Grade, Designation, Subdesignation, Location, Department,
			UPSIAccessofcompany, DematAccountNumber, DPBank, DPId, TMId, StockExchange, CINNumber, DIN, 
			CreatedBy, CreatedOn, ModifiedBy, ModifiedOn)
		SELECT 
			t.TransactionMasterId, t.TransactionDetailsId, @inp_bFormDetails, t.UserInfoId, t.UserTypeCode, t.ForUserInfoId, t.EmployeeId,
			t.FirstName, t.MiddleName, t.LastName, t.Relation, t.FormCategoryPerson, t.Email, t.MobileNumber, t.CompanyName, t.Address,
			t.Country, t.Pincode, t.ContactPerson, t.DateOfJoining, t.DateOfBecomingInsider, t.PanNumber, t.Landline1, t.Landline2,
			t.TanNumber, t.Category, t.Subcategory, t.Grade, t.Designation, t.Subdesignation, t.Location, t.Department,
			t.UPSIAccessofcompany, t.DematAccountNumber, t.DPBank, t.DPId, t.TMId, t.StockExchange, t.CINNumber, t.DIN, 
			t.ModifiedBy, dbo.uf_com_GetServerDate(), t.ModifiedBy, dbo.uf_com_GetServerDate()
		FROM #tmpUserDetails  t
		
		--select * from tra_TradingTransactionUserDetails
		
		-- Delete temporary table
		DROP TABLE #tmpUserDetails
		
		SET @out_nReturnValue = 0
		RETURN @out_nReturnValue
	END	 TRY
	BEGIN CATCH		
		print '@out_nSQLErrCode= '+convert(varchar, ERROR_NUMBER())+'  @out_sSQLErrMessage='+convert(varchar, ERROR_NUMBER())
		SET @out_nSQLErrCode    =  ERROR_NUMBER()
		SET @out_sSQLErrMessage =   ERROR_MESSAGE()
		
		-- Return common error if required, otherwise specific error.		
		SET @out_nReturnValue  = CASE 
									WHEN @inp_bFormDetails = 0 THEN dbo.uf_com_GetErrorCode(@ERR_TRANSACTION_USER_DETAILS_SAVE_FAIL, ERROR_NUMBER())
									ELSE dbo.uf_com_GetErrorCode(@ERR_TRANSACTION_FORM_DETAILS_SAVE_FAIL, ERROR_NUMBER())
								 END 
		RETURN @out_nReturnValue		
	END CATCH
END

