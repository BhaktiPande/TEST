$(document).ready(function () {
    $(function () {
        $("Password").focus(function (pas) {
            $("#Password").val("");
            $("#Password").attr("Type", "Password");
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

$(document).delegate("#nonemp_detail_save", "click", function () {
    if ($("#confirm_role").val() == "True" && $('#SubmittedRole option:selected').length <= 0) {
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