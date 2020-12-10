$(document).ready(function () {
  
    $(document).delegate('#CalculateBefore', 'click', function (event) {
        var months = ['JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN', 'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC'];
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
        var DecalrationDate = $('#ResultDeclarationDate').val();
        var ResultDeclarationDate = moment(DecalrationDate.toLowerCase());

        var SelectedDateArr = $('#ResultDeclarationDate').val();
        SelectedDateArr = SelectedDateArr.split("/");
        var SelectedMonthIndex = months1[SelectedDateArr[1]];
        var OriginalMonthIndex = Number(SelectedMonthIndex + 1);
        var SelectedDate = SelectedDateArr[2] + "/" + OriginalMonthIndex + "/" + SelectedDateArr[0]
        ResultDeclarationDate = moment(SelectedDate, "YYYY-MM-DD");

       
        var DecalrationTimeHrs = parseInt($('#ResultDeclarationHrs').val());
        var DeclarationTimeMins = parseInt($('#ResultDeclarationMins').val());
        var WindowsClosesBefore = parseInt($('#txtWindowsClosesBefore').val());
        var WindowClosesBeforeHours = parseInt($('#ddlWindowClosesBeforeHours').val());
        var WindowClosesBeforeMinutes = parseInt($('#ddlWindowClosesBeforeMinutes').val());

        ResultDeclarationDate.subtract(WindowsClosesBefore, 'days');
        var DifferenceMins = DeclarationTimeMins - WindowClosesBeforeMinutes;
        if (DifferenceMins < 0)
        {
            DifferenceMins = 60 + DifferenceMins;
            WindowClosesBeforeHours = WindowClosesBeforeHours + 1;

        }
        if (WindowClosesBeforeHours < 0)
        {
            var DiffereceHrs = DecalrationTimeHrs + WindowClosesBeforeHours;
        }
        else {

            var DiffereceHrs = DecalrationTimeHrs - WindowClosesBeforeHours;
        }

        if(DiffereceHrs < 0)
        {
            DiffereceHrs = 24 + DiffereceHrs;
            ResultDeclarationDate.subtract(1, 'days');
        }
        var testValue1 = moment(ResultDeclarationDate).format("DD/MM/YYYY").toString().split('/');
        var a1 = Number(testValue1[1]);
        var value1 = testValue1[0] + '/' + (months[a1 - 1]) + '/' + testValue1[2];
        var sDate = value1;//moment(ResultDeclarationDate).format("DD/MM/YYYY");
     //   alert($('#ResultDeclarationDate').val());
        if ($('#ResultDeclarationDate').val() != null && $('#ResultDeclarationDate').val() != "") {
            $('#WindowCloseDate').val(sDate);
        }
        if (!isNaN(DiffereceHrs))
            $('#WindowClosesHours').val(DiffereceHrs);
        if (!isNaN(DifferenceMins))
        $('#WindowClosesMinutes').val(DifferenceMins);
        return false;
    });
       
    $(document).delegate('#CalculateAfter', 'click', function (event) {
        var months = ['JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN', 'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC'];
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
        var DecalrationDate = $('#ResultDeclarationDate').val();
        var ResultDeclarationDate = moment(DecalrationDate.toLowerCase());//, "DD/MM/YYYY");

        var SelectedDateArr = $('#ResultDeclarationDate').val();
        SelectedDateArr = SelectedDateArr.split("/");
        var SelectedMonthIndex = months1[SelectedDateArr[1]];
        var OriginalMonthIndex = Number(SelectedMonthIndex + 1);
        var SelectedDate = SelectedDateArr[2] + "/" + OriginalMonthIndex + "/" + SelectedDateArr[0]
        ResultDeclarationDate = moment(SelectedDate, "YYYY-MM-DD");

        var DecalrationTimeHrs = parseInt($('#ResultDeclarationHrs').val());
        var DeclarationTimeMins = parseInt($('#ResultDeclarationMins').val());

        var WindowOpenAfter = parseInt($('#txtWindowOpenAfter').val());
        var WindowOpensAfterHours = parseInt($('#ddlWindowOpensAfterHours').val());
        var WindowOpensAfterMinutes = parseInt($('#ddlWindowOpensAfterMinutes').val());
      
        ResultDeclarationDate.add(WindowOpenAfter, 'days');

        var DifferenceMins = DeclarationTimeMins + WindowOpensAfterMinutes;
        if (DifferenceMins >= 60) {
            DifferenceMins = DifferenceMins - 60;
            WindowOpensAfterHours = WindowOpensAfterHours + 1;
        }
        //if (WindowOpensAfterHours < 0) {
        //    var DiffereceHrs = DecalrationTimeHrs - WindowOpensAfterHours;
        //}
        //else {

        //    var DiffereceHrs = DecalrationTimeHrs + WindowOpensAfterHours;
        //}
        var DiffereceHrs = DecalrationTimeHrs + WindowOpensAfterHours;
        if (DiffereceHrs >= 24) {
            DiffereceHrs = DiffereceHrs - 24;        
            ResultDeclarationDate.add(1, 'days');
        }
        var sDate = moment(ResultDeclarationDate).format("DD/MM/YYYY")    
        var testValue = moment(ResultDeclarationDate).format("DD/MM/YYYY").toString().split('/');
        var a = Number(testValue[1]);
        var value = testValue[0] + '/' + (months[a - 1]) + '/' + testValue[2];

        
        if ($('#ResultDeclarationDate').val() != null && $('#ResultDeclarationDate').val() != "") {
            $('#WindowOpenDate').val(value);
        }
        if (!isNaN(DiffereceHrs))
            $('#WindowOpensHours').val(DiffereceHrs);
        if (!isNaN(DifferenceMins))
        $('#WindowOpensMinutes').val(DifferenceMins);
        return false;
    });

    $("#txtWindowsClosesBefore").focusout(function () {
        $("#CalculateBefore").trigger("click");
    });

    $("#ddlWindowClosesBeforeHours").change(function () {
        $("#CalculateBefore").trigger("click");
    });

    $("#ddlWindowClosesBeforeMinutes").change(function () {
        $("#CalculateBefore").trigger("click");
    });

    $("#txtWindowOpenAfter").focusout(function () {
        $("#CalculateAfter").trigger("click");
    });

    $("#ddlWindowOpensAfterMinutes").change(function () {
        $("#CalculateAfter").trigger("click");
    });

    $("#ddlWindowOpensAfterHours").change(function () {
        $("#CalculateAfter").trigger("click");
    });

    

    $("#ResultDeclarationDate").change(function () {
        $("#CalculateBefore").trigger("click");
        $("#CalculateAfter").trigger("click");
    });

    $("#ResultDeclarationMins").change(function () {
        $("#CalculateBefore").trigger("click");
        $("#CalculateAfter").trigger("click");
    });

    $("#ResultDeclarationHrs").change(function () {
        $("#CalculateBefore").trigger("click");
        $("#CalculateAfter").trigger("click");
    });

    

    

    $(document).delegate('#Search', 'click', function (event) {      
        var date = $('#Month').val();
        var split = date.split(" ");
        $('#divCalenderPartial').html("");
        $.ajax({
            url: $("#calender").val(),
            type: 'post',
            headers: getRVToken(),
            cache: false,
            data: { "Year": split[1], "sMonth": split[0], "CalledFrom": "Search", "acid": $("#ViewCalenderAction").val(), "PageFrom": $("#PageFrom").val() },
            success: function (result) {
                $('#divCalenderPartial').html(result);
            },
            error: function (result) {
            }

        });
    });

        $(document).delegate('#Month', 'change', function (event) {
            var date = $('#Month').val();
            if (date != null) {
                var split = date.split(" ");
                $('#divCalenderPartial').html("");
             //   return true;
                $.ajax({
                    url: $("#calender").val(),
                    type: 'post',
                    headers: getRVToken(),
                    cache: false,
                    data: { "Year": split[1], "sMonth": split[0], "CalledFrom": "Search", "acid": $("#ViewCalenderAction").val(), "PageFrom": $("#PageFrom").val() },
                    success: function (result) {
                        $('#divCalenderPartial').html(result);
                        return false;
                    },
                    error: function (result) {
                    }

                });
            }
        });
       
    //});




    $(document).delegate('#Prev', 'click', function (event) {
        var Year = $('#hidCurrentyear').val();
        var Month = $('#hidCurrentMonth').val();
      //   $('#divCalender').html("");
        $('#divCalenderPartial').html("");
        $.ajax({
            url: $("#calender").val(),
            type: 'post',
            headers: getRVToken(),
            cache: false,
            data: { "Year": Year, "sMonth": Month, "CalledFrom": "Prev", "acid": $("#ViewCalenderAction").val(), "PageFrom": $("#PageFrom").val() },
            success: function (result) {
                $('#divCalenderPartial').html(result);
                $('#Month').val($('#NewMonth').val());
                $('#PageFrom').val($('#PageFrom').val());
            },
            error: function (result) {
            }

        });
    });

    $(document).delegate('#Next', 'click', function (event) {
        var Year = $('#hidCurrentyear').val();
        var Month = $('#hidCurrentMonth').val();
        // $('#divCalender').html("");
        $('#divCalenderPartial').html("");
        $.ajax({
            url: $("#calender").val(),
            type: 'post',
            headers: getRVToken(),
            cache: false,
            data: { "Year": Year, "sMonth": Month, "CalledFrom": "Next", "acid": $("#ViewCalenderAction").val(), "PageFrom": $("#PageFrom").val() },
            success: function (result) {
              
                $('#divCalenderPartial').html(result);
                $('#Month').val($('#NewMonth').val());
            },
            error: function (result) {
            }

        });
    });

    $(document).delegate('#ViewAll', 'click', function (event) {
        var Year = $('#hidCurrentyear').val();
        var Month = $('#hidCurrentMonth').val();
        //$('#divCalender').html("");
        $('#divCalenderPartial').html("");
        $.ajax({
            url: $("#viewall").val(),
            type: 'post',
            headers: getRVToken(),
            cache: false,
            data: { "Year": Year, "sMonth": Month, "CalledFrom": "", "acid": $("#ViewCalenderAction").val(), "PageFrom": $("#PageFrom").val() },
            success: function (result) {
                $('#divCalenderPartial').html(result);
            },
            error: function (result) {
            }

        });
    });
    $('#DeleteTradingWindowEventOther').click(function () {
        ShowDeleteConfirm("WARNING", "Are you sure want to delete this Trading Window Event?", $("#DeleteEvent"));
    });
 
    getTradingWindow();
    

});

function getTradingWindow() {
    var date = $('#Month').val();
    if (date == undefined || date == "") {
        date = $('#hidCurrentMonth').val() + ' ' + $('#hidCurrentyear').val();
    }
    var split = date.split(" ");
    if (split[0] != 'undefined') {
        $('#divCalenderPartial').html("");
        $.ajax({
            url: $("#calender").val(),
            type: 'post',
            headers: getRVToken(),
            cache: false,
            data: { "Year": split[1], "sMonth": split[0], "CalledFrom": "Search", "acid": $("#ViewCalenderAction").val(), "PageFrom": $("#PageFrom").val() },
            success: function (result) {
                $('#divCalenderPartial').html(result);
            },
            error: function (result) {
            }
        });
    }
}

function datatableCallFunction() {
    $(".dataTables_wrapper").find("div").first("div").hide();
    $(".dataTables_wrapper").find("div").next("div").attr("style", "ms-overflow-x: scroll;").removeAttr("style");
    $(".data-table").addClass("GridFullWidth");
}