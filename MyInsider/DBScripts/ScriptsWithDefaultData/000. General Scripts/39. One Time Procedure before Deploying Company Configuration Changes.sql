/*
	WARNING - This is one time procedure which to be executed before deploying company configuration changes.

	Script is within begin and rollback transaction. Please Comment begin rollback transaction statement before executing procedure 
*/
DECLARE @DocumentPath VARCHAR(5000) = 'C:\inetpub\wwwroot\Vigilante\Document\';
DECLARE @FormF_DisplayedFileName_WithoutExtention VARCHAR(2000) = 'Vigilante_FormF'
BEGIN TRAN

/*
	This procedure is created to gererate exercise pool balance after changes to store exercise pool balance for per demat
	Currently exercise pools is mainatain for per user. howerver after exercise pool is maintain for per demat account

	Script logic:
		Create temp table to store transcation squence 
		loop through temp table and execute update exercise pool store procedure to generate exercise pool table
*/

	-- create temp table
	create table #TempTranscationSquence 
	(
		Id INT IDENTITY(1,1),
		IsPreclearanceTransaction BIT DEFAULT 0,
		PreClearanceRequestId INT NULL,
		TransactionMasterId BIGINT NULL
	)

	declare @TranscationStatus_DocUploaded INT = 148001
	declare @TranscationStatus_NotConfirmed INT = 148002

	declare @PreclearanceStatus_Approved INT = 144002

	declare @MapToTypeCodeId_Preclearance INT = 132004
	declare @MapToTypeCodeId_Transaction INT = 132005

	declare @IsPreclearance BIT
	declare @TranscationMasterId BIGINT
	declare @PreclearanceRequestId INT
	declare @TranscationStatusCodeId INT
	declare @PreclearanceStatusCodeId INT

	declare @out_nReturnValue INT = 0
	declare @out_nSQLErrCode INT = 0
	declare @out_sSQLErrMessage	NVARCHAR(500)

	declare @DisclosureType_initial INT = 147001
	declare @transcationType_sell INT = 143002
	declare @ModeOfAcquisition_sell INT = 149010

	-- update mode of acquisition in transaction details table for sell transaction type 
	Update td SET td.ModeOfAcquisitionCodeId = @ModeOfAcquisition_sell
	FROM tra_TransactionDetails td LEFT JOIN tra_TransactionMaster tm ON td.TransactionMasterId = tm.TransactionMasterId
	where tm.DisclosureTypeCodeId = @DisclosureType_initial AND td.TransactionTypeCodeId = @transcationType_sell

	-- set data into temp table 
	DECLARE TraMaster_Cursor CURSOR FOR 
		SELECT TM.TransactionMasterId, TM.PreclearanceRequestId, TM.TransactionStatusCodeId, PCL.PreclearanceStatusCodeId
		FROM tra_TransactionMaster TM LEFT JOIN tra_PreclearanceRequest PCL ON TM.PreclearanceRequestId = PCL.PreclearanceRequestId
		ORDER BY TM.TransactionMasterId asc
	OPEN TraMaster_Cursor
	FETCH NEXT FROM TraMaster_Cursor INTO @TranscationMasterId, @PreclearanceRequestId, @TranscationStatusCodeId, @PreclearanceStatusCodeId
	WHILE @@FETCH_STATUS = 0
	BEGIN
	
		IF @PreclearanceStatusCodeId = @PreclearanceStatus_Approved AND NOT EXISTS(SELECT PreClearanceRequestId FROM #TempTranscationSquence WHERE PreClearanceRequestId = @PreclearanceRequestId)
		BEGIN
			INSERT INTO #TempTranscationSquence
				(IsPreclearanceTransaction, PreClearanceRequestId, TransactionMasterId)
			VALUES
				(1, @PreclearanceRequestId, @TranscationMasterId)
		END
	
		IF @TranscationStatusCodeId <> @TranscationStatus_NotConfirmed OR @TranscationStatusCodeId <> @TranscationStatus_DocUploaded
		BEGIN
			INSERT INTO #TempTranscationSquence
				(IsPreclearanceTransaction, PreClearanceRequestId, TransactionMasterId)
			VALUES
				(0, NULL, @TranscationMasterId)
		END
	


		FETCH NEXT FROM TraMaster_Cursor INTO @TranscationMasterId, @PreclearanceRequestId, @TranscationStatusCodeId, @PreclearanceStatusCodeId
	END			
	CLOSE TraMaster_Cursor
	DEALLOCATE TraMaster_Cursor;

	--select * from #TempTranscationSquence

	set @TranscationMasterId = null
	set @PreclearanceRequestId = null 

	-- set data into temp table 
	DECLARE ExercisePoolUpdate_Cursor CURSOR FOR 
		SELECT tmp.IsPreclearanceTransaction, tmp.PreClearanceRequestId, tmp.TransactionMasterId
		FROM #TempTranscationSquence tmp ORDER BY tmp.Id asc
	OPEN ExercisePoolUpdate_Cursor
	FETCH NEXT FROM ExercisePoolUpdate_Cursor INTO @IsPreclearance, @PreclearanceRequestId, @TranscationMasterId
	WHILE @@FETCH_STATUS = 0
	BEGIN
	
		IF @IsPreclearance = 1 -- preclearance is taken before transcation master
		BEGIN
			EXECUTE st_tra_ExerciseBalancePoolUpdateDetails
						@MapToTypeCodeId_Preclearance,
						@PreclearanceRequestId,
						NULL,
						@out_nReturnValue OUTPUT,
						@out_nSQLErrCode OUTPUT,
						@out_sSQLErrMessage OUTPUT
		END
		ELSE IF @IsPreclearance = 0 -- transaction submitted
		BEGIN
			-- update exercise pool 
			EXECUTE st_tra_ExerciseBalancePoolUpdateDetails
						@MapToTypeCodeId_Transaction,
						NULL,
						@TranscationMasterId,
						@out_nReturnValue OUTPUT,
						@out_nSQLErrCode OUTPUT,
						@out_sSQLErrMessage OUTPUT
		END

		FETCH NEXT FROM ExercisePoolUpdate_Cursor INTO @IsPreclearance, @PreclearanceRequestId, @TranscationMasterId
	END			
	CLOSE ExercisePoolUpdate_Cursor
	DEALLOCATE ExercisePoolUpdate_Cursor;

	-- Delete temporary table
	DROP TABLE #TempTranscationSquence






/*

Currently the script is added in Begin tran - Rollback tran clause so when executing the script on production remove these 
clauses and then execute as without removing these clauses the effect will not be seen

This script whould be executed only one time on a database.
This script will add the DBBankCodeID for the records which have been added by selecting the DP name from the dropdown.
IF the DP name is entered by user by selecting the option other then DPBank will not be changed and DBBankCodeID will be 
set to null
*/




UPDATE DM
SET DM.DPBankCodeId = CD.CodeId, DM.DPBank = CASE WHEN CD.CodeId IS NULL THEN DM.DPBank ELSE '' END
FROM usr_DMATDetails DM
LEFT JOIN com_Code CD ON ((CD.DisplayCode IS NOT NULL AND DM.DPBank = CD.DisplayCode) OR (CD.DisplayCode IS NULL AND DM.DPBank = CD.CodeName)) AND CD.CodeGroupId = 120
where DM.DPBankCodeId IS NULL




/*
Script from - Gaurishankar on 27 September 2016
Script to add Form F document for First time, This script will give you error, so according to your Form F document, please change the document details in the script.
Please do not execute this script blindly.
*/


INSERT INTO [dbo].[com_Document]
	([DocumentName],[GUID],[Description],[DocumentPath],[FileSize],[FileType],[CreatedBy],[CreatedOn],[ModifiedBy],[ModifiedOn])
VALUES
    (	@FormF_DisplayedFileName_WithoutExtention + '.pdf','vigilante_formf_guid.pdf',null,@DocumentPath + '132016\1\vigilante_formf_guid.pdf'
    --'Vigilante_FormF.pdf',null,'E:\Projects\InsiderTrading\Vigilante Dev\InsiderTrading_WebSite\INSIDERTRADING\Document\132016\1\Vigilante_FormF.pdf'
    -- Add GUID for Form F document and add server full path for the document.
,94972,'.pdf',1,GETDATE(),1,GETDATE())
DECLARE @nDocumentId INT
SET @nDocumentId = SCOPE_IDENTITY()
INSERT INTO [dbo].[com_DocumentObjectMapping]
	([DocumentId],[MapToTypeCodeId],[MapToId],[PurposeCodeId])
VALUES
	(@nDocumentId,132016,(SELECT ISNULL(MAX (MapToId),0) +1 FROM com_DocumentObjectMapping WHERE MapToTypeCodeId = 132016 AND PurposeCodeId = 133004),133004)
	
	UPDATE com_CompanySettingConfiguration
	SET ConfigurationValueOptional = @nDocumentId
	WHERE ConfigurationTypeCodeId = 180003
	AND ConfigurationCodeId = 185005


/*
	Tushar 28-Sep-2016
	Insert Template for FROM E
	Note :- Before Execution remove BEGIN TRAN & ROLLBACK TRAN code
*/

IF NOT EXISTS(SELECT * FROM tra_TemplateMaster WHERE CommunicationModeCodeId = 156007)
BEGIN
INSERT INTO tra_TemplateMaster(TemplateName,CommunicationModeCodeId,DisclosureTypeCodeId,LetterForCodeId,IsActive
           ,Date,ToAddress1,ToAddress2,Subject,Contents,Signature,CommunicationFrom,SequenceNo,IsCommunicationTemplate
           ,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
 VALUES('Form E Template',156007,NULL,NULL,1,NULL,NULL,NULL,NULL,
		'<div style="margin: 30px; width: 650px;font-family: ''Roboto'', sans-serif;font-size:12px;">
	<p style="text-align: center;">
		<b>FORM - E</b>(for physical pre-clearance/e-mail)
	</p>
	<BR/>
	<p style="text-align: center;">
		<i>[PCL_IMPLEMENTCOMPANY] Trading Code of Conduct</i> 
	</p>
	<p style="text-align: center;">
		APPLICATION TO TRADE
	</p>
	<BR/>
	<table border="0" cellspacing="0" cellpadding="0" style="font-family:inherit;font-size:inherit;">
		<tr height="14">
			<td width="120" height="14"><p align="left">To</p></td>
			<td width="700" valign="top"><p>: Compliance Officer</p></td>
		</tr>
		<tr height="14">
			<td></td>
		</tr>
		<tr height="14">
			<td width="120" height="14"  valign="top"><p align="left">From</p></td>
			<td width="700" valign="top">
				<table width="700" style="font-family:inherit;font-size:inherit;">
					<tr>
						<td width="200">: NAME OF EMPLOYEE</td>
						<td><u>[UREL_FIRSTNAME] [UREL_MIDDLENAME] [UREL_LASTNAME]</u></td>
					</tr>
					<tr>
						<td width="200">: EMPLOYEE CODE</td>
						<td><u>[USR_EMPLOYEEID]</u></td>
					</tr>
					<tr>
						<td width="200">: BRANCH/DEPARTMENT</td>
						<td><u>[USR_DEPT]</u></td>
					</tr>
				</table>
			</td>
			<td width="173" height="14" valign="top"></td>
		</tr>
		<tr height="14">
			<td></td>
		</tr>
		<tr height="14">
			<td width="120" height="14"><p align="left">KS Code No</p></td>
			<td width="700" valign="top"><p>: [USR_DMATTMID]</p></td>
		</tr>
	</table>

<BR/><BR/><BR/>
<p style="text-align: justify;">With reference to the [PCL_IMPLEMENTCOMPANY] Trading Code of Conduct, I here by give notice that I / my affected person Mr/ Ms <u>[UREL_FIRSTNAME] [UREL_MIDDLENAME] [UREL_LASTNAME]</u> propose to carry out the following transaction:-</p>
<BR/><BR/>
<p style="text-align: justify;">(Note: For offline trades, please fill separate forms for self and each of affected person.The code number above should be of the person in whose name the transaction is proposed)</p>
<BR/>
<table border="1" cellspacing="0" cellpadding="10" style="max-width: 700px;font-family:inherit;font-size:inherit;">
<tr height="18">
<td width="50" valign="top" style="word-wrap: break-word"><b>Name of  the Security(ies)  </b></td>
<td width="50" valign="top" style="word-wrap: break-word"><b>Type   of Security </b></td>
<td width="50" valign="top" style="word-wrap: break-word"><b>Nature of Transaction </b></td>
<td width="90" valign="top" style="word-wrap: break-word"><b>Quantity of Security (ies) </b></td>
<td width="90" valign="top" style="word-wrap: break-word"><b>Indicative Price / Premium (for offline    trade only) </b></td>
<td width="50" valign="top" style="word-wrap: break-word"><b>Name of   the Exchange </b></td>
<td width="50" valign="top" style="word-wrap: break-word"><b>Date of  purchase / allotment  (applicable only if        the        application is in        respect        of sale of      Securities)      </b></td>
<td width="50" valign="top" style="word-wrap: break-word"><b>*Previous approval no. and date for purchase/allotment)</b></td>
<td width="50" valign="top" style="word-wrap: break-word"><b>Name of  Proposed  Buyer/ Seller  in  case  of offline trade            </b></td>
</tr>

<tr height="18">
<td width="50" height="18" valign="top"> [PCL_TRADEDFORCOMPANY] </td>
<td width="50" height="18" valign="top"> [PCL_SECURITYTYPE] </td>
<td width="50" height="18" valign="top"> [PCL_TRANSACTNTYPE] </td>
<td width="90" height="18" valign="top"> [PCL_SECURITYTRADEQTY] </td>
<td width="90" height="18" valign="top"> Not Applicable </td>
<td width="50" height="18" valign="top">  </td>
<td width="50" height="18" valign="top"> [PCL_BUYDATE] </td>
<td width="50" height="18" valign="top"> [PCL_PREVAPPROVNUMBERANDDATE] </td>
<td width="50" height="18" valign="top">  </td>
</tr>
</table>
<p><b> * applicable only if the application is in respect of sale of Securities for which an earlier purchase sanction was granted by the Compliance Officer</b></p>
<BR/>
<p>In this connection, I do hereby represent and undertake as follows:-</p>
<BR/>
<ol type="a" style="list-style-type:lower-alpha;text-align: justify;">
 <li>That I am aware of the SEBI (Prohibition of Insider Trading) Regulations, 2015(Regulations) and the [PCL_IMPLEMENTCOMPANY] (Bank/Company)-Trading Code of Conduct and procedures made thereunder and have not contravened the Regulations and the Code/procedures laid down by the Bank for prevention of insider trading as notified by the Bank from time to time.</li>
 <li>That I do not have any access nor have I received any "Unpublished Price Sensitive Information" as defined in the Regulations as amended up to and at the time of signing the undertaking in respect of the aforesaid securities.</li>
 <li>That in case I have access to or receive "Unpublished Price Sensitive Information" after the signing of the undertaking but before the execution of any transactions in securities of the Company, I shall inform the Compliance Officer of the change in my position and that I would completely refrain from dealing in the securities of the company till the time such information becomes generally available or ceases to be price sensitive.</li>
 <li>I am not trading in any securities including the Bank securities, which I have undertaken a contra-trade in the last 6 months, as the case may be subject to exception granted by Clause 9.5 of the Code of the Bank, if applicable.</li>
 <li>I undertake to submit the necessary report within 2 trading days of execution of the transaction/a ''Nil'' report if the transaction is not undertaken.</li>
<li>I agree to comply with the provisions of the Code and provide any information related to the trade as may be required by the Compilance Officer and permit the company to disclosure such details to SEBI, if so required by SEBI.</li>
<li>That I have made a full and true disclosure in the matter.</li>
</ol>
<BR/>
<BR/>
<BR/>
<table border="0" cellspacing="0" cellpadding="0" style="font-family:inherit;font-size:inherit;">
<tr>
<td width="50"><p align="left">Date:</p></td>
<td width="200" valign="top">[PCL_REQUESTDATE]</td>
<td width="400" valign="top" style="text-align:right;"><u>[USR_FIRSTNAME] [USR_LASTNAME]</u></td>
</tr>
<tr>
<td width="50"><p align="left"></p></td>
<td width="200" valign="top"></td>
<td width="400" valign="top" style="text-align:right;">(Signature) / (Approval by email)</td>
</tr>
</table>
<BR/><BR/>
<p>AUTHORISATION TO TRADE</p>
<BR/>
<p>The above transaction has been authorised. Your dealing must be completed within 7 trading days from the date of approval. 
(Including the date of approval).</p>
<BR/>
<BR/>
<table border="0" cellspacing="0" cellpadding="0" style="font-family:inherit;font-size:inherit;">
<tr>
<td width="50"><p align="left">Date:</p></td>
<td width="200" valign="top">[PCL_APPROVEDDATE]</td>
<td width="400" valign="top" style="text-align:right;"><u>[PCL_APPROVEDBY]</u></td>
</tr>
<tr>
<td width="50"><p align="left"></p></td>
<td width="200" valign="top"></td>
<td width="400" valign="top" style="text-align:right;">(Signature) / (Approval by email)</td>
</tr>
</table>

</div>',
		NULL,NULL,NULL,0,1,GETDATE(),1,GETDATE()
		)
END
GO

ROLLBACK TRAN