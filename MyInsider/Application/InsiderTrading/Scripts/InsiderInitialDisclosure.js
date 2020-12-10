$(document).ready(function () {

    $('#chkAccept').click(function (event) {
        if ($('#chkAccept').is(':checked'))
        {
            $('#btnAccept').removeAttr("disabled", "disabled");
        }
        else
        {
            $('#btnAccept').attr("disabled", "disabled");
        }
    })


});