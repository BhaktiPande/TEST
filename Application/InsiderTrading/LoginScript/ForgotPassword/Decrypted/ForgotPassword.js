$(document).ready(function () {
    $("#LoginID").val("");
    $("#EmailID").val("");

    $('input,textarea', 'form').blur(function () {

    });
    $("#LoginID").click(function () {
        $("#LoginID").val("");
        $("#LoginID").attr("type", "text");
    });
    $("#EmailID").click(function () {
        $("#EmailID").val("");
        $("#EmailID").attr("type", "text");
    });
    $("#LoginID,#EmailID").keydown(function (e) {
        if (e.keyCode == 13) {
            $("button[type='submit'].btn-success").focus();
        }
    });
    $("#LoginID").blur(function () {
        if ($("#LoginID").val() != "") {
            $("#LoginID").val(encrypt($("#LoginID").val()));
            $("#LoginID").attr("type", "password");
        }
    });
    $("#EmailID").blur(function () {
        if ($("#EmailID").val() != "") {
            $("#EmailID").val(encrypt($("#EmailID").val()));
            $("#EmailID").attr("type", "password");
        }
    });
    $("form").submit(function () {
        $("#LoginID").val($("#LoginID").val());
        $("#EmailID").val($("#EmailID").val());
    });
});
