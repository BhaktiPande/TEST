
$(document).ready(function () {  

    $("#DesignationName").autocomplete({
        source: function (request, response) {
            var DesignationName = new Array();
            $.ajax({
                async: false,
                cache: false,
                url: $("#CorporateAutoComplete").val(),
                type: "POST",
                headers: getRVToken(),
                dataType: "json",
                data: { sSearchString: request.term },
                success: function (data) {
                    for (var i = 0; i < data.length ; i++) {
                        DesignationName[i] = { label: data[i].Value, Id: data[i].Key };
                    }
                    response(DesignationName);
                }                
            });       
  
        },
        messages: {
            noResults: '',
            results: function () { }
        }
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
                               function () { return false; });
        }   
    });

});

$(document).delegate("#corp_detail_save", "click", function () {
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