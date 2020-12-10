
$(document).ready(function () {
    $(document).undelegate('#btnSave', 'click');

    $(document).delegate('#btnSave', 'click', function (event) {
        $('#TemplateForm').removeData('validator');
        $('#TemplateForm').removeData('unobtrusiveValidation');
        $("#TemplateForm").each(function () { $.data($(this)[0], 'validator', false); });
        $.validator.unobtrusive.parse("#TemplateForm");
        if ($("#TemplateForm").valid()) {
            if ($('#CommunicationModeCodeId').val() == 156002) {
                var sCommunicationFromEmial = $('#CommunicationFromEmail').val();
                $('#CommunicationFrom').val(sCommunicationFromEmial);
            }

            var modelDataJSON = '@Html.Raw(Json.Encode(Model))';
            if ($("#calledFrom").val() == "Communication") {
                $("#IsActive").removeAttr("disabled")
            }
            $.ajax({
                url: $("#SaveAction").val(),
                method: 'post',
                headers: getRVToken(),
                data: $("#TemplateForm").serialize(),//{ 'objTemplateMasterModel': modelDataJSON, "calledFrom": "Communication" },
                success: function (response) {
                    if (response.status) {
                        if ($("#calledFrom").val() == "CommunicationRule") {
                            if (response.IsActive) {
                                $("#cmu_grd_18008 option:last").after("<option value=" + "\"" + response.TemplateMasterId + "\"" + " " + "optionattribute=" + "\"" + response.CommunicationModeCodeId + "\"" + ">" + response.TemplateName + "</option>");
                                $("#DataTables_Table_0 tr select[name$='ModeCodeId']").each(function () {
                                    if ($(this).val() == response.CommunicationModeCodeId) {
                                        $(this).closest("tr").find("[name$='TemplateId'] option:last").after("<option value=" + "\"" + response.TemplateMasterId + "\"" + " " + "optionattribute=" + "\"" + response.CommunicationModeCodeId + "\"" + ">" + response.TemplateName + "</option>")
                                        $(this).closest("tr").find("[name$='TemplateId']").val(response.TemplateMasterId);
                                    }
                                });
                            }
                        }
                        else if ($("#calledFrom").val() == "Communication") {
                            $("#IsActive").attr("disabled", "disabled");
                            $("#cmu_grd_18008 option ").each(function () {
                                var value = $(this).attr('value');
                                var optionattribute = $(this).attr('optionattribute');
                                if (value == response.TemplateMasterId && optionattribute == response.CommunicationModeCodeId) {
                                    $(this).text(response.TemplateName);
                                }
                            });
                            $("#DataTables_Table_0 tr select[name$='ModeCodeId']").each(function () {
                                if ($(this).val() == response.CommunicationModeCodeId) {
                                    $(this).closest("tr").find("[name$='TemplateId'] :selected").text(response.TemplateName);
                                }
                            });
                        }
                        showMessage(response.Message, true);
                        setTimeout(function () {
                            $("#addtemplate").hide();
                            $("#myModal").hide();
                        }, 1000);
                        $("body").removeClass("noscroll");
                        $("body").removeClass("modal-open");
                    }
                    else {
                        DisplayErrors(response.error);
                    }
                },
                error: function (response) { }
            });
        }
    });

    $(document).undelegate('#CommunicationModeCodeId', 'change');
    $(document).delegate('#CommunicationModeCodeId', 'change', function (event) {
        var valCommunicationModeCodeId = $('#CommunicationModeCodeId').val();

        $('#btnSave').attr("disabled", "disabled");
        if (valCommunicationModeCodeId > 0) {
            $('#divPartialCreateViewTemplate').html('');

            $.ajax({
                url: $('#PartialCreateViewURL').val(),
                type: 'post',
                headers: getRVToken(),
                cache: false,
                data: { 'CommunicationMode_id': valCommunicationModeCodeId },
                success: function (response) {
                    $('#divPartialCreateViewTemplate').html(response);

                    $("form").removeData("validator");
                    $("form").removeData("unobtrusiveValidation");
                    $.validator.unobtrusive.parse("form");

                    $('#btnSave').removeAttr("disabled");
                    if (valCommunicationModeCodeId == 156002 && $('#TemplateMasterId').val() == 0)
                    {
                        $('#CommunicationFromEmail').val($('#hidImplementedCompanyEmailId').val());
                    }
                    else if ($('#TemplateMasterId').val() == 0) {
                        $('#CommunicationFrom').val('');
                    }
                },
                error: function (response) { }
            });
        } else {
            $('#divPartialCreateViewTemplate').empty();
        }
    });

});

function DisplayErrors(errors) {
    $('input').removeClass('input-validation-error');
    $('select').removeClass('input-validation-error');

    $('#messageSection div').not('#TemplateForm #divValidationSummaryModal,#mainMessageSection').remove();
    $("#TemplateForm #divValidationSummaryModal ul").html("");
    for (index in errors) {
        var obj = errors[index];
        for (i = 0; i < obj.length; i++) {
            var li = $("<li>");
            $(li).text(obj[i]);
            $("#TemplateForm  #divValidationSummaryModal ul").append($(li));
        }
    }

    $('#TemplateForm  #divValidationSummaryModal').slideDown(500);
    $('#messageSection div').not('#TemplateForm  #divValidationSummaryModal').remove();
    $("#TemplateForm  #divValidationSummaryModal").removeClass("validation-summary-valid");
    $("#TemplateForm  #divValidationSummaryModal").addClass("validation-summary-errors");

    setTimeout(function () {
        $("#TemplateForm #divValidationSummaryModal").removeClass("validation-summary-errors");
        $('#TemplateForm #divValidationSummaryModal').removeClass('alert-danger').fadeOut('slow');
        $("#TemplateForm #divValidationSummaryModal").addClass("alert-danger");
        $("#TemplateForm #divValidationSummaryModal").addClass("validation-summary-valid");

    }, 10000);
}