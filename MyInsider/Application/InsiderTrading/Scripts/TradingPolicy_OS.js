$(document).ready(function () {
   
    /*
        This Javascript event for Select Trading Policy 
        1. If 'Insider' Radio Button is Select then Preclearance Requirement section show.
        2.   if 'Employee'  Radio Button is Select then Preclearance Requirement section hide
           and by default 'Multiple Transaction Trade above' is selected in COntinuous Disclosure section for Employee
           type policy.
    */

    $(document).delegate('#TradingPolicyForCodeId', 'change', function (event) {
        var URL = $('#TradingPolicyForCodeType').val();
        var nTradingPolicyForCodeId = $(this).filter(':checked').val();
        var values = $("#frmTradingPolicy").serializeArray();
        values.push({
            name: "acid",
            value: $("#TradingPolicyUserAction").val()
        });       
        // If Insider Type policy.
        if ($("#AutoSubmitTransaction").val() == 178001) {
            $(':radio[name="StExSingMultiTransTradeFlagCodeId"]').prop("checked", null);
            $(':radio[name="StExSingMultiTransTradeFlagCodeId"]').attr("disabled", false);
            $('#SingleTransactionDiv').empty();
        } else if ($("#AutoSubmitTransaction").val() == 178002) {
            $(':radio[name="StExSingMultiTransTradeFlagCodeId"]').prop("checked", $('#MultipleTransactionTrade').val());
            $.ajax({
                url: $("#RadioButtonChangeTransaction").val(),
                type: 'post',
                headers: getRVToken(),
                cache: false,
                data: values,
                success: function (result) {
                    $('#SingleTransactionDiv').html(result);
                },
                error: function (result) {
                }
            });
            $(':radio[name="StExSingMultiTransTradeFlagCodeId"]').attr("disabled", true);

        }
        $('#lblSingleTransactionTrade').removeClass("TextGray");

        if (nTradingPolicyForCodeId > 0) {
            $('#DivPreClearanceRequired').html("");
            $.ajax({
                url: $("#TradingPolicyForCodeType").val(),
                type: 'post',
                headers: getRVToken(),
                cache: false,
                data: values,
                success: function (result) {
                    $('#DivPreClearanceRequired').html(result);
                },
                error: function (result) {
                }
            });
        }
        else {
            $('#DivPreClearanceRequired').empty();
        }
        

    });
     $(':radio[name="DiscloInitReqFlag"]').change(function () {
        var URL = $('#DiscloInitReqFlagURL').val();
        var a = $(this).filter(':checked').val();
        var values = $("#frmTradingPolicy").serializeArray();
        values.push({
            name: "acid",
            value: $("#TradingPolicyUserAction").val()
        });
        if (a == 'True') {
            $('#DivInitialDisclosure').html("");
            $.ajax({
                url: $("#DiscloInitReqFlagURL").val(),
                type: 'post',
                headers: getRVToken(),
                cache: false,
                data: values,
                success: function (result) {

                    $('#DivInitialDisclosure').html(result);
                },
                error: function (result) {
                }
            });
        }
        else {
            $('#DivInitialDisclosure').empty();
        }
    });

    $(':radio[name="DiscloPeriodEndReqFlag"]').change(function () {
        var URL = $('#DiscloPeriodEndReqFlagURL').val();
        var a = $(this).filter(':checked').val();
        var values = $("#frmTradingPolicy").serializeArray();
        values.push({
            name: "acid",
            value: $("#TradingPolicyUserAction").val()
        });
        if (a == 'True') {
            $('#DivPeiodEndDisclosure').html("");
            $.ajax({
                url: $("#DiscloPeriodEndReqFlagURL").val(),
                type: 'post',
                headers: getRVToken(),
                cache: false,
                data: values,
                success: function (result) {

                    $('#DivPeiodEndDisclosure').html(result);
                },
                error: function (result) {
                }
            });
        }
        else {
            $('#DivPeiodEndDisclosure').empty();
        }
    });

    $(':radio[name="ContraTradeBasedOn"]').change(function () {
        var URL = $('#ContraTradeSecuirtyMapping').val();
        var a = $(this).filter(':checked').val();
        var values = $("#frmTradingPolicy").serializeArray();
        values.push({
            name: "acid",
            value: $("#TradingPolicyUserAction").val()
        });
        $('#DivContraTradeSecurityMapping').html("");
        $.ajax({
            url: URL,
            type: 'post',
            headers: getRVToken(),
            cache: false,
            data: values,
            success: function (result) {

                $('#DivContraTradeSecurityMapping').html(result);
                DisableUnselectedSecurityType()
            },
            error: function (result) {
            }
        });
    });

    $('#BasicInfo').click(function () {
       
        var form = $("#frmTradingPolicy")
        .removeData("validator")
        .removeData("unobtrusiveValidation");
        $.validator.unobtrusive.parse(form);
        if (form.valid()) {
            return true;
        } else {
            return false;
        }
    });


    $(function () {

        if ($('input:radio[name=DiscloInitReqFlag]').filter(":checked").val() == 'False') {
            $(':checkbox[name="DiscloInitReqSoftcopyFlag"]').attr("disabled", true);
            $(':checkbox[name="DiscloInitReqHardcopyFlag"]').attr("disabled", true);
            $(':checkbox[name="DiscloInitReqSoftcopyFlag"]').prop("checked", null);
            $(':checkbox[name="DiscloInitReqHardcopyFlag"]').prop("checked", null);
        } else {
            $(':checkbox[name="DiscloInitReqSoftcopyFlag"]').attr("disabled", false);
            $(':checkbox[name="DiscloInitReqHardcopyFlag"]').attr("disabled", false);
        }
        if ($('input:radio[name=StExSubmitDiscloToCOByInsdrFlag]').filter(":checked").val() == 'False') {
            $(':checkbox[name="StExSubmitDiscloToCOByInsdrSoftcopyFlag"]').attr("disabled", true);
            $(':checkbox[name="StExSubmitDiscloToCOByInsdrHardcopyFlag"]').attr("disabled", true);
            $(':checkbox[name="StExSubmitDiscloToCOByInsdrSoftcopyFlag"]').prop("checked", null);
            $(':checkbox[name="StExSubmitDiscloToCOByInsdrHardcopyFlag"]').prop("checked", null);
        } else {
            $(':checkbox[name="StExSubmitDiscloToCOByInsdrSoftcopyFlag"]').attr("disabled", false);
            $(':checkbox[name="StExSubmitDiscloToCOByInsdrHardcopyFlag"]').attr("disabled", false);
        }
        if ($('input:radio[name=StExSubmitDiscloToCOByInsdrFlag]').filter(":checked").val() == 'False') {
            $(':checkbox[name="StExSubmitDiscloToCOByInsdrSoftcopyFlag"]').attr("disabled", true);
            $(':checkbox[name="StExSubmitDiscloToCOByInsdrHardcopyFlag"]').attr("disabled", true);
            $(':checkbox[name="StExSubmitDiscloToCOByInsdrSoftcopyFlag"]').prop("checked", null);
            $(':checkbox[name="StExSubmitDiscloToCOByInsdrHardcopyFlag"]').prop("checked", null);
        } else {
            $(':checkbox[name="StExSubmitDiscloToCOByInsdrSoftcopyFlag"]').attr("disabled", false);
            $(':checkbox[name="StExSubmitDiscloToCOByInsdrHardcopyFlag"]').attr("disabled", false);
        }
        if ($('input:radio[name=DiscloPeriodEndReqFlag]').filter(":checked").val() == 'False') {
            $(':checkbox[name="DiscloPeriodEndReqSoftcopyFlag"]').attr("disabled", true);
            $(':checkbox[name="DiscloPeriodEndReqHardcopyFlag"]').attr("disabled", true);
            $(':checkbox[name="DiscloPeriodEndReqSoftcopyFlag"]').prop("checked", null);
            $(':checkbox[name="DiscloPeriodEndReqHardcopyFlag"]').prop("checked", null);
        } else {
            $(':checkbox[name="DiscloPeriodEndReqSoftcopyFlag"]').attr("disabled", false);
            $(':checkbox[name="DiscloPeriodEndReqHardcopyFlag"]').attr("disabled", false);
        }

        if ($("#CalledFrom").val() == "View") {
            $('input[type=text],input[type=checkbox],input[type=radio], select, textarea').attr('disabled', 'disabled');
            $("#BasicInfo").hide();
            $("#Delete").hide();

        }
        if ($("#CalledFrom").val() == "History") {
            $('input[type=text],input[type=checkbox],input[type=radio], select, textarea').attr('disabled', 'disabled');
            $("#BasicInfo").hide();
            $("#Delete").hide();
            $("#btnDefineApplicablility").show();
        }

        if ($("#AutoSubmitTransaction").val() == 178002) {

            $(':radio[name="StExSubmitTradeDiscloAllTradeFlag"]').prop("checked", 'False');
            $(':radio[name="StExSubmitTradeDiscloAllTradeFlag"]').attr("disabled", true);
            $(':radio[name="StExSingMultiTransTradeFlagCodeId"]').prop("checked", $('#MultipleTransactionTrade').val());
            $(':radio[name="StExSingMultiTransTradeFlagCodeId"]').attr("disabled", true);
        }
    });

    function ShowConfirm(Title, Message, URL) {
        $('#MainConfirm').trigger("click", [Title, Message, URL]);
    }


    $(document).delegate("#MainConfirm", "click", function (event, Title, Message, URL) {
        $.confirm({
            title: Title,
            text: Message,//"Are you sure want to delete this Company.?",
            confirm: function (button) {
                window.location.href = URL;
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

    $('#DeleteTradingPolicy').click(function () {
        var URL = $("#DeleteTradingPolicyDetails").val() + "?TradingPolicyId=" + $("#TradingPolicyId").val() + "&acid=" + $("#TradingPolicyDeleteUserAction").val() + "&TradingPolicyForAction=" + $("#TradingPolicyUserAction").val();
        ShowConfirm("WARNING", "Are you sure want to delete this Trading Policy.?", URL);
    });

    $(':radio[name="DiscloInitReqFlag"]').change(function () {
        var a = $(this).filter(':checked').val();
        if (a == 'True') {
            $(':checkbox[name="DiscloInitReqSoftcopyFlag"]').prop("disabled", false);
            $(':checkbox[name="DiscloInitReqHardcopyFlag"]').prop("disabled", false);
        }
        else {
            $(':checkbox[name="DiscloInitReqSoftcopyFlag"]').attr("disabled", true);
            $(':checkbox[name="DiscloInitReqHardcopyFlag"]').attr("disabled", true);
            $(':checkbox[name="DiscloInitReqSoftcopyFlag"]').prop("checked", null);
            $(':checkbox[name="DiscloInitReqHardcopyFlag"]').prop("checked", null);
        }
    });

    $(':radio[name="DiscloPeriodEndReqFlag"]').change(function () {
        var a = $(this).filter(':checked').val();
        if (a == 'True') {
            $(':checkbox[name="DiscloPeriodEndReqSoftcopyFlag"]').prop("disabled", false);
            $(':checkbox[name="DiscloPeriodEndReqHardcopyFlag"]').prop("disabled", false);
        }
        else {
            $(':checkbox[name="DiscloPeriodEndReqSoftcopyFlag"]').attr("disabled", true);
            $(':checkbox[name="DiscloPeriodEndReqHardcopyFlag"]').attr("disabled", true);
            $(':checkbox[name="DiscloPeriodEndReqSoftcopyFlag"]').prop("checked", null);
            $(':checkbox[name="DiscloPeriodEndReqHardcopyFlag"]').prop("checked", null);
        }
    });

    $(':radio[name="StExSubmitDiscloToCOByInsdrFlag"]').change(function () {
        var a = $(this).filter(':checked').val();
        var values = $("#frmTradingPolicy").serializeArray();
        values.push({
            name: "acid",
            value: $("#TradingPolicyUserAction").val()
        });
        if (a == 'True') {
            $(':checkbox[name="StExSubmitDiscloToCOByInsdrSoftcopyFlag"]').prop("disabled", false);
            $(':checkbox[name="StExSubmitDiscloToCOByInsdrHardcopyFlag"]').prop("disabled", false);
            if ($('input:radio[name=TradingPolicyForCodeId]').filter(":checked").val() == 135002) {
                $(':radio[name="StExSingMultiTransTradeFlagCodeId"]').prop("checked", $('#MultipleTransactionTrade').val());
                $.ajax({
                    url: $("#RadioButtonChangeTransaction").val(),
                    type: 'post',
                    headers: getRVToken(),
                    cache: false,
                    data: values,
                    success: function (result) {
                        $('#SingleTransactionDiv').html(result);
                    },
                    error: function (result) {
                    }
                });
                $(':radio[name="StExSingMultiTransTradeFlagCodeId"]').attr("disabled", true);
                $('#lblSingleTransactionTrade').addClass("TextGray");
                $(':radio[name="StExForAllSecuritiesFlag"]').attr("disabled", false);
            }
            else {

                if ($("#AutoSubmitTransaction").val() == 178001) {
                    $(':radio[name="StExSingMultiTransTradeFlagCodeId"]').prop("checked", null);
                    $(':radio[name="StExSingMultiTransTradeFlagCodeId"]').attr("disabled", false);
                }
                else if ($("#AutoSubmitTransaction").val() == 178002) {
                    $(':radio[name="StExSingMultiTransTradeFlagCodeId"]').prop("checked", $('#MultipleTransactionTrade').val());
                    $.ajax({
                        url: $("#RadioButtonChangeTransaction").val(),
                        type: 'post',
                        headers: getRVToken(),
                        cache: false,
                        data: values,
                        success: function (result) {
                            $('#SingleTransactionDiv').html(result);
                        },
                        error: function (result) {
                        }
                    });
                    $(':radio[name="StExSingMultiTransTradeFlagCodeId"]').attr("disabled", true);
                }

                $('#lblSingleTransactionTrade').removeClass("TextGray");
            }

            //  $('#DIVCOntinuousDisclosureRequired').html("");
            $.ajax({
                url: $("#ContinuousDisclosureRequiredURL").val(),
                type: 'post',
                headers: getRVToken(),
                cache: false,
                data: values,
                success: function (result) {
                    $('#DIVCOntinuousDisclosureRequired').html(result);
                },
                error: function (result) {
                }
            });


        } else {
            $(':checkbox[name="StExSubmitDiscloToCOByInsdrSoftcopyFlag"]').attr("disabled", true);
            $(':checkbox[name="StExSubmitDiscloToCOByInsdrHardcopyFlag"]').attr("disabled", true);
            $(':checkbox[name="StExSubmitDiscloToCOByInsdrSoftcopyFlag"]').prop("checked", null);
            $(':checkbox[name="StExSubmitDiscloToCOByInsdrHardcopyFlag"]').prop("checked", null);
            $('#DIVCOntinuousDisclosureRequired').html("");
        }

    });

    $("#BasicInfo").click(function () {
        
        var a = $('input[name=TradingPolicyForCodeId]:checked').val();

        dataTable = $("table[name='DatatableGrid'][gridtype='" + $(this).attr("gridtype") + "']").dataTable();
        objTable = $("table[name='DatatableGrid'][gridtype='" + $(this).attr("gridtype") + "']");
        dataTable1 = $("table[name='DatatableGrid_1'][gridtype='" + $(this).attr("gridtype") + "']").dataTable();
        objTable1 = $("table[name='DatatableGrid_1'][gridtype='" + $(this).attr("gridtype") + "']");
        if (objTable != null)
            var PreclearanceSecuritywisedata = Save(dataTable, objTable);
        if (objTable1 != null)
            var ContinousSecuritywisedata = Save(dataTable1, objTable1);
        var values = $("#frmTradingPolicy").serializeArray();
      

        values.push({
            name: "PreclearanceSecuritywisedata",
            value: JSON.stringify(PreclearanceSecuritywisedata),
            name: "formId",
            value: 29
        });
        values.push({
            name: "ContinousSecuritywisedata",
            value: JSON.stringify(ContinousSecuritywisedata)
        });

        var SelectedOptions = new Array();
        
        $("input[type='checkbox'].preclearancetransactiosecurity:checked").each(function () {
            var a = (this.id).split('-');
            var json = {
                TransactionType: a[0].replace(/,/g, ""),
                SecurityType: a[1].replace(/,/g, ""),

            };
            SelectedOptions.push(json);
        });

        var SelectedSecurityTypeOptions = new Array();
        $("input[type='checkbox'].contratradesecurity:checked").each(function () {
            var json = {
                SecurityType: this.id,

            };
            SelectedSecurityTypeOptions.push(json);
        });

        values.push({
            name: "SelectedOptionsCheckBox",
            value: JSON.stringify(SelectedOptions)
        });

        values.push({
            name: "SelectedSecurityTypeOptions",
            value: JSON.stringify(SelectedSecurityTypeOptions)
        });

        if ($('#TradingPolicyId').val() > 0 && $('#CountUserAndOverlapTradingPolicy').val() > 0) {
            $.ajax({
                url: $("#ViewOverlappedUser").val(),
                type: 'post',
                headers: getRVToken(),
                data: { 'TradingPolicyId': $('#TradingPolicyId').val(), 'ShowFrom': 'TradingPolicy_OS' },//values,
                success: function (data) {
                    $("#divOverlapModal").html(data);
                    $("body").removeClass("loading");
                    $("#divOverlapModal").show();
                    $('#OverlapModal').modal('show');
                },
                error: function (jqXHR, textStatus, errorThrown) {
                    alert(errorThrown);
                }
            });
        } else {
            $('#Save2').trigger("click");
        }

    });

    $('#Save1').confirm({
        
        title: "WARNING",
        text: $("#AffectApplicability").val(),//"This change may affect applicability. Please check Applicability screen for this policy.",
        confirm: function (button) {

            var values = $("#frmTradingPolicy").serializeArray();
            values.push({
                name: "acid",
                value: $("#TradingPolicyUserAction").val()
            });

            $.ajax({
                url: $("#SaveTradingPolicy").val(),
                type: 'post',
                headers: getRVToken(),
                cache: false,
                data: values,
                success: function (data) {
                    if (data.status) {
                        showMessage(data.msg);
                        if (data.TradingPolicyStatus == 141002) {
                            setTimeout(function () {
                                window.location.href = $('#PolicyList').val();
                            }, 1000);
                        } else {
                            setTimeout(function () {
                                window.location.href = $('#CreateTradingPolicy').val() + "?TradingPolicyId=" + $('#TradingPolicyId').val() + "&CalledFrom=" + $('#CalledFrom').val() + "&ParentTradingPolicy=0&acid=" + $("#TradingPolicyUserAction").val();
                            }, 1000);
                        }
                    } else {
                        DisplayErrors(data.error);
                        $(window).scrollTop(0);
                    }
                },
                error: function (data) {
                    DisplayErrors(data.error);
                    $(window).scrollTop(0);
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

    $('input,textarea', 'form').blur(function () {

        $(this).valid();

        $("#divValidationSummaryModal").removeClass("validation-summary-errors");
        $("#divValidationSummaryModal").addClass("validation-summary-valid");

    });

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

    function Save(dataTable, objTable) {
        var lst = new Array();
        $("#" + objTable.attr("id") + " > tbody  > tr").each(function () {
            var inpNoOfShare = $(this).find(".inpNoOfShare").val();
            var inpCapital = $(this).find(".inpCapital").val();
            var inpValueOfShare = $(this).find(".inpValueOfShare").val();
            var inpSecurityCodeID = $(this).find(".inpSecurityCodeID").val();
            if (inpSecurityCodeID == "null") {
                inpSecurityCodeID = 0;
            }
            if (inpNoOfShare != undefined) {
                var json = {
                    NoOfShare: inpNoOfShare.replace(/,/g, ""),
                    Capital: inpCapital.replace(/,/g, ""),
                    ValueOfShare: inpValueOfShare.replace(/,/g, ""),
                    SecurityCodeID: inpSecurityCodeID,
                };
                lst.push(json);
            }
        });
        var postData = { listdata: lst };
        return lst;//postData;
    }

    $(':checkbox[name="DiscloInitReqHardcopyFlag"]').change(function () {

        if ($(this).is(":checked")) {
            $(':checkbox[name="DiscloInitReqSoftcopyFlag"]').prop("checked", true);
        }
    });


    $(':checkbox[name="DiscloInitReqSoftcopyFlag"]').change(function () {

        if (!$(this).is(":checked")) {
            $(':checkbox[name="DiscloInitReqHardcopyFlag"]').prop("checked", false);
        }
    });

    $(':checkbox[name="StExSubmitDiscloToCOByInsdrHardcopyFlag"]').change(function () {

        if ($(this).is(":checked")) {
            $(':checkbox[name="StExSubmitDiscloToCOByInsdrSoftcopyFlag"]').prop("checked", true);
        }
    });

    $(':checkbox[name="StExSubmitDiscloToCOByInsdrSoftcopyFlag"]').change(function () {

        if (!$(this).is(":checked")) {
            $(':checkbox[name="StExSubmitDiscloToCOByInsdrHardcopyFlag"]').prop("checked", false);
        }
    });

    $(':checkbox[name="DiscloPeriodEndReqHardcopyFlag"]').change(function () {

        if ($(this).is(":checked")) {
            $(':checkbox[name="DiscloPeriodEndReqSoftcopyFlag"]').prop("checked", true);
        }
    });

    $(':checkbox[name="DiscloPeriodEndReqSoftcopyFlag"]').change(function () {

        if (!$(this).is(":checked")) {
            $(':checkbox[name="DiscloPeriodEndReqHardcopyFlag"]').prop("checked", false);
        }
    });

    $(document).delegate("#btnOk", "click", function () {
        $('#OverlapModal').modal('hide');
        $("#divOverlapModal").hide();
        $("#divOverlapModal").html();
        $('#Save2').trigger("click");

    });


    $("#Save2").click(function () {
        var a = $('input[name=TradingPolicyForCodeId]:checked').val();
        if ($('#HasApplicabilityDefinedFlag').val() == 1 && $('#TradingPolicyType').val() != a) {
            $('#Save1').trigger("click");
        } else {
            dataTable = $("table[name='DatatableGrid']").dataTable();
            objTable = $("table[name='DatatableGrid']");
            dataTable1 = $("table[name='DatatableGrid_1']").dataTable();
            objTable1 = $("table[name='DatatableGrid_1']");
            if (objTable != null)
                var PreclearanceSecuritywisedata = Save(dataTable, objTable);
            if (objTable1 != null)
                var ContinousSecuritywisedata = Save(dataTable1, objTable1);            
            var values = $("#frmTradingPolicy").serializeArray();
            values.push({
                name: "PreclearanceSecuritywisedata",
                value: JSON.stringify(PreclearanceSecuritywisedata)
            });
            values.push({
                name: "ContinousSecuritywisedata",
                value: JSON.stringify(ContinousSecuritywisedata)
            });
            values.push({
                name: "formId",
                value: 29
            });


            var SelectedOptions = new Array();           
            $("input[type='checkbox'].preclearancetransactiosecurity:checked").each(function () {
                var a = (this.id).split('-');
                var json = {
                    TransactionType: a[0].replace(/,/g, ""),
                    SecurityType: a[1].replace(/,/g, ""),

                };
                SelectedOptions.push(json);
            });


            var SelectedSecurityTypeOptions = new Array();
            $("input[type='checkbox'].contratradesecurity:checked").each(function () {
                var json = {
                    SecurityType: this.id,

                };
                SelectedSecurityTypeOptions.push(json);
            });

            values.push({
                name: "SelectedOptionsCheckBox",
                value: JSON.stringify(SelectedOptions)
            });
            values.push({
                name: "acid",
                value: $("#TradingPolicyUserAction").val()
            });

            values.push({
                name: "SelectedSecurityTypeOptions",
                value: JSON.stringify(SelectedSecurityTypeOptions)
            });

            $.ajax({
                url: $("#SaveTradingPolicy").val(),
                type: 'post',
                headers: getRVToken(),
                cache: false,
                data: values,
                success: function (data) {
                    if (data.status) {
                        showMessage(data.msg, true);
                        if (data.TradingPolicyStatus == 141002) {
                            setTimeout(function () {
                                window.location.href = $('#PolicyList').val() + "?acid=121";
                            }, 1000);
                        } else {
                            setTimeout(function () {
                                window.location.href = $('#CreateTradingPolicy').val() + "?TradingPolicyId=" + data.TradingPolicyId + "&CalledFrom=" + $('#CalledFrom').val() + "&ParentTradingPolicy=0&acid=" + $("#TradingPolicyUserAction").val();
                            }, 1000);
                        }

                    } else {
                        DisplayErrors(data.error);
                        $(window).scrollTop(0);
                    }
                },
                error: function (data) {
                    DisplayErrors(data.error);
                    $(window).scrollTop(0);
                }
            });
        }

    });

    $(document).delegate('input:radio[name="SearchType"]:checked', 'click', function (event) {        
        
        var Limited = this.value;
        if (Limited == 528002) {
            $("#SearchLimit").show();
            sessionStorage.setItem("checkvalues", 528002);

        }
        else {
            $("#SearchLimit").hide();
            $("#SearchLimit").val("");
            sessionStorage.setItem("checkvalues", 528001);
            
        }

    });

    $('input:radio[name="PreClrTradesApprovalReqFlag"]').change(function () {
       
        var values = $("#frmTradingPolicy").serializeArray();
        values.push({
            name: "acid",
            value: $("#TradingPolicyUserAction").val()
        });
        var URL = $('#PreClearanceTransactionForTrade').val();
        var a = $(this).filter(':checked').val();
        if (a == 'False') {
            $('#DivPreclearanceTransaction').html("");
            $.ajax({
                url: $("#PreClearanceTransactionForTrade").val(),
                type: 'post',
                headers: getRVToken(),
                cache: false,
                data: values,
                success: function (result) {
                    $('#DivPreclearanceTransaction').html(result);
                },
                error: function (result) {
                }
            });
        }
        else {
            $('#DivPreclearanceTransaction').empty();
        }
        check();
    });

    $(':radio[name="PreClrSeekDeclarationForUPSIFlag"]').change(function () {
        var URL = $('#PreClrSeekDeclarationForUPSIFlagURL').val();
        var a = $(this).filter(':checked').val();
        var values = $("#frmTradingPolicy").serializeArray();
        values.push({
            name: "acid",
            value: $("#TradingPolicyUserAction").val()
        });
        if (a == 'True') {
            $('#DivPreClrUPSIDeclaration').html("");
            $.ajax({
                url: $("#PreClrSeekDeclarationForUPSIFlagURL").val(),
                type: 'post',
                headers: getRVToken(),
                cache: false,
                data: values,
                success: function (result) {
                    $('#DivPreClrUPSIDeclaration').html(result);
                },
                error: function (result) {
                }
            });
        }
        else {
            $('#DivPreClrUPSIDeclaration').empty();
        }
    });

    $(':radio[name="PreClrReasonForNonTradeReqFlag"]').change(function () {
        var values = $("#frmTradingPolicy").serializeArray();
        values.push({
            name: "acid",
            value: $("#TradingPolicyUserAction").val()
        });
        var URL = $('#PreClrPartialTradeNotDoneFlagURL').val();
        var a = $(this).filter(':checked').val();
        if (a == 'True') {
            $('#divPreclrpartialtradenotdoneflag').html("");
            $.ajax({
                url: $("#PreClrPartialTradeNotDoneFlagURL").val(),
                type: 'post',
                headers: getRVToken(),
                cache: false,
                data: values,
                success: function (result) {

                    $('#divPreclrpartialtradenotdoneflag').html(result);
                },
                error: function (result) {
                }
            });
        }
        else {
            $('#divPreclrpartialtradenotdoneflag').empty();
        }
    });



    $(document).delegate('#SelectedPreClearancerequiredforTransaction', 'change', function (event) {
        var SelectedPreClearancerequiredforValue = $("#SelectedPreClearancerequiredforTransaction").val();
        var values = $("#frmTradingPolicy").serializeArray();
        values.push({
            name: "acid",
            value: $("#TradingPolicyUserAction").val()
        });
        $('#DivProhibitDuringNonTradingPeriod').html("");
        $.ajax({
            url: $("#ProhibitPreclearanceValueChange").val(),
            type: 'post',
            headers: getRVToken(),
            cache: false,
            data: values,
            success: function (result) {
                $('#DivProhibitDuringNonTradingPeriod').html(result);

            },
            error: function (result) {
            }

        });
        return false;
    });

    $(document).delegate('#SelectedPreClearancerequiredforTransaction', 'change', function (event) {
        var SelectedPreClearancerequiredforValue = $("#SelectedPreClearancerequiredforTransaction").val();
        var values = $("#frmTradingPolicy").serializeArray();
        values.push({
            name: "acid",
            value: $("#TradingPolicyUserAction").val()
        });
        $('#divTransactionSecurityMapping').html("");
        $.ajax({
            url: $("#TransactionSecuityMappingChange").val(),
            type: 'post',
            headers: getRVToken(),
            cache: false,
            data: values,
            success: function (result) {
                $('#divTransactionSecurityMapping').html(result);
                DisableUnselectedSecurityTypeControl();
            },
            error: function (result) {
            }

        });
        return false;
    });

    $(document).delegate('.preclearancetransactiosecurity', 'change', function (event) {

        DisableUnselectedSecurityTypeControl();

    });

    ShowLimitedSearchOption($('input:radio[name="SearchType"]:checked').val());
    $(document).delegate('input:radio[name="SearchType"]:checked', 'click', function (event) {
        ShowLimitedSearchOption(this.value);
    });

    if ($('.PreClrReqRadio')[0].checked == true) {
        $("#hideAll").show();
    }
    else if ($('.PreClrReqRadio')[1].checked == true) {
        $("#hideAll").hide();
    }

});

function ShowLimitedSearchOption(opt_val) {
    sessionStorage.setItem("checkvalues", opt_val);
    if (opt_val == 'Perpetual') {
        $('#noOfHits').fadeOut('fast');

    } else if (opt_val == 'Limited') {
        $('#noOfHits').fadeIn('fast');
    }
}

function DisableUnselectedSecurityType() {
    if ($("#TradingPolicyId").val() == 0) {
       
        $("input[type='checkbox'].preclearancetransactiosecurity:checked").each(function () {
            var value = this.id;
            if ($(this).is(":checked")) {
                $('#DivContraTradeSecurityMapping #' + value.split('-')[1]).prop("checked", true);
            }
        });
    }
}
