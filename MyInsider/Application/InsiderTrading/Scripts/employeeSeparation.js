
$(document).ready(function () {
    $(document).undelegate('#btnSave', 'click');
    $(document).undelegate('#btnReactivate', 'click');
    $(document).delegate('#btnSave', 'click', function (event) {

        $('#EditSeparationForm').removeData('validator');
        $('#EditSeparationForm').removeData('unobtrusiveValidation');
        $("#EditSeparationForm").each(function () { $.data($(this)[0], 'validator', false); });
        $.validator.unobtrusive.parse("#EditSeparationForm");
        if ($("#EditSeparationForm").valid()) {
            ShowConfirm("Confirmation", $("#MsgConfirmSeparation").val(), 'btnSave');
        }
        
    });

    $(document).delegate('#btnReactivate', 'click', function (event) {

        $('#EditSeparationForm').removeData('validator');
        $('#EditSeparationForm').removeData('unobtrusiveValidation');
        $("#EditSeparationForm").each(function () { $.data($(this)[0], 'validator', false); });
        $.validator.unobtrusive.parse("#EditSeparationForm");
        if ($("#EditSeparationForm").valid()) {
            ShowConfirm("Confirmation", $("#MsgConfirmReActivate").val(), 'btnReactivate');
        }

    });

    $(document).undelegate('#DateOfSeparation', 'change');

    $(document).delegate('#DateOfSeparation', 'change', function (event) {
        addDate();
    });
    $(document).undelegate('#DateOfSeparation', 'blur');

    $(document).delegate('#DateOfSeparation', 'blur', function (event) {
        addDate();
    });
    $(document).undelegate('#NoOfDaysToBeActive', 'change');
    $(document).delegate('#NoOfDaysToBeActive', 'change', function (event) {
        addDate();
    });
    $(document).undelegate('#NoOfDaysToBeActive', 'blur');
    $(document).delegate('#NoOfDaysToBeActive', 'blur', function (event) {
        addDate();
    });
});

function addDate()
{
    var date ;//= new Date($("#DateOfSeparation").val()),
           days = parseInt($("#NoOfDaysToBeActive").val(), 10);
  
           if (days >= 0 && $("#DateOfSeparation").val() != "") {
        date = $("#DateOfSeparation").val();
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
        var InActivationDate ;
        var SelectedDateArr = date;
        SelectedDateArr = SelectedDateArr.split("/");
        var SelectedMonthIndex = months1[SelectedDateArr[1]];
        var OriginalMonthIndex = Number(SelectedMonthIndex + 1);
        var SelectedDate = SelectedDateArr[2] + "/" + OriginalMonthIndex + "/" + SelectedDateArr[0]
        InActivationDate = moment(SelectedDate, "YYYY-MM-DD");
        InActivationDate.add(days, 'days');
        var testValue = moment(InActivationDate).format("DD/MM/YYYY").toString().split('/');
        var a = Number(testValue[1]);
        var value = testValue[0] + '/' + (months[a - 1]) + '/' + testValue[2];
        $("#DateOfInactivation").val(value);
        $("#txtDateOfInactivation").val(value);
    }
    else {
               $("#DateOfSeparation").val("");
               $("#txtDateOfSeparation").val("");
    }
}

function ShowConfirm(Title, Message, URL) {
    $('#MainConfirm').trigger("click", [Title, Message, URL]);
}


$(document).delegate("#MainConfirm", "click", function (event, Title, Message, URL) {
    $.confirm({
        title: Title,
        text: Message,//"Are you sure want to delete this Company.?",
        confirm: function (button) {
            // window.location.href = URL;//$("#DeleteFromGrid").val() + "&CompanyId=" + data.CompanyId;
            if (URL == "btnSave")
            {
                SaveDetails();
            }
            else {
                ReactvateUser();
            }
        },
        cancel: function (button) {
        },
        confirmButton: "Yes I Confirm",
        cancelButton: "No",
        post: true,
        confirmButtonClass: "btn btn-success",
        cancelButtonClass: "btn-danger",
        dialogClass: "modal-dialog modal-lg"
    });
});

function SaveDetails() {
    var modelDataJSON = $('#EditSeparationForm').serialize();;

    $.ajax({
        url: $("#SaveAction").val(),
        method: 'post',
        headers: getRVToken(),
        data: $("#EditSeparationForm").serialize(),//{ 'objTemplateMasterModel': modelDataJSON, "calledFrom": "Communication" },
        success: function (response) {
            if (response.status) {
                dataTable = $("table[name='DatatableGrid'][gridtype='114019']").dataTable();

                showMessage(response.Message, true);
                setTimeout(function () {
                    $("#myModalSeparation").hide();
                }, 1000);
                dataTable.fnDraw();
            }
            else {

                DisplayErrors(response.error);

            }
            //  alert("Test");
        },
        error: function (response) { DisplayErrors(response.error); }
    });
}

function ReactvateUser() {
    var modelDataJSON = $('#EditSeparationForm').serialize();

    $.ajax({
        url: $("#ReActivateUser").val(),
        method: 'post',
        headers: getRVToken(),
        data: $("#EditSeparationForm").serialize(),//{ 'objTemplateMasterModel': modelDataJSON, "calledFrom": "Communication" },
        success: function (response) {
            if (response.status) {
                dataTable = $("table[name='DatatableGrid'][gridtype='114019']").dataTable();

                showMessage(response.Message, true);
                setTimeout(function () {
                    $("#myModalSeparation").hide();
                }, 1000);
                dataTable.fnDraw();
            }
            else {
                DisplayErrors(response.error);
            }
        },
        error: function (response) { DisplayErrors(response.error); }
    });
}
function DisplayErrors(errors) {
    $('input').removeClass('input-validation-error');
    $('select').removeClass('input-validation-error');

    $('#messageSection div').not('#divValidationSummaryModal,#mainMessageSection').remove();
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
    $('#messageSection div').not('#divValidationSummaryModal').remove();
    $("#divValidationSummaryModal").removeClass("validation-summary-valid");
    $("#divValidationSummaryModal").addClass("validation-summary-errors");

    setTimeout(function () {
        $("#divValidationSummaryModal").removeClass("validation-summary-errors");
        $('#divValidationSummaryModal').removeClass('alert-danger').fadeOut('slow');
        $("#divValidationSummaryModal").addClass("alert-danger");
        $("#divValidationSummaryModal").addClass("validation-summary-valid");

    }, 10000);
}