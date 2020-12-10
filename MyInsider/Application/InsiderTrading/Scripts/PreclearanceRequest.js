$(document).ready(function () {
    ShowHideSecurityPool();

    //var ModeOfAcquisitionOptions = '';
    //ModeOfAcquisitionOptions = $("#ModeOfAcquisitionCodeId").html();
    //if (($("#ModeOfAcquisitionCodeId").val() == "0" || $("#ModeOfAcquisitionCodeId").val() == "") && $("#ModeOfAcquisitionCodeId").is(":visible")) {
    //    $("#ModeOfAcquisitionCodeId").attr("disabled", "disabled");
    //}

    //var SecurityType_ModeOfAcquisitionMapping = {
    //    "143001": ["149005", "149006", "149004", "149007", "149003", "149002", "149001", "149008", "149011", "143009"],
    //    "143002": ["149005", "149006", "149004", "149007", "149002", "149003", "149010", "149008"],
    //    "143003": ["149009"],
    //    "143004": ["149009"],
    //    "143005": ["149009"],
    //    "143006": ["149012"],
    //    "143007": ["149013"],
    //    "143008": ["149014"],
    //};

    var dataTable = null;
    $(':radio[name="PreclearanceRequestForCodeId"]').change(function () {

        var values = $("#frmPreclearanceRequest").serializeArray();
        var a = $(this).filter(':checked').val();
        if (a == 142002) {
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
                url: $("#UserInfoIdRelativeChange").val(),
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


    $(document).delegate('#TransactionTypeCodeId', 'change', function (event) {

        var URL = $('#LoadSecurityType').val();
        $('#DivSecurityTypeDetails').html("");
        $('#DivModeOfAcquisition').html("");
        ShowHideSecurityPool();
        var values = $("#frmPreclearanceRequest").serializeArray();
        $.ajax({
            url: $("#LoadSecurityType").val(),
            type: 'post',
            headers: getRVToken(),
            cache: false,
            data: values,
            success: function (result) {
                $('#DivSecurityTypeDetails').html(result);               
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
            }

        });


        //if ($(this).val() != "0" && $(this).val() != "" && $("#ModeOfAcquisitionCodeId").is(":visible")) {
        //    var AllowedModeOfacquisition = SecurityType_ModeOfAcquisitionMapping[$(this).val()];

        //    $("#ModeOfAcquisitionCodeId").removeAttr("disabled");
        //    $("#ModeOfAcquisitionCodeId").html(ModeOfAcquisitionOptions);
        //    var toRemove = [];

        //    $("#ModeOfAcquisitionCodeId option").each(function () {
        //        if ($(this).val() != "0" && $(this).val() != "" && $.inArray($(this).val(), AllowedModeOfacquisition) == -1) {
        //            toRemove.push($(this).val());
        //        }
        //    });
        //    $(toRemove).each(function () {
        //        $("#ModeOfAcquisitionCodeId option[value='" + this + "']").remove();
        //    });
        //} else {
        //    $("#ModeOfAcquisitionCodeId option").each(function () {
        //        if ($(this).val() != "0" && $(this).val() != "") {
        //            $("#ModeOfAcquisitionCodeId option[value='" + $(this).val() + "']").remove();
        //        }
        //    });
        //    $("#ModeOfAcquisitionCodeId").attr("disabled", "disabled");
        //}

        return false;
    });


    $(document).delegate('#DMATDetailsID1', 'change', function (event) {
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
        var a = $('#SecurityTypeCodeId').val();
        $('#DivModeOfAcquisition').html("");
        if (a == 139001) {
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

    $(function () {
        if ($("#PreclearanceRequestForCodeId").val() == 142001) {
            $("#UserInfoIdRelative").prop("disabled", true);
        }
    });

    $('#Save1').confirm({
        title: $("#ConfirmMessage").val(),//"Are you sure want to confirm PRE-CLEARANCE Request?",
        text: $("#AlertMessage").val() + '<br/><br/>' + $("#BlockedPeriodMessage").val(),
        confirm: function (button, data) {
            $("#Save").attr("disabled", true);
            var values = $("#frmPreclearanceRequest").serializeArray();
            values.push({
                name: "acid",
                value: $("#PreclearaceRequestInsiderUserAction").val(),
                name: "formId",
                value:8
            });
            $.ajax({
                url: $("#SaveData").val(),
                type: 'post',
                headers: getRVToken(),
                cache: false,
                data: values,
                success: function (data) {
                    if (data.status) {
                        showMessage(data.msg, true);
                        window.location.href = $('#DisclosureList').val() + '?acid=' + $("#PreclearaceRequestInsiderUserAction").val();
                    } else {
                        $("#Save").attr("disabled", false);
                        DisplayErrors(data.error);
                    }
                },
                error: function (data) {
                    $("#Save").attr("disabled", false);
                    DisplayErrors(data.error);
                }
            });
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
        $('#frmPreclearanceRequest').removeData('validator');
        $('#frmPreclearanceRequest').removeData('unobtrusiveValidation');
        $("#frmPreclearanceRequest").each(function () { $.data($(this)[0], 'validator', false); });
        $.validator.unobtrusive.parse("#frmPreclearanceRequest");
        var a = $('input[name=PreclearanceRequestForCodeId]:checked').val();
        if (a == 142002 && $('#UserInfoIdRelative').val() <= 0) {
            $("#UserInfoIdRelative").rules("add", {
                required: true,
                messages: {
                    required: $("#RequiredUserRelativeMessage").val()
                }
            });
        }

        ValidatePoolSelection();

        if ($("#frmPreclearanceRequest").valid()) {

            if ($("#AgreeMessage").val() == "" || $("#agree").prop("checked") == true) {
                $('#Save1').trigger("click");
            } else {
                $.confirm({
                    title: 'Alert!',
                    text: $("#AgreeTermsMsg").val(),
                    confirm: function () {
                    },
                    confirmButton: "OK",
                    cancelButtonClass: "hide",
                    confirmButtonClass: "btn btn-success",
                    dialogClass: "modal-dialog modal-sm"
                });
                return false;
            }
        }
    });

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

    $(function () {
        if ($("#CalledFrom").val() == "View") {
            $('input, select, textarea').attr('disabled', 'disabled');
            $("#Save").hide();
            $("#Proceed").hide();
            $("#AddDAMT").hide();
        }

    });

    $(document).delegate('#UserInfoIdRelative', 'change', function (event) {
        var UserID = $('#UserInfoIdRelative').val();
        var values = $("#frmPreclearanceRequest").serializeArray();
        $("#UserInfoIdPassDMAT").val(UserID);
        $('#divDMAT').html("");
        $.ajax({
            url: $("#UserInfoIdRelativeChange").val(),
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
    });


    $('input,textarea,select', 'form').blur(function () {
        $(this).valid();
        $("#divValidationSummaryModal").removeClass("validation-summary-errors");
        $("#divValidationSummaryModal").addClass("validation-summary-valid");

    });




    $(document).delegate(".btnAddDMAT", "click", function () {
        var UserID = $("#UserInfoIdPassDMAT").val();
        if (UserID != null && UserID > 0) {
            $.ajax({
                url: $("#EditDMAT").val(),
                type: 'post',
                headers: getRVToken(),
                data: { "acid": $("#EditDMAT").attr("acid"), "nDMATDetailsID": $(this).attr("data-details"), "nUserInfoID": UserID },
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
            $.confirm({
                title: 'Alert!',
                text: 'Pleade select User Relative...?',
                confirm: function () {
                },
                confirmButton: "OK",
                cancelButtonClass: "hide",
                confirmButtonClass: "btn btn-success",
                dialogClass: "modal-dialog modal-sm"
            });
            return false;
        }
    });

    var dataTable = null;
    $(document).delegate("#btnSaveDMATDetails", "click", function () {

        if ($("#frmDMATDetails").valid()) {
            $.ajax({
                url: $("#SaveDMAT").val(),
                type: 'post',
                headers: getRVToken(),
                data: $("#frmDMATDetails").serialize(),
                success: function (data) {
                    if (data.status) {
                        showMessage(data.Message, true);
                        $("#DMATDetailsID").val(data.DMATDetailsID);

                        if (data.type && $(".btnEditDMATHolderDetails:visible").length == 0) {
                            GetDMATList();
                        }
                        else {
                            $("#divDMATHolderList").html("");
                            $("#divDMATDetailsModal").hide();
                            $('#DMATModal').modal('hide');

                            $.ajax({
                                url: $("#UserInfoIdRelativeChange").val(),
                                type: 'post',
                                headers: getRVToken(),
                                cache: false,
                                data: $("#frmPreclearanceRequest").serialize(),
                                success: function (result) {
                                    $('#divDMAT').html(result);
                                    $("#divDMATDetailsModal").hide();
                                    $('#DMATModal').modal('hide');
                                    $("#DMATDetailsID1").val(data.DMATDetailsID);
                                },
                                error: function (result) {
                                }
                            });
                        }
                    }
                    else {
                        $("#divDMATHolderList").html("");
                        $("#divDMATDetailsModal").hide();
                        $('#DMATModal').modal('hide');
                    }

                },
                error: function (jqXHR, textStatus, errorThrown) {
                    alert(errorThrown);
                }
            });
        }
        return false;
    });

    $(document).delegate("#DPBank", "click", function () {
        if ($('option:selected', $(this)).attr("value") == "Other") {
            $("#DPBankName").show();
            $("#divDPBankName").show()
        }
        else {
            $("#DPBankName").hide();
            $("#divDPBankName").hide();
        }
    });

    $(document).delegate("#btnSaveDMATHolderDetails", "click", function () {
        dataTable = $("table[name='DatatableGrid'][gridtype='" + $(this).attr("gridtype") + "']").dataTable();
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
                    alert(errorThrown);
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
                alert(errorThrown);
            }
        });
    });

    DesignationList = {};
    if ($('#DesignationAC').val() == 'yes') {
        $.ajax({
            url: $('#DesignantionListURL').val(),
            type: 'post',
            headers: getRVToken(),
            cache: false,
            data: {},
            success: function (response) {
                DesignationList = response;
                $("#12").autocomplete({ source: DesignationList });
            },
            error: function (response) { }
        });


    }


    $("[name=DatatableGrid][gridtype=114038]").delegate(".btnNoTransaction", "click", function (e) {

        $.ajax({
            url: $("#NoMoreTransaction").val(),
            type: 'post',
            headers: getRVToken(),
            data: { "PreclearanceRequestId": $(this).attr("PreclearanceRequestId"), "CalledFrom": "Insider" },
            success: function (data) {
                $("#divNotTradedModal").html(data);
                $("#divNotTradedModal").show();
                $('#NotTradedModal').modal('show');
            },
            error: function (jqXHR, textStatus, errorThrown) {
                alert(errorThrown);
            }
        });
    });


    $("[name=DatatableGrid][gridtype=114049]").delegate(".btnNoTransaction", "click", function (e) {

        $.ajax({
            url: $("#NoMoreTransaction").val(),
            type: 'post',
            headers: getRVToken(),
            data: { "PreclearanceRequestId": $(this).attr("PreclearanceRequestId"), "CalledFrom": "CO" },
            success: function (data) {
                $("#divNotTradedModal").html(data);
                $("#divNotTradedModal").show();
                $('#NotTradedModal').modal('show');
            },
            error: function (jqXHR, textStatus, errorThrown) {
                alert(errorThrown);
            }
        });
    });

    $(document).delegate("#dmatholder_cancelButton", "click", function () {
        $("#divDMATHodlerDetails").html("");
        return false;
    })

    $(document).delegate('#SecurityTypeCodeId', 'change', function (event) {
        ShowHideSecurityPool();
    });



    $(document).delegate("input#ApproveAction[type='button']", "click", function () {
        $.confirm({
            title: "Approve Preclearance",
            text: "Are you sure want to approve Preclearance Request..?",
            confirm: function (button) {
                $("#ApproveAction").attr("type", "submit");
                $("#ApproveAction").click();
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
            alert(errorThrown);
        }
    });
}


function ShowHideSecurityPool() {
    var transaction_type = $('#TransactionTypeCodeId').val();
    var security_type = $('#SecurityTypeCodeId').val();
    var show_pool_flag = $('#showExercisepool').val();

    var transaction = (transaction_type == "" || transaction_type == 143004) ? false : true;
    var security = (security_type != "" && security_type == 139001) ? true : false;

    if (show_pool_flag != 1) return;

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

function ValidatePoolSelection() {
    var transaction_type = $('#TransactionTypeCodeId').val();
    var security_type = $('#SecurityTypeCodeId').val();

    var transaction = (transaction_type != "" && (transaction_type == 143002 || transaction_type == 143008)) ? true : false;
    var security = (security_type != "" && security_type == 139001) ? true : false;

    var esopchk = $("#ESOPExcerciseOptionQtyFlag").filter(':checked').val()
    var otherchk = $("#OtherESOPExcerciseOptionQtyFlag").filter(':checked').val()

    if (transaction && security && esopchk != undefined && otherchk != undefined && !esopchk && !otherchk) {
        $("#ESOPExcerciseOptionQtyFlag").rules("add", {
            required: true,
            messages: {
                required: $("#SelectExercisePool").val()
            }
        });
    }
}