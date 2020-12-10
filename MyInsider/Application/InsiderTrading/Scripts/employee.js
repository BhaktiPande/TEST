$(document).ready(function () {
    $.validator.setDefaults(':hidden, [readonly=readonly]');
    var lstUserSeparation = [];
    var count = 0;
    $(function () {
        $("#userInfoModel_Password").focus(function (pas) {
            $("#userInfoModel_Password").val("");
            $("#userInfoModel_Password").attr("Type", "Password");
        });
    });

    $(document).delegate("#btnInsider", "click", function () {
        $(".clsInsider").show();
    });

    var dataTable = null;
    var SaveCalled = false;
    $(document).delegate("#btnUploadSeparation", "click", function () {        
        dataTable = $("table[name='DatatableGrid'][gridtype='" + $(this).attr("gridtype") + "']").dataTable();
        SaveSeparation(dataTable);
        return false;
    });

    
    var pageChange = $("table[name='DatatableGrid'][gridtype='114019']").dataTable();
    
    $(document).delegate(".clkUserSeparation", "change", function () {
        var $this = $(this).closest("tr");
        $this.find(".chkUserRow").prop("checked", true);
    });


    $(document).delegate("#userInfoModel_Category", "change", function () {
        var CategoryId = $(this).val();
        var user_action = $('#partial_fetch').val();

        if (CategoryId == "") CategoryId = 0;
        $.ajax({
            url: $("#GetSubCategories").val(),
            type: 'post',
            headers: getRVToken(),
            data: { categoryID: CategoryId, acid: user_action },
            success: function (data) {
                $("#divSubCategories").html(data);
            },
            error: function (jqXHR, textStatus, errorThrown) {
                alert(errorThrown);
            }
        });
    });

    $(document).delegate("#userInfoModel_DesignationId", "change", function () {
        var DesignationId = $(this).val();
        var user_action = $('#partial_fetch').val();
        if (DesignationId == "") DesignationId = 0;
        $.ajax({
            url: $("#GetSubDesignation").val(),
            type: 'post',
            headers: getRVToken(),
            data: { DesignationID: DesignationId, acid: user_action },
            success: function (data) {
                $("#divSubDesignation").html(data);
            },
            error: function (jqXHR, textStatus, errorThrown) {
                alert(errorThrown);
            }
        });
    });

    $(document).delegate("#ConfirmDetails[type='button']", "click", function () {
        var isValidform = true;

        $("form [disabled='disabled']").each(function () {
            $(this).removeAttr("disabled");
            $(this).attr("readonly", "readonly");

            var validfrom = $(this).valid();
            if (!validfrom) {
                isValidform = false;
            }

            $(this).removeAttr("readonly");
            $(this).attr("disabled", "disabled");
        });

        if (isValidform) {
            AskConfirmation("Confirm Details", $('#confirm_msg').val(),
                               function () {
                                   $('#ConfirmDetails[type="button"]').attr("type", "submit");
                                   $('#ConfirmDetails').click();
                               },
                               function () {
                                   return false;
                               });
        }
    });
});


function SaveSeparation(dataTable) {
    
    if (!AskConfirmation
        ("User Saperation", "Are you sure you want to save the changes? Else changes will be discarded.",
        function () {
            var lst = new Array();
        var count = 0;
        $(".chkUserRow:checked").each(function () {
            var $this = $(this).closest("tr");
            var chkname = $this.find(".chkUserRow").attr("name");
            var chkvalue = $this.find(".chkUserRow").attr("data-details");
            $this.find(".inpUserSeparation").attr("data-val", true);
            $this.find(".inpUserSeparation").attr("required", "required");
            $this.find(".inpUserSeparation").attr("title", "Sepration date is required field for " + $this.find("td:eq(1)").text());
            var inpDateName = $this.find(".inpUserSeparation").attr("name");
            var inpDateValue = $($this).find(".inpUserSeparation").val();
            $this.find(".inpUserRowReason").attr("required", "required");
            $this.find(".inpUserRowReason").attr("title", "Reason is required field for " + $this.find("td:eq(1)").text());
            $this.find(".inpUserRowReason").attr("data-val", true);
            var inpReasonName = $($this).find(".inpUserRowReason").attr("name");
            var inpReasonValue = $($this).find(".inpUserRowReason").val();

            var json = {
            UserInfoID: chkvalue,
            DateOfSeparation: inpDateValue,
            ReasonForSeparation: inpReasonValue
        };

            lst.push(json);
        });
        var postData = { userInfoModel: lst, acid: $("#SeparationACID").val() };
        if ($("#frmUserSeparation").valid()) {
            $.ajax({
            url: $("#SaveUserSeparation").val(),
            type: 'post',
            headers: getRVToken(),
            dataType: 'json',
            data: JSON.stringify(postData),
            contentType: 'application/json; charset=utf-8',
            success: function (data) {
                    if (data.status == true) {
                        dataTable.fnDraw();
                        showMessage(data.Message, true);
                    }
                    else {
                         showMessage(data.Message, true);
                    }
        },
            error: function (jqXHR, textStatus, errorThrown) {
                    showMessage(errorThrown, true);
        }
        });
    }
        return true;
    },
        function () {
            return false;
        }
        )//AskConfirmation function
    )//If condition
    return false;
}

$(document).delegate("#emp_detail_save", "click", function () {
    if ($("#confirm_role").val() == "True" && $('#userInfoModel_SubmittedRole option:selected').length <= 0) {
        return confirm("Role has not been assigned to user - do you want to continue?");
    }

    var isValidform = true;

    $("form [disabled='disabled']").each(function () {
        $(this).removeAttr("disabled");
        $(this).attr("readonly", "readonly");
        
        var validfrom = $(this).valid();
        if (!validfrom) {
            isValidform = false;
        }

        $(this).removeAttr("readonly");
        $(this).attr("disabled", "disabled");
    });

    return isValidform;
});