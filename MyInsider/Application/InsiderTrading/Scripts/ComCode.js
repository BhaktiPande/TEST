
$(document).ready(function () {

    var sCalledFrom = "Details";

    $(document).undelegate('#btnSave', 'click');

    $(document).delegate('#btnSave', 'click', function (event) {
        $('#ComCodeForm').removeData('validator');
        $('#ComCodeForm').removeData('unobtrusiveValidation');
        $("#ComCodeForm").each(function () { $.data($(this)[0], 'validator', false); });
        $.validator.unobtrusive.parse("#ComCodeForm");
        if ($("#ComCodeForm").valid()) {
            $.ajax({
                url: $("#SaveAction").val(),
                method: 'post',
                headers: getRVToken(),
                data: $("#ComCodeForm").serialize(),
                success: function (response) {
                    if (response.status) {
                        if ( response.IsVisible) {
                                $("#4 option:last").after("<option value=" + "\"" + response.CodeID + "\"" + ">" + response.DisplayCode + "</option>");                               
                            }
                        
                        showMessage(response.Message, true);
                        setTimeout(function () {
                            $("#addCode").hide();
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
   
    $(function () {
        if ($('#CalledFrom').val() == "SaveCancleDetails") {
            var CodeGroupId = $("#ddlCodeGroupId").val();
            $('#1').val(CodeGroupId);         
                var res = CodeGroupId.split("-");
                if (res[1] != 0) {
                    $('#SCDetails').val("PartialIndex");
                }
                else {
                    $('#SCDetails').val("temp");
                    $('#2').val("");
                }
                var pc = $('#pcid').val();
                if(pc == "" || pc == null)
                {
                    pc = 0;
                }
                $('#divParentCodeName').html("");
                
                var acid = $('#v_acid').val();

                $.ajax({
                    url: $("#PopulateComboOnChange").val(),
                    type: 'post',
                    headers: getRVToken(),
                    cache: false,
                    async: false,
                    data: { "CodeId": $("#ddlCodeGroupId").val(), "CalledFrom": "List", "ParentId": pc, "acid": acid},
                    success: function (result) {
                        $('#divParentCodeName').html(result);
                    },
                    error: function (result) {
                    }

                });              
        }

    });
    
    $(function () {
        if ($('#SCDetails').val() == "PartialIndex") {
            var pcid = $("#pcid").val();
            $("#DefaultView").html("");
            var acid = $('#v_acid').val();
            //$('#2').val(pcid);
            $.ajax({
                url: $("#ParentPopulateComboOnChange").val(),
                type: 'post',
                headers: getRVToken(),
                cache: false,
                data: { "CodeId": $("#CodeGroupId").val(), "CalledFrom": "List", "ParentId": $('#pcid').val(), "acid": acid },
                success: function (result) {
                    $('#2').val(pcid);
                    $('#DefaultView').empty();
                    $('#ParentGridView').html(result);
                },
                error: function (result) {
                }
            });
        }
    });

    var sCalledFrom = "List";
    //$('#1').change(function () {      
    $(document).delegate('#ddlCodeGroupId', 'change', function (event) {
        var URL = $('#PopulateComboOnChange').val();
        var CodeGroupval = $("#ddlCodeGroupId").val();
        $('#1').val(CodeGroupval);
        $('#2').val("");
        $('#divParentCodeName').html("");
        if (CodeGroupval != '0-0')
        {
            var acid = $('#v_acid').val();

            $.ajax({
                url: $("#PopulateComboOnChange").val(),
                type: 'post',
                headers: getRVToken(),
                cache: false,
                async: false,
                data: { "CodeId": $("#ddlCodeGroupId").val(), "CalledFrom": sCalledFrom, "ParentId": 0, "acid": acid },
                success: function (result) {
                    $('#divParentCodeName').html(result);
                },
                error: function (result) {
                }
            });
        }
        
        return false;
    });

    // $('#2').change(function () {
    $(document).delegate('#ddlParentCodeId', 'change', function (event) {
        var URL = $('#ParentPopulateComboOnChange').val();
        var ParentCodeval = $("#ddlParentCodeId").val();
        $('#2').val(ParentCodeval);
        $('#DefaultView').empty();
        var acid = $('#v_acid').val();

        $.ajax({
            url: $("#ParentPopulateComboOnChange").val(),
            type: 'post',
            headers: getRVToken(),
            cache: false,
            data: { "CodeId": $("#ddlCodeGroupId").val(), "CalledFrom": sCalledFrom, "ParentId": $('#ddlParentCodeId').val(), "acid": acid },
            success: function (result) {
                $('#ParentGridView').html(result);
            },
            error: function (result) {
            }
        });
       
       
        return false;
    });   

    $(document).delegate('#btnAddNew', 'click', function (event) {
        var CodeGroupID = $('#1').val();
        var ParentCodeID = $('#2').val();
        if (ParentCodeID == null || ParentCodeID == 0)
        {
            ParentCodeID = 0;
        }
        var acid = $('#c_acid').val();
        window.location.href = $("#ComCodeCrete").val() + "?CodeGroupId=" + CodeGroupID + '&ParentCodeId=' + ParentCodeID + '&acid=' + acid;
    });

    
    $('#DeleteComCode').click(function () {
        ShowDeleteConfirm("WARNING", "Are you sure want to delete this code.?", $("#DeleteCode"));
    });

});

function DisplayErrors(errors) {
    $('input').removeClass('input-validation-error');
    $('select').removeClass('input-validation-error');

    $('#messageSection div').not('#ComCodeForm #divValidationSummaryModal,#mainMessageSection').remove();
    $("#ComCodeForm #divValidationSummaryModal ul").html("");
    for (index in errors) {
        var obj = errors[index];
        for (i = 0; i < obj.length; i++) {
            var li = $("<li>");
            $(li).text(obj[i]);
            $("#ComCodeForm  #divValidationSummaryModal ul").append($(li));
        }
    }

    $('#ComCodeForm  #divValidationSummaryModal').slideDown(500);
    $('#messageSection div').not('#ComCodeForm  #divValidationSummaryModal').remove();
    $("#ComCodeForm  #divValidationSummaryModal").removeClass("validation-summary-valid");
    $("#ComCodeForm  #divValidationSummaryModal").addClass("validation-summary-errors");

    setTimeout(function () {
        $("#ComCodeForm #divValidationSummaryModal").removeClass("validation-summary-errors");
        $('#ComCodeForm #divValidationSummaryModal').removeClass('alert-danger').fadeOut('slow');
        $("#ComCodeForm #divValidationSummaryModal").addClass("alert-danger");
        $("#ComCodeForm #divValidationSummaryModal").addClass("validation-summary-valid");

    }, 10000);
}