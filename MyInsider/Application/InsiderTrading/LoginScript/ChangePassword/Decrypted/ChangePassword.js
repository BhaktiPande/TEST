$(document).ready(function () {
    $("#OldPassword").val("");
    $("#NewPassword").val("");
    $("#ConfirmNewPassword").val("");

    $('input,textarea', 'form').blur(function () {

    });
    $("#OldPassword").click(function () {
        $("#OldPassword").val("");
    });
    $("#NewPassword").click(function () {
        $("#NewPassword").val("");
    });
    $("#ConfirmNewPassword").click(function () {
        $("#ConfirmNewPassword").val("");
    });
    $("#OldPassword,#NewPassword,#ConfirmNewPassword").keydown(function (e) {
        if (e.keyCode == 13) {
            $("button[type='submit'].btn-success").focus();
        }
    });
    $("#OldPassword").blur(function () {
        if ($("#OldPassword").val() != "") {
            $("#OldPassword").val(encrypt($("#OldPassword").val()));
        }
    });
    $("#NewPassword").blur(function () {
        if ($("#NewPassword").val() != "") {
            $("#NewPassword").val(encrypt($("#NewPassword").val()));
        }
    });
    $("#ConfirmNewPassword").blur(function () {
        if ($("#ConfirmNewPassword").val() != "") {
            $("#ConfirmNewPassword").val(encrypt($("#ConfirmNewPassword").val()));
        }
    });
    $("form").submit(function () {
        $("#OldPassword").val($("#OldPassword").val());
        $("#NewPassword").val($("#NewPassword").val());
        $("#ConfirmNewPassword").val($("#ConfirmNewPassword").val());
    });
});
