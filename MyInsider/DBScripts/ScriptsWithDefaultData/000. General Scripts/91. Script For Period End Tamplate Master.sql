

---script for Period End disclosures Form tamplete for tra_TamplateMaster table open
IF NOT EXISTS(SELECT * FROM tra_TemplateMaster WHERE CommunicationModeCodeId = 156010)
BEGIN
			INSERT INTO tra_TemplateMaster(TemplateName,CommunicationModeCodeId,DisclosureTypeCodeId,LetterForCodeId,IsActive
					   ,Date,ToAddress1,ToAddress2,Subject,Contents,Signature,CommunicationFrom,SequenceNo,IsCommunicationTemplate
					   ,CreatedBy,CreatedOn,ModifiedBy,ModifiedOn)
			 VALUES('Period End Disclosures Form G for Other Securities Template',156010,NULL,NULL,1,NULL,NULL,NULL,NULL,
					'<div style="margin: 30px; width: 650px;font-family: ''Roboto'', sans-serif;font-size:10px;">
        <p style="text-align: right; font-size:18px;padding-right:10px"> <b>[PERIODEND_FREQUENCY] statement of holdings from [FROM_DATEOF_PERIODEND_DISCLOSURES] to [TO_DATEOF_PERIODEND_DISCLOSURES] </b>  </p>
        <br /><br />
        <p><b>Date :  [DATEOF_SUBMISSION]</b> </p><br />
        <p>[NAMEOF_IMPLEMENTING_COMPANY]</p>
        <p>ISIN Number : [ISIN_NUMBER]</p><br>
        <p>Period end statement of holdings of securities of all listed companies :</p><br>
              <br /><br /><br />
        <table border="1" cellspacing="0" cellpadding="10" style="max-width: 600px;font-family:inherit;font-size:inherit;">
            <tbody>
                <tr height="100">
                    <td   style="word-wrap: break-word;width=80;valign:top"><b>Name, PAN,<br /> CIN/DIN, Address  </b></td>
                    <td   style="word-wrap: break-word;width=50;valign:top"><b>Category of Person<br /> (Promoter/ KMP/Director/<br /> Immediate relative to etc) </b></td>
                    <td   style="word-wrap: break-word;width=50;valign:top"><b>Demat<br /> Account<br /> Number </b></td>
                    <td   style="word-wrap: break-word;width=50;valign:top"><b>Type of Security </b></td>
                    <td   style="word-wrap: break-word;width=50;valign:top"><b>Name of company </b></td>
                    <td   style="word-wrap: break-word;width=30;valign:top"><b>Holding at the <br />beginning <br />of the <br />period </b></td>
                    <td   style="word-wrap: break-word;width=30;valign:top"><b>No. of <br />securities <br />purchased <br />during <br />the period </b></td>
                    <td   style="word-wrap: break-word;width=30;valign:top"><b>No. of <br />securities <br />sold <br />during <br />the period </b></td>
                    <td   style="word-wrap: break-word;width=30;valign:top"><b>No. of <br />securities <br />at the end<br /> of the period </b></td>
                    <td   style="word-wrap: break-word;width=25;valign:top"><b>No. of <br />securities <br />pledged <br />during<br /> the period </b></td>
                    <td   style="word-wrap: break-word;width=25;valign:top"><b>No. of <br />securities <br />unpledged <br />during<br /> the period </b></td>
                    <td   style="word-wrap: break-word;width=25;valign:top"><b>No. of <br />securities <br />pledged at the end <br />of the period </b></td>
                </tr>
                <tr height="50">
                    <td style="width:80; height:18; valign:middle"> [NAME],[PAN],[CIN] [DIN],[ADDRESS] </td>
                    <td style="width:50; height:18; valign:middle"> [SUB_CATEGORYOF_PERSONS] </td>
                    <td style="width:50; height:18; valign:middle"> [DEMAT_ACCOUNT_NUMBER] </td>
                    <td style="width:50; height:18; valign:middle"> [SECURITY_TYPE] </td>
                    <td style="width:50; height:18; valign:middle"> [NAMEOF_TRADING_COMPANY] </td>
                    <td style="width:30; height:18; valign:middle"> [HOLDINGON_FROM_DATE] </td>
                    <td style="width:30; height:18; valign:middle"> [BOUGHT_DURING_PERIOD] </td>
                    <td style="width:30; height:18; valign:middle"> [SOLD_DURING_PERIOD] </td>
                    <td style="width:30; height:18; valign:middle"> [HOLDINGON_TO_DATE] </td>
                    <td style="width:30; height:18; valign:middle"> [SECURITIES_PLEDGED_DURINGTHE_PERIOD] </td>
                    <td style="width:30; height:18; valign:middle"> [SECURITIES_UNPLEDGED_DURINGTHE_PERIOD] </td>
                    <td style="width:30; height:18; valign:middle"> [SECURITIES_PLEDGED_AT_THE_END_OFTHE_PERIOD] </td>
                </tr>
            </tbody>
        </table>          <br /> <br /><br /><br /><br /><br /><br /><br />

        <p>I do hereby also confirm the following:<br/><br />
			&nbsp;- I am aware of the Company’s- Trading Code of Conduct and the procedures thereunder and have not contravened the same.<br />
			&nbsp;- No contra trades have been executed by me and my affected persons within the specified timelines.
		</p><br />
		<p>	Kindly treat this communication as a disclosure under the Company’s Trading Code of Conduct.<br />
			&nbsp;I hereby declare that the information above is true and correct to the best of my knowledge.</p>
        <br /><br />
        <p><b>Name:</b> [EMPLOYEE_NAME]</p><br />
        <p><b>Employee Code: </b> [EMPLOYEE_CODE] </p><br />
        <p><b>Designation : </b>[DESIGNATION]</p><br />
        <p><b>Branch / Department: </b>[DEPARTMENT]</p>
    </div>' ,
					NULL,NULL,NULL,0,1,GETDATE(),1,GETDATE()
					)
END
----script for Period End disclosures Form tamplete for tra_TamplateMaster table close