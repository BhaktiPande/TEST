$(document).ready(function () {

    $(document).delegate('#4', 'change', function (event) {
        var category = ($('#4').val() == null || $('#4').val() == "") ? 0 : $('#4').val();
        var edit = $('#edit').val();
        var all_sub_cat_list = $('#AllSubCatList').val();
        var acid = $('#SubCatAcid').val();
        if (category > 0 || (category == 0 && all_sub_cat_list == "True")) {
            $('#divsubcategory').html('');

            $.ajax({
                url: $('#SubCateogoryURL').val(),
                type: 'post',
                headers: getRVToken(),
                cache: false,
                data: { 'category_id': category, 'edit': edit, 'subcat': all_sub_cat_list, 'acid': acid },
                success: function (response) {
                    $('#divsubcategory').html(response);

                    $("form").removeData("validator");
                    $("form").removeData("unobtrusiveValidation");
                    $.validator.unobtrusive.parse("form");
                },
                error: function (response) { }
            });
        } else {
            $('#divsubcategory').empty();
        }
    });

    $(document).delegate('input:radio[name="WindowStatus"]', 'click', function (event) {
        if (this.value == 'Active' && $('#applicability').val() == 'False') {
            $('div[id=PolicyDocumentErrorMsg]').addClass('alert-danger').fadeIn('slow');
        }
    });

    //this is grid reset button click event to reset sub cat list
    $("#btnReset").click(function () {
        $("#4").change();
    });
});