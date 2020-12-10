$(document).ready(function () {

    $('input,textarea,select', 'form').blur(function () {
        $(this).valid();
        //alert('sdf');
        $("#divValidationSummaryModal").removeClass("validation-summary-errors");
        $("#divValidationSummaryModal").addClass("validation-summary-valid");

    });

    $(':radio[name="TransferFor"]').change(function () {

        var values = $("#frmSecurityTransfer").serializeArray();
        var a = $(this).filter(':checked').val();
        if (a == 142002) {
            $('#divOtherThanEsopQty').hide();
            $('#divEsopQty').hide();
            $('#divToWhichDMATAccNumber').hide();
            $('#TransferQuantity').val('');
            $('#TransferESOPQuantity').val('');
            $('#divbalance').empty();
            $('#Save').hide();
            $('#DivRelativeDetails').html("");
            $.ajax({
                url: $("#LoadRelative").val(),
                type: 'post',
                headers: getRVToken(),
                cache: false,
                data: values,
                success: function (result) {
                    $('#DivRelativeDetails').html(result);
                    $('#SecurityTypeCodeID').empty();
                    $('#ToDEMATAcountID').empty();
                    LoadData();
                },
                error: function (result) {
                }
            });
           
        } else {
            $('#DivRelativeDetails').html("");
            var a = $('input[name=SecurityTransferOption]:checked').val();
            if (a == 191001) {
                $.ajax({
                    url: $("#LoadIndividualAccount").val(),
                    type: 'post',
                    headers: getRVToken(),
                    cache: false,
                    data: values,
                    success: function (result) {
                        $('#DivIndividualAccount').html(result);
                    },
                    error: function (result) {
                    }
                });

            } else if (a == 191002) {
                $.ajax({
                    url: $("#LoadAllAccount").val(),
                    type: 'post',
                    headers: getRVToken(),
                    cache: false,
                    data: values,
                    success: function (result) {
                        $('#DivIndividualAccount').html(result);
                        $('#SecurityTypeCodeID').empty();
                        $('#FromDEMATAcountID').empty();
                        LoadData();
                    },
                    error: function (result) {
                    }
                });
            }
        }
    });

    $(':radio[name="SecurityTransferOption"]').change(function () {
        var values = $("#frmSecurityTransfer").serializeArray();
        $('#DivIndividualAccount').html("");
        var a = $(this).filter(':checked').val();
        if (a == 191001) {
            $.ajax({
                url: $("#LoadIndividualAccount").val(),
                type: 'post',
                headers: getRVToken(),
                cache: false,
                data: values,
                success: function (result) {
                    $('#DivIndividualAccount').html(result);
                    $('#SecurityTypeCodeID').empty();
                    $('#FromDEMATAcountID').empty();
                    LoadData();
                },
                error: function (result) {
                }
            });
           
        } else if (a == 191002) {

            $.ajax({
                url: $("#LoadAllAccount").val(),
                type: 'post',
                headers: getRVToken(),
                cache: false,
                data: values,
                success: function (result) {
                    $('#DivIndividualAccount').html(result);
                    $('#SecurityTypeCodeID').empty();
                    $('#ToDEMATAcountID').empty();
                    $('#Save').hide();
                    LoadData();
                },
                error: function (result) {
                }
            }); 
        }
    });

    $(document).delegate('#StExMultiTradeFreq', 'change', function (event) {
        LoadData();
    });

    $(document).delegate('#ForUserInfoId', 'change', function (event) {
        LoadData();
    });

    $(document).delegate('#FromDEMATAcountID', 'change', function (event) {
        var values = $("#frmSecurityTransfer").serializeArray();
        $.ajax({
            url: $("#GetAvailableQty").val(),
            type: 'post',
            headers: getRVToken(),
            cache: false,
            data: values,
            success: function (data) {
                if (data.status) {
                    $('#divbalance').empty();
                    var result = '<div class="form-group" style="width:700px"><br/><b>' + data.Message + '</b> &nbsp;&nbsp;&nbsp;&nbsp; <b>' + data.Other_Qty_Message + '</b> &nbsp;&nbsp;&nbsp;&nbsp; <b>' + data.ESOP_Qty_Message + '</b> </div>'
                    $('#divbalance').append(result);
                    $('#divbalance').fadeIn('slow');
                    $('#divOtherThanEsopQty').hide();
                    $('#divEsopQty').hide();
                    $('#divToWhichDMATAccNumber').hide();
                    $('#TransferQuantity').val('');
                    $('#TransferESOPQuantity').val('');
                    $('#Save').hide();
                    if (data.Other_Than_Esop_Qty != 0)
                    {       
                        $('#divToWhichDMATAccNumber').show();
                        $('#divOtherThanEsopQty').show();
                        $('#Save').show();
                    }
                    if (data.Esop_Qty != 0)
                    {   
                        $('#divToWhichDMATAccNumber').show();
                        $('#divEsopQty').show();
                        $('#Save').show();
                    }
                               
                } else {
                    DisplayErrors(data);
                }
            },
            error: function (data) {
                DisplayErrors(data);
            }
        });

        //if ($('#FromDEMATAcountID').val() == "") {
        //    $("#ToDEMATAcountID").find('option[disabled=disabled]').removeAttr("disabled");
        //} else {
        //    $("#ToDEMATAcountID").find('option[value=' + $('#FromDEMATAcountID').val() + ']').attr("disabled", "disabled");
        //    $("#ToDEMATAcountID").find('option[value!=' + $('#FromDEMATAcountID').val() + ']').removeAttr("disabled");
        //}
        $("#ToDEMATAcountID").empty();
        $('#FromDEMATAcountID option').clone().appendTo('#ToDEMATAcountID');
       // alert($('#FromDEMATAcountID').val());
        $("#ToDEMATAcountID").find('option[value=' + $('#FromDEMATAcountID').val() + ']').remove();

    });

  

    $(document).delegate('#ToDEMATAcountID', 'change', function (event) {
        var values = $("#frmSecurityTransfer").serializeArray();
        $.ajax({
            url: $("#GetAvailableQty").val(),
            type: 'post',
            headers: getRVToken(),
            cache: false,
            data: values,
            success: function (data) {
                if (data.status) {
                    $('#divbalanceAll').empty();
                    var result = data.Message;
                    $('#divbalanceAll').append(result);
                    $('#divbalanceAll').fadeIn('slow');
                } else {
                    DisplayErrors(data);
                }
            },
            error: function (data) {
                DisplayErrors(data);
            }
        });
        
       // if ($('#ToDEMATAcountID').val() == "") {
        //    $("#FromDEMATAcountID").find('option[disabled=disabled]').removeAttr("disabled");
        //} else{
        //    $("#FromDEMATAcountID").find('option[value=' + $('#ToDEMATAcountID').val() + ']').attr("disabled", "disabled");
        //    $("#FromDEMATAcountID").find('option[value!=' + $('#ToDEMATAcountID').val() + ']').removeAttr("disabled");
        //}
    });

    $(document).delegate('#SecurityTypeCodeID', 'change', function (event) {
        var values = $("#frmSecurityTransfer").serializeArray();
        $.ajax({
            url: $("#GetAvailableQty").val(),
            type: 'post',
            headers: getRVToken(),
            cache: false,
            data: values,
            success: function (data) {
                if (data.status) {
                    var a = $('input[name=SecurityTransferOption]:checked').val();
                    if (a == "191001") {
                        $('#divbalance').empty();
                        var result = '<div class="form-group" style="width:700px"><br/><b>' + data.Message + '</b> &nbsp;&nbsp;&nbsp;&nbsp; <b>' + data.Other_Qty_Message + '</b> &nbsp;&nbsp;&nbsp;&nbsp; <b>' + data.ESOP_Qty_Message + '</b> </div>'
                        $('#divbalance').append(result);
                        $('#divbalance').fadeIn('slow');

                        $('#divOtherThanEsopQty').hide();
                        $('#divEsopQty').hide();
                        $('#divToWhichDMATAccNumber').hide();
                        $('#TransferQuantity').val('');
                        $('#TransferESOPQuantity').val('');
                        $('#Save').hide();
                        if (data.Other_Than_Esop_Qty != 0) {
                            $('#divToWhichDMATAccNumber').show();
                            $('#divOtherThanEsopQty').show();
                            $('#Save').show();
                        }
                        if (data.Esop_Qty != 0) {
                            $('#divToWhichDMATAccNumber').show();
                            $('#divEsopQty').show();
                            $('#Save').show();
                        }

                    } else if (a == 191002) {
                        $('#divbalanceAll').empty();
                        var result = data.Message;
                        $('#divbalanceAll').append(result);
                        $('#divbalanceAll').fadeIn('slow');
                        if (data.ESOP_Other_TotalQty != 0)
                        {
                            $('#Save').show();
                        }
                        else
                        {
                            $('#Save').hide();
                        }
                    }
                } else {
                    DisplayErrors(data);
                }
            },
            error: function (data) {
                DisplayErrors(data);
            }
        });
    });

    $(function () {
        LoadData();

    });


    $('#Save1').confirm({        
        title: $("#ConfirmTitle").val(),
        text: $("#ConfirmMessage").val(),
        confirm: function (button, data) {
            var values = $("#frmSecurityTransfer").serializeArray();
            values.push({
                name: "formId",
                value: 104
            });
            if ($("#frmSecurityTransfer").valid()) {
            $.ajax({
                url: $("#TransferBalance").val(),
                type: 'post',
                headers: getRVToken(),
                cache: false,
                data: values,
                success: function (data) {
                    if (data.status) {
                        showMessage(data.msg, true);
                        window.location.href = $('#holdinglist').val() + '?acid=219';
                    } else {
                        DisplayErrors(data.error);
                    }
                },
                error: function (data) {
                    DisplayErrors(data.error);
                }
            });
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

    $(document).delegate("#Save", "click", function () {
        $('#frmSecurityTransfer').removeData('validator');
        $('#frmSecurityTransfer').removeData('unobtrusiveValidation');
        $("#frmSecurityTransfer").each(function () { $.data($(this)[0], 'validator', false); });
        $.validator.unobtrusive.parse("#frmSecurityTransfer");

        if ($("#frmSecurityTransfer").valid()) {
            $('#Save1').trigger("click");
        }
    });

});

function LoadData() {
    var values = $("#frmSecurityTransfer").serializeArray();
    var a = $('input[name=SecurityTransferOption]:checked').val();
    if (a == "191001") {
       
        $.ajax({
            url: $("#LoadIndividualAccount").val(),
            type: 'post',
            headers: getRVToken(),
            cache: false,
            data: values,
            success: function (result) {
                $('#DivIndividualAccount').html(result);
            },
            error: function (result) {
            }
        });
       
    } else if (a == "191002") {
        $.ajax({
            url: $("#LoadAllAccount").val(),
            type: 'post',
            headers: getRVToken(),
            cache: false,
            data: values,
            success: function (result) {
                $('#DivIndividualAccount').html(result);
            },
            error: function (result) {
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

