$(document).ready(function () {

    var dataTable = null;
    $(document).delegate("#btnSaveDMATDetails", "click", function () {
        if ($("table[name='DatatableGrid_demat'][gridtype='" + $(this).attr("gridtype") + "']").length > 0) {
            dataTable = $("table[name='DatatableGrid_demat'][gridtype='" + $(this).attr("gridtype") + "']").dataTable();
        }
        else {
            dataTable = $("table[name='DatatableGrid'][gridtype='" + $(this).attr("gridtype") + "']").dataTable();
        }
        if ($("#frmDMATDetails").valid()) {
            var datavalues = $("#frmDMATDetails").serializeArray();
            datavalues.push({
                name: "callfrom",
                value: $("#DematPopup").val() == "yes" ? "popup" : "",
                name: "formId",
                value: 6
            });

            $.ajax({
                url: $("#SaveDMAT").val(),
                type: 'post',
                headers: getRVToken(),
                data: datavalues,
                success: function (data) {
                    if (data.status) {
                        showMessage(data.Message, true);

                        if (data.RefreshDematList) {
                            var userid = $('#DematCreateUser').val();
                            fetchDemat(userid);
                            $("#divDMATDetailsModal").hide();
                            $("#divDMATDetailsModal").html("");
                        } else {
                            $("#DMATDetailsID").val(data.DMATDetailsID);
                            if (data.type)
                                GetDMATList();
                            else {
                                $("#divDMATHolderList").html("");
                                $("#divDMATDetailsModal").hide();
                                $('#DMATModal').modal('hide');
                            }
                            if (data.UpdateDMAT) {
                                window.location.reload();
                            }
                            else {
                                window.location = data.url;
                            }
                        }
                    }
                    else {
                        var ErrorMessage = data.Message;
                        DisplayErrorMessage(ErrorMessage);
                    }
                },
                error: function (jqXHR, textStatus, errorThrown) {
                    DisplayErrors(data.error);
                    var errorData = $.parseJSON(jqXHR.responseText);
                    var errorMessages = [];
                    //this ugly loop is because List<> is serialized to an object instead of an array
                    for (var key in errorData) {
                        errorMessages.push(errorData[key]);
                    }
                    $('#result').html(errorMessages.join("<br />"));
                }
            });
        }
        return false;
    });


    //Save And Add DMATE button
    $(document).delegate(".btnAddDMATDetails", "click", function () {
        var RelForm = $("#EditRelativeForm").valid();
        if (RelForm == true) {
            $.ajax({
                url: $("#AddRelDMAT").val(),
                type: 'post',
                headers: getRVToken(),
                data: $("#EditRelativeForm").serialize(),
                success: function (data) {
                    if (data.length > 0) {
                        $("#divDMATDetailsModal").html(data);
                        $("#divDMATDetailsModal").show();
                        $('#DMATModal').modal('show');
                    }
                    else {

                        if (!data.status) {
                            var ErrorMessage = data.Message;
                            DisplayErrorMessageForDuplicateField(ErrorMessage);
                        }
                    }

                },
                error: function (jqXHR, textStatus, errorThrown) {
                    // alert(errorThrown);
                    DisplayErrorMessage(errorThrown);
                }
            });
        }
    });

    //Working Code (double load popup issue)
    //1712
    $(document).delegate(".btnEditDMATDetails", "click", function () {
        $.ajax({
            url: $("#EditDMAT").val(),
            type: 'post',
            headers: getRVToken(),
            data: { "acid": $("#EditDMAT").attr("acid"), "nDMATDetailsID": $(this).attr("data-details"), "nUserInfoID": $("#EditDMAT").attr("userinfoid") },
            success: function (data) {
                $("#divDMATDetailsModal").html(data);
                $("#divDMATDetailsModal").show();
                $('#DMATModal').modal('show');
            },
            error: function (jqXHR, textStatus, errorThrown) {
                // alert(errorThrown);
            }
        });
    });


    $(document).delegate(".btnDeleteDMATDetails", "click", function () {
        $.ajax({
            url: $(this).val(),
            type: 'post',
            headers: getRVToken(),
            data: { "nDMATDetailsID": $(this).attr("data-detailID") },
            success: function (data) {
                if (data.status) {
                }
            },
            error: function (jqXHR, textStatus, errorThrown) {
                //alert(errorThrown);
            }
        });
    });

    $(document).delegate("#DPBank", "click", function () {
        if ($('option:selected', $(this)).attr("value") == "1") {
            $("#DPBankName").show();
            $("#divDPBankName").show();
        }
        else if ($('option:selected', $(this)).attr("value") == "Other") {
            $("#DPBankName").show();
            $("#divDPBankName").show();
        }
        else {
            $("#DPBankName").hide();
            $("#divDPBankName").hide();
        }
    });

    $(document).delegate("#btnSaveDMATHolderDetails", "click", function () {
        if ($("table[name='DatatableGrid_demat'][gridtype='" + $(this).attr("gridtype") + "']").length > 0) {
            dataTable = $("table[name='DatatableGrid_demat'][gridtype='" + $(this).attr("gridtype") + "']").dataTable();
        } else {
            dataTable = $("table[name='DatatableGrid'][gridtype='" + $(this).attr("gridtype") + "']").dataTable();
        }
        if ($("#frmDMATHolderDetails").valid()) {
            $.ajax({
                url: $("#SaveDMATHolder").val(),
                type: 'post',
                headers: getRVToken(),
                data: $("#frmDMATHolderDetails").serialize(),
                success: function (data) {
                    if (data.status) {
                        showMessage(data.Message, true);

                        $("#divDMATHodlerDetails").html("");
                        dataTable.fnDraw();
                    }
                },
                error: function (jqXHR, textStatus, errorThrown) {
                    //alert(errorThrown);
                }
            });
        }
    });

    $(document).delegate(".btnEditDMATHolderDetails", "click", function () {
        $.ajax({
            url: $("#EditDMATHolder").val(),
            type: 'post',
            headers: getRVToken(),
            data: { "nDMATAccountHolderID": $(this).attr("data-details"), "nDMATDetailsID": $("#DMATDetailsID").val() },
            success: function (data) {
                $("#divDMATHodlerDetails").html(data);
            },
            error: function (jqXHR, textStatus, errorThrown) {
                //alert(errorThrown);
            }
        });
    });

    $(document).delegate("#dmatholder_cancelButton", "click", function () {
        $("#divDMATHodlerDetails").html("");
        return false;
    })
});

function GetDMATList() {
    $.ajax({
        url: $("#GetDMATList").val(),
        type: 'post',
        headers: getRVToken(),
        data: { "nDMATDetailsID": $("#DMATDetailsID").val() },
        success: function (data) {
            $("#divDMATHolderList").html(data);
        },
        error: function (jqXHR, textStatus, errorThrown) {
            //alert(errorThrown);
        }
    });
}

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

function DisplayErrorMessageForDuplicateField(ErrorMessage) {
    $('input').removeClass('input-validation-error');
    $('select').removeClass('input-validation-error');

    $('#messageSection div').not('#EditRelativeForm #divValidationSummaryModal,#mainMessageSection').remove();
    $("#EditRelativeForm #divValidationSummaryModal ul").html("");

    $("#EditRelativeForm  #divValidationSummaryModal ul").append(("<li>" + ErrorMessage + "</li>"));

    $('#EditRelativeForm  #divValidationSummaryModal').slideDown(500);
    $('#messageSection div').not('#EditRelativeForm  #divValidationSummaryModal').remove();
    $("#EditRelativeForm  #divValidationSummaryModal").removeClass("validation-summary-valid");
    $("#EditRelativeForm  #divValidationSummaryModal").addClass("validation-summary-errors");

    setTimeout(function () {
        $("#EditRelativeForm #divValidationSummaryModal").removeClass("validation-summary-errors");
        $('#EditRelativeForm #divValidationSummaryModal').removeClass('alert-danger').fadeOut('slow');
        $("#EditRelativeForm #divValidationSummaryModal").addClass("alert-danger");
        $("#EditRelativeForm #divValidationSummaryModal").addClass("validation-summary-valid");

    }, 10000);
}