$(document).ready(function () {

    DesignationList = {};
    if ($('#DesignationAC').val() == 'yes') {
        $.ajax({
            url: $('#DesignantionListURL').val(),
            type: 'post',
            headers: getRVToken(),
            cache: false,
            data: { },
            success: function (response) {
                DesignationList = response;
                $("#5").autocomplete({ source: DesignationList });
            },
            error: function (response) { }
        });

        
    }

    $(document).delegate('#2', 'change', function (event) {
        if ($('#period_search').val() == 1) {
            $('#btnSearch').click();
        }
    });
});