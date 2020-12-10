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
            $("#DPIDNSDL").removeAttr('disabled')
            $("#DPIDCDSL").removeAttr('disabled')
            var datavalues = $("#frmDMATDetails").serializeArray();
            $("#DPIDNSDL").attr('disabled', 'disabled')
            $("#DPIDCDSL").attr('disabled', 'disabled')
            datavalues.push({
                name: "callfrom",
                value: $("#DematPopup").val() == "yes" ? "popup" : "",
                name: "formId",
                value:5
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
                            dataTable.fnDraw();
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


    $(document).delegate(".btnEditDMATDetails", "click", function () {
        $.ajax({
            url: $("#EditDMAT").val(),
            type: 'post',
            headers: getRVToken(),
            data: { "acid": $("#EditDMAT").attr("acid"), "nDMATDetailsID": $(this).attr("data-details"), "nUserInfoID": $("#EditDMAT").attr("userinfoid"), "formId": '5' },
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

    $(document).delegate(".btnAddDMATDetails", "click", function () {
        $.ajax({
            url: $("#AddDMAT").val(),
            type: 'post',
            headers: getRVToken(),
            data: { "acid": $("#AddDMAT").attr("acid"), "nDMATDetailsID": $(this).attr("data-details"), "nUserInfoID": $("#AddDMAT").attr("userinfoid"), "formId": '5' },
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
        else {
            $("#DPBankName").hide();
            $("#divDPBankName").hide();
        }
    });

    $(document).delegate("#DPBank", "change", function () {
        if ($('option:selected', $(this)).attr("value") == "1") {
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
