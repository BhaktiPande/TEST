
$(document).ready(function () {

    var count = 0;
    var dataTable = null;//$("table[name='DatatableGrid'][gridtype='" + $("#1").attr("gridtype") + "']").dataTable();
    if ($('.search #1').val() != "0" && $('.search #2').val() != "0") {
        $('#btnSave').removeAttr('disabled');
    }
    else {
        $('#btnSave').attr('disabled', 'disabled');
    }
    $(document).delegate(".inpRowDaysPriorToResultDeclaration", "blur", function () {
        var DaysPriorToResultDeclaration = $(this).val();

        if (DaysPriorToResultDeclaration != "" && !isNaN(DaysPriorToResultDeclaration)) {
            if ($(this).closest("tr").find(".inpRowResultDeclarationDate").val() != "") {
                var months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
                var months1 = [];
                months1['JAN'] = 0;
                months1['FEB'] = 1;
                months1['MAR'] = 2;
                months1['APR'] = 3;
                months1['MAY'] = 4;
                months1['JUN'] = 5;
                months1['JUL'] = 6;
                months1['AUG'] = 7;
                months1['SEP'] = 8;
                months1['OCT'] = 9;
                months1['NOV'] = 10;
                months1['DEC'] = 11;
                var ResultDeclarationDate = moment($(this).closest("tr").find(".inpRowResultDeclarationDate").val().toLowerCase());

                var SelectedDateArr = $(this).closest("tr").find(".inpRowResultDeclarationDate").val();

            

                SelectedDateArr = SelectedDateArr.split("/");
                var SelectedMonthIndex = months1[SelectedDateArr[1]];
                var OriginalMonthIndex = Number(SelectedMonthIndex + 1);
                var SelectedDate = SelectedDateArr[2] + "/" + OriginalMonthIndex + "/" + SelectedDateArr[0]
                ResultDeclarationDate = moment(SelectedDate, "YYYY-MM-DD");

                ResultDeclarationDate.subtract(DaysPriorToResultDeclaration, 'days');
                var testValue1 = moment(ResultDeclarationDate).format("DD/MM/YYYY").toString().split('/');
                var a1 = Number(testValue1[1]);
                var value1 = testValue1[0] + '/' + (months[a1 - 1]) + '/' + testValue1[2];
               // alert(value1);
                $(this).closest("tr").find(".inpRowWindowCloseDate").val(value1);
            }
            else {
                $(this).closest("tr").find(".inpRowWindowCloseDate").val("");
            }
        }
        else {
            $(this).closest("tr").find(".inpRowWindowCloseDate").val("");
        }
        //$(this).valid();
        $("#divValidationSummaryModal").removeAttr('disabled');
        $("#divValidationSummaryModal").attr("style", "display: none;")
        $("#divValidationSummaryModal ul").html("");
        $("#divValidationSummaryModal").removeClass("validation-summary-errors");
        $("#divValidationSummaryModal").addClass("validation-summary-valid");
    });
    $(document).delegate(".inpRowDaysPostToResultDeclaration", "blur", function () {
        var DaysPostToResultDeclaration = $(this).val();
        if (DaysPostToResultDeclaration != "" && !isNaN(DaysPostToResultDeclaration)) {
            if ($(this).closest("tr").find(".inpRowResultDeclarationDate").val() != "") {
                var months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
                var months1 = [];
                months1['JAN'] = 0;
                months1['FEB'] = 1;
                months1['MAR'] = 2;
                months1['APR'] = 3;
                months1['MAY'] = 4;
                months1['JUN'] = 5;
                months1['JUL'] = 6;
                months1['AUG'] = 7;
                months1['SEP'] = 8;
                months1['OCT'] = 9;
                months1['NOV'] = 10;
                months1['DEC'] = 11;
                var ResultDeclarationDate = moment($(this).closest("tr").find(".inpRowResultDeclarationDate").val().toLowerCase());

                var SelectedDateArr = $(this).closest("tr").find(".inpRowResultDeclarationDate").val();
                SelectedDateArr = SelectedDateArr.split("/");
                var SelectedMonthIndex = months1[SelectedDateArr[1]];
                var OriginalMonthIndex = Number(SelectedMonthIndex + 1);
                var SelectedDate = SelectedDateArr[2] + "/" + OriginalMonthIndex + "/" + SelectedDateArr[0]
                ResultDeclarationDate = moment(SelectedDate, "YYYY-MM-DD");
                DaysPostToResultDeclaration = parseInt(DaysPostToResultDeclaration) + 1;
                ResultDeclarationDate.add(DaysPostToResultDeclaration, 'days');
                var testValue = moment(ResultDeclarationDate).format("DD/MM/YYYY").toString().split('/');
                var a = Number(testValue[1]);
                var value = testValue[0] + '/' + (months[a - 1]) + '/' + testValue[2];
                $(this).closest("tr").find(".inpRowWindowOpenDate").val(value);
            }
            else {
                $(this).closest("tr").find(".inpRowWindowOpenDate").val("");
            }
        }
        else {
            $(this).closest("tr").find(".inpRowWindowOpenDate").val("");
        }
        //$(this).valid();
        $("#divValidationSummaryModal").removeAttr('disabled');
        $("#divValidationSummaryModal").attr("style", "display: none;")
        $("#divValidationSummaryModal ul").html("");
        $("#divValidationSummaryModal").removeClass("validation-summary-errors");
        $("#divValidationSummaryModal").addClass("validation-summary-valid");
    });
    $(document).delegate(".inpRowResultDeclarationDate", "change", function () {
        var DaysPostToResultDeclaration = $(this).closest("tr").find(".inpRowDaysPostToResultDeclaration").val();
        var DaysPriorToResultDeclaration = $(this).closest("tr").find(".inpRowDaysPriorToResultDeclaration").val();
        if ($(this).val() != "") {
            if (DaysPostToResultDeclaration != "" && !isNaN(DaysPostToResultDeclaration) && DaysPriorToResultDeclaration != "" && !isNaN(DaysPriorToResultDeclaration)) {
                var months = ["JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL", "AUG", "SEP", "OCT", "NOV", "DEC"];
                var months1 = [];
                months1['JAN'] = 0;
                months1['FEB'] = 1;
                months1['MAR'] = 2;
                months1['APR'] = 3;
                months1['MAY'] = 4;
                months1['JUN'] = 5;
                months1['JUL'] = 6;
                months1['AUG'] = 7;
                months1['SEP'] = 8;
                months1['OCT'] = 9;
                months1['NOV'] = 10;
                months1['DEC'] = 11;
                var ResultDeclarationDate = moment($(this).val().toLowerCase())
                var SelectedDateArr = $(this).val();
                SelectedDateArr = SelectedDateArr.split("/");
                var SelectedMonthIndex = months1[SelectedDateArr[1]];
                var OriginalMonthIndex = Number(SelectedMonthIndex + 1);
                var SelectedDate = SelectedDateArr[2] + "/" + OriginalMonthIndex + "/" + SelectedDateArr[0]
                ResultDeclarationDate = moment(SelectedDate, "YYYY-MM-DD");
                DaysPostToResultDeclaration = parseInt(DaysPostToResultDeclaration) + 1;
                ResultDeclarationDate.add(DaysPostToResultDeclaration, 'days');
                var testValue = moment(ResultDeclarationDate).format("DD/MM/YYYY").toString().split('/');
                var a = Number(testValue[1]);
                var value = testValue[0] + '/' + (months[a-1]) + '/' + testValue[2];
                $(this).closest("tr").find(".inpRowWindowOpenDate").val(value);
                var ResultDeclarationDate1 = moment(SelectedDate, "YYYY-MM-DD");
                ResultDeclarationDate1.subtract(DaysPriorToResultDeclaration, 'days');
                var testValue1 = moment(ResultDeclarationDate1).format("DD/MM/YYYY").toString().split('/');
                var a1 = Number(testValue1[1]);
                var value1 = testValue1[0] + '/' + (months[a1 - 1]) + '/' + testValue1[2];
                $(this).closest("tr").find(".inpRowWindowCloseDate").val(value1);
            }
        }
        else {
            $(this).closest("tr").find(".inpRowWindowCloseDate").val("");
            $(this).closest("tr").find(".inpRowWindowOpenDate").val("");
        }
       
        $("#divValidationSummaryModal").removeAttr('disabled');
        $("#divValidationSummaryModal").attr("style", "display: none;")
        $("#divValidationSummaryModal ul").html("");
        $("#divValidationSummaryModal").removeClass("validation-summary-errors");
        $("#divValidationSummaryModal").addClass("validation-summary-valid");

    });
    $(document).delegate(".inpRowResultDeclarationDate", "blur", function () {
        var DaysPostToResultDeclaration = $(this).closest("tr").find(".inpRowDaysPostToResultDeclaration").val();
        var DaysPriorToResultDeclaration = $(this).closest("tr").find(".inpRowDaysPriorToResultDeclaration").val();
        if ($(this).val() != "") {
            if (DaysPostToResultDeclaration != "" && !isNaN(DaysPostToResultDeclaration) && DaysPriorToResultDeclaration != "" && !isNaN(DaysPriorToResultDeclaration)) {
                var months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
                var months = ["JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL", "AUG", "SEP", "OCT", "NOV", "DEC"];
                var months1 = [];
                months1['JAN'] = 0;
                months1['FEB'] = 1;
                months1['MAR'] = 2;
                months1['APR'] = 3;
                months1['MAY'] = 4;
                months1['JUN'] = 5;
                months1['JUL'] = 6;
                months1['AUG'] = 7;
                months1['SEP'] = 8;
                months1['OCT'] = 9;
                months1['NOV'] = 10;
                months1['DEC'] = 11;
                var ResultDeclarationDate = moment($(this).val().toLowerCase());
                var SelectedDateArr = $(this).val();
                SelectedDateArr = SelectedDateArr.split("/");
                var SelectedMonthIndex = months1[SelectedDateArr[1]];
                var OriginalMonthIndex = Number(SelectedMonthIndex + 1);
                var SelectedDate = SelectedDateArr[2] + "/" + OriginalMonthIndex + "/" + SelectedDateArr[0]
                ResultDeclarationDate = moment(SelectedDate, "YYYY-MM-DD");
                DaysPostToResultDeclaration = parseInt(DaysPostToResultDeclaration) + 1;
                ResultDeclarationDate.add(DaysPostToResultDeclaration, 'days');
                var testValue = moment(ResultDeclarationDate).format("DD/MM/YYYY").toString().split('/');
                var a = Number(testValue[1]);
                var value = testValue[0] + '/' + (months[a - 1]) + '/' + testValue[2];
                $(this).closest("tr").find(".inpRowWindowOpenDate").val(value);
                var ResultDeclarationDate1 = moment(SelectedDate, "YYYY-MM-DD");
                ResultDeclarationDate1.subtract(DaysPriorToResultDeclaration, 'days');
                var testValue1 = moment(ResultDeclarationDate1).format("DD/MM/YYYY").toString().split('/');
                var a1 = Number(testValue1[1]);
                var value1 = testValue1[0] + '/' + (months[a1 - 1]) + '/' + testValue1[2];
                $(this).closest("tr").find(".inpRowWindowCloseDate").val(value1);
            }
        }
        else {
            $(this).closest("tr").find(".inpRowWindowCloseDate").val("");
            $(this).closest("tr").find(".inpRowWindowOpenDate").val("");
        }

    });
    $(document).delegate(".inpRowDaysPriorToResultDeclaration", "keydown", function (e) {
        NumberOnly(e);
    });
    $(document).delegate(".inpRowDaysPostToResultDeclaration", "keydown", function (e) {
        NumberOnly(e);
    });
    $(document).delegate("#btnSave", "click", function () {
       
        var form = $('#frmTradingWindowEvent');
        var token = $('input[name="__RequestVerificationToken"]', form).val();        
        
        dataTable = $("table[name='DatatableGrid'][gridtype='" + $(this).attr("gridtype") + "']").dataTable();
        objTable = $("table[name='DatatableGrid'][gridtype='" + $(this).attr("gridtype") + "']");
        
        if ($('.search #1').val() != "0" && $('.search #2').val() != "0")
        {
            Save(dataTable, objTable, token);
        }
        
    });
    $(document).delegate(".search #1", "change", function () {

        
        $('#FinancialYearId').val($(this).val());
        $('#FinancialPeriodTypeId').val($('.search #2').val());
        dataTable = $("table[name='DatatableGrid'][gridtype='" + $(this).attr("gridtype") + "']").dataTable();
        
        populateGrid(dataTable, $(this).val(), $('.search #2').val())
        if ($('.search #1').val() != "0" && $('.search #2').val() != "0") {
            $('#btnSave').removeAttr('disabled');
        }
        else {
            $('#btnSave').attr('disabled', 'disabled');
        }
    });
    $(document).delegate(".search #2", "change", function () {
        dataTable = $("table[name='DatatableGrid'][gridtype='" + $(this).attr("gridtype") + "']").dataTable()
        if ($('.search #1').val() != 0) {

            $('#FinancialYearId').val($('.search #1').val());
            $('#FinancialPeriodTypeId').val($('.search #2').val());
           // $('#btnsearch').click();
            dataTable.fnDraw();
        }
        if ($('.search #1').val() != "0" && $('.search #2').val() != "0") {
            $('#btnSave').removeAttr('disabled');
        }
        else {
            $('#btnSave').attr('disabled', 'disabled');
        }
    });
   

});
function NumberOnly(e) {

    // Allow: backspace, delete, tab, escape, enter and .
    if ($.inArray(e.keyCode, [46, 8, 9, 27, 13]) !== -1 ||
        // Allow: Ctrl+A
        (e.keyCode == 65 && e.ctrlKey === true) ||
        // Allow: home, end, left, right, down, up
        (e.keyCode >= 35 && e.keyCode <= 40)) {
        // let it happen, don't do anything
        return;
    }
    // Ensure that it is a number and stop the keypress
    if (((e.keyCode < 48 || e.keyCode > 57)) && (e.keyCode < 96 || e.keyCode > 105)) {
        e.preventDefault();
    }
}
function populateGrid(dataTable, nFinancialYearId, nFinancialPeriodTypeId)
{
    var postData = { FinancialYearId: $("#FinancialYearId").val(), FinancialPeriodTypeId: $("#FinancialYearId").val(), acid: $("#acid").val() };
    $.ajax({
        url: $("#dropdownIndex").val(),
        type: 'post',
        headers: getRVToken(),
        dataType: 'json',
        data: JSON.stringify(postData),
        contentType: 'application/json; charset=utf-8',
        success: function (data) {
            if (data.status) {
                $('.search #2').val(data.FinancialPeriodTypeId);
                $('#FinancialPeriodTypeId').val(data.FinancialPeriodTypeId);
                if ($('.search #1').val() != "0" && $('.search #2').val() != "0") {
                    $('#btnSave').removeAttr('disabled');
                }
                else {
                    $('#btnSave').attr('disabled', 'disabled');
                }
                $("#divValidationSummaryModal").removeAttr('disabled');
                $("#divValidationSummaryModal").attr("style", "display: none;")
                $("#divValidationSummaryModal ul").html("");
                $("#divValidationSummaryModal").removeClass("validation-summary-errors");
                $("#divValidationSummaryModal").addClass("validation-summary-valid");
                dataTable.fnDraw();
            }
        },
        error: function (jqXHR, textStatus, errorThrown) {
            alert(errorThrown);
           // $('#divValidationSummaryModal').val("Error");
        }
    });
}
function Save(dataTable, objTable, token) {
    
    var lst = new Array();
    $("#" + $(objTable).attr("id") + " > tbody  > tr").each(function () {

        //var form = $('#frmTradingWindowEvent');
        //var token = $('input[name="__RequestVerificationToken"]', form).val();

        var inpTradingWindowEventId = $(this).find(".inpRowTradingWindowEventId").val();
        var inpFinancialYearCodeId = $(this).find(".inpRowFinancialYearCodeId").val();
        var inpFinancialPeriodCodeId = $(this).find(".inpRowFinancialPeriodCodeId").val();
        var inpTradingWindowId = $(this).find(".inpRowTradingWindowId").val();
        var inpRowResultDeclarationDate = $(this).find(".inpRowResultDeclarationDate").val();
        var inpRowWindowCloseDate = $(this).find(".inpRowWindowCloseDate").val();
        var inpRowWindowOpenDate = $(this).find(".inpRowWindowOpenDate").val();
        var inpRowDaysPriorToResultDeclaration = $(this).find(".inpRowDaysPriorToResultDeclaration").val();
        var inpRowDaysPostToResultDeclaration = $(this).find(".inpRowDaysPostToResultDeclaration").val();

        var json = {
            TradingWindowEventId: inpTradingWindowEventId,
            FinancialYearCodeId: inpFinancialYearCodeId,
            FinancialPeriodCodeId: inpFinancialPeriodCodeId,
            TradingWindowId: inpTradingWindowId,
            ResultDeclarationDate: inpRowResultDeclarationDate,
            WindowCloseDate: inpRowWindowCloseDate,
            WindowOpenDate: inpRowWindowOpenDate,
            DaysPriorToResultDeclaration: inpRowDaysPriorToResultDeclaration,
            DaysPostResultDeclaration: inpRowDaysPostToResultDeclaration,           
        };
        lst.push(json);

        
    });
    //alert(token);
    var postData = { tradingWindowEventModel: lst, nFinancialYearCodeId: $("#FinancialYearId").val(), nFinancialPeriodTypeCodeId: $("#FinancialPeriodTypeId").val(), acid: $("#TradingWindowEventCreateUserAction").val(),__RequestVerificationToken: token, formId:30};
    //var postData = { tradingWindowEventModel: lst, nFinancialYearCodeId: $("#FinancialYearId").val(), nFinancialPeriodTypeCodeId: $("#FinancialPeriodTypeId").val(), acid: $("#TradingWindowEventCreateUserAction").val() };
    if ($("#frmTradingWindowEvent").valid()) {

        $.ajax({
            url: $("#Create").val(),
            type: 'post',
            headers: getRVToken(),
            dataType: 'json',
            data: JSON.stringify(postData),
            contentType: 'application/json; charset=utf-8',
            success: function (data) {
                if (data.status) {

                    showMessage(data.Message, true);
                    dataTable.fnDraw();
                }
                else {
                    //$('.search #2').val(0);
                    DisplayErrors(data.error);
                    //dataTable.fnDraw();
                    //alert(data.Message);
                }
            },
            error: function (data) {
                DisplayErrors(data.error);
            }
        });
    }
}
function DisplayErrors(errors) {


    $("#divValidationSummaryModal ul").html("");
    for (index in errors) {
        var obj = errors[index];
        for (i = 0; i < obj.length; i++) {
            var li = $("<li>");
            $(li).text(obj[i]);
            $("#divValidationSummaryModal ul").append($(li));
        }
    }

    $('#divValidationSummaryModal').slideDown(500);
    $('#messageSection div').not('#divValidationSummaryModal,#mainMessageSection').remove();
    $("#divValidationSummaryModal").removeClass("validation-summary-valid");
    $("#divValidationSummaryModal").addClass("validation-summary-errors");
}

function dateTimeFormat(i_dDateTime) {
    var re = /-?\d+/;
    var datetime = "";
    if (i_dDateTime != null && i_dDateTime != "") {
        var m = re.exec(i_dDateTime);
        var d = new Date(parseInt(m[0]));
        var month = ("0" + (d.getMonth() + 1)).slice(-2);
        var months = ['JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN', 'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC'];
        datetime = ("0" + d.getDate()).slice(-2) + "/" + months[month - 1] + "/" + d.getFullYear();
    }
    return datetime;
}
