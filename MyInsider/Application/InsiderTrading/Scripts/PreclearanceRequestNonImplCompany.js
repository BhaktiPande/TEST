$(document).ready(function () {
    $('#TransactionTypeCodeId').change(function () {
        var values = $("#frmPreclearanceRequest").serializeArray();
        $('#DivModeOfAcquisition').html(' ');
        $('#DivSecurityTypeDetails').html("");
        $.ajax({
            url: $("#LoadSecurityType").val(),
            data: values,
            type: "POST",
            error: function (data) {
                alert(" An error occurred.");
            },
            success: function (data) {
                debugger
                $('#DivSecurityTypeDetails').html(data);
            }
    });
        $.ajax({
            url: $("#LoadModeOfAquisition").val(),
            type: 'post',
            headers: getRVToken(),
            cache: false,
            data: values,
            success: function (result1) {
                $('#DivModeOfAcquisition').html(result1);
            }
        });
    })//.trigger('change');

    $(document).delegate('input:radio[name="PreclearanceRequestForCodeId"]', 'click', function (event) {
        var uid = null;
        if (this.value == 142001 || this.value == 'Self') {
            $('div[id=relativeDetails]').fadeOut('fast');

            uid = $('#UserInfoId').val();
            $('#DematCreateUser').val(uid);
        } else if (this.value == 142002 || this.value == 'Relative') {
            $('div[id=relativeDetails]').fadeIn('fast');
            //$('#UserInfoIdRelative').attr('selectedIndex', 0);
            //$("#UserInfoIdRelative").val("").change();

            uid = ($('#UserInfoIdRelative').val() == null || $('#UserInfoIdRelative').val() == "") ? 0 : $('#UserInfoIdRelative').val();
            $('#DematCreateUser').val(uid);
        }
        fetchDemat(uid);
    });

    $(document).delegate('#UserInfoIdRelative', 'change', function (event) {
        var uid = ($('#UserInfoIdRelative').val() == null || $('#UserInfoIdRelative').val() == "") ? 0 : $('#UserInfoIdRelative').val();
        $('#DematCreateUser').val(uid);
        fetchDemat(uid);
    });

    $(document).delegate('#btnSave', 'click', function (e) {
        if ($("#frmPreclearanceRequest").valid()) {
            if ($("#RequiredModule").val()==513001)
            {
                if ($('#declare').is(':checked')) {
                    e.preventDefault();
                    var YesCallbackFunction = function () { $("#frmPreclearanceRequest").submit(); return false; }
                    if (YesCallbackFunction != undefined && typeof YesCallbackFunction == "function") {
                        $("body").addClass("loading");
                        YesCallbackFunction.call();
                    }
                } else {
                    PreclearanceAlert('Alert!', $("#AgreeTermsMsg").val());
                    return false;
                }
            }
            else {
                
                if ($("#UPSISeekDecReq11").val() == 1) {

                     if ($('#declare').is(':checked')) {
                    e.preventDefault();
                    var YesCallbackFunction = function () { $("#frmPreclearanceRequest").submit(); return false; }
                    if (YesCallbackFunction != undefined && typeof YesCallbackFunction == "function") {
                        $("body").addClass("loading");
                        YesCallbackFunction.call();
                    }
                    }
                    else {
                    PreclearanceAlert('Alert!', $("#AgreeTermsMsg").val());
                    return false;
                    }                
                }
            }
           
        }
    });

    $(document).delegate('#AddDAMT', 'click', function (e) {
        var userid = $("#DematCreateUser").val();
        var acid = $("#DematCreateAcid").val();
        var dematid = 0;

        if (userid != null && userid > 0) {
            $.ajax({
                url: $("#AddDematURL").val(),
                type: 'post',
                headers: getRVToken(),
                data: { "acid": acid, "nDMATDetailsID": dematid, "nUserInfoID": userid },
                success: function (data) {
                    $("#divDMATDetailsModal").html(data);
                    $("#divDMATDetailsModal").show();
                    $('#DMATModal').modal('show');
                },
                error: function (jqXHR, textStatus, errorThrown) {
                    alert(errorThrown);
                }
            });
        } else {
            PreclearanceAlert('Alert!', "Pleade select User Relative...?");
            return false;
        }
    });

    if ($('#SecuritiesToBeTradedQty').val() != null) {
    $('#DMATDllId').change(function () {
        $('#divDMATwiseBalance').html("");
        var values = $("#frmPreclearanceRequest").serializeArray();
        $.ajax({
            url: $("#LoadBalanceDMATwise").val(),
            type: 'post',
            headers: getRVToken(),
            cache: false,
            data: values,
            success: function (result) {
                $('#divDMATwiseBalance').html(result);
                ShowHideSecurityPool();
            },
            error: function (result) {
                DisplayErrors(result);
            }
        });
    }).trigger('change');   
    }
});

function fetchDemat(id) {
    var acid = $('#acid').val();
    $('#divDMAT').html(' ');
    $.ajax({
        url: $('#DematListURL').val(),
        type: 'post',
        headers: getRVToken(),
        cache: false,
        data: { 'id': id, 'acid': acid },
        success: function (response) {
            $('#divDMAT').html(response);

            $("form").removeData("validator");
            $("form").removeData("unobtrusiveValidation");
            $.validator.unobtrusive.parse("form");
        },
        error: function (response) { }
    });
}

function PreclearanceAlert(Title, Message) {
    return $.confirm({
        title: Title,
        text: Message,
        confirm: function () {
        },
        confirmButton: "OK",
        cancelButtonClass: "hide",
        confirmButtonClass: "btn btn-success",
        dialogClass: "modal-dialog modal-sm"
    });
}


$(document).delegate('#DMATDllId', 'change', function (event) {
    $('#divDMATwiseBalance').html("");
    var values = $("#frmPreclearanceRequest").serializeArray();
    $.ajax({
        url: $("#LoadBalanceDMATwise").val(),
        type: 'post',
        headers: getRVToken(),
        cache: false,
        data: values,
        success: function (result) {
            $('#divDMATwiseBalance').html(result);
            ShowHideSecurityPool();
        },
        error: function (result) {
            DisplayErrors(result);
        }
    });
});

$(document).delegate('#SecurityTypeCodeId', 'change', function (event) {
    debugger
    var a = $('#SecurityTypeCodeId').val();
    $('#DivModeOfAcquisition').html("");
        if ($('#divDMATwiseBalance').length == 1) {
            $('#divDMATwiseBalance').html("");
            var values = $("#frmPreclearanceRequest").serializeArray();
            $.ajax({
                url: $("#LoadBalanceDMATwise").val(),
                type: 'post',
                headers: getRVToken(),
                cache: false,
                data: values,
                success: function (result) {
                    $('#divDMATwiseBalance').html(result);
                    ShowHideSecurityPool();
                    $.ajax({
                        url: $("#LoadModeOfAquisition").val(),
                        type: 'post',
                        headers: getRVToken(),
                        cache: false,
                        data: values,
                        success: function (result1) {
                            $('#DivModeOfAcquisition').html(result1);
                        }
                    });
                },
                error: function (result) {
                    DisplayErrors(result);
                }
            });
        }
        else {
            var values = $("#frmPreclearanceRequest").serializeArray();
            $.ajax({
                url: $("#LoadModeOfAquisition").val(),
                type: 'post',
                headers: getRVToken(),
                cache: false,
                data: values,
                success: function (result1) {
                    $('#DivModeOfAcquisition').html(result1);
                }
            });
        }

});

function ShowHideSecurityPool() {
    var transaction_type = $('#TransactionTypeCodeId').val();
    var security_type = $('#SecurityTypeCodeId').val();
    var show_pool_flag = $('#showExercisepool').val();

    var transaction = (transaction_type == "") ? false : true;
    var security = (security_type != "") ? true : false;

    if (show_pool_flag != "1") return;

    if (transaction && security) {

        $('#securityPool').show();

        if (transaction_type == 143002 || transaction_type == 143008) { //type sell && Pledge Invoke
            $('#ESOPExcerciseOptionQtyFlag').show();
            $('#OtherESOPExcerciseOptionQtyFlag').show();
        } else {
            $('#ESOPExcerciseOptionQtyFlag').hide();
            $('#OtherESOPExcerciseOptionQtyFlag').hide();
        }
    } else {
        $('#securityPool').hide();
        $('#ESOPExcerciseOptionQtyFlag').hide();
        $('#OtherESOPExcerciseOptionQtyFlag').hide();
    }
}

$(':radio[name="PreclearanceRequestForCodeId"]').change(function () {

    var values = $("#frmPreclearanceRequest").serializeArray();
    var a = $(this).filter(':checked').val();
    if (a == 142002 || a == 'Relative') {
        $('#divDMAT').html("");
        $('#DivRelativeDetails').html("");
        $.ajax({
            url: $("#LoadRelative").val(),
            type: 'post',
            headers: getRVToken(),
            cache: false,
            data: values,
            success: function (result) {
                    $('#DivRelativeDetails').html(result);
            },
            error: function (result) {
            }
        });
        $("#UserInfoIdPassDMAT").val("");
    } else {
        $("#UserInfoIdPassDMAT").val($("#UserInfoId1").val());
        $('#divDMAT').html("");
        $('#DivRelativeDetails').html("");
        $.ajax({
            url: $("#LoadRelative").val(),
            type: 'post',
            headers: getRVToken(),
            cache: false,
            data: values,
            success: function (result) {
                $('#divDMAT').html(result);
            },
            error: function (result) {
            }
        });
    }
});