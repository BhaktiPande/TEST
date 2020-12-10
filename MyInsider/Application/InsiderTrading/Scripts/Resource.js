$(document).ready(function () {
    var dataTable = null;

    $('input,textarea', 'form').blur(function () {
        $(this).valid();

        $("#divValidationSummaryModal").removeClass("validation-summary-errors");
        $("#divValidationSummaryModal").addClass("validation-summary-valid");

    });

   
    $(document).delegate('#1', 'change', function (event) {
        var URL = $('#ModuleCodeChange').val();
        var ChildValue = $("#1").attr("SelectedChild");
        if (ChildValue == undefined || ChildValue == '')
            ChildValue = 0;
        var a = $('#1').val();
        if (a > 0) {
            $('#divParentCodeID').html("");
            $.ajax({
                url: $("#ModuleCodeChange").val(),
                type: 'post',
                headers: getRVToken(),
                cache: false,
                data: { "ParentId": a, "acid":$("#ResourceUserAction").val(), "SelectedId": ChildValue },
                success: function (result) {
                    $('#divParentCodeID').html(result);
                },
                error: function (result) {
                }
            });
        }
        else {
            $('#divParentCodeID').empty();
        }


    });

    $(document).delegate("#btnSaveResourcedetails", "click", function () {
        dataTable = $("table[name='DatatableGrid'][gridtype='" + $(this).attr("gridtype") + "']").dataTable();

   
        $('#frmResourceDetails1').removeData('validator');
        $('#frmResourceDetails1').removeData('unobtrusiveValidation');
        $("#frmResourceDetails1").each(function () { $.data($(this)[0], 'validator', false); });
        $.validator.unobtrusive.parse("#frmResourceDetails1");
        var values = $("#frmResourceDetails1").serializeArray();
        values.push({            
            name: "formId",
            value: 17
        });


        if ($("#frmResourceDetails1").valid()) {
            $.ajax({
                url: $("#UpdateResorce").val(),
                type: 'post',
                headers: getRVToken(),
                async:false,
                data: values,
                success: function (data) {
                    if (data.status) {
                        showMessage(data.Message, true);
                        $('#ResourceModal').modal('hide');
                        $("#divResourceDetailsModal").hide();
                        //dataTable.fnDraw();
                    }
                },
                error: function (data) {
                    DisplayErrors(data.error);
                }
            });
        }
        return false;
    });


    $("[name=DatatableGrid][gridtype=114018]").undelegate(".btnEditResource", "click");

   // $(document).delegate(".btnEditResource", "click", function () {
    $("[name=DatatableGrid][gridtype=114018]").delegate(".btnEditResource", "click", function (e) {
  
        $.ajax({
            url: $("#Edit").val(),
            type: 'post',
            headers: getRVToken(),
            data: { "ResourceKey": $(this).attr("ResourceKey") },
            success: function (data) {
                $("#divResourceDetailsModal").html(data);
                $("#divResourceDetailsModal").show();
                $('#ResourceModal').modal('show');
            },
            error: function (jqXHR, textStatus, errorThrown) {
                alert(errorThrown);
            }
        });
    });
    

 


});