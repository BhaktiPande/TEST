
IF NOT EXISTS(select * from com_Code where CodeID = 156016)
BEGIN
	insert into com_Code values(
	156016,	'Initial Disclosures Form for Other Securities Without Quantity',156,	'Initial Disclosures Form for Other Securities Without Quantity',1,1,14,NULL,166002,	1,	Getdate())
END

IF NOT EXISTS(select * from com_Code where CodeID = 156017)
BEGIN
	insert into com_Code values(
	156017,	'Continuous Disclosures Form for Other Securities Without Quantity',156,	'Continuous Disclosures Form for Other Securities Without Quantity',1,1,15,NULL,166002,	1,	Getdate())
END

IF NOT EXISTS(select * from com_Code where CodeID = 156018)
BEGIN
	insert into com_Code values(
	156018,	'Pre-clearance form for Implementing Company Without Quantity',156,	'Pre-clearance form for Implementing Company Without Quantity',1,1,16,NULL,	166002,	1,	Getdate())
END

IF NOT EXISTS(select * from com_Code where CodeID = 156019)
BEGIN
	insert into com_Code values(
	156019,	'Period End Form for Other Securities Without Quantity',156,'Period End Form for Other Securities Without Quantity',1,1,17,NULL, 166002,	1,	Getdate())
END



IF NOT EXISTS(select * from tra_TemplateMaster where CommunicationModeCodeId = 156017)
BEGIN
Insert into tra_TemplateMaster values(
'Continuous Disclosures Form for Other Securities Without Quantity',156017,NULL,NULL,1,	NULL,NULL,NULL,NULL,	
'<div style="margin: 30px; width: 650px;font-family: Roboto, sans-serif;font-size:11.5px; padding-left:10px;">        
<p style="text-align: center;font-size:18px""><b>        Trade Details Form for Other Securities </b>       </p>       
<br /><br />       <p><b>Date</b> &nbsp;:  [CDOS_INTIMATIONDATE] </p>       
<p><b>To</b> &nbsp;&nbsp;&nbsp;  :  Compliance Officer </p>       
<p><b>From</b> :  [CDOS_FIRSTNAME] [CDOS_MIDDLENAME] [CDOS_LASTNAME]</p>       
<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;      [CDOS_EMPLOYEEID]</p>      
<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp;    [CDOS_DEPT] </p>           <br />      
<p style="text-align: justify;"> DETAILS OF TRANSACTION</p>       <br />      
<p>Ref: Your Approval PCL  No.&nbsp; [PCLOS_NO] &nbsp; dated &nbsp; [PCLOS_DATE] </p>       
<P>I hereby inform you that &nbsp; [CDOS_FIRSTNAME] [CDOS_MIDDLENAME] [CDOS_LASTNAME] &nbsp; has bought/sold/ Securities as mentioned below </P>       
<br/>       
<table border="1" cellspacing="0" cellpadding="10" style="max-width: 700px;font-family:inherit;font-size:inherit;">          
<tbody>        <tr height="18">         
<td width="50" valign="top" style="word-wrap: break-word"><b>Account Holder Name  </b></td>         
<td width="50" valign="top" style="word-wrap: break-word"><b>Relation with Insider </b></td>         
<td width="80" valign="top" style="word-wrap: break-word"><b>PAN </b></td>         
<td width="50" valign="top" style="word-wrap: break-word"><b>Name of the Security(ies) </b></td>         
<td width="50" valign="top" style="word-wrap: break-word"><b>Type of Security </b></td>         .
<td width="45" valign="top" style="word-wrap: break-word"><b>Nature of Transaction </b></td>         
<td width="50" valign="top" style="word-wrap: break-word"><b>Demat Account No. </b></td>                  
<td width="60" valign="top" style="word-wrap: break-word"><b>Name of the Exchange </b></td>        </tr>          
<tr height="18">         
<td width="50" height="18" valign="top"> [CDOS_ACCOUNTHOLDERNAME] </td>         
<td width="50" height="18" valign="top"> [CDOS_RELATIONWITHINSIDER] </td>        
<td width="80" height="18" valign="top"> [CDOS_PAN] </td>       
<td width="50" height="18" valign="top"> [CDOS_COMPANYNAME] </td>       
<td width="50" height="18" valign="top"> [CDOS_SECURITYTYPE] </td>      
<td width="45" height="18" valign="top"> [CDOS_TRANSACTIONTYPE] </td>   
<td width="50" height="18" valign="top"> [CDOS_DEMATACCOUNTNO] </td>           
<td width="60" height="18" valign="top"> [CDOS_NAMEOFEXCHANGE] </td>   
</tr>         </tbody>       </table>       <br /> <br />       
<p style="text-align: justify;">I declare that the above information is correct and that no provisions of the Company’s 
Trading Code of Conduct and/or applicable laws/regulations have been contravened for effecting the above said transaction(s).</p>       
<p style="text-align: justify;">I agree not to buy/sell ? the Securities for a period of 6 months/30 days ?, as the case may be from the 
date of the aforesaid transaction (applicable in case of purchase / sale transaction by Designated Persons only).</p>       
<p style="text-align: justify;">In case there is any urgent need to sell these Securities within the said period, I shall 
approach the Company (Compliance Officer) for necessary approval (applicable in case of purchase / subscription).</p>        
<br/>       <p>Yours truly,</p>       <p>Signature:</p>       <br/>       
<p>Name:[CDOS_FIRSTNAME] [CDOS_MIDDLENAME] [CDOS_LASTNAME]</p>                    
</div>',
NULL,	NULL,	NULL,	0,	1,	Getdate(),	1,	Getdate())

END

IF NOT EXISTS(select * from tra_TemplateMaster where CommunicationModeCodeId = 156016)
BEGIN
Insert into tra_TemplateMaster values(
'Initial Disclosures Form for Other Securities Without Quantity',156016,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	
'<div style="margin: 30px; width: 650px;font-family: Roboto, sans-serif;font-size:12px; padding-left:10px;">          
<p style="text-align: center; font-size:18px">              
<b>Initial Disclosures Form for Other Securities  </b>          </p>          
<br /><br /><br /><br />            
<p><b>NAME : </b> [USROS_FIRSTNAME] [USROS_MIDDLENAME] [USROS_LASTNAME]</p><br />          
<p><b>EMPLOYEE CODE : </b>[USROS_EMPLOYEEID]</p><br />          
<p><b>BRANCH/DEPARTMENT : </b> [USROS_DEPT]</p>                  <br /><br /><br />          
<p style="text-align: justify;"> <b>Please note that as of [USROS_INITIALDISCLOSURESUBMISSIONDATE] I hold securities of the following listed 
companies, as under: </b></p>          <br /><br />            
<table border="1" cellspacing="0" cellpadding="10" style="max-width: 700px;font-family:inherit;font-size:inherit;">            
<tbody>              <tr height="18">                  
<td width="120" valign="top" style="word-wrap: break-word"><b>Demat Account  </b></td>                  
<td width="50" valign="top" style="word-wrap: break-word"><b>Account Holder Name </b></td>              
<td width="52" valign="top" style="word-wrap: break-word"><b>Relation with Insider </b></td>            
<td width="80" valign="top" style="word-wrap: break-word"><b>PAN </b></td>                
<td width="90" valign="top" style="word-wrap: break-word"><b>Scrip Name </b></td>            
<td width="50" valign="top" style="word-wrap: break-word"><b>ISIN </b></td>               
<td width="50" valign="top" style="word-wrap: break-word"><b>Security Type </b></td>               
               
</tr>                <tr height="18">                  
<td width="120" height="18" valign="top"> [USROS_DEMATACCOUNT] </td>                
<td width="50" height="18" valign="top"> [USROS_FIRSTNAME] [USROS_MIDDLENAME] [USROS_LASTNAME] </td>             
<td width="52" height="18" valign="top"> [USROS_RELATIONWITHINSIDER] </td>               
<td width="80" height="18" valign="top"> [USROS_PAN] </td>               
<td width="90" height="18" valign="top"> [USROS_SCRIP_NAME] </td>               
<td width="50" height="18" valign="top"> [USROS_ISIN] </td>                
<td width="50" height="18" valign="top"> [USROS_SECURITYTYPE] </td>             
                             
</tr>               </tbody>          </table>          
<br /> <br /><br /><br /><br /><br /><br /><br />            
<p><b>Signature:</b></p><br />          <p><b>Designation: </b> [USROS_DESIGNATION] </p><br />          
<p><b>Date: </b></p><br />          <p><b>Place: </b></p>            
</div>',	NULL,	NULL,	NULL,	0,	1,	GETDATE(),	1,	GETDATE())
END

IF NOT EXISTS(select * from tra_TemplateMaster where CommunicationModeCodeId = 156019)
BEGIN
Insert into tra_TemplateMaster values(
'Period End Form for Other Securities Without Quantity Template',	156019,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,
'<div style="margin: 30px; width: 650px;font-family: Roboto, sans-serif;font-size:10px;">         
<p style="text-align: right; font-size:18px;padding-right:10px"> <b>[PERIODEND_FREQUENCY] statement of holdings 
from [FROM_DATEOF_PERIODEND_DISCLOSURES] to [TO_DATEOF_PERIODEND_DISCLOSURES] </b>  </p>          <br /><br />         
<p><b>Date :  [DATEOF_SUBMISSION]</b> </p><br />          
<p>[NAMEOF_IMPLEMENTING_COMPANY]</p>          
<p>ISIN Number : [ISIN_NUMBER]</p><br>          
<p>Period end statement of holdings of securities of all listed companies :</p><br>                
<br /><br /><br />          <table border="1" cellspacing="0" cellpadding="10" style="max-width: 650px;font-family:inherit;font-size:inherit;"> 
<tbody>                  <tr height="100">                      
<td   style="word-wrap: break-word;width=80;valign:top"><b>Name, PAN,<br /> CIN/DIN, Address  </b></td>                     
<td   style="word-wrap: break-word;width=50;valign:top"><b>Category of Person<br /> (Promoter/ KMP/Director/<br /> Immediate relative to etc) </b></td> 
<td   style="word-wrap: break-word;width=50;valign:top"><b>Demat<br /> Account<br /> Number </b></td>         
<td   style="word-wrap: break-word;width=50;valign:top"><b>Type of Security </b></td>                     
<td   style="word-wrap: break-word;width=50;valign:top"><b>Name of company </b></td>                            
</tr>                  <tr height="50">                     
<td style="width:80; height:18; valign:middle"> [NAME],[PAN],[CIN] [DIN],[ADDRESS] </td>                  
<td style="width:50; height:18; valign:middle"> [SUB_CATEGORYOF_PERSONS] </td>                   
<td style="width:50; height:18; valign:middle"> [DEMAT_ACCOUNT_NUMBER] </td>                   
<td style="width:50; height:18; valign:middle"> [SECURITY_TYPE] </td>                   
<td style="width:50; height:18; valign:middle"> [NAMEOF_TRADING_COMPANY] </td>                                    
            
</tr>              </tbody>          </table>          <br /> <br /><br /><br /><br /><br /><br /><br />         
<p>I do hereby also confirm the following:<br/><br />     &nbsp;- I am aware of the Company’s- Trading Code of Conduct and the procedures
thereunder and have not contravened the same.<br />     &nbsp;- No contra trades have been executed by me and my affected persons within the
specified timelines.    </p><br />    <p> Kindly treat this communication as a disclosure under the Company’s Trading Code of Conduct.<br />   
&nbsp;I hereby declare that the information above is true and correct to the best of my knowledge.</p>          <br /><br />        
<p><b>Name:</b> [EMPLOYEE_NAME]</p><br />          <p><b>Employee Code: </b> [EMPLOYEE_CODE] </p><br />          
<p><b>Designation : </b>[DESIGNATION]</p><br />          <p><b>Branch / Department: </b>[DEPARTMENT]</p>      
</div>',	NULL,	NULL,	NULL,	0,	1,	GETDATE(),	1,GETDATE())
END

IF NOT EXISTS(select * from tra_TemplateMaster where CommunicationModeCodeId = 156018)
BEGIN
Insert into tra_TemplateMaster values(
'Pre-clearance form for Implementing Company Without Quantity Form E Template',	156018,	NULL,	NULL,	1,	NULL,	NULL,	NULL,	NULL,	
'<p style="text-align:center"><strong>FORM - E</strong>(for physical pre-clearance/e-mail)</p>    
<p style="text-align:center">&nbsp;</p>    <p style="text-align:center"><em>[PCL_IMPLEMENTCOMPANY] Trading Code of Conduct</em></p>    
<p style="text-align:center">APPLICATION TO TRADE</p>    <p>&nbsp;</p>    <p>To</p>    <p>Compliance Officer</p>    <p>From,</p>    
<p>NAME OF EMPLOYEE :&nbsp;[USR_FIRSTNAME][USR_MIDDLENAME][USR_LASTNAME]</p>    <p>EMPLOYEE CODE :&nbsp; &nbsp; &nbsp;&nbsp;<u>[USR_EMPLOYEEID]</u></p>  
<p>BRANCH/DEPARTMENT :<u>[USR_DEPT]</u></p>    <p>&nbsp;</p>    <p>With reference to the [PCL_IMPLEMENTCOMPANY]&nbsp;Trading Code of Conduct, 
I here by give notice that I / my affected person Mr/ Ms [USR_FIRSTNAME][USR_MIDDLENAME][USR_LASTNAME]propose to carry 
out the following transaction:-</p>    <p>(Note: For offline trades, please fill separate forms for self and each of 
affected person.The code number above should be of the person in whose name the transaction is proposed)</p>    <p>&nbsp;</p>   
<p>&nbsp;</p>    <table border="1" cellpadding="10" cellspacing="0" style="width:100%">   <tbody>    <tr>     
<td><strong>Name of the Security(ies) </strong></td>     
<td><strong>Type of Security </strong></td>   
<td><strong>Nature of Transaction </strong></td>   
<td><strong>Indicative Price / Premium (for offline trade only) </strong></td>   
<td><strong>Name of the Exchange </strong></td>   
<td><strong>Date of purchase / allotment (applicable only if the application is in respect of sale of Securities) </strong></td>    
<td><strong>*Previous approval no. and date for purchase/allotment)</strong></td>    
<td><strong>Name of Proposed Buyer/ Seller in case of offline trade </strong></td>   
</tr>    <tr>     
<td>[PCL_TRADEDFORCOMPANY]</td>    
<td>[PCL_SECURITYTYPE]</td>     
<td>[PCL_TRANSACTNTYPE]</td>     
<td>Not Applicable</td>   
<td>&nbsp;</td>     
<td>[PCL_BUYDATE]</td>   
<td>[PCL_PREVAPPROVNUMBERANDDATE]</td>   
<td>[PCL_STATUS]</td>    
</tr>   </tbody>  </table>    
<p><strong>* applicable only if the application is in respect of sale of Securities for which an earlier purchase sanction was 
granted by the Compliance Officer</strong></p>    <p>&nbsp;</p>    <p>&nbsp;</p>    <p>&nbsp;</p>    <p>In this connection, 
I do hereby represent and undertake as follows:-</p>    <ol>   
<li>That I am aware of the SEBI (Prohibition of Insider Trading) Regulations, 2015(Regulations) and the [PCL_IMPLEMENTCOMPANY] 
(Bank/Company)-Trading Code of Conduct and procedures made thereunder and have not contravened the Regulations and the Code/procedures 
laid down by the Bank for prevention of insider trading as notified by the Bank from time to time.</li>  
<li>That I do not have any access nor have I received any &quot;Unpublished Price Sensitive Information&quot; 
as defined in the Regulations as amended up to and at the time of signing the undertaking in respect of the aforesaid securities.</li>   
<li>That in case I have access to or receive &quot;Unpublished Price Sensitive Information&quot; after the signing of the undertaking 
but before the execution of any transactions in securities of the Company, I shall inform the Compliance Officer of the change in my 
position and that I would completely refrain from dealing in the securities of the company till the time such information becomes generally 
available or ceases to be price sensitive.</li>   <li>I am not trading in any securities including the Bank securities, which 
I have undertaken a contra-trade in the last 6 months, as the case may be subject to exception granted by Clause 9.5 of the Code of the Bank,
if applicable.</li>   <li>I undertake to submit the necessary report within 2 trading days of execution of the transaction/a &#39;Nil&#39; 
report if the transaction is not undertaken.</li>   <li>I agree to comply with the provisions of the Code and provide any information related
to the trade as may be required by the Compilance Officer and permit the company to disclosure such details to SEBI, if so required by SEBI.</li>  
<li>That I have made a full and true disclosure in the matter.</li>  </ol>    <p>&nbsp;</p>    
<p>Date:[PCL_REQUESTDATE]&nbsp;<u>[USR_LASTNAME]</u></p>    <p>&nbsp;</p>    <p>&nbsp;</p>    
<p>(Signature) / (Approval by email)</p>    <p>&nbsp;</p>    <p>AUTHORISATION TO TRADE</p>    
<p>The above transaction has been authorised. Your dealing must be completed within 7 trading days from the date of approval. 
(Including the date of approval).</p>    <p>&nbsp;</p>    <p>Date:[PCL_APPROVEDDATE]&nbsp;<u>[PCL_APPROVEDBY]</u></p>    
<p>&nbsp;</p>    <p>&nbsp;</p>    <p>(Signature) / (Approval by email)</p>',  	
NULL,	NULL,	NULL,	0,	1,GETDATE(),	1,	GETDATE())
END
