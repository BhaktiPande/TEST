
$(document).ready(function () {

    $("#3").autocomplete({
        source: function (request, response) {
            var DesignationId = new Array();
            $.ajax({
                async: false,
                cache: false,
                url: $("#AutoComplete").val(),
                type: "POST",
                headers: getRVToken(),
                dataType: "json",
                data: { sSearchString: request.term },
                success: function (data) {
                    for (var i = 0; i < data.length ; i++) {
                        DesignationId[i] = { label: data[i].Value, Id: data[i].Key };
                    }
                    response(DesignationId);
                }
            });

        },
        messages: {
            noResults: '',
            results: function () { }
        }
    });



});