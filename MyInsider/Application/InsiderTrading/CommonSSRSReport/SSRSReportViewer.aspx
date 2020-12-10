<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="SSRSReportViewer.aspx.cs" Inherits="InsiderTrading.CommonSSRSReport.SSRSReportViewer" %>

<%@ Register Assembly="Microsoft.ReportViewer.WebForms, Version=11.0.0.0, Culture=neutral, PublicKeyToken=89845dcd8080cc91"
    Namespace="Microsoft.Reporting.WebForms" TagPrefix="rsweb" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>View Report</title>
     <script src="../Scripts/jQuery/jQuery-2.1.3.js"></script>
    <script src="../Scripts/jQuery/jQuery-2.1.3.min.js"></script>
 

    <script src="../Scripts/bootstrap/js/bootstrap.js"></script>
    <script src="../Scripts/bootstrap/js/bootstrap.min.js"></script>

    <script src="../Scripts/jQueryUI/jquery-ui-1.12.1.js"></script>
    <script src="../Scripts/jQueryUI/jquery-ui-1.12.1.min.js"></script>

    <script src="../Scripts/datepicker/bootstrap-datepicker.js"></script>
    <link href="../Scripts/datepicker/datepicker3.css" rel="stylesheet" />
    <link href="../Scripts/daterangepicker/daterangepicker-bs3.css" rel="stylesheet" />
    <script src="../Scripts/daterangepicker/daterangepicker.js"></script>

 <%--   <script src="../Scripts/dist/js/custom.js"></script>--%>
</head>
<script lang="javascript" type="text/javascript">  

    function pageLoad(sender, args)  // This is the function which calls every time when page load / after update panel get refresh.
    {
        $(document).ready(function () {
            var hdnBrowserName = GetBrowserName();

            if (hdnBrowserName == "Chrome" || hdnBrowserName == "Safari") {
                $($(":hidden[id*='DatePickers']").val().split(",")).each(function (i, item) {
                    var h = $("table[id*='ParametersGrid']").filter(function (i) {
                        var v = "[" + $(this).text() + "]";
                        return (v != null && v != '[NULL]' && v.toUpperCase().indexOf('DATE') >= 0 && v.toUpperCase().indexOf('SELECT DATE')<=0);
                    }).parent("td").find("input:text[readonly!=readonly]").datepicker({
                        format: 'dd-MM-yyyy'
                    });
                });
            }
        });
    }

    function GetBrowserName() {
        var objAgent = navigator.userAgent;
        var hdnBrowserName = "";
        // In Chrome 
        if (objAgent.indexOf("Chrome") != -1) {
            hdnBrowserName = "Chrome";
        }
            // In Microsoft internet explorer 
        else if (objAgent.indexOf("MSIE") != -1) {
            hdnBrowserName = "MSIE";
        }
            // In Firefox 
        else if (objAgent.indexOf("Firefox") != -1) {
            hdnBrowserName = "Firefox";
        }
            // In Safari
        else if (objAgent.indexOf("Safari") != -1) {
            hdnBrowserName = "Safari";
        }
        return hdnBrowserName;
    };
    
</script>

<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="SSRSScriptmanager" runat="server"></asp:ScriptManager>
        <asp:HiddenField ID="DatePickers" runat="server" clientidmode="Static"/>
        <div>
            <rsweb:ReportViewer ID="SSRSReport" runat="server" Height="100%" SizeToReportContent="false" Width="100%"></rsweb:ReportViewer>
        </div>
    </form>
</body>
</html>
