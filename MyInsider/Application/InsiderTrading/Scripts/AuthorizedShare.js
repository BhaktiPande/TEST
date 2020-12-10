$(document).ready(function () {
    $('.input-append').datepicker(
   {
       format: "dd/mm/yyyy",
       orientation: "auto",
   }).on("change", function () {
       $('.datepicker').hide();
   });


  
});

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