$(document).ready(function () {
    $("#SaveNAddDmat").hide();
    $('#RelCreateGrid').hide();
    $('#EmpInfo').hide();


    $(document).delegate("#chkSameEmployee:checked", "click", function () {
        if ($(this).prop("checked") == true) {
            $.ajax({
                url: $("#GetUserDetails").val(),
                type: 'post',
                headers: getRVToken(),
                data: { "nParentID": $("#userInfoModel_ParentId").val() },
                success: function (data) {
                    if (data.status) {
                        data = data.data;
                        $("#userInfoModel_AddressLine1").val(data.AddressLine1);
                        $("#userInfoModel_PinCode").val(data.PinCode);
                        $("#userInfoModel_CountryId").val(data.CountryId);
                    }
                },
                error: function (jqXHR, textStatus, errorThrown) {
                    alert(errorThrown);
                }
            });
        }
    });

    $(document).delegate("#SelectedStatusId", 'change', function () {
        //var atLeastOneIsChecked = $('#chkDmatAccAvailable:checkbox:checked').length > 0;
        //var Selected_Value = $("#SelectedStatusId option:selected").val();
        //if ((atLeastOneIsChecked == true)) {
        //    if (Selected_Value == 102001) {
        //        $("#SaveNAddDmat").show();
        //        $("#emp_rel_detail_save").hide();
        //    }
        //    else {
        //        $("#SaveNAddDmat").hide();
        //        $("#emp_rel_detail_save").show();
        //    }

        //}
        //else {
        //    $("#SaveNAddDmat").hide();
        //    $("#emp_rel_detail_save").show();
        //}

    });

    $('#userInfoModel_PAN').focusout(function (event) {
        $('input[type=radio]#RBYes').prop('checked', false);
        $("#err_msg").hide();
        $('#SaveNAddDmat').attr("disabled", "disabled");
    });

    $(document).delegate('input:radio[id="RBYes"]', 'click', function (event) {
        var pan = $("#userInfoModel_PAN").val();
        if (pan != "")
        {
            $('#SaveNAddDmat').removeAttr("disabled");
            $("#SaveNAddDmat").show();
            $("#emp_rel_detail_save").hide();
        }
        else {
            $("#err_msg").show();
            $('#emp_rel_detail_save').attr("disabled", "disabled");
        }
        
    });

    $(document).delegate('input:radio[id="RBNo"]', 'click', function (event) {
        $("#SaveNAddDmat").hide();
        $("#emp_rel_detail_save").show();
        $('#emp_rel_detail_save').removeAttr("disabled");
        $("#err_msg").hide();
    });

});

$(document).delegate("#AddRelBtn", "click", function () {
    $('#RelCreateGrid').show();
    $('#EmpInfo').show();
    $("#ConfirmDetails").hide();
    $('#RelGrid').hide();

})

$(document).delegate("#emp_rel_detail_save", "click", function () {
    var isValidform = true;
    $("form [disabled='disabled']").each(function () {
        $(this).removeAttr("disabled");
        $(this).attr("readonly", "readonly");

        var validfrom = $(this).valid();
        if (!validfrom) {
            isValidform = false;
        }

        $(this).removeAttr("readonly");
        $(this).attr("disabled", "disabled");
    });
    var relSave = $("#EditRelativeForm").valid();
    if (relSave == true && isValidform == true) {
        //$('#ConfirmDetails').show();
        $('#btnProceed').hide();
        $('#RelCreateGrid').hide();
        $('#EmpInfo').hide();
        $('#ConfirmDetails').hide();
    }
    return isValidform;
});

function DisplayErrorMessage(ErrorMessage) {
    $('input').removeClass('input-validation-error');
    $('select').removeClass('input-validation-error');

    $('#messageSection div').not('#frmDMATDetails #divValidationSummaryModal,#mainMessageSection').remove();
    $("#frmDMATDetails #divValidationSummaryModal ul").html("");

    $("#frmDMATDetails  #divValidationSummaryModal ul").append(("<li>" + ErrorMessage + "</li>"));

    $('#frmDMATDetails  #divValidationSummaryModal').slideDown(500);
    $('#messageSection div').not('#frmDMATDetails  #divValidationSummaryModal').remove();
    $("#frmDMATDetails  #divValidationSummaryModal").removeClass("validation-summary-valid");
    $("#frmDMATDetails  #divValidationSummaryModal").addClass("validation-summary-errors");

    setTimeout(function () {
        $("#frmDMATDetails #divValidationSummaryModal").removeClass("validation-summary-errors");
        $('#frmDMATDetails #divValidationSummaryModal').removeClass('alert-danger').fadeOut('slow');
        $("#frmDMATDetails #divValidationSummaryModal").addClass("alert-danger");
        $("#frmDMATDetails #divValidationSummaryModal").addClass("validation-summary-valid");

    }, 10000);
}

