$(document).ready(function () {


    $('input,textarea', 'form').blur(function () {
        $(this).valid();

        $("#divValidationSummaryModal").removeClass("validation-summary-errors");
        $("#divValidationSummaryModal").addClass("validation-summary-valid");
    });

    $(document).delegate('.btnDeleteCompany', 'click', function (event) {
        var CompanyId = $(event.currentTarget).attr('CompanyId');
        var RvToken = getRVToken();
        var URL = $("#DeleteFromGrid").val() + "&CompanyId=" + CompanyId + "&__RequestVerificationToken=" + RvToken.version + "&formId=88";
        ShowConfirm("WARNING", $("#deletealertmessage").val(), URL);
    });

    function ShowConfirm(Title, Message, URL) {
        $('#MainConfirm').trigger("click", [Title, Message, URL]);
    }

    $(document).delegate("#MainConfirm", "click", function (event, Title, Message, URL) {

        $.confirm({
            title: Title,
            text: Message,//"Are you sure want to delete this Company.?",
            confirm: function (button) {
                window.location.href = URL;//$("#DeleteFromGrid").val() + "&CompanyId=" + data.CompanyId;
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

    function test(Title, Message, confirm, cancel, btnId, fnCallback) {
        var obj = $.confirm({
            title: Title,
            text: Message,
            confirm: function () {
                fnCallback(btnId);
            },
            cancel: function () {
            },
            confirmButton: "Yes I Confirm",
            cancelButton: "No",
            post: true,
            confirmButtonClass: "btn btn-success",
            cancelButtonClass: "btn-danger",
            dialogClass: "modal-dialog modal-lg"
        });

    }

    function callback() {
        return true;
    }

    $('#DeleteCompany').click(function () {
        var URL = $("#DeleteFromGrid").val() + "&CompanyId=" + $("#CompanyId").val() + "&acid=" + $("#CompanyDeleteAction").val();
        ShowConfirm("WARNING", $("#deletealertmessage").val(), URL);
    });

    $("#btnSaveCompanyBasicInfo").click(function () {

        $('#frmBasicInfo').removeData('validator');
        $('#frmBasicInfo').removeData('unobtrusiveValidation');
        $("#frmBasicInfo").each(function () { $.data($(this)[0], 'validator', false); });
        $.validator.unobtrusive.parse("#frmBasicInfo");
        var values = $("#frmBasicInfo").serializeArray();
        values.push({
            name: "acid",
            value: $("#UserAction").val()
        });
        values.push({
            name: "formId",
            value: 25
        });
        if ($("#frmBasicInfo").valid()) {
            $.ajax({
                url: $("#SaveBasicInfo").val(),
                type: 'post',
                headers: getRVToken(),
                cache: false,
                data: values,
                success: function (result) {
                    var targetDiv = "#1_BasicInfo";
                    $(targetDiv).html(result);
                    $(targetDiv).show();
                    var visible = $('#divValidationSummaryModal').is(':visible');
                    if (!visible) {
                        showMessage("Company Name :- " + $('#CompanyName').val() + "  Save Successfully", true);
                    }
                },
                error: function (result) {
                    // alert(data.error);
                    var targetDiv = "#1_BasicInfo";
                    $(targetDiv).html(result);
                    $(targetDiv).show();
                }
            });
        }

    });

    $("#SaveCompanyFaceValue").click(function () {

        $('#frmFaceValue').removeData('validator');
        $('#frmFaceValue').removeData('unobtrusiveValidation');
        $("#frmFaceValue").each(function () { $.data($(this)[0], 'validator', false); });
        $.validator.unobtrusive.parse("#frmFaceValue");
        var values = $("#frmFaceValue").serializeArray();

        values.push({
            name: "acid",
            value: $("#UserAction").val()
        });
        values.push({
            name: "formId",
            value: 20
        });
        if ($("#frmFaceValue").valid()) {
            $.ajax({
                url: $("#SaveFaceValue").val(),
                type: 'post',
                headers: getRVToken(),
                cache: false,
                data: values,
                success: function (result) {
                    $(this).closest('#frmFaceValue').find("input[type=text], textarea").val("");
                    //  showMessage("Data Save Successfully", true);
                    showMessage($("#FaceValueSucceess").val(), true);
                    var targetDiv = "#2_FaceValue";
                    $(targetDiv).html(result);
                    $(targetDiv).show();
                },
                error: function (result) {
                    // alert(data.error);
                    var targetDiv = "#2_FaceValue";
                    $(targetDiv).html(result);
                    $(targetDiv).show();
                }
            });
        }

    });

    $("[name=DatatableGrid][gridtype=114011]").delegate(".btnEditFaceValue", "click", function (e) {
        $.ajax({
            url: $("#EditFaceValue").val(),
            type: 'post',
            headers: getRVToken(),
            cache: false,
            data: { "CompanyFaceValueID": $(this).attr("CompanyFaceValueID"), "acid": $("#UserAcion").val() },
            success: function (result) {
                var targetDiv = "#2_FaceValue";
                $(targetDiv).html(result);
                $(targetDiv).show();
            },
            error: function (jqXHR, textStatus, errorThrown) {
                alert(errorThrown);
            }
        });
    });

    $("#SaveAuthorisedShares").click(function () {

        $('#frmAuthorisedShares').removeData('validator');
        $('#frmAuthorisedShares').removeData('unobtrusiveValidation');
        $("#frmAuthorisedShares").each(function () { $.data($(this)[0], 'validator', false); });
        $.validator.unobtrusive.parse("#frmAuthorisedShares");
        var values = $("#frmAuthorisedShares").serializeArray();

        values.push({
            name: "acid",
            value: $("#UserAction").val()
        });
        values.push({
            name: "formId",
            value: 21
        });
        if ($("#frmAuthorisedShares").valid()) {
            $.ajax({
                url: $("#SaveAuthorizedShareCapital").val(),
                type: 'post',
                headers: getRVToken(),
                cache: false,
                data: values,
                success: function (result) {
                    showMessage($("#AuthorizedShareSucceess").val(), true);
                    $(this).closest('#frmAuthorisedShares').find("input[type=text], textarea").val("");
                    var targetDiv = "#3_AuthorisedCapital";
                    $(targetDiv).html(result);
                    $(targetDiv).show();
                },
                error: function (result) {
                    var targetDiv = "#3_AuthorisedCapital";
                    $(targetDiv).html(result);
                    $(targetDiv).show();
                }
            });
        }
    });

    $("[name=DatatableGrid][gridtype=114012]").delegate(".btnEditAuthorisedShares", "click", function (e) {
        $.ajax({
            url: $("#EditAuthorizedShareCapital").val(),
            type: 'post',
            headers: getRVToken(),
            cache: false,
            data: { "CompanyAuthorizedShareCapitalID": $(this).attr("CompanyAuthorizedShareCapitalID"), "acid": $("#UserAcion").val() },
            success: function (result) {
                var targetDiv = "#3_AuthorisedCapital";
                $(targetDiv).html(result);
                $(targetDiv).show();
            },
            error: function (jqXHR, textStatus, errorThrown) {
                alert(errorThrown);
            }
        });

    });

    $("#btnSavePaidUpCapital").click(function () {

        $('#frmPaidUpAndSubscribedShareCapital').removeData('validator');
        $('#frmPaidUpAndSubscribedShareCapital').removeData('unobtrusiveValidation');
        $("#frmPaidUpAndSubscribedShareCapital").each(function () { $.data($(this)[0], 'validator', false); }); //enable to display the error messages
        $.validator.unobtrusive.parse("#frmPaidUpAndSubscribedShareCapital");
        var values = $("#frmPaidUpAndSubscribedShareCapital").serializeArray();

        values.push({
            name: "acid",
            value: $("#UserAction").val()
        });
        values.push({
            name: "formId",
            value: 22
        });
        if ($("#frmPaidUpAndSubscribedShareCapital").valid()) {
            $.ajax({
                url: $("#SavePaidUpCapital").val(),
                type: 'post',
                headers: getRVToken(),
                cache: false,
                data: values,
                success: function (result) {
                    // showMessage("Data Save Successfully",true);
                    showMessage($("#CapitalSucceess").val(), true);
                    $(this).closest('#frmPaidUpAndSubscribedShareCapital').find("input[type=text], textarea").val("");
                    var targetDiv = "#4_ShareCapital";
                    $(targetDiv).html(result);
                    $(targetDiv).show();
                },
                error: function (jqXHR, textStatus, errorThrown) {
                    alert(errorThrown);
                }
            });
        }

    });

    $("[name=DatatableGrid][gridtype=114013]").delegate(".btnEditPaidUpAndSubscribeShareCapital", "click", function (e) {
        $.ajax({
            url: $("#EditPaidUpCapital").val(),
            type: 'post',
            headers: getRVToken(),
            cache: false,
            data: { "CompanyPaidUpAndSubscribedShareCapitalID": $(this).attr("CompanyPaidUpAndSubscribedShareCapitalID"), "acid": $("#UserAcion").val() },
            success: function (result) {
                var targetDiv = "#4_ShareCapital";
                $(targetDiv).html(result);
                $(targetDiv).show();
            },
            error: function (jqXHR, textStatus, errorThrown) {
                alert(errorThrown);
            }
        });

    });

    $("#btnSaveListingDetails").click(function () {
        $('#frmListingDetails').removeData('validator');
        $('#frmListingDetails').removeData('unobtrusiveValidation');
        $("#frmListingDetails").each(function () { $.data($(this)[0], 'validator', false); }); //enable to display the error messages
        $.validator.unobtrusive.parse("#frmListingDetails");
        var values = $("#frmListingDetails").serializeArray();
        values.push({
            name: "acid",
            value: $("#UserAction").val()
        });
        values.push({
            name: "formId",
            value: 23
        });
        if ($("#frmListingDetails").valid()) {
            $.ajax({
                url: $("#SaveListingDetails").val(),
                type: 'post',
                headers: getRVToken(),
                cache: false,
                data: values,
                success: function (result) {
                    var isVisible = $(result).find("#IsError").val();
                    var targetDiv = "#5_ListingDetails";
                    $(targetDiv).html(result);
                    $(targetDiv).show();
                    if (isVisible == 0) {
                        showMessage($("#ListingDetailsSucceess").val(), true);
                    }
                },
                error: function (jqXHR, textStatus, errorThrown) {

                }
            });
        }

    });

    $("[name=DatatableGrid][gridtype=114014]").delegate(".btnEditListingDetails", "click", function (e) {
        $.ajax({
            url: $("#EditListingDetails").val(),
            type: 'post',
            headers: getRVToken(),
            cache: false,
            data: { "CompanyListingDetailsID": $(this).attr("CompanyListingDetailsID"), "acid": $("#UserAcion").val() },
            success: function (result) {
                var targetDiv = "#5_ListingDetails";
                $(targetDiv).html(result);
                $(targetDiv).show();
            },
            error: function (jqXHR, textStatus, errorThrown) {
                alert(errorThrown);
            }
        });
    });

    $("#btnSaveComplianceOfficer").click(function () {
        $('#frmComplianceOfficer').removeData('validator');
        $('#frmComplianceOfficer').removeData('unobtrusiveValidation');
        $("#frmComplianceOfficer").each(function () { $.data($(this)[0], 'validator', false); }); //enable to display the error messages
        $.validator.unobtrusive.parse("#frmComplianceOfficer");
        var values = $("#frmComplianceOfficer").serializeArray();
        values.push({
            name: "acid",
            value: $("#UserAction").val()
        });
        if ($("#frmComplianceOfficer").valid()) {
            $.ajax({
                url: $("#SaveComplianceOfficer").val(),
                type: 'post',
                headers: getRVToken(),
                cache: false,
                data: values,
                success: function (result) {
                    // showMessage("Data Save Successfully",true);
                    showMessage($("#ComplianceOfficerSucceess").val(), true);
                    $(this).closest('#frmComplianceOfficer').find("input[type=text], textarea").val("");
                    var targetDiv = "#6_ComplianceOfficer";
                    $(targetDiv).html(result);
                    $(targetDiv).show();
                },
                error: function (jqXHR, textStatus, errorThrown) {

                }
            });
        }
    });

    $("[name=DatatableGrid][gridtype=114015]").delegate(".btnEditComplianceOfficer", "click", function (e) {
        $.ajax({
            url: $("#EditComplianceOfficer").val(),
            type: 'post',
            headers: getRVToken(),
            cache: false,
            data: { "CompanyComplianceOfficerId": $(this).attr("CompanyComplianceOfficerId"), "acid": $("#UserAcion").val() },
            success: function (result) {
                var targetDiv = "#6_ComplianceOfficer";
                $(targetDiv).html(result);
                $(targetDiv).show();
            },
            error: function (jqXHR, textStatus, errorThrown) {

            }
        });
    });

    function demo(btnId) {

        $.ajax({
            url: $("#DeleteComplianceOfficer").val(),
            type: 'post',
            headers: getRVToken(),
            cache: false,
            data: { "CompanyComplianceOfficerId": btnId.attr("CompanyComplianceOfficerId"), "CompanyId": $("#CompanyId").val() },
            success: function (result) {
                showMessage("Data deleted Successfully", true);
                var targetDiv = "#6_ComplianceOfficer";

                //   $.get(url, null, function (result) {
                $(targetDiv).html(result);
                $(targetDiv).show();
                //  });
            },
            error: function (jqXHR, textStatus, errorThrown) {

            }
        });
        return true;
    }

    $(document).delegate('input:radio[name="PreClearanceImplementingCompany"]', 'click', function (event) {
        if (this.value == 'AllDemat') {
            $('div[id=tra_pclImp_DPBank]').fadeOut('fast');
        } else if (this.value == 'SelectedDemat') {
            $('div[id=tra_pclImp_DPBank]').fadeIn('fast');
        }
    });

    $(document).delegate('input:radio[name="PreClearanceNonImplementingCompany"]', 'click', function (event) {
        if (this.value == 'AllDemat') {
            $('div[id=tra_pclNImp_DPBank]').fadeOut('fast');
        } else if (this.value == 'SelectedDemat') {
            $('div[id=tra_pclNImp_DPBank]').fadeIn('fast');
        }
    });

    $(document).delegate('input:radio[name="InitialDisclosureTransaction"]', 'click', function (event) {
        if (this.value == 'AllDemat') {
            $('div[id=tra_ID_DPBank]').fadeOut('fast');
        } else if (this.value == 'SelectedDemat') {
            $('div[id=tra_ID_DPBank]').fadeIn('fast');
        }
    });

    $(document).delegate('input:radio[name="ContinuousDisclosureTransaction"]', 'click', function (event) {
        if (this.value == 'AllDemat') {
            $('div[id=tra_CD_DPBank]').fadeOut('fast');
        } else if (this.value == 'SelectedDemat') {
            $('div[id=tra_CD_DPBank]').fadeIn('fast');
        }
    });

    $(document).delegate('input:radio[name="PeriodEndDisclosureTransaction"]', 'click', function (event) {
        if (this.value == 'AllDemat') {
            $('div[id=tra_PED_DPBank]').fadeOut('fast');
        } else if (this.value == 'SelectedDemat') {
            $('div[id=tra_PED_DPBank]').fadeIn('fast');
        }
    });

    $("#SaveCompanyConfiguration").click(function () {
        var values = $("#frmCompanyConfiguration").serializeArray();
        values.push(
            {
                name: "acid", value: $("#UserAction").val()
            },
            {
                name: "compid", value: $('#CompanyId').val()
            },
            {
                name: "documentID", value: $("[name='[0].Value[0].DocumentId']").val()
            },
            {
                name: "formId", value: 19
            }
        );
        if ($("#frmCompanyConfiguration").valid()) {
            $.ajax({
                url: $("#SaveConfiguration").val(),
                type: 'post',
                headers: getRVToken(),
                cache: false,
                data: values,
                success: function (result) {
                    if (result.Message == "error")
                        showMessage($("#ConfigurationUpdateError").val(), false);
                    else
                        if (result.Message == "EmailError")
                            showMessage($("#ConfigurationUpdateUPSIError").val(), false);
                        else
                            if (result.Message == "RequiredEmailError")
                                showMessage($("#ConfigurationUpdateUPSIToError").val(), false);
                            else
                                showMessage($("#ConfigurationUpdateSucceess").val(), true);

                    var targetDiv = "#7_Configuration";
                    $(targetDiv).html(result);
                    $(targetDiv).show();
                    setDmatAccountlst();
                },
                error: function (jqXHR, textStatus, errorThrown) {

                }
            });
        }
    });

    $("#btnSavePersonalDetailsConfirmation").click(function () {
        var values = $("#frmPersonalDetailsConfirmation").serializeArray();
        values.push(
            {
                name: "acid", value: $("#UserAction").val()
            },
            {
                name: "compid", value: $('#CompanyId').val()
            },
            {
                name: "formId", value: 26
            }
        );
        if ($("#frmPersonalDetailsConfirmation").valid()) {
            $.ajax({
                url: $("#SaveConfirmation").val(),
                type: 'post',
                headers: getRVToken(),
                cache: false,
                data: values,
                success: function (result) {

                },
                error: function (jqXHR, textStatus, errorThrown) {

                }
            });
            showMessage($("#ConfirmationSucceess").val(), true);
        }
    });

});

function setDmatAccountlst() {
    if ($('input:radio[name="PreClearanceImplementingCompany"]:checked').val() == 'SelectedDemat') {
        $('div[id=tra_pclImp_DPBank]').fadeIn('fast');
    }
    if ($('input:radio[name="PreClearanceNonImplementingCompany"]:checked').val() == 'SelectedDemat') {
        $('div[id=tra_pclNImp_DPBank]').fadeIn('fast');
    }
    if ($('input:radio[name="InitialDisclosureTransaction"]:checked').val() == 'SelectedDemat') {
        $('div[id=tra_ID_DPBank]').fadeIn('fast');
    }
    if ($('input:radio[name="ContinuousDisclosureTransaction"]:checked').val() == 'SelectedDemat') {
        $('div[id=tra_CD_DPBank]').fadeIn('fast');
    }
    if ($('input:radio[name="PeriodEndDisclosureTransaction"]:checked').val() == 'SelectedDemat') {
        $('div[id=tra_PED_DPBank]').fadeIn('fast');
    }
    selectAllChk('tra_pclImp_DPBank');
    selectAllChk('tra_pclNImp_DPBank');
    selectAllChk('tra_ID_DPBank');
    selectAllChk('tra_CD_DPBank');
    selectAllChk('tra_PED_DPBank');

    selectAllUnChk('tra_pclImp_DPBank');
    selectAllUnChk('tra_pclNImp_DPBank');
    selectAllUnChk('tra_ID_DPBank');
    selectAllUnChk('tra_CD_DPBank');
    selectAllUnChk('tra_PED_DPBank');
}

function selectAllChk(tbl) {
    $('#' + tbl + '_All').click(function (e) {
        var table = $(e.target).closest('table');
        $('td input:checkbox', table).prop('checked', this.checked);
    });
}

function selectAllUnChk(tbl) {
    $('#DataTables_Table_' + tbl + ' tbody td input:checkbox').click(function (e) {
        if (!this.checked) {
            $('#' + tbl + '_All').prop('checked', false);
        } else {
            var all = true;
            $('#DataTables_Table_' + tbl + ' tbody td input:checkbox').each(function (e) {
                if (!this.checked) { all = false; }
            })
            if (all) { $('#' + tbl + '_All').prop('checked', true); }
        }
    });
}

function DisplayErrors(errors) {
    $("#divValidationSummary ul").html("");
    for (index in errors) {
        var obj = errors[index];
        for (i = 0; i < obj.length; i++) {
            var li = $("<li>");
            $(li).text(obj[i]);
            $("#divValidationSummary ul").append($(li));
        }
    }
    $('#divValidationSummary').slideDown(500);
    $('#messageSection div').not('#divValidationSummary,#mainMessageSection').remove();
    $("#divValidationSummary").removeClass("validation-summary-valid");
    $("#divValidationSummary").addClass("validation-summary-errors");
}

